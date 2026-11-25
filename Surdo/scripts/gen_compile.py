#!/usr/bin/env python3
"""gen_compile.py [--cold] <code.genexpr | maxpat> — compile a gen~ codebox for real (inside a throwaway
.amxd loaded by the maxtest harness in standalone Max) and print the compiler's console output.
Exit 1 on errors. Debug aid: Max's C++ codegen rejects some code that the GenExpr grammar and
the Node shim accept. A unique History value defeats Max's compiled-code cache."""
import json
import os
import re
import subprocess
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "../../../MaxForLiveTools"))
from build_amxd import build_amxd  # noqa: E402



# --cold: restart Max first. Some code only fails on the first compile in a fresh Max (see the
# first-compile trap note in wt_engine.py), which is exactly what a user's first load hits.
cold = "--cold" in sys.argv
if cold:
    sys.argv.remove("--cold")
    subprocess.run([os.path.join(HERE, "max_restart.sh")], capture_output=True)
src = sys.argv[1]
if src.endswith(".maxpat"):
    doc = json.load(open(src))
    g = [b for b in doc["patcher"]["boxes"] if b["box"].get("text", "").startswith("gen~")][0]["box"]
    code = [b for b in g["patcher"]["boxes"] if b["box"]["maxclass"] == "codebox"][0]["box"]["code"]
else:
    code = open(src).read()
tag = f"gc{int(time.time() * 1000) % 10**8}"
m = re.search(r"^(Param|History|Data|Buffer|Delay) ", code, re.M)  # after any function definitions
at = m.start() if m else 0
code = code[:at] + f"History {tag}({int(tag[2:]) * 1e-12});\n" + code[at:] + f"\n{tag} = {tag} * 0.5;\nout1 = out1 + {tag};\n"
# reuse the real device (a hand-rolled minimal .amxd doesn't load in amxd~), swapping only the code
dev = json.load(open(src if src.endswith(".maxpat") else os.path.join(HERE, "../m4l/Surdo.maxpat")))   # the device being compiled supplies the controls
gb = [b for b in dev["patcher"]["boxes"] if b["box"].get("text", "").startswith("gen~")][0]["box"]
[b for b in gb["patcher"]["boxes"] if b["box"]["maxclass"] == "codebox"][0]["box"]["code"] = code
p = dev
tmp = os.path.join(HERE, "../m4l")  # js/wav dependencies are found next to the device
os.makedirs(tmp, exist_ok=True)
json.dump(p, open(f"{tmp}/_gc.maxpat", "w"))
build_amxd(f"{tmp}/_gc.maxpat", f"{tmp}/_gc.amxd", "iiii")
out = subprocess.run(["uv", "run", "--directory", os.environ["MAXTEST_DIR"], "python", "-c",
                      f"import server\nr = server.load_device('{tmp}/_gc.amxd')\nprint('\\n'.join(r['console']))"],
                     capture_output=True, text=True)
lines = [l for l in (out.stdout + out.stderr).splitlines() if "gen~" in l or "Error" in l or "error" in l]
print("\n".join(lines) or "compiled OK")
sys.exit(1 if any("[1]" in l or "Error" in l for l in lines) else 0)
