#!/usr/bin/env bash
# decode_refs.sh — the Latin Percussion caxixi previews (plain ogg) -> mono 48 kHz 16-bit wavs in Caxixi/ref_wav (Ableton's audio: gitignored,
# never committed). Needs ffmpeg and the Sandisk pack volume.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p ref_wav
P="$LP_PACK/Ableton Folder Info/Previews"
for f in "$P"/Drums/Drum\ Hits/Shaker/Caxixi*.ogg; do
    b=$(basename "$f" .adg.ogg | tr ' ' '_'); ffmpeg -loglevel error -y -i "$f" -ac 1 -ar 48000 -c:a pcm_s16le ref_wav/$b.wav
done
for f in "$P"/Clips/*Caxixi*.alc.ogg; do
    b=$(basename "$f" .alc.ogg | tr ' &' '__'); ffmpeg -loglevel error -y -i "$f" -ac 1 -ar 48000 -c:a pcm_s16le ref_wav/clip_$b.wav
done
ls ref_wav | wc -l
