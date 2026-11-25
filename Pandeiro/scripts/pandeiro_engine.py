"""pandeiro_engine.py -- gen~ GenExpr code for Pandeiro: ONE instrument per instance, a Pandeiro (frame-drum head + jingles / platinelas) or a Tamborim
(small tight head, no jingles, played with a stick). The stroke is chosen at run time. See docs/SPEC.md (what the recordings show, decisions) and README.md.

Two layers, both here:
  head   Bongo's modal head, forked (bongo_engine.py): NH damped resonators at ratios of the head's pitch f1 (measured from the Latin Percussion previews,
         tests/refs.py), one fixed 125 Hz body tone, NB decaying band-passed noise bands (above ~2 kHz the recordings are flat noise), a contact pulse through two
         one-poles, a band-passed noise tick, the hand damping what already rings (kp, G, tau). Per-instrument mode sets, per-instrument noise-band T60s.
  jingle Shaker's PhISEM engine (Shaker/scripts/shaker_engine.py: stroke energy -> collisions at a rate that follows the energy -> a decaying sound level on
         noise -> 4th-order high-pass + three band-passes), one constant set for the platinelas (pandeiro_jingle.json, fitted by tests/jingle_fit.js to the
         Shake and Roll recordings). Every head hit energises it (row coupling jg, build-up jk ms, decay multiplier js); the Shake stroke is only that.
         Its filter coefficients are computed in the control block, not per sample. Jingles (the control) x JG[instrument] is its level: the tamborim has none.
Rows (the fitted table entries, pandeiro_tables.json): pan_thumb, pan_finger, pan_slap, pan_rim, pan_shake, tam_open, tam_mute, tam_finger.
The Stroke menu is one fixed list (MENU); MAP[instrument][menu] says which row a menu entry plays on each instrument (a fallback where the instrument has no such
stroke). Roll is the instrument's Finger row repeated ROLL_N times ROLL_GAP s apart (the Latin Percussion "Roll" is ~18 rapid finger taps a second for 1.1 s).

First-compile trap: no ternary / max / min / clamp on an expression that depends only on Params at the top level. Everything derived from the Params
`stroke`, `inst`, `vel`, `jingles` lives inside the hit block (multiplied by vh, a comparison of the counter `trg` with a History).
"""
import json
import math
import os

HERE = os.path.dirname(os.path.abspath(__file__))
INSTRUMENTS = ["Pandeiro", "Tamborim"]
# the table rows: (instrument, key, label)
ROWS = [(0, "pan_thumb", "Thumb"), (0, "pan_finger", "Finger"), (0, "pan_slap", "Slap"), (0, "pan_rim", "Rim"), (0, "pan_shake", "Shake"),
        (1, "tam_open", "Open"), (1, "tam_mute", "Mute"), (1, "tam_finger", "Finger")]
NROW = len(ROWS)
KEYS = [r[1] for r in ROWS]
MENU = ["Thumb", "Finger", "Slap", "Rim", "Shake", "Roll", "Open", "Mute"]          # the Stroke menu: one fixed list (what Live stores reliably)
ROLL = 5
# MAP[instrument][menu entry] = row. A stroke the instrument has not is mapped to the nearest one it has (documented in docs/SPEC.md):
#   Pandeiro: Open -> Thumb (the open bass stroke), Mute -> Finger (the shortest); Tamborim: Thumb / Slap / Rim -> Open, Shake / Roll -> Finger, Finger -> Finger.
MAP = [[0, 1, 2, 3, 4, 1, 0, 1],
       [5, 7, 5, 5, 7, 7, 5, 6]]
