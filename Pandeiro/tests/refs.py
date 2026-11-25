"""refs.py -- the pandeiro / tamborim reference strokes. Sources, converted once to ref_wav/*.wav (float32 mono, native rate; gitignored; never commit Ableton audio):
  * Latin Percussion pack, Drum Hits previews (plain ogg, ffmpeg), Drums/Drum Hits/Tambourin/: "Pandeiro A {Finger, Rim, Roll, Shake, Slap, Thumb}" (one take),
    "Tmbourim {A,B} {Finger, Mute, Open}" (the tamborim, two takes). Peak-normalised, so only shapes are compared, not loudness.
  * Not fitted, measured as a cross-check of the jingle grains: "Tmbourin {A 1, B 2, C 3..6} {Hit, Shake}" (a jingle tambourine, out of scope) -> tests/jingle_probe.py.
    python3 tests/refs.py     # (re)convert and list
    from refs import REFS, load, ref_names   # REFS[name] = (row key, instrument, take); load(name) -> (sr, x) peak-normalised mono
The Roll is not a table row (the engine plays it as the instrument's Finger row repeated); it is kept as ROLL_REF for the roll check.
"""
import os
import subprocess
import sys

import numpy as np
from scipy.io import wavfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "../scripts"))
import pandeiro_engine as E  # noqa: E402

OUT = os.path.join(HERE, "../ref_wav")
LP = os.environ["LP_PACK"] + "/Ableton Folder Info/Previews/Drums/Drum Hits/Tambourin"
CLIPS = os.environ["LP_PACK"] + "/Ableton Folder Info/Previews/Clips"
REFS = {}
for t in "A":
    for lab, key in (("Thumb", "pan_thumb"), ("Finger", "pan_finger"), ("Slap", "pan_slap"), ("Rim", "pan_rim"), ("Shake", "pan_shake")):
        REFS[f"lp_Pandeiro_{t}_{lab}"] = (key, 0, t)
for t in "AB":
    for lab, key in (("Open", "tam_open"), ("Mute", "tam_mute"), ("Finger", "tam_finger")):
        REFS[f"lp_Tmbourim_{t}_{lab}"] = (key, 1, t)
ROLL_REF = "lp_Pandeiro_A_Roll"
# each take's tuning against the nominal instrument (engine F1): the tamborim takes A and B differ by 1.00 (the cross-correlation of their pooled log spectra peaks at
# scale 1.0, tests/jingle_probe.py), the pandeiro has one take
TAKE_SCALE = {0: {"A": 1.0}, 1: {"A": 1.0, "B": 1.0}}
EXTRA = [ROLL_REF] + [f"lp_Tmbourin_{t}_{h}" for t in ("A_1", "B_2", "C_3", "C_4", "C_5", "C_6") for h in ("Hit", "Shake")]


def src_of(name):
    return os.path.join(LP, name[3:].replace("_", " ") + ".adg.ogg")


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


def ref_names(row):
    """[(take, name)] of the recordings that define that table row (an index into engine ROWS)"""
    key = E.KEYS[row]
    return [(t, n) for n, (k, _, t) in REFS.items() if k == key]


if __name__ == "__main__":
    convert()
    for n in list(REFS) + EXTRA:
        sr, x = load(n)
        print(n, REFS.get(n), sr, round(len(x) / sr, 2))
