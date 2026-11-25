"""timbales_engine.py -- gen~ GenExpr code for Timbales: ONE timbal (High or Low) whose stroke is chosen at run time.
See docs/RESEARCH.md for the acoustics and README.md for usage.

A timbal here is two banks of damped resonators (pinged 2-pole rotations):
  head modes  NH, at ratios of the head's pitch f1 (the number the player tunes; Tune and the mod wheel move them),
  shell modes NS, at fixed frequencies in Hz (the thin metal shell does not retune with the head: the same ~430..8700 Hz peaks
              appear on both drums in the recordings), high-Q; from SHELL[NOISE_FROM] up they are decaying band-passed noise instead (see NOISE_FROM).
A stroke = a stick-contact force pulse (an impulse through two one-pole low-passes: the contact time, set by the stroke, Stick and
velocity) into both banks with per-stroke, per-drum mode gains W, plus a short band-passed noise burst (the stick's tick). A stroke
also damps what is already ringing: at the hit the head ring is multiplied by kph and the shell ring by kps (a cascara barely touches
the head; a muted stroke kills it), and for the contact time `tau` every mode's decay rate is multiplied by G[m].
Tables (scripts/timbales_tables.json) come from tests/fit.py (band profiles of the recordings) and tests/calibrate.py (levels).

First-compile trap: no ternary / max / min / clamp on an expression that depends only on Params at the top level. Everything derived
from the Params `stroke`, `drum`, `vel` lives inside the hit block (multiplied by vh, a comparison of the counter `trg` with a History).
"""
import json
import math
import os

HERE = os.path.dirname(os.path.abspath(__file__))
DRUMS = ["High", "Low"]
STROKES = ["open", "rimshot", "cascara", "paila", "rimclick", "muted"]
STROKE_MENU = ["Open", "Rimshot", "Cascara", "Paila", "Rim click", "Muted"]
F1 = [200.0, 120.0]                    # the head's open tone at Tune 0 (Hz): LP pack takes A B C High 199/195/217, Low 131/111/113
# head modes: ratio to f1, open-stroke T60 (s, High drum); Low rings T60_DRUM times longer. T60s are the recordings' per-band decays
# (open strokes, 60 ms on, docs/RESEARCH.md round 2); 830..1400 Hz on the High drum is shell-dominated there, so modes 4..7 taper by hand
HEAD = [(1.00, 0.5), (1.94, 0.9), (2.15, 0.9), (3.15, 0.7), (4.15, 0.6), (5.15, 0.5), (6.0, 0.45), (7.0, 0.4)]
T60_DRUM = [1.0, 3.0]
# shell modes: frequency (Hz), T60 (s, High drum; Low x SHELL_DRUM). Peaks of the averaged cascara/paila/rim recordings; T60 below 1.7 kHz is the
# cascara tail's (tonal, 0.8-1.2 s High, 1.6-2 s Low); above, decay climbs with frequency (Rossing et al. 1992 shell; the splash is gone by 150 ms)
SHELL = [(432, 1.0), (577, 1.0), (650, 1.0), (720, 1.0), (816, 1.0), (920, 1.0), (1090, 1.0), (1155, 1.0), (1330, 1.0),
         (1633, 0.9), (2100, 0.5), (2593, 0.35), (3400, 0.25), (4500, 0.18), (6535, 0.14), (8700, 0.1)]
SHELL_DRUM = [1.0, 1.8]
NH, NS = len(HEAD), len(SHELL)
NM = NH + NS
# the shell's modes from this index of SHELL up are noise-driven bands (a decaying band-passed noise, Q NOISE_Q) instead of sinusoids: a real shell's
# modes are dense there, and the recordings above 2.5 kHz are as flat as white noise (spectral flatness -3..-6 dB, sinusoids give -13..-25 dB)
NOISE_FROM = 11
NOISE_Q = 2.0
NOISE_SC = 5.0                         # excitation of a noise band against a sinusoid's, times the contact's low-pass gain (two poles at vfc, as vE2 gives the sinusoids)
NN0 = NH + NOISE_FROM                  # first noise mode
# per-hit variation: each sinusoid mode's gain gets a random factor at every hit (uniform in dB, this standard deviation at Vary 100 %). The A/B/C takes differ by 3-4 dB
# per mode (median), but they also differ in tuning and hand position, so this is a judgement: about 40 % of that. tests/fit.py fits with it off.
JITTER_DB = 1.5
NOISE_RISE = 0.0003                    # s: the noise bands' excitation goes through two one-poles of this time constant (rise about 1.9x it); the recordings' 10 % -> -3 dB rise is 0.9-3 ms
LN60 = 6.907755279
CTL = 16
TABLES_PATH = os.path.join(HERE, "timbales_tables.json")


