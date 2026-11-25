"""compare.py -- plot the recording against ours, per bell: first 15 ms (waveform), 0..2 s (5 ms RMS, dB), spectrogram 0..11 kHz over 0..2 s.

    python3 tests/compare.py [vel]      # -> docs/compare/high.png, low.png (gitignored)
Rows per bell: the recording (kit A, peak-normalised, as stored), ours Open and ours Mute (vel 0.8, peak-normalised the same way; there is no recording of a mute).
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
from refs import FIT, load  # noqa: E402

E = M.E


def rows_of(bell, vel):
    sr, x = load(FIT[bell])
    on = M.onset(x)
    rows = [("recording A", sr, x[max(0, on - int(0.002 * sr)):])]
    code = write_code(E.load_tables(), jitter=E.JITTER_DB)
    for s, lab in ((0, "ours Open"), (1, "ours Mute")):
        sr2, y = M.render([(bell, s, vel, 0.02)], 2.2, [], code=code)
        on = M.onset(y)
        y = y[max(0, on - int(0.002 * sr2)):]
        rows.append((lab, sr2, y / (np.abs(y).max() + 1e-12)))
    return rows


def main():
    vel = float(sys.argv[1]) if len(sys.argv) > 1 else 0.8
    for bell in range(2):
        rows = rows_of(bell, vel)
        fig, ax = plt.subplots(len(rows), 3, figsize=(15, 2.2 * len(rows)))
        for i, (lab, sr, x) in enumerate(rows):
            t = np.arange(len(x)) / sr * 1000
            a = ax[i]
            n = int(0.015 * sr)
            a[0].plot(t[:n], x[:n], lw=0.6)
            a[0].set_ylabel(f"{E.BELLS[bell]} {lab}")
            w = max(2, int(0.005 * sr))
            env = 20 * np.log10(np.sqrt(np.convolve(x ** 2, np.ones(w) / w, "same")) + 1e-6)
            m = t < 2000
            a[1].plot(t[m], env[m], lw=0.8)
            a[1].set_ylim(-90, 0)
            a[1].grid(alpha=0.3)
            f, tt, S = spectrogram(x[:int(2.0 * sr)], sr, nperseg=1024, noverlap=896)
            k = f < 11000
            a[2].pcolormesh(tt * 1000, f[k], 10 * np.log10(S[k] + 1e-14), vmin=-120, vmax=-40, shading="auto")
        ax[0][0].set_title("first 15 ms")
        ax[0][1].set_title("5 ms RMS, dB (0..2 s)")
        ax[0][2].set_title("spectrogram, 0..11 kHz")
        out = os.path.join(HERE, "../docs/compare")
        os.makedirs(out, exist_ok=True)
        p = os.path.join(out, f"{E.BELLS[bell].lower()}.png")
        fig.tight_layout()
        fig.savefig(p, dpi=55)
        plt.close(fig)
        print(p)


if __name__ == "__main__":
    main()
