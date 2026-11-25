"""fit.py -- fit the agogo engine to the recordings (kit A) and print recording / ours.

    python3 tests/fit.py fit              # modes from tests/extract.py -> scripts/agogo_tables.json (levels, T60s, doublets), the Mute table derived, the tick fitted to the blip
    python3 tests/fit.py report           # per bell: recording A / ours (f0, doublet split, T60, centroid, t20, t40, rise, blip, flatness) and kits B, E measured only
    python3 tests/fit.py targets          # the modal table of each fitted recording
    python3 tests/fit.py ab               # docs/strokes_ab.wav: per bell the recording, ours Open, ours Mute (gitignored)
References: tests/refs.py (peak-normalised previews: levels come from tests/calibrate.py). B and E are different instruments: measured in `report`, never averaged in.
"""
import json
import math
import os
import sys
import warnings

import numpy as np
from scipy.io import wavfile

warnings.filterwarnings("ignore")
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import measure as M  # noqa: E402
from extract import extract  # noqa: E402
from refs import FIT, REFS, load  # noqa: E402

E = M.E
CODE = os.path.join(HERE, "_t.fit.genexpr")
T60_MAX = 2.0           # the pencil's tails run longer than the preview's 1.5-2 s: no table entry above this
MUTE_G = (12.0, 12.0, 6000.0)       # judgement: G = a + b * min(f / c, 1)
MUTE_TILT_DB_OCT = 2.0              # judgement: a hand on the bell takes this much per octave above 1 kHz out of the strike's spectrum
MUTE_KP, MUTE_TAU = 0.3, 1.5        # judgement: the ring already on the bell keeps 0.3; the hand's extra damping relaxes over 1.5 s


NEAR = {"Agogo_B_High": 1168.0, "Agogo_B_Mid": 1155.0, "Agogo_B_Low": 906.0, "Agogo_E_High": 1357.0, "Agogo_E_Low": 1009.0}     # each instrument's own fundamental (the user's hand measurement)


def write_code(tables, path=CODE, jitter=0):
    """jitter 0: the nominal stroke the fit and the tolerances are about; E.JITTER_DB: what is heard"""
    open(path, "w").write(E.code(tables, jitter=jitter))
    return path


def mode_table(d):
    """(f1, [(f, T60, dB at the hit)]) of the fitted recording of bell d, f1 the strongest mode"""
    sr, x, ms = extract(FIT[d])
    f1 = max((m for m in ms if m[0] < 4500 and m[1] > 0.3), key=lambda m: m[2])[0]      # the strongest ringing mode below 4.5 kHz: the bell's pitch
    return f1, ms


def tick_target(d):
    """the stick tick of the recording: its geometric centre (700..8000 Hz of the first 1.8 ms), the blip ratio and the 10 % -> -3 dB rise (ms)"""
    sr, x = load(FIT[d])
    on = M.onset(x)
    seg = x[max(0, on - int(0.0003 * sr)):on + int(0.0015 * sr)]
    sp = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), 1 << 12)) ** 2
    f = np.fft.rfftfreq(1 << 12, 1 / sr)
    m = (f > 700) & (f < 8000)
    bb = M.broadband(x, sr)
    return float(np.exp((np.log(f[m]) * sp[m]).sum() / sp[m].sum())), bb["blip"], bb["rise"]


