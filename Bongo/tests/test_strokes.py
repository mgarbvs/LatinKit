"""test_strokes.py -- holds the engine to what the recordings measure (tests/fit.py, tests/measure.py): per drum and stroke, our t20 (ms), spectral
centroid (Hz) and crack (energy above 1.5 kHz) must sit inside the range the Latin Percussion takes A and B span (widened by a margin: 3 takes are a thin
sample), and the 2.5-9 kHz spectral flatness no more than 3 dB below the takes' (noise, not lines), and the early band profile must be within 3.5 dB rms of theirs over the bands where the recordings have energy. Also: the maxpat's codebox
equals the engine's code. Prints FAIL lines, exits 1 on any."""
import json
import os
import sys
import warnings

import numpy as np

warnings.filterwarnings("ignore")
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import fit  # noqa: E402
import measure as M  # noqa: E402
from refs import load, ref_names  # noqa: E402

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


doc = json.load(open(os.path.join(HERE, "../m4l/Bongo.maxpat")))
g = [b for b in doc["patcher"]["boxes"] if b["box"].get("text", "").startswith("gen~")][0]["box"]
cb = [b for b in g["patcher"]["boxes"] if b["box"]["maxclass"] == "codebox"][0]["box"]["code"]
check(cb == E.code(), "the maxpat's gen~ codebox is exactly bongo_engine.code() with the tables in scripts/bongo_tables.json")

code = fit.write_code(E.load_tables())
for s in E.STROKES:
    for d in range(2):
        tg = fit.target(d, s)
        ps, bs = fit.ref_profile(d, s)
        ref = {k: [b[k] for b in bs] for k in ("t20", "t40", "centroid", "crack", "blip", "rise")}
        si = E.STROKES.index(s)
        # ours: 4 hits spaced 1.5 s (the noise differs hit to hit), medians
        sr, x = M.render([(d, si, 0.8, 0.05 + 1.5 * k) for k in range(4)], 6.2, [], code=code)
        mine = [M.broadband(x[int(1.5 * k * sr):int((1.5 * k + 1.4) * sr)], sr, int(0.05 * sr)) for k in range(4)]
        ours = {k: float(np.median([m[k] for m in mine])) for k in ref}
        prof = M.profile(x[:int(1.4 * sr)], sr, d, E.F1[d])
        n = f"{E.DRUMS[d]} {s}"
        lo, hi = np.nanmin(ref["t20"]), np.nanmax(ref["t20"])
        check(0.4 * lo <= ours["t20"] <= 2.5 * hi, f"{n}: t20 {ours['t20']:.0f} ms (recordings {lo:.0f}..{hi:.0f}, x0.4..2.5)")
        lo, hi = np.nanmin(ref["t40"]), np.nanmax(ref["t40"])
        check(0.6 * lo <= ours["t40"] <= 1.6 * hi, f"{n}: t40 {ours['t40']:.0f} ms (recordings {lo:.0f}..{hi:.0f}, x0.6..1.6)")
        lo, hi = min(ref["blip"]), max(ref["blip"])
        if s != "slap":      # a slap's recordings start with the crack itself (their 5 % onset is 4-6 ms in), so their blip is no measure; fit.py fits its crack share instead
          check(0.5 * lo <= ours["blip"] <= 2.0 * hi, f"{n}: tick before the tone {ours['blip']:.2f} of the peak (recordings {lo:.2f}..{hi:.2f}, x0.5..2)")
        lo, hi = min(ref["rise"]), max(ref["rise"])
        check(0.2 * lo <= ours["rise"] <= 3.0 * hi, f"{n}: rise {ours['rise']:.2f} ms (recordings {lo:.2f}..{hi:.2f}, x0.2..3; the first 8 ms envelope: beating makes it jumpy)")
        lo, hi = min(ref["centroid"]), max(ref["centroid"])
        check(0.65 * lo <= ours["centroid"] <= 1.5 * hi, f"{n}: centroid {ours['centroid']:.0f} Hz (recordings {lo:.0f}..{hi:.0f}, x0.65..1.5)")
        check(min(ref["crack"]) - 4 <= ours["crack"] <= max(ref["crack"]) + 4, f"{n}: crack {ours['crack']:.1f} dB (recordings {min(ref['crack']):.1f}..{max(ref['crack']):.1f}, +-4)")
        fl = [M.flatness(load(n)[1], load(n)[0]) for _, n in ref_names(d, s)]
        check(M.flatness(x[:int(1.4 * sr)], sr) >= min(fl) - 3, f"{n}: 2.5-9 kHz flatness {M.flatness(x[:int(1.4 * sr)], sr):.1f} dB (recordings {min(fl):.1f}..{max(fl):.1f}, >= min - 3: noise, not lines)")
        use = tg["early"] > -30
        use[E.NH] = False        # the 125 Hz body band holds the finger's low-frequency thump: capped in the fit (BODY_CAP), not matched
        err = float(np.sqrt(np.mean((prof["early"][use] - tg["early"][use]) ** 2)))
        check(err < 3.5, f"{n}: band profile {err:.1f} dB rms from the recordings over {int(use.sum())} bands (need < 3.5)")
# per-hit variation (Vary 100 vs 0, 8 hits of each stroke): the sinusoid modes' early band levels gain about E.JITTER_DB of hit-to-hit spread beyond the
# noise's own. 
jc = fit.write_code(E.load_tables(), os.path.join(HERE, "_t.jit.genexpr"), jitter=E.JITTER_DB)
for d in range(2):
    for s in ("open", "heel", "tip"):
        si = E.STROKES.index(s)
        sd = {}
        for vary in (0, 100):
            sr, x = M.render([(d, si, 0.8, 0.05 + 1.5 * k) for k in range(8)], 12.2, [f"vary={vary}"], code=jc)
            e = np.array([M.profile(x[int(1.5 * k * sr):int((1.5 * k + 1.4) * sr)], sr, d, E.F1[d])["early"][:E.NN0] for k in range(8)])
            sd[vary] = e.std(0, ddof=1)[e.mean(0) > -30]
        extra = float(np.sqrt(max(np.mean(sd[100] ** 2) - np.mean(sd[0] ** 2), 0)))
        check(0.6 * E.JITTER_DB <= extra <= 1.6 * E.JITTER_DB, f"{E.DRUMS[d]} {s}: Vary 100 adds {extra:.1f} dB of hit-to-hit spread to the sinusoid modes (JITTER_DB {E.JITTER_DB}, x0.6..1.6; Vary 0 {np.mean(sd[0] ** 2) ** .5:.1f})")
print(f"{fails} FAILED ({passed} passed)" if fails else f"all {passed} passed")
sys.exit(1 if fails else 0)
