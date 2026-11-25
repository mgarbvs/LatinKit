"""calibrate.py -- set each row's amplitude A (and its jingle coupling jg, so the head / jingle balance stays) in scripts/pandeiro_tables.json so its peak at velocity 1,
Volume 0 dB (before the limiter) is E.PEAK_DB. Run after tests/fit.py fit; prints the peaks before and after."""
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import measure as M  # noqa: E402

E = M.E
tabs = E.load_tables()
for it in range(2):
    code = os.path.join(HERE, "_t.cal.genexpr")
    open(code, "w").write(E.code(tabs, jitter=0))
    for r, k in enumerate(E.KEYS):
        i, m = E.ROW_MENU[r]
        # the noise makes the peak vary hit to hit: the median of 9 hits, 1.2 s apart; 24 dB down keeps the soft limiter out of it
        sr, x = M.render([(i, m, 1.0, 0.02 + 1.2 * n) for n in range(9)], 11.0, ["volume=-24"], code=code)
        pk = float(np.median([20 * np.log10(np.abs(x[int(1.2 * n * sr):int(1.2 * (n + 1) * sr)]).max()) for n in range(9)])) + 24
        if it == 1:
            print(f"{k:10s} peak (want {E.PEAK_DB[k]}): {pk:.1f}")
        f = 10 ** ((E.PEAK_DB[k] - pk) / 20)
        tabs[k]["A"] = round(tabs[k]["A"] * f, 4)
        tabs[k]["jg"] = round(tabs[k]["jg"] * f, 4)
json.dump(tabs, open(E.TABLES_PATH, "w"), indent=1)
