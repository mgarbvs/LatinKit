"""End-to-end checks of m4l/Cuica.amxd running in real standalone Max (needs Max, not Live), from a cold start.

    uv run --directory $MAXTEST_DIR python <repo>/Cuica/tests/test_max_render.py
Also writes docs/demo.wav (a samba-ish phrase with mod-wheel thumb sweeps) when run with --demo.
"""
import os
import shutil
import subprocess
import sys
import time

import numpy as np

sys.path.insert(0, os.environ["MAXTEST_DIR"])
import server  # noqa: E402
from analyze import read_wav  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
DEV = os.path.join(HERE, "../m4l/Cuica.amxd")
RESTART = os.path.join(HERE, "../scripts/max_restart.sh")
FAILS = []
# every test starts from these (a shared device instance keeps what the last test set)
BASE = {"Tune": 0, "Pressure": 55, "Speed": 60, "Stroke": 300, "Pull": 0, "Scoop": -4, "Glide": 60, "Thumb": 12, "Head": 50,
        "Rasp": 25, "Tone": 60, "Decay": 400, "Volume": -6,
        "MPE": 1, "MPE Bend": 48, "MPE Pressure": 100, "MPE Slide": 1, "Alt": 1}


def check(cond, what):
    print(("ok   " if cond else "FAIL ") + what)
    if not cond:
        FAILS.append(what)


def play(events, ms, **p):
    r = server.render(events, ms, params={**BASE, **p})
    x, sr = read_wav(r["wav"])
    return x.mean(axis=1), sr, r


def onset(x, sr, thresh=0.003):   # time (s) of the first sample above ~-50 dBFS: the harness's event jitter is a few ms
    return int(np.argmax(np.abs(x) > thresh)) / sr


def pitch(x, sr, near, t0, t1):   # autocorrelation peak within -7..+7 semitones of near, parabolic refinement (Hz)
    s = x[int(t0 * sr):int(t1 * sr)]
    lo, hi = int(sr / near / 1.5), int(sr / near * 1.5) + 1
    c = np.array([np.dot(s[:len(s) - lag], s[lag:]) for lag in range(lo - 1, hi + 2)])
    k = int(np.argmax(c[1:-1])) + 1
    return sr / (lo - 1 + k + 0.5 * (c[k - 1] - c[k + 1]) / (c[k - 1] - 2 * c[k] + c[k + 1]))


def ct(f, g):
    return 1200 * np.log2(f / g)


def rms_db(x, sr, t0, t1):
    s = x[int(t0 * sr):int(t1 * sr)]
    return 20 * np.log10(np.sqrt(np.mean(s ** 2)) + 1e-12)


def demo():   # a samba figure at 100 bpm: one stroke per 16th note (push/pull alternate), low grunts and high cries, wheel
    ev = []      # sweeps on the cries, then a long cry held on with channel pressure (MPE-style) while the thumb rises
    def cc(at, v): ev.append({"t": at, "cc": 1, "value": v})
    def note(at, n, vel=100, dur=120): ev.append({"t": at, "note": n, "vel": vel, "dur": dur})
    s16 = 150
    for bar in range(2):
        b = 50 + bar * 16 * s16
        for step, n, v in ((0, 57, 110), (2, 69, 90), (3, 69, 80), (6, 57, 105), (8, 69, 95), (10, 57, 100), (11, 69, 85), (14, 74, 115)):
            note(b + step * s16, n, v)
        cc(b + 14 * s16, 0)
        for i in range(6): cc(b + 14 * s16 + 20 + i * 25, int(127 * i / 5))
        cc(b + 15 * s16 + 60, 0)
    t = 50 + 32 * s16
    cc(t, 0); note(t, 69, 110, 1400)
    for i in range(14): ev.append({"t": t + 10 + i * 100, "midi": [0xD0, int(110 * (1 - i / 13))]})
    for i in range(10): cc(t + 300 + i * 80, int(127 * i / 9))
    return ev, t + 2000


subprocess.run(["bash", RESTART], capture_output=True)
loaded = server.load_device(DEV)
errs = [l for l in loaded["console"] if "[1]" in l]
check(not errs, f"cold load: no [1] errors on the console ({len(errs)})")
for l in errs:
    print("     " + l)
