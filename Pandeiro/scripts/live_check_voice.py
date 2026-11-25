"""live_check_voice.py <Pandeiro.amxd> -- load the instrument into the running Live (LiveTestMCP harness: adds/replaces an "LT DUT" track; never
touches other tracks), then check inside Live: clean Max console, all 11 parameters with their defaults and ranges, every instrument x menu stroke sounds
(Instrument and Stroke set through Live's parameter API), each instrument's tone in tune, Stroke changed between hits, a fallback stroke plays its mapped row, the Roll, the
jingles, mod wheel; the LT tracks are deleted at the end (set --keep to leave them). Exit 1 on any failure.

    uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check_voice.py "$PWD/m4l/Pandeiro.amxd"
"""
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "../../../LiveTestMCP"))
sys.path.insert(0, os.path.join(HERE, "../tests"))
sys.path.insert(0, HERE)
import server  # noqa: E402
import pandeiro_engine as V  # noqa: E402
E = V
from analyze import read_wav  # noqa: E402

FAILS = []
DEFAULTS = {ln: d for _, ln, _, _, d, *_ in V.PARAMS}
RANGE = {ln: (lo, hi) for _, ln, lo, hi, *_ in V.PARAMS}
MUSICAL = "Musical" in os.path.basename(sys.argv[1])
NOTES = E.NOTES if MUSICAL else [60, 60]       # the key each instrument is played at (Musical: the keys nearest the kit's pitches; the kit ignores the key)


def check(ok, what):
    print(("ok   " if ok else "FAIL ") + what)
    if not ok:
        FAILS.append(what)


def fft_peak(sig, sr, lo, hi):
    n = 1 << 18
    s = np.abs(np.fft.rfft(sig * np.hanning(len(sig)), n))
    a, b = int(lo * n / sr), int(hi * n / sr)
    k = a + int(np.argmax(s[a:b]))
    l, c, r = np.log(s[k - 1] + 1e-30), np.log(s[k] + 1e-30), np.log(s[k + 1] + 1e-30)
    return (k + 0.5 * (l - r) / (l - 2 * c + r)) * sr / n


def band_db(sig, sr, lo, hi):
    n = 1 << 16
    s = np.abs(np.fft.rfft(sig * np.hanning(len(sig)), n)) ** 2
    f = np.fft.rfftfreq(n, 1 / sr)
    return 10 * np.log10(s[(f >= lo) & (f < hi)].sum() + 1e-20)


r = server.setup(os.path.abspath(sys.argv[1]), "instrument")
console = list(r["console"])
params = {p["name"]: p for p in r["params"]}
print({n: p.get("value") for n, p in params.items()})
check(set(DEFAULTS) <= set(params), f"Live sees all {len(DEFAULTS)} parameters (missing: {set(DEFAULTS) - set(params) or 'none'})")
bad = {n: params[n].get("value") for n, d in DEFAULTS.items() if n in params and abs(float(params[n].get("value", 1e9)) - d) > 0.51}
check(not bad, f"defaults as designed (off: {bad or 'none'})")
badr = {n: (params[n].get("min"), params[n].get("max")) for n, (lo, hi) in RANGE.items() if n in params and (params[n].get("min"), params[n].get("max")) != (lo, hi)}
check(not badr, f"ranges as designed (off: {badr or 'none'})")
pid = os.getpid()

