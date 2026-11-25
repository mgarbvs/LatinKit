"""extract.py -- the modal table of one bell from its recording: damped sinusoids (f Hz, T60 s, level dB at the hit), doublets resolved.

    python3 tests/extract.py lp_Agogo_A_High        # prints the table
    extract(name, ns) -> (sr, x_from_onset, [(f, t60, level_dB)] sorted by f)

Low group (< LOW_MAX Hz): narrow-band matrix pencil (a complex baseband per spectral cluster, 0.03..0.93 s, order 3-5) -- it separates the partners of a doublet 10 Hz
apart, which a 40 ms FFT cannot. High group: the same on the first 150 ms from 3 ms in (those lines die in 10-200 ms), neighbours within MERGE_HZ merged into one
partial (power sum): above ~5 kHz the lines are denser than 60 Hz and no table of 12 could hold them one by one.
A wide-band pencil of high order was tried first and only fitted the noise (hundreds of 10-100 ms components above 5 kHz): not used.
"""
import sys

import numpy as np
from scipy.optimize import least_squares
from scipy.signal import butter, find_peaks, firwin, hilbert, lfilter, sosfiltfilt

sys.path.insert(0, __import__("os").path.dirname(__import__("os").path.abspath(__file__)))
from refs import load  # noqa: E402

LOW_MAX = 4500.0
MERGE_HZ = 60.0
N_LOW, N_HIGH = 12, 12
LN60 = 6.907755279


def onset(x, thr=0.05):
    return int(np.argmax(np.abs(x) > thr * np.abs(x).max()))


def band_modes(x, sr, t0, dur, lo, hi, order, refine=False):
    """matrix pencil on the complex baseband of lo..hi Hz -> [(f, T60, dB at t = 0)]; x starts at the hit"""
    fc, bw = 0.5 * (lo + hi), hi - lo
    n = np.arange(len(x))
    z = x * np.exp(-2j * np.pi * fc * n / sr)
    q = max(1, int(sr / (bw * 1.6)))
    h = firwin(255, bw * 0.55 / (sr / 2))
    y = np.roll(lfilter(h, 1, z), -127)[::q]
    fs = sr / q
    y = y[int(t0 * fs):int((t0 + dur) * fs)]
    N = len(y)
    L = N // 2
    if L < order + 2:
        return []
    H = np.array([y[i:i + N - L] for i in range(L)])
    U, S, _ = np.linalg.svd(H, full_matrices=False)
    k = max(1, min(order, int((S > S[0] * 10 ** (-60 / 20)).sum())))
    Us = U[:, :k]
    zz = np.linalg.eigvals(np.linalg.lstsq(Us[:-1], Us[1:], rcond=None)[0])
    zz = zz[np.abs(zz) < 1.0]
    f = np.angle(zz) * fs / (2 * np.pi) + fc
    a = -np.log(np.abs(zz)) * fs
    keep = (a > 0) & (f >= lo + 0.05 * bw) & (f < hi - 0.05 * bw) & (LN60 / a < 4) & (LN60 / a > 0.004)
    zz, f, a = zz[keep], f[keep], a[keep]
    if not len(zz):
        return []
    t = np.arange(N) / fs
    if refine:        # the low group: only partners that ring (a short-lived component here is the stick's transient, the tick's job)
        c0 = np.linalg.lstsq(np.array([w ** np.arange(N) for w in zz]).T, y, rcond=None)[0]
        ok = (LN60 / a >= 0.08) & (np.abs(c0) >= np.abs(c0).max() * 10 ** (-45 / 20))
        zz, f, a = zz[ok], f[ok], a[ok]
        if not len(zz):
            return []
    if refine:        # variable projection: f and decay of each partner by non-linear least squares, amplitudes linear
        def res(p):
            kk = len(p) // 2
            V = np.exp((-p[None, kk:] + 2j * np.pi * (p[None, :kk] - fc)) * t[:, None])
            r = y - V @ np.linalg.lstsq(V, y, rcond=None)[0]
            return np.concatenate([r.real, r.imag])
        p0 = np.concatenate([f, a])
        kk = len(f)
        s = least_squares(res, p0, bounds=(np.concatenate([f - 5, a / 1.6]), np.concatenate([f + 5, a * 1.6])))
        f, a = s.x[:kk], s.x[kk:]
        zz = np.exp((-a + 2j * np.pi * (f - fc)) / fs)
    V = np.array([w ** np.arange(N) for w in zz]).T
    c = np.linalg.lstsq(V, y, rcond=None)[0]
    amp = np.abs(c) * 2 / np.sum(h)
    return [(fi, LN60 / ai, 20 * np.log10(am + 1e-12) + 8.686 * ai * t0) for fi, ai, am in zip(f, a, amp)]


def spec_peaks(x, sr, a, b, prom=7, floor=-55, fmin=300, fmax=11000):
    seg = x[int(a * sr):int(b * sr)]
    N = 1 << 16
    s = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), N))
    f = np.fft.rfftfreq(N, 1 / sr)
    d = 20 * np.log10(s / s.max() + 1e-12)
    p, _ = find_peaks(np.where((f > fmin) & (f < fmax), d, -300), height=floor, distance=int(15 / f[1]), prominence=prom)
    return f[p]


