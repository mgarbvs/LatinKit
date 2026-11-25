"""fit.py -- fit the repinique engine to the recordings and print ref vs ours.

    python3 tests/fit.py targets          # what the recordings say, per stroke
    python3 tests/fit.py fit [iters]      # adjust mode gains W, damping G and the tick noise in scripts/repinique_tables.json until the band profiles match
    python3 tests/fit.py report           # per stroke: ref vs ours
    python3 tests/fit.py ab               # docs/strokes_ab.wav: ref stroke, then ours, alternating (gitignored)
References: tests/refs.py. The previews are peak-normalised, so only shapes are compared, not loudness (tests/calibrate.py sets levels).
"""
import json
import os
import sys
import warnings

import numpy as np
from scipy.io import wavfile

warnings.filterwarnings("ignore")
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import measure as M  # noqa: E402
from refs import load, ref_names  # noqa: E402

E = M.E
CODE = os.path.join(HERE, "_t.fit.genexpr")
FLOOR = -45.0       # the recordings' ring window sits on the room / noise floor below this (dB re the early total): not chased
FIT = [s for s in E.STROKES if ref_names(s)]      # the Mute has no recording: derive_mute() builds it from the Hand
FMIN = 50.0         # Hz: below it the recordings' ring window holds a 35 Hz room / shell rumble 50-70 dB down (every stroke), not the head's decay


def ref_profile(stroke):
    ps, bs = [], []
    for n in ref_names(stroke):
        sr, x = load(n)
        ps.append(M.profile(x, sr))
        bs.append(M.broadband(x, sr))
    return ps, bs


def mean_profile(ps):
    return dict(early=np.mean([p["early"] for p in ps], 0), ring=np.mean([p["ring"] for p in ps], 0),
                hf=np.mean([p["hf"] for p in ps]), lf=np.mean([p["lf"] for p in ps]))


def target(stroke):
    return mean_profile(ref_profile(stroke)[0])


def tick_target(stroke):
    """(median over the takes) the contact tick before the tone: its centre (geometric, Hz, 700..8000 of the first 1.8 ms), the recording's blip ratio, tone-start and crack share"""
    r = []
    for n in ref_names(stroke):
        sr, x = load(n)
        on = M.onset(x, 0.05)
        seg = x[max(0, on - int(0.0003 * sr)):on + int(0.0015 * sr)]
        sp = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), 1 << 12)) ** 2
        f = np.fft.rfftfreq(1 << 12, 1 / sr)
        m = (f > 700) & (f < 8000)
        b = M.broadband(x, sr)
        r.append((float(np.exp((np.log(f[m]) * sp[m]).sum() / sp[m].sum())), b["blip"], b["tone"], b["crack"]))
    return tuple(float(np.median([v[i] for v in r])) for i in range(4))


def write_code(tables, path=CODE, jitter=0):
    """jitter 0: the nominal stroke the fit and the tolerances are about; E.JITTER_DB: what is heard"""
    open(path, "w").write(E.code(tables, jitter=jitter))
    return path


def model_profile(stroke, code, hits=3):
    """profile of the first hit, broadband = the median over `hits` hits M.SPACE s apart (the tick's noise differs hit to hit)"""
    sp = M.SPACE
    sr, x = M.render([(E.STROKES.index(stroke), 0.8, 0.05 + sp * k) for k in range(hits)], sp * hits + 0.1, [], code=code)
    bbs = [M.broadband(x[int(sp * k * sr):int(sp * (k + 1) * sr)], sr, int(0.05 * sr)) for k in range(hits)]
    return M.profile(x[:int((sp - 0.1) * sr)], sr), {k: float(np.nanmedian([b[k] for b in bbs])) for k in bbs[0]}


GRID_G = [0.25, 0.4, 0.6, 1.0, 1.5, 2.5, 4.0, 6.5, 10.0, 15.0]
GRID_TAU = [0.006, 0.012, 0.025, 0.05, 0.1, 0.2, 0.4]


def decay_cost(bb, mp, t):
    """how far the stroke's envelope decay (t20, t40) and its ring-window band levels are from the recordings'"""
    c = np.log2(bb["t20"] / t["t20"]) ** 2 + np.log2(bb["t40"] / t["t40"]) ** 2 + ((bb["crack"] - t["crack"]) / 10) ** 2     # the crack share: a G on the noise bands makes the tick's tail
    use = (t["early"] > -28) & (t["ring"] > FLOOR) & (np.array([E.mode_freq(m) for m in range(E.NM)]) > FMIN)
    return float(c + np.mean((mp["ring"][use] - t["ring"][use]) ** 2) / 300) if use.any() else float(c)


