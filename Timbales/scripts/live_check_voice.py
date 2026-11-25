"""live_check_voice.py <Timbales.amxd> -- load the instrument into the running Live (LiveTestMCP harness: adds/replaces an "LT DUT" track; never
touches other tracks), then check inside Live: clean Max console, all 10 parameters with their defaults and ranges, every drum x stroke sounds
(Drum and Stroke set through Live's parameter API), each drum's open tone in tune, Stroke changed between hits, mod wheel. Exit 1 on any failure.

    uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check_voice.py "$PWD/m4l/Timbales.amxd"
"""
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "../../../LiveTestMCP"))
sys.path.insert(0, os.path.join(HERE, "../tests"))
sys.path.insert(0, HERE)
import server  # noqa: E402
import timbales_engine as V  # noqa: E402
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

# every drum x stroke: the menus are set 250 ms before each note (the Remote Script's parameter writes land within ~100 ms)
ev = []
for i in range(12):
    t = 400 + 700 * i
    ev += [{"t": t - 250, "param": "Drum", "value": i // 6}, {"t": t - 250, "param": "Stroke", "value": i % 6}, {"t": t, "note": NOTE, "vel": 110, "dur": 450}]
out = server.render(ev, 400 + 700 * 12 + 600, name=f"timb{pid}_all")
console += out.get("console", [])
for i, w in enumerate(out["windows"]):
    pk = w.get("peak_dbfs")
    check(pk is not None and pk > -45, f"{E.DRUMS[i // 6]} {E.STROKES[i % 6]}: peak {pk} dBFS")
check(out["nan_count"] == 0, f"no NaN in the 12-hit sweep ({out['nan_count']})")

for d in range(2):
    rr = server.render([{"t": 300, "note": NOTE, "vel": 100, "dur": 60}], 1200, params={"Drum": d, "Stroke": 0}, name=f"timb{pid}_open{d}")
    console += rr["console"]
    x, sr = read_wav(rr["wav"])
    m = x.mean(axis=1)
    o = int(np.argmax(np.abs(m) > 2e-3))
    f = fft_peak(m[o + int(0.08 * sr):o + int(0.45 * sr)], sr, E.F1[d] * 0.85, E.F1[d] * 1.15)
    c = 1200 * np.log2(f / E.F1[d])
    check(abs(c) < 15 and rr["nan_count"] == 0, f"{E.DRUMS[d]} open through Live: {f:.1f} Hz ({c:+.1f} ct from {E.F1[d]})")

# Stroke changed between hits: High open, Stroke -> Muted 150 ms in, a very soft second note 300 ms in: the head's ring 250..500 ms after it is 10 dB under the free ring
fr = server.render([{"t": 300, "note": NOTE, "vel": 110, "dur": 60}], 1800, params={"Drum": 0, "Stroke": 0}, name=f"timb{pid}_free")
mu = server.render([{"t": 300, "note": NOTE, "vel": 110, "dur": 60}, {"t": 450, "param": "Stroke", "value": 5}, {"t": 600, "note": NOTE, "vel": 1, "dur": 60}], 1800,
                   params={"Drum": 0, "Stroke": 0}, name=f"timb{pid}_mute")
console += fr["console"] + mu["console"]
xf, sr = read_wav(fr["wav"])
xm, _ = read_wav(mu["wav"])
mf, mm = xf.mean(axis=1), xm.mean(axis=1)
t0 = int(np.argmax(np.abs(mf) > 2e-3))
a0, a1 = t0 + int(0.55 * sr), t0 + int(0.8 * sr)
dd = band_db(mm[a0:a1], sr, 170, 240) - band_db(mf[a0:a1], sr, 170, 240)
check(dd < -10, f"Stroke -> Muted between hits, inside Live: the High drum's head ring is {dd:.1f} dB under the free ring (need < -10)")

rr = server.render([{"t": 0, "cc": 1, "value": 127}, {"t": 300, "note": NOTE, "vel": 100, "dur": 60}], 1200, params={"Press": 12, "Drum": 0, "Stroke": 0}, name=f"timb{pid}_wheel")
console += rr["console"]
x, sr = read_wav(rr["wav"])
m = x.mean(axis=1)
o = int(np.argmax(np.abs(m) > 2e-3))
f = fft_peak(m[o + int(0.08 * sr):o + int(0.45 * sr)], sr, 330, 480)
check(abs(1200 * np.log2(f / (2 * E.F1[0]))) < 25, f"mod wheel + Press 12 through Live: High open at {f:.1f} Hz (want {2 * E.F1[0]:.1f})")
errs = [l for l in console if "error" in l.lower() or "[1]" in l]
check(not errs, "Max console clean" + ("" if not errs else ": " + " | ".join(errs[:5])))
sys.exit(1 if FAILS else 0)
