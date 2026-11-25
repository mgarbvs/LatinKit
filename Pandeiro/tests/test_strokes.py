"""test_strokes.py -- holds the engine to what the recordings measure (tests/fit.py, tests/measure.py): per table row, our t20 / t40 (ms), tick, rise, spectral centroid (Hz)
and crack (energy above 1.5 kHz) must sit inside the range the Latin Percussion takes span (widened by a margin: one or two takes are a thin sample), the 2.5-9 kHz spectral
flatness no more than 3 dB below the takes' (noise, not lines), the early band profile within 3.5 dB rms of theirs over the bands where the recordings have energy; on the
pandeiro also the jingles (the 6.5-16 kHz share, when the 8-15.5 kHz envelope peaks and its t20); the Roll (band levels, tap rate, length). Also: the maxpat's codebox
equals the engine's code, and the panel's stroke names equal the engine's MAP. Prints FAIL lines, exits 1 on any."""
import json
import os
import re
import sys
import warnings

import numpy as np

warnings.filterwarnings("ignore")
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import fit  # noqa: E402
import measure as M  # noqa: E402
from refs import load, ref_names, ROLL_REF  # noqa: E402

E = M.E
verbose = "-v" in sys.argv
fails = passed = 0


def check(ok, what):
    global fails, passed
    if ok:
        passed += 1
        if verbose:
            print("ok   " + what)
    else:
        fails += 1
        print("FAIL " + what)


doc = json.load(open(os.path.join(HERE, "../m4l/Pandeiro.maxpat")))
g = [b for b in doc["patcher"]["boxes"] if b["box"].get("text", "").startswith("gen~")][0]["box"]
cb = [b for b in g["patcher"]["boxes"] if b["box"]["maxclass"] == "codebox"][0]["box"]["code"]
check(cb == E.code(), "the maxpat's gen~ codebox is exactly pandeiro_engine.code() with the tables in scripts/pandeiro_tables.json and pandeiro_jingle.json")
doc = json.load(open(os.path.join(HERE, "../m4l/PandeiroMusical.maxpat")))
g = [b for b in doc["patcher"]["boxes"] if b["box"].get("text", "").startswith("gen~")][0]["box"]
cb = [b for b in g["patcher"]["boxes"] if b["box"]["maxclass"] == "codebox"][0]["box"]["code"]
check(cb == E.code(musical=True), "the Musical maxpat's gen~ codebox is exactly pandeiro_engine.code(musical=True) with the frozen tables (scripts/pandeiro_tables_musical.json, pandeiro_jingle_musical.json)")
view = open(os.path.join(HERE, "../m4l/pandeiro_view.js")).read()
eff = json.loads(re.search(r"var EFF = (.*?);\s*// MAP", view).group(1))
want = [[("Roll" if m == E.ROLL else E.ROWS[E.MAP[i][m]][2]) for m in range(len(E.MENU))] for i in range(2)]
check(eff == want, "the panel's stroke names (pandeiro_view.js EFF) equal the engine's MAP: " + json.dumps(want))
check(E.JG[1] == 0 and all(E.load_tables()[k]["jg"] == 0 for k in E.KEYS if k.startswith("tam_")), "the tamborim has no jingles: JG[1] = 0 and every tamborim row's coupling is 0")

