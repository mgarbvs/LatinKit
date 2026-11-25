"""Surdo Musical (m4l/SurdoMusical.amxd) in real standalone Max, from a cold start: the played key sets the open tone (mtof(key) x 2^(Tune/12)), Tune adds,
extreme keys are finite, the Stroke menu still works. With --demo also writes docs/musical_demo.wav (a bass line through the device).

    uv run --directory $MAXTEST_DIR python <repo>/Surdo/tests/test_musical_max.py [--demo]
"""
import os
import sys
import wave

import numpy as np

sys.path.insert(0, os.environ["MAXTEST_DIR"])
import server  # noqa: E402
from analyze import read_wav  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
DEV = os.path.join(HERE, "../m4l/SurdoMusical.amxd")
sys.path.insert(0, os.path.join(HERE, "../scripts"))
import surdo_engine as E  # noqa: E402

DEFAULTS = {ln: d for _, ln, _, _, d, *_ in E.PARAMS}
FAILS, PASSED, DIRTY = [], [0], set()
mtof = lambda k: 440 * 2 ** ((k - 69) / 12)  # noqa: E731


def check(cond, what):
    if cond:
        PASSED[0] += 1
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


def fft_peak(sig, sr, lo, hi):
    n = 1 << 18
    s = np.abs(np.fft.rfft(sig * np.hanning(len(sig)), n))
    a, b = int(lo * n / sr), int(hi * n / sr)
    k = a + int(np.argmax(s[a:b]))
    l, c, r = np.log(s[k - 1] + 1e-30), np.log(s[k] + 1e-30), np.log(s[k + 1] + 1e-30)
    return (k + 0.5 * (l - r) / (l - 2 * c + r)) * sr / n


def open_f0(key, tune=0):
    """the Open's settled tone (0.5..1.2 s after the onset; the glide is gone) for MIDI note `key`"""
    r = render([{"t": 100, "note": key, "vel": 100, "dur": 60}], 1600, params={"Stroke": 0, "Vary": 0, "Tune": tune}, name=f"mus{key}_{tune}")
    x, sr = read_wav(r["wav"])
    m = x.mean(axis=1)
    o = int(np.argmax(np.abs(m) > 2e-3))
    f = mtof(key) * 2 ** (tune / 12)
    return fft_peak(m[o + int(0.5 * sr):o + int(1.2 * sr)], sr, 0.93 * f, 1.08 * f), r


ct = lambda a, b: 1200 * np.log2(a / b)  # noqa: E731

subprocess_restart = os.path.join(HERE, "../scripts/max_restart.sh")
os.system(f"bash {subprocess_restart} >/dev/null 2>&1")
loaded = server.load_device(DEV)
errs = [l for l in loaded["console"] if "[1]" in l]
check(not errs, f"load_device console has no [1] errors ({len(errs)} found)")
names = {p["name"] for p in loaded["params"]}
check(set(DEFAULTS) <= names, f"all {len(DEFAULTS)} parameters exposed (missing: {sorted(set(DEFAULTS) - names)})")

worst = 0
for key in (28, 41, 53, 60, 72):
    f, r = open_f0(key)
    worst = max(worst, abs(ct(f, mtof(key))))
    check(r["nan_count"] == 0 and abs(ct(f, mtof(key))) < 5, f"key {key}: the open tone {f:.2f} Hz, mtof {mtof(key):.2f} Hz ({ct(f, mtof(key)):+.1f} ct, want +-5)")
f41, f53 = open_f0(41)[0], open_f0(53)[0]
check(abs(ct(f53, f41) - 1200) < 5, f"key 41 -> 53 moves the open tone {ct(f53, f41):+.1f} ct (want 1200)")
fa, fb = open_f0(41, 7)[0], open_f0(48)[0]
check(abs(ct(fa, fb)) < 5, f"key 41 + Tune 7 st vs key 48: {ct(fa, fb):+.1f} ct (Tune adds in semitones)")

