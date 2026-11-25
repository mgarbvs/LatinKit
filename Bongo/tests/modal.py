"""modal.py -- matrix-pencil (Prony-family) fit of a drum hit: the damped sinusoids it is made of.
    modes(x, sr, t0, dur, order) -> [(f Hz, T60 s, level dB re strongest, at t0)] sorted by frequency
Decimates to ~4 kHz first (conga modes sit below ~1.8 kHz), so it says nothing about the slap's top end (see fit.py bands)."""
import numpy as np
from scipy.signal import decimate


def modes(x, sr, t0, dur=0.4, order=24, fmax=1800.0, minlvl=-35.0):
    q = max(1, int(sr // 4000))
    y = decimate(x, q, zero_phase=True) if q > 1 else x
    fs = sr / q
    y = y[int(t0 * fs):int((t0 + dur) * fs)]
    n = len(y)
    L = n // 2
    H = np.array([y[i:i + n - L] for i in range(L)])      # Hankel, L x (n-L)
    U, S, Vt = np.linalg.svd(H, full_matrices=False)
    Us = U[:, :order]
    A = np.linalg.lstsq(Us[:-1], Us[1:], rcond=None)[0]
    z = np.linalg.eigvals(A)
    z = z[np.abs(z) < 1.0]
    z = z[z.imag > 0]                                      # positive frequencies
    f = np.angle(z) * fs / (2 * np.pi)
    a = -np.log(np.abs(z)) * fs                            # 1/s
    keep = (f > 40) & (f < fmax) & (a > 0)
    z, f, a = z[keep], f[keep], a[keep]
    # amplitudes: least squares on the damped complex exponentials
    t = np.arange(n)
    V = np.array([zz ** t for zz in z]).T
    V2 = np.concatenate([V, V.conj()], 1)
    c = np.linalg.lstsq(V2, y.astype(complex), rcond=None)[0][:len(z)]
    amp = 2 * np.abs(c)
    out = [(fi, 6.9078 / ai, 20 * np.log10(am + 1e-12)) for fi, ai, am in zip(f, a, amp)]
    top = max(o[2] for o in out)
    out = [(fi, t6, lv - top) for fi, t6, lv in out if lv - top > minlvl]
    return sorted(out)
