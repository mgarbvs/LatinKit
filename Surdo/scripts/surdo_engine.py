"""surdo_engine.py -- gen~ GenExpr code for Surdo: ONE samba bass drum (a deep two-headed surdo) whose stroke is chosen at run time.
See docs/SPEC.md for what the recordings show and README.md for usage.

The head is a bank of damped resonators (pinged 2-pole rotations), Bongo's structure with the modes measured from the surdo recordings (Latin Percussion pack,
tests/refs.py):
  head modes   NH lines at ratios of the head's pitch f1 = 86 Hz (the number the player tunes; Tune and the mod wheel move them): the Open stroke rings 86 Hz,
               the Rim and Mute strokes excite lower and higher members of the same set (73 Hz, 125-145 Hz), the Finger a thump (36-46 Hz) and 100-106 Hz.
  glide        the Open stroke starts about 40 ct sharp and falls to f1 in ~0.25 s (tension modulation: bigger for harder hits): `gl` x velocity^2, decaying with GLIDE_TAU.
  noise bands  from BANDS up (700 Hz) Mute / Rim / Finger are as flat as white noise (spectral flatness -3..-6 dB): decaying band-passed noise, new at every hit.
A stroke = a contact force pulse (an impulse through two one-pole low-passes: the contact time, set by the stroke, Touch and velocity) into the modes with per-stroke
gains W, plus a short band-passed noise tick. The hand damps what is already ringing: at the hit the ring is multiplied by kp (a Mute kills most of it, an Open
little), and for `tau` every mode's decay rate is multiplied by G[m]; G below 1 is the Open's slow start (its envelope falls ever faster: T60 2.6 s early, 0.8 s late).
Tables (scripts/surdo_tables.json) come from tests/fit.py (band profiles of the recordings) and tests/calibrate.py (levels).

First-compile trap: no ternary / max / min / clamp on an expression that depends only on Params at the top level. Everything derived from the Params
`stroke`, `vel` lives inside the hit block (multiplied by vh, a comparison of the counter `trg` with a History).
"""
import json
import math
import os

HERE = os.path.dirname(os.path.abspath(__file__))
STROKES = ["open", "mute", "rim", "finger"]
STROKE_MENU = ["Open", "Mute", "Rim", "Finger"]
NSTROKE = len(STROKES)
F1 = 86.0                              # Hz: the open tone once the glide has settled (the Latin Percussion Open: 88 Hz at the hit, 86.0 from 250 ms; the clips agree)
GLIDE_TAU = 0.1                        # s: the pitch glide's time constant (the measured offset 1.85 Hz at 30 ms, 0.6 Hz at 150 ms, 0.1 Hz at 250 ms)
# head modes: ratio to f1, T60 in s (late slope), from the pooled spectra of the four strokes (docs/SPEC.md "Modes")
HEAD = [(0.30, 0.12), (0.42, 0.25), (0.54, 0.15), (0.74, 0.30), (0.85, 0.75), (1.00, 0.85), (1.20, 0.40), (1.45, 0.35), (1.65, 0.30), (1.85, 1.00), (2.40, 0.30), (2.76, 0.50), (3.00, 1.00),
        (3.83, 0.40), (4.40, 0.40), (5.20, 0.90), (5.86, 0.60)]
NH = len(HEAD)
# decaying band-passed noise: centre Hz, T60 s (fixed Hz). Q NOISE_Q
BANDS = [(800, 0.32), (1150, 0.28), (1650, 0.24), (2400, 0.2), (3500, 0.2), (5200, 0.2), (7800, 0.2)]
NB = len(BANDS)
NM = NH + NB
NB0 = NH                               # first noise band
NN0 = NB0                              # modes below this index are sinusoids
NOISE_Q = 2.0
NOISE_SC = 5.0                         # excitation of a noise band against a sinusoid's, times the contact's low-pass gain
JITTER_DB = 1.5                        # Vary 100 %: each sinusoid's gain x a random factor, uniform in dB with this standard deviation (a judgement)
PHASE_SPREAD = 1.0                     # each mode's excitation phase: pi x this x a fixed low-discrepancy value in -1..1 (0 = every mode starts as a sine)
NOISE_RISE = 0.0003                    # s: the noise bands' excitation goes through two one-poles of this time constant
LN60 = 6.907755279
CTL = 16
TABLES_PATH = os.path.join(HERE, "surdo_tables.json")


