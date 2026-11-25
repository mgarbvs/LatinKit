"""analyze_refs.py -- what Open / Hand / FX are: per take rise, t20/t30, centroid, 1/3-octave spectrum, pre-event, FX burst rate.  python3 tests/analyze_refs.py"""
import os, warnings
import numpy as np
from scipy.io import wavfile
from scipy.signal import spectrogram, welch
warnings.filterwarnings("ignore")
H = os.path.dirname(os.path.abspath(__file__))
def load(n):
    sr, x = wavfile.read(f"{H}/../ref_wav/{n}.wav"); return sr, x / 32768.
def rms(x, ms, sr):
    w = max(1, int(ms * sr / 1000)); return np.sqrt(np.convolve(x ** 2, np.ones(w) / w, "same"))
def thirds(x, sr, a, n):
    f, p = welch(x[a:a + n], sr, nperseg=4096)
    ed = 500 * 2 ** (np.arange(0, 17) / 3); out = []
    for lo, hi in zip(ed[:-1], ed[1:]): out.append(p[(f >= lo) & (f < hi)].sum())
    out = np.array(out); return 10 * np.log10(out / out.sum() + 1e-12), ed[:-1]
for k in ["Open", "Hand"]:
    print("==", k)
    T = []
    for i in range(1, 9):
        sr, x = load(f"Caxixi_{i}_{k}")
        e10 = rms(x, 10, sr); pi = e10.argmax(); pk = e10[pi]
        e5 = rms(x, 5, sr); on = int(np.argmax(e5 > pk * 10 ** (-26 / 20)))
        t20 = (np.argmax(e10[pi:] < pk * .1)) / sr * 1000; t30 = (np.argmax(e10[pi:] < pk * 10 ** (-1.5))) / sr * 1000
        e1 = rms(x, 1, sr); pk1 = e1.argmax()
        # slope in dB/ms from peak to -40
        th, ed = thirds(x, sr, on, int(.1 * sr)); T.append(th)
        w = x[on:on + int(.1 * sr)]; sp = np.abs(np.fft.rfft(w * np.hanning(len(w)), 16384)) ** 2; fr = np.fft.rfftfreq(16384, 1 / sr)
        cen = (sp * fr).sum() / sp.sum()
        pre = 20 * np.log10(e5[:max(on - 1, 1)].max() / pk + 1e-9) if on > 5 else -99
        # peak 1ms vs 10ms crest => click-iness
        print(f"take {i}: rise {(pi-on)/sr*1000:5.1f} t20 {t20:5.1f} t30 {t30:5.1f} cent {cen:6.0f} peak1ms-vs-10ms {20*np.log10(e1.max()/pk):4.1f} dB, pre-onset {pre:5.1f} dB (on {on/sr*1000:.0f} ms)")
    T = np.array(T); print("mean 1/3-oct dB:", " ".join(f"{int(f)}:{v:.0f}" for f, v in zip(ed, T.mean(0))))
    print("  std over takes:", " ".join(f"{s:.0f}" for s in T.std(0)))
print("== FX burst rate")
for i in range(1, 9):
    sr, x = load(f"Caxixi_{i}_FX")
    e = rms(x, 20, sr); e = e[::48]  # 1 kHz env
    e = np.log10(e + 1e-5); e -= e.mean(); d = np.diff(e)
    # autocorr of the 20ms envelope
    ee = rms(x, 15, sr)[::48]; ee -= ee.mean()
    ac = np.correlate(ee, ee, "full")[len(ee) - 1:]; ac /= ac[0]
    lo, hi = 60, 400
    pkl = lo + ac[lo:hi].argmax()
    print(f"FX{i}: dur {len(x)/sr:.2f}s  autocorr peak lag {pkl} ms ({1000/pkl:.1f}/s) ac {ac[pkl]:.2f}  rms {20*np.log10(x.std()):.1f} dB")
