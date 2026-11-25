#!/usr/bin/env python3
"""guiro_engine.py — generates the gen~ GenExpr code for Guiro: a scraper (güiro, reco-reco). See README.md / docs/SPEC.md.

The model (a PhISEM-style event train with a *deterministic* rate, after the STK Shakers guiro's "ratchet" but with an explicit gesture):
  * a note starts a stroke (Up, Down, Long, Top: `stk`). A stroke is a stick crossing evenly spaced ridges at some speed: impacts at
    rate = Ridge x Speed x the stroke's rate factor (x a slight curve over the stroke) for the stroke's length (Up ~80 ms, Down ~115 ms,
    Long = the Length control, Top = a single tap). The first impact fires with the note; the phase accumulator then fires one per ridge,
    each interval jittered by Vary (capped at +-35 %: Cuica once ran a phase backwards on > 100 % jitter).
  * each impact has a level (velocity x the stroke's attack / end taper x a random factor from Vary) that kicks (a) a fast level (`snd`, the tick,
    decays by `sdec` ms) times noise, through a 4th-order high-pass and three band-pass resonances (f Hz, Q, gain): the bright broadband click;
    (b) two slow noise levels (`slw`, `rtau` ms, weight ringS in a scrape / ringT in a Top tap; `slw2`, `rtau2`, ringL: the two-slope broadband tail the previews show after every stroke); (c) three tonal body modes
    (the gourd: ~300 Hz, ~0.7 and ~1.5 kHz in the previews; f, decay ms, gain; `bs` / `bT` = their share in a scrape, where the hand holds the gourd, and in a Top tap).
    The click's grain gain is normalised for the impact overlap so Ridge / Speed move texture, not level. Tone shifts everything.
The per-Type constants (Guiro: fitted to the Latin Percussion güiro previews by tests/fit_types.js; Reco-reco: a judgement, no reference exists)
and the per-stroke constants (length, rate, curve, taper: measured from the previews) are tables below.

Hits arrive as a counter `tr` (bumped by guiro_midi.js) with velocity `vl` and stroke `stk`: a changed counter is a stroke (a gate edge could be lost).
First-compile trap: no ternary / max / min / clamp on an expression that depends only on Params; Types and strokes are selected arithmetically.
`python3 scripts/guiro_engine.py --code` prints the code. GUIRO_FIT=1 prints a variant whose Type constants are Params (c_*) for tests/fit_types.js.
"""
import os
import sys

NAMES = ["Guiro", "Recoreco"]   # ASCII keys (code, tests); the menu spells them with accents
MENU = ["Güiro", "Reco"]   # "Reco-reco" is truncated in the 58 px menu
STROKES = ["Up", "Down", "Long", "Top"]

# per Type: trm (rate factor), sdec (tick length, ms), rtau / ringS / ringT (the broadband noise tail: ms, weight in a scrape / in a Top tap), rtau2 / ringL (a second, slower and
# fainter tail), hp / hq (two identical 2-pole high-passes; kT: the Top tap's resonances are that many times higher: a tap is brighter than a scrape), res = three (f Hz, Q, gain), body = three (f Hz, decay ms, gain), bs / bT (the body's share in a scrape / in a Top tap)
TYPES = {
    "Guiro": dict(trm=1.0, sdec=1.406, rtau=12.42, rtau2=43.24, ringS=0.02257, ringT=0.1487, ringL=0.005958, hp=229.8, hq=2.145, kT=1.8, res=[(4004, 5.653, 1.164), (6279, 5.681, 1.532), (3634, 2.569, 1.717)],
                  body=[(305.8, 100, 0.03922), (1200, 60, 0.1022), (1523, 30.42, 0.1583)], bs=0.3672, bT=0.35),
    "Recoreco": dict(trm=3, sdec=2.016, rtau=50.82, rtau2=58.52, ringS=0.001511, ringT=0.08537, ringL=0.02649, hp=1653, hq=0.5643, kT=0.8882, res=[(7880, 1.633, 1.367), (12590, 1.599, 0.9958), (3195, 1.498, 1.097)],
                     body=[(1606, 128.3, 0.09882), (2659, 327.7, 0.05797), (3323, 75.57, 0.1982)], bs=0.6968, bT=1.021),
}
# per stroke (measured from the previews, tests/refs.js): length ms (Long: the Length control), rate factor against the nominal Ridge rate,
# bw (the body's weight in this scrape: the previews' Up has the most low end, Down the least), curve (+ = slows down over the stroke), attack (the level starts at this fraction and builds over the first 40 %), end taper (the level
# falls by exp(-tap) over the last 60 %)
STK = {
    "Up": dict(dur=80, rm=1.35, cv=0.0, att=0.8, tap=2.4, bw=1.2),
    "Down": dict(dur=115, rm=0.9, cv=0.35, att=0.3, tap=1.8, bw=0.35),
    "Long": dict(dur=450, rm=0.8, cv=0.1, att=0.7, tap=0.8, bw=0.7),
    "Top": dict(dur=0, rm=0.0, cv=0.0, att=1.0, tap=0.0, bw=1.0),
}
BASE_RATE = 130.0   # impacts per second at Ridge 100 %, Speed 100 %, rate factor 1
# level trim per Type x stroke: 10 ms RMS peak of a vel-1 stroke at Level 0 dB = TARGET (tests/calibrate.js prints these)
CAL = {"Guiro": [0.4921,0.4977,0.3462,0.3379], "Recoreco": [0.3655,0.3739,0.2592,0.8201]}
TARGET = 0.25

