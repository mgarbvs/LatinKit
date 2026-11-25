"""fit.py -- fit the pandeiro / tamborim engine to the recordings and print ref vs ours. Forked from Bongo/tests/fit.py (rows instead of drum x stroke, plus the jingle layer).

    python3 tests/fit.py targets          # what the recordings say, per table row
    python3 tests/fit.py fit [iters]      # adjust the mode gains W, damping G, the tick noise and the jingle coupling (jg, jk, js) in scripts/pandeiro_tables.json
    python3 tests/fit.py jg               # after calibrate.py: re-set the jingle level with the peaks calibrated (3 rounds with calibrate.py)
    python3 tests/fit.py report           # per row: ref vs ours (incl. `tail`: the rms dB difference of the band-envelope curves, tests/tail.py; tests/fit_tail.py fits it)
    python3 tests/fit.py roll [--write]   # the Roll: ROLL_REL (tap level) so the LF level of the sustained part matches; prints the band levels, tap rate, length
    python3 tests/fit.py ab               # docs/strokes_ab.wav: ref stroke, then ours, alternating (gitignored) + the cue list
The jingle constants (scripts/pandeiro_jingle.json) come from tests/jingle_fit.js first (Shake + Roll recordings); here only each row's coupling to them is fitted:
jg (level: the 6.5-16 kHz share of the first 40 ms), jk (build-up ms: when the 8-15.5 kHz envelope is within 4 dB of its peak), js (decay multiplier: its t20).
References: tests/refs.py. The previews are peak-normalised, so only shapes are compared, not loudness (tests/calibrate.py sets levels).
"""
import json
import os
import re
import sys
import warnings

import numpy as np
from scipy.io import wavfile

warnings.filterwarnings("ignore")
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import measure as M  # noqa: E402
import tail  # noqa: E402
from refs import load, ref_names, TAKE_SCALE, ROLL_REF  # noqa: E402

E = M.E
CODE = os.path.join(HERE, "_t.fit.genexpr")
FLOOR = -50.0       # the recordings' ring window sits on the room / noise floor below this (dB re the early total): not chased


def inst_of(row):
    return E.ROWS[row][0]


def ref_f1(inst, take):
    return E.F1[inst] * TAKE_SCALE[inst][take]


def fit_bands(row):
    """the bands the head fit may move (and the report judges): not the 125 Hz body (capped), and on the pandeiro not the two top noise bands (the jingles' range)"""
    use = np.ones(E.NM, bool)
    use[E.NH] = False
    if inst_of(row) == 0:
        use[E.NB0 + E.JOWN:] = False
    return use


def ref_profile(row):
    ps, bs = [], []
    for take, n in ref_names(row):
        sr, x = load(n)
        ps.append(M.profile(x, sr, inst_of(row), ref_f1(inst_of(row), take)))
        bs.append(M.broadband(x, sr))
    return ps, bs


def mean_profile(ps):
    return dict(early=np.mean([p["early"] for p in ps], 0), ring=np.mean([p["ring"] for p in ps], 0),
                hf=np.mean([p["hf"] for p in ps]), lf=np.mean([p["lf"] for p in ps]), jing=np.mean([p["jing"] for p in ps]))


def target(row):
    return mean_profile(ref_profile(row)[0])


def tick_target(row):
    """the contact tick before the tone: its centre (geometric Hz, 700..8000 of the first 1.8 ms) and the recordings' mean blip ratio, tone-start and crack"""
    cs, bl, ri, ck = [], [], [], []
    for take, n in ref_names(row):
        sr, x = load(n)
        on = M.onset(x, 0.05)
        seg = x[max(0, on - int(0.0003 * sr)):on + int(0.0015 * sr)]
        sp = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), 1 << 12)) ** 2
        f = np.fft.rfftfreq(1 << 12, 1 / sr)
        m = (f > 700) & (f < 8000)
        cs.append(np.exp((np.log(f[m]) * sp[m]).sum() / sp[m].sum()))
        b = M.broadband(x, sr)
        bl.append(b["blip"])
        ri.append(b["tone"])
        ck.append(b["crack"])
    return float(np.mean(cs)), float(np.mean(bl)), float(np.mean(ri)), float(np.mean(ck))


