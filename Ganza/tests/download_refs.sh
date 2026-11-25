#!/usr/bin/env bash
# download_refs.sh — fetch the CC recordings (docs/RESEARCH.md) into a fresh scratch dir, convert to mono 48 kHz 16-bit in Ganza/ref_wav (gitignored),
# then cut the ganzá loop into strokes. Downloads are untrusted data: they are only read by ffmpeg and numpy/node (python -I where possible).
set -euo pipefail
cd "$(dirname "$0")/.."
T=$(mktemp -d); mkdir -p ref_wav
get() { curl -s -A "Mozilla/5.0" -o "$T/$2" "$1"; ffmpeg -loglevel error -y -i "$T/$2" -ac 1 -ar 48000 -c:a pcm_s16le "ref_wav/${2%.*}.wav"; }
P=https://cdn.freesound.org/previews
get $P/609/609774_7096110-hq.mp3 ganza_arroz.mp3            # Ilson_Junior, CC0
get $P/444/444344_897016-hq.mp3 ganza_mattyharm.mp3         # mattyharm, CC0
get $P/863/863230_262-hq.mp3 metal_alexarje.mp3             # alexarje, CC BY 4.0 (analysis only)
get https://upload.wikimedia.org/wikipedia/commons/8/8f/Chocalho_Sound.ogg choc_commons.ogg   # Samba-x, CC BY-SA 3.0 (looked at only)
# CamTarn, CC0: sound id -> name
for m in 556070:choc_fwd1 556075:choc_fwd2 556074:choc_fwd3 556077:choc_fwd4 556076:choc_fwd5 556078:choc_fwd6 556081:choc_fwd7 \
         556069:choc_back1 556068:choc_back2 556067:choc_back3 556066:choc_back4 556073:choc_back5 556072:choc_back6 556071:choc_back7 \
         556079:choc_rhythm1 556080:choc_rhythm2; do
    get $P/556/${m%%:*}_77117-hq.mp3 ${m##*:}.mp3
done
python3 tests/segment_refs.py
