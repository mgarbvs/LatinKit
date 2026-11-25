"""End-to-end checks of m4l/Shaker.amxd running in real standalone Max (needs Max, not Live), from a cold start: it loads and compiles,
every Type sounds at its calibrated level and has the spectrum / envelope tests/refs.json measured on the Ableton one-shots, direction
(odd notes quieter), Roll, back-to-back notes (the gate-collapse trap), parameters, pan, extremes.

    uv run --directory $MAXTEST_DIR python <repo>/Shaker/tests/test_max_render.py
The metrics here mirror tests/shaker_measure.js.
(Written while another agent owned Max; not yet run. The parent session runs it.)
"""
import json
import os
import subprocess
import sys

import numpy as np

sys.path.insert(0, os.environ["MAXTEST_DIR"])
import server  # noqa: E402
from analyze import read_wav  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
DEV = os.path.join(HERE, "../m4l/Shaker.amxd")
RESTART = os.path.join(HERE, "../scripts/max_restart.sh")
REFS = json.load(open(os.path.join(HERE, "refs.json")))
NAMES = ["Maraca", "Cabasa", "Shekere", "Ganza", "Egg"]
CAL_RMS = 0.25 * 10 ** (-6 / 20) * 100 / 127   # a vel-100 stroke at the default Level -6 dB: 10 ms RMS peak of the (L, R) magnitude
FAILS = []
BASE = {"Type": 0, "Beads": 100, "Damping": 100, "Shake": 100, "Rattle": 50, "Tone": 0, "Back": 70, "Roll": 0, "Direction": 0, "Pan": 0, "Level": -6}
BANDS = [0, 500, 1000, 2000, 4000, 6000, 8000, 12000, 16000, 24000]


def check(cond, what):
    print(("ok   " if cond else "FAIL ") + what)
    if not cond:
        FAILS.append(what)


def play(events, ms, **p):
    r = server.render(events, ms, params={**BASE, **p})
    x, sr = read_wav(r["wav"])
    return x, sr, r


def mag(x):
    return np.hypot(x[:, 0], x[:, 1])


def mov_rms(x, w):
    cs = np.concatenate([[0], np.cumsum(x ** 2)])
    h = w // 2
    i = np.arange(len(x))
    a, b = np.maximum(0, i - h), np.minimum(len(x), i - h + w)
    return np.sqrt((cs[b] - cs[a]) / np.maximum(1, b - a))


def stroke_metrics(x, sr, start):
    """metrics of the stroke starting near `start` (samples) in the stereo render x, as tests/shaker_measure.js: 10 ms RMS peak (of the
    L/R magnitude: its RMS is the true level), onset, t20 (ms from the peak to 20 dB down), the octave bands re total over the first
    100 ms and the centroid (of the L+R sum: NOT of the magnitude, which is rectified and full of low-frequency energy)"""
    seg = mag(x[start:start + int(0.9 * sr)])
    sig = (x[start:start + int(0.9 * sr), 0] + x[start:start + int(0.9 * sr), 1]) / np.sqrt(2)
    e10 = mov_rms(seg, int(0.010 * sr))
    pk, pi = float(e10.max()), int(np.argmax(e10))
    e5 = mov_rms(seg, int(0.005 * sr))
    on = int(np.argmax(e5 > pk * 10 ** (-26 / 20)))
    below = np.where(e10[pi:] < pk * 0.1)[0]
    t20 = below[0] / sr * 1000 if len(below) else np.inf
    w = sig[on:on + int(0.1 * sr)]
    w = w - w.mean()
    n = 1 << int(np.ceil(np.log2(max(8192, len(w)))))
    s = np.abs(np.fft.rfft(w, n)) ** 2
    f = np.fft.rfftfreq(n, 1 / sr)
    tot = s[1:].sum()
    bands = [10 * np.log10(s[(f >= lo) & (f < hi)].sum() / tot + 1e-12) for lo, hi in zip(BANDS[:-1], BANDS[1:])]
    return {"peak": pk, "rise": (pi - on) / sr * 1000, "t20": t20, "bands": bands, "cent": float((s[1:] * f[1:]).sum() / tot)}


def strokes(n=12, gap=1000, **p):
    """n separate forward strokes `gap` ms apart; returns a list of metrics (magnitude of L and R, so Pan doesn't matter)"""
    ev = [{"t": 100 + gap * k, "note": 60, "vel": 100, "dur": 40} for k in range(n)]
    x, sr, r = play(ev, 100 + gap * n + 200, **p)
    out = []
    for k in range(n):
        a = int((0.1 + gap / 1000 * k - 0.03) * sr)
        out.append(stroke_metrics(x, sr, a))
    return out, r


