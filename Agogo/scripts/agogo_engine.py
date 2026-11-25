"""agogo_engine.py -- gen~ GenExpr code for Agogo: ONE agogo bell (High or Low) whose stroke (Open, Mute) is chosen at run time.
See docs/SPEC.md for what the recordings show and README.md for usage.

An agogo bell here is a bank of NS damped resonators (pinged 2-pole rotations) whose frequencies, T60s and levels were measured from the Latin Percussion
recordings (kit A; tests/extract.py), not copied from another instrument:
  * Every strong mode is a DOUBLET (the bell is not axisymmetric: A High 1469 / 1479 Hz, the partner 11 dB down, ripple of the ring envelope ~10 Hz): the two
    partners are two entries of the table, each with its own f, T60 and level. The ~10-45 Hz "sidebands" of a coarse peak-pick are window leakage.
  * The highs (5-11 kHz) are TONAL LINES (spectral flatness -10..-23 dB), dying in 10-200 ms: sinusoid partials too, merged to about 12 per bell (the real
    lines are denser than 60 Hz), not Timbales / Bongo noise bands. Only a short stick tick (band-passed noise, ~1 ms) is noise.
A stroke = a contact force pulse (an impulse through two one-pole low-passes: stick hardness, Touch, velocity) into the modes with per-stroke per-bell gains
W, plus the tick. Open: the stick does not damp what rings (kp = 1, G = 1). Mute: the hand holds the bell (a judgement, nothing in the recordings is muted:
docs/SPEC.md): at the hit the ring is multiplied by kp and every mode's decay rate by G[m] for a long `tau`, faster for the highs.
Tables (scripts/agogo_tables.json) come from tests/fit.py (modes from tests/extract.py) and tests/calibrate.py (levels).

First-compile trap: no ternary / max / min / clamp on an expression that depends only on Params at the top level. Everything derived from the Params
`stroke`, `bell`, `vel` lives inside the hit block (a comparison of the counter `trg` with a History).
"""
import json
import math
import os

HERE = os.path.dirname(os.path.abspath(__file__))
BELLS = ["High", "Low"]
STROKES = ["open", "mute"]
STROKE_MENU = ["Open", "Mute"]
NSTROKE = len(STROKES)
NS = 24                                # sinusoid modes per bell (the table pads with silent ones)
CONTACT_SR = 48000.0
JITTER_DB = 1.5                        # Vary 100 %: each mode's gain x a random factor, uniform in dB with this standard deviation (a judgement; the bell's takes are one hit each)
PHASE_SPREAD = 1.0                     # each mode's excitation phase: pi x this x a fixed low-discrepancy value in -1..1
LN60 = 6.907755279
CTL = 16
TABLES_PATH = os.path.join(HERE, "agogo_tables.json")
FC_REF_SHIFT = 2 ** ((0.8 - 0.6) * 0.8)    # the contact bandwidth at Touch 50, vel 0.8 against the table's fc: what the stored mode levels W are referred to


def db(x):
    return 10 ** (x / 20.0)


def contact_db(f, fc):
    """gain (dB) of the two one-pole low-passes of the contact (bandwidth fc) at f Hz, as the engine builds them"""
    k = 1 - math.exp(-2 * math.pi * min(fc, 18000) / CONTACT_SR)
    w = 2 * math.pi * f / CONTACT_SR
    h2 = k * k / (1 - 2 * (1 - k) * math.cos(w) + (1 - k) ** 2)
    return 10 * math.log10(h2 * h2)


def default_tables():
    pad = lambda v: [v] * NS   # noqa: E731
    bell = lambda f1: dict(f1=f1, r=[1.0] * NS, t60=[0.1] * NS)   # noqa: E731
    base = dict(fc=9000.0, tau=[0.05, 0.05], ta=[0.0004, 0.0004], kp=1.0, nl=[0.05, 0.05], nf=4000.0, nq=0.7, nt=0.0008)
    return dict(bells=[bell(1470.0), bell(1003.0)],
                open=dict(A=[1.0, 1.0], W=[pad(-200.0), pad(-200.0)], G=[pad(1.0), pad(1.0)], **base),
                mute=dict(A=[1.0, 1.0], W=[pad(-200.0), pad(-200.0)], G=[pad(1.0), pad(1.0)], **{**base, "kp": 0.3, "tau": [1.5, 1.5]}))


def load_tables():
    return json.load(open(TABLES_PATH)) if os.path.exists(TABLES_PATH) else default_tables()


