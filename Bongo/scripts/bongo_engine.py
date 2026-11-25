"""bongo_engine.py -- gen~ GenExpr code for Bongo: ONE bongo drum (Macho, the high one, or Hembra, the low one) whose stroke is chosen at run time.
See docs/SPEC.md for what the recordings show and README.md for usage.

A bongo head here is a bank of damped resonators (pinged 2-pole rotations), Conga's structure with the modes measured from the bongo recordings
(Latin Percussion pack, tests/refs.py), not copied from the conga:
  head modes   NH per drum, at ratios of the head's pitch f1 (the number the player tunes; Tune and the mod wheel move them). The two drums have different
               mode sets (Macho: the axisymmetric 1, 2.29, 3.4-3.6, 5 and a cluster below; Hembra: 1, 1.5-1.6, 2.15, 3.0-3.25 and a dense cluster), fitted
               per band; both ring about 0.3-0.4 s (T60).
  body mode    one fixed 125 Hz tone (the shell / the hand-held drum; it does not follow Tune), most audible on the tip and the heel.
  noise bands  from BANDS up the recordings are as flat as white noise (spectral flatness -3..-6 dB; a sinusoid line reads -13..-25), so those "modes" are
               decaying band-passed noise, new at every hit (Timbales round 3).
A stroke = a contact force pulse (an impulse through two one-pole low-passes: the contact time, set by the stroke, Touch and velocity) into the modes with
per-stroke, per-drum gains W, plus a short band-passed noise tick. The hand damps what is already ringing: at the hit the ring is multiplied by kp (a heel
or a slap kills most of it, an open stroke little), and for the contact time `tau` every mode's decay rate is multiplied by G[m].
Flam (stroke 6): two Open hits FLAM_GAP s apart, the second FLAM_REL x as loud (the recordings' flams are a strong stroke then a lighter one, 30-60 ms later).
Tables (scripts/bongo_tables.json) come from tests/fit.py (band profiles of the recordings) and tests/calibrate.py (levels).

First-compile trap: no ternary / max / min / clamp on an expression that depends only on Params at the top level. Everything derived from the Params
`stroke`, `drum`, `vel` lives inside the hit block (multiplied by vh, a comparison of the counter `trg` with a History).
"""
import json
import math
import os

HERE = os.path.dirname(os.path.abspath(__file__))
DRUMS = ["Macho", "Hembra"]
STROKES = ["open", "open3", "slap", "heel", "tip", "rim"]                  # the six with tables
STROKE_MENU = ["Open", "Open 3F", "Slap", "Heel", "Tip", "Rim", "Flam"]    # the menu adds the Flam (two Open hits)
NSTROKE = len(STROKES)
FLAM_STROKE = 6
FLAM_GAP = 0.042                       # s between the two hits of a flam: the median of the four 1F / 3F takes (60, 40, 45, 40, 42, 40, 47, 30 ms)
FLAM_REL = 0.45                        # the second hit's velocity relative to the first
F1 = [365.0, 325.0]                    # the open tone at Tune 0 (Hz): the geometric middle of the A and B kits (Macho A 360 / B 371, Hembra A 304 / B 348)
# head modes per drum: ratios to f1, picked from the peaks of the pooled A+B open/flam spectra (docs/SPEC.md "Modes"), T60 in s from the band-envelope slopes
HEAD = [[(0.78, 0.30), (0.91, 0.35), (1.00, 0.38), (1.21, 0.35), (1.35, 0.35), (1.55, 0.35), (1.74, 0.35), (2.05, 0.40), (2.29, 0.34), (3.43, 0.25), (3.65, 0.28), (4.97, 0.26)],
        [(0.75, 0.28), (0.88, 0.25), (1.00, 0.32), (1.12, 0.33), (1.21, 0.35), (1.32, 0.35), (1.54, 0.30), (1.63, 0.35), (2.15, 0.39), (2.96, 0.28), (3.25, 0.33), (3.90, 0.34)]]
