"""End-to-end checks of m4l/Conga.amxd running in real standalone Max (needs Max, not Live), from a cold start: every note, each drum's
tuning, the hand's damping, controls, back-to-back and simultaneous notes, extremes. With --demo also writes docs/demo.wav.

    uv run --directory $MAXTEST_DIR python <repo>/Conga/tests/test_max_render.py [--demo]
"""
import os
import shutil
import subprocess
import sys

import numpy as np

sys.path.insert(0, os.environ["MAXTEST_DIR"])
import server  # noqa: E402
from analyze import read_wav  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
DEV = os.path.join(HERE, "../m4l/Conga.amxd")
RESTART = os.path.join(HERE, "../scripts/max_restart.sh")
sys.path.insert(0, os.path.join(HERE, "../scripts"))
import conga_engine as E  # noqa: E402

FAILS = []
PASSED = [0]
NAME = {n: ln for n, ln, *_ in E.PARAMS}        # engine name -> the long name Max reports
DEFAULTS = {ln: d for _, ln, _, _, _, d, *_ in E.PARAMS}
DIRTY = set()
SLOT_NAMES = [f"{dn} {s}" for _, dn in E.DRUMS for s in E.STROKES]


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
    params = {NAME.get(k, k): v for k, v in (params or {}).items()}
    full = {n: DEFAULTS[n] for n in DIRTY if n not in params}
    DIRTY.update(params)
    return server.render(events, ms, params={**full, **params}, name=name)


def play(slot, ms=1200, params=None, vel=127, extra=(), name=None):
    r = render([{"t": 100, "note": E.NOTES[slot], "vel": vel, "dur": 60}, *extra], ms, params=params, name=name or f"s{slot}")
    x, sr = read_wav(r["wav"])
    return x, sr, r


def fft_peak(sig, sr, lo, hi):
    n = 1 << 18
    s = np.abs(np.fft.rfft(sig * np.hanning(len(sig)), n))
    a, b = int(lo * n / sr), int(hi * n / sr)
    k = a + int(np.argmax(s[a:b]))
    l, c, r = np.log(s[k - 1] + 1e-30), np.log(s[k] + 1e-30), np.log(s[k + 1] + 1e-30)
    return (k + 0.5 * (l - r) / (l - 2 * c + r)) * sr / n


def cents(f, g):
    return 1200 * np.log2(f / g)


def onset(m, thr=1e-3):
    return int(np.argmax(m > thr))


def env_t(m, sr, db, win=0.01):
    """time from the envelope's peak until it is `db` below"""
    w = max(2, int(win * sr))
    cs = np.concatenate([[0], np.cumsum(m ** 2)])
    env = np.sqrt((cs[w:] - cs[:-w]) / w)
    pk = int(np.argmax(env))
    below = np.where(env[pk:] <= env[pk] * 10 ** (-db / 20))[0]
    return below[0] / sr if len(below) else np.inf


def band_db(sig, sr, lo, hi):
    n = 1 << 16
    s = np.abs(np.fft.rfft(sig * np.hanning(len(sig)), n)) ** 2
    f = np.fft.rfftfreq(n, 1 / sr)
    return 10 * np.log10(s[(f >= lo) & (f < hi)].sum() + 1e-20)


subprocess.run(["bash", RESTART], capture_output=True)
loaded = server.load_device(DEV)
errs = [l for l in loaded["console"] if "[1]" in l]
check(not errs, f"load_device console has no [1] errors ({len(errs)} found)")
for l in errs:
    print("     " + l)
names = {p["name"] for p in loaded["params"]}
check(set(DEFAULTS) <= names, f"every engine parameter is exposed as a Live parameter (missing: {sorted(set(DEFAULTS) - names)})")
print(f"     {len(names)} parameters, sr {loaded['sr']}")

# 1. every note sounds, finite, near its calibrated level. At the default Level a velocity-127 stroke peaks at PEAK_DB + Level (+-5 dB:
# the contact noise differs hit to hit, and Spread 40 puts part of it in one channel)
for slot in range(18):
    x, sr, r = play(slot, 900)
    pk = 20 * np.log10(float(np.abs(x).max()) + 1e-12)
    want = E.PEAK_DB[E.STROKES[slot % 6]] + DEFAULTS["Level"]
    check(r["nan_count"] == 0 and r["inf_count"] == 0 and abs(pk - want) < 5.5, f"note {E.NOTES[slot]} ({SLOT_NAMES[slot]}): peak {pk:.1f} dBFS, want {want:.1f} +-5.5", verbose=True)

