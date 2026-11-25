"""End-to-end checks of m4l/Surdo.amxd in real standalone Max (needs Max, not Live), from a cold start: parameters, every stroke against the
Node shim (same peak, same energy), tuning, the Open's glide, Stroke changed between hits (a mute damps the head, an open stroke much less), controls, extremes.
With --demo also writes docs/demo.wav (a samba pattern read from the Latin Percussion clip "Samba 1 Surdo", rendered through the device).

    uv run --directory $MAXTEST_DIR python <repo>/Surdo/tests/test_voice_max.py [--demo]
"""
import os
import shutil
import subprocess
import sys

import numpy as np
import wave

sys.path.insert(0, os.environ["MAXTEST_DIR"])
import server  # noqa: E402
from analyze import read_wav  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
DEV = os.path.join(HERE, "../m4l/Surdo.amxd")
RESTART = os.path.join(HERE, "../scripts/max_restart.sh")
sys.path.insert(0, os.path.join(HERE, "../scripts"))
sys.path.insert(0, HERE)
import surdo_engine as E  # noqa: E402

FAILS = []
PASSED = [0]
DEFAULTS = {ln: d for _, ln, _, _, d, *_ in E.PARAMS}
META = {ln: (lo, hi) for _, ln, lo, hi, *_ in E.PARAMS}
DIRTY = set()
NOTE = 60
OUTDIR = os.environ.get("SURDO_OUT", "")


def check(cond, what, verbose=False):
    if cond:
        PASSED[0] += 1
        if verbose:
            print("ok   " + what)
    else:
        print("FAIL " + what)
        FAILS.append(what)


def render(events, ms, params=None, name="render"):
    """server.render, first putting back the default of every parameter an earlier render changed (the device keeps them)"""
    params = params or {}
    full = {n: DEFAULTS[n] for n in DIRTY if n not in params}
    DIRTY.update(params)
    return server.render(events, ms, params={**full, **params}, name=name)


def play(stroke, ms=1500, params=None, vel=127, extra=(), name=None):
    r = render([{"t": 100, "note": NOTE, "vel": vel, "dur": 60}, *extra], ms, params={"Stroke": stroke, "Vary": 0, **(params or {})}, name=name or f"t{stroke}")
    x, sr = read_wav(r["wav"])
    if OUTDIR:
        shutil.copy(r["wav"], os.path.join(OUTDIR, f"{E.STROKES[stroke]}_{name or ''}.wav"))
    return x, sr, r


def fft_peak(sig, sr, lo, hi):
    n = 1 << 18
    s = np.abs(np.fft.rfft(sig * np.hanning(len(sig)), n))
    a, b = int(lo * n / sr), int(hi * n / sr)
    k = a + int(np.argmax(s[a:b]))
    l, c, r = np.log(s[k - 1] + 1e-30), np.log(s[k] + 1e-30), np.log(s[k + 1] + 1e-30)
    return (k + 0.5 * (l - r) / (l - 2 * c + r)) * sr / n


def band_db(sig, sr, lo, hi):
    n = 1 << 16
    s = np.abs(np.fft.rfft(sig * np.hanning(len(sig)), n)) ** 2
    f = np.fft.rfftfreq(n, 1 / sr)
    return 10 * np.log10(s[(f >= lo) & (f < hi)].sum() + 1e-20)


def onset(m, thr=1e-3):
    return int(np.argmax(m > thr))


def env_t(m, sr, db, win=0.01):
    w = max(2, int(win * sr))
    cs = np.concatenate([[0], np.cumsum(m ** 2)])
    env = np.sqrt((cs[w:] - cs[:-w]) / w)
    pk = int(np.argmax(env))
    below = np.where(env[pk:] <= env[pk] * 10 ** (-db / 20))[0]
    return below[0] / sr if len(below) else np.inf


