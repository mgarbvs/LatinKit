"""End-to-end checks of m4l/Pandeiro.amxd in real standalone Max (needs Max, not Live), from a cold start: parameters, every instrument x menu stroke against the
Node shim (median of 6 hits: same peak, same energy; the jingles are noise), tuning, Stroke changed between hits, the Roll, the jingles, controls, extremes, CPU of the gen~.
With --demo also writes docs/demo.wav (two device instances, Pandeiro and Tamborim, mixed: a samba groove read from the LP clip).

    uv run --directory $MAXTEST_DIR python <repo>/Bongo/tests/test_voice_max.py [--demo]
"""
import os
import shutil
import subprocess
import sys

import numpy as np
import wave

sys.path.insert(0, os.environ["MAXTEST_DIR"])
import server  # noqa: E402
from analyze import read_wav  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
DEV = os.environ.get("PANDEIRO_DEV") or os.path.join(HERE, "../m4l/Pandeiro.amxd")      # PANDEIRO_DEV=.../m4l/PandeiroMusical.amxd tests the Musical device
MUSICAL = "Musical" in os.path.basename(DEV)
os.environ["PANDEIRO_DEV"] = DEV
RESTART = os.path.join(HERE, "../scripts/max_restart.sh")
sys.path.insert(0, os.path.join(HERE, "../scripts"))
sys.path.insert(0, HERE)
import pandeiro_engine as E  # noqa: E402

FAILS = []
PASSED = [0]
DEFAULTS = {ln: d for _, ln, _, _, d, *_ in E.PARAMS}
META = {ln: (lo, hi) for _, ln, lo, hi, *_ in E.PARAMS}
DIRTY = set()
NOTES = E.NOTES if MUSICAL else [60, 60]       # the key each instrument is played at (Musical: the keys nearest the kit's pitches; the kit ignores the key)
OUTDIR = os.environ.get("PANDEIRO_OUT", "")


def check(cond, what, verbose=False):
    if cond:
        PASSED[0] += 1
        if verbose:
            print("ok   " + what)
    else:
        print("FAIL " + what)
        FAILS.append(what)


def render(events, ms, params=None, name="render"):
    """server.render, first putting back the default of every parameter an earlier render changed (the device keeps them)"""
    params = params or {}
    full = {n: DEFAULTS[n] for n in DIRTY if n not in params}
    DIRTY.update(params)
    return server.render(events, ms, params={**full, **params}, name=name)


def play(inst, stroke, ms=1200, params=None, vel=127, extra=(), name=None):
    r = render([{"t": 100, "note": NOTES[inst], "vel": vel, "dur": 60}, *extra], ms, params={"Instrument": inst, "Stroke": stroke, "Vary": 0, **(params or {})}, name=name or f"t{inst}{stroke}")
    x, sr = read_wav(r["wav"])
    if OUTDIR:
        shutil.copy(r["wav"], os.path.join(OUTDIR, f"{E.INSTRUMENTS[inst]}_{E.MENU[stroke]}_{name or ''}.wav"))
    return x, sr, r


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


def onset(m, thr=1e-3):
    return int(np.argmax(m > thr))


def node_stats():
    """the Node shim's median peak and 0.8 s energy per instrument x menu stroke at velocity 1 (the numbers Max must reproduce; computed by tests/node_stats.py with the system python)"""
    import json
    o = subprocess.run(["/opt/homebrew/bin/python3", os.path.join(HERE, "node_stats.py")], capture_output=True, text=True, check=True).stdout
    return {tuple(int(v) for v in k.split(",")): tuple(x) for k, x in json.loads(o.strip().splitlines()[-1]).items()}


ref = node_stats()
subprocess.run(["bash", RESTART], capture_output=True)
loaded = server.load_device(DEV)
errs = [l for l in loaded["console"] if "[1]" in l]
check(not errs, f"load_device console has no [1] errors ({len(errs)} found)")
for l in errs:
    print("     " + l)
names = {p["name"] for p in loaded["params"]}
check(set(DEFAULTS) <= names, f"every engine parameter is exposed as a Live parameter (missing: {sorted(set(DEFAULTS) - names)})")
print(f"     {len(names)} parameters, sr {loaded['sr']}")

