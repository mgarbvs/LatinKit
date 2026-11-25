"""measure.py -- what we compare between a recorded stroke and ours (used by fit.py and test_strokes.py).

A stroke is described in frequency relative to its drum's open tone f1 (u = f / f1), in the bands the engine's modes sit in:
  early[b]  band energy over the first 40 ms, dB re the stroke's total early energy (attack + all modes)
  ring[b]   band energy over 60..360 ms after the onset, dB re the same total
  t60[b]    decay time of that band's energy (s), regression over its STFT track
and broadband: attack (10 % -> peak of the 1 ms envelope, ms), t20 / t40 (the 5 ms RMS envelope falls this far below its peak, ms),
centroid (Hz, first 40 ms), crack (share of the first 40 ms energy above 1.5 kHz, dB re total).
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
import conga_engine as E  # noqa: E402

U = [m[0] for m in E.MODES]
EDGES = [U[0] / 1.2] + [np.sqrt(U[i] * U[i + 1]) for i in range(len(U) - 1)] + [U[-1] * 1.25]
NB = len(U)


def onset(x, thr=0.05):
    return int(np.argmax(np.abs(x) > thr * np.abs(x).max()))


def band_energy(seg, sr, f1, nfft=1 << 15):
    s = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), nfft)) ** 2
    f = np.fft.rfftfreq(nfft, 1 / sr)
    e = np.array([s[(f >= f1 * EDGES[b]) & (f < f1 * EDGES[b + 1])].sum() for b in range(NB)])
    hf = s[(f >= f1 * EDGES[-1]) & (f < 12000)].sum()
    lf = s[(f >= 20) & (f < f1 * EDGES[0])].sum()
    return e, hf, lf


def t60_bands(x, sr, f1, t0, win=1024, hop=256):
    """per band: decay time (s) of the band energy after t0 (regression of dB over the STFT track while within 40 dB of its peak)"""
    w = np.hanning(win)
    fr = np.fft.rfftfreq(win * 4, 1 / sr)
    n0 = int(t0 * sr)
    tracks = []
    ts = []
    for i in range(n0, min(len(x) - win, n0 + int(1.2 * sr)), hop):
        s = np.abs(np.fft.rfft(x[i:i + win] * w, win * 4)) ** 2
        tracks.append([s[(fr >= f1 * EDGES[b]) & (fr < f1 * EDGES[b + 1])].sum() for b in range(NB)])
        ts.append(i / sr)
    tr = 10 * np.log10(np.array(tracks) + 1e-20)
    ts = np.array(ts)
    out = []
    for b in range(NB):
        y = tr[:, b]
        pk = int(np.argmax(y[:max(3, len(y) // 3)]))
        ok = np.where(y[pk:] > y[pk] - 40)[0]
        n = ok[-1] + 1 if len(ok) else 0
        n = min(n, len(y) - pk)
        if n < 4:
            out.append(float("nan"))
            continue
        slope = np.polyfit(ts[pk:pk + n], y[pk:pk + n], 1)[0]   # dB / s
        out.append(float(np.clip(-60.0 / slope, 0.01, 3.0)) if slope < -1 else 3.0)
    return np.array(out)


def profile(x, sr, f1):
    on = onset(x)
    e1, hf1, lf1 = band_energy(x[on:on + int(0.04 * sr)], sr, f1)
    tot = e1.sum() + hf1 + lf1
    r1, hfr, lfr = band_energy(x[on + int(0.06 * sr):on + int(0.36 * sr)], sr, f1)
    nrm = int(0.3 * sr) / int(0.04 * sr)     # a longer window holds more samples: per-sample power
    d = lambda v: 10 * np.log10(np.maximum(v, 1e-20) / tot)  # noqa: E731
    return dict(early=d(e1), ring=d(r1 / nrm), hf=float(d(hf1)), lf=float(d(lf1)), t60=t60_bands(x, sr, f1, on / sr + 0.01))


def broadband(x, sr):
    on = onset(x)
    w = max(2, int(sr * 0.005))
    env = np.sqrt(np.convolve(x ** 2, np.ones(w) / w, "same"))
    ed = 20 * np.log10(env + 1e-9)
    ip = int(np.argmax(ed[on:on + int(0.15 * sr)])) + on
    below = lambda l: (np.argmax(ed[ip:] < ed[ip] - l) / sr * 1000) if (ed[ip:] < ed[ip] - l).any() else float("nan")  # noqa: E731
    w1 = max(2, int(sr * 0.001))
    e1 = np.sqrt(np.convolve(x ** 2, np.ones(w1) / w1, "same"))
    pk = e1[on:on + int(0.1 * sr)].max()
    a0 = int(np.argmax(e1[on:] > 0.1 * pk)) + on
    a1 = int(np.argmax(e1[on:on + int(0.1 * sr)])) + on
    seg = x[on:on + int(0.04 * sr)]
    nfft = 1 << 14
    s = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), nfft)) ** 2
    f = np.fft.rfftfreq(nfft, 1 / sr)
    m = f < 12000
    cent = float((s[m] * f[m]).sum() / s[m].sum())
    crack = 10 * np.log10(s[(f > 1500) & m].sum() / s[m].sum() + 1e-12)
    return dict(attack=(a1 - a0) / sr * 1000, t20=below(20), t40=below(40), centroid=cent, crack=float(crack))


def f1_of(x, sr, near, span=0.18):
    """strongest spectral peak (60..400 ms after the onset) within +-span of `near` Hz: the open tone as recorded"""
    on = onset(x)
    seg = x[on + int(0.06 * sr):on + int(0.4 * sr)]
    nfft = 1 << 17
    s = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), nfft))
    f = np.fft.rfftfreq(nfft, 1 / sr)
    m = (f > near * (1 - span)) & (f < near * (1 + span))
    return float(f[m][np.argmax(s[m])])


def render(hits, sec, params=(), code=None):
    """hits: [(slot, vel, t)] -> (sr, mono float array) from the Node shim. code: path of a .genexpr to render instead of the built maxpat"""
    with tempfile.TemporaryDirectory() as d:
        w = os.path.join(d, "o.wav")
        env = dict(os.environ)
        if code:
            env["CONGA_CODE"] = code
        r = subprocess.run(["node", os.path.join(HERE, "render_strokes.js"), w, ",".join(f"{s}:{v}@{t}" for s, v, t in hits), str(sec)] + list(params),
                           check=True, env=env, capture_output=True, text=True)
        sr, x = wavfile.read(w)
    render.peak = json.loads(r.stdout.strip().splitlines()[-1])["peak"]   # of the stereo outputs (the WAV is their mean)
    return sr, x.astype(float)
