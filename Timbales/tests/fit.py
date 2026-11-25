"""fit.py -- fit the timbales engine to the recordings and print ref vs ours.

    python3 tests/fit.py targets          # what the recordings say, per drum and stroke
    python3 tests/fit.py fit [iters]      # adjust mode gains W, damping G and the tick noise in scripts/timbales_tables.json until the band profiles match
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
from refs import load, ref_names  # noqa: E402

E = M.E
CODE = "/tmp/timbales_fit.genexpr"
FLOOR = -50.0       # the recordings' ring window sits on the room / noise floor below this (dB re the early total): not chased


def ref_f1(drum, take):
    if take == "X":
        return 195.0          # the rim click's one recording: a High-ish drum (peaks 195 / 394 Hz)
    sr, x = load(f"lp_Timbales_{take}_{'HL'[drum]}_Open")
    return M.f1_of(x, sr, E.F1[drum])


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


def noise_target(stroke):
    """the contact tick: where the recordings' energy above 1.5 kHz sits (geometric centre, Hz) and how big it is (dB re the early energy)"""
    cs, ks = [], []
    for d in range(2):
        for take, n in ref_names(d, stroke):
            sr, x = load(n)
            on = M.onset(x)
            seg = x[on:on + int(0.04 * sr)]
            sp = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), 1 << 14)) ** 2
            f = np.fft.rfftfreq(1 << 14, 1 / sr)
            m = (f > 1500) & (f < 11000)
            cs.append(np.exp((np.log(f[m]) * sp[m]).sum() / sp[m].sum()))
            ks.append(M.broadband(x, sr)["crack"])
    return float(np.mean(cs)), float(np.mean(ks))


def write_code(tables, path=CODE, jitter=0):
    """jitter 0: the nominal stroke the fit and the tolerances are about; E.JITTER_DB: what is heard"""
    open(path, "w").write(E.code(tables, jitter=jitter))
    return path


def model_profile(drum, stroke, code):
    sr, x = M.render([(drum, E.STROKES.index(stroke), 0.8, 0.05)], 1.2, [], code=code)
    return M.profile(x, sr, drum, E.F1[drum]), M.broadband(x, sr)


def fit(iters=6):
    tabs = E.default_tables() if os.environ.get('FRESH') else E.load_tables()
    nt = {s: noise_target(s) for s in E.STROKES}
    for s in E.STROKES:
        tabs[s]["nf"] = round(nt[s][0], -1)
        tabs[s]["nt"] = 0.004
        tabs[s]["nl"] = tabs[s]["nl"] or 0.1
    tg = {(d, s): target(d, s) for d in range(2) for s in E.STROKES}
    for it in range(iters):
        code = write_code(tabs)
        worst = 0
        for s in E.STROKES:
            T = tabs[s]
            cks = []
            for d in range(2):
                mp, bb = model_profile(d, s, code)
                cks.append(bb["crack"])
                t = tg[(d, s)]
                long_ref = True      # (noise bands keep G = 1: their ring window is room noise; the rim click's G is its hand-set seed: its recording ends at 0.23 s, so there is no ring window to fit)
                for b in range(E.NM):
                    dlt = float(np.clip(t["early"][b] - mp["early"][b], -12, 12))
                    worst = max(worst, abs(dlt))
                    T["W"][d][b] = round(float(np.clip(T["W"][d][b] + 0.7 * dlt, -70, 12)), 1)
                    tr = max(t["ring"][b], FLOOR)
                    if b < E.NN0 and s != "rimclick" and long_ref and t["early"][b] > -28 and mp["early"][b] > -40 and (t["ring"][b] > FLOOR or mp["ring"][b] > FLOOR):
                        tdr, mdr = tr - t["early"][b], min(mp["ring"][b] - mp["early"][b], -1.0)
                        if tdr < -3:
                            T["G"][d][b] = round(float(np.clip(T["G"][d][b] * (tdr / mdr) ** 0.8, 0.4, 10)), 2)
            T["nl"] = round(float(np.clip(T["nl"] * 10 ** ((nt[s][1] - np.mean(cks)) / 20 * 0.8), 0.001, 20)), 4)
        for s in E.STROKES:      # level of the whole stroke is not fitted: the loudest mode of either drum stays at 0 dB (calibrate.py sets A)
            m = max(max(w) for w in tabs[s]["W"])
            tabs[s]["W"] = [[round(w - m, 1) for w in ws] for ws in tabs[s]["W"]]
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
            err = float(np.sqrt(np.mean((mp["early"][use] - t["early"][use]) ** 2)))
            print(f"{E.DRUMS[d]:4s} {s:9s} profile rms {err:4.1f} dB ({int(use.sum())} bands)  rise {r['rise']:.2f}/{ob['rise']:.2f} ms  t20 {r['t20']:.0f}/{ob['t20']:.0f}  "
                  f"t40 {r['t40']:.0f}/{ob['t40']:.0f} ms  centroid {r['centroid']:.0f}/{ob['centroid']:.0f} Hz  crack {r['crack']:.1f}/{ob['crack']:.1f} dB")


def ab_cmd():
    from scipy.signal import resample_poly
    code = write_code(E.load_tables(), jitter=E.JITTER_DB)
    sr = 48000
    out = []
    for d in range(2):
        for s in E.STROKES:
            take, n = ref_names(d, s)[0]
            rsr, rx = load(n)
            rx = resample_poly(rx, sr, rsr) if rsr != sr else rx
            on = M.onset(rx)
            rx = rx[max(0, on - int(0.01 * sr)):][:int(1.2 * sr)]
            f1r = ref_f1(d, take)
            _, ox = M.render([(d, E.STROKES.index(s), 0.8, 0.02)], 1.3, [f"tune={12 * np.log2(f1r / E.F1[d]):.3f}"], code=code)
            ox = ox[:int(1.2 * sr)]
            ox = ox / (np.abs(ox).max() + 1e-9) * 0.7
            rx = rx / (np.abs(rx).max() + 1e-9) * 0.7
            out += [rx, np.zeros(int(0.25 * sr)), ox, np.zeros(int(0.7 * sr))]
    y = np.concatenate(out)
    wavfile.write(os.path.join(HERE, "../docs/strokes_ab.wav"), sr, (y * 32767).astype(np.int16))
    print("docs/strokes_ab.wav", len(y) / sr, "s")


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "report"
    {"targets": targets_cmd, "report": report_cmd, "ab": ab_cmd}.get(cmd, lambda: fit(int(sys.argv[2]) if len(sys.argv) > 2 else 6))()