ROW_MENU = [(0, 0), (0, 1), (0, 2), (0, 3), (0, 4), (1, 6), (1, 7), (1, 1)]   # (instrument, menu entry) that plays each row as itself
ROLLROW = [1, 7]                       # the row a Roll repeats: that instrument's Finger
ROLL_N = 20                            # taps in a Roll (1.1 s at ROLL_GAP, as the recording)
ROLL_GAP = 1 / 18.2                    # s: the recording's tap rate is a clear 18.2 Hz line in its 0.15-4 kHz envelope (tests/jingle_probe.py)
ROLL_REL = [0.194, 0.6]                # per instrument: a Roll's taps x the velocity. Pandeiro fitted (tests/fit.py roll): the recording's taps are 19 dB under its jingles; Tamborim a judgement (no recording)
ROLL_REL_MUSICAL, ROLL_J_MUSICAL = [0.149, 0.6], 14.35     # the Musical device's frozen Roll constants (fit.py roll --write patches ROLL_REL / ROLL_J, the kit's, not these)
ROLL_J = 9.93                          # the jingles' extra level in a Roll (the recording's roll is jingle-heavy: its 7-15 kHz sits 19 dB over its 150-900 Hz; fitted: tests/fit.py roll)
JG = [1.0, 0.0]                        # per instrument: the Jingles control's reach (a tamborim has no jingles: the control does nothing there)
F1 = [250.0, 450.0]                    # the open tone at Tune 0 (Hz), the strongest pooled peaks of the previews
# head modes per instrument: (ratio to f1, T60 s), from the peaks of the pooled head-stroke spectra (docs/SPEC.md "Modes") and band-envelope slopes
HEAD = [[(0.56, 0.20), (1.00, 0.28), (1.16, 0.26), (1.27, 0.26), (1.38, 0.25), (1.59, 0.24), (1.80, 0.60), (2.00, 0.24), (2.50, 0.20), (3.00, 0.17), (3.80, 0.17), (5.80, 0.15)],
        [(0.65, 0.25), (0.86, 0.25), (1.00, 0.50), (1.08, 0.35), (1.19, 0.30), (1.25, 0.30), (1.33, 0.25), (1.49, 0.25), (1.61, 0.35), (2.11, 0.55), (2.77, 0.30), (3.24, 0.25)]]
NH = len(HEAD[0])
assert len(HEAD[1]) == NH
BODY = (125.0, 0.06)
# decaying band-passed noise: centre Hz (shared), T60 s per instrument (from the band-envelope slopes of the recordings)
BAND_F = [2000, 2800, 4000, 5800, 8500]
BAND_T60 = [[0.10, 0.17, 0.10, 0.20, 0.25], [0.15, 0.13, 0.12, 0.07, 0.06]]   # x the row's `ns` (the stroke's own noise decay, tests/fit.py)
# the kit's own copies (the Musical device keeps BAND_F / BAND_T60 above): per instrument, tuned to the recordings' band-envelope curves (tests/fit_tail.py)
KIT_BAND_F = [list(BAND_F), [2000, 3200, 5000, 8000, 12500]]       # the tamborim's noise reaches 16 kHz in the recordings (the pandeiro's top two bands are the jingles', unused)
KIT_BAND_T60 = [list(BAND_T60[0]), [0.30] * len(BAND_F)]           # x the row's ns x S (tests/fit_tail.py)
NB = len(BAND_F)
NM = NH + 1 + NB
NB0 = NH + 1
NN0 = NB0
JOWN = 3                               # on the pandeiro the noise bands from this index up (5.8 and 8.5 kHz) belong to the jingles: their W stay off
NOISE_Q = 2.0
NOISE_SC = 5.0
JITTER_DB = 1.5
PHASE_SPREAD = 1.0
NOISE_RISE = 0.0003
LN60 = 6.907755279
CTL = 16
TABLES_PATH = os.path.join(HERE, "pandeiro_tables.json")
JINGLE_PATH = os.path.join(HERE, "pandeiro_jingle.json")
# the Musical device (code(musical=True)) reads frozen copies of the kit's fit / calibration data, taken before the kit was re-fitted for noisier tails: re-fitting the kit never moves it
TABLES_MUSICAL = os.path.join(HERE, "pandeiro_tables_musical.json")
JINGLE_MUSICAL = os.path.join(HERE, "pandeiro_jingle_musical.json")
# the kit's Roll (not the Musical device's): taps differ in level (exp(ROLL_JA x u), u uniform +-1) and in spacing (x (1 + ROLL_JT u)) as the recording's do (tap level std 3 dB, spacing std 26 ms),
# the last ROLL_FADE_N taps fall off by up to ROLL_FADE_DB, the final tap is ROLL_LAST x louder and its jingles ring ROLL_JS_END x longer (the recording fades 0.7-1.0 s, swells at 1.1 s, rings out to 1.7 s)
ROLL_JA, ROLL_JT, ROLL_FADE_N, ROLL_FADE_DB, ROLL_LAST, ROLL_JS_END = 0.6, 0.08, 6, 12.0, 1.6, 3.0
JDELAY = 0.002                         # s: the jingles answer a hit this long after it (the head has to move them: without it every stroke's first ms carries jingle noise the recordings' ticks lack)
JKEYS = ["rate", "sp", "sdec", "sys", "shk", "hp", "hq", "f0", "q0", "g0", "f1", "q1", "g1", "f2", "q2", "g2"]


def mode_freq(inst, m, tune_st=0.0):
    if m < NH:
        return F1[inst] * 2 ** (tune_st / 12) * HEAD[inst][m][0]
    return BODY[0] if m == NH else KIT_BAND_F[inst][m - NB0]


