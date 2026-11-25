"""End-to-end checks of m4l/Guiro.amxd running in real standalone Max (needs Max, not Live), from a cold start: it loads and compiles, every stroke
(Up, Down, Long, Top) sounds at its calibrated level with the length / centroid / bands the Latin Percussion previews measured (tests/refs.json),
the Stroke menu and the note map, Roll, back-to-back notes (the gate-collapse trap), every parameter, pan, extremes, both Types.

    uv run --directory $MAXTEST_DIR python <repo>/Guiro/tests/test_max_render.py
The metrics here mirror tests/guiro_measure.js (spectra of L+R: the L/R magnitude is rectified and full of low-frequency energy).
"""
import json
import os
import subprocess
import sys

import numpy as np

sys.path.insert(0, os.environ["MAXTEST_DIR"])
import server  # noqa: E402
from analyze import read_wav  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
DEV = os.path.join(HERE, "../m4l/Guiro.amxd")
RESTART = os.path.join(HERE, "../scripts/max_restart.sh")
REFS = json.load(open(os.path.join(HERE, "refs.json")))
KINDS = ["Up", "Down", "Long", "Top"]
CAL_RMS = 0.25 * 10 ** (-6 / 20) * 100 / 127   # a vel-100 stroke at the default Level -6 dB: 10 ms RMS peak of the (L, R) magnitude
FAILS = []
BASE = {"Type": 0, "Length": 450, "Roll": 0, "Stroke": 0, "Pan": 0, "Level": -6, "Speed": 100, "Ridge": 100, "Tone": 0, "Vary": 50}
BANDS = [0, 250, 500, 1000, 2000, 4000, 6000, 8000, 12000, 16000, 24000]


def check(cond, what):
    print(("ok   " if cond else "FAIL ") + what)
    if not cond:
        FAILS.append(what)


def play(events, ms, **p):
    r = server.render(events, ms, params={**BASE, **p})
    x, sr = read_wav(r["wav"])
    return x, sr, r


def mag(x):
    return np.hypot(x[:, 0], x[:, 1])


def mov_rms(x, w):
    cs = np.concatenate([[0], np.cumsum(x ** 2)])
    h = w // 2
    i = np.arange(len(x))
    a, b = np.maximum(0, i - h), np.minimum(len(x), i - h + w)
    return np.sqrt((cs[b] - cs[a]) / np.maximum(1, b - a))


def hp4(x, fc, sr):
    """4th-order Butterworth high-pass as two RBJ biquads (the same as tests/guiro_measure.js; the maxtest env has no scipy)"""
    y = np.array(x, dtype=float)
    for q in (0.5412, 1.3066):
        w = 2 * np.pi * fc / sr
        al, c = np.sin(w) / (2 * q), np.cos(w)
        a0 = 1 + al
        b0, b1, a1, a2 = (1 + c) / 2 / a0, -(1 + c) / a0, -2 * c / a0, (1 - al) / a0
        x1 = x2 = y1 = y2 = 0.0
        out = np.empty_like(y)
        for i, v in enumerate(y):
            o = b0 * v + b1 * x1 + b0 * x2 - a1 * y1 - a2 * y2
            x2, x1, y2, y1 = x1, v, y1, o
            out[i] = o
        y = out
    return y


def impacts(sig, sr):
    """ridge impacts as tests/guiro_measure.js detect(): above 3 kHz, 0.4 ms RMS, a 6 dB rise in 1 ms, >= 2.5 ms apart, within 24 dB of the loudest"""
    hp = hp4(sig, 3000, sr)
    d = 20 * np.log10(mov_rms(hp, max(1, int(0.0004 * sr))) + 1e-6)
    k = int(0.001 * sr)
    o = np.concatenate([np.zeros(k), np.maximum(0, d[k:] - d[:-k])])
    pk = []
    for i in range(1, len(d) - 1):
        if o[i] >= 6 and o[i] >= o[i - 1] and o[i] > o[i + 1] and d[i] > d.max() - 24:
            if pk and i - pk[-1] < int(0.0025 * sr):
                if o[i] > o[pk[-1]]:
                    pk[-1] = i
            else:
                pk.append(i)
    return np.array(pk)


