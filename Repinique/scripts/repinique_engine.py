"""repinique_engine.py -- gen~ GenExpr code for Repinique: ONE samba repinique (a 10-12 inch metal-shell drum, played with one stick and one hand) whose stroke is chosen at run time.
See docs/SPEC.md for what the recordings show, docs/RESEARCH.md for the sources and README.md for usage. Forked from Repinique (same structure, tables, fit pipeline).

Modes are damped resonators (pinged 2-pole rotations), their set read from the BeppeB recordings (tests/refs.py):
  head modes   below SHELL_FROM Hz, at ratios of the head's pitch f1 = 356 Hz (the number the player tunes; Tune and the mod wheel move them)
  shell modes  from SHELL_FROM up, at FIXED Hz (the thin metal shell does not retune with the head: the same 733..2340 Hz peaks appear in every stroke), sinusoids
  noise bands  from BANDS up (2.6 kHz): the Rim / Rimshot highs are as flat as noise: decaying band-passed noise, new at every hit.
A stroke = a contact force pulse (an impulse through two one-pole low-passes: the contact time, set by the stroke, Touch and velocity) into the modes with per-stroke
gains W, plus a short band-passed noise tick. The hand damps what is already ringing: at the hit the ring is multiplied by kp (a Mute kills most of it, an Open
little), and for `tau` every mode's decay rate is multiplied by G[m]. Flam (stroke 5): two Open hits FLAM_GAP s apart, the second FLAM_REL x as loud (Bongo's).
There is no pitch glide: the recordings' head tone is flat (351 Hz in the first 40 ms, 356-357 Hz after).
Tables (scripts/repinique_tables.json) come from tests/fit.py (band profiles of the recordings) and tests/calibrate.py (levels).

First-compile trap: no ternary / max / min / clamp on an expression that depends only on Params at the top level. Everything derived from the Params
`stroke`, `vel` lives inside the hit block (multiplied by vh, a comparison of the counter `trg` with a History).
"""
import json
import math
import os

HERE = os.path.dirname(os.path.abspath(__file__))
STROKES = ["open", "rimshot", "rim", "hand", "mute"]
STROKE_MENU = ["Open", "Rimshot", "Rim", "Hand", "Mute", "Flam"]    # the menu adds the Flam (two Open hits)
NSTROKE = len(STROKES)
FLAM_STROKE = 5
FLAM_GAP = 0.042                       # s between the two hits of a flam (Bongo's median; no flam in these recordings: a judgement)
FLAM_REL = 0.45                        # the second hit's velocity relative to the first
F1 = 356.5                             # Hz: the head's open tone (352 Hz in the first 40 ms, 356-357 Hz from 0.1 s, in every Open and Hand take)
SHELL_FROM = 700.0                     # Hz: modes at or above are shell modes: fixed Hz
# modes: Hz at Tune 0, T60 s. Peaks of the pooled 0-0.3 s spectra of the four strokes (a mode appears in all of them at the same Hz); T60 from tests/t60.py (band-pass envelopes, median of the takes)
HZ = [(250, 0.37), (286, 0.42), (323, 0.40), (356, 0.50), (389, 0.28), (440, 0.24), (510, 0.25), (576, 0.50), (634, 0.40), (678, 0.30),
      (733, 0.25), (800, 0.40), (850, 0.35), (940, 0.50), (1117, 0.42), (1211, 0.35), (1363, 0.50), (1437, 0.38), (1616, 0.50), (1720, 0.43), (1855, 0.55), (2096, 0.42), (2340, 0.70)]
HEAD = [(hz / F1, t60) for hz, t60 in HZ]      # (ratio to f1, T60)
FIXED = [hz >= SHELL_FROM for hz, _ in HZ]
NH = len(HEAD)
# decaying band-passed noise: centre Hz, T60 s (fixed Hz). Q NOISE_Q
BANDS = [(2600, 0.38), (3300, 0.35), (4200, 0.33), (5400, 0.3), (7000, 0.25), (9500, 0.2)]
NB = len(BANDS)
NM = NH + NB
NB0 = NH                               # first noise band
NN0 = NB0                              # modes below this index are sinusoids
NOISE_Q = 2.0
NOISE_SC = 5.0                         # excitation of a noise band against a sinusoid's, times the contact's low-pass gain
JITTER_DB = 1.5                        # Vary 100 %: each sinusoid's gain x a random factor, uniform in dB with this standard deviation (a judgement)
PHASE_SPREAD = 0.35                     # each mode's excitation phase: pi x this x a fixed low-discrepancy value in -1..1 (0 = every mode starts as a sine)
NOISE_RISE = 0.0003                    # s: the noise bands' excitation goes through two one-poles of this time constant
LN60 = 6.907755279
CTL = 16
TABLES_PATH = os.path.join(HERE, "repinique_tables.json")


def mode_freq(m, tune_st=0.0):
    """nominal frequency of mode m (Hz): head modes follow Tune, shell modes and noise bands do not"""
    return (HZ[m][0] if FIXED[m] else F1 * 2 ** (tune_st / 12) * HEAD[m][0]) if m < NH else BANDS[m - NB0][0]


def db(x):
    return 10 ** (x / 20.0)


def default_tables():
    seeds = {   # fc contact bandwidth, tau damping time, ta tone swell, kp survival of the ring, noise: nl level, nf centre Hz, nq Q, nt decay s
        "open":    dict(fc=2500, tau=0.05, ta=0.001, kp=0.85, nl=0.1, nf=3000, nq=0.5, nt=0.0008),
        "rimshot": dict(fc=8000, tau=0.05, ta=0.0005, kp=0.7, nl=0.3, nf=3000, nq=0.5, nt=0.0008),
        "rim":     dict(fc=8000, tau=0.05, ta=0.0005, kp=0.7, nl=0.3, nf=3000, nq=0.5, nt=0.0008),
        "hand":    dict(fc=1500, tau=0.05, ta=0.002, kp=0.85, nl=0.1, nf=2000, nq=0.5, nt=0.0008),
        "mute":    dict(fc=1500, tau=0.1, ta=0.001, kp=0.1, nl=0.1, nf=2000, nq=0.5, nt=0.0008),
    }
    return {s: dict(A=1.0, W=[-10.0] * NM, G=[1.0] * NM, **seeds[s]) for s in STROKES}


