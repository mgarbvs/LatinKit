"""conga_engine.py -- generates the gen~ GenExpr code for Conga: three drums (quinto, conga, tumba), six strokes each, one gen~.
See docs/RESEARCH.md for the acoustics and README.md for the note map.

A drum is a bank of NM damped resonators (pinged 2-pole rotations): the head's modes at fixed ratios of its pitch f1 (the number the player
tunes), plus two low "body" modes (air in the shell and the head's lowest motion; the heel/bass thump). A stroke is a force pulse (an
impulse through two one-pole low-passes: the contact time) into those modes with per-stroke mode gains W[m], plus a short band-passed
noise burst (the slap's crack, a fingertip's click). The hand's contact damps the head: every mode's decay rate is multiplied by
1 + (G[m] - 1) * c(t) where c falls from 1 at the hit to 0 with the stroke's release time, so a mute damps what was already ringing and
a slap that stays on the head is dead after a few ms. Mode gains W, damping G, exciter bandwidth and noise were fitted to recordings
(tests/fit.py, scripts/conga_tables.json); ratios, T60s and tunings are in the tables below.

Hits arrive as counters (tr0..tr17, bumped by conga_midi.js) with their velocity in vl0..vl17: slot = drum * 6 + stroke, drum 0 quinto,
1 conga, 2 tumba; stroke 0 open, 1 slap, 2 mute, 3 bass, 4 heel, 5 toe. A change in the counter is a hit (a counter, not a gate, so a
note-off and the next note-on in one audio block cannot swallow it).

First-compile trap (playbook 4): no ternary / max / min / clamp on an expression that depends only on Params at the top level.
Selections below are arithmetic. The one min/max pair (the output limiter) works on signals.
"""
import json
import math
import os

HERE = os.path.dirname(os.path.abspath(__file__))
DRUMS = [("q", "Quinto"), ("c", "Conga"), ("t", "Tumba")]
STROKES = ["open", "slap", "mute", "bass", "heel", "toe"]
BASE_NOTE = [60, 48, 36]               # drum 0 (quinto) C3, 1 (conga) C2, 2 (tumba) C1 (Live's naming: 60 = C3)
STROKE_KEY = [0, 2, 4, 5, 7, 9]        # semitones above the drum's C: C open, D slap, E mute, F bass, G heel, A toe
NOTES = [BASE_NOTE[d] + STROKE_KEY[s] for d in range(3) for s in range(6)]
F1 = [366.0, 266.0, 219.0]             # the open tone of each drum at Tune 0 (Hz): measured on the Latin Percussion pack's three drums
T60_DRUM = [1.0, 1.0, 1.0]             # per-drum decay scale
PAN = [0.6, 0.0, -0.6]                 # at Spread 100 %: quinto right, tumba left (as the player sees them)
NOISE_DRUM = [1.33, 1.22, 0.62]        # the contact tick's level per drum (the recordings' tumba has ~7 dB less crack than the quinto)
# head + body modes: ratio to f1, open-stroke T60 (s). Fitted (see docs/SPEC.md "Fit").
MODES = [(0.30, 0.15), (0.52, 0.12), (0.80, 0.25), (1.00, 0.55), (1.17, 0.30), (1.57, 0.35), (1.77, 0.25), (2.06, 0.22),
         (2.30, 0.18), (2.65, 0.14), (3.20, 0.10), (3.90, 0.08), (4.80, 0.06), (6.20, 0.04)]
NM = len(MODES)
LN60 = 6.907755279  # ln(1000): amplitude to 1/1000 (-60 dB)
CTL = 16            # control-rate block (samples)

TABLES_PATH = os.path.join(HERE, "conga_tables.json")


def db(x):
    return 10 ** (x / 20.0)


