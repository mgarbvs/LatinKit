#!/usr/bin/env bash
# build.sh — emit m4l/Cuica.maxpat, check + test it, assemble the .amxd instrument.
# Real Max (standalone):  uv run --directory $MAXTEST_DIR python $PWD/tests/test_max_render.py
set -euo pipefail
cd "$(dirname "$0")"
python3 scripts/build_maxpat.py m4l/Cuica.maxpat
node scripts/check_genexpr.js m4l/Cuica.maxpat
python3 scripts/validate_maxpat.py m4l/Cuica.maxpat
node tests/test_engine.js
node tests/test_push.js
python3 tests/test_strokes.py | grep -v "^  stroke\|^=="
python3 ../../MaxForLiveTools/build_amxd.py m4l/Cuica.maxpat m4l/Cuica.amxd --type iiii