def load_tables():
    return json.load(open(TABLES_PATH)) if os.path.exists(TABLES_PATH) else default_tables()


# peak at velocity 1, Volume 0 dB (dBFS). The recordings' levels are unknown (the takes' peaks vary 0.4..1.0 within a file), so these are a judgement: the rimshot is the loudest, the muted
# hand the quietest. tests/calibrate.py sets each stroke's A.
PEAK_DB = {"open": -4.0, "rimshot": -2.0, "rim": -5.0, "hand": -6.0, "mute": -11.0}

# (name, long name, min, max, default, unit, hover text). Names are the gen~ Params; menus have unit None.
PARAMS = [
    ("stroke", "Stroke", 0, 5, 0, None, "Which stroke a note plays: Open (stick in the middle of the head), Rimshot (stick on head and rim together: the crack, the repinique's signature), "
                                         "Rim (stick on the rim only), Hand (open hand on the head), Mute (the hand pressed on the head: a short dull thud; a judgement, not in the recordings) or "
                                         "Flam (two Open strokes, the second softer). Changing it between hits works: the new stroke damps the ring already on the head."),
    ("tune", "Tune", -12, 12, 0, "st", "Tuning of the head in semitones. 0 is the recorded drum's open tone, 356 Hz. The shell's own tones (above 700 Hz) stay where they are, as on a real drum."),
    ("decay", "Decay", 30, 300, 100, "pct", "How long the drum rings, in percent of the natural time (about 0.3 to 0.5 s per tone)."),
    ("skin", "Skin", 0, 100, 50, "pct", "Brightness of the head: tilts the strength of the overtones against the fundamental. 50 % is the recording."),
    ("touch", "Touch", 0, 100, 50, "pct", "Hardness of the contact: harder is brighter and ticks more; velocity does the same."),
    ("press", "Press", 0, 12, 5, "st", "The mod wheel presses the head (a hand leaning on it): this many semitones up at full wheel."),
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

    def per(key):
        return [S[i][key] for i in range(NSTROKE)]

    out = [f"Param {n}({d});" for n, d in [(p[0], p[4]) for p in PARAMS] + EXTERNAL]
    out += ["History cnt(0);", "History pf(1);", "History pt(0);", "History vC(0);", "History vCk(0.99);", "History vE1(0);",
            "History vE2(0);", "History vK(0.5);", "History vNe(0);", "History vNr(0.99);", "History vI1(0);", "History vI2(0);",
            "History vNa1(0);", "History vNa2(0);", "History vNa3(0);", "History vNk(1);", "History vAm(0);", "History vF1(356);",
            "History vIt(0);", "History vP1(0);", "History vP2(0);", "History vAe(0);", "History vTa(0.9);", "History vFd(0);", "History vFv(0);"]
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
    # hits: the counter, or the second stroke of a flam coming due (Bongo's scheme)
    out.append("vh1 = trg != pt; pt = trg;\nvh2 = 0;\nif (vFd > 0.5) { vFd = vFd - 1; vh2 = vFd < 0.5; }\nvh = max(vh1, vh2 * (1 - vh1));")
    hit = [f"vfl = vh1 * (abs(stroke - {FLAM_STROKE}) < 0.5);                  // a Flam starts as an Open and schedules its second hit",
           "vds = vh1 * stroke * (1 - vfl);                       // History-derived: the stroke and velocity at the hit (the flam's second hit is an Open: 0)",
           "vdv = vh1 * vel + (1 - vh1) * vFv;",
           f"vFd = vfl * {FLAM_GAP} * samplerate + (1 - vh1) * vFd; vFv = vfl * vdv * {FLAM_REL} + (1 - vfl) * vFv;",
           "vg = pow(vdv, 1.4);",
           "vJs = nz * 1000 + trg; vJv = vary * 0.01;",
           f"vAm = vg * ({sel('vds', [S[i]['A'] * cal.get(i, 1.0) for i in range(NSTROKE)])});",
           "vIm = vAm; vIt = vAm;",
           "vAe = 1; vTa = exp(-1 / ((" + sel('vds', per('ta')) + f") * samplerate));",
           f"vfc = ({sel('vds', per('fc'))}) * exp2(touchT * 1.5 + (vdv - 0.6) * 0.8);",
           "vK = 1 - exp(-twopi * min(vfc, 18000) / samplerate);",
           "vC = vC + (1 - vC) * vdv;                              // a soft hit does not restart the stroke's own damping (an Open over a ringing Open would slow its ring again)",
           f"vCk = exp(-{CTL} / (({sel('vds', per('tau'))}) * samplerate));",
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
    ctl = ["vC = vC * vCk;", f"vF1 = {F1} * exp2(tune / 12);"]
    for m in range(NM):
        if m < NH:
            fq = f"{HZ[m][0]}" if FIXED[m] else f"vF1 * pf * {HEAD[m][0]:.6f}"     # shell modes: fixed Hz
            ctl.append(f"vw = twopi * {fq} / samplerate; vCc{m} = cos(vw); vSn{m} = sin(vw); "
                       f"vR{m} = exp(-{LN60} * (1 + (vG{m} - 1) * vC) / ({HEAD[m][1]} * decayS * samplerate));")
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
