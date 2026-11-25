#!/usr/bin/env bash
# reco_refs.sh — fetches the one reco-reco reference (Freesound 219634 "recoreco-texture.wav" by andrescompovigo, CC0; the site's 192 kbps preview mp3)
# into ref_wav/ (gitignored), decodes it to 48 kHz mono 16-bit and cuts it into clips RR_<n>.wav (see tests/reco_refs.py). Downloads are untrusted data: own dir, python -I.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p ref_wav/reco_dl
curl -sf -m 60 -o ref_wav/reco_dl/fs219634.mp3 https://cdn.freesound.org/previews/219/219634_2235140-hq.mp3
ffmpeg -loglevel error -y -i ref_wav/reco_dl/fs219634.mp3 -af "pan=mono|c0=c0" -ar 48000 -c:a pcm_s16le ref_wav/reco_texture.wav
python3 tests/reco_refs.py ref_wav/reco_texture.wav ref_wav