NH = len(HEAD[0])
assert len(HEAD[1]) == NH
BODY = (125.0, 0.06)                   # fixed Hz, T60 s
# decaying band-passed noise: centre Hz, T60 s (fixed Hz: the splash does not retune with the head). Q NOISE_Q
BANDS = [(2000, 0.22), (2800, 0.20), (4000, 0.16), (5800, 0.12), (8500, 0.09)]
NB = len(BANDS)
NM = NH + 1 + NB
NB0 = NH + 1                           # first noise band
NN0 = NB0                              # modes below this index are sinusoids
NOISE_Q = 2.0
NOISE_SC = 5.0                         # excitation of a noise band against a sinusoid's, times the contact's low-pass gain
JITTER_DB = 1.5                        # Vary 100 %: each sinusoid's gain x a random factor, uniform in dB with this standard deviation (a judgement; the A / B takes differ by 3-4 dB)
PHASE_SPREAD = 1.0                     # each mode's excitation phase: pi x this x a fixed low-discrepancy value in -1..1 (0 = every mode starts as a sine: a coherent first crest the recordings lack)
NOISE_RISE = 0.0003                    # s: the noise bands' excitation goes through two one-poles of this time constant
LN60 = 6.907755279
CTL = 16
TABLES_PATH = os.path.join(HERE, "bongo_tables.json")


def mode_freq(drum, m, tune_st=0.0):
    """nominal frequency of mode m on a drum (Hz)"""
    if m < NH:
        return F1[drum] * 2 ** (tune_st / 12) * HEAD[drum][m][0]
    return BODY[0] if m == NH else BANDS[m - NB0][0]


def db(x):
    return 10 ** (x / 20.0)


def default_tables():
    seeds = {   # fc contact bandwidth, tau damping time, kp survival of the ring, noise: level, centre Hz, Q, decay s
        "open":  dict(fc=3000, tau=[0.05, 0.05], ta=[0.0005, 0.0005], kp=0.85, nl=[0.05, 0.05], nf=3500, nq=0.5, nt=0.0008),
        "open3": dict(fc=2500, tau=[0.05, 0.05], ta=[0.0005, 0.0005], kp=0.8, nl=[0.05, 0.05], nf=3500, nq=0.5, nt=0.0008),
        "slap":  dict(fc=6000, tau=[0.05, 0.05], ta=[0.0005, 0.0005], kp=0.5, nl=[0.2, 0.2], nf=4000, nq=0.5, nt=0.0008),
        "heel":  dict(fc=1500, tau=[0.15, 0.15], ta=[0.0005, 0.0005], kp=0.4, nl=[0.05, 0.05], nf=2500, nq=0.5, nt=0.0008),
        "tip":   dict(fc=2500, tau=[0.1, 0.1], ta=[0.0005, 0.0005], kp=0.6, nl=[0.05, 0.05], nf=3000, nq=0.5, nt=0.0008),
        "rim":   dict(fc=6000, tau=[0.06, 0.06], ta=[0.0005, 0.0005], kp=0.7, nl=[0.2, 0.2], nf=4000, nq=0.5, nt=0.0008),
    }
    return {s: dict(A=[1.0, 1.0], W=[[-10.0] * NM for _ in range(2)], G=[[1.0] * NM for _ in range(2)], **seeds[s]) for s in STROKES}


def load_tables():
    return json.load(open(TABLES_PATH)) if os.path.exists(TABLES_PATH) else default_tables()


# peak at velocity 1, Volume 0 dB (dBFS). The previews are peak-normalised, so these are a judgement; tests/calibrate.py sets each stroke's A to hit them.
PEAK_DB = {"open": -4.0, "open3": -5.0, "slap": -2.0, "heel": -7.0, "tip": -9.0, "rim": -3.0}

