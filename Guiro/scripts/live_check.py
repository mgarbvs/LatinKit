"""live_check.py <Guiro.amxd> — load the instrument into the running Live (LiveTestMCP harness: adds/replaces an "LT DUT" track; never touches other
tracks), then check inside Live: clean Max console, all 10 parameters present with their defaults, every stroke and both Types sound through Live's
MIDI (the Key note map: C3 Up, C#3 Down, D3 Long, D#3 Top), Long is longer than Up, Roll keeps a held note going. Exit 1 on any failure.

    uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check.py $PWD/m4l/Guiro.amxd
"""
import os
import sys

import numpy as np

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../../LiveTestMCP"))
import server  # noqa: E402
from analyze import read_wav  # noqa: E402

FAILS = []
DEFAULTS = {"Type": 0, "Length": 450, "Roll": 0, "Stroke": 0, "Pan": 0, "Level": -6, "Speed": 100, "Ridge": 100, "Tone": 0, "Vary": 50}
# Speed / Ridge are exponent dials (stored linear in travel in the LOM: lo + (hi - lo) * frac ** (1 / exponent))
EXPO = {"Speed": (25, 400, 2.32), "Ridge": (25, 400, 2.32)}


def check(ok, what):
    print(("ok   " if ok else "FAIL ") + what)
    if not ok:
        FAILS.append(what)


def run(events, ms, **kw):
    rr = server.render(events, ms, params={**base, **kw}, name=f"gui{os.getpid()}_{len(events)}_{ms}")
    x, sr = read_wav(rr["wav"])
    return rr, x, sr


def length(x, sr):   # ms from the first sound to the last within 20 dB of the peak (5 ms envelope)
    m = np.abs(x).max(axis=1) if x.ndim > 1 else np.abs(x)
    e = np.sqrt(np.convolve(m ** 2, np.ones(int(0.005 * sr)) / int(0.005 * sr), "same"))
    idx = np.where(e > e.max() * 0.1)[0]
    return (idx[-1] - idx[0]) / sr * 1000


r = server.setup(os.path.abspath(sys.argv[1]), "instrument")
console = list(r["console"])
params = {p["name"]: p for p in r["params"]}
print({n: p.get("value") for n, p in params.items()})
check(set(DEFAULTS) <= set(params), f"Live sees all {len(DEFAULTS)} parameters (missing: {set(DEFAULTS) - set(params) or 'none'})")
want = {n: (EXPO[n][0] + (EXPO[n][1] - EXPO[n][0]) * ((d - EXPO[n][0]) / (EXPO[n][1] - EXPO[n][0])) ** (1 / EXPO[n][2]) if n in EXPO else d)
        for n, d in DEFAULTS.items() if n not in ("Type", "Stroke")}
bad = {n: params[n].get("value") for n, d in want.items() if n in params and abs(float(params[n].get("value", 1e9)) - d) > 0.51}
check(not bad, f"defaults as designed (off: {bad or 'none'})")
base = {n: d for n, d in DEFAULTS.items() if n not in EXPO}
lens = {}
for ti, tname in enumerate(["Güiro", "Reco-reco"]):
    for note, kname in ((60, "Up (C3)"), (61, "Down (C#3)"), (62, "Long (D3)"), (63, "Top (D#3)")):
        rr, x, sr = run([{"t": 100, "note": note, "vel": 100, "dur": 50}], 1100, Type=ti)
        console += rr["console"]
        pk = float(np.abs(x).max())
        check(rr["nan_count"] == 0 and pk > 0.02, f"{tname} {kname} through Live: peak {rr['peak_dbfs']} dBFS")
        if ti == 0:
            lens[note] = length(x, sr)
check(lens[62] > 2 * lens[61] and lens[63] < lens[60], f"Key note map: lengths Up {lens[60]:.0f}, Down {lens[61]:.0f}, Long {lens[62]:.0f}, Top {lens[63]:.0f} ms")
rr, x, sr = run([{"t": 100, "note": 60, "vel": 100, "dur": 50}], 1100, Stroke=3)
check(300 < length(x, sr) < 650, f"Stroke = Long on C3 gives the long scrape: {length(x, sr):.0f} ms")
rl = server.render([{"t": 100, "note": 60, "vel": 100, "dur": 800}], 1200, params={**base, "Roll": 8}, name=f"gui{os.getpid()}_r")
x, sr = read_wav(rl["wav"])
m = np.abs(x).max(axis=1)
late = float(m[int(0.6 * sr):int(0.9 * sr)].max())
check(late > 0.4 * float(m.max()), f"Roll 8 Hz keeps a held note scraping: late peak {late:.3f} vs {float(m.max()):.3f}")
check(float(m[int(1.05 * sr):].max()) < 0.05 * float(m.max()), "Roll stops at note-off")
errs = [l for l in console if "error" in l.lower() or "[1]" in l]
check(not errs, "Max console clean" + ("" if not errs else ": " + " | ".join(errs[:5])))
sys.exit(1 if FAILS else 0)