def stats(x, sr):
    m = x.mean(axis=1)
    o = onset(np.abs(m), 1e-3)
    return 20 * np.log10(float(np.abs(x).max()) + 1e-12), 10 * np.log10(float(np.mean(m[o:o + int(0.8 * sr)] ** 2)) + 1e-20)


def node_stats():
    """the Node shim's peak and 0.8 s energy per stroke at velocity 1 (the numbers Max must reproduce; computed by tests/node_stats.py with the system python)"""
    import json
    o = subprocess.run(["/opt/homebrew/bin/python3", os.path.join(HERE, "node_stats.py")], capture_output=True, text=True, check=True).stdout
    return {int(k): tuple(x) for k, x in json.loads(o.strip().splitlines()[-1]).items()}


ref = node_stats()
subprocess.run(["bash", RESTART], capture_output=True)
loaded = server.load_device(DEV)
errs = [l for l in loaded["console"] if "[1]" in l]
check(not errs, f"load_device console has no [1] errors ({len(errs)} found)")
for l in errs:
    print("     " + l)
names = {p["name"] for p in loaded["params"]}
check(set(DEFAULTS) <= names, f"every engine parameter is exposed as a Live parameter (missing: {sorted(set(DEFAULTS) - names)})")
print(f"     {len(names)} parameters, sr {loaded['sr']}")

# 1. every stroke (Vary 0, as in every play(): Node and Max draw different jitter): peak within 3.5 dB and 0.8 s energy within 2.5 dB of the Node shim (the tick noise differs hit to hit), sounds, L == R
for s in range(4):
    x, sr, r = play(s, 1500)
    pk, en = stats(x, sr)
    rp, re = ref[s]
    dp, de = pk - rp, en - re
    check(r["nan_count"] == 0 and r["inf_count"] == 0 and abs(dp) < 3.5 and abs(de) < 2.5 and float(np.abs(x[:, 0] - x[:, 1]).max()) < 1e-6,
          f"{E.STROKE_MENU[s]}: peak {pk:.1f} dBFS ({dp:+.1f} vs Node), energy {de:+.1f} dB vs Node, L == R", verbose=True)

# 2. Tune +7 st moves the open tone up a fifth (60-130 Hz, 0.3..0.8 s in); Tune 0 puts it at the recorded 86 Hz. 3. the glide: the tone starts sharp and falls to f1
fs = {}
for t in (0, 7):
    x, sr, _ = play(0, 1500, {"Tune": t}, vel=100)
    m = x.mean(axis=1)
    o = onset(np.abs(m), 2e-3)
    fs[t] = fft_peak(m[o + int(0.3 * sr):o + int(0.8 * sr)], sr, 60, 195 if t else 130)
check(abs(1200 * np.log2(fs[7] / fs[0]) - 700) < 25, f"open: Tune 0 -> +7 st moves the open tone {fs[0]:.2f} -> {fs[7]:.2f} Hz ({1200 * np.log2(fs[7] / fs[0]):+.0f} ct, want 700)", verbose=True)
check(abs(1200 * np.log2(fs[0] / E.F1)) < 15, f"open, Tune 0: the settled tone is {fs[0]:.2f} Hz (recorded 86.0)", verbose=True)
gl = {}
for v in (115, 38):
    x, sr, _ = play(0, 1500, vel=v, name=f"glide{v}")
    m = x.mean(axis=1)
    o = onset(np.abs(m), 2e-3)
    gl[v] = 1200 * np.log2(fft_peak(m[o + int(0.03 * sr):o + int(0.15 * sr)], sr, 70, 105) / fft_peak(m[o + int(0.3 * sr):o + int(0.8 * sr)], sr, 70, 105))
check(12 < gl[115] < 80 and gl[38] < gl[115] / 2, f"open glide: the tone starts {gl[115]:.0f} ct above its settled pitch at velocity 115, {gl[38]:.0f} ct at 38 (want 12..80, then under half)", verbose=True)

