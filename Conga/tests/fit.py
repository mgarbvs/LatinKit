"""fit.py -- fit the conga engine to the recordings and print ref vs ours.

    python3 tests/fit.py targets          # what the recordings say, per stroke (band profile, T60s, attack, decay, centroid)
    python3 tests/fit.py fit [iters]      # adjust mode gains W and damping G in scripts/conga_tables.json until the band profiles match
    python3 tests/fit.py report           # per stroke and drum: ref vs ours
    python3 tests/fit.py ab               # docs/strokes_ab.wav: ref stroke, then ours, alternating (gitignored)
References: Latin Percussion pack Drum Hits previews (quinto / conga / tumba, takes A B C, open / mute / slap / slap mute / heel / tip) and
Ableton's Core Library "Conga *" one-shots (tests/refs.py). The previews are peak-normalised, so only shapes are compared, not loudness.
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
from refs import REFS, load  # noqa: E402

E = M.E
DRUM_NAMES = ["Quinto", "Conga", "Tumba"]
# stroke -> the recordings that define it. "lp <drum> <take> <name>"; bass has no recording (see TARGET_EDITS)
SRC = {"open": ["Open"], "slap": ["Slap Open", "Slap", "Slap Mute"], "mute": ["Mute"], "heel": ["Heel"], "toe": ["Tip"]}
CODE = "/tmp/conga_fit.genexpr"


def ref_names(drum, stroke):
    out = []
    for take in "ABC":
        for nm in SRC.get(stroke, []):
            n = f"lp {drum} {take} {nm}"
            if n in REFS:
                out.append((take, n))
    return out


def ref_f1(drum, take):
    """the open tone of that take of that drum"""
    sr, x = load(f"lp {drum} {take} Open")
    return M.f1_of(x, sr, E.F1[DRUM_NAMES.index(drum)])


def ref_profile(drum, stroke):
    ps, bs = [], []
    for take, n in ref_names(drum, stroke):
        sr, x = load(n)
        f1 = ref_f1(drum, take)
        ps.append(M.profile(x, sr, f1))
        bs.append(M.broadband(x, sr))
    return ps, bs


def mean_profile(ps):
    return dict(early=np.mean([p["early"] for p in ps], 0), ring=np.mean([p["ring"] for p in ps], 0),
                hf=np.mean([p["hf"] for p in ps]), lf=np.mean([p["lf"] for p in ps]),
                t60=np.exp(np.nanmean(np.log([p["t60"] for p in ps]), 0)))


def bass_target(heel):
    """no recording of a bass stroke (palm in the centre) exists here: the heel's profile, low modes up, everything above the open tone down"""
    p = {k: np.array(v, dtype=float) if hasattr(v, "__len__") else v for k, v in heel.items()}
    for b, u in enumerate(M.U):
        tilt = 6.0 if u < 0.6 else (0.0 if u < 1.0 else -8.0)
        p["early"][b] += tilt
        p["ring"][b] += tilt
    return p


def noise_target(stroke):
    """the contact tick: where the recordings' energy above 1.5 kHz sits (geometric centre, Hz) and how big it is (dB re the early energy)"""
    src = "heel" if stroke == "bass" else stroke
    cs, ks = [], []
    for d in DRUM_NAMES:
        for take, n in ref_names(d, src):
            sr, x = load(n)
            on = M.onset(x)
            seg = x[on:on + int(0.04 * sr)]
            sp = np.abs(np.fft.rfft(seg * np.hanning(len(seg)), 1 << 14)) ** 2
            f = np.fft.rfftfreq(1 << 14, 1 / sr)
            m = (f > 1500) & (f < 10000)
            cs.append(np.exp((np.log(f[m]) * sp[m]).sum() / sp[m].sum()))
            ks.append(M.broadband(x, sr)["crack"])
    return float(np.mean(cs)), float(np.mean(ks))


def shared_target(stroke):
    """band profile shared by the three drums (the engine's mode gains are per stroke, not per drum)"""
    if stroke == "bass":
        return bass_target(shared_target("heel"))
    allp = []
    for d in DRUM_NAMES:
        allp += ref_profile(d, stroke)[0]
    return mean_profile(allp)


def render_stroke(drum, stroke, code, vel=0.8, sec=1.2, params=()):
    s = E.STROKES.index(stroke)
    sr, x = M.render([(drum * 6 + s, vel, 0.05)], sec, params, code=code)
    return sr, x


def write_code(tables, path=CODE):
    open(path, "w").write(E.code(tables))
    return path


def model_profile(stroke, code):
    ps = []
    for d in range(3):
        sr, x = render_stroke(d, stroke, code)
        ps.append((M.profile(x, sr, E.F1[d]), M.broadband(x, sr)))
    return mean_profile([p for p, _ in ps]), [b for _, b in ps]


