#!/usr/bin/env bash
# build.sh — emit m4l/Shaker.maxpat, check + test it, assemble the .amxd instrument.
# Real Max (standalone):  uv run --directory $MAXTEST_DIR python $PWD/tests/test_max_render.py
# Live:                   uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check.py $PWD/m4l/Shaker.amxd
set -euo pipefail
cd "$(dirname "$0")"
python3 scripts/build_maxpat.py m4l/Shaker.maxpat
node scripts/check_genexpr.js m4l/Shaker.maxpat
python3 scripts/validate_maxpat.py m4l/Shaker.maxpat
node tests/test_engine.js
node tests/test_push.js
python3 ../../MaxForLiveTools/build_amxd.py m4l/Shaker.maxpat m4l/Shaker.amxd --type iiii
