"""tail.py -- the recordings' band-envelope curves against ours: per row, five bands (150-700, 700-2k, 2-5k, 5-10k, 10-16k Hz), each band's 5 ms RMS envelope in dB re the stroke's own
peak (the 5 ms RMS of the whole signal over the first 100 ms), read at TS ms after the onset. `curve_error` is the weighted rms dB difference over bands x times (values under FLOOR are
clipped: the recordings' room noise sits there); that is what tests/fit_tail.py minimises and what `fit.py report` prints as "tail".
    python3 tests/tail.py [code.genexpr] [row ...]     # the curves, recording above ours, per band
"""
import os
import sys
import warnings

import numpy as np
from scipy.signal import butter, sosfilt

warnings.filterwarnings("ignore")
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import measure as M  # noqa: E402
from refs import load, ref_names  # noqa: E402

E = M.E
BANDS = [(150, 700), (700, 2000), (2000, 5000), (5000, 10000), (10000, 16000)]
TS = [10, 15, 25, 40, 60, 80, 100, 125, 150, 200, 250, 300, 350, 400]
WT = np.array([1, 1, 1, 1, 1, 1, 1, 1, 1, 0.7, 0.5, 0.5, 0.4, 0.4])
FLOOR = -80.0
_SOS = {}


def _sos(sr):
    if sr not in _SOS:
        _SOS[sr] = [butter(4, [lo / (sr / 2), min(hi, 0.45 * sr) / (sr / 2)], "band", output="sos") for lo, hi in BANDS]
    return _SOS[sr]


def curves(x, sr, on):
    """(5, len(TS)) dB re the 5 ms total envelope's peak in the first 100 ms after `on`"""
    x = x[:on + int(0.45 * sr)]
    w = int(0.005 * sr)
    k = np.ones(w) / w
    pk = np.sqrt(np.convolve(x ** 2, k, "same"))[on:on + int(0.1 * sr)].max()
    out = []
    for sos in _sos(sr):
        e = np.sqrt(np.convolve(sosfilt(sos, x) ** 2, k, "same"))
        out.append([20 * np.log10(e[on + int(t / 1000 * sr)] / pk + 1e-9) for t in TS])
    return np.array(out)


_REF = {}


def ref_curves(row):
    if row not in _REF:
        r = []
        for _, n in ref_names(row):
            sr, x = load(n)
            r.append(curves(x, sr, M.onset(x)))
        _REF[row] = np.mean(r, 0)
    return _REF[row]


def our_curves(row, code, vel=0.8):
    i, m = E.ROW_MENU[row]
    sr, x = M.render([(i, m, vel, 0.05)], 0.6, [], code=code)
    return curves(x, sr, int(0.05 * sr))


def diff(a, b):
    return np.clip(a, FLOOR, 0) - np.clip(b, FLOOR, 0)


def curve_error(row, code=None, ours=None):
    c = our_curves(row, code) if ours is None else ours
    return float(np.sqrt(np.sum(WT * diff(c, ref_curves(row)) ** 2) / (len(BANDS) * WT.sum())))


if __name__ == "__main__":
    from fit import write_code
    a = [x for x in sys.argv[1:]]
    code = a.pop(0) if a and a[0].endswith(".genexpr") else write_code(E.load_tables())
    for k in a or E.KEYS:
        r = E.KEYS.index(k)
        ref, our = ref_curves(r), our_curves(r, code)
        print(f"\n== {k}   tail error {curve_error(r, ours=our):.1f} dB rms   t(ms): " + " ".join(f"{t:5d}" for t in TS))
        for j, (lo, hi) in enumerate(BANDS):
            print(f"  {lo:5d}-{hi:5d} ref " + " ".join(f"{v:5.0f}" for v in ref[j]) + "\n" + " " * 12 + "our " + " ".join(f"{v:5.0f}" for v in our[j]))
