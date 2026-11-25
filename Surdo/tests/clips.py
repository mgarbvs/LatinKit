"""clips.py -- what the Latin Percussion surdo clips (tests/refs.py CLIPS) add to the four one-shots.

    python3 tests/clips.py stats          # which one-shot each clip hit replays, at what gain; the Open's pitch and glide against level (the numbers in docs/SPEC.md)
    python3 tests/clips.py score <clip>   # the clip's hits as [(ms, stroke, velocity)] for the demo (e.g. clip_Samba_1)
Method: a clip hit = a normalised cross-correlation peak (> 0.97, Open > 0.9) of the first 62 ms of a one-shot; its gain = the least-squares scale of the one-shot. The clips are sample replays,
so nothing here is a new recording of a stroke: they give tuning, the Open's glide against level (velocity layers), and what loudness the strokes have against each other in use.
"""
import sys

import numpy as np
from scipy.signal import fftconvolve

import measure as M
from refs import CLIPS, REFS, load

STROKES = ["open", "mute", "finger", "rim"]


def templates():
    t = {}
    for n, s in REFS.items():
        sr, x = load(n)
        o = M.onset(x)
        t[s] = x[max(0, o - int(0.002 * sr)):o + int(0.062 * sr)]
    return sr, t


RISE_DB = 5.0
THR = {"open": 0.9, "mute": 0.97, "finger": 0.97, "rim": 0.97}      # the Open is an 86 Hz tone: any neighbour hit leaves the 62 ms correlation lower


def hits(clip):
    """[(time s, stroke, gain re the one-shot)] of every one-shot replay in the clip"""
    sr, t = templates()
    _, x = load(clip)
    w = int(0.003 * sr)
    env = 20 * np.log10(np.sqrt(np.convolve(x ** 2, np.ones(w) / w, "same")) + 1e-7)
    out = []
    for s in STROKES:
        tt = t[s]
        e = np.sum(tt ** 2)
        c = fftconvolve(x, tt[::-1], "valid")
        r = c / (np.sqrt(np.maximum(fftconvolve(x ** 2, np.ones(len(tt)), "valid"), 0) * e) + 1e-12)
        for _ in range(200):
            i = int(np.argmax(r))
            if not r[i] > THR[s]:
                break
            # an Open match is an onset only if the 3 ms envelope rises by 5 dB across it: later stretches of the same ring correlate 0.9 with the template too (ghosts, a third of the matches)
            j = i + int(0.002 * sr)
            if s != "open" or env[j + int(0.005 * sr)] - env[j - int(0.005 * sr)] > RISE_DB:
                out.append((i / sr, s, float(c[i] / e)))
            r[max(0, i - int(0.1 * sr)):i + int(0.1 * sr)] = 0
    return sorted(out)


def stats():
    sc = {s: [] for s in STROKES}
    opens = []
    for clip in CLIPS.values():
        sr, x = load(clip)
        # the clip's peak-normalisation differs per clip: convert the gains back with the clip's own peak is not possible, so gains are re the clip's peak-normalised file; report as found
        hs = hits(clip)
        for t, s, g in hs:
            sc[s].append(g)
        times = [h[0] for h in hs]
        for t, s, g in hs:
            if s != "open" or g < 0.15:
                continue
            nxt = [u for u in times if u > t + 0.01]
            if nxt and nxt[0] - t < 0.32:
                continue                    # another hit inside the 300 ms the glide is read over
            on = int((t + 0.002) * sr)
            if on + int(0.62 * sr) > len(x):
                continue
            opens.append((g, 1200 * np.log2(M.pitch(x, sr, 0.04, 0.10, on=on) / M.pitch(x, sr, 0.20, 0.29, on=on)), M.pitch(x, sr, 0.3, 0.6, on=on)))
        print(clip, {s: len([h for h in hs if h[1] == s]) for s in STROKES})
    print("gain of the replayed one-shot in the clips (the clips are peak-normalised files; the one-shots peak at 1.0):")
    for s, v in sc.items():
        if v:
            v = np.array(v)
            print(f"  {s:6s} n {len(v):3d}  median {np.median(v):.2f} ({20 * np.log10(np.median(v)):+.1f} dB)  min {v.min():.2f}  max {v.max():.2f}")
        else:
            print(f"  {s:6s} none")
    o = np.array(opens)
    print(f"clean Open replays (no other hit within 0.32 s): {len(o)}; settled pitch f(0.3-0.6 s) median {np.median(o[:, 2]):.2f} Hz (min {o[:, 2].min():.2f}, max {o[:, 2].max():.2f})")
    for lo, hi in ((0, 0.35), (0.35, 0.6), (0.6, 1.5)):
        m = (o[:, 0] >= lo) & (o[:, 0] < hi)
        if m.any():
            print(f"  gain {lo}..{hi}: n {int(m.sum()):2d}  glide f(40-100 ms) vs f(200-290 ms): median {np.median(o[m, 1]):.0f} ct  (min {o[m, 1].min():.0f}, max {o[m, 1].max():.0f})")


def score(clip, bars_s=None):
    hs = [h for h in hits(clip) if h[2] > 0.15]
    t0 = hs[0][0]
    print([(round((t - t0) * 1000), s, int(np.clip(127 * min(g, 1.0) ** (1 / 1.4), 8, 127))) for t, s, g in hs if s != "rim"])


if __name__ == "__main__":
    stats() if sys.argv[1] == "stats" else score(sys.argv[2])