def search_decay(tabs, tg, near=False):
    """per stroke: the hand's damping (one G for the head modes (the noise bands share it or stay at 1, whichever fits better), tau its duration) by grid search on t20, t40 and the ring-window levels (near: only the grid cells next to the
    current ones). G below 1 is the Open's slow start (its envelope falls ever faster). A per-band G fitted to the ring window alone left t20 far off in Bongo."""
    for s in FIT:
        t = tg[s]
        g0, tau0 = tabs[s]["G"][0], tabs[s]["tau"]
        gi = min(range(len(GRID_G)), key=lambda i: abs(GRID_G[i] - g0))
        ti = min(range(len(GRID_TAU)), key=lambda i: abs(GRID_TAU[i] - tau0))
        best = None
        for g in (GRID_G[max(gi - 1, 0):gi + 2] if near else GRID_G):
            for tau in (GRID_TAU[max(ti - 1, 0):ti + 2] if near else GRID_TAU):
                for ns in (0, 1):       # the noise bands share G (the Finger's and Rim's tails) or stay at 1 (as in Bongo)
                    tabs[s]["G"] = [g] * E.NN0 + [g if ns else 1.0] * E.NB
                    tabs[s]["tau"] = tau
                    sr, x = M.render([(E.STROKES.index(s), 0.8, 0.05)], 1.3, [], code=write_code(tabs))
                    c = decay_cost(M.broadband(x, sr, int(0.05 * sr)), M.profile(x, sr), t)
                    if best is None or c < best[0]:
                        best = (c, g, tau, ns)
        tabs[s]["G"] = [best[1]] * E.NN0 + [best[1] if best[3] else 1.0] * E.NB
        tabs[s]["tau"] = best[2]


def derive_mute(tabs):
    """Mute = the Hand held on the head: a judgement (no recording). The Hand's mode gains with the shell's and the highs 12 dB down (a damped skin does not excite them), every decay
    5x faster for 0.15 s and most of the ring killed at the hit; the level is PEAK_DB's (calibrate.py)."""
    h = tabs["hand"]
    tabs["mute"] = dict(h, W=[round(w - (12 if m >= E.NH or E.FIXED[m] else 0), 1) for m, w in enumerate(h["W"])], G=[5.0] * E.NM, tau=0.15, kp=0.1)


def fit(iters=6):
    tabs = E.default_tables() if os.environ.get('FRESH') else E.load_tables()
    tk = {s: tick_target(s) for s in FIT}
    tg = {s: target(s) for s in FIT}
    for s, t in tg.items():
        bs = ref_profile(s)[1]
        t["t20"], t["t40"], t["crack"] = (float(np.nanmean([b[k] for b in bs])) for k in ("t20", "t40", "crack"))
    for s in FIT:
        tabs[s]["nf"] = round(tk[s][0], -1)
        tabs[s]["nq"] = 0.7
        if os.environ.get('FRESH'):     # seed the mode gains with the recordings' own band levels
            tabs[s]["W"] = [round(float(np.clip(v, -60, 0)), 1) for v in tg[s]["early"]]
    for it in range(iters):
        code = write_code(tabs)
        worst = 0
        for s in FIT:
            T = tabs[s]
            mp, bb = model_profile(s, code)
            t = tg[s]
            for b in range(E.NM):
                dlt = float(np.clip(t["early"][b] - mp["early"][b], -12, 12))
                worst = max(worst, abs(dlt))
                T["W"][b] = round(float(np.clip(T["W"][b] + 0.7 * dlt, -70, 12)), 1)
            # the tick's level from the blip before the tone, and when the tone starts (ta) from the rise
            if tk[s][1] > 0.12:
                T["nl"] = round(float(np.clip(T["nl"] * (tk[s][1] / bb["blip"]) ** 0.8, 0.001, 60)), 4)
            else:       # a stroke whose recordings have no tick at the start (the Open's soft mallet; Finger): the crack share is the measure
                T["nl"] = round(float(np.clip(T["nl"] * 10 ** ((tk[s][3] - bb["crack"]) / 20 * 0.8), 0.001, 60)), 4)
            T["ta"] = round(float(np.clip(T["ta"] + 0.5e-3 * (tk[s][2] - bb["tone"]), 0.0001, 0.02)), 5)
        for s in FIT:      # level of the whole stroke is not fitted: the loudest mode stays at 0 dB (calibrate.py sets A)
            m = max(tabs[s]["W"])
            tabs[s]["W"] = [round(w - m, 1) for w in tabs[s]["W"]]
        if it == 3 or it >= 6:      # one full search, then near ones every iteration (a search followed by W updates drifts: the last operation is a search)
            search_decay(tabs, tg, near=it != 3)
        print(f"iter {it}: worst band error {worst:.1f} dB", flush=True)
    derive_mute(tabs)
    json.dump(tabs, open(E.TABLES_PATH, "w"), indent=1)
    print("wrote", E.TABLES_PATH)


