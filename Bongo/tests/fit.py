"""fit.py -- fit the bongo engine to the recordings and print ref vs ours.

    python3 tests/fit.py targets          # what the recordings say, per drum and stroke
    python3 tests/fit.py fit [iters]      # adjust mode gains W, damping G and the tick noise in scripts/bongo_tables.json until the band profiles match
    python3 tests/fit.py report           # per drum and stroke: ref vs ours
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
from refs import load, ref_names, TAKE_SCALE  # noqa: E402

E = M.E
CODE = os.path.join(HERE, "_t.fit.genexpr")
FLOOR = -50.0       # the recordings' ring window sits on the room / noise floor below this (dB re the early total): not chased


def ref_f1(drum, take):
    """the open tone of that take (Hz): the nominal F1 x the take's measured tuning (refs.TAKE_SCALE)"""
    return E.F1[drum] * TAKE_SCALE[drum][take]


def ref_profile(drum, stroke):
    ps, bs = [], []
    for take, n in ref_names(drum, stroke):
        sr, x = load(n)
        ps.append(M.profile(x, sr, drum, ref_f1(drum, take)))
        bs.append(M.broadband(x, sr))
    return ps, bs


def mean_profile(ps):
    return dict(early=np.mean([p["early"] for p in ps], 0), ring=np.mean([p["ring"] for p in ps], 0),
                hf=np.mean([p["hf"] for p in ps]), lf=np.mean([p["lf"] for p in ps]))


def target(drum, stroke):
    return mean_profile(ref_profile(drum, stroke)[0])


def tick_target(stroke):
    """the contact tick before the tone: its centre (geometric, Hz, 700..8000 of the first 1.8 ms, both drums) and, per drum, the recordings' mean blip ratio and tone-start"""
    cs, bl, ri, ck = [], [[], []], [[], []], [[], []]
    for d in range(2):
        for take, n in ref_names(d, stroke):
            sr, x = load(n)
            on = M.onset(x, 0.05)
            seg = x[max(0, on - int(0.0003 * sr)):on + int(0.0015 * sr)]
            sp = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), 1 << 12)) ** 2
            f = np.fft.rfftfreq(1 << 12, 1 / sr)
            m = (f > 700) & (f < 8000)
            cs.append(np.exp((np.log(f[m]) * sp[m]).sum() / sp[m].sum()))
            b = M.broadband(x, sr)
            bl[d].append(b["blip"])
            ri[d].append(b["tone"])
            ck[d].append(b["crack"])
    return float(np.mean(cs)), [float(np.mean(v)) for v in bl], [float(np.mean(v)) for v in ri], [float(np.mean(v)) for v in ck]


def write_code(tables, path=CODE, jitter=0):
    """jitter 0: the nominal stroke the fit and the tolerances are about; E.JITTER_DB: what is heard"""
    open(path, "w").write(E.code(tables, jitter=jitter))
    return path


def model_profile(drum, stroke, code, hits=3):
    """profile of the first hit, broadband = the median over `hits` hits 1.5 s apart (the tick's noise differs hit to hit)"""
    sr, x = M.render([(drum, E.STROKES.index(stroke), 0.8, 0.05 + 1.5 * k) for k in range(hits)], 1.5 * hits + 0.1, [], code=code)
    bbs = [M.broadband(x[int(1.5 * k * sr):int(1.5 * (k + 1) * sr)], sr, int(0.05 * sr)) for k in range(hits)]
    return M.profile(x[:int(1.4 * sr)], sr, drum, E.F1[drum]), {k: float(np.nanmedian([b[k] for b in bbs])) for k in bbs[0]}


BODY_CAP = -6.0
GRID_G = [1.0, 1.4, 2.0, 3.0, 4.5, 6.5, 9.0, 13.0]
GRID_TAU = [0.004, 0.007, 0.012, 0.02, 0.035, 0.06, 0.1]


def decay_cost(bb, mp, t):
    """how far the stroke's envelope decay (t20, t40) and its ring-window band levels are from the recordings'"""
    c = np.log2(bb["t20"] / t["t20"]) ** 2 + np.log2(bb["t40"] / t["t40"]) ** 2
    use = (t["early"] > -28) & (t["ring"] > FLOOR)
    return float(c + np.mean((mp["ring"][use] - t["ring"][use]) ** 2) / 100) if use.any() else float(c)


