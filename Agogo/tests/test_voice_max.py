"""End-to-end checks of m4l/Agogo.amxd in real standalone Max (needs Max, not Live), from a cold start: parameters, every bell x stroke against the
Node shim (same peak, same energy), tuning, the doublet partner, Mute (and Stroke changed between hits: a Mute stops the ring, an Open does not), Vary, controls,
extremes. With --demo also writes docs/demo.wav (two device instances, High and Low, mixed: the pattern of the LP clip "Afoxe Agogo-107bpm").

    uv run --directory $MAXTEST_DIR python <repo>/Agogo/tests/test_voice_max.py [--demo]
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
DEV = os.path.join(HERE, "../m4l/Agogo.amxd")
RESTART = os.path.join(HERE, "../scripts/max_restart.sh")
sys.path.insert(0, os.path.join(HERE, "../scripts"))
sys.path.insert(0, HERE)
import agogo_engine as E  # noqa: E402

FAILS = []
PASSED = [0]
DEFAULTS = {ln: d for _, ln, _, _, d, *_ in E.PARAMS}
META = {ln: (lo, hi) for _, ln, lo, hi, *_ in E.PARAMS}
DIRTY = set()
NOTE = 60
OUTDIR = os.environ.get("AGOGO_OUT", "")


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


def play(bell, stroke, ms=1500, params=None, vel=127, extra=(), name=None):
    r = render([{"t": 100, "note": NOTE, "vel": vel, "dur": 60}, *extra], ms, params={"Bell": bell, "Stroke": stroke, "Vary": 0, **(params or {})}, name=name or f"t{bell}{stroke}")
    x, sr = read_wav(r["wav"])
    if OUTDIR:
        shutil.copy(r["wav"], os.path.join(OUTDIR, f"{E.BELLS[bell]}_{E.STROKES[stroke]}_{name or ''}.wav"))
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
    return 20 * np.log10(float(np.abs(x).max()) + 1e-12), 10 * np.log10(float(np.mean(m[o:o + int(1.0 * sr)] ** 2)) + 1e-20)


def node_stats():
    """the Node shim's peak and 1.0 s energy per bell x stroke at velocity 1 (the numbers Max must reproduce; computed by tests/node_stats.py with the system python)"""
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

# 1. every bell x stroke (Vary 0, as in every play(): Node and Max draw different jitter): peak within 3.5 dB and 1.0 s energy within 2.5 dB of the Node shim (the tick noise differs hit to hit), sounds, L == R
for d in range(2):
    for s in range(2):
        x, sr, r = play(d, s, 1700)
        pk, en = stats(x, sr)
        rp, re = ref[(d, s)]
        dp, de = pk - rp, en - re
        check(r["nan_count"] == 0 and r["inf_count"] == 0 and abs(dp) < 3.5 and abs(de) < 2.5 and float(np.abs(x[:, 0] - x[:, 1]).max()) < 1e-6,
              f"{E.BELLS[d]} {E.STROKE_MENU[s]}: peak {pk:.1f} dBFS ({dp:+.1f} vs Node), energy {de:+.1f} dB vs Node, L == R", verbose=True)

# 2. Tune 0 puts each bell's strongest tone (0.1..0.7 s in) at the table's f1; Tune +7 st moves it a fifth; the High's doublet partner is there (the band +5..16 Hz over f1 holds more than the +22..33 Hz and -33..-22 Hz ones)
T = E.load_tables()
for d in range(2):
    f1 = T["bells"][d]["f1"]
    fs = {}
    for t in (0, 7):
        x, sr, _ = play(d, 0, 1000, {"Tune": t}, vel=100)
        m = x.mean(axis=1)
        o = onset(np.abs(m), 2e-3)
        fs[t] = fft_peak(m[o + int(0.1 * sr):o + int(0.7 * sr)], sr, f1 * 0.8 * (1.4983 if t else 1), f1 * 1.2 * (1.4983 if t else 1))
        if t == 0 and d == 0:
            seg = m[o + int(0.3 * sr):o + int(1.2 * sr)]
            pt, aw, bl = band_db(seg, sr, f1 + 5, f1 + 16), band_db(seg, sr, f1 + 22, f1 + 33), band_db(seg, sr, f1 - 33, f1 - 22)
            check(pt > aw + 6 and pt > bl + 6, f"High open in Max: the doublet partner band holds {pt - aw:.1f} dB more than +22..33 Hz and {pt - bl:.1f} dB more than -33..-22 Hz (need > 6)", verbose=True)
    check(abs(1200 * np.log2(fs[0] / f1)) < 15 and abs(1200 * np.log2(fs[7] / fs[0]) - 700) < 25,
          f"{E.BELLS[d]} open: Tune 0 -> +7 st: strongest tone {fs[0]:.1f} (table {f1}) -> {fs[7]:.1f} Hz ({1200 * np.log2(fs[7] / fs[0]):+.0f} ct, want 700)", verbose=True)