PARAMS = [("type", 0), ("stk", 0), ("len", 450), ("speed", 1), ("ridge", 1), ("tone", 0), ("vary", 0.5), ("vol", -6), ("pan", 0),
          ("tr", 0), ("vl", 0)]
FIELDS = ["trm", "sdec", "rtau", "rtau2", "ringS", "ringT", "ringL", "hp", "hq", "kT", "bs", "bT"] + [f"{a}{k}" for k in range(3) for a in "fqg"] + [f"{a}{k}" for k in range(3) for a in ("bf", "bt", "bg")]


def f(x):   # plain decimals only: exponent literals break the codebox
    s = f"{x:.10f}".rstrip("0")
    return s + "0" if s.endswith(".") else s


def flat(name):
    d = TYPES[name]
    v = {k: d[k] for k in ("trm", "sdec", "rtau", "rtau2", "ringS", "ringT", "ringL", "hp", "hq", "kT", "bs", "bT")}
    for k, (fr, q, g) in enumerate(d["res"]):
        v[f"f{k}"], v[f"q{k}"], v[f"g{k}"] = fr, q, g
    for k, (fr, t, g) in enumerate(d["body"]):
        v[f"bf{k}"], v[f"bt{k}"], v[f"bg{k}"] = fr, t, g
    return v