# peak at velocity 1, Volume 0 dB (dBFS). The previews are peak-normalised, so these are a judgement; tests/calibrate.py sets each stroke's A to hit them.
PEAK_DB = {"open": -4.0, "mute": -8.0}

# (name, long name, min, max, default, unit, hover text). Names are the gen~ Params; menus have unit None.
PARAMS = [
    ("bell", "Bell", 0, 1, 0, None, "Which bell of the pair: High (the small one, open tone about 1470 Hz) or Low (the large one, about 1000 Hz). Any MIDI note plays it."),
    ("stroke", "Stroke", 0, 1, 0, None, "Which stroke a note plays: Open (the stick hits the bell and it rings) or Mute (the other hand holds the bell: a short, dull tick). "
                                         "Changing it between hits works: a Mute hit also stops the ring already on the bell."),
    ("tune", "Tune", -12, 12, 0, "st", "Tuning of the bell in semitones. 0 is the recorded bell (High about 1470 Hz, Low about 1000 Hz); +-12 reaches the other agogos."),
    ("decay", "Decay", 30, 300, 100, "pct", "How long the bell rings, in percent of the natural time (High about 1.3 s, Low about 0.5 s to fall 60 dB)."),
    ("tone", "Tone", 0, 100, 50, "pct", "Brightness of the bell: tilts the strength of the overtones against the fundamental (+-6 dB per octave at the ends). 50 % is the recording."),
    ("touch", "Touch", 0, 100, 50, "pct", "Hardness of the stick: harder is brighter, louder and clickier; velocity does the same."),
    ("vary", "Vary", 0, 100, 100, "pct", "How much every hit differs from the last: the loudness of each of the bell's tones is nudged at random at every hit (about 1.5 dB at 100 %), as no two "
                                          "real strokes are the same. 0 plays the same hit every time."),
    ("volume", "Volume", -36, 6, -9, "db", "Output level."),
]
EXTERNAL = [("trg", 0), ("vel", 1)]


def sel(expr, values):
    """arithmetic select: (|expr - 0| < 0.5) * v0 + (|expr - 1| < 0.5) * v1 + ..."""
    return " + ".join(f"(abs({expr} - {i}) < 0.5) * {v:.6f}" for i, v in enumerate(values))


def svf_coefs(n, g, k):
    return f"{n}a1 = 1 / (1 + {g} * ({g} + {k})); {n}a2 = {g} * {n}a1; {n}a3 = {g} * {n}a2;"