def db(x):
    return 10 ** (x / 20.0)


def default_tables():
    seeds = {   # fc contact bandwidth, tau damping time, kp survival of the ring, noise: level, centre Hz, Q, decay s; jg jingle coupling, jk build ms, js decay multiplier, ns noise-band decay multiplier; kit only: S per mode T60 multiplier, jq the jingles' late-fall time in ms (1e5 = off: energy x exp(-(t / jq)^2))
        "pan_thumb":  dict(fc=2500, tau=0.06, ta=0.0005, kp=0.7, nl=0.05, nf=2500, nq=0.7, nt=0.0008, jg=1.0, jk=2.0, js=1.0, ns=1.0),
        "pan_finger": dict(fc=3000, tau=0.05, ta=0.0005, kp=0.6, nl=0.05, nf=3000, nq=0.7, nt=0.0008, jg=1.0, jk=2.0, js=1.0, ns=1.0),
        "pan_slap":   dict(fc=6000, tau=0.05, ta=0.0005, kp=0.5, nl=0.2, nf=4000, nq=0.7, nt=0.0008, jg=1.0, jk=2.0, js=1.0, ns=1.0),
        "pan_rim":    dict(fc=6000, tau=0.06, ta=0.0005, kp=0.7, nl=0.2, nf=4000, nq=0.7, nt=0.0008, jg=1.0, jk=2.0, js=1.0, ns=1.0),
        "pan_shake":  dict(fc=2000, tau=0.05, ta=0.0005, kp=1.0, nl=0.01, nf=3000, nq=0.7, nt=0.0008, jg=3.0, jk=20.0, js=1.0, ns=1.0),
        "tam_open":   dict(fc=6000, tau=0.03, ta=0.0003, kp=0.8, nl=0.2, nf=3000, nq=0.7, nt=0.0008, jg=0.0, jk=2.0, js=1.0, ns=1.0),
        "tam_mute":   dict(fc=5000, tau=0.03, ta=0.0003, kp=0.4, nl=0.2, nf=3000, nq=0.7, nt=0.0008, jg=0.0, jk=2.0, js=1.0, ns=1.0),
        "tam_finger": dict(fc=4000, tau=0.03, ta=0.0003, kp=0.5, nl=0.2, nf=3000, nq=0.7, nt=0.0008, jg=0.0, jk=2.0, js=1.0, ns=1.0),
    }
    return {k: dict(A=1.0, W=[-10.0] * NM, G=[1.0] * NM, S=[1.0] * NM, jq=1e5, **seeds[k]) for k in KEYS}


def load_tables(musical=False):
    if musical:
        return json.load(open(TABLES_MUSICAL))
    return json.load(open(TABLES_PATH)) if os.path.exists(TABLES_PATH) else default_tables()


def default_jingle():
    return dict(rate=8000.0, sp=0.3, sdec=2.0, sys=60.0, shk=5.0, hp=5000.0, hq=0.6, f0=8000.0, q0=2.0, g0=0.6, f1=11000.0, q1=3.0, g1=1.0, f2=14000.0, q2=3.0, g2=0.6)


def load_jingle(musical=False):
    if musical:
        return json.load(open(JINGLE_MUSICAL))
    return json.load(open(JINGLE_PATH)) if os.path.exists(JINGLE_PATH) else default_jingle()


# peak at velocity 1, Volume 0 dB (dBFS) per row: previews are peak-normalised, so these are a judgement; tests/calibrate.py sets each row's A and jg to hit them
PEAK_DB = {"pan_thumb": -5.0, "pan_finger": -7.0, "pan_slap": -3.0, "pan_rim": -5.0, "pan_shake": -8.0, "tam_open": -4.0, "tam_mute": -6.0, "tam_finger": -7.0}

