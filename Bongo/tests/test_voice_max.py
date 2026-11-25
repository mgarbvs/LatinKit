"""End-to-end checks of m4l/Bongo.amxd in real standalone Max (needs Max, not Live), from a cold start: parameters, every drum x stroke against the
Node shim (same peak, same energy), tuning, Stroke changed between hits (a heel damps the head, an open stroke much less), flam, controls, extremes.
With --demo also writes docs/demo.wav (two device instances, Macho and Hembra, mixed: a martillo pattern then a fill).

    uv run --directory $MAXTEST_DIR python <repo>/Bongo/tests/test_voice_max.py [--demo]
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
DEV = os.path.join(HERE, "../m4l/Bongo.amxd")
RESTART = os.path.join(HERE, "../scripts/max_restart.sh")
sys.path.insert(0, os.path.join(HERE, "../scripts"))
sys.path.insert(0, HERE)
import bongo_engine as E  # noqa: E402

FAILS = []
PASSED = [0]
DEFAULTS = {ln: d for _, ln, _, _, d, *_ in E.PARAMS}
META = {ln: (lo, hi) for _, ln, lo, hi, *_ in E.PARAMS}
DIRTY = set()
NOTE = 60
OUTDIR = os.environ.get("BONGO_OUT", "")


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


def play(drum, stroke, ms=1200, params=None, vel=127, extra=(), name=None):
    r = render([{"t": 100, "note": NOTE, "vel": vel, "dur": 60}, *extra], ms, params={"Drum": drum, "Stroke": stroke, "Vary": 0, **(params or {})}, name=name or f"t{drum}{stroke}")
    x, sr = read_wav(r["wav"])
    if OUTDIR:
        shutil.copy(r["wav"], os.path.join(OUTDIR, f"{E.DRUMS[drum]}_{E.STROKES[stroke]}_{name or ''}.wav"))
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
    """the Node shim's peak and 0.8 s energy per drum x stroke at velocity 1 (the numbers Max must reproduce; computed by tests/node_stats.py with the system python)"""
    import json
    o = subprocess.run(["/opt/homebrew/bin/python3", os.path.join(HERE, "node_stats.py")], capture_output=True, text=True, check=True).stdout
    return {tuple(int(v) for v in k.split(",")): tuple(x) for k, x in json.loads(o.strip().splitlines()[-1]).items()}


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

# 1. every drum x stroke (Vary 0, as in every play(): Node and Max draw different jitter): peak within 3.5 dB and 0.8 s energy within 2.5 dB of the Node shim (the tick noise differs hit to hit), sounds, L == R
for d in range(2):
    for s in range(7):
        x, sr, r = play(d, s, 1200)
        pk, en = stats(x, sr)
        rp, re = ref[(d, s)]
        dp, de = pk - rp, en - re
        check(r["nan_count"] == 0 and r["inf_count"] == 0 and abs(dp) < 3.5 and abs(de) < 2.5 and float(np.abs(x[:, 0] - x[:, 1]).max()) < 1e-6,
              f"{E.DRUMS[d]} {E.STROKE_MENU[s]}: peak {pk:.1f} dBFS ({dp:+.1f} vs Node), energy {de:+.1f} dB vs Node, L == R", verbose=True)

# 2. Tune +7 st moves the head's strongest tone up a fifth (250-1000 Hz, 80..450 ms in), and Tune 0 puts the lowest group near each drum's F1
for d in range(2):
    fs = {}
    for t in (0, 7):
        x, sr, _ = play(d, 0, 1000, {"Tune": t}, vel=100)
        m = x.mean(axis=1)
        o = onset(np.abs(m), 2e-3)
        fs[t] = fft_peak(m[o + int(0.08 * sr):o + int(0.45 * sr)], sr, 250, 1000 * 1.5 if t else 1000)
    check(abs(1200 * np.log2(fs[7] / fs[0]) - 700) < 25, f"{E.DRUMS[d]} open: Tune 0 -> +7 st moves the strongest head tone {fs[0]:.1f} -> {fs[7]:.1f} Hz ({1200 * np.log2(fs[7] / fs[0]):+.0f} ct, want 700)", verbose=True)

# 3. Stroke changed between hits (menu set 25 ms ahead of the note at 80 ms): head ring (250-450 Hz) 120..320 ms after the second hit, against the free ring
free, sr, _ = play(0, 0, 700, vel=110, name="free")
mf = free.mean(axis=1)
t0 = onset(np.abs(mf), 2e-3) / sr
a0, a1 = int((t0 + 0.2) * sr), int((t0 + 0.4) * sr)
res = {}
for stroke, nm in ((3, "Heel"), (4, "Tip"), (0, "Open")):
    ch, sr, _ = play(0, 0, 700, vel=110, extra=[{"t": 175, "param": "Stroke", "value": stroke}, {"t": 200, "note": NOTE, "vel": 1, "dur": 60}], name=nm)
    res[nm] = band_db(ch.mean(axis=1)[a0:a1], sr, 250, 450) - band_db(mf[a0:a1], sr, 250, 450)
