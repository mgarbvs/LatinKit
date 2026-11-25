#!/usr/bin/env bash
# build.sh — emit m4l/CR78.maxpat (+ cr_midi.js, cr_view.js) and the 13 single-voice m4l/CR78 <Name>.maxpat, check + test them, assemble the .amxd files.
# Real-Max check (needs standalone Max): uv run --directory $MAXTEST_DIR python "$PWD/tests/test_max_render.py"
set -euo pipefail
cd "$(dirname "$0")"
python3 scripts/build_maxpat.py m4l/CR78.maxpat
node scripts/check_genexpr.js m4l/CR78.maxpat
python3 scripts/validate_maxpat.py m4l/CR78.maxpat
node tests/test_engine.js
python3 ../../MaxForLiveTools/build_amxd.py m4l/CR78.maxpat m4l/CR78.amxd --type iiii
python3 scripts/build_voices.py m4l
for f in m4l/CR78\ *.maxpat; do
    node scripts/check_genexpr.js "$f"
    python3 scripts/validate_maxpat.py "$f"
done
node tests/test_voices.js
node tests/test_push.js
for f in m4l/CR78\ *.maxpat; do python3 ../../MaxForLiveTools/build_amxd.py "$f" "${f%.maxpat}.amxd" --type iiii; done