# extremes: the lowest and highest keys, Tune +-12, wheel full, all 4 strokes via the menu: finite, under full scale
for key, tune in ((0, -12), (127, 12), (110, 0), (16, 0)):
    ev = [{"t": 0, "cc": 1, "value": 127}]
    for i in range(4):
        ev += [{"t": 100 + 250 * i - 20, "param": "Stroke", "value": i}, {"t": 100 + 250 * i, "note": key, "vel": 127, "dur": 50}]
    r = render(ev, 1400, params={"Tune": tune}, name="extreme")
    x, sr = read_wav(r["wav"])
    check(r["nan_count"] == 0 and r["inf_count"] == 0 and float(np.abs(x).max()) < 1.0001, f"key {key}, Tune {tune:+d}, 4 strokes: peak {float(np.abs(x).max()):.3f}, nan {r['nan_count']}")
render([{"t": 0, "cc": 1, "value": 0}], 200, params={}, name="wheel0")

# the demo: a samba-feel bass line in D dorian, 2/4 at 100 bpm (16th = 150 ms): beat 1 a muted root, beat 2 an open root or fifth, an open pick-up on the last 16th of every other bar;
# bars 7-8 a D dorian scale up and down in 16ths; then the root, open. (step in 16ths, key, stroke, velocity); the Stroke menu is set 25 ms ahead whenever it changes
OPEN, MUTE = 0, 1
D2, G1, C2, A1 = 38, 31, 36, 33
BARS = [(D2, A1), (D2, A1), (G1, D2), (G1, D2), (C2, G1), (C2, G1), (A1, 40), (A1, 33)]      # (beat 1 root, beat 2 note) per bar: Dm7 Dm7 G7 G7 Cmaj7 Cmaj7 Am7 Am7
SCALE = [38, 40, 41, 43, 45, 47, 48, 50, 48, 47, 45, 43, 41, 40]
HITS = []
for b, (r1, r2) in enumerate(BARS[:6]):
    s = 8 * b
    HITS += [(s, r1, MUTE, 85), (s + 4, r2, OPEN, 112)]
    if b % 2:
        HITS.append((s + 7, r2, OPEN, 70))
s = 8 * 6
HITS += [(s, 33, MUTE, 85), (s + 4, 40, OPEN, 112)]
s = 8 * 7
HITS += [(s + i, k, OPEN, 100 + (4 if i % 4 == 0 else 0)) for i, k in enumerate(SCALE[:8])]
HITS += [(s + 8 + i, k, OPEN, 96) for i, k in enumerate(SCALE[8:])]
HITS.append((s + 14, 38, OPEN, 127))


def demo():
    ev, cur = [], None
    for step, key, st, v in sorted(HITS):
        t = 200 + int(step * 150)
        if st != cur:
            ev.append({"t": t - 25, "param": "Stroke", "value": st})
            cur = st
        ev.append({"t": t, "note": key, "vel": v, "dur": 40})
    ms = 200 + 150 * HITS[-1][0] + 2800
    r = render(ev, ms, params={"Stroke": MUTE}, name="musical_demo")
    x, sr = read_wav(r["wav"])
    y = x.mean(axis=1)
    return y / (np.abs(y).max() + 1e-9) * 0.7, sr


y, sr = demo()
check(float(np.abs(y).max()) > 0.1 and np.isfinite(y).all(), f"demo bass line: {len(y) / sr:.1f} s rendered")
if "--demo" in sys.argv:
    with wave.open(os.path.join(HERE, "../docs/musical_demo.wav"), "wb") as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(int(sr)); w.writeframes((y * 32767).astype("<i2").tobytes())
    print(f"musical_demo.wav written: {len(y) / sr:.1f} s")

print(f"{PASSED[0]} passed" + (f", {len(FAILS)} FAILED" if FAILS else ""))
sys.exit(1 if FAILS else 0)
