"""compare.py -- plot the recordings against ours for one drum and stroke: first 40 ms (waveform), 0..1.2 s (5 ms RMS, dB), spectrograms 0..600 Hz and 0..10 kHz.

    python3 tests/compare.py open|rimshot|rim|hand|mute|all [vel]      # -> docs/compare/<stroke>.png (gitignored): 
Rows: the recording (peak-normalised, as stored) then ours (vel 0.8, peak-normalised the same way).
"""
import os
import sys

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402
from scipy.signal import spectrogram  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import measure as M  # noqa: E402
from fit import write_code  # noqa: E402
from refs import load, ref_names  # noqa: E402

E = M.E


def stroke_audio(stroke, vel=0.8):
    rows = []
    for n in ref_names(stroke):
        sr, x = load(n)
        on = M.onset(x)
        rows.append(("ref", sr, x[max(0, on - int(0.002 * sr)):]))
    code = write_code(E.load_tables(), jitter=E.JITTER_DB)
    sr, y = M.render([(E.STROKES.index(stroke), vel, 0.02)], 1.8, [], code=code)
    on = M.onset(y)
    y = y[max(0, on - int(0.002 * sr)):]
    rows.append(("ours", sr, y / (np.abs(y).max() + 1e-12)))
    return rows[:3] + rows[-1:]       # three takes of eight, then ours


def main():
    stroke = sys.argv[1]
    vel = float(sys.argv[2]) if len(sys.argv) > 2 else 0.8
    for stroke in ([s for s in E.STROKES if ref_names(s)] if stroke == "all" else [stroke]):
        rows = stroke_audio(stroke, vel)
        fig, ax = plt.subplots(len(rows), 4, figsize=(20, 2.4 * len(rows)))
        for i, (lab, sr, x) in enumerate(rows):
            t = np.arange(len(x)) / sr * 1000
            a = ax[i]
            n = int(0.04 * sr)
            a[0].plot(t[:n], x[:n], lw=0.6)
            a[0].set_ylabel(lab)
            w = max(2, int(0.005 * sr))
            env = 20 * np.log10(np.sqrt(np.convolve(x ** 2, np.ones(w) / w, "same")) + 1e-6)
            m = t < 1200
            a[1].plot(t[m], env[m], lw=0.8)
            a[1].set_ylim(-90, 0)
            a[1].grid(alpha=0.3)
            f, tt, S = spectrogram(x[:int(1.2 * sr)], sr, nperseg=4096, noverlap=3584)
            k = f < 600
            a[2].pcolormesh(tt * 1000, f[k], 10 * np.log10(S[k] + 1e-14), vmin=-110, vmax=-30, shading="auto")
            f, tt, S = spectrogram(x[:int(0.1 * sr)], sr, nperseg=128, noverlap=112)
            k = f < 10000
            a[3].pcolormesh(tt * 1000, f[k], 10 * np.log10(S[k] + 1e-14), vmin=-120, vmax=-40, shading="auto")
        ax[0][0].set_title("first 40 ms")
        ax[0][1].set_title("5 ms RMS, dB (0..1200 ms)")
        ax[0][2].set_title("spectrogram, 0..600 Hz, 1.2 s")
        ax[0][3].set_title("spectrogram, 0..10 kHz, first 100 ms")
        out = os.path.join(HERE, "../docs/compare")
        os.makedirs(out, exist_ok=True)
        p = os.path.join(out, f"{stroke}.png")
        fig.tight_layout()
        fig.savefig(p, dpi=60)
        plt.close(fig)
        print(p)


if __name__ == "__main__":
    main()
