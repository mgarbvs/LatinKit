"""End-to-end checks of m4l/Timbales.amxd in real standalone Max (needs Max, not Live), from a cold start: parameters, every drum x stroke against the
Node shim (same peak, same energy), tuning, Stroke changed between hits (a mute damps the head, a cascara doesn't), controls, extremes.
With --demo also writes docs/demo.wav (two device instances, High and Low, mixed: a cascara pattern in son clave then a mambo-ish fill).

    uv run --directory $MAXTEST_DIR python <repo>/Timbales/tests/test_voice_max.py [--demo]
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
DEV = os.path.join(HERE, "../m4l/Timbales.amxd")
RESTART = os.path.join(HERE, "../scripts/max_restart.sh")
sys.path.insert(0, os.path.join(HERE, "../scripts"))
sys.path.insert(0, HERE)
import timbales_engine as E  # noqa: E402

FAILS = []
PASSED = [0]
DEFAULTS = {ln: d for _, ln, _, _, d, *_ in E.PARAMS}
META = {ln: (lo, hi) for _, ln, lo, hi, *_ in E.PARAMS}
DIRTY = set()
NOTE = 60
OUTDIR = os.environ.get("TIMB_OUT", "")


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
    for s in range(6):
        x, sr, r = play(d, s, 1200)
        pk, en = stats(x, sr)
        rp, re = ref[(d, s)]
        dp, de = pk - rp, en - re
        check(r["nan_count"] == 0 and r["inf_count"] == 0 and abs(dp) < 3.5 and abs(de) < 2.5 and float(np.abs(x[:, 0] - x[:, 1]).max()) < 1e-6,
              f"{E.DRUMS[d]} {E.STROKES[s]}: peak {pk:.1f} dBFS ({dp:+.1f} vs Node), energy {de:+.1f} dB vs Node, L == R", verbose=True)

# 2. each drum's open tone is at its tuning (15 ct), at Tune 0 and +7 st
for d in range(2):
    for t in (0, 7):
        x, sr, _ = play(d, 0, 1000, {"Tune": t}, vel=100)
        m = x.mean(axis=1)
        o = onset(np.abs(m), 2e-3)
        want = E.F1[d] * 2 ** (t / 12)
        f = fft_peak(m[o + int(0.08 * sr):o + int(0.45 * sr)], sr, want * 0.85, want * 1.15)
        check(abs(1200 * np.log2(f / want)) < 15, f"{E.DRUMS[d]} open, Tune {t:+d} st: {f:.1f} Hz, want {want:.1f} ({1200 * np.log2(f / want):+.1f} ct)", verbose=True)

# 3. Stroke changed between hits (menu set 50 ms before the note): head ring 250..500 ms after
free, sr, _ = play(0, 0, 1400, vel=110, name="free")
mf = free.mean(axis=1)
t0 = onset(np.abs(mf), 2e-3) / sr
a0, a1 = int((t0 + 0.55) * sr), int((t0 + 0.85) * sr)
for stroke, nm, lim, soft in ((5, "Muted", -10, True), (2, "Cascara", -4, False), (3, "Paila", -4, False)):
    ch, sr, _ = play(0, 0, 1400, vel=110, extra=[{"t": 330, "param": "Stroke", "value": stroke}, {"t": 400, "note": NOTE, "vel": 1 if soft else 70, "dur": 60}], name=nm)
    dd = band_db(ch.mean(axis=1)[a0:a1], sr, 170, 240) - band_db(mf[a0:a1], sr, 170, 240)
    check((dd < lim) if soft else (dd > lim), f"High open, then Stroke -> {nm} between hits: the head's ring is {dd:.1f} dB re the free ring (need {'<' if soft else '>'} {lim})")
# the same note after a Stroke change is the new stroke: Rimshot has far more highs than Open
a, sr, _ = play(1, 0, 900, extra=[{"t": 340, "param": "Stroke", "value": 1}, {"t": 400, "note": NOTE, "vel": 110, "dur": 60}], name="chg")
b, sr, _ = play(1, 0, 900, extra=[{"t": 400, "note": NOTE, "vel": 110, "dur": 60}], name="nochg")
i0, i1 = int(0.396 * sr), int(0.44 * sr)
check(band_db(a.mean(axis=1)[i0:i1], sr, 2000, 8000) > band_db(b.mean(axis=1)[i0:i1], sr, 2000, 8000) + 3, "Stroke -> Rimshot between hits: the second hit has the rimshot's crack (> 3 dB more at 2-8 kHz)")
c, sr, _ = play(1, 0, 800, extra=[{"t": 300, "param": "Stroke", "value": 1}, {"t": 300, "note": NOTE, "vel": 110, "dur": 60}], name="same")
check(band_db(c.mean(axis=1)[int(0.296 * sr):int(0.34 * sr)], sr, 2000, 8000) > band_db(b.mean(axis=1)[i0:i1], sr, 2000, 8000) + 3, "Stroke menu and note in the same tick: the new stroke plays")

# 4. back-to-back notes: three cascara hits 40 ms apart all sound
ev = [{"t": 100 + 40 * k, "note": NOTE, "vel": 110, "dur": 40} for k in range(3)]
r = render(ev, 500, params={"Drum": 0, "Stroke": 2}, name="b2b")
x, sr = read_wav(r["wav"])
m = np.abs(x).max(axis=1)
o = onset(m, 2e-3)
gaps = sum(float(m[o + int((40 * k - 8) * sr / 1000):o + int((40 * k + 18) * sr / 1000)].max()) > 0.4 * float(m[o:o + int(0.01 * sr)].max()) for k in (1, 2))
check(gaps == 2, f"three cascara hits 40 ms apart all sound ({gaps + 1} of 3)")

# 4b. Vary: eight rimshots 1.4 s apart; the levels of the shell's sinusoid bands (0.4-2 kHz, first 250 ms) differ hit to hit by about 1.5 dB at Vary 100, hardly at 0
for vary, lo, hi in ((100, 0.7, 4.0), (0, 0, 0.7)):
    r = render([{"t": 100 + 1400 * k, "note": NOTE, "vel": 110, "dur": 60} for k in range(8)], 100 + 1400 * 8, params={"Drum": 0, "Stroke": 1, "Vary": vary}, name=f"vary{vary}")
    x, sr = read_wav(r["wav"])
    m = x.mean(axis=1)
    o0 = onset(np.abs(m), 2e-3)
    bands = np.array([[band_db(m[o0 + int(1.4 * k * sr):o0 + int((1.4 * k + 0.25) * sr)], sr, a, b) for a, b in ((400, 700), (700, 1100), (1100, 1700), (1700, 2200))] for k in range(8)])
    sd = float(np.median(bands.std(0, ddof=1)))
    check(lo <= sd <= hi, f"Vary {vary}: the shell bands' level differs hit to hit by {sd:.1f} dB (want {lo}..{hi})", verbose=True)

# 5. controls in the real engine
drops = {}
for dc in (100, 200):
    x, sr, _ = play(1, 0, 2400, {"Decay": dc}, vel=100, name=f"dc{dc}")
    m = x.mean(axis=1)
    o = onset(np.abs(m), 2e-3)
    drops[dc] = band_db(m[o + int(0.15 * sr):o + int(0.45 * sr)], sr, 100, 140) - band_db(m[o + int(0.75 * sr):o + int(1.05 * sr)], sr, 100, 140)
check(0.35 < drops[200] / drops[100] < 0.65, f"Decay 200 %: the head's fundamental falls {drops[200]:.1f} dB over 0.6 s vs {drops[100]:.1f} dB at 100 % (x{drops[200] / drops[100]:.2f}, want ~0.5)")
x1, sr, _ = play(0, 3, 1000, {"Shell": 50}, vel=110)
x0, sr, _ = play(0, 3, 1000, {"Shell": 0}, vel=110)
dsh = band_db(x1.mean(axis=1)[int(0.12 * sr):int(0.4 * sr)], sr, 1500, 3000) - band_db(x0.mean(axis=1)[int(0.12 * sr):int(0.4 * sr)], sr, 1500, 3000)
check(dsh > 15, f"Paila: Shell 0 takes the shell out ({dsh:.1f} dB at 1.5-3 kHz, above the High head's top mode, need > 15)")
x1, sr, _ = play(0, 3, 1500, {"Ring": 100}, vel=110)
x2, sr, _ = play(0, 3, 1500, {"Ring": 250}, vel=110)
dr = band_db(x2.mean(axis=1)[int(0.4 * sr):int(0.7 * sr)], sr, 700, 1800) - band_db(x1.mean(axis=1)[int(0.4 * sr):int(0.7 * sr)], sr, 700, 1800)
check(dr > 4, f"Paila: Ring 250 % keeps the shell ringing (+{dr:.1f} dB at 0.3-0.6 s after the hit, need > 4)")
x, sr, _ = play(0, 0, 1200, {"Press": 12}, vel=100, extra=[{"t": 0, "cc": 1, "value": 127}])
m = x.mean(axis=1)
o = onset(np.abs(m), 2e-3)
f = fft_peak(m[o + int(0.08 * sr):o + int(0.45 * sr)], sr, 330, 480)
check(abs(1200 * np.log2(f / (2 * E.F1[0]))) < 25, f"mod wheel 127 with Press 12: High open at {f:.1f} Hz, want {2 * E.F1[0]:.1f} ({1200 * np.log2(f / (2 * E.F1[0])):+.1f} ct)")
x, sr, _ = play(0, 0, 800, vel=127)
lo = float(np.abs(play(0, 0, 800, vel=30)[0]).max())
check(20 * np.log10(float(np.abs(x).max()) / lo) > 10, f"velocity 30 -> 127 spans {20 * np.log10(float(np.abs(x).max()) / lo):.1f} dB (> 10)")
x1, sr, _ = play(0, 1, 800, {"Volume": -9}, vel=127)
x2, sr, _ = play(0, 1, 800, {"Volume": -21}, vel=127)
dv = stats(x1, sr)[1] - stats(x2, sr)[1]
check(abs(dv - 12) < 0.5, f"Volume -9 -> -21 dB: energy {dv:.2f} dB lower (want 12)")

# 6. extremes: every control at its minimum, then maximum (menus left alone), all 12 drum x stroke one after the other via the menus
for which in (0, 1):
    p = {n: v[which] for n, v in META.items() if n not in ("Drum", "Stroke")}
    ev = [{"t": 0, "cc": 1, "value": 127}]
    for i in range(12):
        ev += [{"t": 100 + 90 * i - 20, "param": "Drum", "value": i // 6}, {"t": 100 + 90 * i - 20, "param": "Stroke", "value": i % 6},
               {"t": 100 + 90 * i, "note": NOTE, "vel": 127, "dur": 50}]
    r = render(ev, 2000, params=p, name="extreme")
    x, sr = read_wav(r["wav"])
    check(r["nan_count"] == 0 and r["inf_count"] == 0 and float(np.abs(x).max()) < 1.0001,
          f"all controls at {'max' if which else 'min'}, drum and stroke swept: peak {float(np.abs(x).max()):.3f}, nan {r['nan_count']}, inf {r['inf_count']}")

# 7. the demo: two instances (High and Low), each playing through its own Stroke menu, mixed
BPM_MS = 300       # an 8th note at 100 bpm
CLAVE = [0, 3, 6, 10, 12]                       # son clave 3-2 on an 8th grid over two bars (16 steps)
GHOST = [2, 5, 8, 14]                           # the shell fills the gaps between clave notes (our reading of a cascara, not a transcription)


def line(drum, hits, name):
    """hits: [(ms, stroke, vel)] -> events with the Stroke menu set 25 ms ahead whenever it changes"""
    ev, cur = [], None
    for t, st, v in sorted(hits):
        if st != cur:
            ev.append({"t": t - 25, "param": "Stroke", "value": st})
            cur = st
        ev.append({"t": t, "note": NOTE, "vel": v, "dur": 40})
    ms = int(max(t for t, _, _ in hits) + 2500)
    r = render(ev, ms, params={"Drum": drum, "Stroke": hits[0][1]}, name=name)
    x, sr = read_wav(r["wav"])
    return x.mean(axis=1), sr, ms


def demo():
    hi, lo = [], []
    t0 = 200
    for cyc in range(4):                          # 4 x 2 bars of cascara in 3-2 clave; the Low drum joins on the open tone from cycle 3
        for s in range(16):
            t = t0 + (cyc * 16 + s) * BPM_MS
            if s in CLAVE:
                hi.append((t, 2, 105 if s in (0, 6) else 95))
            elif s in GHOST:
                hi.append((t, 2, 55))
            if cyc >= 2 and s in (6, 14):
                lo.append((t, 0, 80))
        if cyc == 3:                              # cycle 4: paila on the clave "3" side
            for s in (0, 3, 6):
                hi.append((t0 + (cyc * 16 + s) * BPM_MS + 15, 3, 70))
    tf = t0 + 64 * BPM_MS                          # the fill (2 bars): rimshots, an open-stroke figure on the Low, an abanico roll into the downbeat
    for s, st, v in ((0, 1, 120), (2, 1, 100), (3, 1, 110), (6, 1, 120), (8, 1, 105), (10, 1, 115)):
        hi.append((tf + s * BPM_MS, st, v))
    for s, v in ((1, 100), (4, 105), (5, 90), (7, 110), (9, 100)):
        lo.append((tf + s * BPM_MS, 0, v))
    for k in range(14):                            # abanico: a rimshot roll that speeds up and swells, resolving on the downbeat
        hi.append((tf + 12 * BPM_MS + int(sum(150 - 7 * j for j in range(k))), 1, 60 + 4 * k))
    hi.append((tf + 16 * BPM_MS, 1, 127))
    lo.append((tf + 16 * BPM_MS, 0, 127))
    a, sr, ms = line(0, hi, "demo_high")
    b, sr, _ = line(1, lo, "demo_low")
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