# 4. Stroke changed between hits (menu set 25 ms ahead of the note at 0.3 s): head ring (60-130 Hz) 0.2..0.4 s after the second hit, against the free ring
free, sr, _ = play(0, 1100, vel=110, name="free")
mf = free.mean(axis=1)
t0 = onset(np.abs(mf), 2e-3) / sr
a0, a1 = int((t0 + 0.5) * sr), int((t0 + 0.7) * sr)
res = {}
for stroke, nm in ((1, "Mute"), (3, "Finger"), (0, "Open")):
    ch, sr, _ = play(0, 1100, vel=110, extra=[{"t": 375, "param": "Stroke", "value": stroke}, {"t": 400, "note": NOTE, "vel": 1, "dur": 60}], name=nm)
    res[nm] = band_db(ch.mean(axis=1)[a0:a1], sr, 60, 130) - band_db(mf[a0:a1], sr, 60, 130)
check(res["Mute"] < -10, f"open, then Stroke -> Mute between hits (quiet): the head's ring is {res['Mute']:.1f} dB re the free ring (need < -10)")
check(res["Finger"] < -3, f"open, then Stroke -> Finger between hits (quiet): the head's ring is {res['Finger']:.1f} dB re the free ring (need < -3)")
check(res["Mute"] < res["Open"] - 3, f"the Mute damps the ring more than an Open does ({res['Mute']:.1f} vs {res['Open']:.1f} dB re free)")
# the same note after a Stroke change is the new stroke: Rim has far more highs than Open
b, sr, _ = play(0, 900, extra=[{"t": 400, "note": NOTE, "vel": 110, "dur": 60}], name="nochg")
a, sr, _ = play(0, 900, extra=[{"t": 340, "param": "Stroke", "value": 2}, {"t": 400, "note": NOTE, "vel": 110, "dur": 60}], name="chg")
i0, i1 = int(0.396 * sr), int(0.44 * sr)
dcr = band_db(a.mean(axis=1)[i0:i1], sr, 1500, 8000) - band_db(b.mean(axis=1)[i0:i1], sr, 1500, 8000)
check(dcr > 10, f"Stroke -> Rim between hits: the second hit has the rim's crack ({dcr:.1f} dB more at 1.5-8 kHz, need > 10)")
c, sr, _ = play(0, 800, extra=[{"t": 300, "param": "Stroke", "value": 2}, {"t": 300, "note": NOTE, "vel": 110, "dur": 60}], name="same")
dsame = band_db(c.mean(axis=1)[int(0.296 * sr):int(0.34 * sr)], sr, 1500, 8000) - band_db(b.mean(axis=1)[i0:i1], sr, 1500, 8000)
check(dsame > 10, f"Stroke menu and note in the same tick: the new stroke plays ({dsame:.1f} dB more at 1.5-8 kHz, need > 10)")

# 5. back-to-back notes: three Rim hits 40 ms apart all sound
ev = [{"t": 100 + 40 * k, "note": NOTE, "vel": 110, "dur": 40} for k in range(3)]
r = render(ev, 500, params={"Stroke": 2, "Vary": 0}, name="b2b")
x, sr = read_wav(r["wav"])
m = np.abs(x).max(axis=1)
o = onset(m, 2e-3)
gaps = sum(float(m[o + int((40 * k - 8) * sr / 1000):o + int((40 * k + 18) * sr / 1000)].max()) > 0.3 * float(m[o:o + int(0.01 * sr)].max()) for k in (1, 2))
check(gaps == 2, f"three Rim hits 40 ms apart all sound ({gaps + 1} of 3)")

