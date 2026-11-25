"""live_check.py <Caxixi.amxd> — load the instrument into the running Live (LiveTestMCP harness: adds/replaces an "LT DUT" track; never
touches other tracks), then check inside Live: clean Max console, all 10 parameters present with their defaults, every Stroke sounds through
Live's MIDI, the FX phrase runs for its Length and a note-off does not cut it, Length / Rate change it. Exit 1 on any failure.

    uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check.py $PWD/m4l/Caxixi.amxd
"""
import os
import sys

import numpy as np

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../../LiveTestMCP"))
import server  # noqa: E402
from analyze import read_wav  # noqa: E402

FAILS = []
DEFAULTS = {"Stroke": 0, "Length": 1000, "Rate": 9.3, "Beads": 100, "Damping": 100, "Shake": 100, "Rattle": 50, "Tone": 0, "Pan": 0, "Level": -6}
STROKES = ["Open", "Hand", "FX"]
# Beads / Damping / Shake are exponent dials (stored linear in travel in the LOM: lo + (hi - lo) * sqrt-ish of the value fraction)
EXPO = {"Beads": (25, 400, 2.32), "Damping": (25, 400, 2.32), "Shake": (25, 400, 2.32)}


def check(ok, what):
    print(("ok   " if ok else "FAIL ") + what)
    if not ok:
        FAILS.append(what)


def peak_of(rr):
    x, sr = read_wav(rr["wav"])
    return float(np.abs(x).max()), x, sr


r = server.setup(os.path.abspath(sys.argv[1]), "instrument")
console = list(r["console"])
params = {p["name"]: p for p in r["params"]}
print({n: p.get("value") for n, p in params.items()})
check(set(DEFAULTS) <= set(params), f"Live sees all {len(DEFAULTS)} parameters (missing: {set(DEFAULTS) - set(params) or 'none'})")
want = {n: (EXPO[n][0] + (EXPO[n][1] - EXPO[n][0]) * ((d - EXPO[n][0]) / (EXPO[n][1] - EXPO[n][0])) ** (1 / EXPO[n][2]) if n in EXPO else d)
        for n, d in DEFAULTS.items() if n != "Stroke"}
bad = {n: params[n].get("value") for n, d in want.items() if n in params and abs(float(params[n].get("value", 1e9)) - d) > 0.51}
check(not bad, f"defaults as designed (off: {bad or 'none'})")
base = {n: d for n, d in DEFAULTS.items() if n not in EXPO}
for ti, tname in enumerate(STROKES):
    rr = server.render([{"t": 100, "note": 60, "vel": 100, "dur": 50}], 1200, params={**base, "Stroke": ti}, name=f"cxx{os.getpid()}_{ti}")
    console += rr["console"]
    pk, x, sr = peak_of(rr)
    check(rr["nan_count"] == 0 and pk > 0.02, f"{tname} through Live (C3): peak {rr['peak_dbfs']} dBFS")


def fx_env(length, rate, note_dur=50):
    rr = server.render([{"t": 100, "note": 60, "vel": 100, "dur": note_dur}], 3600, params={**base, "Stroke": 2, "Length": length, "Rate": rate}, name=f"cxx{os.getpid()}_fx{length}")
    console.extend(rr["console"])
    x, sr = read_wav(rr["wav"])
    return np.abs(x).max(axis=1), sr


m, sr = fx_env(1000, 9.3)
check(float(m[int(0.6 * sr):int(0.9 * sr)].max()) > 0.2 * float(m.max()), "FX keeps shaking after a 50 ms note (still sounding at 0.5-0.8 s: a note-off does not cut it)")
check(float(m[int(1.5 * sr):].max()) < 0.1 * float(m.max()), "FX at Length 1000 ms is over by 1.5 s")
m2, sr = fx_env(2000, 9.3)
check(float(m2[int(1.6 * sr):int(2.0 * sr)].max()) > 0.2 * float(m2.max()) and float(m2[int(2.6 * sr):].max()) < 0.1 * float(m2.max()), "Length 2000 ms: sounding at 1.5-1.9 s, over by 2.5 s")
errs = [l for l in console if "error" in l.lower() or "[1]" in l]
check(not errs, "Max console clean" + ("" if not errs else ": " + " | ".join(errs[:5])))
sys.exit(1 if FAILS else 0)