def write_code(tables, path=CODE, jitter=0):
    """jitter 0: the nominal stroke the fit and the tolerances are about; E.JITTER_DB: what is heard"""
    open(path, "w").write(E.code(tables, jitter=jitter))
    return path


def hit(row, vel=0.8, t=0.05):
    i, m = E.ROW_MENU[row]
    return (i, m, vel, t)


def model_profile(row, code, hits=3):
    """profile of the first hit, broadband = the median over `hits` hits 1.5 s apart (the tick's and the jingles' noise differ hit to hit)"""
    i, m = E.ROW_MENU[row]
    sr, x = M.render([(i, m, 0.8, 0.05 + 1.5 * k) for k in range(hits)], 1.5 * hits + 0.1, [], code=code)
    bbs = [M.broadband(x[int(1.5 * k * sr):int(1.5 * (k + 1) * sr)], sr, int(0.05 * sr)) for k in range(hits)]
    return M.profile(x[:int(1.4 * sr)], sr, i, E.F1[i]), {k: float(np.nanmedian([b[k] for b in bbs])) for k in bbs[0]}


BODY_CAP = -6.0
GRID_G = [1.0, 1.4, 2.0, 3.0, 4.5, 6.5, 9.0, 13.0]
GRID_TAU = [0.004, 0.007, 0.012, 0.02, 0.035, 0.06, 0.1]


def decay_cost(bb, mp, t, use):
    """how far the stroke's envelope decay (t20, t40) and its ring-window band levels are from the recordings'"""
    c = np.log2(bb["t20"] / t["t20"]) ** 2 + np.log2(bb["t40"] / t["t40"]) ** 2
    u = (t["early"] > -28) & (t["ring"] > FLOOR) & use
    return float(c + np.mean((mp["ring"][u] - t["ring"][u]) ** 2) / 100) if u.any() else float(c)


def search_decay(tabs, tg, near=False):
    """per row: the hand's damping (one G for the head and body modes, tau its duration) by grid search on t20, t40 and the ring-window levels
    (near: only the grid cells next to the current ones)."""
    for row, k in enumerate(E.KEYS):
        t = tg[row]
        g0, tau0 = tabs[k]["G"][0], tabs[k]["tau"]
        gi = min(range(len(GRID_G)), key=lambda i: abs(GRID_G[i] - g0))
        ti = min(range(len(GRID_TAU)), key=lambda i: abs(GRID_TAU[i] - tau0))
        best = None
        i, m = E.ROW_MENU[row]
        for g in (GRID_G[max(gi - 1, 0):gi + 2] if near else GRID_G):
            for tau in (GRID_TAU[max(ti - 1, 0):ti + 2] if near else GRID_TAU):
                tabs[k]["G"] = [g] * E.NN0 + [1.0] * (E.NM - E.NN0)
                tabs[k]["tau"] = tau
                sr, x = M.render([(i, m, 0.8, 0.05)], 0.5, [], code=write_code(tabs))
                c = decay_cost(M.broadband(x, sr, int(0.05 * sr)), M.profile(x, sr, i, E.F1[i]), t, fit_bands(row))
                if best is None or c < best[0]:
                    best = (c, g, tau)
        tabs[k]["G"] = [best[1]] * E.NN0 + [1.0] * (E.NM - E.NN0)
        tabs[k]["tau"] = best[2]


