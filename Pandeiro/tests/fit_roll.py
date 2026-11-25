"""fit_roll.py -- the kit's Roll envelope against the recording's: 50 ms RMS envelopes (dB re the whole roll's peak) of the full band, 150-900 Hz and 7-15 kHz at RT times from 0.05 to 1.7 s.
Fits the fade over the last taps (ROLL_FADE_N, ROLL_FADE_DB), the last tap's weight (ROLL_LAST) and how long its jingles ring (ROLL_JS_END) by Powell on the rms dB difference
(clipped at -80 dB, the mean of 3 rolls with different noise), after tests/fit.py roll has set ROLL_REL / ROLL_J. Prints the curves and the tap statistics; --write patches the constants.

    python3 tests/fit_roll.py [--write]
"""
import os
import re
import sys
import warnings

import numpy as np
from scipy.optimize import minimize
from scipy.signal import butter, find_peaks, sosfilt

warnings.filterwarnings("ignore")
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import fit  # noqa: E402
import measure as M  # noqa: E402
from refs import load, ROLL_REF  # noqa: E402

E = M.E
TS = [0.05, 0.1, 0.2, 0.4, 0.6, 0.8, 0.9, 1.0, 1.05, 1.1, 1.15, 1.2, 1.25, 1.3, 1.4, 1.5, 1.6, 1.7]
BANDS = {"all": (20, 20000), "lf": (150, 900), "hf": (7000, 15000)}
FLOOR = -80.0
CODE = os.path.join(HERE, "_t.roll.genexpr")


def curves(x, sr, on):
    w = int(0.05 * sr)
    out = {}
    for nm, (lo, hi) in BANDS.items():
        y = x if nm == "all" else sosfilt(butter(4, [lo / (sr / 2), min(hi, 0.45 * sr) / (sr / 2)], "band", output="sos"), x)
        out[nm] = np.sqrt(np.convolve(y ** 2, np.ones(w) / w, "same"))
    pk = out["all"][on:on + int(1.2 * sr)].max()
    return np.array([[20 * np.log10(out[nm][min(on + int(t * sr), len(x) - 1)] / pk + 1e-9) for t in TS] for nm in BANDS])


def taps(x, sr, on):
    """tap statistics of the 150-900 Hz envelope: the strongest 8-40 Hz line (rate), the level std (dB) of its peaks"""
    y = sosfilt(butter(4, [150 / (sr / 2), 900 / (sr / 2)], "band", output="sos"), x)
    e = np.sqrt(np.convolve(y ** 2, np.ones(int(0.004 * sr)) / int(0.004 * sr), "same"))[on + int(0.1 * sr):on + int(1.0 * sr)]
    pk, _ = find_peaks(e, distance=int(0.03 * sr), prominence=0.1 * e.max())
    return len(pk), float(np.std(20 * np.log10(e[pk] / e.max())))


def ours(n=3):
    open(CODE, "w").write(E.code(E.load_tables(), jitter=0))
    cs, ts = [], []
    for k in range(n):
        o, y = M.render([(0, E.ROLL, 0.8, 0.05 + 2.2 * k)], 2.2 * n + 0.1, [], code=CODE)
        seg = y[int(2.2 * k * o):int((2.2 * k + 2.1) * o)]
        on = M.onset(seg)
        cs.append(curves(seg, o, on))
        ts.append(taps(seg, o, on))
    return np.mean(cs, 0), np.mean(ts, 0)


def cost(c, ref):
    d = np.clip(c, FLOOR, 0) - np.clip(ref, FLOOR, 0)
    return float(np.sqrt(np.mean(d ** 2)))


def main():
    sr, x = load(ROLL_REF)
    on = M.onset(x)
    ref = curves(x, sr, on)
    rt = taps(x, sr, on)
    names = ["ROLL_FADE_N", "ROLL_FADE_DB", "ROLL_LAST", "ROLL_JS_END"]
    u0 = np.array([E.ROLL_FADE_N, E.ROLL_FADE_DB, np.log(E.ROLL_LAST), np.log(E.ROLL_JS_END)])

    def setv(u):
        E.ROLL_FADE_N, E.ROLL_FADE_DB, E.ROLL_LAST, E.ROLL_JS_END = int(round(u[0])), float(u[1]), float(np.exp(u[2])), float(np.exp(u[3]))

    def f(u):
        setv(u)
        return cost(ours(2)[0], ref)
    print(f"start: envelope error {f(u0):.1f} dB")
    res = minimize(f, u0, method="Powell", bounds=[(2, 12), (0, 30), (0, np.log(4)), (0, np.log(12))], options=dict(maxiter=4, xtol=0.05, ftol=1e-3))
    setv(res.x)
    c, tp = ours(3)
    print(f"fitted: {', '.join(f'{n} {getattr(E, n):.3g}' for n in names)}: envelope error {cost(c, ref):.1f} dB over {len(TS)} times x 3 bands")
    print("t (s)      " + " ".join(f"{t:5.2f}" for t in TS))
    for j, nm in enumerate(BANDS):
        print(f"ref {nm:3s}    " + " ".join(f"{v:5.0f}" for v in ref[j]) + f"\nours {nm:3s}   " + " ".join(f"{v:5.0f}" for v in c[j]))
    print(f"taps (150-900 Hz peaks / level std dB): recording {rt[0]:.0f} / {rt[1]:.1f}, ours {tp[0]:.0f} / {tp[1]:.1f}")
    if "--write" in sys.argv:
        p = os.path.join(HERE, "../scripts/pandeiro_engine.py")
        s = open(p).read()
        s = re.sub(r"^ROLL_JA, ROLL_JT, ROLL_FADE_N, ROLL_FADE_DB, ROLL_LAST, ROLL_JS_END = .*$",
                   f"ROLL_JA, ROLL_JT, ROLL_FADE_N, ROLL_FADE_DB, ROLL_LAST, ROLL_JS_END = {E.ROLL_JA}, {E.ROLL_JT}, {E.ROLL_FADE_N}, {E.ROLL_FADE_DB:.1f}, {E.ROLL_LAST:.2f}, {E.ROLL_JS_END:.2f}", s, flags=re.M)
        open(p, "w").write(s)
        print("patched", p)


if __name__ == "__main__":
    main()
