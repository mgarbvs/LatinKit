"""test_strokes.py -- holds the engine to what the recordings measure (tests/fit.py, tests/measure.py), per bell (Open, kit A, Vary off, vel 0.8, medians of 3 hits):
the fundamental within 15 cents, the doublet (High: the ring's beat within 3 Hz; Low: its partner shows as the tail's strongest peak, within 3 Hz of the recording's),
T60 of the fundamental within x0.75..1.33, centroid of the first 40 ms within x0.75..1.33, t20 / t40 / rise / tick (blip) within x0.5..2 of the recording's, and the
2.5-9 kHz spectral flatness tonal (below -9 dB) and no more than 3 dB above the most noise-like recording of that bell (kits A, B, E). Mute: its fundamental's T60 under
0.35 x the Open's, its 0.3-0.5 s ring 25 dB under the Open's. Also: the maxpat's codebox equals the engine's code, and each Open peaks at E.PEAK_DB. Prints FAIL lines, exits 1 on any."""
import json
import os
import sys
import warnings

import numpy as np

warnings.filterwarnings("ignore")
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import fit  # noqa: E402
import measure as M  # noqa: E402
from refs import FIT, REFS, load  # noqa: E402

E = M.E
verbose = "-v" in sys.argv
fails = passed = 0


def check(ok, what):
    global fails, passed
    if ok:
        passed += 1
        if verbose:
            print("ok   " + what)
    else:
        fails += 1
        print("FAIL " + what)


doc = json.load(open(os.path.join(HERE, "../m4l/Agogo.maxpat")))
g = [b for b in doc["patcher"]["boxes"] if b["box"].get("text", "").startswith("gen~")][0]["box"]
cb = [b for b in g["patcher"]["boxes"] if b["box"]["maxclass"] == "codebox"][0]["box"]["code"]
check(cb == E.code(), "the maxpat's gen~ codebox is exactly agogo_engine.code() with the tables in scripts/agogo_tables.json")

T = E.load_tables()
code = fit.write_code(T)
for d in range(2):
    f1 = T["bells"][d]["f1"]
    n = E.BELLS[d]
    r = fit.ref_row(FIT[d], f1)
    sr, x, bb = fit.model_broadband(d, 0, code)
    on = int(0.05 * sr)
    o = {**M.tonal(x, sr, f1, on), **bb, "flat": M.flatness(x, sr, on=on)}
    cents = 1200 * np.log2(o["f0"] / r["f0"])
    check(abs(cents) < 15, f"{n}: fundamental {o['f0']:.1f} Hz vs the recording's {r['f0']:.1f} ({cents:+.0f} ct, +-15)")
    if d == 0:
        check(abs(o["split"] - r["split"]) < 3, f"{n}: doublet beat {o['split']:.1f} Hz vs the recording's {r['split']:.1f} (+-3)")
    check(abs(o["tail"] - r["tail"]) < 3, f"{n}: the tail's strongest peak (0.3-0.8 s) {o['tail']:.1f} Hz vs the recording's {r['tail']:.1f} (+-3: the partner)")
    check(0.75 <= o["t60"] / r["t60"] <= 1.33, f"{n}: T60 of the fundamental {o['t60']:.2f} s vs {r['t60']:.2f} (x0.75..1.33)")
    check(0.75 <= o["centroid"] / r["centroid"] <= 1.33, f"{n}: centroid of the first 40 ms {o['centroid']:.0f} Hz vs {r['centroid']:.0f} (x0.75..1.33)")
    for k in ("t20", "t40", "rise", "blip"):
        check(0.5 <= o[k] / r[k] <= 2.0, f"{n}: {k} {o[k]:.2f} vs the recording's {r[k]:.2f} (x0.5..2)")
    fl = [M.flatness(*reversed(load(nm))) for nm, (bell, _) in REFS.items() if bell == d]
    check(o["flat"] < -9 and o["flat"] <= max(fl) + 3, f"{n}: 2.5-9 kHz flatness {o['flat']:.1f} dB (recordings {min(fl):.1f}..{max(fl):.1f}; lines: below -9 and <= max + 3)")
    sr, xm, _ = fit.model_broadband(d, 1, code)
    mt = M.t60_of(xm, sr, o["f0"], on)
    check(mt < 0.35 * o["t60"], f"{n}: Mute T60 {mt:.2f} s under 0.35 x the Open's {o['t60']:.2f}")
    ring = lambda y: 10 * np.log10(np.mean(y[on + int(0.3 * sr):on + int(0.5 * sr)] ** 2) + 1e-20)  # noqa: E731
    check(ring(xm) < ring(x) - 25, f"{n}: Mute's 0.3-0.5 s ring {ring(xm) - ring(x):.0f} dB under the Open's (need < -25)")
    sr, xp = M.render([(d, 0, 1.0, 0.02)], 3.0, ["volume=0"], code=code)
    pk = 20 * np.log10(np.abs(xp).max())
    check(abs(pk - E.PEAK_DB["open"]) < 1.0, f"{n}: Open peak at vel 1, Volume 0 dB {pk:.1f} dBFS (calibrated {E.PEAK_DB['open']})")
print(f"{fails} FAILED ({passed} passed)" if fails else f"all {passed} passed")
sys.exit(1 if fails else 0)