def mode_freq(m, tune_st=0.0):
    """nominal frequency of mode m (Hz)"""
    return F1 * 2 ** (tune_st / 12) * HEAD[m][0] if m < NH else BANDS[m - NB0][0]


def db(x):
    return 10 ** (x / 20.0)


def default_tables():
    seeds = {   # fc contact bandwidth, tau damping time, ta tone swell, kp survival of the ring, gl glide (fraction of f1, at velocity 1), noise: nl level, nf centre Hz, nq Q, nt decay s
        "open":   dict(fc=700, tau=0.25, ta=0.002, kp=0.9, gl=0.026, nl=0.02, nf=1500, nq=0.5, nt=0.0008),
        "mute":   dict(fc=2500, tau=0.02, ta=0.0005, kp=0.15, gl=0.0, nl=0.3, nf=1500, nq=0.5, nt=0.0008),
        "rim":    dict(fc=5000, tau=0.05, ta=0.0005, kp=0.7, gl=0.0, nl=0.3, nf=2500, nq=0.5, nt=0.0008),
        "finger": dict(fc=1500, tau=0.03, ta=0.005, kp=0.5, gl=0.0, nl=0.1, nf=2000, nq=0.5, nt=0.0008),
    }
    return {s: dict(A=1.0, W=[-10.0] * NM, G=[1.0] * NM, **seeds[s]) for s in STROKES}


def load_tables():
    return json.load(open(TABLES_PATH)) if os.path.exists(TABLES_PATH) else default_tables()


# peak at velocity 1, Volume 0 dB (dBFS). The previews are peak-normalised, so these are a judgement; the Live clips replay the three recorded strokes at
# median gains 0.80 (Open), 0.46 (Mute), 0.37 (Finger) of the previews' peaks, i.e. 0 / -4.7 / -6.7 dB (docs/SPEC.md, tests/clips.py); there is no Rim in the clips (-5 dBFS:
# a judgement). tests/calibrate.py sets each stroke's A.
PEAK_DB = {"open": -4.0, "mute": -8.7, "rim": -5.0, "finger": -10.7}

# (name, long name, min, max, default, unit, hover text). Names are the gen~ Params; menus have unit None.
PARAMS = [
    ("stroke", "Stroke", 0, 3, 0, None, "Which stroke a note plays: Open (mallet in the middle of the head, the long 86 Hz boom), Mute (the other hand on the head: a short thud), "
                                         "Rim (stick on the rim and head together: a crack over a lower tone) or Finger (a finger tap: a soft click and a low thump). "
                                         "Changing it between hits works: the new stroke damps the ring already on the head."),
    ("tune", "Tune", -12, 12, 0, "st", "Tuning of the head in semitones. 0 is the recorded drum's open tone, 86 Hz. Down a fourth or up a fourth might stand for the larger and smaller surdo sizes: a guess, the sizes are not in the recordings."),
    ("decay", "Decay", 30, 300, 100, "pct", "How long the head rings, in percent of the natural time (the Open stroke's 86 Hz tone falls 40 dB in about 0.7 s)."),
    ("skin", "Skin", 0, 100, 50, "pct", "Brightness of the head: tilts the strength of the overtones against the fundamental. 50 % is the recording."),
    ("touch", "Touch", 0, 100, 50, "pct", "Hardness of the contact: harder is brighter and ticks more; velocity does the same."),
    ("press", "Press", 0, 12, 5, "st", "The mod wheel presses the head (a hand leaning on it): this many semitones up at full wheel."),
    ("vary", "Vary", 0, 100, 100, "pct", "How much every hit differs from the last: the loudness of each of the drum's tones is nudged at random at every hit (about 1.5 dB at 100 %), as no two "
                                          "real strokes are the same. 0 plays the same hit every time."),
    ("volume", "Volume", -36, 6, -9, "db", "Output level."),
]
EXTERNAL = [("trg", 0), ("vel", 1), ("mw", 0)]
KEY0 = 41                              # Surdo Musical: the key before any note (87.3 Hz, F2: next to Surdo's 86 Hz)
NYQ_MUTE = 0.45                        # Surdo Musical: head modes above this x samplerate are muted