def default_tables():  # noqa: C901
    """a first guess: shapes over the modes in dB; tests/fit.py replaces W and G with fitted values"""
    def shape(centres, floor):
        out = []
        for u, _ in MODES:
            v = floor
            for cu, cd, w in centres:     # (centre ratio, level dB, width in octaves)
                v = max(v, cd - 6.0 * ((math.log2(u / cu) / w) ** 2))
            out.append(round(v, 1))
        return out
    T = {
        "open": dict(A=[1.0] * 3, fc=3000, W=shape([(1.0, 0, 0.3), (1.57, -10, 0.3), (2.06, -14, 0.3)], -30), G=[1.0] * NM, tau=1.0,
                     nl=0.0, nf=2500, nq=1.0, nt=0.004),
        "slap": dict(A=[1.0] * 3, fc=6000, W=shape([(1.8, -4, 1.0), (4.0, -12, 1.0)], -30), G=[4.0] * NM, tau=0.05,
                     nl=0.3, nf=2500, nq=0.8, nt=0.006),
        "mute": dict(A=[1.0] * 3, fc=1500, W=shape([(0.8, -2, 0.8)], -30), G=[6.0] * NM, tau=0.3, nl=0.0, nf=2000, nq=1.0, nt=0.004),
        "bass": dict(A=[1.0] * 3, fc=250, W=shape([(0.4, 0, 0.6)], -40), G=[2.0] * NM, tau=0.2, nl=0.0, nf=300, nq=1.0, nt=0.01),
        "heel": dict(A=[1.0] * 3, fc=500, W=shape([(0.5, 0, 0.8)], -35), G=[3.0] * NM, tau=0.15, nl=0.0, nf=400, nq=1.0, nt=0.01),
        "toe": dict(A=[1.0] * 3, fc=2000, W=shape([(1.0, -3, 0.8)], -30), G=[4.0] * NM, tau=0.1, nl=0.0, nf=2500, nq=1.0, nt=0.004),
    }
    return T


def load_tables():
    T = json.load(open(TABLES_PATH)) if os.path.exists(TABLES_PATH) else default_tables()
    for k, t in T.items():
        t.setdefault("kp", KP[k])
        if not isinstance(t["A"], list):
            t["A"] = [t["A"]] * 3
    return T


# how much of the ring already on the head survives the hand arriving (instant, at the hit): a mute catches nearly all of it
KP = {"open": 0.85, "slap": 0.5, "mute": 0.15, "bass": 0.4, "heel": 0.4, "toe": 0.6}


# stroke loudness: peak at velocity 1, Level 0 dB (dBFS). Not recoverable from the previews (all peak-normalised): judgement.
# tests/calibrate.py sets each stroke's A in the tables to hit these
PEAK_DB = {"open": -3.0, "slap": -1.5, "mute": -5.0, "bass": -3.0, "heel": -9.0, "toe": -11.0}

# ---- UI parameter table: (name, long name, short name, min, max, default, units, hover text)
UNITS = {"st": "%+.1f st", "pct": "%.0f %", "db": "%.1f dB"}
PARAMS = [
    ("tuneQ", "Quinto Tune", "Quinto Tune", -12, 12, 0, "st", "Quinto (the high drum) tuning in semitones. 0 is F#4 (366 Hz): the open tone."),
    ("tuneC", "Conga Tune", "Conga Tune", -12, 12, 0, "st", "Conga (the middle drum) tuning in semitones. 0 is C4 (266 Hz): the open tone."),
    ("tuneT", "Tumba Tune", "Tumba Tune", -12, 12, 0, "st", "Tumba (the low drum) tuning in semitones. 0 is A3 (219 Hz): the open tone."),
    ("decay", "Decay", "Decay", 30, 300, 100, "pct", "How long the heads ring, in percent of the natural time (the open tone's T60 is about half a second)."),
    ("skin", "Skin", "Skin", 0, 100, 50, "pct", "Brightness of the head: tilts the strength of the overtones against the fundamental. 50 % is the recording."),
    ("slap", "Slap", "Slap", 0, 100, 50, "pct", "Character of the slap: the crack of the fingers on the rim (noise) and how far up the overtones are driven."),
    ("shell", "Shell", "Shell", 0, 100, 50, "pct", "The body of the drum: how much the low modes (air in the shell, the heel and bass thump) speak."),
    ("touch", "Touch", "Touch", 0, 100, 50, "pct", "How much velocity changes the tone: harder hits are shorter in contact (brighter) as well as louder."),
    ("press", "Press", "Press", 0, 12, 5, "st", "The mod wheel presses the head (elbow or palm on it): this many semitones up at full wheel, on all three drums."),
    ("spread", "Spread", "Spread", 0, 100, 40, "pct", "Stereo spread of the three drums: quinto right, conga centre, tumba left."),
    ("level", "Level", "Level", -36, 6, -9, "db", "Output level."),
]
EXTERNAL = [(f"tr{i}", 0) for i in range(18)] + [(f"vl{i}", 1) for i in range(18)] + [("mw", 0)]


def params():
    return [(n, d) for n, _, _, _, _, d, _, _ in PARAMS]


def svf_coefs(n, g, k):
    return f"{n}a1 = 1 / (1 + {g} * ({g} + {k})); {n}a2 = {g} * {n}a1; {n}a3 = {g} * {n}a2;"


