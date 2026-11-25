"""segment_refs.py -- cut the 16th-note CC0 ganza loop (ref_wav/ganza_arroz.wav) into single strokes ref_wav/arroz_sNN.wav, each from the trough
before it to the trough after it (strokes are 118 ms apart, so each carries its neighbour's tail). python3 tests/segment_refs.py"""
import os, sys, numpy as np
from scipy.io import wavfile
from scipy.signal import find_peaks
H = os.path.dirname(os.path.abspath(__file__)); R = f"{H}/../ref_wav"
sr, x = wavfile.read(f"{R}/ganza_arroz.wav"); xf = x / 32768.
w = int(0.004 * sr); e = np.sqrt(np.convolve(xf ** 2, np.ones(w) / w, "same"))
db = 20 * np.log10(e / e.max() + 1e-6)
pk, _ = find_peaks(db, height=-20, distance=int(0.06 * sr), prominence=3)
tr = [int(np.argmin(e[a:b])) + a for a, b in zip(pk[:-1], pk[1:])]
for i in range(1, len(pk) - 1):          # strokes 1..n-2 have a trough on both sides
    a, b = tr[i - 1], tr[i]
    wavfile.write(f"{R}/arroz_s{i:02d}.wav", sr, x[a:b])
    print(i, f"{a/sr:.3f}-{b/sr:.3f} peak {db[pk[i]]:.1f} dB")