# 2. each drum's open tone is at its tuning (15 ct), at Tune 0 and +7 st
for d, (key, nm) in enumerate((("tuneQ", "Quinto Tune"), ("tuneC", "Conga Tune"), ("tuneT", "Tumba Tune"))):
    for t in (0, 7):
        x, sr, _ = play(d * 6, 900, {key: t}, vel=100)
        m = x.mean(axis=1)
        o = onset(np.abs(m), 2e-3)
        want = E.F1[d] * 2 ** (t / 12)
        f = fft_peak(m[o + int(0.08 * sr):o + int(0.45 * sr)], sr, want * 0.85, want * 1.15)
        check(abs(cents(f, want)) < 15, f"{E.DRUMS[d][1]} open, Tune {t:+d} st: {f:.1f} Hz, want {want:.1f} ({cents(f, want):+.1f} ct)", verbose=True)

# 3. the hand damps: an open tumba, then a mute 300 ms later: its 219 Hz ring 100..300 ms later is 12 dB under the free ring
free, sr, _ = play(12, 1200, vel=110)
mut, sr, _ = play(12, 1200, vel=110, extra=[{"t": 400, "note": E.NOTES[14], "vel": 70, "dur": 60}])
mf, mm = free.mean(axis=1), mut.mean(axis=1)
t0 = onset(np.abs(mf), 2e-3) / sr
a0, a1 = int((t0 + 0.55) * sr), int((t0 + 0.8) * sr)       # 150..400 ms after the mute (at ~0.4 s from the open's onset)
d = band_db(mm[a0:a1], sr, 200, 240) - band_db(mf[a0:a1], sr, 200, 240)
check(d < -12, f"mute over a ringing tumba: its ring is {d:.1f} dB under the free ring (need < -12)")

# 4. back-to-back notes: three slaps 40 ms apart (note-off in the next note-on's tick) all sound; so do 18 notes at once
ev = [{"t": 100 + 40 * k, "note": E.NOTES[7], "vel": 110, "dur": 40} for k in range(3)]
r = render(ev, 500, name="b2b")
x, sr = read_wav(r["wav"])
m = np.abs(x).max(axis=1)
o = onset(m, 2e-3)
gaps = sum(float(m[o + int((40 * k - 8) * sr / 1000):o + int((40 * k + 18) * sr / 1000)].max()) > 0.5 * float(m[o:o + int(0.01 * sr)].max()) for k in (1, 2))
check(gaps == 2, f"three conga slaps 40 ms apart all sound ({gaps + 1} of 3)")
r = render([{"t": 100, "note": n, "vel": 127, "dur": 200} for n in E.NOTES], 1500, name="chord18")
x, sr = read_wav(r["wav"])
check(r["nan_count"] == 0 and r["inf_count"] == 0 and float(np.abs(x).max()) < 1.0001, f"all 18 notes at once: peak {float(np.abs(x).max()):.3f}, nan {r['nan_count']}")

# 5. controls in the real engine
x, sr, _ = play(6, 3000, {"decay": 100}, vel=100)
t100 = env_t(x.mean(axis=1), sr, 20)
x, sr, _ = play(6, 3500, {"decay": 200}, vel=100)
t200 = env_t(x.mean(axis=1), sr, 20)
check(1.6 < t200 / t100 < 2.4, f"Decay 200 %: t-20 {t200 * 1000:.0f} ms vs {t100 * 1000:.0f} ms at 100 % (x{t200 / t100:.2f}, want ~2)")
x, sr, _ = play(0, 800, vel=127)
q = float(np.abs(x[:, 1]).max()) / float(np.abs(x[:, 0]).max())
x, sr, _ = play(12, 800, vel=127)
t = float(np.abs(x[:, 1]).max()) / float(np.abs(x[:, 0]).max())
x, sr, _ = play(0, 800, {"spread": 0}, vel=127)
z = float(np.abs(x[:, 1] - x[:, 0]).max())
check(q > 1.3 and t < 0.75 and z < 1e-6, f"Spread: quinto R/L {q:.2f} (> 1.3), tumba R/L {t:.2f} (< 0.75), Spread 0 L-R {z:.1e}")
x, sr, _ = play(6, 1200, {"press": 12}, vel=100, extra=[{"t": 0, "cc": 1, "value": 127}])
m = x.mean(axis=1)
o = onset(np.abs(m), 2e-3)
f = fft_peak(m[o + int(0.08 * sr):o + int(0.45 * sr)], sr, 400, 700)
check(abs(cents(f, 2 * E.F1[1])) < 25, f"mod wheel 127 with Press 12: conga open at {f:.1f} Hz, want {2 * E.F1[1]:.1f} ({cents(f, 2 * E.F1[1]):+.1f} ct)")
x, sr, _ = play(6, 800, vel=127)
lo = float(np.abs(play(6, 800, vel=30)[0]).max())
check(20 * np.log10(float(np.abs(x).max()) / lo) > 10, f"velocity 30 -> 127 spans {20 * np.log10(float(np.abs(x).max()) / lo):.1f} dB (> 10)")

