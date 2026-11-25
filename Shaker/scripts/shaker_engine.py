#!/usr/bin/env python3
"""shaker_engine.py — generates the gen~ GenExpr code for Shaker: Perry Cook's PhISEM (Physically Informed Stochastic Event
Modeling; "Physically Informed Sonic Modeling (PhISM)", Computer Music Journal 21(3), 1997; STK Shakers.cpp) as five instruments:
maraca, cabasa, shekere, ganza, egg shaker. See docs/SPEC.md.

The model, per sample (STK's, with the constants refitted to recordings, see tests/fit_refs.js):
  * a stroke adds energy: an impulse of area vel (back strokes: x Back) through two one-poles (a gamma(2) bump, `shk` ms), so the
    shake takes a few ms to build; the system energy E then decays exponentially (`sys` ms), the shaker's total energy dissipating.
    The impulse is scaled so E peaks at vel (area x (1 + 2.7 shk / sys), exact when shk = sys), whatever Shake and Damping are. Strokes overlap by plain addition (it is all linear).
  * beads collide at random: each sample a collision happens with probability rate x Beads x (1 - sp + sp E): more energy, more
    collisions (sp = 0 is STK's constant rate; the real tails get sparse, so sp > 0).
  * each collision adds E (x a random 0.2..1 strength) to the sound level; the sound level decays by `sdec` ms (x Rattle's
    4^(+-1) range) and multiplies noise. Per-grain amplitude is scaled so the sound level's mean square stays put: x = rate x Beads x grain length (s), mean square = 0.36 x^2 + 0.2067 x (overlapping grains add as amplitudes, not powers: a plain 1/sqrt(x) made Beads 400 % +5 dB louder), so Beads and Rattle
    change the texture (dense hiss to separate clicks), not the loudness.
  * that noise goes through three parallel band-pass resonances (f Hz, Q, gain), shifted together by Tone semitones.

Hits arrive as a counter (tr, bumped by shaker_midi.js) with velocity vl and direction dir (0 forward, 1 back); a change in the
counter is a stroke (a gate edge could be lost when two notes land in one audio block).

First-compile trap (playbook sec. 4): no ternary / max / min / clamp on an expression that depends only on Params. Types are
selected arithmetically; the only clamps work on signals.

`python3 scripts/shaker_engine.py --code` prints the code. SHAKER_FIT=1 prints a variant whose type constants are Params
(c_rate, c_sp, c_sdec, c_sys, c_shk, c_f0, c_q0, c_g0, ... instead of the five tables) for tests/fit_types.js.
"""
import os
import sys

NAMES = ["Maraca", "Cabasa", "Shekere", "Ganza", "Egg"]   # ASCII keys (code, tests); the menu spells Ganz\u00e1
MENU = ["Maraca", "Cabasa", "Shekere", "Ganzá", "Egg"]

# per type: hp / hq (two identical 2-pole high-passes (4th order) before the resonances: the real strokes have almost nothing under 1-2 kHz), rate (collisions/s at full energy, Beads 100 %), sp (how much the rate follows the energy), sdec (grain length, ms),
# sys (energy decay time constant, ms), shk (build-up time constant, ms), then three resonances (f Hz, Q, gain).
# Fitted to Ableton's Core Library one-shots by tests/fit_types.js; see README "Fitted to recordings". Shekere's sys / shk are a hand-set
# compromise after the fit (the fit gave sys 59 / shk 13 ms: rise 40 ms against the seed-pod reference's 137; 30 / 45 gives rise 72, t20 116 vs 78).
TYPES = {
    "Maraca": dict(rate=2456, sp=0.2382, sdec=1.639, sys=19.87, shk=4.866, hp=1231, hq=1.446, res=[(6131, 15.21, 0.227), (9107, 1.162, 0.1437), (4178, 30, 0.8086)]),
    "Cabasa": dict(rate=15750, sp=0.2419, sdec=0.9061, sys=12.84, shk=6.902, hp=300, hq=0.7748, res=[(10000, 0.8343, 1.168), (7635, 2.029, 0.08303), (4115, 9.44, 0.9173)]),
    "Shekere": dict(rate=2083, sp=0.6663, sdec=1.344, sys=30, shk=45, hp=2436, hq=0.8049, res=[(10000, 6.79, 0.8993), (6370, 4.175, 0.7235), (232.8, 0.6405, 0)]),
    "Ganza": dict(rate=16000, sp=0.1021, sdec=2.719, sys=12.51, shk=13.3, hp=670, hq=0.4004, res=[(6691, 2.045, 0.7033), (10000, 4.921, 1.012), (604.3, 6.823, 0.3929)]),
    "Egg": dict(rate=1153, sp=0.002234, sdec=3.215, sys=13.55, shk=2.285, hp=5924, hq=0.5622, res=[(1576, 0.8421, 0.1661), (10000, 1.741, 0.2014), (157.6, 30, 0.2912)]),
}
# per-type level trim: 10 ms RMS peak of a vel-1 forward stroke at Level 0 dB = TARGET (tests/calibrate.js prints these)
CAL = {"Maraca": 3.4875, "Cabasa": 0.5991, "Shekere": 1.049, "Ganza": 0.972, "Egg": 7.8502}
TARGET = 0.25
BACK_SHK = 0.25   # a back stroke builds this much slower (assumption: the beads travel back against the hand's slower return)

PARAMS = [("type", 0), ("beads", 1), ("damp", 1), ("shake", 1), ("tone", 0), ("rattle", 0.5), ("back", 0.7), ("vol", -6), ("pan", 0),
          ("tr", 0), ("vl", 0), ("dir", 0)]

FIELDS = ["rate", "sp", "sdec", "sys", "shk", "hp", "hq"] + [f"{a}{k}" for k in range(3) for a in "fqg"]