# 1. every instrument x menu stroke (Vary 0: Node and Max draw different jitter): six hits 2.6 s apart in one render; the median per-hit peak and 0.8 s energy within 3.5 / 2.5 dB of
#    the Node shim's median, sounds, L == R. (The jingles and the noise bands are noise: one hit alone would flake.)
for i in range(2):
    for s in range(len(E.MENU)):
        r = render([{"t": 100 + 2600 * k, "note": NOTES[i], "vel": 127, "dur": 60} for k in range(6)], 100 + 2600 * 6, params={"Instrument": i, "Stroke": s, "Vary": 0}, name=f"all{i}{s}")
        x, sr = read_wav(r["wav"])
        pks, ens = [], []
        for k in range(6):
            seg = x[int((0.1 + 2.6 * k) * sr - 200):int((0.1 + 2.6 * (k + 1)) * sr - 200)]
            m = seg.mean(axis=1)
            o = onset(np.abs(m), 1e-3)
            pks.append(20 * np.log10(float(np.abs(seg).max()) + 1e-12))
            ens.append(10 * np.log10(float(np.mean(m[o:o + int(0.8 * sr)] ** 2)) + 1e-20))
        rp, re = ref[(i, s)]
        dp, de = float(np.median(pks)) - rp, float(np.median(ens)) - re
        check(r["nan_count"] == 0 and r["inf_count"] == 0 and abs(dp) < 3.5 and abs(de) < 2.5 and float(np.abs(x[:, 0] - x[:, 1]).max()) < 1e-6,
              f"{E.INSTRUMENTS[i]} {E.MENU[s]}: median peak {np.median(pks):.1f} dBFS ({dp:+.1f} vs Node), energy {de:+.1f} dB vs Node, L == R", verbose=True)

# 2. Tune +7 st moves the head's strongest tone up a fifth, and the instruments sit apart
fs = {}
for i, st, lo, hi in ((0, 0, 150, 1500), (1, 6, 250, 2000)):
    for t in (0, 7):
        x, sr, _ = play(i, st, 1000, {"Tune": t, "Jingles": 0}, vel=100)
        m = x.mean(axis=1)
        o = onset(np.abs(m), 2e-3)
        fs[(i, t)] = fft_peak(m[o + int(0.08 * sr):o + int(0.45 * sr)], sr, lo, hi * 1.5 if t else hi)
    check(abs(1200 * np.log2(fs[(i, 7)] / fs[(i, 0)]) - 700) < 30, f"{E.INSTRUMENTS[i]} {E.MENU[st]}: Tune 0 -> +7 st moves the strongest head tone {fs[(i, 0)]:.1f} -> {fs[(i, 7)]:.1f} Hz ({1200 * np.log2(fs[(i, 7)] / fs[(i, 0)]):+.0f} ct, want 700)", verbose=True)
def bal(i, st):
    x, sr, _ = play(i, st, 700, {"Jingles": 0}, vel=100)
    m = x.mean(axis=1)
    o = onset(np.abs(m), 2e-3)
    return band_db(m[o + int(0.05 * sr):o + int(0.25 * sr)], sr, 700, 3000) - band_db(m[o + int(0.05 * sr):o + int(0.25 * sr)], sr, 150, 700)
bp, bt = bal(0, 0), bal(1, 6)
check(bt > bp + 6, f"Tamborim Open has {bt:.1f} dB more at 0.7-3 kHz than at 0.15-0.7 kHz; the Pandeiro Thumb {bp:.1f} (need 6 dB higher)")