def stroke_metrics(x, sr, start, span=0.9):
    """metrics of the stroke starting near `start` (samples) in the stereo render x"""
    seg = mag(x[start:start + int(span * sr)])
    sig = (x[start:start + int(span * sr), 0] + x[start:start + int(span * sr), 1]) / np.sqrt(2)
    e10, e5 = mov_rms(seg, int(0.010 * sr)), mov_rms(seg, int(0.005 * sr))
    pk, pi = float(e10.max()), int(np.argmax(e10))
    on = int(np.argmax(e5 > pk * 10 ** (-26 / 20)))
    last = on + int(np.max(np.where(e5[on:] > pk * 0.1)[0])) if (e5[on:] > pk * 0.1).any() else on
    below = lambda db: (np.where(e10[pi:] < pk * 10 ** (-db / 20))[0][:1] / sr * 1000)
    t20 = below(20)
    w = sig[on:on + int(0.1 * sr)]
    w = w - w.mean()
    n = 1 << int(np.ceil(np.log2(max(8192, len(w)))))
    s = np.abs(np.fft.rfft(w, n)) ** 2
    f = np.fft.rfftfreq(n, 1 / sr)
    tot = s[1:].sum()
    bands = [10 * np.log10(s[(f >= lo) & (f < hi)].sum() / tot + 1e-12) for lo, hi in zip(BANDS[:-1], BANDS[1:])]
    p = impacts(sig[on:last + int(0.002 * sr)], sr)
    rate = (len(p) - 1) / ((p[-1] - p[0]) / sr) if len(p) > 3 else float("nan")
    return {"peak": pk, "len": (last - on) / sr * 1000, "t20": float(t20[0]) if len(t20) else np.inf, "bands": bands,
            "cent": float((s[1:] * f[1:]).sum() / tot), "rate": rate, "n": len(p)}


def strokes(n=10, gap=1200, note=60, **p):
    """n separate strokes `gap` ms apart; returns a list of metrics (magnitude of L and R, so Pan doesn't matter)"""
    ev = [{"t": 100 + gap * k, "note": note, "vel": 100, "dur": 40} for k in range(n)]
    x, sr, r = play(ev, 100 + gap * n + 200, **p)
    return [stroke_metrics(x, sr, int((0.1 + gap / 1000 * k - 0.02) * sr)) for k in range(n)], r


def mean(L, key):
    v = [m[key] for m in L if np.isfinite(m[key])]
    return float(np.mean(v)) if v else float("nan")


subprocess.run(["bash", RESTART], capture_output=True)
loaded = server.load_device(DEV)
errs = [l for l in loaded["console"] if "[1]" in l]
check(not errs, f"load_device console has no [1] errors ({len(errs)} found)")
for l in errs:
    print("     " + l)
names = {p["name"] for p in loaded["params"]}
check(set(BASE) <= names, f"all {len(BASE)} parameters exposed to Live (missing: {sorted(set(BASE) - names)})")

# 1. every stroke on the Güiro through the Stroke menu (fixed entries: always that stroke): level, length, centroid, bands, rate vs the previews
res = {}
for ki, k in enumerate(KINDS):
    L, r = strokes(16 if k == "Top" else 8, Stroke=ki + 1)
    res[k] = L
    ref = REFS[k]
    pk = mean(L, "peak")
    d = 20 * np.log10(pk / CAL_RMS)
    tol = 5 if k == "Top" else 3   # a single impact is a single noise burst: its peak scatters (-1.7 .. -4.5 dB between runs) far more than a scrape's
    check(r["nan_count"] == 0 and r["inf_count"] == 0 and abs(d) < tol, f"{k}: 10 ms RMS peak {pk:.3f} = {d:+.1f} dB from the calibrated {CAL_RMS:.3f} (within {tol} dB)")
    ln = mean(L, "len")
    check(0.7 * ref["len"][0] - 5 < ln < 1.35 * ref["len"][1] + 5, f"{k}: length {ln:.0f} ms, references {ref['len'][0]:.0f}..{ref['len'][1]:.0f}")
    c = mean(L, "cent")
    check(0.8 * ref["cent"][0] < c < 1.2 * ref["cent"][1], f"{k}: centroid {c:.0f} Hz, references {ref['cent'][0]:.0f}..{ref['cent'][1]:.0f}")
    if k == "Top":
        t20 = mean(L, "t20")
        check(0.6 * ref["t20"][0] < t20 < 1.7 * ref["t20"][1], f"Top: t20 {t20:.0f} ms, references {ref['t20'][0]:.0f}..{ref['t20'][1]:.0f}")
    else:
        rt = mean(L, "rate")
        check(0.7 * ref["rate"][0] < rt < 1.3 * ref["rate"][1], f"{k}: impact rate {rt:.0f} /s, references {ref['rate'][0]:.0f}..{ref['rate'][1]:.0f}")
    b = np.mean([m["bands"] for m in L], axis=0)
    bad = [(i, round(float(b[i]), 1), ref["bandsR"][i]) for i in range(10) if b[i] > ref["bandsR"][i][1] + 6 or (ref["bandsR"][i][1] > -35 and b[i] < ref["bandsR"][i][0] - 6)]
    check(not bad, f"{k}: octave bands within 6 dB of the range over the takes (off: {bad or 'none'})")
