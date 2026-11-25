#!/usr/bin/env python3
"""ganza_engine.py — generates the gen~ GenExpr code for Ganza: Perry Cook's PhISEM (Physically Informed Stochastic Event
Modeling; "Physically Informed Sonic Modeling (PhISM)", Computer Music Journal 21(3), 1997; STK Shakers.cpp) as a samba ganzá
(a metal tube of beads/shot played in back-and-forth strokes) and a chocalho (a frame of platinelas / jingles). Forked from Shaker
(Direction, Back, Roll) and Caxixi (the two-slope energy store). See docs/SPEC.md.

The model, per sample (STK's, with the constants refitted to recordings, see tests/fit_refs.js):
  * a stroke adds energy: an impulse of area vel (back strokes x Back x bk, accents x ACC_GAIN) through two one-poles (a gamma(2) bump, `shk` ms;
    back strokes build bks x slower and decay bkd x slower), so the shake takes a few ms to build; the system energy E then decays exponentially
    (`sys` ms). The impulse is scaled so E peaks at vel (area x (1 + 2.7 shk / sys), exact when shk = sys). Strokes overlap by plain addition.
  * a second, slower energy store (gs, ss) is fed by the same stroke: the tail between 16th strokes is a shelf, and real tails are two-slope.
  * beads collide at random: each sample a collision happens with probability rate x Beads x (1 - sp + sp E).
  * each collision adds E (x a random 0.2..1 strength) to the sound level; the sound level decays by `sdec` ms (x Rattle's
    4^(+-1) range) and multiplies noise. Per-grain amplitude is scaled so the sound level's mean square stays put (x = rate x Beads x grain length (s),
    mean square = 0.36 x^2 + 0.2067 x): Beads and Rattle change the texture, not the loudness.
  * the END-CAP IMPACT: a forward stroke ends with the beads hitting the cap: a short wide-band click (`clk` x the stroke's velocity, decays `cdec` ms,
    x ACC_CLK on an accent) added to the sound level's noise, so it also rings the shell. Back strokes have none (the references' back strokes
    are the rounded, slower ones).
  * that noise goes through a 4th-order high-pass and three parallel band-pass resonances (f Hz, Q, gain), shifted together by Tone semitones;
    two narrow RING modes (the ganzá's tube wall, the chocalho's platinelas: f, Q, gain) are fed by the same filtered noise.

Hits arrive as a counter (tr, bumped by ganza_midi.js) with velocity vl, direction dir (0 forward, 1 back) and acc (1 = accent); a change in the
counter is a stroke (a gate edge could be lost when two notes land in one audio block).

First-compile trap (playbook sec. 4): no ternary / max / min / clamp on an expression that depends only on Params. Types are
selected arithmetically; the only clamps work on signals.

`python3 scripts/ganza_engine.py --code` prints the code. GANZA_FIT=1 prints a variant whose fitted type constants are Params
(c_rate, c_sp, ..., see FIT_FIELDS) for tests/fit_types.js; every other constant still comes from the Type table (the fit sets `type`).
"""
import os
import sys

NAMES = ["Ganza", "Chocalho"]   # ASCII keys (code, tests); the menu spells Ganzá
MENU = ["Ganzá", "Chocalho"]
# Stroke menu (the js; index-stable for Drum Rack pads): Key = note parity, Alternate = flip every note, Forward, Back, Accent
STROKES = ["Key", "Alternate", "Forward", "Back", "Accent"]