def mean_bands(L):
    return np.mean([m["bands"] for m in L], axis=0)


subprocess.run(["bash", RESTART], capture_output=True)
loaded = server.load_device(DEV)
errs = [l for l in loaded["console"] if "[1]" in l]
check(not errs, f"load_device console has no [1] errors ({len(errs)} found)")
for l in errs:
    print("     " + l)
names = {p["name"] for p in loaded["params"]}
check(set(BASE) <= names, f"all {len(BASE)} parameters exposed to Live (missing: {sorted(set(BASE) - names)})")

# 1. every Type: level, spectrum and envelope against what the references measured (ranges in tests/refs.json)
cents = []
for ti, name in enumerate(NAMES):
    L, r = strokes(12, Type=ti)
    pk = float(np.mean([m["peak"] for m in L]))
    d = 20 * np.log10(pk / CAL_RMS)
    check(r["nan_count"] == 0 and r["inf_count"] == 0 and abs(d) < 3, f"{name}: 10 ms RMS peak {pk:.3f} = {d:+.1f} dB from the calibrated {CAL_RMS:.3f}")
    ref = REFS[name]
    b = mean_bands(L)
    # bands the references have above -30 dB match within 6.5 dB; below that they sit on their recording noise floor, so ours may only not be above it
    bad = [(i, round(b[i], 1), ref["bands"][i]) for i in range(9) if b[i] > ref["bands"][i] + 6.5 or (ref["bands"][i] > -30 and b[i] < ref["bands"][i] - 6.5)]
    check(not bad, f"{name}: octave bands within 6.5 dB of the references (off: {bad or 'none'})")
    cent = float(np.mean([m["cent"] for m in L]))
    cents.append(cent)
    lo, hi = ref["cent"]
    check(0.85 * lo < cent < 1.15 * hi, f"{name}: centroid {cent:.0f} Hz, references {lo:.0f}-{hi:.0f}")
    t20 = float(np.mean([m["t20"] for m in L if np.isfinite(m["t20"])]))
    lo, hi = ref["t20"]
    check(0.6 * lo - 5 < t20 < 1.8 * hi + 5, f"{name}: t20 {t20:.0f} ms, references {lo:.0f}-{hi:.0f}")
check(len({round(c / 400) for c in cents}) >= 4, f"the five Types differ in colour (centroids {[round(c) for c in cents]})")

# 2. direction: odd notes are the back stroke, Back % of the level (and a little slower to build)
ev = [{"t": 100 + 1000 * k, "note": 60 + (k % 2), "vel": 100, "dur": 40} for k in range(16)]
x, sr, _ = play(ev, 17000)
pk = [stroke_metrics(x, sr, int((0.1 + k - 0.03) * sr))["peak"] for k in range(16)]
ratio = np.mean(pk[1::2]) / np.mean(pk[0::2])
check(0.5 < ratio < 0.85, f"back stroke (C#3) / forward (C3) = {ratio:.2f} at Back 70 %")
x, sr, _ = play([{"t": 100, "note": 61, "vel": 100, "dur": 40}], 800, Back=0)
check(float(np.abs(x).max()) < 1e-4, "Back 0 % silences the back stroke")

# Direction: Back makes C3 a back stroke; Forward makes C#3 a forward one; Alternate plays fwd, back, fwd, back on one note
def mp(**kw):
    ev = [{"t": 100 + 1000 * k, "note": 60, "vel": 100, "dur": 40} for k in range(16)]
    x, sr, _ = play(ev, 17000, **kw)
    return [stroke_metrics(x, sr, int((0.1 + k - 0.03) * sr))["peak"] for k in range(16)]
pb = mp(Direction=3); pf = mp(Direction=2); pa = mp(Direction=1)
check(0.5 < np.mean(pb) / np.mean(pf) < 0.85, f"Direction Back / Forward on C3: {np.mean(pb) / np.mean(pf):.2f}")
ra = np.mean(pa[1::2]) / np.mean(pa[0::2])   # it flips from the previous stroke (left by the Forward run), so which parity is back is not fixed
check(0.5 < min(ra, 1 / ra) < 0.85, f"Direction Alternate: every second C3 is a back stroke (odd/even {ra:.2f})")

# 3. Roll: a held note keeps shaking (and alternates), stops with the note, Roll 0 is one stroke
x, sr, _ = play([{"t": 100, "note": 60, "vel": 100, "dur": 800}], 1600, Roll=8)
m = mag(x)
check(float(m[int(0.6 * sr):int(0.9 * sr)].max()) > 0.4 * float(m.max()), "Roll 8 Hz: a held note is still shaking at 0.5-0.8 s")
check(float(m[int(1.15 * sr):].max()) < 0.1 * float(m.max()), "Roll stops at note-off")
x, sr, _ = play([{"t": 100, "note": 60, "vel": 100, "dur": 800}], 1600, Roll=0)
m = mag(x)
check(float(m[int(0.6 * sr):int(0.9 * sr)].max()) < 0.05 * float(m.max()), "Roll 0: one stroke per note, however long it is held")