names = {p["name"] for p in loaded["params"]}
check(set(BASE) <= names, f"all {len(BASE)} parameters exposed (missing: {set(BASE) - names or 'none'})")
for _ in range(20):   # gen~ keeps compiling for a few seconds after a cold load
    x, sr, r = play([{"t": 20, "note": 72, "vel": 100, "dur": 300}], 500)
    if r["peak_dbfs"] is not None and r["peak_dbfs"] > -40:
        break
    time.sleep(0.5)
check(r["peak_dbfs"] is not None and r["peak_dbfs"] > -40, f"the device makes sound after a cold load ({r['peak_dbfs']} dBFS)")

# 1. in tune (first push stroke): the scoop rides the stroke and arrives at 0.105 s; the pitch sags once the rub eases (0.165 s)
for n in (60, 72, 84):
    x, sr, r = play([{"t": 50, "note": n, "vel": 100, "dur": 600}], 800, Pull=0)   # notes alternate push/pull across renders
    f0, t0 = 440 * 2 ** ((n - 69) / 12), onset(x, sr)
    c = ct(pitch(x, sr, f0, t0 + 0.11, t0 + 0.145), f0)
    check(abs(c) < 10 and r["nan_count"] == 0, f"MIDI {n}: {c:+.1f} ct (need within 10), peak {r['peak_dbfs']} dBFS")

# 1b. grip (Pressure) lowers the pitch: in tune at the default, 15..70 ct flat at full (the friction core, round 6)
g = []
for p in (55, 100):
    x, sr, r = play([{"t": 50, "note": 72, "vel": 100, "dur": 600}], 800, Pull=0, Scoop=0, Pressure=p)
    f0, t0 = 440 * 2 ** ((72 - 69) / 12), onset(x, sr)
    g.append(ct(pitch(x, sr, f0, t0 + 0.06, t0 + 0.1), f0))
check(-70 < g[1] - g[0] < -15, f"Pressure 55 -> 100: {g[0]:+.0f} -> {g[1]:+.0f} ct (grip flattens, 15..70 ct)")

# 2. one stroke per note: a held note goes quiet once its stroke (3/4 of Stroke = 225 ms) is done
x, sr, r = play([{"t": 50, "note": 72, "vel": 100, "dur": 1500}], 1700, Rasp=0, Pull=0)
t0 = onset(x, sr)
a, b = rms_db(x, sr, t0 + 0.05, t0 + 0.15), rms_db(x, sr, t0 + 0.6, t0 + 1.4)
check(a > -30 and b < -60, f"held 1.5 s: stroke {a:.0f} dBFS, then {b:.0f} dBFS (one stroke, need < -60)")

# 3. channel pressure keeps rubbing while held; note-off: silent (< -60 dB) within 3 x Decay
x, sr, r = play([{"t": 50, "note": 72, "vel": 127, "dur": 500}, {"t": 60, "midi": [0xD0, 100]}], 1300, Volume=6, Decay=150)
tail = rms_db(x, sr, 0.05 + 0.5 + 0.45 + 0.03, 1.25)
body = rms_db(x, sr, 0.3, 0.5)
check(tail < -60 and body > -30, f"note-off: tail {tail:.0f} dBFS at 3 x Decay (Decay 150 ms), body {body:.0f} dBFS")

# 4. the thumb: wheel up raises the pitch by Thumb
x, sr, _ = play([{"t": 0, "cc": 1, "value": 127}, {"t": 50, "note": 64, "vel": 100, "dur": 700}], 900, Scoop=0, Pull=0)
f1, t0 = 440 * 2 ** ((64 + 12 - 69) / 12), onset(x, sr)
c = ct(pitch(x, sr, f1, t0 + 0.08, t0 + 0.13), f1)   # mid-stroke, before the end sag
check(abs(c) < 15, f"wheel 127, Thumb 12: {c:+.1f} ct from an octave up")

# 5. Alt On: notes alternate push and pull; the pull is higher by Pull
x, sr, _ = play([{"t": 50, "note": 67, "vel": 100, "dur": 300}, {"t": 450, "note": 67, "vel": 100, "dur": 300}], 900,
                Pull=3, Scoop=0, Glide=20, Alt=2)
f0, t0 = 440 * 2 ** (-2 / 12), onset(x, sr)
p1, p2 = ct(pitch(x, sr, f0, t0 + 0.08, t0 + 0.14), f0), ct(pitch(x, sr, f0, t0 + 0.48, t0 + 0.54), f0)
a, b = (p1, p2) if abs(p1) < abs(p2) else (p2, p1)   # the device remembers the last direction across renders
check(abs(a) < 15 and abs(b - 300) < 15, f"Pull 3 st: push {a:+.0f} ct, pull {b:+.0f} ct (need 0 / +300)")