def fit(iters=6):
    tabs = E.default_tables() if os.environ.get("FRESH") else E.load_tables()
    tk = {r: tick_target(r) for r in range(E.NROW)}
    tg = {r: target(r) for r in range(E.NROW)}
    for r, t in tg.items():
        bs = ref_profile(r)[1]
        for key in ("t20", "t40", "hrise", "ht20", "ht30", "nt20"):
            t[key] = float(np.nanmean([b[key] for b in bs]))
    for r, k in enumerate(E.KEYS):
        tabs[k]["nf"] = round(tk[r][0], -1)
        tabs[k]["nq"] = 0.7
        if os.environ.get("FRESH"):     # seed the mode gains with the recordings' own band levels
            tabs[k]["W"] = [round(float(np.clip(v, -60, 0)), 1) for v in tg[r]["early"]]
            if k == "pan_shake":
                tabs[k]["jk"] = round(tg[r]["hrise"], 1)
        if inst_of(r) == 0:
            for b in range(E.NB0 + E.JOWN, E.NM):
                tabs[k]["W"][b] = -70.0
    for it in range(iters):
        code = write_code(tabs)
        worst = 0
        for r, k in enumerate(E.KEYS):
            T = tabs[k]
            mp, bb = model_profile(r, code)
            t = tg[r]
            use = fit_bands(r)
            use[E.NH] = True
            for b in range(E.NM):
                if not use[b]:
                    continue
                dlt = float(np.clip(t["early"][b] - mp["early"][b], -12, 12))
                worst = max(worst, abs(dlt))
                T["W"][b] = round(float(np.clip(T["W"][b] + 0.7 * dlt, -70, 12)), 1)
            # the 125 Hz body's band holds the finger's broadband low-frequency thump too; as a tone it ran away on Bongo: at most BODY_CAP dB over the strongest head mode
            T["W"][E.NH] = min(T["W"][E.NH], max(T["W"][:E.NH]) + BODY_CAP)
            if tk[r][1] > 0.12:
                T["nl"] = round(float(np.clip(T["nl"] * (tk[r][1] / bb["blip"]) ** 0.8, 0.001, 60)), 4)
            else:       # a stroke whose recordings start with the crack itself: the blip is no measure, the crack share is
                T["nl"] = round(float(np.clip(T["nl"] * 10 ** ((tk[r][3] - bb["crack"]) / 20 * 0.8), 0.001, 60)), 4)
            T["ta"] = round(float(np.clip(T["ta"] + 0.5e-3 * (tk[r][2] - bb["tone"]), 0.0001, 0.004)), 5)
            if np.isfinite(bb["nt20"]) and np.isfinite(t["nt20"]):      # the noise bands' decay (their t20 in 2-5 kHz)
                T["ns"] = round(float(np.clip(T["ns"] * (t["nt20"] / bb["nt20"]) ** 0.7, 0.15, 6)), 3)
            if inst_of(r) == 0:     # the jingle coupling: level (the 6.5-16 kHz share), build-up (when the 8-15.5 kHz envelope peaks), decay (its t20)
                T["jg"] = round(float(np.clip(T["jg"] * 10 ** ((t["jing"] - mp["jing"]) / 20 * 0.8), 0.01, 400)), 4)
                if np.isfinite(bb["hrise"]):
                    T["jk"] = round(float(np.clip(T["jk"] + 0.5 * (t["hrise"] - bb["hrise"]), 0.5, 80)), 2)
                if np.isfinite(bb["ht20"]) and np.isfinite(t["ht20"]):      # the envelope falls 20 and 30 dB in the recordings: the geometric mean of both ratios (an exponential cannot match both)
                    q = (t["ht20"] / bb["ht20"]) * ((t["ht30"] / bb["ht30"]) if np.isfinite(bb["ht30"]) and np.isfinite(t["ht30"]) else (t["ht20"] / bb["ht20"]))
                    T["js"] = round(float(np.clip(T["js"] * q ** 0.35, 0.25, 5)), 3)
        for r, k in enumerate(E.KEYS):      # the whole stroke's level is not fitted (calibrate.py sets it): the loudest head mode stays at 0 dB, the jingle keeps its balance to it
            m = max(tabs[k]["W"])
            tabs[k]["W"] = [round(w - m, 1) if w > -69.9 else w for w in tabs[k]["W"]]
            tabs[k]["jg"] = round(tabs[k]["jg"] * 10 ** (-m / 20), 4)
        if it == 3 or it >= 6:      # one full search, then near ones every iteration (the last operation is a search)
            search_decay(tabs, tg, near=it != 3)
        print(f"iter {it}: worst band error {worst:.1f} dB", flush=True)
    for _ in range(4):      # the jingle level alone, with the head fixed: the head's band errors move the total the share is taken of
        code = write_code(tabs)
        for r, k in enumerate(E.KEYS):
            if inst_of(r) == 0:
                mp, _ = model_profile(r, code)
                tabs[k]["jg"] = round(float(np.clip(tabs[k]["jg"] * 10 ** ((tg[r]["jing"] - mp["jing"]) / 20 * 0.9), 0.01, 400)), 4)
    json.dump(tabs, open(E.TABLES_PATH, "w"), indent=1)
    print("wrote", E.TABLES_PATH)


