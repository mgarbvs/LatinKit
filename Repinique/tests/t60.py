"""t60.py -- per-mode T60 of the recordings: band-pass (+-2 %) Hilbert envelope per take, slope of the dB envelope from 60 ms to where it is 30 dB under its peak or 1.2 s, median over the takes in which the mode stands 25 dB above the floor.
    python3 tests/t60.py f1 f2 ..."""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import numpy as np
from scipy.signal import butter, hilbert, sosfiltfilt
from refs import REFS, load


def t60(x, sr, f):
    bw = max(8.0, f * 0.02)
    y = np.abs(hilbert(sosfiltfilt(butter(3, [f - bw, f + bw], "band", fs=sr, output="sos"), x)))
    w = int(sr * 0.01)
    e = 20 * np.log10(np.convolve(y, np.ones(w) / w, "same") + 1e-9)
    o = int(0.03 * sr)
    i0 = o + int(0.06 * sr)
    seg = e[i0:i0 + int(1.2 * sr)]
    pk = seg.max()
    floor = np.median(e[-int(0.2 * sr):]) if len(x) > sr * 1.4 else -200
    if pk - floor < 25:
        return None
    end = np.argmax(seg < pk - 30) if (seg < pk - 30).any() else len(seg)
    if end < int(0.1 * sr):
        end = int(0.1 * sr)
    t = np.arange(end) / sr
    s = np.polyfit(t, seg[:end], 1)[0]
    return -60 / s if s < 0 else None


if __name__ == "__main__":
    for f in map(float, sys.argv[1:]):
        r = {}
        for n, s in REFS.items():
            sr, x = load(n)
            v = t60(x, sr, f)
            if v:
                r.setdefault(s, []).append(v)
        print(f"{f:6.0f} " + "  ".join(f"{s} {np.median(v):.2f}({len(v)})" for s, v in sorted(r.items())))