PARAMS = [
    ("inst", "Instrument", 0, 1, 0, None, "Which instrument: Pandeiro (a frame-drum head with jingles, the platinelas) or Tamborim (a small tight head played with a stick, no jingles). Any MIDI note plays it."),
    ("stroke", "Stroke", 0, 7, 0, None, "Which stroke a note plays. Pandeiro: Thumb (the open bass tone), Finger, Slap, Rim, Shake (the jingles alone, no head hit), Roll (about 18 rapid finger taps a second for 1.1 s). "
                                         "Tamborim: Open (the stick on the head), Mute (the hand damps it), Finger. A stroke an instrument does not have plays the nearest one it does (the panel shows which). "
                                         "Changing it between hits works: the new stroke damps the ring already on the head."),
    ("tune", "Tune", -12, 12, 0, "st", "Tuning of the head in semitones. 0 is the open tone of the recordings (Pandeiro 250 Hz, Tamborim 450 Hz). The 125 Hz body and the jingles do not move."),
    ("decay", "Decay", 30, 300, 100, "pct", "How long the head and the jingles ring, in percent of the natural time (a pandeiro head rings about a quarter of a second, the jingles a little longer)."),
    ("skin", "Skin", 0, 100, 50, "pct", "Brightness of the head: tilts the strength of the overtones against the fundamental. 50 % is the recording."),
    ("shell", "Shell", 0, 100, 50, "pct", "The body of the drum: how much the low 125 Hz thump speaks."),
    ("touch", "Touch", 0, 100, 50, "pct", "Hardness of the contact: harder is shorter and brighter and ticks more; velocity does the same."),
    ("press", "Press", 0, 12, 5, "st", "The mod wheel presses the head (a thumb leaning on it): this many semitones up at full wheel. The body and the jingles do not move."),
    ("vary", "Vary", 0, 100, 100, "pct", "How much every hit differs from the last: the loudness of each of the head's tones is nudged at random at every hit (about 1.5 dB at 100 %); the jingles and the noise differ every hit anyway. 0 repeats the same sinusoids."),
    ("jingles", "Jingles", 0, 100, 100, "pct", "How much the jingles (platinelas) answer every hit and the Shake. 0 is a bare head. The Tamborim has no jingles: here the control does nothing."),
    ("volume", "Volume", -36, 6, -9, "db", "Output level."),
]
EXTERNAL = [("trg", 0), ("vel", 1), ("mw", 0)]
EXTERNAL_MUSICAL = EXTERNAL + [("note", 60)]       # the Musical device: the MIDI key, set by pandeiro_midi_musical.js before every hit
MUSICAL_HELP = {   # the Musical device's hover texts that differ
    "inst": "Which instrument: Pandeiro (a frame-drum head with jingles, the platinelas) or Tamborim (a small tight head played with a stick, no jingles). The MIDI key sets the pitch of the head.",
    "tune": "Tuning of the head in semitones, added to the MIDI key: the head's fundamental is the key's pitch x 2^(Tune/12). The 125 Hz body and the jingles do not move.",
}
NOTES = [59, 69]                       # the Musical device's keys nearest each instrument's kit pitch (246.9 Hz for 250, 440 Hz for 450): what the tests play it at
FMAX = 0.45                            # Musical: a head mode above this x the sample rate is left out (it would fold back as an alias)


def sel(expr, values):
    """arithmetic select: (|expr - 0| < 0.5) * v0 + (|expr - 1| < 0.5) * v1 + ..."""
    return " + ".join(f"(abs({expr} - {i}) < 0.5) * {v:.6f}" for i, v in enumerate(values))


def svf_coefs(n, g, k):
    return f"{n}a1 = 1 / (1 + {g} * ({g} + {k})); {n}a2 = {g} * {n}a1; {n}a3 = {g} * {n}a2;"


def num(x):     # plain decimals only: exponent literals break the codebox
    s = f"{x:.10f}".rstrip("0")
    return s + "0" if s.endswith(".") else s


JHIST = ["vJa", "vJpa", "vJdn", "vJy1", "vJy2", "vJen", "vJsnd", "vJhx1", "vJhx2", "vJhz1", "vJhz2", "vJjx1", "vJjx2", "vJjz1", "vJjz2", "vJamp", "vJdE", "vJca", "vJrt", "vJsd", "vJgr", "vJsp",
         "vJhb", "vJh2", "vJh3"] + [f"vJ{k}{n}" for k in range(3) for n in ("x1", "x2", "z1", "z2", "b", "c1", "c2", "g")]


def jingle_ctl(c):
    """control-rate coefficients of the jingle layer (Shaker's): c(name) is the constant's expression (a number, or a Param name for tests/jingle_fit.js)"""
    L = [f"vJmsr = samplerate * 0.001; vJrt = {c('rate')} / samplerate; vJsp = {c('sp')}; vJsd = exp(-1 / ({c('sdec')} * vJmsr));",
         f"vJgx = {c('rate')} * {c('sdec')} * 0.001; vJgr = 1 / sqrt(0.36 * vJgx * vJgx + 0.2067 * vJgx);",
         "vJfmx = 0.42 * samplerate;",
         f"vJfh = {c('hp')}; vJfh = vJfh / pow(1 + pow(vJfh / vJfmx, 4), 0.25); vJwh = twopi * vJfh / samplerate; vJalh = sin(vJwh) / (2 * {c('hq')}); vJiah = 1 / (1 + vJalh); "
         "vJchh = cos(vJwh); vJhb = (1 + vJchh) * 0.5 * vJiah; vJh2 = 2 * vJchh * vJiah; vJh3 = (1 - vJalh) * vJiah;"]
    for k in range(3):
        L.append(f"vJfr = {c(f'f{k}')}; vJfr = vJfr / pow(1 + pow(vJfr / vJfmx, 4), 0.25); vJw = twopi * vJfr / samplerate; vJal = sin(vJw) / (2 * {c(f'q{k}')}); vJia = 1 / (1 + vJal); "
                 f"vJ{k}b = vJal * vJia; vJ{k}c1 = -2 * cos(vJw) * vJia; vJ{k}c2 = (1 - vJal) * vJia; vJ{k}g = {c(f'g{k}')};")
    return L


