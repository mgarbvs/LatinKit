#!/usr/bin/env bash
# build.sh — emit m4l/Guiro.maxpat, check + test it, assemble the .amxd instrument.
# Real Max (standalone):  uv run --directory $MAXTEST_DIR python $PWD/tests/test_max_render.py
# Live:                   uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check.py $PWD/m4l/Guiro.amxd
set -euo pipefail
cd "$(dirname "$0")"
python3 scripts/build_maxpat.py m4l/Guiro.maxpat
node scripts/check_genexpr.js m4l/Guiro.maxpat
python3 scripts/validate_maxpat.py m4l/Guiro.maxpat
node tests/test_engine.js
node tests/test_push.js
python3 ../../MaxForLiveTools/build_amxd.py m4l/Guiro.maxpat m4l/Guiro.amxd --type iiii
