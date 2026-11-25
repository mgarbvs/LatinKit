"""measure.py -- what we compare between a recorded stroke and ours (used by fit.py and test_strokes.py). Forked from Bongo/tests/measure.py.

Bands = the engine's modes: for each of the NM modes of an instrument the window between the geometric midpoints to its neighbours (in Hz, sorted).
Head-mode windows are scaled by the recording's own head pitch (f1_take / F1[inst]); shell windows are in
absolute Hz. The jingles (Pandeiro) live above ~6 kHz: `jing` is the 6.5-16 kHz share of the first 40 ms; `hf` (above the top window up to 16 kHz) is in the total. Per band, dB re the stroke's total:
  blip: RMS of the first 1.1 ms (0.3 ms before the 5 % onset) over the peak of the first 10 ms: the contact tick that comes before the tone (0.2-0.4 in every recording)
  tone: ms from the onset until the below-1.5 kHz envelope reaches half its first-8 ms peak (when the tone starts, after the tick)
  early[b]  band energy over the first 40 ms     ring[b]  per-sample band energy over 60..360 ms after the onset
and broadband: rise (10 % -> within 3 dB of the peak of the causal 0.5 ms RMS envelope over the first 8 ms after the onset, ms: a later beat of the modes is not the attack), t20 / t40 (the 5 ms RMS envelope falls this far below its peak, ms),
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
import pandeiro_engine as E  # noqa: E402

NM, NH = E.NM, E.NH


def layout(d):
    """[(lo, hi)] nominal Hz window of each mode of instrument d"""
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
    return np.array(e), s[(f >= top) & (f < 16000)].sum(), s[(f >= 20) & (f < min(lo for lo, _ in layout(d)))].sum(), s[(f >= 6500) & (f < 16000)].sum()


def profile(x, sr, d, f1take):
    on = onset(x)
    e1, hf1, lf1, j1 = band_energy(x[on:on + int(0.04 * sr)], sr, d, f1take)
    tot = e1.sum() + hf1 + lf1
    r1, hfr, lfr, _ = band_energy(x[on + int(0.06 * sr):on + int(0.36 * sr)], sr, d, f1take)
    nrm = int(0.3 * sr) / int(0.04 * sr)
    dd = lambda v: 10 * np.log10(np.maximum(v, 1e-20) / tot)  # noqa: E731
    return dict(early=dd(e1), ring=dd(r1 / nrm), hf=float(dd(hf1)), lf=float(dd(lf1)), jing=float(dd(j1)))


def broadband(x, sr, on=None):
    """on: the onset sample if known (our own renders: the hit time; a recording's is found at 5 % of its peak)"""
    on = onset(x) if on is None else on
    w = max(2, int(sr * 0.005))
    env = np.sqrt(np.convolve(x ** 2, np.ones(w) / w, "same"))
    ed = 20 * np.log10(env + 1e-9)
    ip = int(np.argmax(ed[on:on + int(0.15 * sr)])) + on
    below = lambda l: (np.argmax(ed[ip:] < ed[ip] - l) / sr * 1000) if (ed[ip:] < ed[ip] - l).any() else float("nan")  # noqa: E731
    w1 = max(2, int(sr * 0.0005))
    e1 = np.sqrt(np.convolve(x ** 2, np.ones(w1) / w1, "full")[:len(x)])
    pk = e1[:on + int(0.008 * sr)].max()          # the first 8 ms: a later beat of the modes is not the attack
    rise = (np.argmax(e1 > 10 ** (-3 / 20) * pk) - np.argmax(e1 > 0.1 * pk)) / sr * 1000
    seg = x[on:on + int(0.04 * sr)]
    nfft = 1 << 14
    s = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), nfft)) ** 2
    f = np.fft.rfftfreq(nfft, 1 / sr)
    m = f < 12000
    cent = float((s[m] * f[m]).sum() / s[m].sum())
    crack = 10 * np.log10(s[(f > 1500) & m].sum() / s[m].sum() + 1e-12)
    a, b = max(0, on - int(0.0003 * sr)), on + int(0.0008 * sr)
    blip = float(np.sqrt(np.mean(x[a:b] ** 2)) / (np.abs(x[on:on + int(0.01 * sr)]).max() + 1e-12))
    from scipy.signal import butter, sosfilt
    lf = sosfilt(butter(2, 1500 / (sr / 2), "low", output="sos"), x)       # causal: no pre-ringing before the onset
    w3 = max(2, int(sr * 0.0003))
    el = np.sqrt(np.convolve(lf ** 2, np.ones(w3) / w3, "full")[:len(x)])
    tone = float((np.argmax(el[on:] > 0.5 * el[on:on + int(0.008 * sr)].max())) / sr * 1000)
    # the jingles' band (8-15.5 kHz): causal 3 ms RMS envelope: ms from the onset until the 5 ms envelope is within 4 dB of its first-150 ms peak, and from the 3 ms envelope's peak to 20 / 30 dB down
    hb = sosfilt(butter(4, [8000 / (sr / 2), min(15500, 0.45 * sr) / (sr / 2)], "band", output="sos"), x)
    w4 = max(2, int(sr * 0.003))
    w5 = max(2, int(sr * 0.005))
    eh5 = 20 * np.log10(np.sqrt(np.convolve(hb ** 2, np.ones(w5) / w5, "full")[:len(x)]) + 1e-9)
    eh = 20 * np.log10(np.sqrt(np.convolve(hb ** 2, np.ones(w4) / w4, "full")[:len(x)]) + 1e-9)
    ih = int(np.argmax(eh[on:on + int(0.15 * sr)])) + on
    p5 = float(eh5[on:on + int(0.15 * sr)].max())      # the envelope is a plateau for tens of ms (its argmax is noise): the first time the 5 ms envelope is within 4 dB of its peak
    hrise = float(np.argmax(eh5[on:] > p5 - 4) / sr * 1000)
    ht20 = float(np.argmax(eh[ih:] < eh[ih] - 20) / sr * 1000) if (eh[ih:] < eh[ih] - 20).any() else float("nan")
    ht30 = float(np.argmax(eh[ih:] < eh[ih] - 30) / sr * 1000) if (eh[ih:] < eh[ih] - 30).any() else float("nan")
    # the noise bands' own decay: the 2-5 kHz band (above the head modes, under the jingles), 3 ms RMS, peak (first 50 ms) to 20 dB down
    nb = sosfilt(butter(4, [2000 / (sr / 2), 5000 / (sr / 2)], "band", output="sos"), x)
    en_ = 20 * np.log10(np.sqrt(np.convolve(nb ** 2, np.ones(w4) / w4, "full")[:len(x)]) + 1e-9)
    inn = int(np.argmax(en_[on:on + int(0.05 * sr)])) + on
    nt20 = float(np.argmax(en_[inn:] < en_[inn] - 20) / sr * 1000) if (en_[inn:] < en_[inn] - 20).any() else float("nan")
    # the onset's build-up: ms from the onset until the causal 2 ms RMS envelope first reaches -20 / -10 dB re the peak of the 5 ms envelope in the first 60 ms (a Shake's jingles swell in over ~12 ms)
    w6 = max(2, int(sr * 0.002))
    e6 = 20 * np.log10(np.sqrt(np.convolve(x ** 2, np.ones(w6) / w6, "full")[:len(x)]) + 1e-9)
    p6 = float(ed[on:on + int(0.06 * sr)].max())
    on20 = float(np.argmax(e6[on:] > p6 - 20) / sr * 1000)
    on10 = float(np.argmax(e6[on:] > p6 - 10) / sr * 1000)
    return dict(rise=rise, on20=on20, on10=on10, t20=below(20), t40=below(40), centroid=cent, crack=float(crack), blip=blip, tone=tone, hrise=hrise, ht20=ht20, ht30=ht30, nt20=nt20)


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
    """hits: [(inst, menu stroke, vel, t)] -> (sr, mono float array) from the Node shim. code: path of a .genexpr to render instead of the built maxpat"""
    with tempfile.TemporaryDirectory() as d:
        w = os.path.join(d, "o.wav")
        env = dict(os.environ)
        if code:
            env["PANDEIRO_CODE"] = code
        r = subprocess.run(["node", os.path.join(HERE, "render_strokes.js"), w, ",".join(f"{a}:{b}:{v}@{t}" for a, b, v, t in hits), str(sec)] + list(params),
                           check=True, env=env, capture_output=True, text=True)
        sr, x = wavfile.read(w)
    render.peak = json.loads(r.stdout.strip().splitlines()[-1])["peak"]
    return sr, x.astype(float)