# 3. Mute: the ring 0.3..0.5 s in is 25 dB under the Open's; Stroke changed between hits (menu set 25 ms ahead of a very soft note at 200 ms): Mute stops the ring, Open does not
op, sr, _ = play(0, 0, 1500, vel=110, name="free")
mu, sr, _ = play(0, 1, 1500, vel=110, name="mute")
mf, mm = op.mean(axis=1), mu.mean(axis=1)
t0 = onset(np.abs(mf), 2e-3) / sr
a0, a1 = int((t0 + 0.3) * sr), int((t0 + 0.5) * sr)
dm = band_db(mm[a0:a1], sr, 700, 6000) - band_db(mf[a0:a1], sr, 700, 6000)
check(dm < -25, f"High: Mute's 0.3..0.5 s ring is {dm:.1f} dB under the Open's (need < -25)", verbose=True)
b0, b1 = int((t0 + 0.5) * sr), int((t0 + 0.9) * sr)
res = {}
for stroke, nm in ((1, "Mute"), (0, "Open")):
    ch, sr, _ = play(0, 0, 1500, vel=110, extra=[{"t": 275, "param": "Stroke", "value": stroke}, {"t": 300, "note": NOTE, "vel": 1, "dur": 60}], name="ch" + nm)
    res[nm] = band_db(ch.mean(axis=1)[b0:b1], sr, 700, 6000) - band_db(mf[b0:b1], sr, 700, 6000)
check(res["Mute"] < -12, f"High open, then Stroke -> Mute between hits (quiet note at 200 ms): the ring 0.5..0.9 s is {res['Mute']:.1f} dB re the free ring (need < -12)")
check(res["Open"] > -3, f"High open, then an Open at 200 ms (quiet): the ring is untouched ({res['Open']:.1f} dB re free, need > -3)")
# the same note after a Stroke change is the new stroke; menu and note in the same tick too
a, sr, _ = play(0, 0, 1500, extra=[{"t": 340, "param": "Stroke", "value": 1}, {"t": 400, "note": NOTE, "vel": 110, "dur": 60}], name="chg")
c, sr, _ = play(0, 0, 1500, extra=[{"t": 300, "param": "Stroke", "value": 1}, {"t": 300, "note": NOTE, "vel": 110, "dur": 60}], name="same")
for nm, y, t_ in (("Stroke -> Mute between hits", a, 0.4), ("Stroke menu and note in the same tick", c, 0.3)):
    d_ = band_db(y.mean(axis=1)[int((t_ + 0.35) * sr):int((t_ + 0.5) * sr)], sr, 700, 6000) - band_db(mf[int(0.45 * sr):int(0.6 * sr)], sr, 700, 6000)
    check(d_ < -5, f"{nm}: the new hit is a Mute (its ring 0.35..0.5 s after it is {d_:.1f} dB re an Open's at 0.35..0.5 s; need < -5)")

# 4. back-to-back notes: three notes 40 ms apart all sound
ev = [{"t": 100 + 40 * k, "note": NOTE, "vel": 110, "dur": 40} for k in range(3)]
r = render(ev, 500, params={"Bell": 0, "Stroke": 1, "Vary": 0}, name="b2b")
x, sr = read_wav(r["wav"])
m = np.abs(x).max(axis=1)
o = onset(m, 2e-3)
gaps = sum(float(m[o + int((40 * k - 8) * sr / 1000):o + int((40 * k + 18) * sr / 1000)].max()) > 0.3 * float(m[o:o + int(0.01 * sr)].max()) for k in (1, 2))
check(gaps == 2, f"three Mute notes 40 ms apart all sound ({gaps + 1} of 3)")

