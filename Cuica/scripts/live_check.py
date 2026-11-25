"""live_check.py <Cuica.amxd> — load the instrument into the running Live (LiveTestMCP harness: adds/replaces an "LT DUT" track; never
touches other tracks), then check inside Live: clean Max console, all 13 parameters with their defaults, a note in tune through Live's MIDI.
Exit 1 on any failure.

    uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check.py $PWD/m4l/Cuica.amxd
"""
import os
import sys

import numpy as np

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../../LiveTestMCP"))
import server  # noqa: E402
from analyze import read_wav  # noqa: E402

FAILS = []
DEFAULTS = {"Tune": 0, "Pressure": 55, "Speed": 60, "Stroke": 300, "Pull": 0, "Scoop": -4, "Glide": 60, "Thumb": 12, "Head": 50,
            "Rasp": 25, "Tone": 60, "Decay": 400, "Volume": -6}


def check(ok, what):
    print(("ok   " if ok else "FAIL ") + what)
    if not ok:
        FAILS.append(what)


def pitch(x, sr, near, t0, t1):   # autocorrelation peak within -7..+7 semitones of near, parabolic refinement (Hz)
    s = x[int(t0 * sr):int(t1 * sr)]
    lo, hi = int(sr / near / 1.5), int(sr / near * 1.5) + 1
    c = np.array([np.dot(s[:len(s) - lag], s[lag:]) for lag in range(lo - 1, hi + 2)])
    k = int(np.argmax(c[1:-1])) + 1
    return sr / (lo - 1 + k + 0.5 * (c[k - 1] - c[k + 1]) / (c[k - 1] - 2 * c[k] + c[k + 1]))


r = server.setup(os.path.abspath(sys.argv[1]), "instrument")
console = list(r["console"])
params = {p["name"]: p for p in r["params"]}
print({n: p.get("value") for n, p in params.items()})
check(set(DEFAULTS) <= set(params), f"Live sees all {len(DEFAULTS)} parameters (missing: {set(DEFAULTS) - set(params) or 'none'})")
# exponent dials (Stroke, Glide, Decay) are stored linear in travel in the LOM: lo + (hi - lo) * sqrt((v - lo) / (hi - lo))
RANGE = {"Stroke": (40, 800), "Glide": (0, 500), "Decay": (10, 2000)}
want = {n: (RANGE[n][0] + (RANGE[n][1] - RANGE[n][0]) * ((d - RANGE[n][0]) / (RANGE[n][1] - RANGE[n][0])) ** 0.5 if n in RANGE else d)
        for n, d in DEFAULTS.items()}
bad = {n: params[n].get("value") for n, d in want.items() if n in params and abs(float(params[n].get("value", 1e9)) - d) > 0.51}
check(not bad, f"defaults as designed (off: {bad or 'none'})")
for n in (60, 72, 84):
    rr = server.render([{"t": 100, "note": n, "vel": 100, "dur": 600}], 900, params={**{n: d for n, d in DEFAULTS.items() if n not in RANGE}, "Pull": 0}, name=f"cuica{os.getpid()}_{n}")
    console += rr["console"]
    x, sr = read_wav(rr["wav"])
    x = x.mean(axis=1)
    t0 = int(np.argmax(np.abs(x) > 0.003)) / sr
    f0 = 440 * 2 ** ((n - 69) / 12)
    c = 1200 * np.log2(pitch(x, sr, f0, t0 + 0.09, t0 + 0.125) / f0)
    check(abs(c) < 10 and rr["nan_count"] == 0 and rr["peak_dbfs"] > -30, f"MIDI {n} through Live: {c:+.1f} ct, peak {rr['peak_dbfs']} dBFS")
errs = [l for l in console if "error" in l.lower() or "[1]" in l]
check(not errs, "Max console clean" + ("" if not errs else ": " + " | ".join(errs[:5])))
sys.exit(1 if FAILS else 0)