def jingle_hit(c, amp, k_ms, s_mult, delay=JDELAY, q_ms=None):
    """at a hit: the stroke's energy impulse `amp` (applied `delay` s later), build-up time k_ms (ms), decay multiplier s_mult (expressions); q_ms (kit): the late-fall time, ms"""
    L = [f"vJts = {c('sys')} * ({s_mult}) * vJmsr; vJash = ({k_ms}) * vJmsr;",
         f"vJdE = exp(-1 / vJts); vJca = 1 - exp(-1 / vJash); vJamp = 1 + 2.7 * vJash / vJts; vJpa = {amp}; vJdn = {delay} * samplerate;"]
    if q_ms:
        L.append(f"vJr = 1; vJqs = ({q_ms}) * vJmsr; vJqc = exp(-2 / (vJqs * vJqs));")
    return L


def jingle_sample(quad=False):
    """per sample: energy -> collisions -> sound level on noise -> filters; leaves the jingle signal in vJo. quad (kit): the energy's decay speeds up with time, x exp(-(t / q)^2)"""
    L = ["vJa = 0; if (vJdn > 0.5) { vJdn = vJdn - 1; if (vJdn < 0.5) { vJa = vJpa; } }",
         "vJy1 = vJy1 + vJca * (vJa * vJamp - vJy1); vJy2 = vJy2 + vJca * (vJy1 - vJy2);",
         "vJr = vJr * vJqc; vJen = fixdenorm(vJen * vJdE * vJr + vJy2); vJen = vJen * (vJen > 0.000000001);" if quad else
         "vJen = fixdenorm(vJen * vJdE + vJy2); vJen = vJen * (vJen > 0.000000001);",
         "vJpe = vJen * (vJen < 1) + (vJen >= 1); vJp = vJrt * (1 - vJsp + vJsp * vJpe); vJcl = abs(noise()) < vJp;",
         "vJsnd = fixdenorm(vJsnd * vJsd + vJcl * vJen * vJgr * (0.2 + 0.8 * abs(noise()))); vJsnd = vJsnd * (vJsnd > 0.000000001); vJraw = vJsnd * noise();",
         "vJhh = vJhb * (vJraw - 2 * vJhx1 + vJhx2) + vJh2 * vJhz1 - vJh3 * vJhz2; vJhx2 = vJhx1; vJhx1 = vJraw; vJhz2 = fixdenorm(vJhz1); vJhz1 = fixdenorm(vJhh);",
         "vJin = vJhb * (vJhh - 2 * vJjx1 + vJjx2) + vJh2 * vJjz1 - vJh3 * vJjz2; vJjx2 = vJjx1; vJjx1 = vJhh; vJjz2 = fixdenorm(vJjz1); vJjz1 = fixdenorm(vJin);",
         "vJo = 0;"]
    for k in range(3):
        L.append(f"vJyy = vJ{k}b * (vJin - vJ{k}x2) - vJ{k}c1 * vJ{k}z1 - vJ{k}c2 * vJ{k}z2; vJ{k}x2 = vJ{k}x1; vJ{k}x1 = vJin; vJ{k}z2 = fixdenorm(vJ{k}z1); vJ{k}z1 = fixdenorm(vJyy); "
                 f"vJo = vJo + vJyy * vJ{k}g;")
    return L