# 5b. Vary: eight Open strokes 2 s apart; the levels of the head's sinusoid bands (100-600 Hz, first 250 ms) differ hit to hit by about 1.5 dB at Vary 100, hardly at 0
for vary, lo, hi in ((100, 1.0, 4.5), (0, 0, 1.2)):
    r = render([{"t": 100 + 2000 * k, "note": NOTE, "vel": 110, "dur": 60} for k in range(8)], 100 + 2000 * 8, params={"Stroke": 0, "Vary": vary}, name=f"vary{vary}")
    x, sr = read_wav(r["wav"])
    m = x.mean(axis=1)
    o0 = onset(np.abs(m), 2e-3)
    bands = np.array([[band_db(m[o0 + int(2.0 * k * sr):o0 + int((2.0 * k + 0.25) * sr)], sr, a, b) for a, b in ((100, 150), (150, 200), (200, 300), (300, 600))] for k in range(8)])
    sd = float(np.median(bands.std(0, ddof=1)))
    check(lo <= sd <= hi, f"Vary {vary}: the head bands' level differs hit to hit by {sd:.1f} dB (want {lo}..{hi})", verbose=True)

# 6. controls in the real engine
drops = {}
for dc in (100, 200):
    x, sr, _ = play(0, 3500, {"Decay": dc}, vel=100, name=f"dc{dc}")
    m = x.mean(axis=1)
    o = onset(np.abs(m), 2e-3)
    drops[dc] = band_db(m[o + int(0.2 * sr):o + int(0.7 * sr)], sr, 60, 130) - band_db(m[o + int(0.9 * sr):o + int(1.4 * sr)], sr, 60, 130)
check(0.3 < drops[200] / drops[100] < 0.7, f"Decay 200 %: the open tone falls {drops[200]:.1f} dB from 0.2-0.7 s to 0.9-1.4 s vs {drops[100]:.1f} dB at 100 % (x{drops[200] / drops[100]:.2f}, want ~0.5)")
fa = {}
for sk in (0, 100):
    x, sr, _ = play(2, 600, {"Skin": sk}, vel=110)
    m = x.mean(axis=1)
    fa[sk] = band_db(m[int(0.1 * sr):int(0.22 * sr)], sr, 1500, 4000) - band_db(m[int(0.1 * sr):int(0.22 * sr)], sr, 250, 500)
check(fa[100] > fa[0] + 8, f"rim, Skin 100 vs 0: the 1.5-4 kHz part is {fa[100] - fa[0]:.1f} dB stronger against 250-500 Hz (need > 8)")
x1, sr, _ = play(0, 400, {"Touch": 100}, vel=110)
x0, sr, _ = play(0, 400, {"Touch": 0}, vel=110)
dt = band_db(x1.mean(axis=1)[int(0.1 * sr):int(0.14 * sr)], sr, 3000, 11000) - band_db(x0.mean(axis=1)[int(0.1 * sr):int(0.14 * sr)], sr, 3000, 11000)
check(dt > 3, f"open, Touch 100 vs 0: {dt:.1f} dB more energy at 3-11 kHz in the first 40 ms (need > 3)")
m0 = play(0, 1500, vel=100)[0].mean(axis=1)
o0 = onset(np.abs(m0), 2e-3)
f0 = fft_peak(m0[o0 + int(0.3 * sr):o0 + int(0.8 * sr)], sr, 60, 130)
x, sr, _ = play(0, 1500, {"Press": 12}, vel=100, extra=[{"t": 0, "cc": 1, "value": 127}])
m = x.mean(axis=1)
o = onset(np.abs(m), 2e-3)
f = fft_peak(m[o + int(0.3 * sr):o + int(0.8 * sr)], sr, 100, 260)
check(abs(1200 * np.log2(f / f0) - 1200) < 60, f"mod wheel 127 with Press 12: the open tone {f0:.1f} -> {f:.1f} Hz ({1200 * np.log2(f / f0):+.0f} ct, want +1200)")
render([{"t": 0, "cc": 1, "value": 0}], 200, params={}, name="wheel0")      # the device keeps the wheel
x, sr, _ = play(0, 1000, vel=127)
lo = float(np.abs(play(0, 1000, vel=30)[0]).max())
check(20 * np.log10(float(np.abs(x).max()) / lo) > 10, f"velocity 30 -> 127 spans {20 * np.log10(float(np.abs(x).max()) / lo):.1f} dB (> 10)")
x1, sr, _ = play(1, 800, {"Volume": -9}, vel=127)
x2, sr, _ = play(1, 800, {"Volume": -21}, vel=127)
dv = stats(x1, sr)[1] - stats(x2, sr)[1]
check(abs(dv - 12) < 0.5, f"Volume -9 -> -21 dB: energy {dv:.2f} dB lower (want 12)")

