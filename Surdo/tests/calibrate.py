"""calibrate.py -- set each stroke's amplitude A in scripts/surdo_tables.json so its peak at velocity 1, Volume 0 dB (before the limiter)
is E.PEAK_DB. Run after tests/fit.py fit; prints the peaks before and after."""
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import measure as M  # noqa: E402

E = M.E
tabs = E.load_tables()
sp = M.SPACE
for it in range(2):
    code = os.path.join(HERE, "_t.cal.genexpr")
    open(code, "w").write(E.code(tabs, jitter=0))
    for si, s in enumerate(E.STROKES):
        # the noise burst makes the peak vary hit to hit: the median of 7 hits; 24 dB down keeps the soft limiter out of it
        sr, x = M.render([(si, 1.0, 0.02 + sp * k) for k in range(7)], sp * 7 + 0.1, ["volume=-24"], code=code)
        pk = float(np.median([20 * np.log10(np.abs(x[int(sp * k * sr):int(sp * (k + 1) * sr)]).max()) for k in range(7)])) + 24
        if it == 1:
            print(f"{s:7s} peak {pk:.1f} dBFS (want {E.PEAK_DB[s]})")
        tabs[s]["A"] = round(tabs[s]["A"] * 10 ** ((E.PEAK_DB[s] - pk) / 20), 4)
json.dump(tabs, open(E.TABLES_PATH, "w"), indent=1)
