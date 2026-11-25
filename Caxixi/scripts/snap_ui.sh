#!/usr/bin/env bash
# snap_ui.sh <file.maxpat> <out.png> [varname=value ...] — open a patch in standalone Max
# (presentation view), screenshot its window, close it. varname=value pairs start those
# controls/tabs at that value (a temp _view copy next to the patch). Design aid; not in the build.
set -euo pipefail
f="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
case "$2" in /*) out="$2" ;; *) out="$PWD/$2" ;; esac
shift 2
if [ $# -gt 0 ]; then
    v="$(dirname "$f")/_view.maxpat"
    python3 - "$f" "$v" "$@" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
sets = dict(a.split("=") for a in sys.argv[3:])
flash = sets.pop("flash", None)   # flash=0.2: hold the display's note-on flash at that alpha
for b in d["patcher"]["boxes"]:
    if flash and b["box"].get("varname") == "view":
        b["box"]["jsarguments"] = [flash]
    vo = b["box"].get("saved_attribute_attributes", {}).get("valueof")
    if b["box"].get("varname") in sets and vo:
        vo["parameter_initial"] = [float(sets[b["box"]["varname"]])]
json.dump(d, open(sys.argv[2], "w"))
PY
    f="$v"
fi
name="$(basename "$f" .maxpat)"
cd "$(dirname "$0")"
BIN=.winid
[ -x "$BIN" ] && [ "$BIN" -nt winid.swift ] || swiftc -O winid.swift -o "$BIN"
# Max has no AppleScript window close; a stale open window would just be refocused, so restart
./max_restart.sh >/dev/null
open -g -a /Applications/Max.app "$f"
id=""
for _ in $(seq 1 90); do id=$(./"$BIN" Max "$name (") && [ -n "$id" ] && break; sleep 0.5; done
[ -n "$id" ] || { echo "window for $name not found"; exit 1; }
sleep 2.5
screencapture -x -o -l "$id" "$out"
[ "$name" = "_view" ] && rm -f "$f"
./max_restart.sh >/dev/null   # don't leave this Max for the maxtest harness to attach to
echo "$out"
