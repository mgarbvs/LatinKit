#!/usr/bin/env bash
# build.sh -- emit m4l/Timbales.maxpat (+ timbales_midi.js; timbales_view.js is hand-written), check + test it, assemble m4l/Timbales.amxd.
# Re-fit to the recordings first if the engine's modes changed:  FRESH=1 python3 tests/fit.py fit 24 && python3 tests/calibrate.py
# Real Max (standalone):  uv run --directory $MAXTEST_DIR python $PWD/tests/test_voice_max.py
set -euo pipefail
cd "$(dirname "$0")"
python3 scripts/build_voice.py m4l/Timbales.maxpat
node scripts/check_genexpr.js m4l/Timbales.maxpat
python3 scripts/validate_maxpat.py m4l/Timbales.maxpat
node tests/test_voice.js | grep -v "^ok"
python3 tests/test_strokes.py
node tests/test_push.js
python3 ../../MaxForLiveTools/build_amxd.py m4l/Timbales.maxpat m4l/Timbales.amxd --type iiii