# (name, long name, min, max, default, unit, hover text). Names are the gen~ Params; menus have unit None.
PARAMS = [
    ("drum", "Drum", 0, 1, 0, None, "Which drum of the pair: Macho (the small, high one, open tone about 365 Hz) or Hembra (the large, low one, about 325 Hz). Any MIDI note plays it."),
    ("stroke", "Stroke", 0, 6, 0, None, "Which hand stroke a note plays: Open (one finger on the head, the ringing tone), Open 3F (three fingers: a softer, broader contact), Slap (the crack), "
                                         "Heel (heel of the hand, short and dull), Tip (fingertip, a light tap), Rim (finger on the rim and head together) or Flam (two Open strokes in a row). "
                                         "Changing it between hits works: the new stroke damps the ring already on the head."),
    ("tune", "Tune", -12, 12, 0, "st", "Tuning of the head in semitones. 0 is the drum's open tone (Macho 365 Hz, Hembra 325 Hz). The 125 Hz body does not move."),
    ("decay", "Decay", 30, 300, 100, "pct", "How long the head rings, in percent of the natural time (a bongo's T60 is about a third of a second)."),
    ("skin", "Skin", 0, 100, 50, "pct", "Brightness of the head: tilts the strength of the overtones against the fundamental. 50 % is the recording."),
    ("shell", "Shell", 0, 100, 50, "pct", "The body of the drum: how much the low 125 Hz thump speaks (it matters most on the Heel and the Tip)."),
    ("touch", "Touch", 0, 100, 50, "pct", "Hardness of the contact: harder is shorter and brighter and ticks more; velocity does the same."),
    ("press", "Press", 0, 12, 5, "st", "The mod wheel presses the head (a finger or the heel of the hand leaning on it): this many semitones up at full wheel. The body does not move."),
    ("vary", "Vary", 0, 100, 100, "pct", "How much every hit differs from the last: the loudness of each of the drum's tones is nudged at random at every hit (about 1.5 dB at 100 %), as no two "
                                          "real strokes are the same. 0 plays the same hit every time."),
    ("volume", "Volume", -36, 6, -9, "db", "Output level."),
]
EXTERNAL = [("trg", 0), ("vel", 1), ("mw", 0)]


def sel(expr, values):
    """arithmetic select: (|expr - 0| < 0.5) * v0 + (|expr - 1| < 0.5) * v1 + ..."""
    return " + ".join(f"(abs({expr} - {i}) < 0.5) * {v:.6f}" for i, v in enumerate(values))


def svf_coefs(n, g, k):
    return f"{n}a1 = 1 / (1 + {g} * ({g} + {k})); {n}a2 = {g} * {n}a1; {n}a3 = {g} * {n}a2;"