def fmt(a):
    return " ".join(f"{v:5.0f}" if np.isfinite(v) else "  nan" for v in a)


def targets_cmd():
    print("band centres Hz:", " ".join(f"{E.mode_freq(m):5.0f}" for m in range(E.NM)))
    for s in FIT:
        t = target(s)
        bs = ref_profile(s)[1]
        print(f"{s:7s} early {fmt(t['early'])}  hf {t['hf']:.0f}  lf {t['lf']:.0f}\n        ring  {fmt(t['ring'])}")
        print(f"        rise {np.nanmean([b['rise'] for b in bs]):.2f} ms, t20 {np.nanmean([b['t20'] for b in bs]):.0f}, t40 {np.nanmean([b['t40'] for b in bs]):.0f} ms, "
              f"centroid {np.mean([b['centroid'] for b in bs]):.0f} Hz, crack {np.mean([b['crack'] for b in bs]):.1f} dB")


def report_cmd():
    code = write_code(E.load_tables())
    for s in FIT:
        t = target(s)
        mp, ob = model_profile(s, code)
        rb = ref_profile(s)[1]
        r = {k: np.nanmean([b[k] for b in rb]) for k in rb[0]}
        use = t["early"] > -30
        err = float(np.sqrt(np.mean((mp["early"][use] - t["early"][use]) ** 2)))
        sr, x = M.render([(E.STROKES.index(s), 0.8, 0.05)], 1.0, [], code=code)
        hf = (float(np.median([M.hf_level(*load(n)[::-1]) for n in ref_names(s)])), M.hf_level(x, sr))
        print(f"{s:6s} profile rms {err:4.1f} dB ({int(use.sum())} bands)  rise {r['rise']:.2f}/{ob['rise']:.2f} ms  t20 {r['t20']:.0f}/{ob['t20']:.0f}  "
              f"t40 {r['t40']:.0f}/{ob['t40']:.0f} ms  centroid {r['centroid']:.0f}/{ob['centroid']:.0f} Hz  crack {r['crack']:.1f}/{ob['crack']:.1f} dB  blip {r['blip']:.2f}/{ob['blip']:.2f}  "
              f"tone {r['tone']:.1f}/{ob['tone']:.1f} ms  HF 2.5-9k {hf[0]:.0f}/{hf[1]:.0f} dB")


def ab_cmd():
    """docs/strokes_ab.wav: per stroke the recording then ours (vel 0.8, Vary on), 1.5 s each; the cue list is printed"""
    from scipy.io import wavfile
    from scipy.signal import resample_poly
    code = write_code(E.load_tables(), jitter=E.JITTER_DB)
    sr = 48000
    out, cues, t = [], [], 0.0
    for s in FIT:
        cen = {n: M.broadband(*load(n)[::-1])["centroid"] for n in ref_names(s)}
        n = sorted(cen, key=cen.get)[len(cen) // 2]      # the take with the median centroid
        rsr, rx = load(n)
        rx = resample_poly(rx, sr, rsr) if rsr != sr else rx
        on = M.onset(rx)
        rx = rx[max(0, on - int(0.01 * sr)):][:int(1.5 * sr)]
        _, ox = M.render([(E.STROKES.index(s), 0.8, 0.02)], 1.6, [], code=code)
        ox = ox[:int(1.5 * sr)]
        ox = ox / (np.abs(ox).max() + 1e-9) * 0.7
        rx = rx / (np.abs(rx).max() + 1e-9) * 0.7
        cues.append(f"{t:6.2f} s  {s}: recording")
        t += (len(rx) / sr) + 0.25
        cues.append(f"{t:6.2f} s  {s}: ours")
        out += [rx, np.zeros(int(0.25 * sr)), ox, np.zeros(int(0.7 * sr))]
        t += (len(ox) / sr) + 0.7
    y = np.concatenate(out)
    wavfile.write(os.path.join(HERE, "../docs/strokes_ab.wav"), sr, (y * 32767).astype(np.int16))
    print("docs/strokes_ab.wav", round(len(y) / sr, 1), "s")
    print("\n".join(cues))


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "report"
    {"targets": targets_cmd, "report": report_cmd, "ab": ab_cmd}.get(cmd, lambda: fit(int(sys.argv[2]) if len(sys.argv) > 2 else 6))()
