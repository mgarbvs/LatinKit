"""node_stats.py -- JSON {"b,s": [peak dBFS, 1.0 s energy dB]} of the Node shim per bell x stroke at velocity 1 (what test_voice_max.py holds Max to)."""
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import fit  # noqa: E402
import measure as M  # noqa: E402

E = M.E
code = fit.write_code(E.load_tables())
out = {}
for d in range(2):
    for s in range(2):
        sr, x = M.render([(d, s, 1.0, 0.1)], 1.6, [], code=code)
        o = int(np.argmax(np.abs(x) > 1e-3))
        out[f"{d},{s}"] = [float(20 * np.log10(np.abs(x).max())), float(10 * np.log10(np.mean(x[o:o + int(1.0 * sr)] ** 2)))]
print(json.dumps(out))
