"""Real-Max checks of the single-voice devices (m4l/CR78 <Name>.amxd): each one loads without errors, exposes its parameters, sounds at the table
level, has the full device's pitch and decay, and its menu / Volume / Accent / Tune work. Needs standalone Max, not Live.

    uv run --directory $MAXTEST_DIR python <repo>/CR78/tests/test_voices_max.py [Kick Snare ...]     (default: all 13, one load each)
"""
import os
import sys

import numpy as np

sys.path.insert(0, os.environ["MAXTEST_DIR"])
import server  # noqa: E402
from analyze import read_wav  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "../scripts"))
import build_voices as V  # noqa: E402

FAILS, PASSED = [], [0]


def check(cond, what):
    if cond:
        PASSED[0] += 1
        print("ok   " + what)
    else:
        print("FAIL " + what)
        FAILS.append(what)


DIRTY, DEFAULTS = set(), {}


def render(events, ms, params=None, name="r"):
    """server.render, first putting back the default of every parameter an earlier render changed (the device keeps them)"""
    params = dict(params or {})
    full = {n: DEFAULTS[n] for n in DIRTY if n not in params}
    DIRTY.update(params)
    r = server.render(events, ms, params={**full, **params}, name=name)
    x, sr = read_wav(r["wav"])
    return x[:, 0].astype(float), sr, r


def hit(note, ms=700, params=None, vel=100, dur=50):
    return render([{"t": 100, "note": note, "vel": vel, "dur": dur}], ms, params)


def cents(f, ref):
    return 1200 * np.log2(f / ref)


def zero_cross_freq(s, sr, n_sec):
    s = s[: int(n_sec * sr)]
    idx = np.where((s[:-1] <= 0) & (s[1:] > 0) | (s[:-1] >= 0) & (s[1:] < 0))[0][1:]
    t = (idx + s[idx] / (s[idx] - s[idx + 1])) / sr
    return 0.5 / np.polyfit(np.arange(len(t)), t, 1)[0]


def onset(m, thr=2e-4):
    return int(np.argmax(np.abs(m) > thr))


def fft_peak(sig, sr, f0, frac):
    n = 1 << 18
    s = np.abs(np.fft.rfft(sig * np.hanning(len(sig)), n))
    lo, hi = int(f0 * (1 - frac) * n / sr), int(f0 * (1 + frac) * n / sr)
    k = lo + int(np.argmax(s[lo:hi]))
    a, b, c = np.log(s[k - 1] + 1e-30), np.log(s[k] + 1e-30), np.log(s[k + 1] + 1e-30)
    return (k + 0.5 * (a - c) / (a - 2 * b + c)) * sr / n


def decay10(m, sr, win_s):
    w = max(2, int(win_s * sr))
    cs = np.concatenate([[0], np.cumsum(m ** 2)])
    env = np.sqrt((cs[w:] - cs[:-w]) / w)
    pk = int(np.argmax(env))
    below = np.where(env[pk:] <= 0.1 * env[pk])[0]
    return below[0] / sr * 1000 if len(below) else np.inf


def decay_avg(note, gap, win, hits, params=None):
    """decay to 1/10 from the mean-square envelope of several hits (one noise hit's envelope is too ragged), aligned on their onsets"""
    x, sr, _ = render([{"t": 100 + gap * 1000 * k, "note": note, "vel": 100, "dur": 50} for k in range(hits)], int(gap * 1000 * hits + 100), params)
    w, ms = max(2, int(win * sr)), 0
    for k in range(hits):
        seg = x[int((0.1 + gap * k - 0.04) * sr):int((0.1 + gap * (k + 1) - 0.04) * sr)]
        seg = seg[onset(seg):][: int((gap - 0.15) * sr)]
        cs = np.concatenate([[0], np.cumsum(seg ** 2)])
        ms = ms + (cs[w:] - cs[:-w]) / w
    env = np.sqrt(ms / hits)
    pk = int(np.argmax(env))
    return np.where(env[pk:] <= 0.1 * env[pk])[0][0] / sr * 1000