check(res["Up"] and mean(res["Up"], "len") < mean(res["Down"], "len") < mean(res["Long"], "len"), "length order Up < Down < Long")

# 2. the note map (Stroke = Key): C3 Up, C#3 Down, D3 Long, D#3 Top, E3 Up again
lens = []
for note in (60, 61, 62, 63, 64):
    L, _ = strokes(4, note=note, Stroke=0)
    lens.append(mean(L, "len"))
check(lens[2] > 2 * lens[1] and lens[3] < lens[0] and abs(lens[4] / lens[0] - 1) < 0.35, f"Key: C3..E3 = Up, Down, Long, Top, Up (lengths {[round(v) for v in lens]} ms)")

# 3. Roll: a held note keeps scraping, stops with the note, Roll 0 is one stroke
x, sr, _ = play([{"t": 100, "note": 60, "vel": 100, "dur": 800}], 1600, Roll=8)
m = mag(x)
check(float(m[int(0.6 * sr):int(0.9 * sr)].max()) > 0.4 * float(m.max()), "Roll 8 Hz: a held note is still scraping at 0.5-0.8 s")
check(float(m[int(1.15 * sr):].max()) < 0.1 * float(m.max()), "Roll stops at note-off")
x, sr, _ = play([{"t": 100, "note": 60, "vel": 100, "dur": 800}], 1600, Roll=0)
m = mag(x)
check(float(m[int(0.6 * sr):int(0.9 * sr)].max()) < 0.05 * float(m.max()), "Roll 0: one stroke per note, however long it is held")

# 4. back-to-back notes: note-off and the next note-on in one instant (gen~ sees only the last Param value per block: a counter, not a gate)
ev = [{"t": 100 + 150 * k, "note": 60, "vel": 100, "dur": 150} for k in range(6)]
x, sr, _ = play(ev, 1300)
m = mag(x)
pks = [float(m[int((0.1 + 0.15 * k) * sr):int((0.1 + 0.15 * k + 0.08) * sr)].max()) for k in range(6)]
check(min(pks) > 0.3 * max(pks), f"six Up strokes 150 ms apart on the same key, note-off meeting the next note-on: all sound (peaks {[round(p, 3) for p in pks]})")

# 5. parameters, on the Long stroke (Stroke menu = Long)
NS = 6
base, _ = strokes(NS, Stroke=3)
bm = mean(base, "peak")
for label, kw, fn, want in (
        ("Level 0 dB", {"Level": 0}, lambda L: mean(L, "peak") / bm, (1.7, 2.35)),
        ("Speed 200 % keeps the loudness", {"Speed": 200}, lambda L: mean(L, "peak") / bm, (0.6, 1.6)),
        ("Ridge 400 % keeps the loudness", {"Ridge": 400}, lambda L: mean(L, "peak") / bm, (0.6, 1.6)),
        ("Speed 200 % halves the length", {"Speed": 200}, lambda L: mean(L, "len") / mean(base, "len"), (0.35, 0.7)),
        ("Speed 200 % doubles the ridge rate", {"Speed": 200}, lambda L: mean(L, "rate") / mean(base, "rate"), (1.4, 2.4)),
        ("Ridge 50 % halves the ridge rate", {"Ridge": 50}, lambda L: mean(L, "rate") / mean(base, "rate"), (0.3, 0.75)),
        ("Length 900 ms doubles the stroke", {"Length": 900}, lambda L: mean(L, "len") / mean(base, "len"), (1.6, 2.3)),
        ("Tone +12 st raises the centroid", {"Tone": 12}, lambda L: mean(L, "cent") / mean(base, "cent"), (1.3, 3.2)),
        ("Tone -12 st lowers the centroid", {"Tone": -12}, lambda L: mean(L, "cent") / mean(base, "cent"), (0.3, 0.8))):
    v = float(fn(strokes(NS, Stroke=3, **kw)[0]))
    check(want[0] < v < want[1], f"{label}: x{v:.2f} (want {want[0]}..{want[1]})")