def fmt(a):
    return " ".join(f"{v:5.0f}" if np.isfinite(v) else "  nan" for v in a)


def targets_cmd():
    for r, k in enumerate(E.KEYS):
        inst = inst_of(r)
        print(f"\n== {k}  band centres Hz:", " ".join(f"{E.mode_freq(inst, m):5.0f}" for m in range(E.NM)))
        t = target(r)
        bs = ref_profile(r)[1]
        print(f"early {fmt(t['early'])}  hf {t['hf']:.0f} jing {t['jing']:.0f}\n  ring  {fmt(t['ring'])}")
        print(f"  rise {np.nanmean([b['rise'] for b in bs]):.2f} ms, t20 {np.nanmean([b['t20'] for b in bs]):.0f}, t40 {np.nanmean([b['t40'] for b in bs]):.0f} ms, "
              f"centroid {np.mean([b['centroid'] for b in bs]):.0f} Hz, crack {np.mean([b['crack'] for b in bs]):.1f} dB, HF peak {np.nanmean([b['hrise'] for b in bs]):.0f} ms t20 {np.nanmean([b['ht20'] for b in bs]):.0f} ms")


def report_cmd():
    code = write_code(E.load_tables())
    for r, k in enumerate(E.KEYS):
        t = target(r)
        mp, ob = model_profile(r, code)
        rb = ref_profile(r)[1]
        rr = {q: np.nanmean([b[q] for b in rb]) for q in rb[0]}
        use = (t["early"] > -30) & fit_bands(r)
        err = float(np.sqrt(np.mean((mp["early"][use] - t["early"][use]) ** 2)))
        print(f"{k:10s} profile rms {err:4.1f} dB ({int(use.sum())} bands)  rise {rr['rise']:.2f}/{ob['rise']:.2f} ms  t20 {rr['t20']:.0f}/{ob['t20']:.0f}  "
              f"t40 {rr['t40']:.0f}/{ob['t40']:.0f} ms  centroid {rr['centroid']:.0f}/{ob['centroid']:.0f} Hz  crack {rr['crack']:.1f}/{ob['crack']:.1f} dB  blip {rr['blip']:.2f}/{ob['blip']:.2f}  "
              f"onset-10dB {rr['on10']:.1f}/{ob['on10']:.1f} ms  tail {tail.curve_error(r, code):.1f} dB  tone {rr['tone']:.2f}/{ob['tone']:.2f}  jingle {t['jing']:.1f}/{mp['jing']:.1f} dB  HF peak {rr['hrise']:.0f}/{ob['hrise']:.0f} ms  HF t20 {rr['ht20']:.0f}/{ob['ht20']:.0f} t30 {rr['ht30']:.0f}/{ob['ht30']:.0f} ms  2-5k t20 {rr['nt20']:.0f}/{ob['nt20']:.0f} ms")


