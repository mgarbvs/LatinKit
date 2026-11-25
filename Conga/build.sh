#!/usr/bin/env bash
# build.sh -- emit m4l/Conga.maxpat (+ conga_midi.js), check + test it, assemble m4l/Conga.amxd.
# Also builds Conga Voice (one drum, Drum + Stroke menus): scripts/build_voice.py -> m4l/"Conga Voice.maxpat" + conga_voice_midi.js (conga_voice_view.js is hand-written).
# Re-fit to the recordings first if the engine's modes changed:  python3 tests/fit.py fit 10 && python3 tests/calibrate.py
# Real Max (standalone):  uv run --directory $MAXTEST_DIR python $PWD/tests/test_max_render.py
set -euo pipefail
cd "$(dirname "$0")"
python3 scripts/build_maxpat.py m4l/Conga.maxpat
node scripts/check_genexpr.js m4l/Conga.maxpat
python3 scripts/validate_maxpat.py m4l/Conga.maxpat
node tests/test_engine.js | grep -v "^ok"
python3 tests/test_strokes.py
python3 ../../MaxForLiveTools/build_amxd.py m4l/Conga.maxpat m4l/Conga.amxd --type iiii
python3 scripts/build_voice.py "m4l/Conga Voice.maxpat"
node scripts/check_genexpr.js "m4l/Conga Voice.maxpat"
python3 scripts/validate_maxpat.py "m4l/Conga Voice.maxpat"
node tests/test_voice.js | grep -v "^ok"
node tests/test_push.js
python3 ../../MaxForLiveTools/build_amxd.py "m4l/Conga Voice.maxpat" "m4l/Conga Voice.amxd" --type iiii