# 4b. Vary: eight High opens 2 s apart; the fundamental band's level differs hit to hit by about 1.5 dB at Vary 100, hardly at 0
for vary, lo, hi in ((100, 0.5, 4.0), (0, 0, 0.4)):
    r = render([{"t": 100 + 2000 * k, "note": NOTE, "vel": 110, "dur": 60} for k in range(8)], 100 + 2000 * 8, params={"Bell": 0, "Stroke": 0, "Vary": vary}, name=f"vary{vary}")
    x, sr = read_wav(r["wav"])
    m = x.mean(axis=1)
    o0 = onset(np.abs(m), 2e-3)
    lv = np.array([band_db(m[o0 + int(2.0 * k * sr) + int(0.02 * sr):o0 + int(2.0 * k * sr) + int(0.5 * sr)], sr, T["bells"][0]["f1"] - 3, T["bells"][0]["f1"] + 3) for k in range(8)])
    sd = float(lv.std(ddof=1))
    check(lo <= sd <= hi, f"Vary {vary}: the fundamental band's level differs hit to hit by {sd:.2f} dB (want {lo}..{hi})", verbose=True)

# 5. controls in the real engine
slopes = {}
for dc in (100, 200):
    x, sr, _ = play(1, 0, 2000, {"Decay": dc}, vel=100, name=f"dc{dc}")
    m = x.mean(axis=1)
    o = onset(np.abs(m), 2e-3)
    slopes[dc] = band_db(m[o + int(0.05 * sr):o + int(0.35 * sr)], sr, 900, 1100) - band_db(m[o + int(0.3 * sr):o + int(0.6 * sr)], sr, 900, 1100)
check(slopes[200] < slopes[100] - 4 and slopes[200] > 0, f"Low open, Decay 200 %: the tone falls {slopes[200]:.1f} dB between 0.05-0.35 s and 0.3-0.6 s vs {slopes[100]:.1f} dB at 100 % (a slower fall)")
fa = {}
for tn in (0, 100):
    x, sr, _ = play(0, 0, 600, {"Tone": tn}, vel=110)
    m = x.mean(axis=1)
    o = onset(np.abs(m), 2e-3)
    fa[tn] = band_db(m[o + int(0.01 * sr):o + int(0.15 * sr)], sr, 5000, 11000) - band_db(m[o + int(0.01 * sr):o + int(0.15 * sr)], sr, 1300, 1700)
check(fa[100] > fa[0] + 8, f"Tone 100 vs 0: the 5-11 kHz partials are {fa[100] - fa[0]:.1f} dB stronger against the fundamental (need > 8)")
x1, sr, _ = play(0, 0, 500, {"Touch": 100}, vel=110)
x0, sr, _ = play(0, 0, 500, {"Touch": 0}, vel=110)
o1, o0_ = onset(np.abs(x1.mean(axis=1)), 2e-3), onset(np.abs(x0.mean(axis=1)), 2e-3)
dt = band_db(x1.mean(axis=1)[o1:o1 + int(0.05 * sr)], sr, 3000, 11000) - band_db(x0.mean(axis=1)[o0_:o0_ + int(0.05 * sr)], sr, 3000, 11000)
check(dt > 3, f"Touch 100 vs 0: {dt:.1f} dB more energy at 3-11 kHz in the first 50 ms (need > 3)")
x, sr, _ = play(0, 0, 800, vel=127)
lo = float(np.abs(play(0, 0, 800, vel=30)[0]).max())
check(20 * np.log10(float(np.abs(x).max()) / lo) > 10, f"velocity 30 -> 127 spans {20 * np.log10(float(np.abs(x).max()) / lo):.1f} dB (> 10)")
x1, sr, _ = play(0, 1, 800, {"Volume": -9}, vel=127)
x2, sr, _ = play(0, 1, 800, {"Volume": -21}, vel=127)
dv = stats(x1, sr)[1] - stats(x2, sr)[1]
check(abs(dv - 12) < 0.5, f"Volume -9 -> -21 dB: energy {dv:.2f} dB lower (want 12)")