# per type: hp / hq (two identical 2-pole high-passes (4th order) before the resonances), rate (collisions/s at full energy, Beads 100 %), sp (how much the rate follows the energy),
# sdec (grain length, ms), sys (energy decay time constant, ms), shk (build-up time constant, ms), gs / ss (the slow tail: its share of the peak energy, its decay in ms),
# res = three resonances (f Hz, Q, gain); clk / cdec (the end-cap click: gain, decay ms); rings = two narrow ring modes (f Hz, Q, gain);
# bk (a back stroke's level re forward, measured), bks / bkd (a back stroke builds / decays that much slower: x (1 + b)), bkt (a back stroke's Tone shift, semitones).
TYPES = {
    "Ganza": dict(rate=16560.0, sp=0.57, sdec=1.339, sys=9.885, shk=12.83, gs=0.3, ss=150, hp=315.8, hq=0.4129,
                  res=[(10000.0, 1.767, 0.02217), (10000.0, 1.678, 0.9914), (1918.0, 0.7916, 0.08463)],
                  clk=1.5, cdec=1.5, rings=[(4460, 40, 0.35), (8960, 40, 0.5)], bk=0.62, bks=0.25, bkd=0.7, bkt=-1.2),
    "Chocalho": dict(rate=2294.0, sp=0.3831, sdec=3.501, sys=24.68, shk=14.91, gs=0.1845, ss=156.2, hp=849.6, hq=0.4,
                     res=[(5381.0, 3.0, 2.272), (10000.0, 0.407, 0.6238), (9361.0, 3.0, 1.703)],
                     clk=0.0, cdec=1.5, rings=[(4230, 40, 2.8), (5860, 40, 2.2)], bk=0.466, bks=0.42, bkd=0.38, bkt=1.3),
}
# per-type level trim: 10 ms RMS peak of a vel-1 forward stroke at Level 0 dB = TARGET (tests/calibrate.js prints these)
CAL = {"Ganza": 0.8097, "Chocalho": 0.29}
TARGET = 0.25
ACC_GAIN = 1.6    # an accent is this much louder than a forward stroke (arroz: the loudest strokes, ~+4 dB)
ACC_CLK = 2.5     # and its end-cap click is this much harder

PARAMS = [("type", 0), ("beads", 1), ("damp", 1), ("shake", 1), ("tone", 0), ("rattle", 0.5), ("back", 1), ("vol", -6), ("pan", 0),
          ("tr", 0), ("vl", 0), ("dir", 0), ("acc", 0)]

FIT_FIELDS = ["rate", "sp", "sdec", "sys", "shk", "gs", "ss", "hp", "hq"] + [f"{a}{k}" for k in range(3) for a in "fqg"]
# constants that are in the Type table but not fitted by tests/fit_types.js
FIXED_FIELDS = ["clk", "cdec", "bk", "bks", "bkd", "bkt"] + [f"{a}{k}" for k in range(2) for a in ("rf", "rq", "rg")]


def f(x):   # plain decimals only: exponent literals break the codebox
    s = f"{x:.10f}".rstrip("0")
    return s + "0" if s.endswith(".") else s


def flat(t, name):
    d = TYPES[name]
    v = {k: d[k] for k in ("rate", "sp", "sdec", "sys", "shk", "gs", "ss", "hp", "hq", "clk", "cdec", "bk", "bks", "bkd", "bkt")}
    for k, (fr, q, g) in enumerate(d["res"]):
        v[f"f{k}"], v[f"q{k}"], v[f"g{k}"] = fr, q, g
    for k, (fr, q, g) in enumerate(d["rings"]):
        v[f"rf{k}"], v[f"rq{k}"], v[f"rg{k}"] = fr, q, g
    return v


