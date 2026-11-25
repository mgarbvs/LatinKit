"""End-to-end checks of m4l/CR78.amxd running in real standalone Max (needs Max, not Live): a cold start, every note, the table's
frequencies / decays / levels measured from the recorded WAV, the guiro gate, back-to-back notes, parameters, extremes, the TRIG chain.

    uv run --directory $MAXTEST_DIR python <repo>/CR78/tests/test_max_render.py
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
DEV = os.path.join(HERE, "../m4l/CR78.amxd")
RESTART = os.path.join(HERE, "../scripts/max_restart.sh")
sys.path.insert(0, os.path.join(HERE, "../scripts"))
import cr_engine as E  # noqa: E402

FAILS = []
PASSED = [0]


def check(cond, what, verbose=False):
    if cond:
        PASSED[0] += 1
        if verbose:
            print("ok   " + what)
    else:
        print("FAIL " + what)
        FAILS.append(what)


DEFAULTS = {n: d for _, n, _, _, _, d, *_ in E.PARAMS}
DIRTY = set()


def render(events, ms, params=None, name="render"):
    """server.render, first putting back the default of every parameter an earlier render changed (the device keeps them)"""
    params = dict(params or {})
    full = {n: DEFAULTS[n] for n in DIRTY if n not in params}
    DIRTY.update(params)
    return server.render(events, ms, params={**full, **params}, name=name)


def play(note, ms=500, params=None, extra=(), vel=100, dur=50, name=None):
    r = render([{"t": 100, "note": note, "vel": vel, "dur": dur}, *extra], ms, params=params, name=name or f"n{note}")
    x, sr = read_wav(r["wav"])
    return x, sr, r


def mono(x):
    return np.hypot(x[:, 0], x[:, 1])


def onset(m, thr=1e-3):
    return int(np.argmax(m > thr))


def zero_cross_freq(sig, sr, n_sec):
    """frequency of a damped sine from its zero crossings after the onset (regression of crossing time on index)"""
    s = sig[: int(n_sec * sr)]
    idx = np.where((s[:-1] <= 0) & (s[1:] > 0) | (s[:-1] >= 0) & (s[1:] < 0))[0][1:]
    t = (idx + s[idx] / (s[idx] - s[idx + 1])) / sr
    k = np.arange(len(t))
    return 0.5 / np.polyfit(k, t, 1)[0]


def fft_peak(sig, sr, f0, frac):
    n = 1 << 18
    s = np.abs(np.fft.rfft(sig * np.hanning(len(sig)), n))
    lo, hi = int(f0 * (1 - frac) * n / sr), int(f0 * (1 + frac) * n / sr)
    k = lo + int(np.argmax(s[lo:hi]))
    a, b, c = np.log(s[k - 1] + 1e-30), np.log(s[k] + 1e-30), np.log(s[k + 1] + 1e-30)
    return (k + 0.5 * (a - c) / (a - 2 * b + c)) * sr / n, s[k]


def decay10(m, sr, win_s):
    """time from the RMS envelope's peak to 1/10 of it"""
    w = max(2, int(win_s * sr))
    cs = np.concatenate([[0], np.cumsum(m ** 2)])
    env = np.sqrt((cs[w:] - cs[:-w]) / w)
    pk = int(np.argmax(env))
    below = np.where(env[pk:] <= 0.1 * env[pk])[0]
    return below[0] / sr if len(below) else np.inf


def cents(f, ref):
    return 1200 * np.log2(f / ref)


subprocess.run(["bash", RESTART], capture_output=True)
loaded = server.load_device(DEV)
errs = [l for l in loaded["console"] if "[1]" in l]
check(not errs, f"load_device console has no [1] errors ({len(errs)} found)")
for l in errs:
    print("     " + l)
names = {p["name"] for p in loaded["params"]}
need = {n for _, n, *_ in E.PARAMS}
check(need <= names, f"every engine parameter is exposed as a Live parameter (missing: {sorted(need - names)})")
print(f"     {len(names)} parameters, sr {loaded['sr']}")