def sel(expr, values):
    """arithmetic select: (|expr - 0| < 0.5) * v0 + (|expr - 1| < 0.5) * v1 + ..."""
    return " + ".join(f"(abs({expr} - {i}) < 0.5) * {v:.6f}" for i, v in enumerate(values))


def drum(d, T, cal):
    p, name = DRUMS[d]
    slots = [d * 6 + s for s in range(6)]
    hist = [f"History pt{k}(0);" for k in slots]
    hist += [f"History {p}C(0);", f"History {p}Ck(0.99);", f"History {p}E1(0);", f"History {p}E2(0);", f"History {p}K(0.5);",
             f"History {p}Ne(0);", f"History {p}Nr(0.99);", f"History {p}I1(0);", f"History {p}I2(0);", f"History {p}Na1(0);",
             f"History {p}Na2(0);", f"History {p}Na3(0);", f"History {p}Nk(1);", f"History {p}Am(0);"]
    for m in range(NM):
        hist += [f"History {p}X{m}(0);", f"History {p}Y{m}(0);", f"History {p}W{m}(0);", f"History {p}G{m}(1);",
                 f"History {p}Cc{m}(1);", f"History {p}Sn{m}(0);", f"History {p}R{m}(0.999);"]
    S = [T[s] for s in STROKES]
    top = []
    for m, (u, t60) in enumerate(MODES):
        # skin tilt on the mode gains (Params only: runs every block)
        tilt = f"exp(skinT * {math.log(u):.6f})"
        shell = f" * shellG" if m < 2 else ""
        top.append(f"{p}Sk{m} = {tilt}{shell};")
    top.append(f"{p}F1 = {F1[d]} * exp2({['tuneQ', 'tuneC', 'tuneT'][d]} / 12);")
    top.append(f"{p}Pl = {PAN[d]} * spr; {p}Gl = cos(({p}Pl + 1) * pi * 0.25); {p}Gr = sin(({p}Pl + 1) * pi * 0.25);")
    body = []
    hk = [f"{p}h{s}" for s in range(6)]
    for s, k in enumerate(slots):
        body.append(f"{hk[s]} = tr{k} != pt{k}; pt{k} = tr{k};")
    body.append(f"{p}hs = {' + '.join(hk)};")
    mx = f"{hk[0]} * 1"
    for s_ in range(1, 6):
        mx = f"max({mx}, {hk[s_]} * {s_ + 1})"
    body.append(f"{p}dm = {mx};                                      // the highest stroke wins if two land in one block")
    body.append(f"{p}ds = {p}dm - 1;")
    body.append(f"{p}dv = {' + '.join(f'({p}dm == {s_ + 1}) * vl{slots[s_]}' for s_ in range(6))};")
    body.append(f"{p}Im = 0;")
    # slap character scales the slap's noise and exciter bandwidth; touch lets velocity open the exciter
    hit = []
    for i, s in enumerate(STROKES):
        hit.append(f"{p}s{i} = abs({p}ds - {i}) < 0.5;")
    hit.append(f"{p}vg = pow({p}dv, 1.4) * {cal[d]:.6f};")
    hit.append(f"{p}Am = {p}vg * ({sel(f'{p}ds', [S[i]['A'][d] for i in range(6)])});")
    hit.append(f"{p}Im = {p}Am;")
    fcs = [S[i]["fc"] for i in range(6)]
    hit.append(f"{p}fc = ({sel(f'{p}ds', fcs)}) * exp2((touchG * ({p}dv - 0.6) * 2) + {p}s1 * (slapG - 1));")
    hit.append(f"{p}K = 1 - exp(-twopi * min({p}fc, 18000) / samplerate);")
    hit.append(f"{p}C = 1;")
    taus = [S[i]["tau"] for i in range(6)]
    hit.append(f"{p}Ck = exp(-{CTL} / (({sel(f'{p}ds', taus)}) * samplerate));")
    nls = [S[i]["nl"] for i in range(6)]
    nts = [S[i]["nt"] for i in range(6)]
    hit.append(f"{p}Ne = {p}Am * {NOISE_DRUM[d]} * ({sel(f'{p}ds', nls)}) * (1 + {p}s1 * (slapG * 2 - 2));")
    hit.append(f"{p}Nr = exp(-1 / (({sel(f'{p}ds', nts)}) * samplerate));")
    nfs = [S[i]["nf"] for i in range(6)]
    nqs = [S[i]["nq"] for i in range(6)]
    hit.append(f"{p}Ng = tan(pi * ({sel(f'{p}ds', nfs)}) / samplerate); {p}Nk = 1 / ({sel(f'{p}ds', nqs)});")
    hit.append(svf_coefs(f"{p}N", f"{p}Ng", f"{p}Nk"))
    for m in range(NM):
        ws = [db(S[i]["W"][m]) for i in range(6)]
        gs = [S[i]["G"][m] for i in range(6)]
        hit.append(f"{p}W{m} = ({sel(f'{p}ds', ws)}) * {p}Sk{m}; {p}G{m} = {sel(f'{p}ds', gs)};")
    kps = [S[i]["kp"] for i in range(6)]
    hit.append(f"{p}kp = {sel(f'{p}ds', kps)};")
    for m in range(NM):
        hit.append(f"{p}X{m} = {p}X{m} * {p}kp; {p}Y{m} = {p}Y{m} * {p}kp;")
    body.append(f"if ({p}hs > 0.5) {{\n" + "\n".join(hit) + "\n}")
    # exciter: impulse through two one-pole low-passes
    body.append(f"{p}E1 = {p}E1 + {p}K * ({p}Im - {p}E1); {p}E2 = {p}E2 + {p}K * ({p}E1 - {p}E2);")
    # control rate: contact decay, mode coefficients
    ctl = [f"{p}C = {p}C * {p}Ck;"]
    for m, (u, t60) in enumerate(MODES):
        ctl.append(f"{p}w = twopi * {p}F1 * pf * {u} / samplerate; {p}Cc{m} = cos({p}w); {p}Sn{m} = sin({p}w); "
                   f"{p}R{m} = exp(-{LN60 / t60:.6f} * (1 + ({p}G{m} - 1) * {p}C) / (decayS * {T60_DRUM[d]} * samplerate));")
    body.append("if (ctl) {\n" + "\n".join(ctl) + "\n}")
    ys = []
    for m in range(NM):
        body.append(f"{p}Xn = {p}R{m} * ({p}Cc{m} * {p}X{m} - {p}Sn{m} * {p}Y{m}) + {p}W{m} * {p}E2; "
                    f"{p}Y{m} = {p}R{m} * ({p}Sn{m} * {p}X{m} + {p}Cc{m} * {p}Y{m}); {p}X{m} = {p}Xn;")
        ys.append(f"{p}Y{m}")
    body.append(f"{p}Sm = {' + '.join(ys)};")
    # noise burst through a band-pass
    body.append(f"{p}Nx = nz * {p}Ne; {p}Ne = {p}Ne * {p}Nr;")
    body.append(f"{p}Nv3 = {p}Nx - {p}I2; {p}Nb = {p}Na1 * {p}I1 + {p}Na2 * {p}Nv3; {p}Nl = {p}I2 + {p}Na2 * {p}I1 + {p}Na3 * {p}Nv3; "
                f"{p}I1 = 2 * {p}Nb - {p}I1; {p}I2 = 2 * {p}Nl - {p}I2;")
    body.append(f"{p}Out = {p}Sm + {p}Nk * {p}Nb;")
    return hist, top, body


