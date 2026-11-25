"""refs.py -- the timbales reference strokes. Sources, converted once to ref_wav/*.wav (float32 mono, native rate; gitignored; never commit Ableton audio):
  * Latin Percussion pack, Drum Hits previews (plain ogg, ffmpeg): Timbales {A,B,C} {H,L} {Open,Rim,Mute,Flam,Roll}, Timb {A,B,C} {H,L} {Cascara,Pressroll},
    Timb(ales) {A,B,C} {H,L} Stick. Peak-normalised, so only shapes are compared, not loudness.
  * Live 12 Core Library one-shots (plain AIFF/WAV, real levels): Drums/Timbales/*, Drums/Misc Percussion/Timbale *.
    python3 tests/refs.py     # (re)convert and list
    from refs import REFS, load, ref_names   # REFS[name] = (stroke, drum, take); load(name) -> (sr, x) peak-normalised mono
Stroke naming used here: LP "Open"=open, "Rim"=rimshot, "Cascara"=cascara, "Stick"=paila (stick on the shell: no head tone, 816/1633 Hz shell pair; the
label is ambiguous), "Mute"=muted. The rim click has one reference only: Core Library "Timbale Stick Slap".
"""
import glob
import os
import subprocess

import numpy as np
from scipy.io import wavfile

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "../ref_wav")
LP = os.environ["LP_PACK"] + "/Ableton Folder Info/Previews/Drums/Drum Hits/Timbales"
CL = "/Applications/Ableton Live 12 Suite.app/Contents/App-Resources/Core Library/Samples/One Shots/Drums"
DR = {"H": 0, "L": 1}
REFS = {}
for t in "ABC":
    for d in "HL":
        REFS[f"lp_Timbales_{t}_{d}_Open"] = ("open", DR[d], t)
        REFS[f"lp_Timbales_{t}_{d}_Rim"] = ("rimshot", DR[d], t)
        REFS[f"lp_Timbales_{t}_{d}_Mute"] = ("muted", DR[d], t)
        REFS[f"lp_Timb_{t}_{d}_Cascara"] = ("cascara", DR[d], t)
        REFS[f"lp_Timb_{t}_H_Stick" if d == "H" else f"lp_Timbales_{t}_L_Stick"] = ("paila", DR[d], t)
REFS["cl_Timbale_Stick_Slap"] = ("rimclick", None, "X")      # both drums
EXTRA = ["cl_Timbales_High_Open_Hard", "cl_Timbales_Low_Open_Hard", "cl_Timbale_505", "cl_Timbales_Pete", "cl_Timbale_Skin_1", "cl_Timbale_Skin_2",
         "cl_Timbale_Skin_3", "cl_Timbale_Rim_Thumb", "cl_Timbale_Chop_Processed"]   # converted, measured in RESEARCH.md, not fitted to


def src_of(name):
    kind, rest = name[:2], name[3:].replace("_", " ")
    if kind == "lp":
        return os.path.join(LP, rest + ".adg.ogg")
    for ext in (".aif", ".wav"):
        for sub in ("Timbales", "Misc Percussion"):
            p = os.path.join(CL, sub, rest + ext)
            if os.path.exists(p):
                return p
    raise FileNotFoundError(name)


def convert():
    os.makedirs(OUT, exist_ok=True)
    for n in list(REFS) + EXTRA + [os.path.basename(p)[:-4] for p in glob.glob(OUT + "/lp_Timb*_Pressroll.wav")]:
        subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-i", src_of(n), "-ac", "1", "-c:a", "pcm_f32le", os.path.join(OUT, n + ".wav")], check=True)


def load(n):
    p = os.path.join(OUT, n + ".wav")
    if not os.path.exists(p):
        convert()
    sr, x = wavfile.read(p)
    x = x.astype(float)
    return sr, x / (np.abs(x).max() + 1e-12)


def ref_names(drum, stroke):
    """[(take, name)] of the recordings that define that stroke on that drum (the rim click's one recording serves both)"""
    return [(t, n) for n, (s, d, t) in REFS.items() if s == stroke and (d == drum or d is None)]


if __name__ == "__main__":
    convert()
    for n in REFS:
        sr, x = load(n)
        print(n, REFS[n], sr, round(len(x) / sr, 2))
