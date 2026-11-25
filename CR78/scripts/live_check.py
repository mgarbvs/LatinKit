"""live_check.py <device.amxd> [notes...] — load an instrument into the running Live (LiveTestMCP harness, adds/replaces an "LT DUT" track),
play the notes (default: the CR78 note map) and print the peak level per note and any new Max console errors. Exit 1 if a note is silent or the
console shows errors. Live bundles a newer Max than standalone, and its gen~ compiler has rejected code standalone Max accepts.

    uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check.py $PWD/m4l/CR78.amxd
"""
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "../../../LiveTestMCP"))
import server  # noqa: E402

r = server.setup(os.path.abspath(sys.argv[1]), "instrument")
notes = [int(n) for n in sys.argv[2:]] or [36, 37, 38, 42, 44, 49, 54, 56, 60, 61, 64, 70, 73, 74, 75]
ev = [{"t": 400 * i, "note": n, "vel": 100, "dur": 60} for i, n in enumerate(notes)]
out = server.render(ev, 400 * len(notes) + 800)
errs = [l for l in r["console"] + out.get("console", []) if "error" in l.lower() or "[1]" in l]
silent = []
for n, w in zip(notes, out["windows"]):
    print(n, w.get("start_ms"), w.get("peak_dbfs"))
    if w.get("peak_dbfs") is None or w.get("peak_dbfs") < -40:
        silent.append(n)
print("\n".join(errs) or "console clean")
print("SILENT: " + str(silent) if silent else "all notes sound")
sys.exit(1 if silent or errs else 0)
