"""live_check_voice.py <Surdo.amxd> -- load the instrument into the running Live (LiveTestMCP harness: adds/replaces an "LT DUT" track; never
touches other tracks), then check inside Live: clean Max console, all 8 parameters with their defaults and ranges, every stroke sounds
(Stroke set through Live's parameter API), the open tone in tune, Stroke changed between hits, mod wheel. Exit 1 on any failure.

    uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check_voice.py "$PWD/m4l/Surdo.amxd"
"""
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "../../../LiveTestMCP"))
sys.path.insert(0, os.path.join(HERE, "../tests"))
sys.path.insert(0, HERE)
import server  # noqa: E402
import surdo_engine as V  # noqa: E402
E = V
from analyze import read_wav  # noqa: E402

FAILS = []
DEFAULTS = {ln: d for _, ln, _, _, d, *_ in V.PARAMS}
RANGE = {ln: (lo, hi) for _, ln, lo, hi, *_ in V.PARAMS}
NOTE = 60


def check(ok, what):
    print(("ok   " if ok else "FAIL ") + what)
    if not ok:
        FAILS.append(what)


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


r = server.setup(os.path.abspath(sys.argv[1]), "instrument")
console = list(r["console"])
params = {p["name"]: p for p in r["params"]}
print({n: p.get("value") for n, p in params.items()})
check(set(DEFAULTS) <= set(params), f"Live sees all {len(DEFAULTS)} parameters (missing: {set(DEFAULTS) - set(params) or 'none'})")
bad = {n: params[n].get("value") for n, d in DEFAULTS.items() if n in params and abs(float(params[n].get("value", 1e9)) - d) > 0.51}
check(not bad, f"defaults as designed (off: {bad or 'none'})")
badr = {n: (params[n].get("min"), params[n].get("max")) for n, (lo, hi) in RANGE.items() if n in params and (params[n].get("min"), params[n].get("max")) != (lo, hi)}
check(not badr, f"ranges as designed (off: {badr or 'none'})")
pid = os.getpid()

# every stroke: the menu is set 250 ms before each note (the Remote Script's parameter writes land within ~100 ms)
ev = []
for i in range(4):
    t = 400 + 1200 * i
    ev += [{"t": t - 250, "param": "Stroke", "value": i}, {"t": t, "note": NOTE, "vel": 110, "dur": 450}]
out = server.render(ev, 400 + 1200 * 4 + 600, name=f"surdo{pid}_all")
console += out.get("console", [])
for i, w in enumerate(out["windows"]):
    pk = w.get("peak_dbfs")
    check(pk is not None and pk > -45, f"{E.STROKE_MENU[i]}: peak {pk} dBFS")
check(out["nan_count"] == 0, f"no NaN in the 4-hit sweep ({out['nan_count']})")

fs = {}     # Tune 0 and +7 st through Live: the open tone moves a fifth
for t in (0, 7):
    rr = server.render([{"t": 300, "note": NOTE, "vel": 100, "dur": 60}], 1500, params={"Stroke": 0, "Tune": t, "Vary": 0}, name=f"surdo{pid}_open{t}")
    console += rr["console"]
    x, sr = read_wav(rr["wav"])
    m = x.mean(axis=1)
    o = int(np.argmax(np.abs(m) > 2e-3))
    fs[t] = fft_peak(m[o + int(0.3 * sr):o + int(0.8 * sr)], sr, 60, 195 if t else 130)
    check(rr["nan_count"] == 0, f"open, Tune {t}: the open tone {fs[t]:.2f} Hz")
c = 1200 * np.log2(fs[7] / fs[0])
check(abs(c - 700) < 25, f"open through Live: Tune +7 st moves it {c:+.0f} ct (want 700)")
check(abs(1200 * np.log2(fs[0] / E.F1)) < 15, f"open through Live, Tune 0: {fs[0]:.2f} Hz (recorded 86.0)")

# Stroke changed between hits: Open, Stroke -> Mute 330 ms in, a very soft second note 380 ms in: the head's ring 0.2..0.4 s after it is 10 dB under the free ring
fr = server.render([{"t": 300, "note": NOTE, "vel": 110, "dur": 60}], 1600, params={"Stroke": 0, "Vary": 0, "Tune": 0}, name=f"surdo{pid}_free")
mu = server.render([{"t": 300, "note": NOTE, "vel": 110, "dur": 60}, {"t": 630, "param": "Stroke", "value": 1}, {"t": 700, "note": NOTE, "vel": 1, "dur": 60}], 1600,
                   params={"Stroke": 0, "Vary": 0, "Tune": 0}, name=f"surdo{pid}_mute")
console += fr["console"] + mu["console"]
xf, sr = read_wav(fr["wav"])
xm, _ = read_wav(mu["wav"])
mf, mm = xf.mean(axis=1), xm.mean(axis=1)
t0 = int(np.argmax(np.abs(mf) > 2e-3))
a0, a1 = t0 + int(0.6 * sr), t0 + int(0.8 * sr)
dd = band_db(mm[a0:a1], sr, 60, 130) - band_db(mf[a0:a1], sr, 60, 130)
check(dd < -10, f"Stroke -> Mute between hits, inside Live: the open tone's ring is {dd:.1f} dB under the free ring (need < -10)")

rr0 = server.render([{"t": 300, "note": NOTE, "vel": 100, "dur": 60}], 1500, params={"Stroke": 0, "Vary": 0, "Tune": 0}, name=f"surdo{pid}_nowheel")
console += rr0["console"]
x0, sr = read_wav(rr0["wav"])
m0 = x0.mean(axis=1)
o0 = int(np.argmax(np.abs(m0) > 2e-3))
f0m = fft_peak(m0[o0 + int(0.3 * sr):o0 + int(0.8 * sr)], sr, 60, 130)
rr = server.render([{"t": 0, "cc": 1, "value": 127}, {"t": 300, "note": NOTE, "vel": 100, "dur": 60}], 1500, params={"Press": 12, "Stroke": 0, "Vary": 0, "Tune": 0}, name=f"surdo{pid}_wheel")
console += rr["console"]
x, sr = read_wav(rr["wav"])
m = x.mean(axis=1)
o = int(np.argmax(np.abs(m) > 2e-3))
f = fft_peak(m[o + int(0.3 * sr):o + int(0.8 * sr)], sr, 100, 260)
check(abs(1200 * np.log2(f / f0m) - 1200) < 60, f"mod wheel + Press 12 through Live: the open tone {f:.1f} Hz (an octave over {f0m:.1f})")
errs = [l for l in console if "error" in l.lower() or "[1]" in l]
check(not errs, "Max console clean" + ("" if not errs else ": " + " | ".join(errs[:5])))
sys.exit(1 if FAILS else 0)