def roll_stats(x, sr):
    """the sustained part of a roll: mean level (dB re the stroke's full-band peak) of 150-900 Hz, 1-4 kHz, 7-15 kHz over 0.15-1.0 s after the onset, the strongest
    line (3-40 Hz) of the 150-900 Hz envelope (the tap rate), and the time the 5 ms envelope last stays within 30 dB of its peak"""
    from scipy.signal import butter, sosfilt
    on = M.onset(x)
    x = x[on:]
    w = max(2, int(sr * 0.005))
    env = np.sqrt(np.convolve(x ** 2, np.ones(w) / w, "same"))
    pk = env.max()
    out = {}
    for nm, lo, hi in (("lf", 150, 900), ("mid", 1000, 4000), ("hf", 7000, 15000)):
        y = sosfilt(butter(4, [lo / (sr / 2), min(hi, 0.45 * sr) / (sr / 2)], "band", output="sos"), x)
        e = np.sqrt(np.convolve(y ** 2, np.ones(w) / w, "same"))
        out[nm] = float(20 * np.log10(np.mean(e[int(0.15 * sr):int(1.0 * sr)] ** 2) ** 0.5 / pk + 1e-9))
        if nm == "lf":
            e2 = np.sqrt(np.convolve(y ** 2, np.ones(max(2, int(sr * 0.002))) / max(2, int(sr * 0.002)), "same"))[int(0.1 * sr):int(1.0 * sr)]
            e2 = e2 - e2.mean()
            sp = np.abs(np.fft.rfft(e2 * np.hanning(len(e2)), 1 << 16))
            fr = np.fft.rfftfreq(1 << 16, 1 / sr)
            m = (fr > 5) & (fr < 40)
            out["rate"] = float(fr[m][np.argmax(sp[m])])
    out["length"] = float(np.where(20 * np.log10(env / pk + 1e-9) > -30)[0][-1] / sr)
    return out


def jg_cmd():
    """after fit + calibrate: the jingle level (jg) again with the peaks calibrated -- calibrate scales A and jg together, and the jingle share it leaves is not the fitted one"""
    import subprocess
    tg = {r: target(r) for r in range(E.NROW) if inst_of(r) == 0}
    for _ in range(3):
        tabs = E.load_tables()
        code = write_code(tabs)
        for r, t in tg.items():
            mp, _ = model_profile(r, code)
            k = E.KEYS[r]
            tabs[k]["jg"] = round(float(np.clip(tabs[k]["jg"] * 10 ** ((t["jing"] - mp["jing"]) / 20 * 0.9), 0.01, 400)), 4)
        json.dump(tabs, open(E.TABLES_PATH, "w"), indent=1)
        subprocess.run([sys.executable, os.path.join(HERE, "calibrate.py")], check=True, stdout=subprocess.DEVNULL)