def mode_freq(drum, m, tune_st=0.0):
    """nominal frequency of mode m on a drum (Hz)"""
    return F1[drum] * 2 ** (tune_st / 12) * HEAD[m][0] if m < NH else SHELL[m - NH][0]


def db(x):
    return 10 ** (x / 20.0)


def default_tables():
    def W(d):
        return [-6.0 - 4 * m if m < NH else -30.0 for m in range(NM)]
    seeds = {   # fc contact bandwidth, tau damping time, kph / kps survival of the ring, noise: level, centre Hz, Q, decay s
        "open":     dict(fc=2500, tau=0.05, kph=0.85, kps=0.9, nl=0.05, nf=3500, nq=0.5, nt=0.004),
        "rimshot":  dict(fc=6000, tau=0.06, kph=0.8, kps=0.7, nl=0.2, nf=4000, nq=0.5, nt=0.006),
        "cascara":  dict(fc=8000, tau=0.03, kph=0.97, kps=0.5, nl=0.2, nf=4600, nq=0.4, nt=0.005),
        "paila":    dict(fc=6000, tau=0.15, kph=0.95, kps=0.4, nl=0.1, nf=3000, nq=0.5, nt=0.005),
        "rimclick": dict(fc=5000, tau=0.5, kph=0.3, kps=0.7, nl=0.1, nf=3000, nq=0.5, nt=0.004),
        "muted":    dict(fc=2000, tau=0.5, kph=0.1, kps=0.8, nl=0.0, nf=2500, nq=0.5, nt=0.004),
    }
    def G(s, d):   # the rim click's stick rests on the rim and damps the shell; its one 0.23 s recording has no ring window to fit that from, so 3 (head too: the stick lies across it; times the drum's ring factor: the damping time is the stick's) is set by t20 (fit.py leaves it)
        return [3.0 * T60_DRUM[d] if s == "rimclick" else 1.0] * NH + [3.0 * SHELL_DRUM[d] if s == "rimclick" else 1.0] * NS
    return {s: dict(A=[1.0, 1.0], W=[W(0), W(1)], G=[G(s, 0), G(s, 1)], **seeds[s]) for s in STROKES}


def load_tables():
    return json.load(open(TABLES_PATH)) if os.path.exists(TABLES_PATH) else default_tables()


# peak at velocity 1, Volume 0 dB (dBFS). The previews are peak-normalised, so these are a judgement (cascara is the quiet stroke,
# rimshot the loudest); tests/calibrate.py sets each stroke's A to hit them. the Core Library one-shots are peak-normalised too (peaks 0 dBFS, +2 dB for some), so no level information exists anywhere.
PEAK_DB = {"open": -4.0, "rimshot": -1.5, "cascara": -7.0, "paila": -6.0, "rimclick": -8.0, "muted": -9.0}