# 6. extremes: every control at its minimum, then maximum, all notes one after the other
meta = {ln: (lo, hi) for _, ln, _, lo, hi, *_ in E.PARAMS}
for which in (0, 1):
    p = {n: v[which] for n, v in meta.items()}
    ev = [{"t": 100 + 70 * i, "note": n, "vel": 127, "dur": 50} for i, n in enumerate(E.NOTES)] + [{"t": 0, "cc": 1, "value": 127}]
    r = render(ev, 2000, params=p, name="extreme")
    x, sr = read_wav(r["wav"])
    check(r["nan_count"] == 0 and r["inf_count"] == 0 and float(np.abs(x).max()) < 1.0001,
          f"all controls at {'max' if which else 'min'}: peak {float(np.abs(x).max()):.3f}, nan {r['nan_count']}, inf {r['inf_count']}")

# 7. a tumbao (16th grid at 100 bpm, 150 ms): all three drums and all six strokes
BPM_MS = 150
TUMBAO = {   # drum -> {16th: (stroke, velocity)}, two bars repeated
    "conga": {0: ("heel", 70), 2: ("toe", 60), 4: ("mute", 85), 6: ("open", 105), 7: ("open", 92), 8: ("heel", 70), 10: ("toe", 60),
              12: ("slap", 112), 14: ("open", 100), 15: ("mute", 70)},
    "tumba": {0: ("bass", 95), 6: ("open", 100), 12: ("open", 112)},
}
FILL = {"quinto": {0: ("slap", 112), 3: ("open", 92), 4: ("slap", 100), 5: ("mute", 70), 8: ("open", 100), 9: ("toe", 70), 10: ("open", 92),
                   12: ("slap", 124), 13: ("slap", 110), 14: ("toe", 60)},
        "tumba": {2: ("slap", 100), 3: ("mute", 80), 10: ("heel", 80), 11: ("bass", 100)}}


def demo():
    ev = []
    for bar in range(4):
        pat = {k: dict(v) for k, v in TUMBAO.items()}
        if bar >= 2:
            for dn, m in FILL.items():
                pat.setdefault(dn, {}).update(m)
        for dn, m in pat.items():
            d = ["quinto", "conga", "tumba"].index(dn)
            for step, (st, vel) in m.items():
                ev.append({"t": 100 + (bar * 16 + step) * BPM_MS, "note": E.NOTES[d * 6 + E.STROKES.index(st)], "vel": vel, "dur": 60})
    return ev, 100 + 64 * BPM_MS + 1500


ev, ms = demo()
used = {n for e in ev for n in [e["note"]]}
check(len(used) >= 14, f"the demo pattern uses {len(used)} of 18 notes")
r = render(ev, ms, name="demo")
x, sr = read_wav(r["wav"])
check(r["nan_count"] == 0 and float(np.abs(x).max()) < 1.0 and 20 * np.log10(float(np.abs(x).max())) > -14, f"demo pattern: peak {r['peak_dbfs']} dBFS, nan {r['nan_count']}")
if "--demo" in sys.argv:
    shutil.copy(r["wav"], os.path.join(HERE, "../docs/demo.wav"))
    print(f"demo.wav written: peak {r['peak_dbfs']} dBFS, {ms} ms")

print(f"{PASSED[0]} passed" + (f", {len(FAILS)} FAILED" if FAILS else ""))
sys.exit(1 if FAILS else 0)
