"""test_strokes.py -- renders strokes through the Node shim and checks their shape against the ranges measured on real cuicas
(tests/stroke_shape.py on the Latin Percussion pack and Freesound 21727; docs/SPEC.md round 5). Prints FAIL lines, exits 1 on any."""
import os
import subprocess
import sys
import tempfile
sys.path.insert(0, os.path.dirname(__file__))
from stroke_shape import report  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
# (note, extra params, {measure: (lo, hi)}); real: scrape 10-30 ms, rise 10-30 ms, squeak climb 240-510 ct, plain sag -12..-237 ct,
# creak low 0.28-0.53 / high 0.01-0.38, tail -21..-33 dB, ring t60 0.2-1.5 s
CASES = [(70, [], {"scrape": (10, 40), "rise": (10, 30), "climb": (200, 520), "tail": (-34, -18), "t60": (0.2, 1.5)}),
         (46, [], {"scrape": (10, 40), "rise": (10, 30), "climb": (200, 520), "creak": (0.2, 0.65), "tail": (-36, -18)}),
         (70, ["scoop=0"], {"climb": (0, 100), "sag": (-240, -10), "creak": (0, 0.4)}),
         (46, ["scoop=0"], {"climb": (0, 100), "sag": (-240, -5), "creak": (0.2, 0.65)})]
fails = 0
with tempfile.TemporaryDirectory() as d:
    for note, extra, want in CASES:
        w = os.path.join(d, f"s{note}{'_'.join(extra)}.wav")
        subprocess.run(["node", os.path.join(HERE, "render_strokes.js"), w, str(note)] + extra, check=True, env={**os.environ, "STROKES": "6"})
        rows = report(w)   # six strokes, averaged: single strokes vary as much as real ones do
        r = {k: sum(x.get(k, float("nan")) for x in rows) / len(rows) for k in rows[0]}
        for k, (lo, hi) in want.items():
            ok = lo <= r.get(k, float("nan")) <= hi
            fails += not ok
            print(("ok   " if ok else "FAIL ") + f"MIDI {note} {' '.join(extra) or 'defaults'}: {k} {r.get(k, float('nan')):.2f} (real {lo}..{hi})")
print(f"{fails} FAILED" if fails else "all passed")
sys.exit(1 if fails else 0)
