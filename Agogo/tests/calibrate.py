"""calibrate.py -- set each stroke's amplitude A (per bell) in scripts/agogo_tables.json so its peak at velocity 1, Volume 0 dB (before the limiter)
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
            # the tick's noise makes the peak vary hit to hit: the median of 3 hits, 3 s apart (a High ring is 1.3 s T60: no leak into the next); 24 dB down keeps the soft limiter out of it
            sr, x = M.render([(d, si, 1.0, 0.02 + 3.0 * k) for k in range(3)], 9.2, ["volume=-24"], code=code)
            pk.append(float(np.median([20 * np.log10(np.abs(x[int(3.0 * k * sr):int(3.0 * (k + 1) * sr)]).max()) for k in range(3)])) + 24)
        if it == 1:
            print(f"{s:6s} peaks (want {E.PEAK_DB[s]}): high {pk[0]:.1f} low {pk[1]:.1f}")
        tabs[s]["A"] = [round(a * 10 ** ((E.PEAK_DB[s] - p) / 20), 4) for a, p in zip(tabs[s]["A"], pk)]
json.dump(tabs, open(E.TABLES_PATH, "w"), indent=1)
