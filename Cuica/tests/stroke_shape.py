"""stroke_shape.py <a.wav> [b.wav ...] -- how each stroke moves, for comparing Cuica against real cuica recordings
(docs/SPEC.md, round 5). Per stroke (onset = the level crossing 20 dB under the file's peak after sitting 25 dB under it):
  scrape  ms from onset to the first clearly pitched frame (YIN aperiodicity < 0.1)
  rise    ms from onset to 6 dB under the stroke's peak
  climb   cents from the first pitched frame to the highest f0 while loud (the squeak)
  sag     cents from that highest f0 down to the f0 at the last loud frame (12 dB under the stroke's peak)
  creak   mean aperiodicity 12-24 dB under the stroke's peak after it (0 = clean, 1 = no pitch at all)
  tail    dB re the stroke's peak 60 ms after the last loud frame; t60 = ring time fitted on the next 100 ms
"""
import sys
import numpy as np
from scipy.io import wavfile

HOP, WIN = 0.01, 0.03


def load(p):
    sr, x = wavfile.read(p)
    x = x.astype(float)
    if x.ndim > 1:
        x = x.mean(1)
    return sr, x / (np.abs(x).max() + 1e-12)


def yin(fr, sr, lo=80, hi=2000):
    n = len(fr) // 2
    d = np.array([np.sum((fr[:n] - fr[t:t + n]) ** 2) for t in range(n)])
    dn = np.r_[1, d[1:] * np.arange(1, n) / (np.cumsum(d[1:]) + 1e-12)]
    a, b = int(sr / hi), int(sr / lo)
    idx = np.where(dn[a:b] < 0.15)[0]
    if not len(idx):
        return 0.0, float(dn[a:b].min())
    t = a + idx[0]
    while t + 1 < b and dn[t + 1] < dn[t]:
        t += 1
    p = t + 0.5 * (dn[t - 1] - dn[t + 1]) / (dn[t - 1] - 2 * dn[t] + dn[t + 1] + 1e-12)
    return sr / p, float(dn[t])


def frames(x, sr):
    N, h = int(WIN * sr), int(HOP * sr)
    out = []
    for i in range(0, len(x) - N, h):
        fr = x[i:i + N]
        lv = 20 * np.log10(np.sqrt((fr ** 2).mean()) + 1e-9)
        f, ap = yin(fr, sr) if lv > -50 else (0.0, 1.0)
        out.append((lv, f, ap))
    return np.array(out)


def strokes(F):
    lv = F[:, 0]
    top = lv.max()
    on, armed = [], True
    for i, l in enumerate(lv):
        if armed and l > top - 20:
            on.append(i)
            armed = False
        elif l < top - 25:
            armed = True
    return on + [len(lv)]


def shape(F, a, b):
    lv, f0, ap = F[a:b, 0], F[a:b, 1], F[a:b, 2]
    pk = int(np.argmax(lv))
    P = lv[pk]
    r = {"scrape": next((i for i in range(len(f0)) if f0[i] and ap[i] < 0.1), len(f0)) * HOP * 1000,
         "rise": next(i for i in range(len(lv)) if lv[i] > P - 6) * HOP * 1000}
    loud = [i for i in range(len(lv)) if lv[i] > P - 12]
    last = loud[-1]
    fl = [f0[i] for i in loud if f0[i] and ap[i] < 0.1]
    if fl:
        r["climb"] = 1200 * np.log2(max(fl) / fl[0])
        fe = next((f0[i] for i in range(last, pk - 1, -1) if f0[i] and ap[i] < 0.1), max(fl))
        r["sag"] = 1200 * np.log2(fe / max(fl))
    end = [ap[i] for i in range(pk, len(lv)) if P - 24 < lv[i] < P - 12]
    r["creak"] = float(np.mean(end)) if end else float("nan")
    k = last + 6
    if k + 10 < len(lv):
        r["tail"] = lv[k] - P
        sl = np.polyfit(np.arange(10) * HOP, lv[k:k + 10], 1)[0]
        r["t60"] = -60 / sl if sl < 0 else float("inf")
    return r


def report(p):
    sr, x = load(p)
    F = frames(x, sr)
    on = strokes(F)
    print(f"== {p.split('/')[-1]}")
    rows = [shape(F, on[i], on[i + 1]) for i in range(len(on) - 1)]
    for i, r in enumerate(rows):
        print(f"  stroke {i + 1}: " + "  ".join(f"{k} {v:6.0f}" if k not in ("creak", "t60") else f"{k} {v:5.2f}" for k, v in r.items()))
    return rows


if __name__ == "__main__":
    for p in sys.argv[1:]:
        report(p)