# 7. extremes: every control at its minimum, then maximum (the menu left alone), all 4 strokes one after the other via the menu
for which in (0, 1):
    p = {n: v[which] for n, v in META.items() if n != "Stroke"}
    ev = [{"t": 0, "cc": 1, "value": 127}]
    for i in range(4):
        ev += [{"t": 100 + 150 * i - 20, "param": "Stroke", "value": i}, {"t": 100 + 150 * i, "note": NOTE, "vel": 127, "dur": 50}]
    r = render(ev, 1800, params=p, name="extreme")
    x, sr = read_wav(r["wav"])
    check(r["nan_count"] == 0 and r["inf_count"] == 0 and float(np.abs(x).max()) < 1.0001,
          f"all controls at {'max' if which else 'min'}, stroke swept: peak {float(np.abs(x).max()):.3f}, nan {r['nan_count']}, inf {r['inf_count']}")

# 8. the demo: the Latin Percussion clip "Samba 1 Surdo-120bpm" read through the one-shot replays in it (tests/clips.py score clip_Samba_1: a replayed one-shot is a hit, its gain the velocity; an Open match counts only where the envelope rises 5 dB: later stretches of the same ring match too), played
# through one instance, the Stroke menu set 25 ms ahead whenever the stroke changes. (ms, stroke, velocity); 4 bars at 120 bpm. Our reading of the clip, not a transcription from a method book.
OPEN, MUTE, RIM, FINGER = range(4)
SAMBA = [(0, MUTE, 79), (379, MUTE, 70), (549, OPEN, 112), (1375, MUTE, 75), (1498, OPEN, 121), (2375, MUTE, 74), (2552, OPEN, 113), (3250, FINGER, 83), (3376, MUTE, 83), (3499, OPEN, 114),
         (4371, MUTE, 77), (4548, OPEN, 112), (5251, FINGER, 83), (5376, MUTE, 79), (5501, OPEN, 115), (6379, MUTE, 78), (6499, OPEN, 115), (7245, FINGER, 85), (7377, MUTE, 80), (7552, OPEN, 117)]


def demo():
    """the pattern above (8 s), then an open on the downbeat and a rim click after it; returns (mono, sr)"""
    hits = [(200 + t, st, v) for t, st, v in SAMBA] + [(200 + 8000, OPEN, 127), (200 + 8250, RIM, 100)]
    ev, cur = [], None
    for t, st, v in sorted(hits, key=lambda h: (h[0], h[1])):
        if st != cur:
            ev.append({"t": t - 25, "param": "Stroke", "value": st})
            cur = st
        ev.append({"t": t, "note": NOTE, "vel": v, "dur": 40})
    ms = 200 + 8250 + 2500
    r = render(ev, ms, params={"Stroke": 1}, name="demo")
    x, sr = read_wav(r["wav"])
    y = x.mean(axis=1)
    return y / (np.abs(y).max() + 1e-9) * 0.7, sr, ms


y, sr, ms = demo()
check(float(np.abs(y).max()) > 0.1 and np.isfinite(y).all(), f"demo pattern: {len(y) / sr:.1f} s rendered")
if "--demo" in sys.argv:
    with wave.open(os.path.join(HERE, "../docs/demo.wav"), "wb") as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(int(sr)); w.writeframes((y * 32767).astype("<i2").tobytes())
    print(f"demo.wav written: {len(y) / sr:.1f} s")

print(f"{PASSED[0]} passed" + (f", {len(FAILS)} FAILED" if FAILS else ""))
sys.exit(1 if FAILS else 0)