def jingle_fit_code():
    """a stand-alone gen~ code: only the jingle layer, every constant a Param c_<name>, `trg` / `vel` as the hit (for tests/jingle_fit.js). Same statements as the full engine."""
    c = lambda n: f"c_{n}"  # noqa: E731
    d = default_jingle()
    out = [f"Param {n}({num(v)});" for n, v in [("trg", 0), ("vel", 1)] + [(f"c_{k}", d[k]) for k in JKEYS]]
    out += ["History pt(0);", "History vh1(0);", "History vJts(1);", "History vJash(1);", "History vJmsr(48);", "History vJo(0);", "History vJhh(0);", "History vJin(0);",
            "History vJpe(0);", "History vJp(0);", "History vJcl(0);", "History vJraw(0);", "History vJyy(0);", "History vJfh(0);", "History vJwh(0);", "History vJalh(0);",
            "History vJiah(1);", "History vJchh(0);", "History vJfmx(0);", "History vJfr(0);", "History vJw(0);", "History vJal(0);", "History vJia(0);", "History vJgx(0);"]
    out += [f"History {n}(0);" for n in JHIST]
    out.append("vh1 = trg != pt; pt = trg;")
    out += jingle_ctl(c)
    out.append("if (vh1 > 0.5) {")
    out += jingle_hit(c, "vel", "c_shk", "1", delay=0.00003)
    out.append("}")
    out += jingle_sample()
    out.append("out1 = vJo; out2 = vJo + 0 * in1;")
    return "\n".join(out) + "\n"