def roll_cmd():
    """two constants: ROLL_REL (the taps relative to the velocity: the 150-900 Hz level of the sustained part) then ROLL_J (the taps' jingle level: the 7-15 kHz level)"""
    sr, x = load(ROLL_REF)
    ref = roll_stats(x, sr)
    code = write_code(E.load_tables())

    def run(rel, j):
        E.ROLL_REL[0], E.ROLL_J = rel, j       # E.code() reads the module's constants
        open(code, "w").write(E.code(E.load_tables(), jitter=0))
        ours = []
        for k in range(3):       # the jingle noise differs run to run: the mean of 3 rolls
            o, y = M.render([(0, E.ROLL, 0.8, 0.05 + 2.0 * k)], 6.2, [], code=code)
            ours.append(roll_stats(y[int(2.0 * k * o):int((2.0 * k + 1.9) * o)], o))
        return {q: float(np.mean([r[q] for r in ours])) for q in ours[0]}
    mo = run(0.5, 1.0)
    print(f"ROLL_REL 0.5, ROLL_J 1: lf {mo['lf']:.1f} mid {mo['mid']:.1f} hf {mo['hf']:.1f} dB re peak (ref: lf {ref['lf']:.1f} mid {ref['mid']:.1f} hf {ref['hf']:.1f})")
    # the recording's jingle band sits (hf - lf) over its 150-900 Hz band: J scales the jingles against the head taps; REL then sets the loudness so that a tap's jingles are about a Finger's
    # (REL ** 1.4 x J = 1: velocity enters as vel ** 1.4)
    j = 10 ** (((ref["hf"] - ref["lf"]) - (mo["hf"] - mo["lf"])) / 20)
    rel = round(j ** (-1 / 1.4), 3)
    mo = run(rel, j)
    print(f"ROLL_REL {rel}, ROLL_J {j:.2f}: lf {mo['lf']:.1f} mid {mo['mid']:.1f} hf {mo['hf']:.1f} dB re peak, tap rate {mo['rate']:.1f} Hz, length {mo['length']:.2f} s   (ref: lf {ref['lf']:.1f} mid {ref['mid']:.1f} hf {ref['hf']:.1f}, "
          f"rate {ref['rate']:.1f} Hz, length {ref['length']:.2f} s)")
    if "--write" in sys.argv:
        p = os.path.join(HERE, "../scripts/pandeiro_engine.py")
        s = open(p).read()
        s = re.sub(r"^ROLL_REL = \[[\d.]+,", f"ROLL_REL = [{rel},", s, flags=re.M)
        s = re.sub(r"^ROLL_J = [\d.]+ ", f"ROLL_J = {j:.2f} ", s, flags=re.M)
        open(p, "w").write(s)
        print("ROLL_REL, ROLL_J patched in", p)


def ab_cmd():
    """docs/strokes_ab.wav: per row (and the Roll) the recording (take A) then ours (vel 0.8, Vary on), up to 1.8 s each; the cue list is printed"""
    from scipy.signal import resample_poly
    code = write_code(E.load_tables(), jitter=E.JITTER_DB)
    sr = 48000
    out, cues, t = [], [], 0.0
    items = [(r, E.ROW_MENU[r], ref_names(r)[0], E.ROWS[r][2], E.INSTRUMENTS[inst_of(r)]) for r in range(E.NROW)]
    items.insert(5, (None, (0, E.ROLL), ("A", ROLL_REF), "Roll", "Pandeiro"))
    for r, (i, m), (take, n), lab, iname in items:
        rsr, rx = load(n)
        rx = resample_poly(rx, sr, rsr) if rsr != sr else rx
        on = M.onset(rx)
        sec = 1.8 if lab == "Roll" else 1.2
        rx = rx[max(0, on - int(0.01 * sr)):][:int(sec * sr)]
        _, ox = M.render([(i, m, 0.8, 0.02)], sec + 0.1, [], code=code)
        ox = ox[:int(sec * sr)]
        ox = ox / (np.abs(ox).max() + 1e-9) * 0.7
        rx = rx / (np.abs(rx).max() + 1e-9) * 0.7
        cues.append(f"{t:6.2f} s  {iname} {lab}: recording (take {take})")
        seg = [rx, np.zeros(int(0.25 * sr))]
        t += (len(rx) / sr) + 0.25
        cues.append(f"{t:6.2f} s  {iname} {lab}: ours")
        seg += [ox, np.zeros(int(0.7 * sr))]
        t += (len(ox) / sr) + 0.7
        out += seg
    y = np.concatenate(out)
    wavfile.write(os.path.join(HERE, "../docs/strokes_ab.wav"), sr, (y * 32767).astype(np.int16))
    print("docs/strokes_ab.wav", round(len(y) / sr, 1), "s")
    print("\n".join(cues))


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "report"
    {"targets": targets_cmd, "report": report_cmd, "ab": ab_cmd, "roll": roll_cmd, "jg": jg_cmd}.get(cmd, lambda: fit(int(sys.argv[2]) if len(sys.argv) > 2 else 6))()
