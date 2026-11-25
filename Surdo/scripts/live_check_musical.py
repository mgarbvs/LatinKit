"""live_check_musical.py <SurdoMusical.amxd> -- load Surdo Musical into the running Live (LiveTestMCP harness: adds/replaces an "LT DUT" track) and check inside
Live: clean Max console, all 8 parameters, the open tone follows the MIDI key (mtof within 8 ct at keys 28, 41, 53, 60; 41 -> 53 an octave), Tune adds, extreme keys finite.

    uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check_musical.py "$PWD/m4l/SurdoMusical.amxd"
"""
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "../../../LiveTestMCP"))
sys.path.insert(0, HERE)
import server  # noqa: E402
import surdo_engine as V  # noqa: E402
from analyze import read_wav  # noqa: E402

FAILS = []
DEFAULTS = {ln: d for _, ln, _, _, d, *_ in V.PARAMS}
mtof = lambda k: 440 * 2 ** ((k - 69) / 12)  # noqa: E731
ct = lambda a, b: 1200 * np.log2(a / b)  # noqa: E731


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


r = server.setup(os.path.abspath(sys.argv[1]), "instrument")
console = list(r["console"])
check(set(DEFAULTS) <= {p["name"] for p in r["params"]}, f"Live sees all {len(DEFAULTS)} parameters")
pid, fs = os.getpid(), {}
for key, tune in ((28, 0), (41, 0), (53, 0), (60, 0), (41, 7), (48, 0)):
    rr = server.render([{"t": 300, "note": key, "vel": 100, "dur": 60}], 1700, params={"Stroke": 0, "Vary": 0, "Tune": tune}, name=f"surdom{pid}_{key}_{tune}")
    console += rr["console"]
    x, sr = read_wav(rr["wav"])
    m = x.mean(axis=1)
    o = int(np.argmax(np.abs(m) > 2e-3))
    f = mtof(key) * 2 ** (tune / 12)
    fs[key, tune] = fft_peak(m[o + int(0.5 * sr):o + int(1.2 * sr)], sr, 0.93 * f, 1.08 * f)
    if tune == 0:
        check(rr["nan_count"] == 0 and abs(ct(fs[key, tune], mtof(key))) < 8, f"key {key}: open tone {fs[key, tune]:.2f} Hz, mtof {mtof(key):.2f} ({ct(fs[key, tune], mtof(key)):+.1f} ct, want +-8)")
check(abs(ct(fs[53, 0], fs[41, 0]) - 1200) < 8, f"key 41 -> 53: {ct(fs[53, 0], fs[41, 0]):+.1f} ct (want 1200)")
check(abs(ct(fs[41, 7], fs[48, 0])) < 8, f"key 41 + Tune 7 vs key 48: {ct(fs[41, 7], fs[48, 0]):+.1f} ct")
for key, tune in ((0, -12), (127, 12)):
    ev = [{"t": 0, "cc": 1, "value": 127}]
    for i in range(4):
        ev += [{"t": 300 + 400 * i - 250, "param": "Stroke", "value": i}, {"t": 300 + 400 * i, "note": key, "vel": 127, "dur": 100}]
    rr = server.render(ev, 2200, params={"Tune": tune}, name=f"surdom{pid}_ext{key}")
    console += rr["console"]
    x, sr = read_wav(rr["wav"])
    check(rr["nan_count"] == 0 and rr["inf_count"] == 0 and float(np.abs(x).max()) < 1.0001, f"key {key}, Tune {tune:+d}, 4 strokes: peak {float(np.abs(x).max()):.3f}, nan {rr['nan_count']}")
errs = [l for l in console if "error" in l.lower() or "[1]" in l]
check(not errs, "Max console clean" + ("" if not errs else ": " + " | ".join(errs[:5])))
sys.exit(1 if FAILS else 0)