def build_tables():
    T = E.default_tables()
    T["bells"], W = [], []
    for d in range(2):
        f1, ms = mode_table(d)
        ms = ms[:E.NS]
        pad = E.NS - len(ms)
        T["bells"].append(dict(f1=round(f1, 2), r=[round(f / f1, 5) for f, _, _ in ms] + [1.0] * pad, t60=[round(min(t, T60_MAX), 3) for _, t, _ in ms] + [0.1] * pad))
        W.append([l - E.contact_db(f, T["open"]["fc"] * E.FC_REF_SHIFT) for f, _, l in ms])
    for d in range(2):
        pad = E.NS - len(W[d])
        top = max(W[d])
        T["open"]["W"][d] = [round(w - top, 1) for w in W[d]] + [-200.0] * pad
        T["open"]["G"][d] = [1.0] * E.NS
        fs = [f1 * r for f1, r in ((T["bells"][d]["f1"], r) for r in T["bells"][d]["r"])]
        # Mute: the level the Open strike has at each mode, less MUTE_TILT_DB_OCT per octave above 1 kHz, and a duller contact (0.7 x the stick's bandwidth)
        T["mute"]["fc"] = T["open"]["fc"] * 0.7
        T["mute"]["W"][d] = [round(T["open"]["W"][d][m] - MUTE_TILT_DB_OCT * max(math.log2(fs[m] / 1000), 0), 1) if T["open"]["W"][d][m] > -100 else -200.0 for m in range(E.NS)]
        T["mute"]["G"][d] = [round(MUTE_G[0] + MUTE_G[1] * min(fs[m] / MUTE_G[2], 1), 2) for m in range(E.NS)]
    T["mute"].update(kp=MUTE_KP, tau=[MUTE_TAU, MUTE_TAU])
    return T


def model_broadband(d, stroke, code, hits=3):
    """median over `hits` hits 3 s apart (the tick's noise differs hit to hit): broadband measures and the first hit's samples"""
    sr, x = M.render([(d, stroke, 0.8, 0.05 + 3.0 * k) for k in range(hits)], 3.0 * hits + 0.1, [], code=code)
    bbs = [M.broadband(x[int(3.0 * k * sr):int(3.0 * (k + 1) * sr)], sr, int(0.05 * sr)) for k in range(hits)]
    return sr, x[:int(3.0 * sr)], {k: float(np.nanmedian([b[k] for b in bbs])) for k in bbs[0]}


def fit(iters=5):
    T = build_tables()
    for d in range(2):
        nf, blip, rise = tick_target(d)
        T["open"]["nf"] = round(nf, -1) if d == 0 else T["open"]["nf"]      # one tick centre per stroke: the High bell's (the bells' ticks are alike)
        for s in ("open", "mute"):
            T[s]["nl"][d] = 0.05
    T["mute"]["nf"] = T["open"]["nf"]
    for it in range(iters):
        code = write_code(T)
        worst = 0.0
        for d in range(2):
            _, blip_t, rise_t = tick_target(d)
            _, _, bb = model_broadband(d, 0, code)
            ratio = blip_t / max(bb["blip"], 1e-6)
            rr = rise_t / max(bb["rise"], 0.05)
            worst = max(worst, abs(math.log2(ratio)), abs(math.log2(rr)))
            T["open"]["nl"][d] = round(float(np.clip(T["open"]["nl"][d] * ratio ** 0.8, 0.001, 60)), 4)
            T["open"]["ta"][d] = round(float(np.clip(T["open"]["ta"][d] * rr ** 0.7, 0.0001, 0.004)), 5)
            T["mute"]["nl"][d] = round(T["open"]["nl"][d] * 0.7, 4)
            T["mute"]["ta"][d] = T["open"]["ta"][d]
        print(f"iter {it}: worst blip / rise error x{2 ** worst:.2f}", flush=True)
    json.dump(T, open(E.TABLES_PATH, "w"), indent=1)
    print("wrote", E.TABLES_PATH)


def targets_cmd():
    for d in range(2):
        f1, ms = mode_table(d)
        print(f"\n== {E.BELLS[d]} ({FIT[d]}), f1 {f1:.1f} Hz, {len(ms)} modes")
        for f, t, l in ms:
            print(f"  {f:8.1f} Hz  r {f / f1:6.3f}  T60 {t:5.2f} s  {l:6.1f} dB")


def ref_row(name, near, span=0.12):
    sr, x = load(name)
    r = {**M.tonal(x, sr, near, span=span), **M.broadband(x, sr)}
    r["flat"] = M.flatness(x, sr)
    return r