# 2b. Musical: the MIDI key sets the head's fundamental, mtof(key) x 2^(Tune/12) (key + 12 = +1200 ct), the jingles do not follow it
if MUSICAL:
    for i, st in ((0, 0), (1, 6)):
        fk = {}
        for k in (48, 60, 72, 84):
            r = render([{"t": 100, "note": k, "vel": 100, "dur": 60}], 1000, params={"Instrument": i, "Stroke": st, "Vary": 0, "Jingles": 0, "Tune": 0}, name=f"key{i}{k}")
            x, sr = read_wav(r["wav"])
            m = x.mean(axis=1)
            o = onset(np.abs(m), 2e-3)
            f0 = 440 * 2 ** ((k - 69) / 12)
            fk[k] = fft_peak(m[o + int(0.1 * sr):o + int(0.5 * sr)], sr, f0 * 0.96, f0 * 1.04)
            check(abs(1200 * np.log2(fk[k] / f0)) < 5, f"{E.INSTRUMENTS[i]} {E.MENU[st]} at key {k}: head fundamental {fk[k]:.2f} Hz, mtof {f0:.2f} ({1200 * np.log2(fk[k] / f0):+.1f} ct, need within 5)")
        check(abs(1200 * np.log2(fk[72] / fk[60]) - 1200) < 5, f"{E.INSTRUMENTS[i]}: key 60 -> 72 moves the head {1200 * np.log2(fk[72] / fk[60]):+.1f} ct (want 1200 +-5)")
    r = render([{"t": 100, "note": 60, "vel": 100, "dur": 60}], 1000, params={"Instrument": 1, "Stroke": 6, "Vary": 0, "Jingles": 0, "Tune": -5}, name="keytune")
    x, sr = read_wav(r["wav"])
    m = x.mean(axis=1)
    o = onset(np.abs(m), 2e-3)
    f0 = 440 * 2 ** ((60 - 69 - 5) / 12)
    f = fft_peak(m[o + int(0.1 * sr):o + int(0.5 * sr)], sr, f0 * 0.96, f0 * 1.04)
    check(abs(1200 * np.log2(f / f0)) < 5, f"key 60 with Tune -5: {f:.2f} Hz, want {f0:.2f} (key and Tune add in semitones, {1200 * np.log2(f / f0):+.1f} ct)")
    hfk = {}
    for k in (36, 96):
        r = render([{"t": 100 + 1500 * q, "note": k, "vel": 120, "dur": 60} for q in range(4)], 100 + 1500 * 4, params={"Instrument": 0, "Stroke": 4, "Vary": 0, "Jingles": 100, "Tune": 0}, name=f"keyjg{k}")
        x, sr = read_wav(r["wav"])
        m = x.mean(axis=1)
        hfk[k] = float(np.median([band_db(m[int((0.1 + 1.5 * q) * sr):int((0.1 + 1.5 * q) * sr + 0.3 * sr)], sr, 8000, 15000) for q in range(4)]))
    check(abs(hfk[36] - hfk[96]) < 1.5, f"Pandeiro Shake (jingles alone): 8-15 kHz power {hfk[36]:.1f} dB at key 36, {hfk[96]:.1f} dB at key 96: the jingles do not follow the key (within 1.5 dB)")

# 3. Stroke changed between hits (menu set 25 ms ahead of the note at 80 ms): Tamborim head ring (350-1200 Hz) 120..320 ms after the second hit, against the free ring
free, sr, _ = play(1, 6, 700, {"Jingles": 0}, vel=110, name="free")
mf = free.mean(axis=1)
t0 = onset(np.abs(mf), 2e-3) / sr
a0, a1 = int((t0 + 0.2) * sr), int((t0 + 0.4) * sr)
res = {}
for stroke, nm in ((7, "Mute"), (6, "Open")):
    ch, sr, _ = play(1, 6, 700, {"Jingles": 0}, vel=110, extra=[{"t": 175, "param": "Stroke", "value": stroke}, {"t": 200, "note": NOTES[1], "vel": 1, "dur": 60}], name=nm)
    res[nm] = band_db(ch.mean(axis=1)[a0:a1], sr, 350, 1200) - band_db(mf[a0:a1], sr, 350, 1200)