def code(tables=None, cal=None, jitter=JITTER_DB, jingle=None, musical=False):  # noqa: C901
    """musical: the Musical device. The head's fundamental is mtof(note) x 2^(Tune/12) instead of F1[inst] x 2^(Tune/12) (the jingles, body and noise bands do not follow the key),
    modes above FMAX x the sample rate are left out, and the tables / jingle constants are the frozen copies (TABLES_MUSICAL, JINGLE_MUSICAL)."""
    T = tables or load_tables(musical)
    R = [T[k] for k in KEYS]
    J = jingle or load_jingle(musical)
    jc = lambda n: num(J[n])  # noqa: E731
    cal = cal or {}
    ROWINST = [r[0] for r in ROWS]
    BF = [BAND_F, BAND_F] if musical else KIT_BAND_F        # noise-band centres per instrument (the kit's own, or the frozen ones)
    BT = BAND_T60 if musical else KIT_BAND_T60
    bfsel = lambda b: sel('inst', [BF[d][b] for d in range(2)])  # noqa: E731

    def per(key, f=lambda v: v):
        return [f(R[i][key]) for i in range(NROW)]

    out = [f"Param {n}({d});" for n, d in [(p[0], p[4]) for p in PARAMS] + (EXTERNAL_MUSICAL if musical else EXTERNAL)]
    out += ["History cnt(0);", "History pf(1);", "History pt(0);", "History vC(0);", "History vCk(0.99);", "History vE1(0);",
            "History vE2(0);", "History vK(0.5);", "History vNe(0);", "History vNr(0.99);", "History vI1(0);", "History vI2(0);",
            "History vNa1(0);", "History vNa2(0);", "History vNa3(0);", "History vNk(1);", "History vAm(0);", "History vF1(250);",
            "History vTd(1);", "History vNs(1);", "History vIt(0);", "History vP1(0);", "History vP2(0);", "History vFd(0);", "History vFv(0);", "History vRn(0);", "History vAe(0);", "History vTa(0.9);",
            "History vJts(1);", "History vJash(1);", "History vJmsr(48);", "History vJo(0);", "History vJhh(0);", "History vJin(0);", "History vJpe(0);", "History vJp(0);",
            "History vJcl(0);", "History vJraw(0);", "History vJyy(0);", "History vJfh(0);", "History vJwh(0);", "History vJalh(0);", "History vJiah(1);", "History vJchh(0);",
            "History vJfmx(0);", "History vJfr(0);", "History vJw(0);", "History vJal(0);", "History vJia(0);", "History vJgx(0);"]
    out += [f"History {n}(0);" for n in JHIST]
    if not musical:
        out += ["History vJr(1);", "History vJqc(1);"] + [f"History vSt{m}(1);" for m in range(NM)]
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
    out.append(f"vh1 = trg != pt; pt = trg;\nvh2 = 0;\nif (vFd > 0.5) {{ vFd = vFd - 1; vh2 = vFd < 0.5; }}\nvh = max(vh1, vh2 * (1 - vh1));")
    rowmap = " + ".join(f"(abs(inst - {i}) < 0.5) * (abs(stroke - {m}) < 0.5) * {MAP[i][m]}" for i in range(2) for m in range(len(MENU)))
    if musical:
        hit = [f"vr1 = vh1 * (abs(stroke - {ROLL}) < 0.5);                  // a Roll starts: this tap is the first of ROLL_N",
               f"vk = vh1 * ({rowmap}) + (1 - vh1) * ({sel('inst', ROLLROW)});   // the table row: the menu's (per instrument), or the Finger row for the taps of a Roll",
               f"vdv = vh1 * vel * (1 - vr1 * (1 - ({sel('inst', ROLL_REL_MUSICAL)}))) + (1 - vh1) * vFv;     // every tap of a Roll, the first too, is ROLL_REL x the velocity (the recording's roll has no louder first tap)",
               f"vRn = vr1 * {ROLL_N - 1} + (1 - vh1) * (vRn - 1);               // taps still to come",
               f"vFd = (vr1 + (1 - vh1) * (vRn > 0.5)) * {ROLL_GAP} * samplerate;   // a new stroke (vh1, no Roll) cancels the pending taps",
               "vFv = vr1 * vdv + (1 - vr1) * vFv;",
               "vg = pow(vdv, 1.4);",
               ]
    else:       # the kit: the Roll's taps are uneven (level and spacing), fade over the last ROLL_FADE_N taps, the last is louder and its jingles ring longer
        hit = [f"vr1 = vh1 * (abs(stroke - {ROLL}) < 0.5);                  // a Roll starts: this tap is the first of ROLL_N",
               f"vk = vh1 * ({rowmap}) + (1 - vh1) * ({sel('inst', ROLLROW)});   // the table row: the menu's (per instrument), or the Finger row for the taps of a Roll",
               f"vRn = vr1 * {ROLL_N - 1} + (1 - vh1) * (vRn - 1);               // taps still to come (0 at the last tap)",
               "vRt = vr1 + 1 - vh1;                                      // 1 for every tap of a Roll",
               f"vdv = vh1 * vel * (1 - vr1 * (1 - ({sel('inst', ROLL_REL)}))) + (1 - vh1) * vFv;     // every tap of a Roll, the first too, is ROLL_REL x the velocity",
               "vFv = vr1 * vdv + (1 - vr1) * vFv;",
               f"vRf = (vRn < {ROLL_FADE_N}) * ({ROLL_FADE_N} - vRn) / {ROLL_FADE_N};                  // 0 .. 1 over the last taps",
               f"vRs = exp({ROLL_JA} * noise() - {ROLL_FADE_DB * math.log(10) / 20:.6f} * vRf * vRf) * (1 + (vRn < 0.5) * {ROLL_LAST - 1:.6f});",
               "vdv = vdv * (1 + vRt * (vRs - 1));",
               f"vFd = (vr1 + (1 - vh1) * (vRn > 0.5)) * {ROLL_GAP} * samplerate * (1 + {ROLL_JT} * noise());   // a new stroke (vh1, no Roll) cancels the pending taps",
               "vg = pow(vdv, 1.4);",
               ]
    hit += [
           "vJs = nz * 1000 + trg; vJv = vary * 0.01;",
           f"vAm = vg * ({sel('vk', [R[i]['A'] * cal.get(i, 1.0) for i in range(NROW)])});",
           "vIm = vAm; vIt = vAm;",
           "vAe = 1; vTa = exp(-1 / ((" + sel('vk', per('ta')) + ") * samplerate));",
           f"vfc = ({sel('vk', per('fc'))}) * exp2(touchT * 1.5 + (vdv - 0.6) * 0.8);",
           "vK = 1 - exp(-twopi * min(vfc, 18000) / samplerate);",
           "vC = 1;",
           f"vCk = exp(-{CTL} / (({sel('vk', per('tau'))}) * samplerate));",
           f"vNe = vAm * ({sel('vk', per('nl'))}) * (1 + touchT);",
           f"vNr = exp(-1 / (({sel('vk', per('nt'))}) * samplerate));",
           f"vNg = tan(pi * ({sel('vk', per('nf'))}) / samplerate); vNk = 1 / ({sel('vk', per('nq'))});",
           svf_coefs("vN", "vNg", "vNk")]
    hit += jingle_hit(jc, f"vg * ({sel('vk', [R[i]['jg'] * cal.get(i, 1.0) for i in range(NROW)])}) * jingles * 0.01 * ({sel('inst', JG)}) * (1 + (vr1 + 1 - vh1) * {(ROLL_J_MUSICAL if musical else ROLL_J) - 1:.6f})",
                      sel('vk', per('jk')),
                      f"({sel('vk', per('js'))}) * decayS" if musical else f"({sel('vk', per('js'))}) * decayS * (1 + (1 - vh1) * (vRn < 0.5) * {ROLL_JS_END - 1:.6f})",
                      q_ms=None if musical else sel('vk', [R[i].get('jq', 1e5) for i in range(NROW)]))
    if musical:     # the head's fundamental now (the control block's vF1 is up to CTL samples behind a new note)
        hit.append("vFh = mtof(note) * exp2(tune / 12) * pf;")
    for m in range(NM):
        ws = [db(R[i]["W"][m]) for i in range(NROW)]
        gs = [R[i]["G"][m] for i in range(NROW)]
        if m < NH:
            tilt = f" * exp(skinT * ({sel('inst', [math.log(HEAD[d][m][0]) for d in range(2)])}))"
        elif m == NH:
            tilt = " * shellG"
        else:
            tilt = f" * exp(skinT * {math.log(BAND_F[m - NB0] / 345.0):.6f})" if musical else f" * exp(skinT * ({sel('inst', [math.log(BF[d][m - NB0] / 345.0) for d in range(2)])}))"
        jit = f" * exp({jitter * math.sqrt(3) * LN60 / 60:.6f} * vJv * (fract(sin(vJs + {m * 78.233}) * 43758.5453) * 2 - 1))" if jitter and m < NN0 else ""
        if musical and m < NH:
            tilt += f" * (vFh * ({sel('inst', [HEAD[d][m][0] for d in range(2)])}) < {FMAX} * samplerate)"
        hit.append(f"vW{m} = ({sel('vk', ws)}){tilt}{jit}; vG{m} = {sel('vk', gs)};" + ("" if musical else f" vSt{m} = {sel('vk', [R[i].get('S', [1.0] * NM)[m] for i in range(NROW)])};"))
    hit.append(f"vkp = {sel('vk', per('kp'))}; vNs = {sel('vk', per('ns'))};")
    for m in range(NM):
        hit.append(f"vX{m} = vX{m} * vkp; vY{m} = vY{m} * vkp;" if m < NN0 else
                   (f"vBe{m} = vBe{m} * vkp; vBg{m} = vW{m} * {NOISE_SC} / (1 + {BAND_F[m - NB0] ** 2} / (vfc * vfc));" if musical else
                    f"vBe{m} = vBe{m} * vkp; vBg{m} = vW{m} * {NOISE_SC} / (1 + ({bfsel(m - NB0)}) * ({bfsel(m - NB0)}) / (vfc * vfc));"))
    out.append("vIm = 0; vIt = 0;")
    out.append("if (vh > 0.5) {\n" + "\n".join(hit) + "\n}")
    out.append("vE1 = vE1 + vK * (vIm - vE1); vE2 = vE2 + vK * (vE1 - vE2);")
    ctl = ["vC = vC * vCk;", "vF1 = mtof(note) * exp2(tune / 12);" if musical else f"vF1 = ({sel('inst', F1)}) * exp2(tune / 12);"] + jingle_ctl(jc)
    for m in range(NM):
        if m < NH:
            ctl.append(f"vw = twopi * vF1 * pf * ({sel('inst', [HEAD[d][m][0] for d in range(2)])}) / samplerate; vCc{m} = cos(vw); vSn{m} = sin(vw); "
                       f"vR{m} = exp(-{LN60} * (1 + (vG{m} - 1) * vC) / (({sel('inst', [HEAD[d][m][1] for d in range(2)])}) * {'' if musical else f'vSt{m} * '}decayS * samplerate))"
                       + (f" * (vw < {2 * math.pi * FMAX:.6f});" if musical else ";"))
        elif m == NH:
            f, t60 = BODY
            ctl.append(f"vw = twopi * {f} / samplerate; vCc{m} = cos(vw); vSn{m} = sin(vw); vR{m} = exp(-{LN60 / t60:.6f} * (1 + (vG{m} - 1) * vC) / ({'' if musical else f'vSt{m} * '}decayS * samplerate));")
        else:
            b = m - NB0
            ctl.append((f"vBg = tan(pi * {BAND_F[b]} / samplerate); " if musical else f"vBg = tan(pi * ({bfsel(b)}) / samplerate); ") +
                       f"vBa1{m} = 1 / (1 + vBg * (vBg + {1 / NOISE_Q:.6f})); vBa2{m} = vBg * vBa1{m}; vBa3{m} = vBg * vBa2{m}; "
                       f"vR{m} = exp(-{LN60} * (1 + (vG{m} - 1) * vC) / (({sel('inst', [BT[d][b] for d in range(2)])}) * vNs * {'' if musical else f'vSt{m} * '}decayS * samplerate));")
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
    out += jingle_sample(quad=not musical)
    out.append("vmix = (vSm + vNk * vNb + vJo) * masterG;")
    out.append("vax = abs(vmix); vlim = sign(vmix) * (min(vax, 0.8) + 0.2 * tanh(max(vax - 0.8, 0) * 5));")
    out.append("out1 = vlim + 0 * in1; out2 = vlim + 0 * in2;")
    return "\n".join(out) + "\n"


if __name__ == "__main__":
    import sys
    print(jingle_fit_code() if "--jingle-fit-code" in sys.argv else code(musical="--musical" in sys.argv))