def clusters(pk, gap=70):
    cl = []
    for f in sorted(pk):
        if cl and f - cl[-1][-1] < gap:
            cl[-1].append(f)
        else:
            cl.append([f])
    return cl


def merge(ms, hz):
    """modes within hz of the previous one -> one (power-sum level, amplitude-weighted f and T60)"""
    out = []
    for f, t, l in sorted(ms):
        if out and f - out[-1][0] < hz:
            f0, t0_, l0 = out[-1]
            a0, a1 = 10 ** (l0 / 20), 10 ** (l / 20)
            out[-1] = ((f0 * a0 + f * a1) / (a0 + a1), (t0_ * a0 + t * a1) / (a0 + a1), 10 * np.log10(a0 ** 2 + a1 ** 2))
        else:
            out.append((f, t, l))
    return out


def refit_high(x, sr, hs):
    """the highs' T60 and level from the decay of each partial's own band (+-half the gap to its neighbours, at most 60 Hz): a merged line's pencil T60 was a mean of
    components of 10-200 ms, and the recordings' highs ring about twice as long as that gave. Level = the amplitude whose first-40-ms energy equals the band's (the regression's intercept over-read a click that dies in ms)."""
    out = []
    for i, (f, t, l) in enumerate(hs):
        half = min(60.0, 0.5 * min([abs(f - g[0]) for j, g in enumerate(hs) if j != i] + [120.0]))
        sos = butter(4, [(f - half) / (sr / 2), (f + half) / (sr / 2)], "band", output="sos")
        env = np.abs(hilbert(sosfiltfilt(sos, x[:int(0.6 * sr)])))
        w = int(0.006 * sr)
        d = 10 * np.log10(np.convolve(env ** 2, np.ones(w) / w, "same") + 1e-18)
        i0 = int(0.004 * sr)
        pk = d[i0:i0 + int(0.03 * sr)].max()
        end = i0 + int(np.argmax(d[i0:] < pk - 25)) if (d[i0:] < pk - 25).any() else len(d) - w
        end = max(end, i0 + int(0.01 * sr))
        tt = np.arange(i0, end) / sr
        sl, ic = np.polyfit(tt, d[i0:end], 1)
        t60 = float(np.clip(-60 / sl, 0.015, 1.0))
        a = LN60 / t60
        e_rec = np.sum(env[:int(0.04 * sr)] ** 2 / 2) / sr                    # the band's energy in the first 40 ms, from the recording
        e_unit = 0.5 * (1 - np.exp(-2 * a * 0.04)) / (2 * a)                  # that of a partial of amplitude 1 and this T60
        out.append((f, t60, 20 * np.log10(np.sqrt(e_rec / e_unit) + 1e-12)))
    return out


def energy(m, span=3.0):
    f, t, l = m
    return 10 ** (l / 10) * min(t, span)


def extract(name, ns=N_LOW + N_HIGH):
    sr, x = load(name)
    x = x[onset(x):]
    low_pk = [f for a, b in ((0.03, 0.2), (0.2, 0.8)) for f in spec_peaks(x, sr, a, b) if 700 < f < LOW_MAX]
    high_pk = [f for f in spec_peaks(x, sr, 0.003, 0.05, prom=6, floor=-50, fmin=LOW_MAX) if f >= LOW_MAX]
    low, high = [], []
    for c in clusters(low_pk):
        lo, hi = max(200, min(c) - 60), max(c) + 60
        if hi - lo < 150:
            m = 0.5 * (lo + hi)
            lo, hi = m - 75, m + 75
        low += band_modes(x, sr, 0.03, 0.9, lo, hi, int(np.clip(2 * len(c) + 1, 3, 5)), refine=True)
    for c in clusters(high_pk, 150):
        lo, hi = min(c) - 100, max(c) + 100
        high += band_modes(x, sr, 0.003, 0.15, lo, hi, 6)
    low = [m for m in merge(low, 3.0) if m[1] >= 0.08]
    top = sorted(m[2] for m in low)[-2]        # (a refit that lands above the second strongest is a transient the pencil mistook for a partner: dropped below)
    low = [m for m in low if top - 50 < m[2] <= top + 12]
    low = sorted(sorted(low, key=lambda m: -energy(m))[:N_LOW])
    high = merge(high, MERGE_HZ)
    htop = max(m[2] for m in high)
    high = [m for m in high if m[2] > htop - 40]
    high = sorted(sorted(high, key=lambda m: -(10 ** (m[2] / 10)) * min(m[1], 0.05))[:N_HIGH])
    high = refit_high(x, sr, high)
    return sr, x, low + high


if __name__ == "__main__":
    sr, x, m = extract(sys.argv[1])
    for f, t, l in m:
        print(f"{f:8.1f}  T60 {t:5.2f}  {l:6.1f} dB")
