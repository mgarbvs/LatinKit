"""refs.py -- the repinique reference strokes: four BeppeB Freesound recordings (CC0), each a string of single hits (docs/RESEARCH.md). Converted once to
ref_wav/ (float32 mono 44.1 kHz; gitignored) and cut into takes: ref_wav/rp_<stroke>_<k>.wav, each from 30 ms before an onset to just before the next one.
  repinique-head = stick on the head (Open), repinique-rimshot = stick on head and rim (Rimshot), repinique-rod = stick on the tension rod / rim (Rim), repinique-hand = open hand.
    python3 tests/refs.py     # (re)cut and list
    from refs import REFS, load, ref_names   # REFS[name] = stroke; load(name) -> (sr, x) peak-normalised mono
"""
import glob
import os
import subprocess

import numpy as np
from scipy.io import wavfile

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "../ref_wav")
SRC = {"open": ("head", 329750), "rimshot": ("rimshot", 329749), "rim": ("rod", 329748), "hand": ("hand", 329751)}
URL = "https://cdn.freesound.org/previews/329/{id}_3097509-hq.mp3"
NTAKE = 8          # takes used per stroke (the first NTAKE whose onset is clean)
REFS = {}


def _whole(f):
    p = os.path.join(OUT, f"bs_{f}.wav")
    if not os.path.exists(p):
        os.makedirs(OUT, exist_ok=True)
        mp3 = os.path.join(OUT, f"bs_{f}.mp3")
        if not os.path.exists(mp3):
            subprocess.run(["curl", "-sL", "-A", "Mozilla/5.0", URL.format(id=[i for n, i in SRC.values() if n == f][0]), "-o", mp3], check=True)
        subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-i", mp3, "-ac", "1", "-c:a", "pcm_f32le", p], check=True)
    sr, x = wavfile.read(p)
    return sr, x.astype(float)


def onsets(x, sr, thr=0.05, gap=0.4):
    h = int(sr * 0.005)
    e = np.sqrt(np.convolve(x ** 2, np.ones(h) / h, "same"))
    e /= e.max()
    on, i = [], 0
    while i < len(e):
        if e[i] > thr:
            on.append(i)
            i += int(sr * gap)
        else:
            i += 1
    return on


def convert():
    for s, (f, _) in SRC.items():
        sr, x = _whole(f)
        on = onsets(x, sr)
        for k, o in enumerate(on[:NTAKE]):
            end = on[k + 1] - int(0.02 * sr) if k + 1 < len(on) else len(x)
            seg = x[max(0, o - int(0.03 * sr)):end]
            wavfile.write(os.path.join(OUT, f"rp_{s}_{k}.wav"), sr, (seg / np.abs(seg).max()).astype(np.float32))


def _scan():
    if not glob.glob(os.path.join(OUT, "rp_*_0.wav")):
        convert()
    for p in sorted(glob.glob(os.path.join(OUT, "rp_*.wav"))):
        n = os.path.basename(p)[:-4]
        REFS[n] = n.split("_")[1]


_scan()


def load(n):
    sr, x = wavfile.read(os.path.join(OUT, n + ".wav"))
    x = x.astype(float)
    return sr, x / (np.abs(x).max() + 1e-12)


def ref_names(stroke):
    return [n for n, s in REFS.items() if s == stroke]


if __name__ == "__main__":
    convert()
    _scan()
    for n in REFS:
        sr, x = load(n)
        print(n, REFS[n], sr, round(len(x) / sr, 2))
