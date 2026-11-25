"""live_check.py <Conga.amxd> -- load the instrument into the running Live (LiveTestMCP harness: adds/replaces an "LT DUT" track; never touches other
tracks), then check inside Live: clean Max console, all 11 parameters with their defaults, every note sounds, each drum's open tone in tune
through Live's MIDI, mod wheel. Exit 1 on any failure. Live bundles a newer Max than standalone and its gen~ compiler has rejected code that
standalone Max accepted.

    uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check.py $PWD/m4l/Conga.amxd
"""
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "../../../LiveTestMCP"))
sys.path.insert(0, os.path.join(HERE, "../tests"))
sys.path.insert(0, HERE)
import server  # noqa: E402
import conga_engine as E  # noqa: E402
from analyze import read_wav  # noqa: E402

FAILS = []
DEFAULTS = {ln: d for _, ln, _, _, _, d, *_ in E.PARAMS}


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
params = {p["name"]: p for p in r["params"]}
print({n: p.get("value") for n, p in params.items()})
check(set(DEFAULTS) <= set(params), f"Live sees all {len(DEFAULTS)} parameters (missing: {set(DEFAULTS) - set(params) or 'none'})")
bad = {n: params[n].get("value") for n, d in DEFAULTS.items() if n in params and abs(float(params[n].get("value", 1e9)) - d) > 0.51}
check(not bad, f"defaults as designed (off: {bad or 'none'})")
pid = os.getpid()
ev = [{"t": 100 + 500 * i, "note": n, "vel": 110, "dur": 450} for i, n in enumerate(E.NOTES)]
out = server.render(ev, 100 + 500 * 18 + 800, name=f"conga{pid}_all")
console += out.get("console", [])
for i, (n, w) in enumerate(zip(E.NOTES, out["windows"])):
    pk = w.get("peak_dbfs")
    check(pk is not None and pk > -40, f"note {n} ({E.DRUMS[i // 6][1]} {E.STROKES[i % 6]}): peak {pk} dBFS")
for d in range(3):
    rr = server.render([{"t": 100, "note": E.NOTES[d * 6], "vel": 100, "dur": 60}], 900, name=f"conga{pid}_open{d}")
    console += rr["console"]
    x, sr = read_wav(rr["wav"])
    m = x.mean(axis=1)
    o = int(np.argmax(np.abs(m) > 2e-3))
    f = fft_peak(m[o + int(0.08 * sr):o + int(0.45 * sr)], sr, E.F1[d] * 0.85, E.F1[d] * 1.15)
    c = 1200 * np.log2(f / E.F1[d])
    check(abs(c) < 15 and rr["nan_count"] == 0, f"{E.DRUMS[d][1]} open through Live: {f:.1f} Hz ({c:+.1f} ct from {E.F1[d]})")
rr = server.render([{"t": 0, "cc": 1, "value": 127}, {"t": 100, "note": E.NOTES[6], "vel": 100, "dur": 60}], 900, params={"Press": 12}, name=f"conga{pid}_wheel")
console += rr["console"]
x, sr = read_wav(rr["wav"])
m = x.mean(axis=1)
o = int(np.argmax(np.abs(m) > 2e-3))
f = fft_peak(m[o + int(0.08 * sr):o + int(0.45 * sr)], sr, 400, 700)
check(abs(1200 * np.log2(f / (2 * E.F1[1]))) < 25, f"mod wheel + Press 12 through Live: conga open at {f:.1f} Hz (want {2 * E.F1[1]:.1f})")
errs = [l for l in console if "error" in l.lower() or "[1]" in l]
check(not errs, "Max console clean" + ("" if not errs else ": " + " | ".join(errs[:5])))
sys.exit(1 if FAILS else 0)
