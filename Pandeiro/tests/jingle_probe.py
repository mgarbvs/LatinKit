"""jingle_probe.py -- what the recordings say about the jingles and the roll, before any modelling (docs/SPEC.md quotes these numbers):
    python3 tests/jingle_probe.py
 1. the Roll: modulation lines of its band envelopes (LF taps at 18.2 Hz, the jingles' own envelope has none), length
 2. tamborim take scale (A against B): the scale that best aligns their pooled log spectra
 3. flatness of the jingle band (6-14 kHz, 5-100 ms): noise grains, not lines
 4. metallic resonances: peaks of the 3-16 kHz long-term spectrum that recur (+-1.5 %) in several clips, and, separately, the narrow bands that RING (late / early energy)
    across the Thumb / Rim / Finger / Slap tails. Cross-check on the jingle tambourine clips (Tmbourin Hit / Shake, out of scope; named so).
 5. grain density: peaks per second of the 0.5 ms envelope of 8-15 kHz (Roll, Shake, tambourine Shake) - ours is the cvE of tests/jingle_fit.js
"""
import glob
import os
import sys

import numpy as np
from scipy.ndimage import gaussian_filter1d, uniform_filter1d
from scipy.signal import butter, find_peaks, sosfilt, welch

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import measure as M  # noqa: E402
from refs import load, ref_names, ROLL_REF  # noqa: E402


def env(y, sr, ms):
    w = max(2, int(sr * ms / 1000))
    return np.sqrt(np.convolve(y ** 2, np.ones(w) / w, "same"))


def band(x, sr, lo, hi):
    return sosfilt(butter(4, [lo / (sr / 2), min(hi, 0.45 * sr) / (sr / 2)], "band", output="sos"), x)


def lines(e, sr, t0, t1, n=3, lo=3, hi=80):
    e = e[int(t0 * sr):int(t1 * sr)]
    e = e - e.mean()
    sp = np.abs(np.fft.rfft(e * np.hanning(len(e)), 1 << 16))
    fr = np.fft.rfftfreq(1 << 16, 1 / sr)
    m = (fr > lo) & (fr < hi)
    pk, _ = find_peaks(sp[m], distance=30)
    top = sorted(pk, key=lambda i: -sp[m][i])[:n]
    return [(round(float(fr[m][i]), 1), round(float(sp[m][i] / sp[m].max()), 2)) for i in top]


print("== 1. Roll")
sr, x = load(ROLL_REF)
for nm, lo, hi in (("150-900 Hz", 150, 900), ("1-4 kHz", 1000, 4000), ("7-15 kHz", 7000, 15000)):
    print(f"  {nm}: strongest envelope-modulation lines (Hz, relative) over 0.1-1.1 s: {lines(env(band(x, sr, lo, hi), sr, 2), sr, 0.1, 1.1)}")
print(f"  length (5 ms envelope within 30 dB of the peak): {M.onset(x) / sr + np.where(20 * np.log10(env(x, sr, 5) / env(x, sr, 5).max() + 1e-9) > -30)[0][-1] / sr:.2f} s")

print("== 2. tamborim take scale")
def pooled(names):
    g = np.geomspace(300, 2500, 2000)
    acc = 0
    for n in names:
        sr, x = load(n)
        on = M.onset(x)
        seg = x[on + int(0.03 * sr):on + int(0.35 * sr)]
        s = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), 1 << 17)) ** 2
        f = np.fft.rfftfreq(1 << 17, 1 / sr)
        acc = acc + 10 * np.log10(gaussian_filter1d(np.interp(g, f, s), 6) / s.max() + 1e-12)
    return g, acc / len(names)
g, a = pooled([f"lp_Tmbourim_A_{k}" for k in ("Open", "Mute", "Finger")])
_, b = pooled([f"lp_Tmbourim_B_{k}" for k in ("Open", "Mute", "Finger")])
best = max(((np.corrcoef(a, np.interp(g, g * sc, b))[0, 1], sc) for sc in np.linspace(0.85, 1.2, 141)))
print(f"  B against A: scale {best[1]:.3f} (correlation {best[0]:.2f}); pooled strongest peaks A {g[np.argmax(a)]:.0f} Hz, B {g[np.argmax(b)]:.0f} Hz")