def search_decay(tabs, tg, near=False):
    """per drum and stroke: the hand's damping (one G for the head and body modes, tau its duration) by grid search on t20, t40 and the ring-window levels
    (near: only the grid cells next to the current ones). A per-band G fitted to the ring window alone left t20 at 50-80 ms where the recordings fall 20 dB in 13-31 ms."""
    for s in E.STROKES:
        for d in range(2):
            t = tg[(d, s)]
            g0, tau0 = tabs[s]["G"][d][0], tabs[s]["tau"][d]
            gi = min(range(len(GRID_G)), key=lambda i: abs(GRID_G[i] - g0))
            ti = min(range(len(GRID_TAU)), key=lambda i: abs(GRID_TAU[i] - tau0))
            best = None
            for g in (GRID_G[max(gi - 1, 0):gi + 2] if near else GRID_G):
                for tau in (GRID_TAU[max(ti - 1, 0):ti + 2] if near else GRID_TAU):
                    tabs[s]["G"][d] = [g] * E.NN0 + [1.0] * (E.NM - E.NN0)
                    tabs[s]["tau"][d] = tau
                    sr, x = M.render([(d, E.STROKES.index(s), 0.8, 0.05)], 0.5, [], code=write_code(tabs))
                    c = decay_cost(M.broadband(x, sr, int(0.05 * sr)), M.profile(x, sr, d, E.F1[d]), t)
                    if best is None or c < best[0]:
                        best = (c, g, tau)
            tabs[s]["G"][d] = [best[1]] * E.NN0 + [1.0] * (E.NM - E.NN0)
            tabs[s]["tau"][d] = best[2]


def fit(iters=6):
    tabs = E.default_tables() if os.environ.get('FRESH') else E.load_tables()
    tk = {s: tick_target(s) for s in E.STROKES}
    tg = {(d, s): target(d, s) for d in range(2) for s in E.STROKES}
    for (d, s), t in tg.items():
        bs = ref_profile(d, s)[1]
        t["t20"], t["t40"] = (float(np.nanmean([b[k] for b in bs])) for k in ("t20", "t40"))
    for s in E.STROKES:
        tabs[s]["nf"] = round(tk[s][0], -1)
        tabs[s]["nq"] = 0.7
        if os.environ.get('FC'):
            tabs[s]["fc"] = float(os.environ['FC'])
        if os.environ.get('FRESH'):     # seed the mode gains with the recordings' own band levels
            for d in range(2):
                tabs[s]["W"][d] = [round(float(np.clip(v, -60, 0)), 1) for v in tg[(d, s)]["early"]]
    for it in range(iters):
        code = write_code(tabs)
        worst = 0
        for s in E.STROKES:
            T = tabs[s]
            for d in range(2):
                mp, bb = model_profile(d, s, code)
                t = tg[(d, s)]
                for b in range(E.NM):
                    dlt = float(np.clip(t["early"][b] - mp["early"][b], -12, 12))
                    worst = max(worst, abs(dlt))
                    T["W"][d][b] = round(float(np.clip(T["W"][d][b] + 0.7 * dlt, -70, 12)), 1)
                # the 125 Hz body's band holds the finger's broadband low-frequency thump too; as a tone it ran away (slap: a 125 Hz swing the recordings do not have): at most BODY_CAP dB over the strongest head mode
                T["W"][d][E.NH] = min(T["W"][d][E.NH], max(T["W"][d][:E.NH]) + BODY_CAP)
                # the tick's level from the blip before the tone, and when the tone starts (td) from the rise
                if tk[s][1][d] > 0.12:
                    T["nl"][d] = round(float(np.clip(T["nl"][d] * (tk[s][1][d] / bb["blip"]) ** 0.8, 0.001, 60)), 4)
                else:       # a stroke whose recordings start with the crack itself (the slap: their 5 % onset is the crack, 4-6 ms in): the blip is no measure, the crack share is
                    T["nl"][d] = round(float(np.clip(T["nl"][d] * 10 ** ((tk[s][3][d] - bb["crack"]) / 20 * 0.8), 0.001, 60)), 4)
                T["ta"][d] = round(float(np.clip(T["ta"][d] + 0.5e-3 * (tk[s][2][d] - bb["tone"]), 0.0001, 0.004)), 5)
        for s in E.STROKES:      # level of the whole stroke is not fitted: the loudest mode of either drum stays at 0 dB (calibrate.py sets A)
            m = max(max(w) for w in tabs[s]["W"])
            tabs[s]["W"] = [[round(w - m, 1) for w in ws] for ws in tabs[s]["W"]]
        if it == 3 or it >= 6:      # one full search, then near ones every iteration (a search followed by W updates drifts: the last operation is a search)
            search_decay(tabs, tg, near=it != 3)
        print(f"iter {it}: worst band error {worst:.1f} dB", flush=True)
    json.dump(tabs, open(E.TABLES_PATH, "w"), indent=1)
    print("wrote", E.TABLES_PATH)


