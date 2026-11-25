"""compare.py -- the previews against ours, per stroke: waveform (the first 120 ms; FX: 2 s), 1 ms RMS in dB over the stroke, spectrogram 0..20 kHz.
Rows: the eight takes (peak-normalised, as stored; fitted takes 2, 3, 4, 7 marked *) then three draws of ours.

    node tests/render_strokes.js && python3 tests/compare.py [Open Hand FX]      # -> docs/compare/<stroke>.png (gitignored)
"""
import os
import sys
import warnings

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402
from scipy.io import wavfile  # noqa: E402
from scipy.signal import spectrogram  # noqa: E402

warnings.filterwarnings("ignore")
HERE = os.path.dirname(os.path.abspath(__file__))
FITTED = (2, 3, 4, 7)


def load(path):
    sr, x = wavfile.read(path)
    x = x / 32768.0
    return sr, x / (np.abs(x).max() + 1e-12)


for k in sys.argv[1:] or ["Open", "Hand", "FX"]:
    rows = [(f"take {i}" + (" *" if i in FITTED else ""), os.path.join(HERE, f"../ref_wav/Caxixi_{i}_{k}.wav")) for i in range(1, 9)]
    rows += [(f"ours {d}", os.path.join(HERE, f"../docs/compare/ours_{k}_{d}.wav")) for d in range(3)]
    fig, ax = plt.subplots(len(rows), 3, figsize=(16, 1.7 * len(rows)))
    tmax = 2.0 if k == "FX" else 0.5
    for a, (lab, p) in zip(ax, rows):
        sr, x = load(p)
        t = np.arange(len(x)) / sr * 1000
        if k != "FX":   # start every stroke 30 ms before its first sample above 10 % of the peak, so the builds line up
            on = int(np.argmax(np.abs(x) > 0.1))
            x = x[max(0, on - int(0.03 * sr)):]
            t = np.arange(len(x)) / sr * 1000
        n = int(sr * (2.0 if k == "FX" else 0.12))
        a[0].plot(t[:n], x[:n], lw=0.4)
        a[0].set_ylabel(lab, fontsize=8)
        w = max(2, int(0.001 * sr))
        env = 20 * np.log10(np.sqrt(np.convolve(x ** 2, np.ones(w) / w, "same")) + 1e-6)
        m = t < tmax * 1000
        a[1].plot(t[m], env[m], lw=0.5)
        a[1].set_ylim(-70, 0)
        a[1].grid(alpha=0.3)
        f, tt, S = spectrogram(x[:int(tmax * sr)], sr, nperseg=256, noverlap=224)
        kk = f < 20000
        a[2].pcolormesh(tt * 1000, f[kk], 10 * np.log10(S[kk] + 1e-14), vmin=-110, vmax=-40, shading="auto")
    ax[0][0].set_title("waveform, start")
    ax[0][1].set_title("1 ms RMS, dB")
    ax[0][2].set_title("spectrogram 0..20 kHz")
    fig.tight_layout()
    out = os.path.join(HERE, f"../docs/compare/{k}.png")
    fig.savefig(out, dpi=50)
    plt.close(fig)
    print(out)
