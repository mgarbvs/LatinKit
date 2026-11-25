"""test_strokes.py -- holds the engine to what the recording of each stroke measures (tests/fit.py, tests/measure.py): our t20 / t40 (ms), rise, tick, spectral centroid (Hz)
and crack (energy above 1.5 kHz) must sit near the Latin Percussion take (a margin: one take is a thin sample), the 2.5-9 kHz spectral flatness no more than 3 dB below
the take's (noise, not lines) and its level there within 15 dB, the early band profile within 3.5 dB rms over the bands where the recording has energy, the Open's pitch glide within a
factor 1.5. Also: the maxpat's codebox equals the engine's code. Prints FAIL lines, exits 1 on any."""
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


doc = json.load(open(os.path.join(HERE, "../m4l/Surdo.maxpat")))
g = [b for b in doc["patcher"]["boxes"] if b["box"].get("text", "").startswith("gen~")][0]["box"]
cb = [b for b in g["patcher"]["boxes"] if b["box"]["maxclass"] == "codebox"][0]["box"]["code"]
check(cb == E.code(), "the maxpat's gen~ codebox is exactly surdo_engine.code() with the tables in scripts/surdo_tables.json")

code = fit.write_code(E.load_tables())
SP = M.SPACE
for s in E.STROKES:
    tg = fit.target(s)
    ps, bs = fit.ref_profile(s)
    ref = {k: [b[k] for b in bs] for k in ("t20", "t40", "centroid", "crack", "blip", "rise", "tone")}
    si = E.STROKES.index(s)
    # ours: 4 hits spaced SPACE s (the noise differs hit to hit), medians
    sr, x = M.render([(si, 0.8, 0.05 + SP * k) for k in range(4)], SP * 4 + 0.2, [], code=code)
    mine = [M.broadband(x[int(SP * k * sr):int((SP * k + SP - 0.1) * sr)], sr, int(0.05 * sr)) for k in range(4)]
    ours = {k: float(np.median([m[k] for m in mine])) for k in ref}
    prof = M.profile(x[:int((SP - 0.1) * sr)], sr)
    lo, hi = np.nanmin(ref["t20"]), np.nanmax(ref["t20"])
    check(0.4 * lo <= ours["t20"] <= 2.5 * hi, f"{s}: t20 {ours['t20']:.0f} ms (recording {lo:.0f}, x0.4..2.5)")
    lo, hi = np.nanmin(ref["t40"]), np.nanmax(ref["t40"])
    check(0.6 * lo <= ours["t40"] <= 2.0 * hi, f"{s}: t40 {ours['t40']:.0f} ms (recording {lo:.0f}, x0.6..2)")
    lo, hi = min(ref["blip"]), max(ref["blip"])
    check(0.3 * lo <= ours["blip"] <= 3.0 * hi, f"{s}: tick before the tone {ours['blip']:.2f} of the peak (recording {lo:.2f}, x0.3..3)")
    lo, hi = min(ref["rise"]), max(ref["rise"])
    check(0.2 * lo <= ours["rise"] <= 3.5 * hi, f"{s}: rise {ours['rise']:.2f} ms (recording {lo:.2f}, x0.2..3.5)")
    lo, hi = min(ref["centroid"]), max(ref["centroid"])
    check(0.65 * lo <= ours["centroid"] <= 1.5 * hi, f"{s}: centroid {ours['centroid']:.0f} Hz (recording {lo:.0f}, x0.65..1.5)")
    check(min(ref["crack"]) - 12 <= ours["crack"] <= max(ref["crack"]) + 12, f"{s}: crack {ours['crack']:.1f} dB (recording {min(ref['crack']):.1f}, +-12: the Open's and Mute's are 35-42 dB down, i.e. nothing)")
    rsr, rx = load(ref_names(s)[0])
    fl, hf = M.flatness(rx, rsr), M.hf_level(rx, rsr)
    ofl, ohf = M.flatness(x[:int((SP - 0.1) * sr)], sr), M.hf_level(x[int(0.05 * sr):int((SP - 0.1) * sr)], sr)
    check(ofl >= fl - 3 or hf < -30, f"{s}: 2.5-9 kHz flatness {ofl:.1f} dB (recording {fl:.1f}; >= recording - 3: noise, not lines; waived where the band is under -30 dB re total, as the Open's {hf:.0f} dB)")
    check(abs(ohf - hf) < 15, f"{s}: 2.5-9 kHz level {ohf:.0f} dB re total (recording {hf:.0f}, +-15: the Mute's is the known gap)")
    use = tg["early"] > -30
    err = float(np.sqrt(np.mean((prof["early"][use] - tg["early"][use]) ** 2)))
    check(err < 3.5, f"{s}: band profile {err:.1f} dB rms from the recording over {int(use.sum())} bands (need < 3.5)")
    if s == "open":
        rg, og = fit.glide(rx, rsr), fit.glide(x[:int((SP - 0.1) * sr)], sr, int(0.05 * sr))
        check(rg / 1.5 <= og <= rg * 1.5, f"open: glide f(40-100 ms) / f(200-290 ms) = {og * 100:.2f} % (recording {rg * 100:.2f} %, x0.67..1.5)")
# per-hit variation (Vary 100 vs 0, 8 hits of each stroke): the sinusoid modes' early band levels gain about E.JITTER_DB of hit-to-hit spread beyond the noise's own.
jc = fit.write_code(E.load_tables(), os.path.join(HERE, "_t.jit.genexpr"), jitter=E.JITTER_DB)
for s in ("open", "mute", "finger"):
    si = E.STROKES.index(s)
    sd = {}
    for vary in (0, 100):
        sr, x = M.render([(si, 0.8, 0.05 + SP * k) for k in range(8)], SP * 8 + 0.2, [f"vary={vary}"], code=jc)
        e = np.array([M.profile(x[int(SP * k * sr):int((SP * k + SP - 0.1) * sr)], sr)["early"][:E.NN0] for k in range(8)])
        sd[vary] = e.std(0, ddof=1)[e.mean(0) > -30]
    extra = float(np.sqrt(max(np.mean(sd[100] ** 2) - np.mean(sd[0] ** 2), 0)))
    check(0.6 * E.JITTER_DB <= extra <= 1.6 * E.JITTER_DB, f"{s}: Vary 100 adds {extra:.1f} dB of hit-to-hit spread to the sinusoid modes (JITTER_DB {E.JITTER_DB}, x0.6..1.6; Vary 0 {np.mean(sd[0] ** 2) ** .5:.1f})")
print(f"{fails} FAILED ({passed} passed)" if fails else f"all {passed} passed")
sys.exit(1 if fails else 0)