def median_peak(note, gap=0.9, hits=7, dur=50, params=None):
    x, sr, _ = render([{"t": 100 + gap * 1000 * k, "note": note, "vel": 100, "dur": dur} for k in range(hits)], int(gap * 1000 * hits + 100), params)
    return float(np.median([np.max(np.abs(x[int((0.1 + gap * k - 0.05) * sr):int((0.1 + gap * (k + 1) - 0.05) * sr)])) for k in range(hits)]))


def pulse_rate(m, sr, a, b):
    m = np.convolve(np.abs(m), np.ones(int(0.001 * sr)) / int(0.001 * sr))[:len(m)]
    e = m[a:b] - m[a:b].mean()
    lags = np.arange(int(0.002 * sr), int(0.03 * sr) + 2)
    ac = np.array([np.dot(e[:-L], e[L:]) / (len(e) - L) for L in lags])
    i = next(j for j in range(1, len(ac) - 1) if ac[j] >= 0.85 * ac.max() and ac[j] >= ac[j - 1] and ac[j] >= ac[j + 1])
    return sr / (lags[i] + 0.5 * (ac[i - 1] - ac[i + 1]) / (ac[i - 1] - 2 * ac[i] + ac[i + 1]))


# ringing voices: name -> (table Vpp, frequency Hz, zero-crossing window s, decay to 1/10 in ms, RMS window s)
TONAL = {"Kick": (0.4, 62.5, 0.12, 100, 0.016), "Rim": (0.8, 1480, 0.006, 5, 0.0007), "Clave": (0.15, 2630, 0.022, 18, 0.0004),
         "Conga": (0.3, 208, 0.18, 150, 0.0048)}
