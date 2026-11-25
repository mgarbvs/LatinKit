"""fit_tail.py -- fit each row's decay to the recordings' band-envelope curves (tests/tail.py): the tones' T60 (S per mode group, G / tau the hand's damping), the noise bands' T60 (S) and level
(W), and on the pandeiro the jingles (jg level, jk build-up, js decay, jq late fall). Powell on the weighted rms dB difference of the curves, plus a term for the first 40 ms band profile (so the
onset spectrum the earlier fit set is kept) and a pull to the starting values. Kit only (the Musical device reads its own frozen tables).

    python3 tests/fit_tail.py <row|all> [maxiter]      # -> tests/_tail_<row>.json (the fitted row entry); `all` runs the rows in parallel
    python3 tests/fit_tail.py merge                    # write the fitted rows into scripts/pandeiro_tables.json (then: calibrate.py, fit.py jg)
"""
import json
import os
import subprocess
import sys
import warnings

import numpy as np
from scipy.optimize import minimize

warnings.filterwarnings("ignore")
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import fit  # noqa: E402
import measure as M  # noqa: E402
import tail  # noqa: E402
from refs import load, ref_names  # noqa: E402

E = M.E
LAM_PROFILE = 0.5       # weight of the first-40 ms band profile's squared rms error (dB^2)
ON10_SHAKE = float(np.nanmean([M.broadband(load(n)[1], load(n)[0])["on10"] for _, n in ref_names(E.KEYS.index("pan_shake"))]))   # the recording's
LAM_CRACK = 0.7         # weight of (crack - the recordings') squared, dB: the share of the first 40 ms above 1.5 kHz
LAM_JING = 0.7          # the pandeiro's jingle share (6.5-16 kHz of the first 40 ms), squared dB error
MU = 0.02               # pull to the starting values (per squared unit of the log / dB parameter)


def groups(inst):
    """tone modes (and the body) under 700 Hz, and over it, at the nominal tuning"""
    lo = [m for m in range(E.NH) if E.F1[inst] * E.HEAD[inst][m][0] < 700] + [E.NH]
    hi = [m for m in range(E.NH) if E.F1[inst] * E.HEAD[inst][m][0] >= 700]
    return lo, hi


def specs(row, T):
    """[(name, kind, get, set, lo, hi)] kind: log (value = exp(u)), db"""
    inst = fit.inst_of(row)
    lo, hi = groups(inst)
    P = []

    def S_group(name, ms):
        P.append((name, "log", lambda T, ms=ms: T["S"][ms[0]], lambda T, v, ms=ms: [T["S"].__setitem__(m, v) for m in ms], 0.25, 4.0))
    S_group("S_lo", lo)
    if hi:
        S_group("S_hi", hi)
    P.append(("G", "log", lambda T: T["G"][0], lambda T, v: T.__setitem__("G", [v] * E.NN0 + T["G"][E.NN0:]), 1.0, 30.0))
    P.append(("tau", "log", lambda T: T["tau"], lambda T, v: T.__setitem__("tau", v), 0.003, 0.15))
    nb = E.JOWN if inst == 0 else E.NB
    for b in range(nb):
        m = E.NB0 + b
        P.append((f"S_n{b}", "log", lambda T, m=m: T["S"][m], lambda T, v, m=m: T["S"].__setitem__(m, v), 0.2, 12.0))
        P.append((f"W_n{b}", "db", lambda T, m=m: T["W"][m], lambda T, v, m=m: T["W"].__setitem__(m, v), -60.0, 24.0))
    if E.KEYS[row] == "pan_shake":       # the jingles alone: the tick and the head tones are only the first ms (the recording swells in over ~11 ms to -10 dB)
        W0 = list(T["W"])
        P.append(("nl", "log", lambda T: T["nl"], lambda T, v: T.__setitem__("nl", v), 0.002, 5.0))
        P.append(("ta", "log", lambda T: T["ta"], lambda T, v: T.__setitem__("ta", v), 0.0001, 0.03))
        P.append(("Wtone", "db", lambda T: T["W"][0] - W0[0], lambda T, v: T.__setitem__("W", [w + v if m < E.NH else w for m, w in enumerate(W0)]), -30.0, 6.0))
    if inst == 0:
        P.append(("jg", "log", lambda T: T["jg"], lambda T, v: T.__setitem__("jg", v), 0.02, 50.0))
        P.append(("jk", "log", lambda T: T["jk"], lambda T, v: T.__setitem__("jk", v), 0.5, 40.0))
        P.append(("js", "log", lambda T: T["js"], lambda T, v: T.__setitem__("js", v), 0.3, 8.0))
        P.append(("jq", "log", lambda T: T["jq"], lambda T, v: T.__setitem__("jq", v), 40.0, 1e5))
    return P