check(res["Heel"] < -10, f"Macho open, then Stroke -> Heel between hits (quiet): the head's ring is {res['Heel']:.1f} dB re the free ring (need < -10)")
check(res["Tip"] < -3, f"Macho open, then Stroke -> Tip between hits (quiet): the head's ring is {res['Tip']:.1f} dB re the free ring (need < -3)")
check(res["Heel"] < res["Open"] - 3, f"the Heel damps the ring more than an Open does ({res['Heel']:.1f} vs {res['Open']:.1f} dB re free)")
# the same note after a Stroke change is the new stroke: Slap has far more highs than Open
a, sr, _ = play(0, 0, 900, extra=[{"t": 340, "param": "Stroke", "value": 2}, {"t": 400, "note": NOTE, "vel": 110, "dur": 60}], name="chg")
b, sr, _ = play(0, 0, 900, extra=[{"t": 400, "note": NOTE, "vel": 110, "dur": 60}], name="nochg")
i0, i1 = int(0.396 * sr), int(0.44 * sr)
dcr = band_db(a.mean(axis=1)[i0:i1], sr, 1500, 8000) - band_db(b.mean(axis=1)[i0:i1], sr, 1500, 8000)
check(dcr > 3, f"Stroke -> Slap between hits: the second hit has the slap's crack ({dcr:.1f} dB more at 1.5-8 kHz, need > 3)")
c, sr, _ = play(0, 0, 800, extra=[{"t": 300, "param": "Stroke", "value": 2}, {"t": 300, "note": NOTE, "vel": 110, "dur": 60}], name="same")
dsame = band_db(c.mean(axis=1)[int(0.296 * sr):int(0.34 * sr)], sr, 1500, 8000) - band_db(b.mean(axis=1)[i0:i1], sr, 1500, 8000)
check(dsame > 3, f"Stroke menu and note in the same tick: the new stroke plays ({dsame:.1f} dB more at 1.5-8 kHz, need > 3)")

# 4. back-to-back notes: three Tip hits 40 ms apart all sound; a Flam is two hits 42 ms apart in Max too
ev = [{"t": 100 + 40 * k, "note": NOTE, "vel": 110, "dur": 40} for k in range(3)]
r = render(ev, 500, params={"Drum": 0, "Stroke": 4, "Vary": 0}, name="b2b")
x, sr = read_wav(r["wav"])
m = np.abs(x).max(axis=1)
o = onset(m, 2e-3)
gaps = sum(float(m[o + int((40 * k - 8) * sr / 1000):o + int((40 * k + 18) * sr / 1000)].max()) > 0.3 * float(m[o:o + int(0.01 * sr)].max()) for k in (1, 2))
check(gaps == 2, f"three Tip hits 40 ms apart all sound ({gaps + 1} of 3)")
fl, sr, _ = play(0, 6, 600, vel=110, name="flam")
op, sr, _ = play(0, 0, 600, vel=110, name="flamref")
mfl, mop = np.abs(fl).max(axis=1), np.abs(op).max(axis=1)
o = onset(mfl, 2e-3)
def seg(m, t0, t1): return float(np.sqrt(np.mean(m[o + int(t0 * sr):o + int(t1 * sr)] ** 2)))
check(seg(mfl, 0.043, 0.052) > seg(mfl, 0.034, 0.042) * 1.1 and seg(mop, 0.043, 0.052) < seg(mop, 0.034, 0.042), "Flam: the energy rises again 42 ms after the first hit where an Open keeps falling")

# 4b. Vary: eight Heel strokes 1.4 s apart; the levels of the head's sinusoid bands (250-1300 Hz, first 250 ms) differ hit to hit by about 1.5 dB at Vary 100, hardly at 0
for vary, lo, hi in ((100, 1.5, 4.5), (0, 0, 1.2)):      # at Vary 0 the noise bands' own randomness shows (0.8 dB)
    r = render([{"t": 100 + 1400 * k, "note": NOTE, "vel": 110, "dur": 60} for k in range(8)], 100 + 1400 * 8, params={"Drum": 0, "Stroke": 0, "Vary": vary}, name=f"vary{vary}")
    x, sr = read_wav(r["wav"])
    m = x.mean(axis=1)
    o0 = onset(np.abs(m), 2e-3)
    bands = np.array([[band_db(m[o0 + int(1.4 * k * sr):o0 + int((1.4 * k + 0.25) * sr)], sr, a, b) for a, b in ((250, 400), (400, 700), (700, 1000), (1000, 1500))] for k in range(8)])
    sd = float(np.median(bands.std(0, ddof=1)))
    check(lo <= sd <= hi, f"Vary {vary}: the head bands' level differs hit to hit by {sd:.1f} dB (want {lo}..{hi})", verbose=True)