x, sr, _ = play([{"t": 100, "note": 60, "vel": 127, "dur": 40}], 700, Pan=-100)
check(float(np.abs(x[:, 1]).max()) < 1e-4 and float(np.abs(x[:, 0]).max()) > 0.05, "Pan -100 is left only")
x, sr, _ = play([{"t": 100, "note": 60, "vel": 127, "dur": 40}], 700, Pan=100)
check(float(np.abs(x[:, 0]).max()) < 1e-4 and float(np.abs(x[:, 1]).max()) > 0.05, "Pan +100 is right only")

# 6. Reco-reco: brighter, rings longer, same controls
G, _ = strokes(NS, Stroke=3)
Rc, _ = strokes(NS, Stroke=3, Type=1)
check(mean(Rc, "cent") > 1.15 * mean(G, "cent"), f"Reco-reco is brighter: centroid {mean(Rc, 'cent'):.0f} vs {mean(G, 'cent'):.0f} Hz")
Gt, _ = strokes(NS, Stroke=4)
Rt, _ = strokes(NS, Stroke=4, Type=1)
check(mean(Rt, "t20") > 1.2 * mean(Gt, "t20"), f"Reco-reco's Top rings longer: t20 {mean(Rt, 't20'):.0f} vs {mean(Gt, 't20'):.0f} ms")

# 6b. Reco-reco against the Freesound reco-reco (tests/refs_reco.json): level, centroid, octave bands, the ring after a tap
RRF = json.load(open(os.path.join(HERE, "refs_reco.json")))
RB = {}
for ki, k in enumerate(KINDS):
    Lr, rr = strokes(16 if k == "Top" else 8, Stroke=ki + 1, Type=1)
    RB[k] = Lr
    d = 20 * np.log10(mean(Lr, "peak") / CAL_RMS)
    tol = 5 if k == "Top" else 3
    check(rr["nan_count"] == 0 and rr["inf_count"] == 0 and abs(d) < tol, f"Reco-reco {k}: 10 ms RMS peak {d:+.1f} dB from the calibrated level (within {tol} dB)")
    c = mean(Lr, "cent")
    if k != "Top":   # the recording has no lone tap, so no reference centroid for it (its Top is a spring ring, lines at 1.6-3.3 kHz)
        check(0.7 * RRF["cent"] < c < 1.35 * RRF["cent"], f"Reco-reco {k}: centroid {c:.0f} Hz, recording {RRF['cent']} Hz")
pool = np.mean([m["bands"] for k in ("Up", "Down", "Long") for m in RB[k]], axis=0)
badb = [(i, round(float(pool[i]), 1), RRF["bands"][i]) for i in range(2, 10) if abs(pool[i] - RRF["bands"][i]) > 6 and max(pool[i], RRF["bands"][i]) > -35]   # bands under 500 Hz are the recording's handling noise (-25 dB under 250 Hz), not the instrument
check(not badb, f"Reco-reco: octave bands of Up + Down + Long within 6 dB of the recording's clips (off: {badb or 'none'})")
t20 = mean(RB["Top"], "t20")
check(0.5 * RRF["ring"]["t20"] < t20 < 2 * RRF["ring"]["t20"], f"Reco-reco Top rings like the ring-out after a run: t20 {t20:.0f} ms, recording {RRF['ring']['t20']:.0f} ms")

# 7. extremes: every parameter at its minimum, then its maximum, both Types, a flurry of strokes of every kind
LIM = {"Length": (100, 1500), "Roll": (0, 12), "Pan": (-100, 100), "Level": (-36, 6), "Speed": (25, 400), "Ridge": (25, 400), "Tone": (-12, 12), "Vary": (0, 100)}
for which in (0, 1):
    for ti in range(2):
        p = {k: v[which] for k, v in LIM.items()}
        ev = [{"t": 100 + 40 * k, "note": 60 + k % 4, "vel": 127, "dur": 30} for k in range(20)]
        x, sr, r = play(ev, 2500, Type=ti, **p)
        check(r["nan_count"] == 0 and r["inf_count"] == 0 and float(np.abs(x).max()) < 1.0001,
              f"{['Guiro', 'Reco-reco'][ti]} with every parameter at {'max' if which else 'min'}: peak {float(np.abs(x).max()):.3f}, nan {r['nan_count']}, inf {r['inf_count']}")
play([{"t": 100, "note": 60, "vel": 100, "dur": 40}], 300)   # put the device back to the defaults

print(f"{len(FAILS)} FAILED" if FAILS else "all passed")
sys.exit(1 if FAILS else 0)
