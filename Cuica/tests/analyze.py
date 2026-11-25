"""analyze.py <a.wav> [b.wav ...] -- timbre fingerprint for comparing Cuica against real cuica recordings:
per 20 ms frame: level, f0 (autocorrelation), harmonic profile H1..H8 (dB re H1), and the noise share (energy not in harmonics)."""
import sys
import numpy as np
from scipy.io import wavfile


def load(p):
    sr, x = wavfile.read(p)
    x = x.astype(float)
    if x.ndim > 1:
        x = x.mean(1)
    return sr, x / (np.abs(x).max() + 1e-12)


def f0_of(fr, sr):
    fr = fr - fr.mean()
    ac = np.correlate(fr, fr, "full")[len(fr) - 1:]
    lo, hi = int(sr / 4000), int(sr / 100)
    k = lo + np.argmax(ac[lo:hi])
    return sr / k if ac[k] > 0.3 * ac[0] else 0.0


def frame_stats(fr, sr, f0):
    n = len(fr)
    sp = np.abs(np.fft.rfft(fr * np.hanning(n), 8 * n)) ** 2
    fq = np.fft.rfftfreq(8 * n, 1 / sr)
    tot = sp[fq < 10000].sum()
    H = []
    harm = 0
    for h in range(1, 9):
        m = np.abs(fq - h * f0) < f0 * 0.15
        e = sp[m].sum()
        harm += e
        H.append(e)
    H = np.array(H) + 1e-20
    return 10 * np.log10(H / H[0]), 1 - harm / tot


def report(p):
    sr, x = load(p)
    N = int(0.04 * sr)
    hop = int(0.02 * sr)
    print(f"== {p.split('/')[-1]}  {len(x) / sr:.2f} s")
    profs, noises = [], []
    for i in range(0, len(x) - N, hop):
        fr = x[i:i + N]
        lvl = 20 * np.log10(np.sqrt((fr ** 2).mean()) + 1e-9)
        if lvl < -40:
            continue
        f0 = f0_of(fr, sr)
        if not f0:
            print(f"{i / sr:5.2f}s {lvl:6.1f} dB   unpitched")
            continue
        H, nz = frame_stats(fr, sr, f0)
        profs.append(H)
        noises.append(nz)
        print(f"{i / sr:5.2f}s {lvl:6.1f} dB f0 {f0:6.0f}  H2..H8 " + " ".join(f"{h:5.0f}" for h in H[1:]) + f"  noise {nz:4.2f}")
    if profs:
        print("MEAN H2..H8:", " ".join(f"{h:5.1f}" for h in np.mean(profs, 0)[1:]), f" noise {np.mean(noises):.2f}")


for p in sys.argv[1:]:
    report(p)
