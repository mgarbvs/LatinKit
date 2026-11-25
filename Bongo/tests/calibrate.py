"""calibrate.py -- set each stroke's amplitude A (per drum) in scripts/bongo_tables.json so its peak at velocity 1, Volume 0 dB (before the limiter)
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
for it in range(2):
    code = os.path.join(HERE, "_t.cal.genexpr")
    open(code, "w").write(E.code(tabs, jitter=0))
    for si, s in enumerate(E.STROKES):
        pk = []
        for d in range(2):
            # the noise burst makes the peak vary hit to hit: the median of 9 hits, 1.2 s apart; 24 dB down keeps the soft limiter out of it
            sr, x = M.render([(d, si, 1.0, 0.02 + 1.2 * k) for k in range(9)], 11.0, ["volume=-24"], code=code)
            pk.append(float(np.median([20 * np.log10(np.abs(x[int(1.2 * k * sr):int(1.2 * (k + 1) * sr)]).max()) for k in range(9)])) + 24)
        if it == 1:
            print(f"{s:9s} peaks (want {E.PEAK_DB[s]}): high {pk[0]:.1f} low {pk[1]:.1f}")
        tabs[s]["A"] = [round(a * 10 ** ((E.PEAK_DB[s] - p) / 20), 4) for a, p in zip(tabs[s]["A"], pk)]
json.dump(tabs, open(E.TABLES_PATH, "w"), indent=1)