# 6. extremes: every control at its minimum, then maximum (menus left alone), all 4 bell x stroke one after the other via the menus; the mod wheel does nothing
for which in (0, 1):
    p = {n: v[which] for n, v in META.items() if n not in ("Bell", "Stroke")}
    ev = [{"t": 0, "cc": 1, "value": 127}]
    for i in range(4):
        ev += [{"t": 100 + 400 * i - 20, "param": "Bell", "value": i // 2}, {"t": 100 + 400 * i - 20, "param": "Stroke", "value": i % 2},
               {"t": 100 + 400 * i, "note": NOTE, "vel": 127, "dur": 50}]
    r = render(ev, 2000, params=p, name="extreme")
    x, sr = read_wav(r["wav"])
    check(r["nan_count"] == 0 and r["inf_count"] == 0 and float(np.abs(x).max()) < 1.0001,
          f"all controls at {'max' if which else 'min'}, bell and stroke swept: peak {float(np.abs(x).max()):.3f}, nan {r['nan_count']}, inf {r['inf_count']}")
render([{"t": 0, "cc": 1, "value": 0}], 200, params={}, name="wheel0")      # put the wheel back
w0, sr, _ = play(0, 0, 800, vel=100)
ww, sr, _ = play(0, 0, 800, vel=100, extra=[{"t": 0, "cc": 1, "value": 127}])
render([{"t": 0, "cc": 1, "value": 0}], 200, params={}, name="wheel0b")
check(abs(stats(w0, sr)[1] - stats(ww, sr)[1]) < 1.5, f"mod wheel at 127 changes nothing (energy {stats(w0, sr)[1]:.1f} vs {stats(ww, sr)[1]:.1f} dB)")

# 7. the demo: two instances (High and Low), each playing through its own Bell menu, mixed. The pattern is read from the onsets of the LP clip "Afoxe Agogo-107bpm":
# an 8-note figure on a 16th-note grid (16th = 140.2 ms at 107 bpm); the clip alternates the two bells of kit A (High 1470 Hz, Low 1003 Hz). The clip is a MIDI render of the pack's
# own one-shots (every hit identical), so velocities are ours: 100 on the beat, 85 on the syncopations. Bars A B A A, 4 bars then a last High on the downbeat.
STEP_MS = 140.2
BAR_A = [(0, "H"), (2, "L"), (4, "H"), (6, "L"), (7, "H"), (9, "H"), (10, "L"), (12, "H"), (14, "L")]
BAR_B = [(0, "H"), (2, "L"), (4, "H"), (6, "L"), (9, "H"), (10, "L"), (12, "H"), (14, "L")]
FIGURE = [BAR_A, BAR_B, BAR_A, BAR_A]


def line(bell, hits, name):
    ev = [{"t": t, "note": NOTE, "vel": v, "dur": 40} for t, v in hits]
    ms = int(max(t for t, _ in hits) + 2200)
    r = render(ev, ms, params={"Bell": bell, "Stroke": 0}, name=name)
    x, sr = read_wav(r["wav"])
    return x.mean(axis=1), sr


def demo():
    hi, lo = [], []
    t0 = 200
    for b, bar in enumerate(FIGURE):
        for slot, k in bar:
            (hi if k == "H" else lo).append((t0 + (b * 16 + slot) * STEP_MS, 100 if slot % 2 == 0 else 85))
    hi.append((t0 + 64 * STEP_MS, 110))
    lo.append((t0 + 64 * STEP_MS, 110))
    a, sr = line(0, hi, "demo_high")
    b, sr = line(1, lo, "demo_low")
    n = min(len(a), len(b))
    y = 0.8 * a[:n] + 0.8 * b[:n]
    return y / (np.abs(y).max() + 1e-9) * 0.7, sr


y, sr = demo()
check(float(np.abs(y).max()) > 0.1 and np.isfinite(y).all(), f"demo pattern: {len(y) / sr:.1f} s rendered")
if "--demo" in sys.argv:
    with wave.open(os.path.join(HERE, "../docs/demo.wav"), "wb") as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(int(sr)); w.writeframes((y * 32767).astype("<i2").tobytes())
    print(f"demo.wav written: {len(y) / sr:.1f} s")

print(f"{PASSED[0]} passed" + (f", {len(FAILS)} FAILED" if FAILS else ""))
sys.exit(1 if FAILS else 0)
