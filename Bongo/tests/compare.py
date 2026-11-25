"""compare.py -- plot the recordings against ours for one drum and stroke: first 15 ms (waveform), 0..400 ms (5 ms RMS, dB), spectrogram 0..8 kHz.

    python3 tests/compare.py open|open3|slap|heel|tip|rim|all [vel]      # -> docs/compare/<stroke>.png (gitignored): both drums
Rows: per drum, each take of the stroke (peak-normalised, as stored) then ours (vel 0.8, tuned to take A's head pitch, peak-normalised the same way).
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
from fit import ref_f1, write_code  # noqa: E402
from refs import load, ref_names  # noqa: E402

E = M.E


def stroke_audio(drum, stroke, vel=0.8):
    rows = []
    for take, n in ref_names(drum, stroke):
        sr, x = load(n)
        on = M.onset(x)
        rows.append((f"ref {take}", sr, x[max(0, on - int(0.002 * sr)):]))
    f1 = ref_f1(drum, ref_names(drum, stroke)[0][0])
    code = write_code(E.load_tables(), jitter=E.JITTER_DB)
    sr, y = M.render([(drum, E.STROKES.index(stroke), vel, 0.02)], 1.2, [f"tune={12 * np.log2(f1 / E.F1[drum]):.3f}"], code=code)
    on = M.onset(y)
    y = y[max(0, on - int(0.002 * sr)):]
    rows.append(("ours", sr, y / (np.abs(y).max() + 1e-12)))
    return rows


def main():
    stroke = sys.argv[1]
    vel = float(sys.argv[2]) if len(sys.argv) > 2 else 0.8
    for stroke in (E.STROKES if stroke == "all" else [stroke]):
        rows = []
        for drum in range(2):
            rows += [(E.DRUMS[drum][0] + " " + lab, sr, x) for lab, sr, x in stroke_audio(drum, stroke, vel)]
        fig, ax = plt.subplots(len(rows), 3, figsize=(15, 1.9 * len(rows)))
        for i, (lab, sr, x) in enumerate(rows):
            t = np.arange(len(x)) / sr * 1000
            a = ax[i]
            n = int(0.015 * sr)
            a[0].plot(t[:n], x[:n], lw=0.6)
            a[0].set_ylabel(lab)
            w = max(2, int(0.005 * sr))
            env = 20 * np.log10(np.sqrt(np.convolve(x ** 2, np.ones(w) / w, "same")) + 1e-6)
            m = t < 400
            a[1].plot(t[m], env[m], lw=0.8)
            a[1].set_ylim(-80, 0)
            a[1].grid(alpha=0.3)
            f, tt, S = spectrogram(x[:int(0.4 * sr)], sr, nperseg=256, noverlap=224)
            k = f < 8000
            a[2].pcolormesh(tt * 1000, f[k], 10 * np.log10(S[k] + 1e-14), vmin=-110, vmax=-30, shading="auto")
        ax[0][0].set_title("first 15 ms")
        ax[0][1].set_title("5 ms RMS, dB (0..400 ms)")
        ax[0][2].set_title("spectrogram, 0..8 kHz")
        out = os.path.join(HERE, "../docs/compare")
        os.makedirs(out, exist_ok=True)
        p = os.path.join(out, f"{stroke}.png")
        fig.tight_layout()
        fig.savefig(p, dpi=60)
        plt.close(fig)
        print(p)


if __name__ == "__main__":
    main()
