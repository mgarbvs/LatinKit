"""measure.py -- what we compare between a recorded stroke and ours (used by fit.py and test_strokes.py).

Bands = the engine's modes: for each of the NM modes the window between the geometric midpoints to its neighbours (in Hz, sorted). Per band, dB re the stroke's total:
  early[b]  band energy over the first EARLY s after the onset (0.12 s: 8 Hz resolution, enough to tell 73 / 86 / 103 Hz apart; Bongo's 40 ms was 25 Hz)
  ring[b]   per-sample band energy over RING (0.2..0.7 s) after the onset
and broadband: rise (10 % -> within 3 dB of the peak of the causal 3 ms RMS envelope over the first 30 ms, ms; an 86 Hz tone has a 12 ms period, so the 0.5 ms / 8 ms envelope Bongo used
sees less than one cycle), t20 / t40 (the 5 ms RMS envelope falls this far below its peak, ms), centroid (Hz, first 40 ms), crack (share of the first 40 ms energy above 1.5 kHz, dB re total),
blip (RMS of the first 1.1 ms over the peak of the first 10 ms: the contact tick), tone (ms until the below-400 Hz 2 ms envelope reaches half its first-30 ms peak: when the head's tone starts);
flatness() separately (2.5-9 kHz is noise in Mute / Rim / Finger and in ours: sinusoids there read -13..-25 dB).
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
import repinique_engine as E  # noqa: E402

NM, NH = E.NM, E.NH
EARLY = 0.12
RING = (0.2, 0.7)
SPACE = 2.0         # s between hits in our renders: the Open rings 0.9 s


def layout():
    """[(lo, hi)] nominal Hz window of each mode"""
    f = [E.mode_freq(m) for m in range(NM)]
    order = sorted(range(NM), key=lambda m: f[m])
    w = [None] * NM
    for k, m in enumerate(order):
        lo = np.sqrt(f[m] * f[order[k - 1]]) if k else f[m] / 1.12
        hi = np.sqrt(f[m] * f[order[k + 1]]) if k < NM - 1 else f[m] * 1.25
        w[m] = (lo, hi)
    return w


def onset(x, thr=0.05):
    return int(np.argmax(np.abs(x) > thr * np.abs(x).max()))


def band_energy(seg, sr, nfft=1 << 16):
    s = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), nfft)) ** 2
    f = np.fft.rfftfreq(nfft, 1 / sr)
    e = [s[(f >= lo) & (f < hi)].sum() for lo, hi in layout()]
    top = max(hi for _, hi in layout())
    return np.array(e), s[(f >= top) & (f < 12000)].sum(), s[(f >= 15) & (f < min(lo for lo, _ in layout()))].sum()


def profile(x, sr):
    on = onset(x)
    e1, hf1, lf1 = band_energy(x[on:on + int(EARLY * sr)], sr)
    tot = e1.sum() + hf1 + lf1
    r1, hfr, lfr = band_energy(x[on + int(RING[0] * sr):on + int(RING[1] * sr)], sr)
    nrm = (RING[1] - RING[0]) / EARLY
    dd = lambda v: 10 * np.log10(np.maximum(v, 1e-20) / tot)  # noqa: E731
    return dict(early=dd(e1), ring=dd(r1 / nrm), hf=float(dd(hf1)), lf=float(dd(lf1)))


def broadband(x, sr, on=None):
    """on: the onset sample if known (our own renders: the hit time; a recording's is found at 5 % of its peak)"""
    from scipy.signal import butter, sosfilt
    on = onset(x) if on is None else on
    w = max(2, int(sr * 0.005))
    env = np.sqrt(np.convolve(x ** 2, np.ones(w) / w, "same"))
    ed = 20 * np.log10(env + 1e-9)
    ip = int(np.argmax(ed[on:on + int(0.15 * sr)])) + on
    below = lambda l: (np.argmax(ed[ip:] < ed[ip] - l) / sr * 1000) if (ed[ip:] < ed[ip] - l).any() else float("nan")  # noqa: E731
    w1 = max(2, int(sr * 0.003))
    e1 = np.sqrt(np.convolve(x ** 2, np.ones(w1) / w1, "full")[:len(x)])
    pk = e1[:on + int(0.03 * sr)].max()
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
    lf = sosfilt(butter(2, 400 / (sr / 2), "low", output="sos"), x)       # causal: no pre-ringing before the onset
    w3 = max(2, int(sr * 0.002))
    el = np.sqrt(np.convolve(lf ** 2, np.ones(w3) / w3, "full")[:len(x)])
    tone = float((np.argmax(el[on:] > 0.5 * el[on:on + int(0.03 * sr)].max())) / sr * 1000)
    return dict(rise=rise, t20=below(20), t40=below(40), centroid=cent, crack=float(crack), blip=blip, tone=tone)


def flatness(x, sr, t0=0.005, t1=0.04, lo=2500, hi=9000):
    """mean spectral flatness (dB, 0 = white noise, -3 = a noise-like periodogram, below -10 = lines) of lo..hi Hz over t0..t1 s after the onset"""
    from scipy.signal import spectrogram
    on = onset(x)
    f, _, S = spectrogram(x[on + int(t0 * sr):on + int(t1 * sr)], sr, nperseg=512, noverlap=384)
    S = S[(f > lo) & (f < hi)] + 1e-18
    return float(np.mean(10 * np.log10(np.exp(np.log(S).mean(0)) / S.mean(0))))


def hf_level(x, sr, lo=2500, hi=9000):
    """energy of lo..hi Hz in the first 40 ms, dB re the 15 Hz..12 kHz total: how much of the spectrum the flatness is about"""
    on = onset(x)
    seg = x[on:on + int(0.04 * sr)]
    s = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), 1 << 14)) ** 2
    f = np.fft.rfftfreq(1 << 14, 1 / sr)
    return float(10 * np.log10(s[(f > lo) & (f < hi)].sum() / s[(f > 15) & (f < 12000)].sum() + 1e-20))


def pitch(x, sr, t0, t1, lo=70, hi=105, on=None):
    """mean instantaneous frequency (Hz) of the lo..hi band between t0 and t1 s after the onset, weighted by amplitude^2 (the open tone's glide)"""
    from scipy.signal import butter, hilbert, sosfiltfilt
    on = onset(x) if on is None else on
    y = sosfiltfilt(butter(4, [lo, hi], "band", fs=sr, output="sos"), x)
    a = hilbert(y)
    i0, i1 = on + int(t0 * sr), on + int(t1 * sr)
    ph = np.unwrap(np.angle(a))
    return float(np.polyfit(np.arange(i0, i1) / sr, ph[i0:i1], 1)[0] / 2 / np.pi)


def render(hits, sec, params=(), code=None):
    """hits: [(stroke, vel, t)] -> (sr, mono float array) from the Node shim. code: path of a .genexpr to render instead of the built maxpat"""
    with tempfile.TemporaryDirectory() as d:
        w = os.path.join(d, "o.wav")
        env = dict(os.environ)
        if code:
            env["REPINIQUE_CODE"] = code
        r = subprocess.run(["node", os.path.join(HERE, "render_strokes.js"), w, ",".join(f"{a}:{v}@{t}" for a, v, t in hits), str(sec)] + list(params),
                           check=True, env=env, capture_output=True, text=True)
        sr, x = wavfile.read(w)
    render.peak = json.loads(r.stdout.strip().splitlines()[-1])["peak"]
    return sr, x.astype(float)