# (name, long name, min, max, default, unit, hover text). Names are the gen~ Params; menus have unit None.
PARAMS = [
    ("drum", "Drum", 0, 1, 0, None, "Which timbal: High (the macho, small drum, open tone about 200 Hz) or Low (the hembra, about 120 Hz). Any MIDI note plays it."),
    ("stroke", "Stroke", 0, 5, 2, None, "Which stick stroke a note plays: Open (head, ringing), Rimshot (rim and head together, the crack), Cascara (stick on the shell "
                                        "near the top edge), Paila (stick on the middle of the shell), Rim click (stick across the head, against the rim) or Muted "
                                        "(stick pressed into the head). Changing it between hits works: the new stroke damps the ring already there."),
    ("tune", "Tune", -12, 12, 0, "st", "Tuning of the head in semitones. 0 is the drum's open tone (High 200 Hz, Low 120 Hz). The shell does not move."),
    ("decay", "Decay", 30, 300, 100, "pct", "How long the head rings, in percent of the natural time."),
    ("shell", "Shell", 0, 100, 50, "pct", "How loud the metal shell is: its ring is the cascara, and the metallic edge of every other stroke."),
    ("ring", "Ring", 30, 300, 100, "pct", "How long the metal shell rings, in percent of the natural time. Short is a dry cascara; long is a loose or ringing shell."),
    ("stick", "Stick", 0, 100, 50, "pct", "Hardness of the stick contact: harder is shorter and brighter and ticks more."),
    ("press", "Press", 0, 12, 5, "st", "The mod wheel presses the head (a hand or the stick leaning on it): this many semitones up at full wheel. The shell does not move."),
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

    def per(f):         # 12 values, drum-major, for sel(vk, ...)
        return [f(d, i) for d in range(2) for i in range(6)]

    def per_stroke(key):
        return [S[i][key] for i in range(6)]

    out = [f"Param {n}({d});" for n, d in [(p[0], p[4]) for p in PARAMS] + EXTERNAL]
    out += ["History cnt(0);", "History pf(1);", "History pt(0);", "History vC(0);", "History vCk(0.99);", "History vE1(0);",
            "History vE2(0);", "History vK(0.5);", "History vNe(0);", "History vNr(0.99);", "History vI1(0);", "History vI2(0);",
            "History vNa1(0);", "History vNa2(0);", "History vNa3(0);", "History vNk(1);", "History vAm(0);", "History vF1(200);",
            "History vTd(1);", "History vTs(1);", "History vP1(0);", "History vP2(0);"]
    for m in range(NM):
        out += [f"History vX{m}(0);", f"History vY{m}(0);", f"History vW{m}(0);", f"History vG{m}(1);", f"History vCc{m}(1);",
                f"History vSn{m}(0);", f"History vR{m}(0.999);"]
        if m >= NN0:
            out += [f"History vBe{m}(0);", f"History vBi1{m}(0);", f"History vBi2{m}(0);", f"History vBa1{m}(0);", f"History vBa2{m}(0);", f"History vBa3{m}(0);", f"History vBg{m}(0);"]
    out.append("""
decayS = decay * 0.01;
ringS = ring * 0.01;
shellG = shell * 0.02;
stickT = (stick - 50) * 0.02;
pfT = exp2(mw * press / 12);
masterG = dbtoa(volume);""")
    out.append(f"cnt = cnt + 1; ctl = cnt >= {CTL}; cnt = cnt - ctl * {CTL};\nif (ctl) {{ pf = pf + 0.2 * (pfT - pf); }}")
    out.append("nz = noise();")
    out.append("vh = trg != pt; pt = trg;")
    hit = ["vds = vh * stroke;                                   // History-derived: the stroke and velocity at the hit",
           "vdv = vh * vel;",
           "vk = drum * 6 + vds;",
           "vg = pow(vdv, 1.4);",
           "vJs = nz * 1000 + trg; vJv = vary * 0.01;",
           f"vAm = vg * ({sel('vk', per(lambda d, i: S[i]['A'][d] * cal.get(i, 1.0)))});",
           f"vfc = ({sel('vds', per_stroke('fc'))}) * exp2(stickT * 1.5 + (vdv - 0.6) * 0.8);",
           "vK = 1 - exp(-twopi * min(vfc, 18000) / samplerate);",
           "vC = 1;",
           f"vCk = exp(-{CTL} / (({sel('vds', per_stroke('tau'))}) * samplerate));",
           f"vNe = vAm * ({sel('vk', per(lambda d, i: S[i]['nl'] if not isinstance(S[i]['nl'], list) else S[i]['nl'][d]))}) * (1 + stickT);",
           f"vNr = exp(-1 / (({sel('vds', per_stroke('nt'))}) * samplerate));",
           f"vNg = tan(pi * ({sel('vds', per_stroke('nf'))}) / samplerate); vNk = 1 / ({sel('vds', per_stroke('nq'))});",
           svf_coefs("vN", "vNg", "vNk")]
    for m in range(NM):
        ws = [db(S[i]["W"][d][m]) for d in range(2) for i in range(6)]
        gs = [S[i]["G"][d][m] for d in range(2) for i in range(6)]
        jit = f" * exp({jitter * math.sqrt(3) * LN60 / 60:.6f} * vJv * (fract(sin(vJs + {m * 78.233}) * 43758.5453) * 2 - 1))" if jitter and m < NN0 else ""
        hit.append(f"vW{m} = ({sel('vk', ws)})" + (" * shellG" if m >= NH else "") + jit + f"; vG{m} = {sel('vk', gs)};")
    hit.append(f"vkh = {sel('vds', per_stroke('kph'))}; vks = {sel('vds', per_stroke('kps'))};")
    for m in range(NM):
        k = "vkh" if m < NH else "vks"
        hit.append(f"vX{m} = vX{m} * {k}; vY{m} = vY{m} * {k};" if m < NN0 else f"vBe{m} = vBe{m} * vks; vBg{m} = vW{m} * {NOISE_SC} / (1 + {SHELL[m - NH][0] ** 2} / (vfc * vfc));")
    out.append("vIm = 0;")
    hit.insert(hit.index("vJs = nz * 1000 + trg; vJv = vary * 0.01;") + 2, "vIm = vAm;")
    out.append("if (vh > 0.5) {\n" + "\n".join(hit) + "\n}")
    out.append("vE1 = vE1 + vK * (vIm - vE1); vE2 = vE2 + vK * (vE1 - vE2);")
    ctl = ["vC = vC * vCk;", f"vF1 = ({sel('drum', F1)}) * exp2(tune / 12);", f"vTd = {sel('drum', T60_DRUM)};", f"vTs = {sel('drum', SHELL_DRUM)};"]
    for m in range(NM):
        if m < NH:
            u, t60 = HEAD[m]
            ctl.append(f"vw = twopi * vF1 * pf * {u} / samplerate; vCc{m} = cos(vw); vSn{m} = sin(vw); "
                       f"vR{m} = exp(-{LN60 / t60:.6f} * (1 + (vG{m} - 1) * vC) / (decayS * vTd * samplerate));")
        else:
            f, t60 = SHELL[m - NH]
            r = f"vR{m} = exp(-{LN60 / t60:.6f} * (1 + (vG{m} - 1) * vC) / (ringS * vTs * samplerate));"
            if m < NN0:
                ctl.append(f"vw = twopi * {f} / samplerate; vCc{m} = cos(vw); vSn{m} = sin(vw); " + r)
            else:
                ctl.append(f"vBg = tan(pi * {f} / samplerate); vBa1{m} = 1 / (1 + vBg * (vBg + {1 / NOISE_Q:.6f})); vBa2{m} = vBg * vBa1{m}; vBa3{m} = vBg * vBa2{m}; " + r)
    out.append("if (ctl) {\n" + "\n".join(ctl) + "\n}")
    for m in range(NN0):
        out.append(f"vXn = vR{m} * (vCc{m} * vX{m} - vSn{m} * vY{m}) + vW{m} * vE2; "
                   f"vY{m} = vR{m} * (vSn{m} * vX{m} + vCc{m} * vY{m}); vX{m} = vXn;")
    out.append(f"vKn = 1 - exp(-1 / ({NOISE_RISE} * samplerate)); vP1 = vP1 + vKn * (vIm - vP1); vP2 = vP2 + vKn * (vP1 - vP2);")
    for m in range(NN0, NM):
        out.append(f"vBe{m} = vBe{m} * vR{m} + vBg{m} * vP2; vQ3 = nz * vBe{m} - vBi2{m}; vQb = vBa1{m} * vBi1{m} + vBa2{m} * vQ3; "
                   f"vQl = vBi2{m} + vBa2{m} * vBi1{m} + vBa3{m} * vQ3; vBi1{m} = 2 * vQb - vBi1{m}; vBi2{m} = 2 * vQl - vBi2{m}; vY{m} = vQb / {NOISE_Q};")
    out.append("vSm = " + " + ".join(f"vY{m}" for m in range(NM)) + ";")
    out.append("vNx = nz * vNe; vNe = vNe * vNr;")
    out.append("vNv3 = vNx - vI2; vNb = vNa1 * vI1 + vNa2 * vNv3; vNl = vI2 + vNa2 * vI1 + vNa3 * vNv3; "
               "vI1 = 2 * vNb - vI1; vI2 = 2 * vNl - vI2;")
    out.append("vmix = (vSm + vNk * vNb) * masterG;")
    out.append("vax = abs(vmix); vlim = sign(vmix) * (min(vax, 0.8) + 0.2 * tanh(max(vax - 0.8, 0) * 5));")
    out.append("out1 = vlim + 0 * in1; out2 = vlim + 0 * in2;")
    return "\n".join(out) + "\n"


if __name__ == "__main__":
    print(code())
