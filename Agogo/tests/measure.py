"""measure.py -- what we compare between a recorded bell and ours (used by fit.py, test_strokes.py, compare.py). The same functions run on both.

  tonal (the bell's own ring):
    f0       the strongest spectral peak within +-12 % of the nominal fundamental, in a Hann window 0.1..0.7 s after the onset (0.6 s: 1.7 Hz bins)
    split    the doublet's beat: the envelope of the 70 Hz band around f0, its exponential decay removed, spectrum peak 3..40 Hz (a doublet of splitting D gives a
             ripple of D Hz; A High: 10 Hz here, 9.5 measured by hand); 6..40 Hz, over 0.05 s .. 0.8 T60 later (at most 0.65 s)
    t60      slope of the smoothed band energy (0.1 s boxcar: longer than the ripple) from 0.08 s to 30 dB down
  broadband (the first 40 ms and the attack):
    rise (10 % -> -3 dB of the 0.5 ms RMS envelope, first 8 ms), t20 / t40 (the 5 ms RMS envelope falls this far below its peak, ms), centroid (Hz, first 40 ms, to 12 kHz),
    blip (RMS of the first 1.1 ms over the peak of the first 10 ms: the stick tick before the tone); flatness() of 2.5-9 kHz (the recordings are lines, -10..-32 dB)
"""
import json
import os
import subprocess
import sys
import tempfile

import numpy as np
from scipy.io import wavfile
from scipy.signal import butter, hilbert, sosfilt, sosfiltfilt, spectrogram

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "../scripts"))
import agogo_engine as E  # noqa: E402


def onset(x, thr=0.05):
    return int(np.argmax(np.abs(x) > thr * np.abs(x).max()))


def f0_of(x, sr, near, on=None, span=0.12):
    on = onset(x) if on is None else on
    seg = x[on + int(0.1 * sr):on + int(0.7 * sr)]
    nfft = 1 << 19
    s = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), nfft))
    f = np.fft.rfftfreq(nfft, 1 / sr)
    m = (f > near * (1 - span)) & (f < near * (1 + span))
    return float(f[m][np.argmax(s[m])])


def tail_f(x, sr, f0, on=None):
    """the strongest peak within +-3 % of f0 in 0.3..0.8 s after the onset: where the long-lived partner of a doublet shows once the fundamental has died away"""
    on = onset(x) if on is None else on
    seg = x[on + int(0.3 * sr):on + int(0.8 * sr)]
    nfft = 1 << 19
    s = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), nfft))
    f = np.fft.rfftfreq(nfft, 1 / sr)
    m = (f > f0 * 0.97) & (f < f0 * 1.03)
    return float(f[m][np.argmax(s[m])])


def _band_env(x, sr, f0, on, half=35.0):
    sos = butter(4, [(f0 - half) / (sr / 2), (f0 + half) / (sr / 2)], "band", output="sos")
    return np.abs(hilbert(sosfiltfilt(sos, x)))[on:]


def split_of(x, sr, f0, on=None, t60=None):
    on = onset(x) if on is None else on
    env = _band_env(x, sr, f0, on)
    t60 = t60_of(x, sr, f0, on) if t60 is None else t60
    a, b = int(0.05 * sr), int((0.05 + min(0.65, 0.8 * t60)) * sr)       # the ring above the room floor: 0.05 s .. 0.8 T60 later
    t = np.arange(a, b) / sr
    e = env[a:b]
    p = np.polyfit(t, np.log(e + 1e-12), 1)
    r = e / np.exp(np.polyval(p, t)) - 1
    nfft = 1 << 16
    s = np.abs(np.fft.rfft((r - r.mean()) * np.hanning(len(r)), nfft))
    f = np.fft.rfftfreq(nfft, 1 / sr)
    m = (f > 6) & (f < 40)       # below ~6 Hz the window (0.4-0.65 s) cannot tell a doublet from the envelope's own wobble
    return float(f[m][np.argmax(s[m])])


def t60_of(x, sr, f0, on=None):
    on = onset(x) if on is None else on
    env = _band_env(x, sr, f0, on)
    w = int(0.1 * sr)
    e2 = np.convolve(env ** 2, np.ones(w) / w, "same")
    d = 10 * np.log10(e2 + 1e-18)
    i0 = int(0.08 * sr)
    pk = d[i0:i0 + int(0.2 * sr)].max()
    end = i0 + int(np.argmax(d[i0:] < pk - 30)) if (d[i0:] < pk - 30).any() else len(d) - w
    end = min(end, int(1.5 * sr))
    t = np.arange(i0, end) / sr
    slope = np.polyfit(t, d[i0:end], 1)[0]
    return float(-60 / slope)


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
    pk = e1[:on + int(0.008 * sr)].max()
    rise = (np.argmax(e1 > 10 ** (-3 / 20) * pk) - np.argmax(e1 > 0.1 * pk)) / sr * 1000
    seg = x[on:on + int(0.04 * sr)]
    nfft = 1 << 14
    s = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), nfft)) ** 2
    f = np.fft.rfftfreq(nfft, 1 / sr)
    m = f < 12000
    cent = float((s[m] * f[m]).sum() / s[m].sum())
    a, b = max(0, on - int(0.0003 * sr)), on + int(0.0008 * sr)
    blip = float(np.sqrt(np.mean(x[a:b] ** 2)) / (np.abs(x[on:on + int(0.01 * sr)]).max() + 1e-12))
    return dict(rise=rise, t20=below(20), t40=below(40), centroid=cent, blip=blip)


def flatness(x, sr, t0=0.005, t1=0.04, lo=2500, hi=9000, on=None):
    """mean spectral flatness (dB, 0 = white noise, -3 = noise-like, below -10 = lines) of lo..hi Hz over t0..t1 s after the onset"""
    on = onset(x) if on is None else on
    f, _, S = spectrogram(x[on + int(t0 * sr):on + int(t1 * sr)], sr, nperseg=512, noverlap=384)
    S = S[(f > lo) & (f < hi)] + 1e-18
    return float(np.mean(10 * np.log10(np.exp(np.log(S).mean(0)) / S.mean(0))))


def tonal(x, sr, near, on=None, span=0.12):
    on = onset(x) if on is None else on
    f0 = f0_of(x, sr, near, on, span)
    t60 = t60_of(x, sr, f0, on)
    return dict(f0=f0, split=split_of(x, sr, f0, on, t60), t60=t60, tail=tail_f(x, sr, f0, on))


def render(hits, sec, params=(), code=None):
    """hits: [(bell, stroke, vel, t)] -> (sr, mono float array) from the Node shim. code: path of a .genexpr to render instead of the built maxpat"""
    with tempfile.TemporaryDirectory() as d:
        w = os.path.join(d, "o.wav")
        env = dict(os.environ)
        if code:
            env["AGOGO_CODE"] = code
        r = subprocess.run(["node", os.path.join(HERE, "render_strokes.js"), w, ",".join(f"{a}:{b}:{v}@{t}" for a, b, v, t in hits), str(sec)] + list(params),
                           check=True, env=env, capture_output=True, text=True)
        sr, x = wavfile.read(w)
    render.peak = json.loads(r.stdout.strip().splitlines()[-1])["peak"]
    return sr, x.astype(float)