try:
    # every instrument x menu stroke: the menus are set 250 ms before each note (the Remote Script's parameter writes land within ~100 ms); 1.4 s apart (a Roll lasts 1.15 s)
    ev = []
    for i in range(16):
        t = 400 + 1400 * i
        ev += [{"t": t - 250, "param": "Instrument", "value": i // 8}, {"t": t - 250, "param": "Stroke", "value": i % 8}, {"t": t, "note": NOTES[i // 8], "vel": 110, "dur": 450}]
    out = server.render(ev, 400 + 1400 * 16 + 600, name=f"pand{pid}_all")
    console += out.get("console", [])
    for i, w in enumerate(out["windows"]):
        pk = w.get("peak_dbfs")
        check(pk is not None and pk > -45, f"{E.INSTRUMENTS[i // 8]} {E.MENU[i % 8]}: peak {pk} dBFS")
    check(out["nan_count"] == 0, f"no NaN in the 16-hit sweep ({out['nan_count']})")

    for i, st, lo, hi in ((0, 0, 150, 1500), (1, 6, 250, 2000)):      # Tune 0 and +7 st through Live: the strongest head tone moves a fifth
        fs = {}
        for t in (0, 7):
            rr = server.render([{"t": 300, "note": NOTES[i], "vel": 100, "dur": 60}], 1000, params={"Instrument": i, "Stroke": st, "Tune": t, "Vary": 0, "Jingles": 0}, name=f"pand{pid}_tune{i}{t}")
            console += rr["console"]
            x, sr = read_wav(rr["wav"])
            m = x.mean(axis=1)
            o = int(np.argmax(np.abs(m) > 2e-3))
            fs[t] = fft_peak(m[o + int(0.08 * sr):o + int(0.45 * sr)], sr, lo, hi * 1.5 if t else hi)
            check(rr["nan_count"] == 0, f"{E.INSTRUMENTS[i]} {E.MENU[st]}, Tune {t}: strongest head tone {fs[t]:.1f} Hz")
        c = 1200 * np.log2(fs[7] / fs[0])
        check(abs(c - 700) < 30, f"{E.INSTRUMENTS[i]} {E.MENU[st]} through Live: Tune +7 st moves it {c:+.0f} ct (want 700)")

    if MUSICAL:     # the key sets the head's fundamental (mtof(key), within 5 ct), key + 12 = +1200 ct, key and Tune add, the jingles do not follow it
        for i, st in ((0, 0), (1, 6)):
            fk = {}
            for k in (48, 60, 72, 84):
                rr = server.render([{"t": 300, "note": k, "vel": 100, "dur": 60}], 1000, params={"Instrument": i, "Stroke": st, "Tune": 0, "Vary": 0, "Jingles": 0}, name=f"pand{pid}_key{i}{k}")
                console += rr["console"]
                x, sr = read_wav(rr["wav"])
                m = x.mean(axis=1)
                o = int(np.argmax(np.abs(m) > 2e-3))
                f0 = 440 * 2 ** ((k - 69) / 12)
                fk[k] = fft_peak(m[o + int(0.1 * sr):o + int(0.5 * sr)], sr, f0 * 0.96, f0 * 1.04)
                check(abs(1200 * np.log2(fk[k] / f0)) < 5, f"{E.INSTRUMENTS[i]} {E.MENU[st]} through Live at key {k}: head fundamental {fk[k]:.2f} Hz, mtof {f0:.2f} ({1200 * np.log2(fk[k] / f0):+.1f} ct, need within 5)")
            check(abs(1200 * np.log2(fk[72] / fk[60]) - 1200) < 5, f"{E.INSTRUMENTS[i]} through Live: key 60 -> 72 moves the head {1200 * np.log2(fk[72] / fk[60]):+.1f} ct (want 1200 +-5)")
        rr = server.render([{"t": 300, "note": 60, "vel": 100, "dur": 60}], 1000, params={"Instrument": 1, "Stroke": 6, "Tune": -5, "Vary": 0, "Jingles": 0}, name=f"pand{pid}_keytune")
        console += rr["console"]
        x, sr = read_wav(rr["wav"])
        m = x.mean(axis=1)
        o = int(np.argmax(np.abs(m) > 2e-3))
        f0 = 440 * 2 ** ((60 - 69 - 5) / 12)
        f = fft_peak(m[o + int(0.1 * sr):o + int(0.5 * sr)], sr, f0 * 0.96, f0 * 1.04)
        check(abs(1200 * np.log2(f / f0)) < 5, f"key 60 with Tune -5 through Live: {f:.2f} Hz, want {f0:.2f} ({1200 * np.log2(f / f0):+.1f} ct)")
        hfk = {}
        for k in (36, 96):
            rr = server.render([{"t": 300 + 1200 * q, "note": k, "vel": 120, "dur": 60} for q in range(4)], 300 + 1200 * 4, params={"Instrument": 0, "Stroke": 4, "Tune": 0, "Vary": 0, "Jingles": 100}, name=f"pand{pid}_keyjg{k}")
            console += rr["console"]
            x, sr = read_wav(rr["wav"])
            m = x.mean(axis=1)
            hfk[k] = float(np.median([band_db(m[int((0.3 + 1.2 * q) * sr):int((0.3 + 1.2 * q) * sr + 0.3 * sr)], sr, 8000, 15000) for q in range(4)]))
        check(abs(hfk[36] - hfk[96]) < 1.5, f"Pandeiro Shake through Live: 8-15 kHz power {hfk[36]:.1f} dB at key 36, {hfk[96]:.1f} dB at key 96 (the jingles do not follow the key, within 1.5 dB)")

    # Stroke changed between hits: Tamborim Open, Stroke -> Mute 150 ms in, a very soft second note 200 ms in: the head's ring 120..320 ms after it is 6 dB under the free ring
    fr = server.render([{"t": 300, "note": NOTES[1], "vel": 110, "dur": 60}], 1500, params={"Instrument": 1, "Stroke": 6, "Vary": 0, "Jingles": 0}, name=f"pand{pid}_free")
    mu = server.render([{"t": 300, "note": NOTES[1], "vel": 110, "dur": 60}, {"t": 330, "param": "Stroke", "value": 7}, {"t": 380, "note": NOTES[1], "vel": 1, "dur": 60}], 1500,
                       params={"Instrument": 1, "Stroke": 6, "Vary": 0, "Jingles": 0}, name=f"pand{pid}_mute")
    console += fr["console"] + mu["console"]
    xf, sr = read_wav(fr["wav"])
    xm, _ = read_wav(mu["wav"])
    mf, mm = xf.mean(axis=1), xm.mean(axis=1)
    t0 = int(np.argmax(np.abs(mf) > 2e-3))
    a0, a1 = t0 + int(0.2 * sr), t0 + int(0.4 * sr)
    dd = band_db(mm[a0:a1], sr, 350, 1200) - band_db(mf[a0:a1], sr, 350, 1200)
    check(dd < -6, f"Stroke -> Mute between hits, inside Live: the Tamborim head's ring is {dd:.1f} dB under the free ring (need < -6)")

    # the stroke map in Live: Tamborim Shake plays the Finger row (the same energy over 4 hits), Pandeiro Open the Thumb row
    def energy(i, s):
        rr = server.render([{"t": 300 + 1200 * k, "note": NOTES[i], "vel": 110, "dur": 60} for k in range(4)], 300 + 1200 * 4, params={"Instrument": i, "Stroke": s, "Vary": 0}, name=f"pand{pid}_map{i}{s}")
        console.extend(rr["console"])
        x, sr = read_wav(rr["wav"])
        m = x.mean(axis=1)
        return float(np.median([10 * np.log10(float(np.mean(m[int((0.3 + 1.2 * k) * sr - 300):int((0.3 + 1.2 * k) * sr + 0.5 * sr)] ** 2)) + 1e-20) for k in range(4)]))
    for i, s1, s2, nm in ((1, 4, 1, "Tamborim Shake and Finger"), (0, 6, 0, "Pandeiro Open and Thumb")):
        e1, e2 = energy(i, s1), energy(i, s2)
        check(abs(e1 - e2) < 1.5, f"{nm} play the same row inside Live: energy {e1:.1f} / {e2:.1f} dB (within 1.5)")

    # the Roll: about 18 taps a second for 1.1 s (Jingles 0), then silence
    rr = server.render([{"t": 300, "note": NOTES[0], "vel": 110, "dur": 60}], 2300, params={"Instrument": 0, "Stroke": 5, "Vary": 0, "Jingles": 0}, name=f"pand{pid}_roll")
    console += rr["console"]
    x, sr = read_wav(rr["wav"])
    m = np.abs(x.mean(axis=1))
    o = int(np.argmax(m > 2e-3))
    w = int(0.002 * sr)
    env = np.sqrt(np.convolve(m ** 2, np.ones(w) / w, "same"))[o:o + int(1.1 * sr)]
    e = env - env.mean()
    frq = np.arange(8, 40, 0.1)
    bf = float(frq[int(np.argmax([abs(np.sum(e[::4] * np.exp(-2j * np.pi * f * np.arange(0, len(e), 4) / sr))) for f in frq]))])
    lv = lambda t: float(np.sqrt(np.mean(m[o + int(t * sr):o + int((t + 0.06) * sr)] ** 2)))  # noqa: E731
    check(abs(bf - 18.2) < 1.5 and lv(0.9) > 0.0003 and 20 * np.log10(lv(1.6) / lv(0.9)) < -25, f"Pandeiro Roll inside Live: tap rate {bf:.1f} Hz, tapping at 0.9 s ({20 * np.log10(lv(0.9)):.0f} dB: the head taps alone are quiet, the recording's are 19 dB under its jingles), silent by 1.6 s ({20 * np.log10(lv(1.6) / lv(0.9)):.0f} dB)")

    # the jingles: Slap with Jingles 100 against 0 (8-15 kHz), the Tamborim's none
    def hf(i, s, jg):
        rr = server.render([{"t": 300 + 1200 * k, "note": NOTES[i], "vel": 120, "dur": 60} for k in range(4)], 300 + 1200 * 4, params={"Instrument": i, "Stroke": s, "Vary": 0, "Jingles": jg}, name=f"pand{pid}_jg{i}{s}{jg}")
        console.extend(rr["console"])
        x, sr = read_wav(rr["wav"])
        m = x.mean(axis=1)
        return float(np.median([band_db(m[int((0.3 + 1.2 * k) * sr):int((0.3 + 1.2 * k) * sr + 0.5 * sr)], sr, 8000, 15000) for k in range(4)]))
    dj = hf(0, 2, 100) - hf(0, 2, 0)
    check(dj > 20, f"Pandeiro Slap inside Live: Jingles 100 puts {dj:.1f} dB more into 8-15 kHz than Jingles 0 (need > 20)")
    dt = abs(hf(1, 6, 100) - hf(1, 6, 0))
    check(dt < 1.5, f"Tamborim Open inside Live: the Jingles control changes 8-15 kHz by {dt:.2f} dB (none there, need < 1.5)")

    rr0 = server.render([{"t": 300, "note": NOTES[1], "vel": 100, "dur": 60}], 1200, params={"Instrument": 1, "Stroke": 6, "Vary": 0, "Jingles": 0}, name=f"pand{pid}_nowheel")
    console += rr0["console"]
    x0, sr = read_wav(rr0["wav"])
    m0 = x0.mean(axis=1)
    f0m = fft_peak(m0[int(np.argmax(np.abs(m0) > 2e-3)) + int(0.08 * sr):int(np.argmax(np.abs(m0) > 2e-3)) + int(0.45 * sr)], sr, 250, 2000)
    rr = server.render([{"t": 0, "cc": 1, "value": 127}, {"t": 300, "note": NOTES[1], "vel": 100, "dur": 60}], 1200, params={"Press": 12, "Instrument": 1, "Stroke": 6, "Vary": 0, "Jingles": 0}, name=f"pand{pid}_wheel")
    console += rr["console"]
    x, sr = read_wav(rr["wav"])
    m = x.mean(axis=1)
    o = int(np.argmax(np.abs(m) > 2e-3))
    f = fft_peak(m[o + int(0.08 * sr):o + int(0.45 * sr)], sr, 500, 4000)
    check(abs(1200 * np.log2(f / f0m) - 1200) < 40, f"mod wheel + Press 12 through Live: Tamborim Open's strongest tone {f:.1f} Hz (an octave over {f0m:.1f})")
    errs = [l for l in console if "error" in l.lower() or "[1]" in l]
    check(not errs, "Max console clean" + ("" if not errs else ": " + " | ".join(errs[:5])))
finally:
    if "--keep" not in sys.argv:       # leave the user's set as it was: the LT tracks go
        server.live("""
for i in reversed(range(len(song.tracks))):
    if song.tracks[i].name.startswith("LT "):
        song.delete_track(i)
""")
        print("LT tracks deleted")
sys.exit(1 if FAILS else 0)