# 4. back-to-back notes: note-off and the next note-on in one instant (gen~ sees only the last Param value per block: a counter, not a gate)
ev = [{"t": 100 + 100 * k, "note": 60, "vel": 100, "dur": 100} for k in range(6)]
x, sr, _ = play(ev, 1100, Damping=25, Shake=25)
m = mag(x)
pks = [float(m[int((0.1 + 0.1 * k) * sr):int((0.1 + 0.1 * k + 0.05) * sr)].max()) for k in range(6)]
check(min(pks) > 0.3 * max(pks), f"six strokes 100 ms apart on the same key, note-off meeting the next note-on: all sound (peaks {[round(p, 3) for p in pks]})")

# 5. parameters
NS = 16
base, _ = strokes(NS)
bm = float(np.mean([q["peak"] for q in base]))
for label, kw, fn, want in (
        ("Level 0 dB", {"Level": 0}, lambda L: np.mean([q["peak"] for q in L]) / bm, (1.7, 2.35)),
        ("Beads 400 % keeps the loudness", {"Beads": 400}, lambda L: np.mean([q["peak"] for q in L]) / bm, (0.7, 1.4)),
        ("Beads 25 % keeps the loudness", {"Beads": 25}, lambda L: np.mean([q["peak"] for q in L]) / bm, (0.7, 1.4)),
        ("Damping 400 % lengthens t20", {"Damping": 400}, lambda L: np.mean([q["t20"] for q in L]) / np.mean([q["t20"] for q in base]), (1.8, 6)),
        ("Damping 25 % shortens t20", {"Damping": 25}, lambda L: np.mean([q["t20"] for q in L]) / np.mean([q["t20"] for q in base]), (0.15, 0.6)),
        ("Shake 400 % slows the build", {"Shake": 400}, lambda L: np.mean([q["rise"] for q in L]) / np.mean([q["rise"] for q in base]), (1.5, 8)),
        ("Tone +12 st raises the centroid", {"Tone": 12}, lambda L: np.mean([q["cent"] for q in L]) / np.mean([q["cent"] for q in base]), (1.2, 3)),
        ("Tone -12 st lowers the centroid", {"Tone": -12}, lambda L: np.mean([q["cent"] for q in L]) / np.mean([q["cent"] for q in base]), (0.3, 0.85))):
    v = float(fn(strokes(NS, **kw)[0]))
    check(want[0] < v < want[1], f"{label}: x{v:.2f} (want {want[0]}..{want[1]})")
x, sr, _ = play([{"t": 100, "note": 60, "vel": 127, "dur": 40}], 600, Pan=-100)
check(float(np.abs(x[:, 1]).max()) < 1e-4 and float(np.abs(x[:, 0]).max()) > 0.05, "Pan -100 is left only")
x, sr, _ = play([{"t": 100, "note": 60, "vel": 127, "dur": 40}], 600, Pan=100)
check(float(np.abs(x[:, 0]).max()) < 1e-4 and float(np.abs(x[:, 1]).max()) > 0.05, "Pan +100 is right only")

# 6. extremes: every parameter at its minimum, then its maximum, all Types, a flurry of strokes
LIM = {"Beads": (25, 400), "Damping": (25, 400), "Shake": (25, 400), "Rattle": (0, 100), "Tone": (-12, 12), "Back": (0, 100), "Roll": (0, 16), "Direction": (0, 3),
       "Pan": (-100, 100), "Level": (-36, 6)}
for which in (0, 1):
    for ti in range(5):
        p = {k: v[which] for k, v in LIM.items()}
        ev = [{"t": 100 + 40 * k, "note": 60 + k % 2, "vel": 127, "dur": 30} for k in range(20)]
        x, sr, r = play(ev, 2500, Type=ti, **p)
        check(r["nan_count"] == 0 and r["inf_count"] == 0 and float(np.abs(x).max()) < 1.0001,
              f"{NAMES[ti]} with every parameter at {'max' if which else 'min'}: peak {float(np.abs(x).max()):.3f}, nan {r['nan_count']}, inf {r['inf_count']}")
play([{"t": 100, "note": 60, "vel": 100, "dur": 40}], 300)   # put the device back to the defaults

print(f"{len(FAILS)} FAILED" if FAILS else "all passed")
sys.exit(1 if FAILS else 0)