sel = sys.argv[1:] or [d[0] for d in V.DEVICES]
for dev in V.DEVICES:
    name = dev[0]
    if name not in sel:
        continue
    DIRTY.clear()
    DEFAULTS.clear()
    loaded = server.load_device(os.path.join(HERE, f"../m4l/CR78 {name}.amxd"))
    errs = [l for l in loaded["console"] if "[1]" in l]
    check(not errs, f"{name}: load_device console has no [1] errors ({errs[:2]})")
    names = {p["name"] for p in loaded["params"]}
    want = {c["label"] for c in dev[3]}
    check(want <= names, f"{name}: parameters exposed {sorted(names)} (missing {sorted(want - names)})")
    for c in dev[3]:
        DEFAULTS[c["label"]] = 0 if c["kind"] == "menu" else V.range_of(c)[2]
    note = 60   # any note plays it
    vol = lambda x: 20 * np.log10(x)  # noqa: E731
    if name in TONAL:
        vpp, f0, fs, ms, win = TONAL[name]
        x, sr, r = hit(note, 900)
        check(r["nan_count"] == 0 and abs(vol(np.max(np.abs(x)) / vpp)) < 1.0, f"{name}: peak {np.max(np.abs(x)):.3f} within 1 dB of {vpp} Vpp")
        f = zero_cross_freq(x[onset(x) - 2:], sr, fs)
        check(abs(cents(f, f0)) < 5, f"{name}: {f:.2f} Hz, want {f0} ({cents(f, f0):+.2f} ct)")
        t = decay10(x[onset(x):], sr, win)
        check(abs(t / ms - 1) < 0.15, f"{name}: decay to 1/10 {t:.1f} ms, want {ms}")
        if name == "Kick":
            x, sr, _ = hit(note, 600, {"Tune": 12})
            f = zero_cross_freq(x[onset(x) - 2:], sr, 0.06)
            check(abs(cents(f, 125)) < 5, f"Kick Tune +12 st: {f:.2f} Hz, want 125")
            x, sr, _ = hit(note, 1500, {"Decay": 1})
            t = decay10(x[onset(x):], sr, 0.016)
            check(abs(t / 200 - 1) < 0.15, f"Kick Decay +1 oct: {t:.0f} ms, want 200")
    elif name == "Bongo":
        for pick, f0, ms, win in ((0, 600, 40, 0.0017), (1, 400, 40, 0.0025)):
            x, sr, r = hit(note, 700, {"Bongo": pick})
            f = zero_cross_freq(x[onset(x) - 2:], sr, 0.05)
            t = decay10(x[onset(x):], sr, win)
            check(abs(cents(f, f0)) < 5 and abs(t / ms - 1) < 0.15 and abs(vol(np.max(np.abs(x)) / 0.15)) < 1.0,
                  f"Bongo {['High', 'Low'][pick]}: {f:.2f} Hz (want {f0}), decay {t:.1f} ms, peak {np.max(np.abs(x)):.3f}")
    elif name == "Snare":
        x, sr, _ = hit(note, 500)
        check(abs(cents(fft_peak(x[: int(0.2 * sr)], sr, 340, 0.1), 340)) < 5, "Snare: tone 340 Hz")
        check(abs(vol(median_peak(note) / 0.4)) < 2.0, "Snare: median peak within 2 dB of 0.4 Vpp")
        t = decay_avg(note, 0.6, 0.00294, 16)
        check(abs(t / 60 - 1) < 0.25, f"Snare: decay to 1/10 {t:.1f} ms (mean of 16 hits), want 60")
    elif name == "Cowbell":
        x, sr, _ = hit(note, 600)
        for f0 in (800, 555):
            f = fft_peak(x[: int(0.3 * sr)], sr, f0, 0.06)
            check(abs(cents(f, f0)) < 5, f"Cowbell: tone {f:.2f} Hz, want {f0}")
        check(abs(vol(median_peak(note) / 0.2)) < 2.0, "Cowbell: median peak within 2 dB of 0.2 Vpp")
        x, sr, _ = hit(note, 1500)
        t = decay10(x[onset(x):], sr, 0.004)
        check(abs(t / 60 - 1) < 0.15, f"Cowbell: decay to 1/10 {t:.1f} ms, want 60")
    elif name == "Metal":
        x, sr, _ = hit(note, 500)
        seg = x[int(0.1 * sr):int(0.4 * sr)]
        s = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), 1 << 18))
        k0, k1 = int(3000 * (1 << 18) / sr), int(8000 * (1 << 18) / sr)
        pk = sorted([k for k in range(k0, k1) if s[k] > s[k - 1] and s[k] >= s[k + 1]], key=lambda k: -s[k])
        top = []
        for k in pk:
            if all(abs(k - j) * sr / (1 << 18) > 100 for j in top):
                top.append(k)
            if len(top) == 3:
                break
        lines = sorted(k * sr / (1 << 18) for k in top)
        check(len(lines) == 3 and all(abs(cents(a, b)) < 5 for a, b in zip(lines, (4080, 5620, 6170))), f"Metal: lines {[round(v, 1) for v in lines]}, want 4080 5620 6170")
        x, sr, _ = hit(note, 1500)
        t = decay10(x[onset(x):], sr, 0.0018)
        check(abs(t / 50 - 1) < 0.15 and abs(vol(np.max(np.abs(x)) / 0.35)) < 1.0, f"Metal: decay to 1/10 {t:.1f} ms (want 50), peak {np.max(np.abs(x)):.3f}")
    elif name in ("Hat", "Cymbal", "Maracas", "Tamb"):
        vpp, ms, win, gap = {"Hat": (0.4, 60, 0.004, 0.6), "Cymbal": (0.4, 350, 0.01, 1.6), "Maracas": (0.4, 20, 0.002, 0.6), "Tamb": (0.25, 220, 0.01, 1.6)}[name]
        check(abs(vol(median_peak(note) / vpp)) < 2.0, f"{name}: median peak within 2 dB of {vpp} Vpp")
        t = decay_avg(note, gap, win, 16)
        check(abs(t / ms - 1) < 0.25, f"{name}: decay to 1/10 {t:.1f} ms (mean of 16 hits), want {ms} +-25 %")
        if name == "Tamb":
            ev = [{"t": 100 + 700 * k, "note": note, "vel": 100, "dur": 50} for k in range(8)]
            x0, sr, _ = render(ev, 5800)
            x1, sr, _ = render(ev, 5800, {"Shake": 1})
            rms = lambda x: sum(np.sqrt(np.mean(x[int((0.1 + 0.7 * k + 0.1) * sr):int((0.1 + 0.7 * k + 0.13) * sr)] ** 2)) for k in range(8))  # noqa: E731
            check(rms(x1) > 1.4 * rms(x0), f"Tamb Shake adds a second kick ({rms(x1) / rms(x0):.2f}x)")
    elif name == "Guiro":
        for pick, f0 in ((0, 125), (1, 77)):
            x, sr, _ = hit(note, 1200, {"Stroke": pick}, dur=600)
            o = onset(x, 1e-3)
            rate = pulse_rate(x, sr, o, o + int(0.5 * sr))
            check(abs(rate / f0 - 1) < 0.02, f"Guiro {['Short', 'Long'][pick]}: {rate:.2f} pulses/s, want {f0}")
            check(float(np.max(np.abs(x[o + int(0.75 * sr):]))) < 2e-3, f"Guiro {['Short', 'Long'][pick]} stops after note-off")
        check(abs(vol(median_peak(note, 1.0, 7, 300) / 0.3)) < 2.0, "Guiro: median peak within 2 dB of 0.3 Vpp")
    # every device: Volume, Accent, any note, extremes
    noisy = name in ("Snare", "Hat", "Cymbal", "Maracas", "Tamb", "Cowbell", "Guiro")   # one hit differs from the next: the RMS of 7 hits

    def level(p=None):
        if not noisy:
            return float(np.max(np.abs(hit(note, 500, p)[0])))
        x, _, _ = render([{"t": 100 + 900 * k, "note": note, "vel": 100, "dur": 300 if name == "Guiro" else 50} for k in range(7)], 6500, p)
        return float(np.sqrt(np.mean(x ** 2)))

    base, half = level(), level({"Volume": -6.0206})
    check(abs(half / base - 0.5) < (0.05 if noisy else 0.02), f"{name}: Volume -6 dB halves the level (x{half / base:.3f})")
    quiet = float(np.max(np.abs(hit(note, 500, vel=50)[0])))
    check(abs(quiet / base - 0.7) < 0.1 or noisy, f"{name}: Accent: velocity 50 plays x{quiet / base:.2f} (0.70)")
    check(float(np.max(np.abs(hit(72, 500)[0]))) > 0.01 and float(np.max(np.abs(hit(30, 500)[0]))) > 0.01, f"{name}: other notes play it too")
    ext = {c["label"]: V.range_of(c)[0] for c in dev[3] if c["kind"] != "menu"}
    x, sr, r = hit(note, 800, ext, vel=127)
    check(r["nan_count"] == 0 and r["inf_count"] == 0 and float(np.max(np.abs(x))) < 1.0001, f"{name}: every control at its minimum: peak {np.max(np.abs(x)):.3f}")
    ext = {c["label"]: V.range_of(c)[1] for c in dev[3] if c["kind"] != "menu"}
    x, sr, r = hit(note, 800, ext, vel=127)
    check(r["nan_count"] == 0 and r["inf_count"] == 0 and float(np.max(np.abs(x))) < 1.0001, f"{name}: every control at its maximum: peak {np.max(np.abs(x)):.3f}")

print(f"{PASSED[0]} passed" + (f", {len(FAILS)} FAILED" if FAILS else ""))
sys.exit(1 if FAILS else 0)
