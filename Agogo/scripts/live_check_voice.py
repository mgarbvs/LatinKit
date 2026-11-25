"""live_check_voice.py <Agogo.amxd> -- load the instrument into the running Live (LiveTestMCP harness: adds/replaces an "LT DUT" track; never
touches other tracks), then check inside Live: clean Max console, all 8 parameters with their defaults and ranges, every bell x stroke sounds
(Bell and Stroke set through Live's parameter API), each bell's open tone in tune, the doublet, Stroke changed between hits. Exit 1 on any failure.

    uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check_voice.py "$PWD/m4l/Agogo.amxd"
"""
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "../../../LiveTestMCP"))
sys.path.insert(0, os.path.join(HERE, "../tests"))
sys.path.insert(0, HERE)
import server  # noqa: E402
import agogo_engine as V  # noqa: E402
E = V
T = V.load_tables()
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

# every bell x stroke: the menus are set 250 ms before each note (the Remote Script's parameter writes land within ~100 ms)
ev = []
for i in range(4):
    t = 400 + 1300 * i
    ev += [{"t": t - 250, "param": "Bell", "value": i // 2}, {"t": t - 250, "param": "Stroke", "value": i % 2}, {"t": t, "note": NOTE, "vel": 110, "dur": 450}]
out = server.render(ev, 400 + 1300 * 4 + 600, name=f"agog{pid}_all")
console += out.get("console", [])
for i, w in enumerate(out["windows"]):
    pk = w.get("peak_dbfs")
    check(pk is not None and pk > -45, f"{E.BELLS[i // 2]} {E.STROKE_MENU[i % 2]}: peak {pk} dBFS")
check(out["nan_count"] == 0, f"no NaN in the 4-hit sweep ({out['nan_count']})")

for d in range(2):      # Tune 0 and +7 st through Live: the strongest tone is the table's f1 and moves a fifth
    f1 = T["bells"][d]["f1"]
    fs = {}
    for t in (0, 7):
        rr = server.render([{"t": 300, "note": NOTE, "vel": 100, "dur": 60}], 1300, params={"Bell": d, "Stroke": 0, "Tune": t, "Vary": 0}, name=f"agog{pid}_open{d}{t}")
        console += rr["console"]
        x, sr = read_wav(rr["wav"])
        m = x.mean(axis=1)
        o = int(np.argmax(np.abs(m) > 2e-3))
        k = 1.4983 if t else 1
        fs[t] = fft_peak(m[o + int(0.1 * sr):o + int(0.7 * sr)], sr, f1 * 0.8 * k, f1 * 1.2 * k)
        check(rr["nan_count"] == 0, f"{E.BELLS[d]} open, Tune {t}: strongest tone {fs[t]:.1f} Hz")
        if d == 0 and t == 0:     # the doublet partner (+5..16 Hz over f1) holds more than the bands beside it
            seg = m[o + int(0.3 * sr):o + int(1.2 * sr)]
            pt, aw, bl = band_db(seg, sr, f1 + 5, f1 + 16), band_db(seg, sr, f1 + 22, f1 + 33), band_db(seg, sr, f1 - 33, f1 - 22)
            check(pt > aw + 6 and pt > bl + 6, f"High open through Live: the doublet partner band holds {pt - aw:.1f} dB more than +22..33 Hz and {pt - bl:.1f} dB more than -33..-22 Hz (need > 6)")
    check(abs(1200 * np.log2(fs[0] / f1)) < 15, f"{E.BELLS[d]} open through Live: Tune 0 tone {fs[0]:.1f} Hz (table {f1}, +-15 ct)")
    c = 1200 * np.log2(fs[7] / fs[0])
    check(abs(c - 700) < 25, f"{E.BELLS[d]} open through Live: Tune +7 st moves it {c:+.0f} ct (want 700)")

# Stroke changed between hits: High open, Stroke -> Mute 150 ms in, a very soft second note 200 ms in: the ring 0.5..0.9 s after the first hit is 12 dB under the free ring
fr = server.render([{"t": 300, "note": NOTE, "vel": 110, "dur": 60}], 1800, params={"Bell": 0, "Stroke": 0, "Vary": 0}, name=f"agog{pid}_free")
mu = server.render([{"t": 300, "note": NOTE, "vel": 110, "dur": 60}, {"t": 330, "param": "Stroke", "value": 1}, {"t": 500, "note": NOTE, "vel": 1, "dur": 60}], 1800,
                   params={"Bell": 0, "Stroke": 0, "Vary": 0}, name=f"agog{pid}_mute")
console += fr["console"] + mu["console"]
xf, sr = read_wav(fr["wav"])
xm, _ = read_wav(mu["wav"])
mf, mm = xf.mean(axis=1), xm.mean(axis=1)
t0 = int(np.argmax(np.abs(mf) > 2e-3))
a0, a1 = t0 + int(0.5 * sr), t0 + int(0.9 * sr)
dd = band_db(mm[a0:a1], sr, 700, 6000) - band_db(mf[a0:a1], sr, 700, 6000)
check(dd < -12, f"Stroke -> Mute between hits, inside Live: the High's ring is {dd:.1f} dB under the free ring (need < -12)")
errs = [l for l in console if "error" in l.lower() or "[1]" in l]
check(not errs, "Max console clean" + ("" if not errs else ": " + " | ".join(errs[:5])))
sys.exit(1 if FAILS else 0)