# 5. controls in the real engine
drops = {}
for dc in (100, 200):
    x, sr, _ = play(1, 0, 1600, {"Decay": dc}, vel=100, name=f"dc{dc}")
    m = x.mean(axis=1)
    o = onset(np.abs(m), 2e-3)
    drops[dc] = band_db(m[o + int(0.12 * sr):o + int(0.27 * sr)], sr, 250, 450) - band_db(m[o + int(0.27 * sr):o + int(0.42 * sr)], sr, 250, 450)
check(0.3 < drops[200] / drops[100] < 0.7, f"Decay 200 %: the head's tones fall {drops[200]:.1f} dB from 0.12-0.27 s to 0.27-0.42 s vs {drops[100]:.1f} dB at 100 % (x{drops[200] / drops[100]:.2f}, want ~0.5)")
x1, sr, _ = play(1, 4, 800, {"Shell": 100}, vel=110)
x0, sr, _ = play(1, 4, 800, {"Shell": 0}, vel=110)
m1, m0_ = x1.mean(axis=1), x0.mean(axis=1)
o1, o0_ = onset(np.abs(m1), 2e-3), onset(np.abs(m0_), 2e-3)
dsh = band_db(m1[o1:o1 + int(0.05 * sr)], sr, 100, 150) - band_db(m0_[o0_:o0_ + int(0.05 * sr)], sr, 100, 150)
check(dsh > 4, f"Hembra tip: Shell 100 vs 0 puts {dsh:.1f} dB more into 100-150 Hz (the body, need > 4)")
fa = {}
for sk in (0, 100):
    x, sr, _ = play(0, 0, 600, {"Skin": sk}, vel=110)
    m = x.mean(axis=1)
    fa[sk] = band_db(m[int(0.11 * sr):int(0.3 * sr)], sr, 1500, 4000) - band_db(m[int(0.11 * sr):int(0.3 * sr)], sr, 250, 500)
check(fa[100] > fa[0] + 8, f"Skin 100 vs 0: the 1.5-4 kHz overtones are {fa[100] - fa[0]:.1f} dB stronger against the fundamental (need > 8)")
x1, sr, _ = play(0, 0, 400, {"Touch": 100}, vel=110)
x0, sr, _ = play(0, 0, 400, {"Touch": 0}, vel=110)
dt = band_db(x1.mean(axis=1)[int(0.1 * sr):int(0.14 * sr)], sr, 3000, 11000) - band_db(x0.mean(axis=1)[int(0.1 * sr):int(0.14 * sr)], sr, 3000, 11000)
check(dt > 3, f"Touch 100 vs 0: {dt:.1f} dB more energy at 3-11 kHz in the first 40 ms (need > 3)")
m0 = play(0, 0, 1000, vel=100)[0].mean(axis=1)
o0 = onset(np.abs(m0), 2e-3)
f0 = fft_peak(m0[o0 + int(0.08 * sr):o0 + int(0.45 * sr)], sr, 250, 1000)
x, sr, _ = play(0, 0, 1000, {"Press": 12}, vel=100, extra=[{"t": 0, "cc": 1, "value": 127}])
m = x.mean(axis=1)
o = onset(np.abs(m), 2e-3)
f = fft_peak(m[o + int(0.08 * sr):o + int(0.45 * sr)], sr, 500, 2000)
check(abs(1200 * np.log2(f / f0) - 1200) < 40, f"mod wheel 127 with Press 12: Macho open's strongest tone {f0:.1f} -> {f:.1f} Hz ({1200 * np.log2(f / f0):+.0f} ct, want +1200)")
render([{"t": 0, "cc": 1, "value": 0}], 200, params={}, name="wheel0")      # the device keeps the wheel
x, sr, _ = play(0, 0, 800, vel=127)
lo = float(np.abs(play(0, 0, 800, vel=30)[0]).max())
check(20 * np.log10(float(np.abs(x).max()) / lo) > 10, f"velocity 30 -> 127 spans {20 * np.log10(float(np.abs(x).max()) / lo):.1f} dB (> 10)")
x1, sr, _ = play(0, 3, 800, {"Volume": -9}, vel=127)
x2, sr, _ = play(0, 3, 800, {"Volume": -21}, vel=127)
dv = stats(x1, sr)[1] - stats(x2, sr)[1]
check(abs(dv - 12) < 0.5, f"Volume -9 -> -21 dB: energy {dv:.2f} dB lower (want 12)")

