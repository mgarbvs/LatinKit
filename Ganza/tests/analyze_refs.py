"""analyze_refs.py -- what the CC ganza / chocalho recordings are: durations, onsets (stroke grid), per-segment centroid and 1/3-octave spectrum.
python3 -I tests/analyze_refs.py [name ...]"""
import os, sys, warnings
import numpy as np
from scipy.io import wavfile
from scipy.signal import welch, find_peaks
warnings.filterwarnings("ignore")
H = os.path.dirname(os.path.abspath(__file__))
def load(n):
    sr, x = wavfile.read(f"{H}/../ref_wav/{n}.wav"); return sr, x / 32768.
def rms(x, ms, sr):
    w = max(1, int(ms * sr / 1000)); return np.sqrt(np.convolve(x ** 2, np.ones(w) / w, "same"))
def cent(w, sr):
    sp = np.abs(np.fft.rfft(w * np.hanning(len(w)), 16384)) ** 2; fr = np.fft.rfftfreq(16384, 1 / sr); return (sp * fr).sum() / sp.sum()
def thirds(x, sr):
    f, p = welch(x, sr, nperseg=2048)
    ed = 250 * 2 ** (np.arange(0, 20) / 3); out = [p[(f >= lo) & (f < hi)].sum() for lo, hi in zip(ed[:-1], ed[1:])]
    out = np.array(out); return 10 * np.log10(out / out.sum() + 1e-12), ed[:-1]
if __name__ == "__main__":
    names = sys.argv[1:] or ["ganza_mattyharm", "ganza_jckovach", "ganza_arroz", "metal_alexarje", "choc_commons", "choc_fwd1", "choc_back1", "choc_rhythm1"]
    for n in names:
        sr, x = load(n); e = rms(x, 5, sr)[::48]
        print(f"== {n}: {len(x)/sr:.2f} s, peak {20*np.log10(abs(x).max()):.1f} dB, rms {20*np.log10(x.std()):.1f} dB")
        env = 20 * np.log10(e / e.max() + 1e-6)
        pk, _ = find_peaks(env, height=-25, distance=40, prominence=6)
        print("  onsets/peaks (ms:dB):", " ".join(f"{p*1:d}:{env[p]:.0f}" for p in pk[:40]))
        if len(pk) > 2: d = np.diff(pk); print(f"  interval median {np.median(d):.0f} ms, sd {d.std():.0f}, n {len(pk)}")
        th, ed = thirds(x, sr); print("  1/3-oct:", " ".join(f"{int(f)}:{v:.0f}" for f, v in zip(ed, th)))
        print(f"  centroid {cent(x[:min(len(x), 48000)], sr):.0f} Hz")