def code(tables=None, cal=(1.0, 1.0, 1.0)):
    T = tables or load_tables()
    out = [f"Param {n}({d});" for n, d in params() + EXTERNAL]
    out.append("History cnt(0);\nHistory pf(1);")
    dr = [drum(d, T, cal) for d in range(3)]
    for h, _, _ in dr:
        out += h
    out.append("""
decayS = decay * 0.01;
skinT = (skin - 50) * 0.02 * 6 / 6.0206;                      // +-6 dB per octave of mode ratio at the ends
shellG = shell * 0.02;
slapG = slap * 0.02;
touchG = touch * 0.01 * 1.0;
spr = spread * 0.01;
pfT = exp2(mw * press / 12);
masterG = dbtoa(level);""")
    for _, t, _ in dr:
        out += t
    out.append(f"cnt = cnt + 1; ctl = cnt >= {CTL}; cnt = cnt - ctl * {CTL};\nif (ctl) {{ pf = pf + 0.2 * (pfT - pf); }}")
    out.append("nz = noise();")
    for _, _, b in dr:
        out += b
    L = " + ".join(f"{p}Out * {p}Gl" for p, _ in DRUMS)
    R = " + ".join(f"{p}Out * {p}Gr" for p, _ in DRUMS)
    out.append(f"mixl = ({L}) * masterG; mixr = ({R}) * masterG;")
    for ch, i in (("l", 1), ("r", 2)):
        out.append(f"ax{ch} = abs(mix{ch}); out{i} = sign(mix{ch}) * (min(ax{ch}, 0.8) + 0.2 * tanh(max(ax{ch} - 0.8, 0) * 5)) + 0 * in{i};")
    return "\n".join(out) + "\n"


if __name__ == "__main__":
    print(code())