def code(fit=None):
    fit = bool(os.environ.get("GANZA_FIT")) if fit is None else fit
    L = ["// Ganza engine. GENERATED by scripts/ganza_engine.py: do not edit."]
    for n, d in PARAMS:
        L.append(f"Param {n}({f(d)});")
    if fit:
        for fld in FIT_FIELDS:
            L.append(f"Param c_{fld}({f(flat(None, NAMES[0])[fld])});")
        L.append("Param c_cal(1);")
    for n in ("ltr", "y1", "y2", "en", "ens", "snd", "ck", "dirs", "accs", "hx1", "hx2", "hz1", "hz2", "jx1", "jx2", "jz1", "jz2"):
        L.append(f"History {n}(0);")
    for k in range(3):
        for n in ("x1", "x2", "z1", "z2"):
            L.append(f"History r{k}{n}(0);")
    for k in range(2):
        for n in ("x1", "x2", "z1", "z2"):
            L.append(f"History m{k}{n}(0);")
    for k in range(len(NAMES)):
        L.append(f"t{k} = abs(type - {k}) < 0.5;")

    def sel(fld):
        if fit and fld in FIT_FIELDS:
            return f"c_{fld}"
        return "(" + " + ".join(f"t{k} * {f(flat(None, n)[fld])}" for k, n in enumerate(NAMES)) + ")"
    cal = "c_cal" if fit else "(" + " + ".join(f"t{k} * {f(CAL[n])}" for k, n in enumerate(NAMES)) + ")"
    L.append(f"""
newn = tr != ltr;
ltr = tr;
isb = dir > 0.5;
dirs = newn * isb + (1 - newn) * dirs;
accs = newn * (acc > 0.5) + (1 - newn) * accs;
amp = vl * newn * (isb * back * {sel('bk')} + (1 - isb)) * (1 + (acc > 0.5) * {f(ACC_GAIN - 1)});
msr = samplerate * 0.001;
ts = {sel('sys')} * damp * (1 + {sel('bkd')} * dirs) * msr;
ash = {sel('shk')} * shake * (1 + {sel('bks')} * dirs) * msr;
dE = exp(-1 / ts);
ca = 1 - exp(-1 / ash);
y1 = y1 + ca * (amp * (1 + 2.7 * ash / ts) - y1);
y2 = y2 + ca * (y1 - y2);
en = fixdenorm(en * dE + y2);
en = en * (en > 0.000000001);
// the slow tail: a second, slower energy store fed by the same stroke (gs: its share of the peak energy, ss: its decay in ms)
dS = exp(-1 / ({sel('ss')} * damp * msr));
ens = fixdenorm(ens * dS + {sel('gs')} * y2 * ts / ({sel('ss')} * damp * msr));
ens = ens * (ens > 0.000001);
et = en + ens;

// collisions: the beads strike at random, more often the more energy there is
rt = {sel('rate')} * beads;
sp = {sel('sp')};
pe = et * (et < 1) + (et >= 1);
p = rt / samplerate * (1 - sp + sp * pe);
hit = abs(noise()) < p;
gl = {sel('sdec')} * pow(4, (rattle - 0.5) * 2);
sd = exp(-1 / (gl * msr));
gx = rt * gl * 0.001;
gr = {cal} / sqrt(0.36 * gx * gx + 0.2067 * gx);
snd = fixdenorm(snd * sd + hit * et * gr * (0.2 + 0.8 * abs(noise())));
snd = snd * (snd > 0.000000001);
// the end-cap impact: a forward stroke's beads hit the cap (a back stroke's do not): a click of vel x clk, harder on an accent
ck = fixdenorm(ck * exp(-1 / ({sel('cdec')} * msr)) + newn * (1 - isb) * vl * {sel('clk')} * {cal} * (1 + (acc > 0.5) * {f(ACC_CLK - 1)}));
ck = ck * (ck > 0.000000001);
raw = (snd + ck) * noise();

// the 4th-order high-pass, then three band-pass resonances (RBJ, constant 0 dB peak), shifted together by Tone (a back stroke's bkt more)
ks = pow(2, (tone + dirs * {sel('bkt')}) / 12);
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
ac0 = 0;""")
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
ac0 = ac0 + yy{k} * {sel(f'g{k}')};""")
    for k in range(2):   # the ring modes: narrow band-passes, not moved by Tone (the tube wall's own modes)
        L.append(f"""mw{k} = twopi * {sel(f'rf{k}')} / samplerate;
mal{k} = sin(mw{k}) / (2 * {sel(f'rq{k}')});
mia{k} = 1 / (1 + mal{k});
mb{k} = mal{k} * mia{k};
mc1{k} = -2 * cos(mw{k}) * mia{k};
mc2{k} = (1 - mal{k}) * mia{k};
my{k} = mb{k} * (inp - m{k}x2) - mc1{k} * m{k}z1 - mc2{k} * m{k}z2;
m{k}x2 = m{k}x1;
m{k}x1 = inp;
m{k}z2 = fixdenorm(m{k}z1);
m{k}z1 = fixdenorm(my{k});
ac0 = ac0 + my{k} * {sel(f'rg{k}')};""")
    L.append(f"""
ac0 = ac0 * dbtoa(vol);
pa = (pan + 1) * 0.25 * pi;
out1 = {'ac0 * cos(pa)' if fit else 'clamp(ac0 * cos(pa), -1, 1)'};
out2 = {'ac0 * sin(pa)' if fit else 'clamp(ac0 * sin(pa), -1, 1)'};
""")
    return "\n".join(L)


if __name__ == "__main__":
    if "--code" in sys.argv:
        print(code())