check(res["Mute"] < -6, f"Tamborim Open, then Stroke -> Mute between hits (quiet): the head's ring is {res['Mute']:.1f} dB re the free ring (need < -6)")
check(res["Mute"] < res["Open"] - 3, f"the Mute damps the ring more than an Open does ({res['Mute']:.1f} vs {res['Open']:.1f} dB re free)")
# the same note after a Stroke change is the new stroke: a Shake is jingles only (no head hit)
a, sr, _ = play(0, 0, 900, {"Vary": 0}, extra=[{"t": 340, "param": "Stroke", "value": 4}, {"t": 400, "note": NOTES[0], "vel": 110, "dur": 60}], name="chg")
b, sr, _ = play(0, 0, 900, extra=[{"t": 400, "note": NOTES[0], "vel": 110, "dur": 60}], name="nochg")
i0, i1 = int(0.396 * sr), int(0.44 * sr)
dh = band_db(b.mean(axis=1)[i0:i1], sr, 100, 1000) - band_db(a.mean(axis=1)[i0:i1], sr, 100, 1000)
check(dh > 8, f"Stroke -> Shake between hits: the second hit has no head strike ({dh:.1f} dB less at 100-1000 Hz than the Thumb, need > 8)")
c, sr, _ = play(0, 0, 800, extra=[{"t": 300, "param": "Stroke", "value": 4}, {"t": 300, "note": NOTES[0], "vel": 110, "dur": 60}], name="same")
dsame = band_db(b.mean(axis=1)[i0:i1], sr, 100, 1000) - band_db(c.mean(axis=1)[int(0.296 * sr):int(0.34 * sr)], sr, 100, 1000)
check(dsame > 8, f"Stroke menu and note in the same tick: the new stroke plays ({dsame:.1f} dB less head at 100-1000 Hz, need > 8)")

# 4. the stroke map through Max: a menu entry the instrument lacks plays the mapped row (Tamborim Shake = Tamborim Finger, Pandeiro Open = Thumb: the same energy, 6 hits each)
def energy6(i, s):
    r = render([{"t": 100 + 1500 * k, "note": NOTES[i], "vel": 127, "dur": 60} for k in range(6)], 100 + 1500 * 6, params={"Instrument": i, "Stroke": s, "Vary": 0}, name=f"map{i}{s}")
    x, sr = read_wav(r["wav"])
    m = x.mean(axis=1)
    return float(np.median([10 * np.log10(float(np.mean(m[int((0.1 + 1.5 * k) * sr - 200):int((0.1 + 1.5 * k) * sr + 0.5 * sr)] ** 2)) + 1e-20) for k in range(6)]))
for i, s1, s2, nm in ((1, 4, 1, "Tamborim Shake and Finger"), (1, 2, 6, "Tamborim Slap and Open"), (0, 6, 0, "Pandeiro Open and Thumb"), (0, 7, 1, "Pandeiro Mute and Finger")):
    e1, e2 = energy6(i, s1), energy6(i, s2)
    check(abs(e1 - e2) < 1.5, f"{nm} play the same row: energy {e1:.1f} / {e2:.1f} dB (within 1.5)")

# 5. the Roll: 20 taps 55 ms apart (the Tamborim's, no jingles: the taps themselves), cancelled by a new stroke; the Pandeiro's is jingles over quiet taps
x, sr, _ = play(1, 5, 2200, vel=110, name="roll")
m = np.abs(x.mean(axis=1))
o = onset(m, 2e-3)
w = int(0.002 * sr)
env = np.sqrt(np.convolve(m ** 2, np.ones(w) / w, "same"))[o:o + int(1.1 * sr)]
e = env - env.mean()
fr = np.arange(8, 40, 0.1)
pw = [abs(np.sum(e[::4] * np.exp(-2j * np.pi * f * np.arange(0, len(e), 4) / sr))) for f in fr]
bf = float(fr[int(np.argmax(pw))])
lvl = lambda t: float(np.sqrt(np.mean(m[o + int(t * sr):o + int((t + 0.06) * sr)] ** 2)))  # noqa: E731
check(abs(bf - 18.2) < 1.5, f"Tamborim Roll: the envelope's strongest 8-40 Hz line is {bf:.1f} Hz (the tap rate, want 18.2)")
check(lvl(0.9) > 0.003 and 20 * np.log10(lvl(1.6) / lvl(0.9)) < -25, f"Tamborim Roll: still tapping at 0.9 s ({20 * np.log10(lvl(0.9)):.0f} dB), silent by 1.6 s ({20 * np.log10(lvl(1.6) + 1e-12):.0f} dB)")
x, sr, _ = play(1, 5, 1500, vel=110, extra=[{"t": 300, "param": "Stroke", "value": 6}, {"t": 300, "note": NOTES[1], "vel": 100, "dur": 60}], name="rollcut")
mm = np.abs(x.mean(axis=1))
check(20 * np.log10(float(mm[int(1.0 * sr):].max()) + 1e-12) < -50, f"a Roll cut by a new stroke at 0.3 s (Open): silent after 1.0 s ({20 * np.log10(float(mm[int(1.0 * sr):].max()) + 1e-12):.0f} dBFS)")