def fmt(a):
    return " ".join(f"{v:5.0f}" if np.isfinite(v) else "  nan" for v in a)


def targets_cmd():
    for d in range(2):
        print(f"\n== {E.DRUMS[d]}  band centres Hz:", " ".join(f"{E.mode_freq(d, m):5.0f}" for m in range(E.NM)))
        for s in E.STROKES:
            t = target(d, s)
            bs = ref_profile(d, s)[1]
            print(f"{s:9s} early {fmt(t['early'])}  hf {t['hf']:.0f}\n          ring  {fmt(t['ring'])}")
            print(f"          rise {np.nanmean([b['rise'] for b in bs]):.2f} ms, t20 {np.nanmean([b['t20'] for b in bs]):.0f}, t40 {np.nanmean([b['t40'] for b in bs]):.0f} ms, "
                  f"centroid {np.mean([b['centroid'] for b in bs]):.0f} Hz, crack {np.mean([b['crack'] for b in bs]):.1f} dB")


def report_cmd():
    code = write_code(E.load_tables())
    for d in range(2):
        for s in E.STROKES:
            t = target(d, s)
            mp, ob = model_profile(d, s, code)
            rb = ref_profile(d, s)[1]
            r = {k: np.nanmean([b[k] for b in rb]) for k in rb[0]}
            use = t["early"] > -30
            use[E.NH] = False       # the 125 Hz body band holds the finger's low-frequency thump: capped, not matched
            err = float(np.sqrt(np.mean((mp["early"][use] - t["early"][use]) ** 2)))
            print(f"{E.DRUMS[d]:4s} {s:9s} profile rms {err:4.1f} dB ({int(use.sum())} bands)  rise {r['rise']:.2f}/{ob['rise']:.2f} ms  t20 {r['t20']:.0f}/{ob['t20']:.0f}  "
                  f"t40 {r['t40']:.0f}/{ob['t40']:.0f} ms  centroid {r['centroid']:.0f}/{ob['centroid']:.0f} Hz  crack {r['crack']:.1f}/{ob['crack']:.1f} dB  blip {r['blip']:.2f}/{ob['blip']:.2f}  tone {r['tone']:.2f}/{ob['tone']:.2f}")


def ab_cmd():
    """docs/strokes_ab.wav: per drum and stroke the recording (take A) then ours (tuned to take A, vel 0.8, Vary on), 1.2 s each; the cue list is printed"""
    from scipy.io import wavfile
    from scipy.signal import resample_poly
    code = write_code(E.load_tables(), jitter=E.JITTER_DB)
    sr = 48000
    out, cues, t = [], [], 0.0
    for d in range(2):
        for s in E.STROKES + ["flam"]:
            take, n = ref_names(d, s)[0]
            rsr, rx = load(n)
            rx = resample_poly(rx, sr, rsr) if rsr != sr else rx
            on = M.onset(rx)
            rx = rx[max(0, on - int(0.01 * sr)):][:int(1.2 * sr)]
            _, ox = M.render([(d, E.STROKES.index(s) if s != "flam" else E.FLAM_STROKE, 0.8, 0.02)], 1.3, [f"tune={12 * np.log2(TAKE_SCALE[d][take]):.3f}"], code=code)
            ox = ox[:int(1.2 * sr)]
            ox = ox / (np.abs(ox).max() + 1e-9) * 0.7
            rx = rx / (np.abs(rx).max() + 1e-9) * 0.7
            cues.append(f"{t:6.2f} s  {E.DRUMS[d]} {s}: recording (take {take})")
            seg = [rx, np.zeros(int(0.25 * sr))]
            t += (len(rx) / sr) + 0.25
            cues.append(f"{t:6.2f} s  {E.DRUMS[d]} {s}: ours")
            seg += [ox, np.zeros(int(0.7 * sr))]
            t += (len(ox) / sr) + 0.7
            out += seg
    y = np.concatenate(out)
    wavfile.write(os.path.join(HERE, "../docs/strokes_ab.wav"), sr, (y * 32767).astype(np.int16))
    print("docs/strokes_ab.wav", round(len(y) / sr, 1), "s")
    print("\n".join(cues))


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "report"
    {"targets": targets_cmd, "report": report_cmd, "ab": ab_cmd}.get(cmd, lambda: fit(int(sys.argv[2]) if len(sys.argv) > 2 else 6))()