def code(fit=None):
    fit = bool(os.environ.get("GUIRO_FIT")) if fit is None else fit
    L = ["// Guiro engine. GENERATED by scripts/guiro_engine.py: do not edit."]
    for n, d in PARAMS:
        L.append(f"Param {n}({f(d)});")
    if fit:
        for fld in FIELDS:
            L.append(f"Param c_{fld}({f(flat('Guiro')[fld])});")
        L.append("Param c_cal(1);")
    for n in ("ltr", "ts", "ph", "jt", "sdur", "srm", "scv", "satt", "stap", "samp", "snd", "slw", "slw2", "hx1", "hx2", "hz1", "hz2", "jx1", "jx2", "jz1", "jz2"):
        L.append(f"History {n}({'1000000000.0' if n == 'ts' else '0'});")
    for k in range(3):
        for n in ("x1", "x2", "z1", "z2", "y1", "y2"):
            L.append(f"History r{k}{n}(0);")
    if not fit:
        for k in range(2):
            L.append(f"t{k} = abs(type - {k}) < 0.5;")
    for k in range(4):
        L.append(f"s{k} = abs(stk - {k}) < 0.5;")

    def sel(fld):
        if fit:
            return f"c_{fld}"
        return "(" + " + ".join(f"t{k} * {f(flat(n)[fld])}" for k, n in enumerate(NAMES)) + ")"

    def sk(key):   # per-stroke constant (Long's length is the Length control)
        return "(" + " + ".join((f"s{k} * len" if (key == "dur" and n == "Long") else f"s{k} * {f(STK[n][key])}") for k, n in enumerate(STROKES)) + ")"
    cal = "c_cal" if fit else "(" + " + ".join(f"t{k} * (" + " + ".join(f"s{j} * {f(CAL[n][j])}" for j in range(4)) + ")" for k, n in enumerate(NAMES)) + ")"
    L.append(f"""
newn = tr != ltr;
ltr = tr;
msr = samplerate * 0.001;
// stroke constants are latched at the note (a new note restarts the gesture; the ring of the old one carries on); a faster stick crosses the
// same ridges in less time (length / speed), so Speed changes the rate and the length, Ridge the rate only
sdur = newn * {sk('dur')} * msr / speed + (1 - newn) * sdur;
srm = newn * {sk('rm')} + (1 - newn) * srm;
scv = newn * {sk('cv')} + (1 - newn) * scv;
satt = newn * {sk('att')} + (1 - newn) * satt;
stap = newn * {sk('tap')} + (1 - newn) * stap;
samp = newn * vl + (1 - newn) * samp;
ts = (1 - newn) * (ts + 1);
u = ts / (sdur + 1);
on = ts < sdur;

// the gesture: impacts at a rate = ridge x speed x stroke factor x a slight curve; one fires with the note, then one per phase wrap
rt = {f(BASE_RATE)} * {sel('trm')} * ridge * speed * srm * (1 + scv * (0.5 - u) * 2);
rt = rt * (rt > 0) * on;
ph = (1 - newn) * (ph + rt / samplerate * (1 + jt));
fire = newn + (1 - newn) * (ph >= 1);
ph = ph - (1 - newn) * (ph >= 1);
jt = fire * vary * 0.35 * noise() + (1 - fire) * jt;
g = (satt + (1 - satt) * clamp(u / 0.4, 0, 1)) * exp(-stap * clamp((u - 0.4) / 0.6, 0, 1));
a = samp * g * (1 - vary * 0.7 * abs(noise()));

// level: a fast click and a slow body ring, both kicked by every impact; grain gain normalised for the overlap
gl = {sel('sdec')};
sd = exp(-1 / (gl * msr));
rd = exp(-1 / ({sel('rtau')} * msr));
rd2 = exp(-1 / ({sel('rtau2')} * msr));
nr = {f(BASE_RATE)} * {sel('trm')} * (s3 + (1 - s3) * ridge * speed * ({sk('rm')} + s3));
gx = nr * gl * 0.001;
gr = {cal} / sqrt(0.36 * gx * gx + 0.2067 * gx);
snd = fixdenorm(snd * sd + fire * a * gr * (0.3 + 0.7 * abs(noise())));
snd = snd * (snd > 0.000000001);
slw = fixdenorm(slw * rd + fire * a * gr * ({sel('ringS')} * (1 - s3) + {sel('ringT')} * s3));
slw = slw * (slw > 0.000000001);
slw2 = fixdenorm(slw2 * rd2 + fire * a * gr * {sel('ringL')});
slw2 = slw2 * (slw2 > 0.000000001);
raw = (snd + slw + slw2) * noise();

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
        L.append(f"""fr{k} = {sel(f'f{k}')} * ks * (1 + s3 * ({sel('kT')} - 1));
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
// the gourd's body: three tonal modes rung by an impulse per impact (amplitude a); a held gourd (scrape) rings less (bs)
bi = fire * a * {cal} * ({sel('bs')} * (1 - s3) * {sk('bw')} + {sel('bT')} * s3);""")
    for k in range(3):
        L.append(f"""bw{k} = twopi * {sel(f'bf{k}')} * ks / samplerate;
br{k} = exp(-1 / ({sel(f'bt{k}')} * msr));
by{k} = bi * sin(bw{k}) * {sel(f'bg{k}')} + 2 * br{k} * cos(bw{k}) * r{k}y1 - br{k} * br{k} * r{k}y2;
r{k}y2 = fixdenorm(r{k}y1);
r{k}y1 = fixdenorm(by{k});
acc = acc + by{k};""")
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