# 6. extremes: every control at its minimum, then maximum (menus left alone), all 14 drum x stroke one after the other via the menus
for which in (0, 1):
    p = {n: v[which] for n, v in META.items() if n not in ("Drum", "Stroke")}
    ev = [{"t": 0, "cc": 1, "value": 127}]
    for i in range(14):
        ev += [{"t": 100 + 90 * i - 20, "param": "Drum", "value": i // 7}, {"t": 100 + 90 * i - 20, "param": "Stroke", "value": i % 7},
               {"t": 100 + 90 * i, "note": NOTE, "vel": 127, "dur": 50}]
    r = render(ev, 2200, params=p, name="extreme")
    x, sr = read_wav(r["wav"])
    check(r["nan_count"] == 0 and r["inf_count"] == 0 and float(np.abs(x).max()) < 1.0001,
          f"all controls at {'max' if which else 'min'}, drum and stroke swept: peak {float(np.abs(x).max()):.3f}, nan {r['nan_count']}, inf {r['inf_count']}")

# 7. the demo: two instances (Macho and Hembra), each playing through its own Stroke menu, mixed
BPM_MS = 156       # an 8th note at 192 bpm, the tempo of the Latin Percussion clip "Son Bongo-192bpm" the pattern is read from
OPEN, OPEN3, SLAP, HEEL, TIP, RIM, FLAM = range(7)
# one bar of 8th notes of that clip's martillo, from its onsets (docs/SPEC.md "Demo"): (slot, drum, stroke, velocity); drum 0 Macho, 1 Hembra.
# The soft taps (pk 0.03-0.06, mostly 125 Hz) are Macho tips, the 850 Hz-rich accents Macho opens, the 350 Hz ones Hembra opens, the crackly ones slaps.
MARTILLO = [(0, 0, TIP, 35), (1, 0, OPEN, 100), (2, 0, TIP, 30), (3, 0, OPEN, 95), (4, 0, TIP, 35), (5, 1, OPEN, 100), (6, 1, OPEN, 100), (7, 0, SLAP, 110)]
MARTILLO_B = MARTILLO[:7] + [(7, 1, SLAP, 110)]       # the clip's second bar ends on a hembra-side slap


def line(drum, hits, name):
    """hits: [(ms, stroke, vel)] -> events with the Stroke menu set 25 ms ahead whenever it changes"""
    ev, cur = [], None
    for t, st, v in sorted(hits):
        if st != cur:
            ev.append({"t": t - 25, "param": "Stroke", "value": st})
            cur = st
        ev.append({"t": t, "note": NOTE, "vel": v, "dur": 40})
    ms = int(max(t for t, _, _ in hits) + 1500)
    r = render(ev, ms, params={"Drum": drum, "Stroke": hits[0][1]}, name=name)
    x, sr = read_wav(r["wav"])
    return x.mean(axis=1), sr, ms


def demo():
    """the martillo above, 4 bars (bars 2 and 4 with the second ending), then a short fill: slaps and rims alternating, a flam into the last downbeat"""
    hi, lo = [], []
    t0 = 200
    for bar in range(4):
        for slot, d, st, v in (MARTILLO if bar % 2 == 0 else MARTILLO_B):
            (hi if d == 0 else lo).append((t0 + (bar * 8 + slot) * BPM_MS, st, v))
    tf = t0 + 32 * BPM_MS
    for s_, st, v in ((0, TIP, 40), (1, OPEN, 105), (2, SLAP, 115), (3, RIM, 100), (4, SLAP, 120), (5, RIM, 105), (6, SLAP, 125), (7, SLAP, 127)):
        hi.append((tf + s_ * BPM_MS, st, v))
    for s_, v in ((1, 100), (3, 105), (5, 110), (7, 105)):
        lo.append((tf + s_ * BPM_MS, OPEN, v))
    hi.append((tf + 8 * BPM_MS, FLAM, 127))
    lo.append((tf + 8 * BPM_MS, OPEN, 127))
    a, sr, ms = line(0, hi, "demo_macho")
    b, sr, _ = line(1, lo, "demo_hembra")
    n = min(len(a), len(b))
    y = 0.8 * a[:n] + 0.8 * b[:n]
    y = y / (np.abs(y).max() + 1e-9) * 0.7
    return y, sr, ms


y, sr, ms = demo()
check(float(np.abs(y).max()) > 0.1 and np.isfinite(y).all(), f"demo pattern: {len(y) / sr:.1f} s rendered")
if "--demo" in sys.argv:
    with wave.open(os.path.join(HERE, "../docs/demo.wav"), "wb") as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(int(sr)); w.writeframes((y * 32767).astype("<i2").tobytes())
    print(f"demo.wav written: {len(y) / sr:.1f} s")

print(f"{PASSED[0]} passed" + (f", {len(FAILS)} FAILED" if FAILS else ""))
sys.exit(1 if FAILS else 0)