def code(tables=None, cal=None, jitter=JITTER_DB):  # noqa: C901
    T = tables or load_tables()
    S = [T[s] for s in STROKES]
    B = T["bells"]
    cal = cal or {}
    F1 = [b["f1"] for b in B]

    def per(f):         # 2 x NSTROKE values, bell-major, for sel(vk, ...)
        return [f(d, i) for d in range(2) for i in range(NSTROKE)]

    def per_stroke(key):
        return [S[i][key] for i in range(NSTROKE)]

    out = [f"Param {n}({d});" for n, d in [(p[0], p[4]) for p in PARAMS] + EXTERNAL]
    out += ["History cnt(0);", "History pt(0);", "History vC(0);", "History vCk(0.99);", "History vE1(0);",
            "History vE2(0);", "History vK(0.5);", "History vNe(0);", "History vNr(0.99);", "History vI1(0);", "History vI2(0);",
            "History vNa1(0);", "History vNa2(0);", "History vNa3(0);", "History vNk(1);", "History vAm(0);", "History vF1(1470);", "History vAe(0);", "History vTa(0.9);"]
    for m in range(NS):
        out += [f"History vX{m}(0);", f"History vY{m}(0);", f"History vW{m}(0);", f"History vG{m}(1);", f"History vCc{m}(1);",
                f"History vSn{m}(0);", f"History vR{m}(0.999);"]
    out.append("""
decayS = decay * 0.01;
toneT = (tone - 50) * 0.02 * 6 / 6.0206;                      // +-6 dB per octave of mode ratio at the ends
touchT = (touch - 50) * 0.02;
masterG = dbtoa(volume);""")
    out.append(f"cnt = cnt + 1; ctl = cnt >= {CTL}; cnt = cnt - ctl * {CTL};")
    out.append("nz = noise();")
    out.append("vh = trg != pt; pt = trg;")
    hit = ["vds = stroke;                                         // History-derived: the stroke and velocity at the hit",
           "vdv = vel;",
           f"vk = bell * {NSTROKE} + vds;",
           "vg = pow(vdv, 1.4);",
           "vJs = nz * 1000 + trg; vJv = vary * 0.01;",
           f"vAm = vg * ({sel('vk', per(lambda d, i: S[i]['A'][d] * cal.get(i, 1.0)))});",
           "vAe = 1; vTa = exp(-1 / ((" + sel('vk', per(lambda d, i: S[i]['ta'][d])) + ") * samplerate));",
           f"vfc = ({sel('vds', per_stroke('fc'))}) * exp2(touchT * 1.5 + (vdv - 0.6) * 0.8);",
           "vK = 1 - exp(-twopi * min(vfc, 18000) / samplerate);",
           "vC = 1;",
           f"vCk = exp(-{CTL} / (({sel('vk', per(lambda d, i: S[i]['tau'][d]))}) * samplerate));",
           f"vNe = vAm * ({sel('vk', per(lambda d, i: S[i]['nl'][d]))}) * (1 + touchT);",
           f"vNr = exp(-1 / (({sel('vds', per_stroke('nt'))}) * samplerate));",
           f"vNg = tan(pi * ({sel('vds', per_stroke('nf'))}) / samplerate); vNk = 1 / ({sel('vds', per_stroke('nq'))});",
           svf_coefs("vN", "vNg", "vNk")]
    for m in range(NS):
        ws = [db(S[i]["W"][d][m]) for d in range(2) for i in range(NSTROKE)]
        gs = [S[i]["G"][d][m] for d in range(2) for i in range(NSTROKE)]
        tilt = f" * exp(toneT * ({sel('bell', [math.log(B[d]['r'][m]) for d in range(2)])}))"
        jit = f" * exp({jitter * math.sqrt(3) * LN60 / 60:.6f} * vJv * (fract(sin(vJs + {m * 78.233}) * 43758.5453) * 2 - 1))" if jitter else ""
        hit.append(f"vW{m} = ({sel('vk', ws)}){tilt}{jit}; vG{m} = {sel('vk', gs)};")
    hit.append(f"vkp = {sel('vk', per(lambda d, i: S[i]['kp']))};")
    for m in range(NS):
        hit.append(f"vX{m} = vX{m} * vkp; vY{m} = vY{m} * vkp;")
    out.append("vAm = 0;")
    out.append("if (vh > 0.5) {\n" + "\n".join(hit) + "\n}")
    out.append("vE1 = vE1 + vK * (vAm - vE1); vE2 = vE2 + vK * (vE1 - vE2);")
    ctl = ["vC = vC * vCk;", f"vF1 = ({sel('bell', F1)}) * exp2(tune / 12);"]
    for m in range(NS):
        ctl.append(f"vw = twopi * vF1 * ({sel('bell', [B[d]['r'][m] for d in range(2)])}) / samplerate; vCc{m} = cos(vw); vSn{m} = sin(vw); "
                   f"vR{m} = exp(-{LN60} * (1 + (vG{m} - 1) * vC) / (({sel('bell', [B[d]['t60'][m] for d in range(2)])}) * decayS * samplerate));")
    out.append("if (ctl) {\n" + "\n".join(ctl) + "\n}")
    for m in range(NS):
        ph = math.pi * PHASE_SPREAD * (((m + 1) * 0.6180339887) % 1.0 * 2 - 1)
        out.append(f"vXn = vR{m} * (vCc{m} * vX{m} - vSn{m} * vY{m}) + {math.cos(ph):.6f} * vW{m} * vE2; "
                   f"vY{m} = vR{m} * (vSn{m} * vX{m} + vCc{m} * vY{m}) + {math.sin(ph):.6f} * vW{m} * vE2; vX{m} = vXn;")
    out.append("vAe = vAe * vTa;                                      // the modes' tone swells in over `ta` (a soft contact) while the tick starts at once")
    out.append("vSm = (1 - vAe) * (" + " + ".join(f"vY{m}" for m in range(NS)) + ");")
    out.append("vNx = nz * vNe; vNe = vNe * vNr;")
    out.append("vNv3 = vNx - vI2; vNb = vNa1 * vI1 + vNa2 * vNv3; vNl = vI2 + vNa2 * vI1 + vNa3 * vNv3; "
               "vI1 = 2 * vNb - vI1; vI2 = 2 * vNl - vI2;")
    out.append("vmix = (vSm + vNk * vNb) * masterG;")
    out.append("vax = abs(vmix); vlim = sign(vmix) * (min(vax, 0.8) + 0.2 * tanh(max(vax - 0.8, 0) * 5));")
    out.append("out1 = vlim + 0 * in1; out2 = vlim + 0 * in2;")
    return "\n".join(out) + "\n"


if __name__ == "__main__":
    print(code())
