#!/usr/bin/env bash
# decode_refs.sh — the Latin Percussion güiro previews (plain ogg) and Live's Core Library güiro samples -> mono 48 kHz 16-bit wavs in Guiro/ref_wav
# (Ableton's audio: gitignored, never committed). Needs ffmpeg, afconvert and the Sandisk pack volume.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p ref_wav
P="$LP_PACK/Ableton Folder Info/Previews"
for f in "$P"/Drums/Drum\ Hits/Wood/Guiro*.ogg; do
    b=$(basename "$f" .adg.ogg | tr ' ' '_'); ffmpeg -loglevel error -y -i "$f" -ac 1 -ar 48000 -c:a pcm_s16le ref_wav/$b.wav
done
for f in "$P"/Clips/*Guiro*.alc.ogg; do
    b=$(basename "$f" .alc.ogg | tr ' &' '__'); ffmpeg -loglevel error -y -i "$f" -ac 1 -ar 48000 -c:a pcm_s16le ref_wav/clip_$b.wav
done
C="/Applications/Ableton Live 12 Suite.app/Contents/App-Resources/Core Library/Samples"
afconvert -f WAVE -d LEI16@48000 -c 1 "$C/One Shots/Drums/Misc Percussion/Guiro Vintage Cut.aif" ref_wav/core_vintage_cut.wav
afconvert -f WAVE -d LEI16@48000 -c 1 "$C/Loops/Drums/Percussion/Guiro 110 bpm.aif" ref_wav/core_loop110.wav
ls ref_wav | wc -l
