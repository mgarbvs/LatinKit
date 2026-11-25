"""End-to-end checks of m4l/Conga Voice.amxd in real standalone Max (needs Max, not Live), from a cold start: parameters, every drum x stroke
against the full Conga.amxd (same peak and energy, Spread 0), tuning, Stroke changed between hits (the hand damps the ring), controls, extremes.

    uv run --directory $MAXTEST_DIR python <repo>/Conga/tests/test_voice_max.py
"""
import os
import subprocess
import sys

import numpy as np

sys.path.insert(0, os.environ["MAXTEST_DIR"])
import server  # noqa: E402
from analyze import read_wav  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
FULL = os.path.join(HERE, "../m4l/Conga.amxd")
DEV = os.path.join(HERE, "../m4l/Conga Voice.amxd")
RESTART = os.path.join(HERE, "../scripts/max_restart.sh")
sys.path.insert(0, os.path.join(HERE, "../scripts"))
import conga_engine as E  # noqa: E402
import conga_voice as V  # noqa: E402

FAILS = []
PASSED = [0]
DEFAULTS = {ln: d for _, ln, _, _, d, *_ in V.PARAMS}
META = {ln: (lo, hi) for _, ln, lo, hi, *_ in V.PARAMS}
DIRTY = set()
NOTE = 60            # any note plays the voice; the drum and stroke come from the menus


def check(cond, what, verbose=False):
    if cond:
        PASSED[0] += 1
        if verbose:
            print("ok   " + what)
    else:
        print("FAIL " + what)
        FAILS.append(what)


def render(events, ms, params=None, name="render", defaults=None):
    """server.render, first putting back the default of every parameter an earlier render changed (the device keeps them)"""
    params = params or {}
    defaults = defaults if defaults is not None else DEFAULTS
    full = {n: defaults[n] for n in DIRTY if n not in params and n in defaults}
    DIRTY.update(params)
    return server.render(events, ms, params={**full, **params}, name=name)


def play(drum, stroke, ms=1200, params=None, vel=127, extra=(), name=None):
    r = render([{"t": 100, "note": NOTE, "vel": vel, "dur": 60}, *extra], ms, params={"Drum": drum, "Stroke": stroke, **(params or {})}, name=name or f"v{drum}{stroke}")
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


def stats(x, sr):
    m = x.mean(axis=1)
    o = onset(np.abs(m), 1e-3)
    return 20 * np.log10(float(np.abs(x).max()) + 1e-12), 10 * np.log10(float(np.mean(m[o:o + int(0.8 * sr)] ** 2)) + 1e-20)


subprocess.run(["bash", RESTART], capture_output=True)

# 0. the full device first: peak and energy per drum x stroke at Spread 0 (the voice must match)
loaded = server.load_device(FULL)
fdef = {ln: d for _, ln, _, _, _, d, *_ in E.PARAMS}
ref = {}
for slot in range(18):
    r = render([{"t": 100, "note": E.NOTES[slot], "vel": 127, "dur": 60}], 1000, params={"Spread": 0}, name=f"full{slot}", defaults=fdef)
    x, sr = read_wav(r["wav"])
    ref[slot] = stats(x, sr)
DIRTY.clear()

subprocess.run(["bash", RESTART], capture_output=True)
loaded = server.load_device(DEV)
errs = [l for l in loaded["console"] if "[1]" in l]
check(not errs, f"load_device console has no [1] errors ({len(errs)} found)")
for l in errs:
    print("     " + l)
names = {p["name"] for p in loaded["params"]}
check(set(DEFAULTS) <= names, f"every engine parameter is exposed as a Live parameter (missing: {sorted(set(DEFAULTS) - names)})")
print(f"     {len(names)} parameters, sr {loaded['sr']}")

# 1. every drum x stroke: peak within 3 dB and 0.8 s energy within 2 dB of the full device (the hit noise differs hit to hit)
for d in range(3):
    for s in range(6):
        x, sr, r = play(d, s, 1000)
        pk, en = stats(x, sr)
        rp, re = ref[d * 6 + s]
        dp, de = pk - rp, en - re
        check(r["nan_count"] == 0 and r["inf_count"] == 0 and abs(dp) < 3.5 and abs(de) < 2.5 and float(np.abs(x[:, 0] - x[:, 1]).max()) < 1e-6,
              f"{E.DRUMS[d][1]} {E.STROKES[s]}: peak {pk:.1f} dBFS ({dp:+.1f} vs Conga), energy {de:+.1f} dB vs Conga, L == R", verbose=True)

# 2. each drum's open tone is at its tuning (15 ct), at Tune 0 and +7 st
for d in range(3):
    for t in (0, 7):
        x, sr, _ = play(d, 0, 900, {"Tune": t}, vel=100)
        m = x.mean(axis=1)
        o = onset(np.abs(m), 2e-3)
        want = E.F1[d] * 2 ** (t / 12)
        f = fft_peak(m[o + int(0.08 * sr):o + int(0.45 * sr)], sr, want * 0.85, want * 1.15)
        check(abs(cents(f, want)) < 15, f"{E.DRUMS[d][1]} open, Tune {t:+d} st: {f:.1f} Hz, want {want:.1f} ({cents(f, want):+.1f} ct)", verbose=True)