# 6. back-to-back notes (note-off on the next note-on's tick: gate-collapse check) all speak
seq = [{"t": 50 + 250 * i, "note": n, "vel": 100, "dur": 250} for i, n in enumerate((60, 64, 67, 64, 60))]
x, sr, _ = play(seq, 1500)
levels = [rms_db(x, sr, 0.05 + 0.25 * i + 0.1, 0.05 + 0.25 * i + 0.2) for i in range(5)]
check(min(levels) > -45, "5 back-to-back notes: levels " + ", ".join(f"{v:.0f}" for v in levels) + " dBFS (all > -45)")

# 7. legato: an overlapping note is a new stroke that glides from the first note's pitch
x, sr, _ = play([{"t": 50, "note": 60, "vel": 100, "dur": 800}, {"t": 400, "note": 67, "vel": 100, "dur": 800}], 1500, Pull=0)
f67 = 440 * 2 ** (-2 / 12)
c = ct(pitch(x, sr, f67, 0.4 + 0.1, 0.4 + 0.15), f67)
check(abs(c) < 15, f"legato 60 -> 67: {c:+.1f} ct from the new note after 100 ms")

# 8. MPE: a note on member channel 2 with pressure (rubs on), slide (the thumb) and per-note bend on its own channel;
#    channel 3's expression is ignored
v = 8192 + round(-2 / 48 * 8191)
x, sr, _ = play([{"t": 50, "midi": [0x91, 64, 100]}, {"t": 60, "midi": [0xD1, 90]}, {"t": 60, "midi": [0xB1, 74, 127]},
                 {"t": 60, "midi": [0xE1, v & 127, v >> 7]}, {"t": 70, "midi": [0xB2, 74, 0]}, {"t": 70, "midi": [0xD2, 0]},
                 {"t": 750, "midi": [0x81, 64, 0]}], 1000, Scoop=0, Pull=0, Thumb=12, Rasp=0)
f = 440 * 2 ** ((64 + 12 - 2 - 69) / 12)
c, lvl = ct(pitch(x, sr, f, 0.55, 0.65), f), rms_db(x, sr, 0.55, 0.65)
check(abs(c) < 15 and lvl > -35, f"MPE ch 2: pressure still rubbing at 0.6 s ({lvl:.0f} dBFS), slide + bend -2 st: {c:+.1f} ct from 64+12-2")

# 8b. the MPE page's switch: MPE off ignores pressure (one stroke only)
x, sr, _ = play([{"t": 50, "midi": [0x91, 64, 100]}, {"t": 60, "midi": [0xD1, 90]}, {"t": 750, "midi": [0x81, 64, 0]}], 1000,
                Scoop=0, Pull=0, Rasp=0, MPE=0)
lvl = rms_db(x, sr, 0.55, 0.65)
check(lvl < -60, f"MPE off: pressure ignored, {lvl:.0f} dBFS at 0.6 s (one stroke only)")

# 9. extremes: finite, no clipping
for side in ("max", "min"):
    hi = side == "max"
    p = {"Tune": 24 if hi else -24, "Pressure": 100 if hi else 0, "Speed": 100 if hi else 0, "Stroke": 40 if hi else 800,
         "Pull": 7 if hi else -7, "Scoop": 12 if hi else -12, "Glide": 0 if hi else 500, "Thumb": 24, "Head": 100 if hi else 0,
         "Rasp": 100 if hi else 0, "Tone": 100 if hi else 0, "Decay": 2000 if hi else 10, "Volume": 0}
    x, sr, r = play([{"t": 0, "cc": 1, "value": 127}] + [{"t": 50 + 150 * i, "note": n, "vel": 127, "dur": 400} for i, n in enumerate((24, 48, 72, 96))], 900, **p)
    check(r["nan_count"] == 0 and r["inf_count"] == 0 and r["clipped_samples"] == 0, f"all controls {side}: peak {r['peak_dbfs']} dBFS, nan {r['nan_count']}, clipped {r['clipped_samples']}")

if "--demo" in sys.argv:
    ev, ms = demo()
    x, sr, r = play(ev, ms, Volume=-3)
    shutil.copy(r["wav"], os.path.join(HERE, "../docs/demo.wav"))
    print(f"demo.wav written: peak {r['peak_dbfs']} dBFS, {ms} ms")

sys.exit(1 if FAILS else 0)