def code(tables=None, cal=None, jitter=JITTER_DB):  # noqa: C901
    T = tables or load_tables()
    S = [T[s] for s in STROKES]
    cal = cal or {}

    def per(f):         # 2 x NSTROKE values, drum-major, for sel(vk, ...)
        return [f(d, i) for d in range(2) for i in range(NSTROKE)]

    def per_stroke(key):
        return [S[i][key] for i in range(NSTROKE)]

    out = [f"Param {n}({d});" for n, d in [(p[0], p[4]) for p in PARAMS] + EXTERNAL]
    out += ["History cnt(0);", "History pf(1);", "History pt(0);", "History vC(0);", "History vCk(0.99);", "History vE1(0);",
            "History vE2(0);", "History vK(0.5);", "History vNe(0);", "History vNr(0.99);", "History vI1(0);", "History vI2(0);",
            "History vNa1(0);", "History vNa2(0);", "History vNa3(0);", "History vNk(1);", "History vAm(0);", "History vF1(365);",
            "History vTd(1);", "History vIt(0);", "History vP1(0);", "History vP2(0);", "History vFd(0);", "History vFv(0);", "History vAe(0);", "History vTa(0.9);"]
    for m in range(NM):
        out += [f"History vX{m}(0);", f"History vY{m}(0);", f"History vW{m}(0);", f"History vG{m}(1);", f"History vCc{m}(1);",
                f"History vSn{m}(0);", f"History vR{m}(0.999);"]
        if m >= NB0:
            out += [f"History vBe{m}(0);", f"History vBi1{m}(0);", f"History vBi2{m}(0);", f"History vBa1{m}(0);", f"History vBa2{m}(0);", f"History vBa3{m}(0);", f"History vBg{m}(0);"]
    out.append("""
decayS = decay * 0.01;
shellG = shell * 0.02;
skinT = (skin - 50) * 0.02 * 6 / 6.0206;                      // +-6 dB per octave of mode ratio at the ends
touchT = (touch - 50) * 0.02;
pfT = exp2(mw * press / 12);
masterG = dbtoa(volume);""")
    out.append(f"cnt = cnt + 1; ctl = cnt >= {CTL}; cnt = cnt - ctl * {CTL};\nif (ctl) {{ pf = pf + 0.2 * (pfT - pf); }}")
    out.append("nz = noise();")
    # hits: the counter, or the second stroke of a flam coming due
    out.append(f"vh1 = trg != pt; pt = trg;\nvh2 = 0;\nif (vFd > 0.5) {{ vFd = vFd - 1; vh2 = vFd < 0.5; }}\nvh = max(vh1, vh2 * (1 - vh1));")
    hit = ["vfl = vh1 * (abs(stroke - 6) < 0.5);                  // a Flam starts as an Open and schedules its second hit",
           "vds = vh1 * stroke * (1 - vfl);                       // History-derived: the stroke and velocity at the hit (the flam's second hit is an Open: 0)",
           "vdv = vh1 * vel + (1 - vh1) * vFv;",
           f"vFd = vfl * {FLAM_GAP} * samplerate + (1 - vh1) * vFd; vFv = vfl * vdv * {FLAM_REL} + (1 - vfl) * vFv;",
           f"vk = drum * {NSTROKE} + vds;",
           "vg = pow(vdv, 1.4);",
           "vJs = nz * 1000 + trg; vJv = vary * 0.01;",
           f"vAm = vg * ({sel('vk', per(lambda d, i: S[i]['A'][d] * cal.get(i, 1.0)))});",
           "vIm = vAm; vIt = vAm;",
           "vAe = 1; vTa = exp(-1 / ((" + sel('vk', per(lambda d, i: S[i]['ta'][d])) + ") * samplerate));",
           f"vfc = ({sel('vds', per_stroke('fc'))}) * exp2(touchT * 1.5 + (vdv - 0.6) * 0.8);",
           "vK = 1 - exp(-twopi * min(vfc, 18000) / samplerate);",
           "vC = 1;",
           f"vCk = exp(-{CTL} / (({sel('vk', per(lambda d, i: S[i]['tau'][d]))}) * samplerate));",
           f"vNe = vAm * ({sel('vk', per(lambda d, i: S[i]['nl'][d]))}) * (1 + touchT);",
           f"vNr = exp(-1 / (({sel('vds', per_stroke('nt'))}) * samplerate));",
           f"vNg = tan(pi * ({sel('vds', per_stroke('nf'))}) / samplerate); vNk = 1 / ({sel('vds', per_stroke('nq'))});",
           svf_coefs("vN", "vNg", "vNk")]
    for m in range(NM):
        ws = [db(S[i]["W"][d][m]) for d in range(2) for i in range(NSTROKE)]
        gs = [S[i]["G"][d][m] for d in range(2) for i in range(NSTROKE)]
        if m < NH:
            tilt = f" * exp(skinT * ({sel('drum', [math.log(HEAD[d][m][0]) for d in range(2)])}))"
        elif m == NH:
            tilt = " * shellG"
        else:
            tilt = f" * exp(skinT * {math.log(BANDS[m - NB0][0] / 345.0):.6f})"
        jit = f" * exp({jitter * math.sqrt(3) * LN60 / 60:.6f} * vJv * (fract(sin(vJs + {m * 78.233}) * 43758.5453) * 2 - 1))" if jitter and m < NN0 else ""
        hit.append(f"vW{m} = ({sel('vk', ws)}){tilt}{jit}; vG{m} = {sel('vk', gs)};")
    hit.append(f"vkp = {sel('vds', per_stroke('kp'))};")
    for m in range(NM):
        hit.append(f"vX{m} = vX{m} * vkp; vY{m} = vY{m} * vkp;" if m < NN0 else
                   f"vBe{m} = vBe{m} * vkp; vBg{m} = vW{m} * {NOISE_SC} / (1 + {BANDS[m - NB0][0] ** 2} / (vfc * vfc));")
    out.append("vIm = 0; vIt = 0;")
    out.append("if (vh > 0.5) {\n" + "\n".join(hit) + "\n}")
    out.append("vE1 = vE1 + vK * (vIm - vE1); vE2 = vE2 + vK * (vE1 - vE2);")
    ctl = ["vC = vC * vCk;", f"vF1 = ({sel('drum', F1)}) * exp2(tune / 12);"]
    for m in range(NM):
        if m < NH:
            ctl.append(f"vw = twopi * vF1 * pf * ({sel('drum', [HEAD[d][m][0] for d in range(2)])}) / samplerate; vCc{m} = cos(vw); vSn{m} = sin(vw); "
                       f"vR{m} = exp(-{LN60} * (1 + (vG{m} - 1) * vC) / (({sel('drum', [HEAD[d][m][1] for d in range(2)])}) * decayS * samplerate));")
        else:
            f, t60 = (BODY if m == NH else BANDS[m - NB0])
            r = f"vR{m} = exp(-{LN60 / t60:.6f} * (1 + (vG{m} - 1) * vC) / (decayS * samplerate));"
            if m < NN0:
                ctl.append(f"vw = twopi * {f} / samplerate; vCc{m} = cos(vw); vSn{m} = sin(vw); " + r)
            else:
                ctl.append(f"vBg = tan(pi * {f} / samplerate); vBa1{m} = 1 / (1 + vBg * (vBg + {1 / NOISE_Q:.6f})); vBa2{m} = vBg * vBa1{m}; vBa3{m} = vBg * vBa2{m}; " + r)
    out.append("if (ctl) {\n" + "\n".join(ctl) + "\n}")
    for m in range(NN0):
        ph = math.pi * PHASE_SPREAD * (((m + 1) * 0.6180339887) % 1.0 * 2 - 1)
        out.append(f"vXn = vR{m} * (vCc{m} * vX{m} - vSn{m} * vY{m}) + {math.cos(ph):.6f} * vW{m} * vE2; "
                   f"vY{m} = vR{m} * (vSn{m} * vX{m} + vCc{m} * vY{m}) + {math.sin(ph):.6f} * vW{m} * vE2; vX{m} = vXn;")
    out.append(f"vKn = 1 - exp(-1 / ({NOISE_RISE} * samplerate)); vP1 = vP1 + vKn * (vIt - vP1); vP2 = vP2 + vKn * (vP1 - vP2);")
    for m in range(NN0, NM):
        out.append(f"vBe{m} = vBe{m} * vR{m} + vBg{m} * vP2; vQ3 = nz * vBe{m} - vBi2{m}; vQb = vBa1{m} * vBi1{m} + vBa2{m} * vQ3; "
                   f"vQl = vBi2{m} + vBa2{m} * vBi1{m} + vBa3{m} * vQ3; vBi1{m} = 2 * vQb - vBi1{m}; vBi2{m} = 2 * vQl - vBi2{m}; vY{m} = vQb / {NOISE_Q};")
    out.append("vAe = vAe * vTa;                                      // the head's tone swells in (a soft contact) while the tick and the noise bands start at once")
    out.append("vSm = (1 - vAe) * (" + " + ".join(f"vY{m}" for m in range(NN0)) + ") + " + " + ".join(f"vY{m}" for m in range(NN0, NM)) + ";")
    out.append("vNx = nz * vNe; vNe = vNe * vNr;")
    out.append("vNv3 = vNx - vI2; vNb = vNa1 * vI1 + vNa2 * vNv3; vNl = vI2 + vNa2 * vI1 + vNa3 * vNv3; "
               "vI1 = 2 * vNb - vI1; vI2 = 2 * vNl - vI2;")
    out.append("vmix = (vSm + vNk * vNb) * masterG;")
    out.append("vax = abs(vmix); vlim = sign(vmix) * (min(vax, 0.8) + 0.2 * tanh(max(vax - 0.8, 0) * 5));")
    out.append("out1 = vlim + 0 * in1; out2 = vlim + 0 * in2;")
    return "\n".join(out) + "\n"


if __name__ == "__main__":
    print(code())