def fit(iters=6):
    tabs = E.load_tables()
    targets = {s: shared_target(s) for s in E.STROKES}
    nt = {s: noise_target(s) for s in E.STROKES}
    for s in E.STROKES:
        tabs[s]["nf"] = round(nt[s][0], -1)
        tabs[s]["nq"] = 0.35
        tabs[s]["nt"] = 0.006 if s == "slap" else 0.003
        tabs[s]["nl"] = tabs[s]["nl"] or 0.1
        for b in range(10, M.NB):
            tabs[s]["W"][b] = min(tabs[s]["W"][b], -20.0)
    for it in range(iters):
        code = write_code(tabs)
        worst = 0
        for s in E.STROKES:
            T = tabs[s]
            mp, bb = model_profile(s, code)
            ck = float(np.mean([b["crack"] for b in bb]))
            T["nl"] = round(float(np.clip(T["nl"] * 10 ** ((nt[s][1] - ck) / 20 * 0.8), 0.001, 20)), 4)
            tg = targets[s]
            # band offsets, early: raise or lower the mode's gain; where the band is empty in both, leave it
            for b in range(M.NB):
                d = tg["early"][b] - mp["early"][b]
                d = float(np.clip(d, -12, 12))
                worst = max(worst, abs(d))
                T["W"][b] = round(float(np.clip(T["W"][b] + 0.7 * d, -70, 12)), 1)
                # decay: the ring window against the early window (the band T60 regression reads the room's tail in empty bands), only where
                # the band holds a mode, i.e. is within 28 dB of the total
                if tg["early"][b] > -28 and mp["early"][b] > -40:
                    tdr, mdr = tg["ring"][b] - tg["early"][b], mp["ring"][b] - mp["early"][b]
                    if tdr < -3 and mdr < -3:
                        T["G"][b] = round(float(np.clip(T["G"][b] * (tdr / mdr) ** 0.7, 0.25, 8)), 2)
        # level of the whole stroke is not fitted: renormalise W so the loudest mode of 'open' stays at 0 dB (the engine's levels are LEVEL_DB)
        for s in E.STROKES:
            m = max(tabs[s]["W"])
            tabs[s]["W"] = [round(w - m, 1) for w in tabs[s]["W"]]
        print(f"iter {it}: worst band error {worst:.1f} dB")
    json.dump(tabs, open(E.TABLES_PATH, "w"), indent=1)
    print("wrote", E.TABLES_PATH)


def fmt(a):
    return " ".join(f"{v:5.0f}" if np.isfinite(v) else "  nan" for v in a)


def targets_cmd():
    print("band centres u:", " ".join(f"{u:5.2f}" for u in M.U))
    for s in E.STROKES:
        tg = shared_target(s)
        print(f"\n{s}\n early dB {fmt(tg['early'])}   hf {tg['hf']:.0f} lf {tg['lf']:.0f}\n ring  dB {fmt(tg['ring'])}\n t60 ms   {fmt(tg['t60'] * 1000)}")
        if s in SRC:
            for d in DRUM_NAMES:
                bs = ref_profile(d, s)[1]
                print(f"   {d}: attack {np.mean([b['attack'] for b in bs]):.1f} ms, t20 {np.nanmean([b['t20'] for b in bs]):.0f}, t40 {np.nanmean([b['t40'] for b in bs]):.0f} ms, "
                      f"centroid {np.mean([b['centroid'] for b in bs]):.0f} Hz, crack {np.mean([b['crack'] for b in bs]):.1f} dB")


def report_cmd():
    code = write_code(E.load_tables())
    for s in E.STROKES:
        tg = shared_target(s)
        mp, bb = model_profile(s, code)
        print(f"\n== {s}")
        print(f" band u      {' '.join(f'{u:5.2f}' for u in M.U)}")
        print(f" ref early   {fmt(tg['early'])}\n our early   {fmt(mp['early'])}")
        print(f" ref ring    {fmt(tg['ring'])}\n our ring    {fmt(mp['ring'])}")
        print(f" ref t60 ms  {fmt(tg['t60'] * 1000)}\n our t60 ms  {fmt(mp['t60'] * 1000)}")
        for i, d in enumerate(DRUM_NAMES):
            if s in SRC:
                rb = ref_profile(d, s)[1]
                r = {k: np.nanmean([b[k] for b in rb]) for k in rb[0]}
                o = bb[i]
                print(f" {d:6s} ref/ours: attack {r['attack']:.1f}/{o['attack']:.1f} ms  t20 {r['t20']:.0f}/{o['t20']:.0f}  t40 {r['t40']:.0f}/{o['t40']:.0f} ms  "
                      f"centroid {r['centroid']:.0f}/{o['centroid']:.0f} Hz  crack {r['crack']:.1f}/{o['crack']:.1f} dB")


def ab_cmd():
    code = write_code(E.load_tables())
    sr = 48000
    out = []
    from scipy.signal import resample_poly
    for d, dn in enumerate(DRUM_NAMES):
        for s in E.STROKES:
            if s not in SRC:
                continue
            names = ref_names(dn, s)
            if not names:
                continue
            take, n = names[0]
            rsr, rx = load(n)
            rx = resample_poly(rx, sr, rsr) if rsr != sr else rx
            on = M.onset(rx)
            rx = rx[max(0, on - int(0.01 * sr)):][:int(1.0 * sr)]
            f1r = ref_f1(dn, take)
            _, ox = M.render([(d * 6 + E.STROKES.index(s), 0.8, 0.02)], 1.1, [f"tune{'QCT'[d]}={12 * np.log2(f1r / E.F1[d]):.3f}"], code=code)
            ox = ox[:int(1.0 * sr)]
            ox = ox / (np.abs(ox).max() + 1e-9) * 0.7
            rx = rx / (np.abs(rx).max() + 1e-9) * 0.7
            out += [rx, np.zeros(int(0.25 * sr)), ox, np.zeros(int(0.7 * sr))]
    y = np.concatenate(out)
    wavfile.write(os.path.join(HERE, "../docs/strokes_ab.wav"), sr, (y * 32767).astype(np.int16))
    print("docs/strokes_ab.wav", len(y) / sr, "s")


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "report"
    {"targets": targets_cmd, "report": report_cmd, "ab": ab_cmd}.get(cmd, lambda: fit(int(sys.argv[2]) if len(sys.argv) > 2 else 6))()