def sel(expr, values):
    """arithmetic select: (|expr - 0| < 0.5) * v0 + (|expr - 1| < 0.5) * v1 + ..."""
    return " + ".join(f"(abs({expr} - {i}) < 0.5) * {v:.6f}" for i, v in enumerate(values))


def svf_coefs(n, g, k):
    return f"{n}a1 = 1 / (1 + {g} * ({g} + {k})); {n}a2 = {g} * {n}a1; {n}a3 = {g} * {n}a2;"


def code(tables=None, cal=None, jitter=JITTER_DB, musical=False):  # noqa: C901
    """musical=True (Surdo Musical): the played note sets f1 (mtof(key) x Tune) instead of the fixed 86 Hz, and head modes above 0.45 sr are muted"""
    T = tables or load_tables()
    S = [T[s] for s in STROKES]
    cal = cal or {}

    def per(key):
        return [S[i][key] for i in range(NSTROKE)]

    out = [f"Param {n}({d});" for n, d in [(p[0], p[4]) for p in PARAMS] + EXTERNAL + ([("key", KEY0)] if musical else [])]
    out += ["History cnt(0);", "History pf(1);", "History pt(0);", "History vC(0);", "History vCk(0.99);", "History vE1(0);",
            "History vE2(0);", "History vK(0.5);", "History vNe(0);", "History vNr(0.99);", "History vI1(0);", "History vI2(0);",
            "History vNa1(0);", "History vNa2(0);", "History vNa3(0);", "History vNk(1);", "History vAm(0);", "History vF1(86);",
            "History vIt(0);", "History vP1(0);", "History vP2(0);", "History vAe(0);", "History vTa(0.9);", "History vGp(0);", "History vGk(0.99);"]
    for m in range(NM):
        out += [f"History vX{m}(0);", f"History vY{m}(0);", f"History vW{m}(0);", f"History vG{m}(1);", f"History vCc{m}(1);",
                f"History vSn{m}(0);", f"History vR{m}(0.999);"]
        if m >= NB0:
            out += [f"History vBe{m}(0);", f"History vBi1{m}(0);", f"History vBi2{m}(0);", f"History vBa1{m}(0);", f"History vBa2{m}(0);", f"History vBa3{m}(0);", f"History vBg{m}(0);"]
    out.append("""
decayS = decay * 0.01;
skinT = (skin - 50) * 0.02 * 6 / 6.0206;                      // +-6 dB per octave of mode ratio at the ends
touchT = (touch - 50) * 0.02;
pfT = exp2(mw * press / 12);
masterG = dbtoa(volume);""")
    out.append(f"cnt = cnt + 1; ctl = cnt >= {CTL}; cnt = cnt - ctl * {CTL};\nif (ctl) {{ pf = pf + 0.2 * (pfT - pf); }}")
    out.append("nz = noise();")
    out.append("vh = trg != pt; pt = trg;")
    hit = ["vds = vh * stroke;                                    // History-derived: the stroke and velocity at the hit",
           "vdv = vh * vel;",
           "vg = pow(vdv, 1.4);",
           "vJs = nz * 1000 + trg; vJv = vary * 0.01;",
           f"vAm = vg * ({sel('vds', [S[i]['A'] * cal.get(i, 1.0) for i in range(NSTROKE)])});",
           "vIm = vAm; vIt = vAm;",
           "vAe = 1; vTa = exp(-1 / ((" + sel('vds', per('ta')) + f") * samplerate));",
           f"vfc = ({sel('vds', per('fc'))}) * exp2(touchT * 1.5 + (vdv - 0.6) * 0.8);",
           "vK = 1 - exp(-twopi * min(vfc, 18000) / samplerate);",
           "vC = vC + (1 - vC) * vdv;                              // a soft hit does not restart the stroke's own damping (an Open over a ringing Open would slow its ring again)",
           f"vCk = exp(-{CTL} / (({sel('vds', per('tau'))}) * samplerate));",
           f"vGp = ({sel('vds', per('gl'))}) * vdv * vdv; vGk = exp(-{CTL} / ({GLIDE_TAU} * samplerate));",
           f"vNe = vAm * ({sel('vds', per('nl'))}) * (1 + touchT);",
           f"vNr = exp(-1 / (({sel('vds', per('nt'))}) * samplerate));",
           f"vNg = tan(pi * ({sel('vds', per('nf'))}) / samplerate); vNk = 1 / ({sel('vds', per('nq'))});",
           svf_coefs("vN", "vNg", "vNk")]
    for m in range(NM):
        ws = [db(S[i]["W"][m]) for i in range(NSTROKE)]
        gs = [S[i]["G"][m] for i in range(NSTROKE)]
        tilt = f" * exp(skinT * {math.log(HEAD[m][0] if m < NH else BANDS[m - NB0][0] / F1):.6f})"
        jit = f" * exp({jitter * math.sqrt(3) * LN60 / 60:.6f} * vJv * (fract(sin(vJs + {m * 78.233}) * 43758.5453) * 2 - 1))" if jitter and m < NN0 else ""
        hit.append(f"vW{m} = ({sel('vds', ws)}){tilt}{jit}; vG{m} = {sel('vds', gs)};")
    hit.append(f"vkp = {sel('vds', per('kp'))};")
    for m in range(NM):
        hit.append(f"vX{m} = vX{m} * vkp; vY{m} = vY{m} * vkp;" if m < NN0 else
                   f"vBe{m} = vBe{m} * vkp; vBg{m} = vW{m} * {NOISE_SC} / (1 + {BANDS[m - NB0][0] ** 2} / (vfc * vfc));")
    out.append("vIm = 0; vIt = 0;")
    out.append("if (vh > 0.5) {\n" + "\n".join(hit) + "\n}")
    out.append("vE1 = vE1 + vK * (vIm - vE1); vE2 = vE2 + vK * (vE1 - vE2);")
    twopi_nyq = 2 * math.pi * NYQ_MUTE
    ctl = ["vC = vC * vCk; vGp = vGp * vGk;", "vF1 = mtof(key) * exp2(tune / 12);" if musical else f"vF1 = {F1} * exp2(tune / 12);"]
    for m in range(NM):
        if m < NH:
            ctl.append(f"vw = twopi * vF1 * pf * (1 + vGp) * {HEAD[m][0]} / samplerate; vCc{m} = cos(vw); vSn{m} = sin(vw); "
                       f"vR{m} = exp(-{LN60} * (1 + (vG{m} - 1) * vC) / ({HEAD[m][1]} * decayS * samplerate));"
                       + (f" vW{m} = vW{m} * (vw < {twopi_nyq:.6f});" if musical else ""))
        else:
            f, t60 = BANDS[m - NB0]
            ctl.append(f"vBg = tan(pi * {f} / samplerate); vBa1{m} = 1 / (1 + vBg * (vBg + {1 / NOISE_Q:.6f})); vBa2{m} = vBg * vBa1{m}; vBa3{m} = vBg * vBa2{m}; "
                       f"vR{m} = exp(-{LN60 / t60:.6f} * (1 + (vG{m} - 1) * vC) / (decayS * samplerate));")
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
