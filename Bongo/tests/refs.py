"""refs.py -- the bongo reference strokes. Sources, converted once to ref_wav/*.wav (float32 mono, native rate; gitignored; never commit Ableton audio):
  * Latin Percussion pack, Drum Hits previews (plain ogg, ffmpeg): "Bongo {A,B} {H,L} {Open 1F, Open 3F, Slap, Heel, Tip, Rim, Flam 1F, Flam 3F}".
    A and B are two takes (two kits); H = macho (the high drum), L = hembra (the low). Peak-normalised, so only shapes are compared, not loudness.
  * Live 12 Core Library one-shots (plain AIFF/WAV): Drums/Bongo/Bongo {High,Low} Open {Hard,Soft}, Bongo Edge {High,Low}, Hi Dry, Shy and Dry (extra: measured, not fitted).
    python3 tests/refs.py     # (re)convert and list
    from refs import REFS, load, ref_names   # REFS[name] = (stroke, drum, take); load(name) -> (sr, x) peak-normalised mono
Stroke naming used here: "open" = Open 1F, "open3" = Open 3F, slap, heel, tip, rim, "flam" = Flam 1F, "flam3" = Flam 3F (see docs/SPEC.md for what 1F / 3F are).
"""
import glob
import os
import subprocess

import numpy as np
from scipy.io import wavfile

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "../ref_wav")
LP = os.environ["LP_PACK"] + "/Ableton Folder Info/Previews/Drums/Drum Hits/Bongo"
CL = "/Applications/Ableton Live 12 Suite.app/Contents/App-Resources/Core Library/Samples/One Shots/Drums/Bongo"
DR = {"H": 0, "L": 1}
LPS = {"Open 1F": "open", "Open 3F": "open3", "Slap": "slap", "Heel": "heel", "Tip": "tip", "Rim": "rim", "Flam 1F": "flam", "Flam 3F": "flam3"}
REFS = {}
for t in "AB":
    for d in "HL":
        for lab, s in LPS.items():
            REFS[f"lp_Bongo_{t}_{d}_{lab.replace(' ', '_')}"] = (s, DR[d], t)
# each take's tuning against the nominal drum (engine F1): a take's head modes sit at TAKE_SCALE x the nominal frequencies. From the cross-correlation of the A and B
# log spectra (tests/analysis in docs/SPEC.md): B is 3.1 % above A on Macho, 14.7 % on Hembra; the engine's F1 is the geometric middle of the two.
TAKE_SCALE = {0: {"A": 0.9848, "B": 1.0155}, 1: {"A": 0.9337, "B": 1.0709}}
EXTRA = ["cl_Bongo_High_Open_Hard", "cl_Bongo_High_Open_Soft", "cl_Bongo_Low_Open_Hard", "cl_Bongo_Low_Open_Soft", "cl_Bongo_Edge_High", "cl_Bongo_Edge_Low",
         "cl_Bongo_Hi_Dry", "cl_Bongo_Shy_and_Dry"]


def src_of(name):
    kind, rest = name[:2], name[3:].replace("_", " ")
    if kind == "lp":
        return os.path.join(LP, rest + ".adg.ogg")
    for ext in (".aif", ".wav"):
        p = os.path.join(CL, rest + ext)
        if os.path.exists(p):
            return p
    raise FileNotFoundError(name)


def convert():
    os.makedirs(OUT, exist_ok=True)
    for n in list(REFS) + EXTRA:
        subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-i", src_of(n), "-ac", "1", "-c:a", "pcm_f32le", os.path.join(OUT, n + ".wav")], check=True)


def load(n):
    p = os.path.join(OUT, n + ".wav")
    if not os.path.exists(p):
        convert()
    sr, x = wavfile.read(p)
    x = x.astype(float)
    return sr, x / (np.abs(x).max() + 1e-12)


def ref_names(drum, stroke):
    """[(take, name)] of the recordings that define that stroke on that drum"""
    return [(t, n) for n, (s, d, t) in REFS.items() if s == stroke and d == drum]


if __name__ == "__main__":
    convert()
    for n in list(REFS) + EXTRA:
        sr, x = load(n)
        print(n, REFS.get(n), sr, round(len(x) / sr, 2))
