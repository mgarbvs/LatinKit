"""compare.py -- plot the previews against ours, per stroke: waveform (first 120 ms; Top: 40 ms), 1 ms RMS in dB over the whole stroke (the ridge impacts),
spectrogram 0..16 kHz. Rows: every take of the stroke (peak-normalised, as stored) then three draws of ours (Güiro, then Reco-reco's first).

    node tests/render_strokes.js && python3 tests/compare.py [Up Down Long Top]      # -> docs/compare/<stroke>.png (gitignored)
"""
import os
import sys

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402
from scipy.io import wavfile  # noqa: E402
from scipy.signal import spectrogram  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
TAKES = {"Up": "ABCD", "Down": "ABC", "Long": "ABCD", "Top": "ABCD"}


def load(path):
    import warnings
    warnings.filterwarnings("ignore")
    sr, x = wavfile.read(path)
    x = x / 32768.0
    on = int(np.argmax(np.abs(x) > 0.03 * np.abs(x).max()))
    x = x[max(0, on - int(0.002 * sr)):]
    return sr, x / (np.abs(x).max() + 1e-12)


def main():
    kinds = sys.argv[1:] or list(TAKES)
    out = os.path.join(HERE, "../docs/compare")
    for k in kinds:
        rows = [(f"ref {t}", os.path.join(HERE, f"../ref_wav/Guiro_{t}_{k}.wav")) for t in TAKES[k]]
        rows += [(f"ours {d}", os.path.join(out, f"ours_Guiro_{k}_{d}.wav")) for d in range(3)]
        rows += [("reco-reco", os.path.join(out, f"ours_Recoreco_{k}_0.wav"))]
        fig, ax = plt.subplots(len(rows), 3, figsize=(15, 1.9 * len(rows)))
        tmax = 1.0 if k == "Long" else 0.35
        for a, (lab, p) in zip(ax, rows):
            sr, x = load(p)
            t = np.arange(len(x)) / sr * 1000
            n = int(sr * (0.04 if k == "Top" else 0.12))
            a[0].plot(t[:n], x[:n], lw=0.5)
            a[0].set_ylabel(lab, fontsize=8)
            w = max(2, int(0.001 * sr))
            env = 20 * np.log10(np.sqrt(np.convolve(x ** 2, np.ones(w) / w, "same")) + 1e-6)
            m = t < tmax * 1000
            a[1].plot(t[m], env[m], lw=0.6)
            a[1].set_ylim(-70, 0)
            a[1].grid(alpha=0.3)
            f, tt, S = spectrogram(x[:int(tmax * sr)], sr, nperseg=256, noverlap=224)
            k16 = f < 16000
            a[2].pcolormesh(tt * 1000, f[k16], 10 * np.log10(S[k16] + 1e-14), vmin=-110, vmax=-40, shading="auto")
        ax[0][0].set_title("waveform, start")
        ax[0][1].set_title("1 ms RMS, dB")
        ax[0][2].set_title("spectrogram 0..16 kHz")
        fig.tight_layout()
        fig.savefig(os.path.join(out, f"{k}.png"), dpi=60)
        plt.close(fig)
        print(os.path.join(out, f"{k}.png"))


if __name__ == "__main__":
    main()