# 1. every note sounds, at its table level: +-1 dB for the tonal voices; the noise voices and the cowbell (whose free-running oscillators
# meet each hit at a different phase) +-2 dB on the median of 7 hits
VPP = {36: 0.4, 37: 0.8, 38: 0.4, 42: 0.4, 44: 0.35, 49: 0.4, 54: 0.25, 56: 0.2, 60: 0.15, 61: 0.15, 64: 0.3, 70: 0.4, 73: 0.3, 74: 0.3, 75: 0.15}
NOISY = {38, 42, 49, 54, 56, 70, 73, 74}
for slot, (p, name, note) in enumerate(E.SLOTS):
    if note in NOISY:
        r = render([{"t": 100 + 900 * k, "note": note, "vel": 100, "dur": 300 if note in (73, 74) else 50} for k in range(7)], 900 * 7 + 100, name=f"n{note}")   # guiro: a 0.3 s stroke, as in Node
        x, sr = read_wav(r["wav"])
        pk = float(np.median([np.max(mono(x[int((0.1 + 0.9 * k - 0.05) * sr):int((0.1 + 0.9 * (k + 1) - 0.05) * sr)])) for k in range(7)]))
    else:
        x, sr, r = play(note, 900, dur=500 if note in (73, 74) else 50)
        pk = float(np.max(mono(x)))
    d = 20 * np.log10(pk / VPP[note]) if pk > 0 else -99
    check(r["nan_count"] == 0 and r["inf_count"] == 0 and abs(d) < (2.0 if note in NOISY else 1.0),
          f"note {note} ({name}): peak {pk:.3f} = {d:+.2f} dB from {VPP[note]} Vpp", verbose=True)

# 2. frequencies of the table, measured from the real render (5 cents); decays to 1/10 (+-15 %, noise voices +-25 %)
for note, f0, sec, win in ((36, 62.5, 0.12, 0.016), (37, 1480, 0.006, 0.0007), (75, 2630, 0.022, 0.0004), (60, 600, 0.05, 0.0017),
                           (61, 400, 0.05, 0.0025), (64, 208, 0.18, 0.0048)):
    x, sr, _ = play(note, 700)
    m = x[:, 0] * np.sqrt(2)
    o = onset(mono(x), 2e-4)
    f = zero_cross_freq(m[o - 2:], sr, sec)
    check(abs(cents(f, f0)) < 5, f"note {note}: {f:.2f} Hz, want {f0} ({cents(f, f0):+.2f} ct)", verbose=True)
def decay_avg(note, gap, win, hits=6):
    """decay to 1/10 from the mean-square envelope of `hits` hits (one noise hit's envelope is too ragged), aligned on their onsets"""
    r = render([{"t": 100 + gap * 1000 * k, "note": note, "vel": 100, "dur": 50} for k in range(hits)], int(gap * 1000 * hits + 100), name=f"d{note}")
    x, sr = read_wav(r["wav"])
    m = mono(x)
    w, ms = max(2, int(win * sr)), 0
    for k in range(hits):
        seg = m[int((0.1 + gap * k - 0.04) * sr):int((0.1 + gap * (k + 1) - 0.04) * sr)]
        o = onset(seg, 2e-4)
        seg = seg[o:o + int((gap - 0.15) * sr)]
        cs = np.concatenate([[0], np.cumsum(seg ** 2)])
        ms = ms + (cs[w:] - cs[:-w]) / w
    env = np.sqrt(ms / hits)
    pk = int(np.argmax(env))
    return np.where(env[pk:] <= 0.1 * env[pk])[0][0] / sr * 1000


# the narrow hat / Tb tanks make a slowly wandering noise envelope: 16 hits, and smoothing ~1/30 of the decay
for note, ms, win in ((38, 60, 0.00294), (42, 60, 0.004), (49, 350, 0.01), (70, 20, 0.002), (54, 220, 0.01)):
    t = decay_avg(note, 1.6 if note in (49, 54) else 0.6, win, hits=16)
    check(abs(t / ms - 1) < 0.15, f"note {note}: decay to 1/10 {t:.1f} ms (mean of 16 hits), want {ms} +-15 %", verbose=True)
for note, ms, win, tol in ((36, 100, 0.016, 0.15), (37, 5, 0.0007, 0.15), (75, 18, 0.0004, 0.15), (60, 40, 0.0017, 0.15), (61, 40, 0.0025, 0.15),
                           (64, 150, 0.0048, 0.15), (56, 60, 0.004, 0.15), (44, 50, 0.0018, 0.15)):
    x, sr, _ = play(note, 1500)
    t = decay10(mono(x)[onset(mono(x), 2e-4):], sr, win) * 1000
    check(abs(t / ms - 1) < tol, f"note {note}: decay to 1/10 {t:.1f} ms, want {ms} +-{int(tol * 100)} %", verbose=True)