print("== 3. flatness 6-14 kHz, 5-100 ms (0 dB = white noise, below -10 = lines)")
for n in [q for _, q in sum((ref_names(r) for r in range(5)), [])] + [ROLL_REF]:
    sr, x = load(n)
    print(f"  {n[3:]:22s} {M.flatness(x, sr, 0.005, 0.1, 6000, 14000):6.1f} dB")

print("== 4. resonances")
def ltas(n, t0, t1, nper=2048):
    sr, x = load(n)
    on = M.onset(x)
    f, P = welch(x[on + int(t0 * sr):on + int(t1 * sr)], sr, nperseg=nper, noverlap=nper * 3 // 4)
    return f, P
def peaks_of(n, t0, t1, nper=4096, thr=3.0):
    """peaks of the long-term spectrum (3-16 kHz) that stand >= thr dB over its 250 Hz mean; with ~40 averages the estimate's std is ~0.7 dB, so 3 dB is > 4 sigma"""
    f, P = ltas(n, t0, t1, nper)
    m = (f > 3000) & (f < 16000)
    l = 10 * np.log10(P[m] + 1e-20)
    base = gaussian_filter1d(l, 250 / (f[1] - f[0]))
    pk, _ = find_peaks(l - base, height=thr, distance=5)
    return f[m][pk], (l - base)[pk]
rf, rv = peaks_of(ROLL_REF, 0.15, 1.05)
print(f"  Pandeiro Roll (steady, 0.15-1.05 s, ~40 averages): {len(rf)} peaks >= 3 dB over the local mean in 3-16 kHz, one every {(rf[-1] - rf[0]) / len(rf):.0f} Hz on average: " + ", ".join(f"{a:.0f}" for a in rf))
print("  -> a peak list cannot name resonances: the peaks are dense (a +-1.5 % window at 10 kHz is 300 Hz wide), so 'recurs in the tambourine clips' has no power; "
      "the ringing-band test below is the one with a contrast.")
print("  ringing narrow bands (energy 150-300 ms over 40-100 ms, dB; the metallic modes outlast the collisions):")
tops = {}
for n in ("lp_Pandeiro_A_Thumb", "lp_Pandeiro_A_Rim", "lp_Pandeiro_A_Finger", "lp_Pandeiro_A_Slap"):
    fe, Pe = ltas(n, 0.04, 0.1)
    fl, Pl = ltas(n, 0.15, 0.3)
    r = 10 * np.log10((Pl + 1e-20) / (Pe + 1e-20))
    m = (fe > 3000) & (fe < 16000)
    sm = uniform_filter1d(r[m], 3)
    cl = []
    for i in np.argsort(sm)[::-1]:
        if all(abs(fe[m][i] / c - 1) > 0.03 for c, _ in cl):
            cl.append((float(fe[m][i]), float(sm[i])))
        if len(cl) == 4:
            break
    tops[n] = cl
    print(f"    {n[3:]:20s} least-decayed bands Hz (late/early dB): " + ", ".join(f"{c:.0f} ({v:+.0f})" for c, v in cl) + f"   median band {np.median(sm):+.0f}, spread (std) {np.std(sm):.1f}")
allf = sorted(c for cl in tops.values() for c, _ in cl)
seen = []
for c in allf:
    if any(abs(c / o - 1) < 0.04 for o in seen):
        continue
    k = [n for n, cl in tops.items() if any(abs(f / c - 1) < 0.04 for f, _ in cl)]
    seen.append(c)
    if len(k) >= 3:
        print(f"  -> {c:.0f} Hz (+-4 %) is among the 4 least-decayed bands in {len(k)} of {len(tops)} clips: {', '.join(q[3:] for q in k)}")

print("== 5. grain density: peaks/s of the 0.5 ms envelope of 8-15 kHz (prominence 0.5 x its 20 ms mean)")
for n, t0, t1 in ((ROLL_REF, 0.15, 1.0), ("lp_Pandeiro_A_Shake", 0.02, 0.2), ("lp_Tmbourin_A_1_Shake", 0.05, 0.6), ("lp_Tmbourin_C_4_Shake", 0.05, 0.6)):
    sr, x = load(n)
    e = env(band(x, sr, 8000, 15000), sr, 0.5)[int(t0 * sr):int(t1 * sr)]
    m20 = uniform_filter1d(e, int(0.02 * sr))
    pk, _ = find_peaks(e, prominence=0.5 * m20.mean(), distance=int(0.0005 * sr))
    print(f"  {n[3:]:22s} {len(pk) / (t1 - t0):6.0f} /s")
