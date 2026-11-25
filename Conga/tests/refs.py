"""refs.py -- the conga reference strokes: Ableton Core Library plain AIFFs, converted once to ref_wav/*.wav (float32 mono, native rate; gitignored).
    python3 tests/refs.py            # (re)convert
    from refs import REFS, load      # REFS[name] = (stroke, drum, file); load(name) -> (sr, x) peak-normalised mono
"""
import os
import re
import subprocess
import numpy as np
from scipy.io import wavfile

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "../ref_wav")
SRC = "/Applications/Ableton Live 12 Suite.app/Contents/App-Resources/Core Library/Samples/One Shots/Drums/Conga"
# name -> (stroke, drum). Hi = quinto-ish, Low = tumba-ish, the unlabelled ones are the "conga" (mid)
REFS = {"Hi Muted": ("mute", "quinto"), "Hi Slap": ("slap", "quinto"), "Hi Smack": ("slap", "quinto"),
        "Low Slap 1": ("slap", "tumba"), "Low Slap 2": ("slap", "tumba"), "Open Hard": ("open", "conga"), "Open Soft": ("open", "conga"),
        "Low Ring 1": ("open", "tumba"), "Low Ring 2": ("open", "tumba"), "Medium": ("open", "conga"), "Soft": ("open", "conga"), "Hard": ("open", "conga")}


# Latin Percussion pack, Drum Hits previews (plain 128 kbps ogg, read through ffmpeg): "<Drum> <take A/B/C> <stroke>"
LP = os.environ["LP_PACK"] + "/Ableton Folder Info/Previews/Drums/Drum Hits/Conga"
LP_STROKE = {"Open": "open", "Mute": "mute", "Slap Open": "slap", "Slap": "slap", "Slap Mute": "slapmute", "Heel": "heel", "Tip": "toe",
             "Flam Opn": "flam", "Flam Mt": "flam"}


def lp_names():
    out = {}
    if os.path.isdir(LP):
        for f in sorted(os.listdir(LP)):
            m = re.match(r"(Quinto|Conga|Tumba) ([ABC]) (.+)\.adg\.ogg$", f)
            if m and m.group(3) in LP_STROKE:
                out[f"lp {m.group(1)} {m.group(2)} {m.group(3)}"] = (LP_STROKE[m.group(3)], m.group(1).lower().replace("conga", "conga"))
    return out


REFS.update(lp_names())


def fname(n):
    return n.replace(" ", "_")


def convert():
    os.makedirs(OUT, exist_ok=True)
    for n in REFS:
        if n.startswith("lp "):
            src = os.path.join(LP, n[3:] + ".adg.ogg")
            subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-i", src, "-ac", "1", "-c:a", "pcm_f32le", os.path.join(OUT, fname(n) + ".wav")], check=True)
            continue
        subprocess.run(["afconvert", "-f", "WAVE", "-d", "LEF32", "-c", "1", os.path.join(SRC, f"Conga {n}.aif"), os.path.join(OUT, fname(n) + ".wav")], check=True)


def load(n):
    p = os.path.join(OUT, fname(n) + ".wav")
    if not os.path.exists(p):
        convert()
    sr, x = wavfile.read(p)
    x = x.astype(float)
    return sr, x / (np.abs(x).max() + 1e-12)


if __name__ == "__main__":
    convert()
    for n in REFS:
        sr, x = load(n)
        print(n, sr, len(x) / sr)