x, sr, _ = play(38, 400)
f, _ = fft_peak(x[: int(0.2 * sr), 0], sr, 340, 0.1)
check(abs(cents(f, 340)) < 5, f"snare tone {f:.2f} Hz, want 340")
x, sr, _ = play(56, 500)
for f0 in (800, 555):
    f, _ = fft_peak(x[: int(0.3 * sr), 0], sr, f0, 0.06)
    check(abs(cents(f, f0)) < 5, f"cowbell tone {f:.2f} Hz, want {f0}")
x, sr, _ = play(44, 500)
seg = x[int(0.1 * sr):int(0.4 * sr), 0]
n = 1 << 18
s = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), n))
band = np.arange(int(3000 * n / sr), int(8000 * n / sr))
pk = [k for k in band if s[k] > s[k - 1] and s[k] >= s[k + 1]]
pk.sort(key=lambda k: -s[k])
top = []
for k in pk:
    if all(abs(k - j) * sr / n > 100 for j in top):
        top.append(k)
    if len(top) == 3:
        break
lines = sorted(k * sr / n for k in top)
check(len(lines) == 3 and all(abs(cents(a, b)) < 5 for a, b in zip(lines, (4080, 5620, 6170))), f"metallic beat lines {[round(v, 1) for v in lines]}, want 4080 5620 6170")

# 3. guiro: pulse rate while the note is held (2 %), stops at note-off, restarts on a back-to-back note
def pulse_rate(m, sr, a, b, min_gap=0.001):
    m = np.convolve(np.abs(m), np.ones(int(0.001 * sr)) / int(0.001 * sr))[:len(m)]   # grains are noise: onsets of the 1 ms envelope
    thr = 0.3 * m[a:b].max()
    on, last = [], -10 ** 9
    for i in range(a, b):
        if m[i] > thr:
            if i - last > min_gap * sr:
                on.append(i / sr)
            last = i
    e = m[a:b] - m[a:b].mean()   # rate: the shortest lag (2-30 ms) whose envelope autocorrelation is within 85 % of the best one
    lags = np.arange(int(0.002 * sr), int(0.03 * sr) + 2)
    ac = np.array([np.dot(e[:-L], e[L:]) / (len(e) - L) for L in lags])
    i = next(j for j in range(1, len(ac) - 1) if ac[j] >= 0.85 * ac.max() and ac[j] >= ac[j - 1] and ac[j] >= ac[j + 1])
    fine = lags[i] + 0.5 * (ac[i - 1] - ac[i + 1]) / (ac[i - 1] - 2 * ac[i] + ac[i + 1])
    return sr / fine, len(on)


for note, f0 in ((73, 125), (74, 77)):
    x, sr, _ = play(note, 1200, dur=600)
    m = mono(x)
    o = onset(m)
    rate, n_p = pulse_rate(m, sr, o, o + int(0.5 * sr))
    check(abs(rate / f0 - 1) < 0.02, f"guiro note {note}: {rate:.2f} pulses/s ({n_p} pulses), want {f0} +-2 %", verbose=True)
    check(float(m[o + int(0.75 * sr):].max()) < 2e-3, f"guiro note {note} stops after note-off")
x, sr, _ = play(73, 2000, dur=1800)
m = mono(x)
last = int(np.max(np.where(m > 0.02)[0]))
check(last - onset(m) < 1.12 * sr, f"a 1.8 s guiro note is cut at ~1 s (stroke {(last - onset(m)) / sr:.2f} s)")

# 4. back-to-back notes: the second hit of a rimshot, note-on in the same instant as the previous note-off (gate-collapse trap)
r = render([{"t": 100, "note": 37, "vel": 100, "dur": 40}, {"t": 140, "note": 37, "vel": 100, "dur": 40}, {"t": 180, "note": 37, "vel": 100, "dur": 40}], 400, name="b2b")
x, sr = read_wav(r["wav"])
m = mono(x)
o = onset(m)
gaps = 0
for k in (1, 2):
    w = m[o + int((40 * k - 10) * sr / 1000):o + int((40 * k + 18) * sr / 1000)]   # +-jitter around each re-hit
    gaps += float(w.max()) > 0.4
check(gaps == 2, f"three rimshots 40 ms apart all sound ({gaps + 1} of 3)")

