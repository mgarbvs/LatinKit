#!/usr/bin/env bash
# build.sh -- emit m4l/Surdo.maxpat (+ surdo_midi.js; surdo_view.js is hand-written), check + test it, assemble m4l/Surdo.amxd; then the same engine as
# m4l/SurdoMusical.amxd (build_voice.py --musical: the MIDI key sets the pitch; + surdo_musical_midi.js).
# Re-fit to the recordings first if the engine's modes changed:  FRESH=1 python3 tests/fit.py fit 24 && python3 tests/calibrate.py
# Real Max (standalone):  uv run --directory $MAXTEST_DIR python $PWD/tests/test_voice_max.py
set -euo pipefail
cd "$(dirname "$0")"
python3 scripts/build_voice.py m4l/Surdo.maxpat
node scripts/check_genexpr.js m4l/Surdo.maxpat
python3 scripts/validate_maxpat.py m4l/Surdo.maxpat
node tests/test_voice.js | grep -v "^ok"
node tests/test_push.js
python3 tests/test_strokes.py
python3 ../../MaxForLiveTools/build_amxd.py m4l/Surdo.maxpat m4l/Surdo.amxd --type iiii
python3 scripts/build_voice.py m4l/SurdoMusical.maxpat --musical
node scripts/check_genexpr.js m4l/SurdoMusical.maxpat
python3 scripts/validate_maxpat.py m4l/SurdoMusical.maxpat
node tests/test_musical.js | grep -v "^ok"
python3 ../../MaxForLiveTools/build_amxd.py m4l/SurdoMusical.maxpat m4l/SurdoMusical.amxd --type iiii