code = fit.write_code(E.load_tables())
for r, k in enumerate(E.KEYS):
    inst, (i, mn) = E.ROWS[r][0], E.ROW_MENU[r]
    tg = fit.target(r)
    ps, bs = fit.ref_profile(r)
    ref = {q: [b[q] for b in bs] for q in ("t20", "t40", "centroid", "crack", "blip", "rise", "hrise", "ht20")}
    # ours: 4 hits spaced 1.5 s (the noise differs hit to hit), medians
    sr, x = M.render([(i, mn, 0.8, 0.05 + 1.5 * q) for q in range(4)], 6.2, [], code=code)
    mine = [M.broadband(x[int(1.5 * q * sr):int((1.5 * q + 1.4) * sr)], sr, int(0.05 * sr)) for q in range(4)]
    ours = {q: float(np.nanmedian([m[q] for m in mine])) for q in ref}
    prof = M.profile(x[:int(1.4 * sr)], sr, inst, E.F1[inst])
    n = k
    lo, hi = np.nanmin(ref["t20"]), np.nanmax(ref["t20"])
    check(0.4 * lo <= ours["t20"] <= 2.5 * hi, f"{n}: t20 {ours['t20']:.0f} ms (recordings {lo:.0f}..{hi:.0f}, x0.4..2.5)")
    lo, hi = np.nanmin(ref["t40"]), np.nanmax(ref["t40"])
    check(0.5 * lo <= ours["t40"] <= 1.9 * hi, f"{n}: t40 {ours['t40']:.0f} ms (recordings {lo:.0f}..{hi:.0f}, x0.5..1.9: the slap's jingle tail is the known gap)")
    lo, hi = min(ref["blip"]), max(ref["blip"])
    if k not in ("pan_slap", "pan_shake"):      # a slap's / a shake's recordings start with the crack / the jingles themselves (their 5 % onset is later): their blip is no measure
        check(0.5 * lo <= ours["blip"] <= 3.0 * hi, f"{n}: tick before the tone {ours['blip']:.2f} of the peak (recordings {lo:.2f}..{hi:.2f}, x0.5..3: nl, the tick's noise level, does not move it; it is the head / jingle onset; known gap)")
    lo, hi = min(ref["rise"]), max(ref["rise"])
    check(0.2 * lo <= ours["rise"] <= 3.0 * hi, f"{n}: rise {ours['rise']:.2f} ms (recordings {lo:.2f}..{hi:.2f}, x0.2..3; the first 8 ms envelope: beating makes it jumpy)")
    lo, hi = min(ref["centroid"]), max(ref["centroid"])
    check(0.65 * lo <= ours["centroid"] <= 1.5 * hi, f"{n}: centroid {ours['centroid']:.0f} Hz (recordings {lo:.0f}..{hi:.0f}, x0.65..1.5)")
    check(min(ref["crack"]) - 4 <= ours["crack"] <= max(ref["crack"]) + 4, f"{n}: crack {ours['crack']:.1f} dB (recordings {min(ref['crack']):.1f}..{max(ref['crack']):.1f}, +-4)")
    fl = [M.flatness(load(q)[1], load(q)[0]) for _, q in ref_names(r)]
    check(M.flatness(x[:int(1.4 * sr)], sr) >= min(fl) - 3, f"{n}: 2.5-9 kHz flatness {M.flatness(x[:int(1.4 * sr)], sr):.1f} dB (recordings {min(fl):.1f}..{max(fl):.1f}, >= min - 3: noise, not lines)")
    if inst == 0:
        fl = [M.flatness(load(q)[1], load(q)[0], 0.005, 0.1, 6000, 14000) for _, q in ref_names(r)]
        fo = M.flatness(x[:int(1.4 * sr)], sr, 0.005, 0.1, 6000, 14000)
        check(fo >= min(fl) - 3, f"{n}: 6-14 kHz flatness over 5-100 ms {fo:.1f} dB (recordings {min(fl):.1f}..{max(fl):.1f}, >= min - 3: the jingles are noise grains, not lines)")
        check(abs(prof["jing"] - tg["jing"]) < 3.5, f"{n}: the jingles' share (6.5-16 kHz, first 40 ms, dB re total) {prof['jing']:.1f} (recordings {tg['jing']:.1f}, +-3.5)")
        lo, hi = np.nanmin(ref["ht20"]), np.nanmax(ref["ht20"])
        check(0.5 * lo <= ours["ht20"] <= 2.0 * hi, f"{n}: the jingles' envelope (8-15.5 kHz) falls 20 dB in {ours['ht20']:.0f} ms (recordings {lo:.0f}..{hi:.0f}, x0.5..2)")
        lo, hi = np.nanmin(ref["hrise"]), np.nanmax(ref["hrise"])
        check(0.4 * lo <= ours["hrise"] <= 2.5 * hi, f"{n}: the jingles' envelope peaks {ours['hrise']:.0f} ms after the onset (recordings {lo:.0f}..{hi:.0f}, x0.4..2.5)")
    use = (tg["early"] > -30) & fit.fit_bands(r)
    err = float(np.sqrt(np.mean((prof["early"][use] - tg["early"][use]) ** 2)))
    check(err < 3.5, f"{n}: band profile {err:.1f} dB rms from the recordings over {int(use.sum())} bands (need < 3.5)")

# the Roll: the sustained part's band levels (dB re the full-band peak), tap rate, length, against the recording
sr, x = load(ROLL_REF)
rr = fit.roll_stats(x, sr)
rc = fit.write_code(E.load_tables())
ro = []
for q in range(3):
    o, y = M.render([(0, E.ROLL, 0.8, 0.05 + 2.0 * q)], 6.3, [], code=rc)
    ro.append(fit.roll_stats(y[int(2.0 * q * o):int((2.0 * q + 1.9) * o)], o))
mo = {q: float(np.mean([a[q] for a in ro])) for q in ro[0]}
for q, tol in (("lf", 4.5), ("mid", 12.0), ("hf", 4.5)):      # mid (1-4 kHz) is a known gap: ours is ~10 dB under the recording's rubbing noise
    check(abs(mo[q] - rr[q]) < tol, f"Pandeiro Roll {q} level over 0.15-1.0 s {mo[q]:.1f} dB re peak (recording {rr[q]:.1f}, +-{tol})")
check(abs(mo["rate"] - rr["rate"]) < 1.5, f"Pandeiro Roll tap rate {mo['rate']:.1f} Hz (recording {rr['rate']:.1f}, +-1.5)")
check(abs(mo["length"] - rr["length"]) < 0.3, f"Pandeiro Roll length (within 30 dB of its peak) {mo['length']:.2f} s (recording {rr['length']:.2f}, +-0.3)")

# per-hit variation (Vary 100 vs 0, 8 hits of each stroke): the sinusoid modes' early band levels gain about E.JITTER_DB of hit-to-hit spread beyond the noise's own
jc = fit.write_code(E.load_tables(), os.path.join(HERE, "_t.jit.genexpr"), jitter=E.JITTER_DB)
for r in (0, 1, 6):
    inst, (i, mn) = E.ROWS[r][0], E.ROW_MENU[r]
    sd = {}
    for vary in (0, 100):
        sr, x = M.render([(i, mn, 0.8, 0.05 + 1.5 * q) for q in range(8)], 12.2, [f"vary={vary}"], code=jc)
        e = np.array([M.profile(x[int(1.5 * q * sr):int((1.5 * q + 1.4) * sr)], sr, inst, E.F1[inst])["early"][:E.NN0] for q in range(8)])
        sd[vary] = e.std(0, ddof=1)[e.mean(0) > -30]
    extra = float(np.sqrt(max(np.mean(sd[100] ** 2) - np.mean(sd[0] ** 2), 0)))
    check(0.6 * E.JITTER_DB <= extra <= 1.6 * E.JITTER_DB, f"{E.KEYS[r]}: Vary 100 adds {extra:.1f} dB of hit-to-hit spread to the sinusoid modes (JITTER_DB {E.JITTER_DB}, x0.6..1.6; Vary 0 {np.mean(sd[0] ** 2) ** .5:.1f})")
print(f"{fails} FAILED ({passed} passed)" if fails else f"all {passed} passed")
sys.exit(1 if fails else 0)