def to_u(kind, v):
    return float(np.log(v)) if kind == "log" else float(v)


def from_u(kind, u):
    return float(np.exp(u)) if kind == "log" else float(u)


def run(row, maxiter=4):
    k = E.KEYS[row]
    tabs = E.load_tables()
    T0 = json.loads(json.dumps(tabs[k]))
    P = specs(row, T0)
    for n, kind, get, setter, lo, hi in P:       # a noise band parked at -70 dB starts at -45
        if kind == "db" and get(T0) < -60:
            setter(T0, -45.0)
    u0 = np.array([to_u(p[1], p[2](T0)) for p in P])
    bnd = [(to_u(p[1], p[4]), to_u(p[1], p[5])) for p in P]
    u0 = np.clip(u0, [b[0] for b in bnd], [b[1] for b in bnd])
    tg = fit.target(row)
    rb = fit.ref_profile(row)[1]
    crack_ref = float(np.mean([b["crack"] for b in rb]))
    use = (tg["early"] > -30) & fit.fit_bands(row)
    code = os.path.join(HERE, f"_t.tail_{k}.genexpr")
    inst, (i, m) = fit.inst_of(row), E.ROW_MENU[row]

    def build(u):
        T = json.loads(json.dumps(T0))
        for p, uu in zip(P, u):
            p[3](T, from_u(p[1], uu))
        return T

    def cost(u, detail=False):
        T = build(u)
        t2 = dict(tabs)
        t2[k] = T
        open(code, "w").write(E.code(t2, jitter=0))
        sr, x = M.render([(i, m, 0.8, 0.05)], 0.6, [], code=code)
        ce = tail.curve_error(row, ours=tail.curves(x, sr, int(0.05 * sr)))
        bb = M.broadband(x, sr, int(0.05 * sr))
        on10 = bb["on10"]
        prof = M.profile(x, sr, inst, E.F1[inst])
        pe = float(np.sqrt(np.mean((prof["early"][use] - tg["early"][use]) ** 2)))
        c = ce ** 2 + LAM_PROFILE * pe ** 2 + MU * float(np.sum((u - u0) ** 2)) + LAM_CRACK * (bb["crack"] - crack_ref) ** 2
        if inst == 0:
            c += LAM_JING * (prof["jing"] - tg["jing"]) ** 2
        if E.KEYS[row] == "pan_shake":     # the swell-in: ms until the 2 ms envelope is within 10 dB of its peak
            c += 30.0 * float(np.log(max(on10, 0.1) / ON10_SHAKE) ** 2)
        return (c, ce, pe) if detail else c

    c0, ce0, pe0 = cost(u0, True)
    res = minimize(cost, u0, method="Powell", bounds=bnd, options=dict(maxiter=maxiter, xtol=0.01, ftol=1e-3))
    c1, ce1, pe1 = cost(res.x, True)
    T = build(res.x)
    json.dump(T, open(os.path.join(HERE, f"_tail_{k}.json"), "w"), indent=1)
    print(f"{k}: tail {ce0:.1f} -> {ce1:.1f} dB, profile {pe0:.1f} -> {pe1:.1f} dB, {res.nfev} evals;  " + "  ".join(f"{p[0]} {from_u(p[1], v):.3g}" for p, v in zip(P, res.x)), flush=True)


def merge():
    tabs = E.load_tables()
    for k in E.KEYS:
        p = os.path.join(HERE, f"_tail_{k}.json")
        if os.path.exists(p):
            tabs[k] = json.load(open(p))
    json.dump(tabs, open(E.TABLES_PATH, "w"), indent=1)
    print("wrote", E.TABLES_PATH)


if __name__ == "__main__":
    a = sys.argv[1] if len(sys.argv) > 1 else "all"
    it = int(sys.argv[2]) if len(sys.argv) > 2 else 4
    if a == "merge":
        merge()
    elif a == "all":
        ps = [subprocess.Popen([sys.executable, __file__, k, str(it)]) for k in E.KEYS]
        for p in ps:
            p.wait()
    else:
        run(E.KEYS.index(a), it)