x, sr, _ = play(0, 5, 2200, vel=110, name="rollp")
mp_ = np.abs(x.mean(axis=1))
op_ = onset(mp_, 2e-3)
lp = lambda t: float(np.sqrt(np.mean(mp_[op_ + int(t * sr):op_ + int((t + 0.06) * sr)] ** 2)))  # noqa: E731
check(lp(0.9) > 0.01 and 20 * np.log10(lp(1.6) / lp(0.9)) < -25, f"Pandeiro Roll: jingles still going at 0.9 s ({20 * np.log10(lp(0.9)):.0f} dB), gone by 1.6 s ({20 * np.log10(lp(1.6) + 1e-12):.0f} dB)")

# 6. the jingles in Max: the Jingles control, the Tamborim's none, Decay
def hf(i, s, jg, ms=500, dec=100):
    r = render([{"t": 100 + 1500 * k, "note": NOTES[i], "vel": 120, "dur": 60} for k in range(4)], 100 + 1500 * 4, params={"Instrument": i, "Stroke": s, "Vary": 0, "Jingles": jg, "Decay": dec}, name=f"jg{i}{s}{jg}")
    x, sr = read_wav(r["wav"])
    m = x.mean(axis=1)
    return float(np.median([band_db(m[int((0.1 + 1.5 * k) * sr):int((0.1 + 1.5 * k) * sr + ms / 1000 * sr)], sr, 8000, 15000) for k in range(4)]))
d_on = hf(0, 2, 100) - hf(0, 2, 0)
check(d_on > 20, f"Pandeiro Slap: Jingles 100 puts {d_on:.1f} dB more into 8-15 kHz than Jingles 0 (need > 20)")
d_h = hf(0, 2, 100) - hf(0, 2, 50)
check(abs(d_h - 6) < 3, f"Jingles 50 is {d_h:.1f} dB under Jingles 100 at 8-15 kHz (want about 6)")
d_t = abs(hf(1, 6, 100) - hf(1, 6, 0))
check(d_t < 1.5, f"Tamborim Open: the Jingles control changes the 8-15 kHz energy by {d_t:.2f} dB (Tamborim has none; need < 1.5)")
d_dec = hf(0, 4, 100, 400, 250) - hf(0, 4, 100, 400, 100)
check(d_dec > 4, f"Pandeiro Shake: Decay 250 % puts {d_dec:.1f} dB more into 8-15 kHz over 0.5 s (need > 4)")

# 4b. Vary: eight Tamborim Open strokes 1.4 s apart; the levels of the head's sinusoid bands (350-2500 Hz, first 250 ms) differ hit to hit by about 1.5 dB at Vary 100, hardly at 0
for vary, lo, hi in ((100, 1.5, 4.5), (0, 0, 1.2)):      # at Vary 0 the noise bands' own randomness shows (0.8 dB)
    r = render([{"t": 100 + 1400 * k, "note": NOTES[1], "vel": 110, "dur": 60} for k in range(8)], 100 + 1400 * 8, params={"Instrument": 1, "Stroke": 6, "Vary": vary, "Jingles": 0}, name=f"vary{vary}")
    x, sr = read_wav(r["wav"])
    m = x.mean(axis=1)
    o0 = onset(np.abs(m), 2e-3)
    bands = np.array([[band_db(m[o0 + int(1.4 * k * sr):o0 + int((1.4 * k + 0.25) * sr)], sr, a, b) for a, b in ((350, 550), (550, 800), (800, 1200), (1200, 2500))] for k in range(8)])
    sd = float(np.median(bands.std(0, ddof=1)))
    check(lo <= sd <= hi, f"Vary {vary}: the head bands' level differs hit to hit by {sd:.1f} dB (want {lo}..{hi})", verbose=True)

