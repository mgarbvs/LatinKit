"""node_stats.py -- JSON {"i,m": [peak dBFS, 0.8 s energy dB]} of the Node shim per instrument x menu stroke at velocity 1 (what test_voice_max.py holds Max to).
Jingle-bearing strokes are noise: the median of 9 hits (1.5 s apart)."""
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import fit  # noqa: E402
import measure as M  # noqa: E402

E = M.E
MUSICAL = "Musical" in os.environ.get("PANDEIRO_DEV", "")       # the Musical device: each instrument at the key E.NOTES[d] (tests/test_voice_max.py plays those)
code = fit.write_code(E.load_tables(MUSICAL)) if not MUSICAL else os.path.join(HERE, "_t.mus.genexpr")
if MUSICAL:
    open(code, "w").write(E.code(musical=True, jitter=0))
out = {}
for d in range(2):
    for s in range(len(E.MENU)):
        sr, x = M.render([(d, s, 1.0, 0.1 + 2.0 * k) for k in range(9)], 18.5, [f"note={E.NOTES[d]}"] if MUSICAL else [], code=code)
        pk, en = [], []
        for k in range(9):
            y = x[int(2.0 * k * sr):int(2.0 * (k + 1) * sr)]
            o = int(np.argmax(np.abs(y) > 1e-3))
            pk.append(20 * np.log10(np.abs(y).max()))
            en.append(10 * np.log10(np.mean(y[o:o + int(0.8 * sr)] ** 2)))
        out[f"{d},{s}"] = [float(np.median(pk)), float(np.median(en))]
print(json.dumps(out))
