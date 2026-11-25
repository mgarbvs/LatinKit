#!/usr/bin/env bash
# build.sh -- emit m4l/Pandeiro.maxpat (+ pandeiro_midi.js) and m4l/PandeiroMusical.maxpat (+ pandeiro_midi_musical.js; pandeiro_view.js is hand-written), check + test them, assemble both .amxd.
# Re-fit to the recordings first if the engine's modes changed:  FRESH=1 python3 tests/fit.py fit 16 && python3 tests/calibrate.py && python3 tests/fit.py roll --write && python3 tests/fit.py jg
# Real Max (standalone):  uv run --directory $MAXTEST_DIR python $PWD/tests/test_voice_max.py
set -euo pipefail
cd "$(dirname "$0")"
python3 scripts/build_voice.py m4l/Pandeiro.maxpat
node scripts/check_genexpr.js m4l/Pandeiro.maxpat
python3 scripts/validate_maxpat.py m4l/Pandeiro.maxpat
python3 scripts/build_voice.py --musical m4l/PandeiroMusical.maxpat
node scripts/check_genexpr.js m4l/PandeiroMusical.maxpat
python3 scripts/validate_maxpat.py m4l/PandeiroMusical.maxpat
node tests/test_voice.js | grep -v "^ok"
node tests/test_musical.js | grep -v "^ok"
node tests/test_push.js
python3 tests/test_strokes.py
python3 ../../MaxForLiveTools/build_amxd.py m4l/Pandeiro.maxpat m4l/Pandeiro.amxd --type iiii
python3 ../../MaxForLiveTools/build_amxd.py m4l/PandeiroMusical.maxpat m4l/PandeiroMusical.amxd --type iiii