def f(x):   # plain decimals only: exponent literals break the codebox
    s = f"{x:.10f}".rstrip("0")
    return s + "0" if s.endswith(".") else s


def flat(t, name):
    d = TYPES[name]
    v = {k: d[k] for k in ("rate", "sp", "sdec", "sys", "shk", "hp", "hq")}
    for k, (fr, q, g) in enumerate(d["res"]):
        v[f"f{k}"], v[f"q{k}"], v[f"g{k}"] = fr, q, g
    return v


def code(fit=None):
    fit = bool(os.environ.get("SHAKER_FIT")) if fit is None else fit
    L = ["// Shaker engine. GENERATED by scripts/shaker_engine.py: do not edit."]
    for n, d in PARAMS:
        L.append(f"Param {n}({f(d)});")
    if fit:
        for fld in FIELDS:
            L.append(f"Param c_{fld}({f(flat(None, 'Maraca')[fld])});")
        L.append("Param c_cal(1);")
    for n in ("ltr", "y1", "y2", "en", "snd", "dirs", "hx1", "hx2", "hz1", "hz2", "jx1", "jx2", "jz1", "jz2"):
        L.append(f"History {n}(0);")
    for k in range(3):
        for n in ("x1", "x2", "z1", "z2"):
            L.append(f"History r{k}{n}(0);")
    if not fit:
        for k in range(5):
            L.append(f"t{k} = abs(type - {k}) < 0.5;")

    def sel(fld):
        if fit:
            return f"c_{fld}"
        return "(" + " + ".join(f"t{k} * {f(flat(None, n)[fld])}" for k, n in enumerate(NAMES)) + ")"
    cal = "c_cal" if fit else "(" + " + ".join(f"t{k} * {f(CAL[n])}" for k, n in enumerate(NAMES)) + ")"
    L.append(f"""
newn = tr != ltr;
ltr = tr;
isb = dir > 0.5;
dirs = newn * isb + (1 - newn) * dirs;
amp = vl * newn * (isb * back + (1 - isb));
msr = samplerate * 0.001;
ts = {sel('sys')} * damp * msr;
ash = {sel('shk')} * shake * (1 + {f(BACK_SHK)} * dirs) * msr;
dE = exp(-1 / ts);
ca = 1 - exp(-1 / ash);
y1 = y1 + ca * (amp * (1 + 2.7 * ash / ts) - y1);
y2 = y2 + ca * (y1 - y2);
en = fixdenorm(en * dE + y2);
en = en * (en > 0.000000001);

// collisions: the beads strike at random, more often the more energy there is
rt = {sel('rate')} * beads;
sp = {sel('sp')};
pe = en * (en < 1) + (en >= 1);
p = rt / samplerate * (1 - sp + sp * pe);
hit = abs(noise()) < p;
gl = {sel('sdec')} * pow(4, (rattle - 0.5) * 2);
sd = exp(-1 / (gl * msr));
gx = rt * gl * 0.001;
gr = {cal} / sqrt(0.36 * gx * gx + 0.2067 * gx);
snd = fixdenorm(snd * sd + hit * en * gr * (0.2 + 0.8 * abs(noise())));
snd = snd * (snd > 0.000000001);
raw = snd * noise();

// the 4th-order high-pass, then three band-pass resonances (RBJ, constant 0 dB peak), shifted together by Tone
ks = pow(2, tone / 12);
fmx = 0.42 * samplerate;
fh = {sel('hp')} * ks;
fh = fh / pow(1 + pow(fh / fmx, 4), 0.25);
wh = twopi * fh / samplerate;
alh = sin(wh) / (2 * {sel('hq')});
iah = 1 / (1 + alh);
chh = cos(wh);
hb = (1 + chh) * 0.5 * iah;
h1 = hb * (raw - 2 * hx1 + hx2) + 2 * chh * iah * hz1 - (1 - alh) * iah * hz2;
hx2 = hx1;
hx1 = raw;
hz2 = fixdenorm(hz1);
hz1 = fixdenorm(h1);
inp = hb * (h1 - 2 * jx1 + jx2) + 2 * chh * iah * jz1 - (1 - alh) * iah * jz2;
jx2 = jx1;
jx1 = h1;
jz2 = fixdenorm(jz1);
jz1 = fixdenorm(inp);
acc = 0;""")
    for k in range(3):
        L.append(f"""fr{k} = {sel(f'f{k}')} * ks;
fr{k} = fr{k} / pow(1 + pow(fr{k} / fmx, 4), 0.25);
w{k} = twopi * fr{k} / samplerate;
al{k} = sin(w{k}) / (2 * {sel(f'q{k}')});
ia{k} = 1 / (1 + al{k});
b{k} = al{k} * ia{k};
c1{k} = -2 * cos(w{k}) * ia{k};
c2{k} = (1 - al{k}) * ia{k};
yy{k} = b{k} * (inp - r{k}x2) - c1{k} * r{k}z1 - c2{k} * r{k}z2;
r{k}x2 = r{k}x1;
r{k}x1 = inp;
r{k}z2 = fixdenorm(r{k}z1);
r{k}z1 = fixdenorm(yy{k});
acc = acc + yy{k} * {sel(f'g{k}')};""")
    L.append(f"""
acc = acc * dbtoa(vol);
pa = (pan + 1) * 0.25 * pi;
out1 = {'acc * cos(pa)' if fit else 'clamp(acc * cos(pa), -1, 1)'};
out2 = {'acc * sin(pa)' if fit else 'clamp(acc * sin(pa), -1, 1)'};
""")
    return "\n".join(L)


if __name__ == "__main__":
    if "--code" in sys.argv:
        print(code())
