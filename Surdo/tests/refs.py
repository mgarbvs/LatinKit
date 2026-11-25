"""refs.py -- the surdo reference strokes. Sources, converted once to ref_wav/*.wav (float32 mono, native rate; gitignored; never commit Ableton audio):
  * Latin Percussion pack, Drum Hits previews (plain ogg, ffmpeg): "Surdo {Open, Mute, Rim, Finger}", one take each, stereo, peak-normalised, so only shapes are compared.
  * Live Latin Percussion pack clips (Previews/Clips): Samba 1 / Samba 2 / Baion B / Candombe B / Murga B / Rhumba Funk B / Afoxe (+ tambourin) surdo loops. They replay the same
    samples as the one-shots at other gains (docs/SPEC.md): used for tuning, glide and level measurements (tests/clips.py), not as fit targets.
    python3 tests/refs.py     # (re)convert and list
    from refs import REFS, load, ref_names   # REFS[name] = stroke; load(name) -> (sr, x) peak-normalised mono
"""
import os
import subprocess

import numpy as np
from scipy.io import wavfile

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "../ref_wav")
LP = os.environ["LP_PACK"] + "/Ableton Folder Info/Previews"
REFS = {f"lp_Surdo_{s}": s.lower() for s in ("Open", "Mute", "Rim", "Finger")}
CLIPS = {"Samba 1 Surdo-120bpm": "clip_Samba_1", "Samba 2 Surdo-120bpm": "clip_Samba_2", "Baion B Surdo-120bpm": "clip_Baion_B", "Candombe B Surdo-120bpm": "clip_Candombe_B",
         "Murga B Surdo-90bpm": "clip_Murga_B", "Rhumba Funk B Surdo-166bpm": "clip_Rhumba_Funk_B", "Afoxe Tambourin & Surdo-107bpm": "clip_Afoxe"}


def src_of(name):
    if name.startswith("lp_"):
        return os.path.join(LP, "Drums/Drum Hits/Percussion", name[3:].replace("_", " ") + ".adg.ogg")
    return os.path.join(LP, "Clips", [k for k, v in CLIPS.items() if v == name][0] + ".alc.ogg")


def convert():
    os.makedirs(OUT, exist_ok=True)
    for n in list(REFS) + list(CLIPS.values()):
        subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-i", src_of(n), "-ac", "1", "-c:a", "pcm_f32le", os.path.join(OUT, n + ".wav")], check=True)


def load(n):
    p = os.path.join(OUT, n + ".wav")
    if not os.path.exists(p):
        convert()
    sr, x = wavfile.read(p)
    x = x.astype(float)
    return sr, x / (np.abs(x).max() + 1e-12)


def ref_names(stroke):
    """[name] of the recordings that define that stroke"""
    return [n for n, s in REFS.items() if s == stroke]


if __name__ == "__main__":
    convert()
    for n in list(REFS) + list(CLIPS.values()):
        sr, x = load(n)
        print(n, REFS.get(n), sr, round(len(x) / sr, 2))
