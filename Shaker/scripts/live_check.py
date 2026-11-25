"""live_check.py <Shaker.amxd> — load the instrument into the running Live (LiveTestMCP harness: adds/replaces an "LT DUT" track; never
touches other tracks), then check inside Live: clean Max console, all 10 parameters present with their defaults, every Type sounds through
Live's MIDI (forward and back notes), a back stroke quieter than a forward one, Roll keeps a held note going. Exit 1 on any failure.
(Not run while another agent owned Live: the parent session runs it.)

    uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check.py $PWD/m4l/Shaker.amxd
"""
import os
import sys

import numpy as np

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../../LiveTestMCP"))
import server  # noqa: E402
from analyze import read_wav  # noqa: E402

FAILS = []
DEFAULTS = {"Type": 0, "Beads": 100, "Damping": 100, "Shake": 100, "Rattle": 50, "Tone": 0, "Back": 70, "Roll": 0, "Direction": 0, "Pan": 0, "Level": -6}
TYPES = ["Maraca", "Cabasa", "Shekere", "Ganzá", "Egg"]
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
        for n, d in DEFAULTS.items() if n != "Type"}
bad = {n: params[n].get("value") for n, d in want.items() if n in params and abs(float(params[n].get("value", 1e9)) - d) > 0.51}
check(not bad, f"defaults as designed (off: {bad or 'none'})")
base = {n: d for n, d in DEFAULTS.items() if n not in EXPO}
for ti, tname in enumerate(TYPES):
    rr = server.render([{"t": 100, "note": 60, "vel": 100, "dur": 50}], 900, params={**base, "Type": ti}, name=f"shk{os.getpid()}_{ti}")
    console += rr["console"]
    pk, x, sr = peak_of(rr)
    check(rr["nan_count"] == 0 and pk > 0.02, f"{tname} through Live (C3, forward): peak {rr['peak_dbfs']} dBFS")
def mean_peak(note, **kw):   # one stroke's peak is as random as the noise: the mean of 8 strokes, 1 s apart
    rr = server.render([{"t": 100 + 1000 * k, "note": note, "vel": 100, "dur": 50} for k in range(8)], 8300, params={**base, "Type": 0, **kw}, name=f"shk{os.getpid()}_{note}{kw.get('Direction', '')}")
    x, sr = read_wav(rr["wav"])
    return float(np.mean([np.abs(x[int((0.08 + k) * sr):int((0.9 + k) * sr)]).max() for k in range(8)]))


pf, pb = mean_peak(60), mean_peak(61)
check(0.4 < pb / pf < 0.95, f"back stroke (C#3) is quieter than forward (C3): {pb / pf:.2f} of it (Back 70 %)")
pdb, pdf = mean_peak(60, Direction=3), mean_peak(61, Direction=2)
check(0.4 < pdb / pf < 0.95 and pdf > pb * 1.1, f"Direction Back makes C3 quieter ({pdb / pf:.2f}), Forward makes C#3 louder ({pdf / pf:.2f})")
rl = server.render([{"t": 100, "note": 60, "vel": 100, "dur": 800}], 1200, params={**base, "Type": 0, "Roll": 8}, name=f"shk{os.getpid()}_r")
x, sr = read_wav(rl["wav"])
m = np.abs(x).max(axis=1)
late = float(m[int(0.6 * sr):int(0.9 * sr)].max())
check(late > 0.4 * float(m.max()), f"Roll 8 Hz keeps a held note shaking: late peak {late:.3f} vs {float(m.max()):.3f}")
check(float(m[int(1.05 * sr):].max()) < 0.05 * float(m.max()), "Roll stops at note-off")
errs = [l for l in console if "error" in l.lower() or "[1]" in l]
check(not errs, "Max console clean" + ("" if not errs else ": " + " | ".join(errs[:5])))
sys.exit(1 if FAILS else 0)