def report_cmd():
    T = E.load_tables()
    code = write_code(T)
    print("recording A / ours (Open, vel 0.8, Vary off); then kits B and E, recordings only (different instruments, not fitted)")
    for d in range(2):
        f1 = T["bells"][d]["f1"]
        r = ref_row(FIT[d], f1)
        sr, x, bb = model_broadband(d, 0, code)
        on = int(0.05 * sr)
        o = {**M.tonal(x, sr, f1, on), **bb, "flat": M.flatness(x, sr, on=on)}
        sr, xm, bm = model_broadband(d, 1, code)
        mt = M.t60_of(xm, sr, o["f0"], on)
        print(f"{E.BELLS[d]:4s} A  f0 {r['f0']:7.1f}/{o['f0']:7.1f} Hz  split {r['split']:5.1f}/{o['split']:5.1f} Hz  tail peak {r['tail']:7.1f}/{o['tail']:7.1f} Hz  T60 {r['t60']:4.2f}/{o['t60']:4.2f} s  centroid {r['centroid']:5.0f}/{o['centroid']:5.0f} Hz  "
              f"t20 {r['t20']:3.0f}/{o['t20']:3.0f}  t40 {r['t40']:3.0f}/{o['t40']:3.0f} ms  rise {r['rise']:.2f}/{o['rise']:.2f} ms  blip {r['blip']:.2f}/{o['blip']:.2f}  flatness {r['flat']:5.1f}/{o['flat']:5.1f} dB   (Mute T60 {mt:.2f} s)")
    for n, (bell, kit) in REFS.items():
        if kit == "A":
            continue
        near = NEAR[n[3:]]
        r = ref_row(n, near, 0.04)
        print(f"{n[3:]:14s} f0 {r['f0']:7.1f} Hz  split {r['split']:5.1f} Hz  tail peak {r['tail']:7.1f} Hz  T60 {r['t60']:4.2f} s  centroid {r['centroid']:5.0f} Hz  t20 {r['t20']:3.0f} t40 {r['t40']:3.0f} ms  blip {r['blip']:.2f}  flatness {r['flat']:5.1f} dB")


def ab_cmd():
    """docs/strokes_ab.wav: per bell the recording (kit A), then ours Open, then ours Mute (no recording of a mute exists), 2 s each; the cue list is printed"""
    from scipy.signal import resample_poly
    code = write_code(E.load_tables(), jitter=E.JITTER_DB)
    sr = 48000
    out, cues, t = [], [], 0.0
    for d in range(2):
        rsr, rx = load(FIT[d])
        rx = resample_poly(rx, sr, rsr) if rsr != sr else rx
        on = M.onset(rx)
        rx = rx[max(0, on - int(0.01 * sr)):][:int(2.0 * sr)]
        segs = [(f"{E.BELLS[d]} open: recording (kit A)", rx)]
        for s, lab in ((0, "ours Open"), (1, "ours Mute")):
            _, ox = M.render([(d, s, 0.8, 0.02)], 2.2, [], code=code)
            segs.append((f"{E.BELLS[d]} {lab.split()[1].lower()}: ours" + (" (no recording of a mute exists)" if s else ""), ox[:int(2.0 * sr)]))
        for lab, y in segs:
            y = y / (np.abs(y).max() + 1e-9) * 0.7
            cues.append(f"{t:6.2f} s  {lab}")
            out += [y, np.zeros(int(0.6 * sr))]
            t += len(y) / sr + 0.6
    y = np.concatenate(out)
    wavfile.write(os.path.join(HERE, "../docs/strokes_ab.wav"), sr, (y * 32767).astype(np.int16))
    print("docs/strokes_ab.wav", round(len(y) / sr, 1), "s")
    print("\n".join(cues))


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "report"
    {"targets": targets_cmd, "report": report_cmd, "ab": ab_cmd}.get(cmd, lambda: fit(int(sys.argv[2]) if len(sys.argv) > 2 else 5))()
