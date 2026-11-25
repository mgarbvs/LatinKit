"""measure.py -- what we compare between a recorded stroke and ours (used by fit.py and test_strokes.py).

Bands = the engine's modes: for each of the NM modes of a drum the window between the geometric midpoints to its neighbours (in Hz, sorted).
Head-mode windows are scaled by the recording's own head pitch (f1_take / F1[drum]): the takes are tuned 10-20 % apart; shell windows are in
absolute Hz. Per band, dB re the stroke's total:
  early[b]  band energy over the first 40 ms     ring[b]  per-sample band energy over 60..360 ms after the onset
and broadband: rise (10 % -> within 3 dB of the peak of the causal 0.5 ms RMS envelope, ms: the 1 ms envelope's highest bump is mode beating, not
the attack), t20 / t40 (the 5 ms RMS envelope falls this far below its peak, ms),
centroid (Hz, first 40 ms), crack (share of the first 40 ms energy above 1.5 kHz, dB re total); flatness() separately (2.5-9 kHz is noise in the
recordings and in ours: sinusoids there read -13..-25 dB).
"""
import json
import os
import subprocess
import sys
import tempfile

import numpy as np
from scipy.io import wavfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "../scripts"))
import timbales_engine as E  # noqa: E402

NM, NH = E.NM, E.NH


def layout(d):
    """[(lo, hi)] nominal Hz window of each mode of drum d"""
    f = [E.mode_freq(d, m) for m in range(NM)]
    order = sorted(range(NM), key=lambda m: f[m])
    w = [None] * NM
    for k, m in enumerate(order):
        lo = np.sqrt(f[m] * f[order[k - 1]]) if k else f[m] / 1.12
        hi = np.sqrt(f[m] * f[order[k + 1]]) if k < NM - 1 else f[m] * 1.25
        w[m] = (lo, hi)
    return w


def onset(x, thr=0.05):
    return int(np.argmax(np.abs(x) > thr * np.abs(x).max()))


def band_energy(seg, sr, d, f1take, nfft=1 << 15):
    s = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), nfft)) ** 2
    f = np.fft.rfftfreq(nfft, 1 / sr)
    sc = f1take / E.F1[d]
    e = []
    for m, (lo, hi) in enumerate(layout(d)):
        k = sc if m < NH else 1.0
        e.append(s[(f >= lo * k) & (f < hi * k)].sum())
    top = max(hi for _, hi in layout(d))
    return np.array(e), s[(f >= top) & (f < 12000)].sum(), s[(f >= 20) & (f < min(lo for lo, _ in layout(d)))].sum()


def profile(x, sr, d, f1take):
    on = onset(x)
    e1, hf1, lf1 = band_energy(x[on:on + int(0.04 * sr)], sr, d, f1take)
    tot = e1.sum() + hf1 + lf1
    r1, hfr, lfr = band_energy(x[on + int(0.06 * sr):on + int(0.36 * sr)], sr, d, f1take)
    nrm = int(0.3 * sr) / int(0.04 * sr)
    dd = lambda v: 10 * np.log10(np.maximum(v, 1e-20) / tot)  # noqa: E731
    return dict(early=dd(e1), ring=dd(r1 / nrm), hf=float(dd(hf1)), lf=float(dd(lf1)))


def broadband(x, sr):
    on = onset(x)
    w = max(2, int(sr * 0.005))
    env = np.sqrt(np.convolve(x ** 2, np.ones(w) / w, "same"))
    ed = 20 * np.log10(env + 1e-9)
    ip = int(np.argmax(ed[on:on + int(0.15 * sr)])) + on
    below = lambda l: (np.argmax(ed[ip:] < ed[ip] - l) / sr * 1000) if (ed[ip:] < ed[ip] - l).any() else float("nan")  # noqa: E731
    w1 = max(2, int(sr * 0.0005))
    e1 = np.sqrt(np.convolve(x ** 2, np.ones(w1) / w1, "full")[:len(x)])
    pk = e1[:on + int(0.1 * sr)].max()
    rise = (np.argmax(e1 > 10 ** (-3 / 20) * pk) - np.argmax(e1 > 0.1 * pk)) / sr * 1000
    seg = x[on:on + int(0.04 * sr)]
    nfft = 1 << 14
    s = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), nfft)) ** 2
    f = np.fft.rfftfreq(nfft, 1 / sr)
    m = f < 12000
    cent = float((s[m] * f[m]).sum() / s[m].sum())
    crack = 10 * np.log10(s[(f > 1500) & m].sum() / s[m].sum() + 1e-12)
    return dict(rise=rise, t20=below(20), t40=below(40), centroid=cent, crack=float(crack))


def flatness(x, sr, t0=0.005, t1=0.04, lo=2500, hi=9000):
    """mean spectral flatness (dB, 0 = white noise, -3 = a noise-like periodogram, below -10 = lines) of lo..hi Hz over t0..t1 s after the onset"""
    from scipy.signal import spectrogram
    on = onset(x)
    f, _, S = spectrogram(x[on + int(t0 * sr):on + int(t1 * sr)], sr, nperseg=512, noverlap=384)
    S = S[(f > lo) & (f < hi)] + 1e-18
    return float(np.mean(10 * np.log10(np.exp(np.log(S).mean(0)) / S.mean(0))))


def f1_of(x, sr, near, span=0.2):
    """strongest spectral peak (60..400 ms after the onset) within +-span of `near` Hz: the open tone as recorded"""
    on = onset(x)
    seg = x[on + int(0.06 * sr):on + int(0.4 * sr)]
    nfft = 1 << 17
    s = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), nfft))
    f = np.fft.rfftfreq(nfft, 1 / sr)
    m = (f > near * (1 - span)) & (f < near * (1 + span))
    return float(f[m][np.argmax(s[m])])


def render(hits, sec, params=(), code=None):
    """hits: [(drum, stroke, vel, t)] -> (sr, mono float array) from the Node shim. code: path of a .genexpr to render instead of the built maxpat"""
    with tempfile.TemporaryDirectory() as d:
        w = os.path.join(d, "o.wav")
        env = dict(os.environ)
        if code:
            env["TIMB_CODE"] = code
        r = subprocess.run(["node", os.path.join(HERE, "render_strokes.js"), w, ",".join(f"{a}:{b}:{v}@{t}" for a, b, v, t in hits), str(sec)] + list(params),
                           check=True, env=env, capture_output=True, text=True)
        sr, x = wavfile.read(w)
    render.peak = json.loads(r.stdout.strip().splitlines()[-1])["peak"]
    return sr, x.astype(float)
