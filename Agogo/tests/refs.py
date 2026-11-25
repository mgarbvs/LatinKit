"""refs.py -- the agogo reference strokes. Sources, converted once to ref_wav/*.wav (float32 mono, native rate; gitignored; never commit Ableton audio):
  * Latin Percussion pack, Drum Hits previews (plain ogg, ffmpeg): "Agogo {A High, A Low, B High, B Mid, B Low, E High, E Low}": one open stick hit each, peak-normalised.
    A, B and E are three different instruments (different bells, not takes of one): the model is fitted to A, B and E are only measured (fit.py report).
  * Live 12 Core Library "Bells Agogo Hi.aif" is the same bell as LP A High (identical peaks): a duplicate, not a 4th take.
  * (The LP in-context clips and two Core Library loops were looked at for muted / clack strokes: docs/SPEC.md; none found; not converted here.)
    python3 tests/refs.py     # (re)convert and list
    from refs import REFS, load      # REFS[name] = (bell, kit); load(name) -> (sr, x) peak-normalised mono
"""
import os
import subprocess

import numpy as np
from scipy.io import wavfile

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "../ref_wav")
LP = os.environ["LP_PACK"] + "/Ableton Folder Info/Previews"
BELL = {"High": 0, "Low": 1}
# name -> (bell 0 High / 1 Low (Mid counts as a third, reported only), kit)
REFS = {f"lp_Agogo_{k}_{b}": (BELL.get(b, 2), k) for k in "ABE" for b in ("High", "Mid", "Low") if not (b == "Mid" and k != "B") and not (k == "E" and b == "Mid")}
FIT = {0: "lp_Agogo_A_High", 1: "lp_Agogo_A_Low"}       # the recordings the table is fitted to


def src_of(name):
    return os.path.join(LP, "Drums/Drum Hits/Bell", name[3:].replace("_", " ") + ".adg.ogg")


def convert():
    os.makedirs(OUT, exist_ok=True)
    for n in REFS:
        subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-i", src_of(n), "-ac", "1", "-c:a", "pcm_f32le", os.path.join(OUT, n + ".wav")], check=True)


def load(n):
    p = os.path.join(OUT, n + ".wav")
    if not os.path.exists(p):
        convert()
    sr, x = wavfile.read(p)
    x = x.astype(float)
    return sr, x / (np.abs(x).max() + 1e-12)


if __name__ == "__main__":
    convert()
    for n in REFS:
        sr, x = load(n)
        print(n, REFS[n], sr, round(len(x) / sr, 2))