# 7. controls in the real engine
x1, sr, _ = play(0, 1, 800, {"Shell": 100}, vel=110)
x0, sr, _ = play(0, 1, 800, {"Shell": 0}, vel=110)
m1, m0_ = x1.mean(axis=1), x0.mean(axis=1)
o1, o0_ = onset(np.abs(m1), 2e-3), onset(np.abs(m0_), 2e-3)
dsh = band_db(m1[o1:o1 + int(0.05 * sr)], sr, 100, 150) - band_db(m0_[o0_:o0_ + int(0.05 * sr)], sr, 100, 150)
check(dsh > 2, f"Pandeiro Finger: Shell 100 vs 0 puts {dsh:.1f} dB more into 100-150 Hz (the body, need > 2)")
drops = {}
for dc in (100, 200):
    x, sr, _ = play(1, 6, 1600, {"Decay": dc, "Jingles": 0}, vel=100, name=f"dc{dc}")
    m = x.mean(axis=1)
    o = onset(np.abs(m), 2e-3)
    drops[dc] = band_db(m[o + int(0.12 * sr):o + int(0.27 * sr)], sr, 350, 1200) - band_db(m[o + int(0.27 * sr):o + int(0.42 * sr)], sr, 350, 1200)
check(0.3 < drops[200] / drops[100] < 0.7, f"Decay 200 %: the Tamborim head's tones fall {drops[200]:.1f} dB from 0.12-0.27 s to 0.27-0.42 s vs {drops[100]:.1f} dB at 100 % (x{drops[200] / drops[100]:.2f}, want ~0.5)")
fa = {}
for sk in (0, 100):
    x, sr, _ = play(1, 6, 600, {"Skin": sk, "Jingles": 0}, vel=110)
    m = x.mean(axis=1)
    fa[sk] = band_db(m[int(0.11 * sr):int(0.3 * sr)], sr, 1800, 4000) - band_db(m[int(0.11 * sr):int(0.3 * sr)], sr, 350, 700)
check(fa[100] > fa[0] + 8, f"Skin 100 vs 0: the 1.8-4 kHz overtones are {fa[100] - fa[0]:.1f} dB stronger against the fundamental (need > 8)")
x1, sr, _ = play(1, 6, 400, {"Touch": 100}, vel=110)
x0, sr, _ = play(1, 6, 400, {"Touch": 0}, vel=110)
dt = band_db(x1.mean(axis=1)[int(0.1 * sr):int(0.14 * sr)], sr, 3000, 11000) - band_db(x0.mean(axis=1)[int(0.1 * sr):int(0.14 * sr)], sr, 3000, 11000)
check(dt > 3, f"Touch 100 vs 0: {dt:.1f} dB more energy at 3-11 kHz in the first 40 ms (need > 3)")
m0 = play(1, 6, 1000, {"Jingles": 0}, vel=100)[0].mean(axis=1)
o0 = onset(np.abs(m0), 2e-3)
f0 = fft_peak(m0[o0 + int(0.08 * sr):o0 + int(0.45 * sr)], sr, 250, 2000)
x, sr, _ = play(1, 6, 1000, {"Press": 12, "Jingles": 0}, vel=100, extra=[{"t": 0, "cc": 1, "value": 127}])
m = x.mean(axis=1)
o = onset(np.abs(m), 2e-3)
f = fft_peak(m[o + int(0.08 * sr):o + int(0.45 * sr)], sr, 500, 4000)
check(abs(1200 * np.log2(f / f0) - 1200) < 40, f"mod wheel 127 with Press 12: Tamborim Open's strongest tone {f0:.1f} -> {f:.1f} Hz ({1200 * np.log2(f / f0):+.0f} ct, want +1200)")
render([{"t": 0, "cc": 1, "value": 0}], 200, params={}, name="wheel0")      # the device keeps the wheel
x, sr, _ = play(1, 6, 800, vel=127)
lo = float(np.abs(play(1, 6, 800, vel=30)[0]).max())
check(20 * np.log10(float(np.abs(x).max()) / lo) > 10, f"velocity 30 -> 127 spans {20 * np.log10(float(np.abs(x).max()) / lo):.1f} dB (> 10)")
r1 = render([{"t": 100 + 1500 * k, "note": NOTES[1], "vel": 70, "dur": 60} for k in range(4)], 100 + 1500 * 4, params={"Instrument": 1, "Stroke": 6, "Vary": 0, "Volume": -9}, name="vol1")
r2 = render([{"t": 100 + 1500 * k, "note": NOTES[1], "vel": 70, "dur": 60} for k in range(4)], 100 + 1500 * 4, params={"Instrument": 1, "Stroke": 6, "Vary": 0, "Volume": -21}, name="vol2")
(xa, sr), (xb, _) = read_wav(r1["wav"]), read_wav(r2["wav"])
dv = 10 * np.log10(float(np.mean(xa ** 2)) / float(np.mean(xb ** 2)))
check(abs(dv - 12) < 1.0, f"Volume -9 -> -21 dB: energy {dv:.2f} dB lower of 4 hits each (want 12 +-1)")

