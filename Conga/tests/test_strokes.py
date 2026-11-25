"""test_strokes.py -- holds the engine's strokes to what the recordings measure (tests/fit.py, tests/measure.py): per drum and stroke, our
t40 (ms), spectral centroid (re the drum's open tone) and crack (energy above 1.5 kHz) must sit inside the range the Latin Percussion takes
A B C span (widened by a margin: 3 takes are a thin sample), and the band profile must be within 5 dB rms of theirs where the recordings
have energy. Bass has no recording: it is held to its physical role (low centroid, low band dominant). Prints FAIL lines, exits 1 on any."""
import os
import sys
import warnings

import numpy as np

warnings.filterwarnings("ignore")
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import fit  # noqa: E402
import measure as M  # noqa: E402

E = M.E
verbose = "-v" in sys.argv
fails = 0
passed = 0


def check(ok, what):
    global fails, passed
    if ok:
        passed += 1
        if verbose:
            print("ok   " + what)
    else:
        fails += 1
        print("FAIL " + what)


code = fit.write_code(E.load_tables())
for s in E.STROKES:
    if s == "bass":
        continue
    tg = fit.shared_target(s)
    for d, dn in enumerate(fit.DRUM_NAMES):
        ps, bs = fit.ref_profile(dn, s)
        ref = {k: [b[k] for b in bs] for k in ("t40", "centroid", "crack")}
        f1s = [fit.ref_f1(dn, t) for t, _ in fit.ref_names(dn, s)]
        # ours: 4 hits spaced 1.5 s (the noise differs hit to hit), medians
        sr, x = M.render([(d * 6 + E.STROKES.index(s), 0.8, 0.05 + 1.5 * k) for k in range(4)], 6.2, ["spread=0"], code=code)
        mine = [M.broadband(x[int(1.5 * k * sr):int((1.5 * k + 1.4) * sr)], sr) for k in range(4)]
        ours = {k: float(np.median([m[k] for m in mine])) for k in ("t40", "centroid", "crack")}
        prof = M.profile(x[:int(1.4 * sr)], sr, E.F1[d])
        lo, hi = np.nanmin(ref["t40"]), np.nanmax(ref["t40"])
        check(0.6 * lo <= ours["t40"] <= 1.6 * hi, f"{dn} {s}: t40 {ours['t40']:.0f} ms (recordings {lo:.0f}..{hi:.0f}, x0.6..1.6)")
        c = np.array(ref["centroid"]) / np.array(f1s)
        co = ours["centroid"] / E.F1[d]
        check(0.65 * c.min() <= co <= 1.5 * c.max(), f"{dn} {s}: centroid {co:.2f} f1 (recordings {c.min():.2f}..{c.max():.2f}, x0.65..1.5)")
        check(min(ref["crack"]) - 6 <= ours["crack"] <= max(ref["crack"]) + 6, f"{dn} {s}: crack {ours['crack']:.1f} dB (recordings {min(ref['crack']):.1f}..{max(ref['crack']):.1f}, +-6)")
        use = tg["early"] > -30
        err = float(np.sqrt(np.mean((prof["early"][use] - tg["early"][use]) ** 2)))
        check(err < 5.0, f"{dn} {s}: band profile {err:.1f} dB rms from the recordings over {int(use.sum())} bands (need < 5)")
# bass: no recording of a palm in the centre; the heel's, shifted low
for d, dn in enumerate(fit.DRUM_NAMES):
    sr, x = M.render([(d * 6 + 3, 0.8, 0.05)], 1.4, ["spread=0"], code=code)
    p = M.profile(x, sr, E.F1[d])
    b = M.broadband(x, sr)
    low = 10 * np.log10(np.sum(10 ** (p["early"][:4] / 10)))      # u <= 1.0: bands 0..3 (body modes, head 0.8 and 1.0)
    hi = 10 * np.log10(np.sum(10 ** (p["early"][4:] / 10)))
    check(b["centroid"] / E.F1[d] < 0.9 and low > hi, f"{dn} bass: centroid {b['centroid'] / E.F1[d]:.2f} f1 (< 0.9), energy up to the open tone {low:.1f} dB vs above {hi:.1f} dB")
print(f"{fails} FAILED ({passed} passed)" if fails else f"all {passed} passed")
sys.exit(1 if fails else 0)