# 3. Stroke changed between hits: an open tumba, then the Stroke menu set to Mute and a second note 300 ms later: the ring is 12 dB under the free ring
free, sr, _ = play(2, 0, 1200, vel=110)
mut, sr, _ = play(2, 0, 1200, vel=110, extra=[{"t": 350, "param": "Stroke", "value": 2}, {"t": 400, "note": NOTE, "vel": 70, "dur": 60}])
mf, mm = free.mean(axis=1), mut.mean(axis=1)
t0 = onset(np.abs(mf), 2e-3) / sr
a0, a1 = int((t0 + 0.55) * sr), int((t0 + 0.8) * sr)
d = band_db(mm[a0:a1], sr, 200, 240) - band_db(mf[a0:a1], sr, 200, 240)
check(d < -12, f"Stroke -> Mute between hits: the tumba's ring is {d:.1f} dB under the free ring (need < -12)")
# ... and the same note after a Stroke change is the new stroke: Open then Slap on the conga has more highs than Open then Open
a, sr, _ = play(1, 0, 900, extra=[{"t": 340, "param": "Stroke", "value": 1}, {"t": 400, "note": NOTE, "vel": 110, "dur": 60}])
b, sr, _ = play(1, 0, 900, extra=[{"t": 400, "note": NOTE, "vel": 110, "dur": 60}])
ma, mb = a.mean(axis=1), b.mean(axis=1)
i0, i1 = int(0.396 * sr), int(0.44 * sr)       # the second note's first 40 ms: the crack is a few ms long
check(band_db(ma[i0:i1], sr, 2500, 8000) > band_db(mb[i0:i1], sr, 2500, 8000) + 3, "Stroke -> Slap between hits: the second hit has the slap's crack (> 3 dB more at 2.5-8 kHz)")
# a menu change followed at once by the note (same audio block) still plays the new stroke
c, sr, _ = play(1, 0, 800, extra=[{"t": 300, "param": "Stroke", "value": 1}, {"t": 300, "note": NOTE, "vel": 110, "dur": 60}])
mc = c.mean(axis=1)
check(band_db(mc[int(0.296 * sr):int(0.34 * sr)], sr, 2500, 8000) > band_db(mb[i0:i1], sr, 2500, 8000) + 3, "Stroke menu and note in the same tick: the new stroke plays")

# 4. back-to-back notes: three slaps 40 ms apart all sound
ev = [{"t": 100 + 40 * k, "note": NOTE, "vel": 110, "dur": 40} for k in range(3)]
r = render(ev, 500, params={"Drum": 1, "Stroke": 1}, name="b2b")
x, sr = read_wav(r["wav"])
m = np.abs(x).max(axis=1)
o = onset(m, 2e-3)
gaps = sum(float(m[o + int((40 * k - 8) * sr / 1000):o + int((40 * k + 18) * sr / 1000)].max()) > 0.5 * float(m[o:o + int(0.01 * sr)].max()) for k in (1, 2))
check(gaps == 2, f"three slaps 40 ms apart all sound ({gaps + 1} of 3)")

# 5. controls in the real engine
x, sr, _ = play(1, 0, 3000, {"Decay": 100}, vel=100)
t100 = env_t(x.mean(axis=1), sr, 20)
x, sr, _ = play(1, 0, 3500, {"Decay": 200}, vel=100)
t200 = env_t(x.mean(axis=1), sr, 20)
check(1.6 < t200 / t100 < 2.4, f"Decay 200 %: t-20 {t200 * 1000:.0f} ms vs {t100 * 1000:.0f} ms at 100 % (x{t200 / t100:.2f}, want ~2)")
x, sr, _ = play(1, 0, 1200, {"Press": 12}, vel=100, extra=[{"t": 0, "cc": 1, "value": 127}])
m = x.mean(axis=1)
o = onset(np.abs(m), 2e-3)
f = fft_peak(m[o + int(0.08 * sr):o + int(0.45 * sr)], sr, 400, 700)
check(abs(cents(f, 2 * E.F1[1])) < 25, f"mod wheel 127 with Press 12: conga open at {f:.1f} Hz, want {2 * E.F1[1]:.1f} ({cents(f, 2 * E.F1[1]):+.1f} ct)")
x, sr, _ = play(1, 0, 800, vel=127)
lo = float(np.abs(play(1, 0, 800, vel=30)[0]).max())
check(20 * np.log10(float(np.abs(x).max()) / lo) > 10, f"velocity 30 -> 127 spans {20 * np.log10(float(np.abs(x).max()) / lo):.1f} dB (> 10)")
x1, sr, _ = play(1, 0, 800, {"Volume": -9}, vel=127)
x2, sr, _ = play(1, 0, 800, {"Volume": -21}, vel=127)
dv = 20 * np.log10(float(np.abs(x1).max()) / float(np.abs(x2).max()))
check(abs(dv - 12) < 1.5, f"Volume -9 -> -21 dB: peak {dv:.1f} dB lower (want 12)")

# 6. extremes: every control at its minimum, then maximum (menus left alone), all 18 drum x stroke one after the other via the menus
for which in (0, 1):
    p = {n: v[which] for n, v in META.items() if n not in ("Drum", "Stroke")}
    ev = [{"t": 0, "cc": 1, "value": 127}]
    for i in range(18):
        ev += [{"t": 100 + 70 * i - 20, "param": "Drum", "value": i // 6}, {"t": 100 + 70 * i - 20, "param": "Stroke", "value": i % 6},
               {"t": 100 + 70 * i, "note": NOTE, "vel": 127, "dur": 50}]
    r = render(ev, 2000, params=p, name="extreme")
    x, sr = read_wav(r["wav"])
    check(r["nan_count"] == 0 and r["inf_count"] == 0 and float(np.abs(x).max()) < 1.0001,
          f"all controls at {'max' if which else 'min'}, drum and stroke swept: peak {float(np.abs(x).max()):.3f}, nan {r['nan_count']}, inf {r['inf_count']}")

print(f"{PASSED[0]} passed" + (f", {len(FAILS)} FAILED" if FAILS else ""))
sys.exit(1 if FAILS else 0)