# 8. extremes: every control at its minimum, then maximum (menus left alone), all 16 instrument x menu strokes one after the other via the menus
for which in (0, 1):
    p = {n: v[which] for n, v in META.items() if n not in ("Instrument", "Stroke")}
    ev = [{"t": 0, "cc": 1, "value": 127}]
    for q in range(16):
        ev += [{"t": 100 + 100 * q - 20, "param": "Instrument", "value": q // 8}, {"t": 100 + 100 * q - 20, "param": "Stroke", "value": q % 8},
               {"t": 100 + 100 * q, "note": NOTES[q // 8], "vel": 127, "dur": 50}]
    r = render(ev, 2600, params=p, name="extreme")
    x, sr = read_wav(r["wav"])
    check(r["nan_count"] == 0 and r["inf_count"] == 0 and float(np.abs(x).max()) < 1.0001,
          f"all controls at {'max' if which else 'min'}, instrument and stroke swept: peak {float(np.abs(x).max()):.3f}, nan {r['nan_count']}, inf {r['inf_count']}")
render([{"t": 0, "cc": 1, "value": 0}], 200, params={}, name="wheel0b")

# 9. the demo: two instances (Pandeiro, Tamborim), each playing through its own Stroke menu, mixed. The groove is read from the LP clip (docs/SPEC.md "Demo")
BPM_MS = 125         # a 16th note at 120 bpm
THUMB, FINGER, SLAP, RIM, SHAKE, ROLL, OPEN, MUTE = range(8)
# one bar (16 slots) of the LP clip "Samba 2 Tambourim Pandeiro-120bpm", read from its onsets (the same 16-slot pattern in all 4 bars; docs/SPEC.md "Demo"): (slot, stroke, velocity).
# Pandeiro: low-heavy onsets (150-500 Hz) are Thumb, jingle-only ones (above 6 kHz: 0.96 of the energy) Finger or Shake, the crackly ones Slap; the soft in-between ones (level 0.2) Finger ghosts.
# Tamborim: the 0.5-2.5 kHz-heavy onsets, the strong ones Open, the ones with a jingle-like tail (the pandeiro under them) Mute.
PAN = [(0, THUMB, 100), (2, FINGER, 85), (4, THUMB, 90), (7, SLAP, 85), (10, SLAP, 110), (12, THUMB, 70), (14, SHAKE, 70)] + [(g, FINGER, 30) for g in (1.4, 2.5, 5.4, 8.4, 9.2, 13.3, 14.5)]
TAM = [(1, OPEN, 100), (3, MUTE, 70), (6, OPEN, 90), (8, OPEN, 95), (11, MUTE, 80), (13, OPEN, 95), (15, MUTE, 85)]


def line(inst, hits, name):
    """hits: [(ms, stroke, vel[, key])] -> events with the Stroke menu set 25 ms ahead whenever it changes (key: the MIDI key; the kit ignores it)"""
    ev, cur = [], None
    for h in sorted(hits):
        t, st, v = h[:3]
        if st != cur:
            ev.append({"t": t - 25, "param": "Stroke", "value": st})
            cur = st
        ev.append({"t": t, "note": h[3] if len(h) > 3 else NOTES[inst], "vel": v, "dur": 40})
    ms = int(max(h[0] for h in hits) + 1800)
    r = render(ev, ms, params={"Instrument": inst, "Stroke": hits[0][1]}, name=name)
    x, sr = read_wav(r["wav"])
    return x.mean(axis=1), sr, ms


def demo():
    """4 bars of the groove (PAN / TAM, read from the LP clip), then a short roll-and-shake fill into a last downbeat"""
    pa, ta = [], []
    t0 = 200
    for bar in range(4):
        for slot, st, v in PAN:
            pa.append((int(t0 + (bar * 16 + slot) * BPM_MS), st, v))
        for slot, st, v in TAM:
            ta.append((int(t0 + (bar * 16 + slot) * BPM_MS), st, v))
    tf = t0 + 64 * BPM_MS
    pa += [(tf, ROLL, 90), (tf + 10 * BPM_MS, SHAKE, 100), (tf + 14 * BPM_MS, SLAP, 120), (tf + 16 * BPM_MS, THUMB, 127)]
    ta += [(tf + k * BPM_MS, OPEN, 70 + 5 * k) for k in range(0, 16, 2)] + [(tf + 16 * BPM_MS, OPEN, 127)]
    a, sr, ms = line(0, pa, "demo_pandeiro")
    b, sr, _ = line(1, ta, "demo_tamborim")
    n = min(len(a), len(b))
    y = 0.8 * a[:n] + 0.8 * b[:n]
    y = y / (np.abs(y).max() + 1e-9) * 0.7
    return y, sr, ms


def musical_demo():
    """a short melodic figure, 4 bars of 120 bpm in A minor: the Tamborim plays the tune (Open on the long notes, Mute on the short), the Pandeiro a bass line on Thumb with Finger ghosts and a Shake (the jingles stay put)"""
    G = BPM_MS
    tune = [(0, 69, OPEN), (3, 64, MUTE), (4, 67, OPEN), (6, 69, MUTE), (8, 72, OPEN), (11, 69, MUTE), (12, 67, OPEN), (14, 64, MUTE),
            (16, 62, OPEN), (19, 64, MUTE), (20, 67, OPEN), (22, 64, MUTE), (24, 69, OPEN), (27, 67, MUTE), (28, 64, OPEN), (30, 60, MUTE),
            (32, 72, OPEN), (35, 69, MUTE), (36, 67, OPEN), (38, 64, MUTE), (40, 67, OPEN), (43, 64, MUTE), (44, 62, OPEN), (46, 64, MUTE),
            (48, 69, OPEN), (52, 64, OPEN), (56, 57, OPEN), (60, 69, OPEN)]
    bass = [(0, 45), (6, 52), (8, 45), (12, 50), (16, 43), (22, 50), (24, 43), (28, 47), (32, 41), (38, 48), (40, 45), (44, 52), (48, 45), (56, 40)]
    t0 = 200
    ta = [(int(t0 + s * G), st, 95 if st == OPEN else 70, k) for s, k, st in tune]
    pa = [(int(t0 + s * G), THUMB, 100, k) for s, k in bass] + [(int(t0 + s * G), FINGER, 30, 60) for s in range(1, 64, 2) if s % 6 != 1] + [(int(t0 + 62 * G), SHAKE, 90, 60)]
    a, sr, ms = line(0, pa, "mdemo_pandeiro")
    b, sr, _ = line(1, ta, "mdemo_tamborim")
    n = min(len(a), len(b))
    y = 0.8 * a[:n] + 0.8 * b[:n]
    return y / (np.abs(y).max() + 1e-9) * 0.7, sr, ms


y, sr, ms = musical_demo() if MUSICAL else demo()
check(float(np.abs(y).max()) > 0.1 and np.isfinite(y).all(), f"demo pattern: {len(y) / sr:.1f} s rendered")
if "--demo" in sys.argv:
    with wave.open(os.path.join(HERE, "../docs/musical_demo.wav" if MUSICAL else "../docs/demo.wav"), "wb") as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(int(sr)); w.writeframes((y * 32767).astype("<i2").tobytes())
    print(f"{'musical_demo' if MUSICAL else 'demo'}.wav written: {len(y) / sr:.1f} s")

print(f"{PASSED[0]} passed" + (f", {len(FAILS)} FAILED" if FAILS else ""))
sys.exit(1 if FAILS else 0)