# 5. parameters in the real engine: Tune, Decay, Accent, Pan, Master, MB on hats
x, sr, _ = play(36, 400, {"Bass Drum Tune": 12})
m = x[:, 0] * np.sqrt(2)
f = zero_cross_freq(m[onset(mono(x), 2e-4) - 2:], sr, 0.06)
check(abs(cents(f, 125)) < 5, f"Bass Drum Tune +12 st: {f:.2f} Hz, want 125")
x, sr, _ = play(36, 1500, {"Bass Drum Decay": 1})
m = mono(x)
t = decay10(m[onset(m, 2e-4):], sr, 0.016) * 1000
check(abs(t / 200 - 1) < 0.15, f"Bass Drum Decay +1 oct: {t:.0f} ms, want 200")
a = float(mono(play(36, 300)[0]).max())
hi = float(mono(play(36, 300, vel=127)[0]).max())
lo = float(mono(play(36, 300, vel=50)[0]).max())
check(abs(hi / a - 1.162) < 0.03 and abs(lo / a - 0.7) < 0.03, f"Accent: velocity 127 x{hi / a:.3f} (1.162), 50 x{lo / a:.3f} (0.700)")
x, sr, _ = play(36, 300, {"Bass Drum Pan": -100})
check(float(np.abs(x[:, 1]).max()) < 1e-4 and abs(float(np.abs(x[:, 0]).max()) - 0.4) < 0.01, "Bass Drum Pan -100 is left only at full level")
check(float(mono(play(36, 300, {"Master Volume": 0})[0]).max()) < 1e-6, "Master 0 is silent")
x0, sr, _ = play(42, 400)
x1, sr, _ = play(42, 400, {"Metallic Beat On Hats": 1, "Metallic Beat Amount": 100})
def mag(x, f0):
    seg = x[int(0.1 * sr):int(0.3 * sr), 0]
    return fft_peak(seg, sr, f0, 0.01)[1]
check(mag(x1, 4080) > 3 * mag(x0, 4080), "Metallic Beat On Hats adds the beat lines to the hi-hat note")

# 6. extremes: every parameter at its minimum, then its maximum, all notes at once and one by one
meta = {n: (lo, hi) for _, n, _, lo, hi, *_ in E.PARAMS}
for which in (0, 1):
    p = {n: v[which] for n, v in meta.items()}
    p["Drive"] = 100
    ev = [{"t": 100 + 60 * i, "note": n, "vel": 127, "dur": 400 if n in (73, 74) else 50} for i, (_, _, n) in enumerate(E.SLOTS)]
    r = render(ev, 1600, params=p, name="extreme")
    x, sr = read_wav(r["wav"])
    check(r["nan_count"] == 0 and r["inf_count"] == 0 and float(np.abs(x).max()) < 1.0001,
          f"all parameters at {'max' if which else 'min'}: peak {float(np.abs(x).max()):.3f}, nan {r['nan_count']}, inf {r['inf_count']}")

# 7. a TRIG button (live.text, button mode -> sel/route -> message -> cr_midi.js -> gen~). The harness can't press a button-mode live.text
# (automation doesn't make it output), so this runs on a temporary copy whose Snare button is a toggle.
sys.path.insert(0, os.path.join(HERE, "../../../MaxForLiveTools"))
from build_amxd import build_amxd  # noqa: E402

tmp = os.path.join(os.path.dirname(DEV), "_t.maxpat")
doc = json.load(open(DEV.replace(".amxd", ".maxpat")))
for b in doc["patcher"]["boxes"]:
    if b["box"].get("varname") == "sdTrig":
        b["box"]["mode"] = 1
json.dump(doc, open(tmp, "w"))
build_amxd(tmp, tmp.replace(".maxpat", ".amxd"), "iiii")
server.load_device(tmp.replace(".maxpat", ".amxd"))
r = server.render([{"t": 100, "param": "Snare Trigger", "value": 1}], 700, name="trig")
x, sr = read_wav(r["wav"])
check(float(np.abs(x[int(0.1 * sr):int(0.6 * sr)]).max()) > 0.05, "the Snare TRIG button plays the snare")
os.remove(tmp)
os.remove(tmp.replace(".maxpat", ".amxd"))

print(f"{PASSED[0]} passed" + (f", {len(FAILS)} FAILED" if FAILS else ""))
sys.exit(1 if FAILS else 0)
