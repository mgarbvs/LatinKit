"""cr_engine.py — generates the gen~ GenExpr code for CR78: the Roland CR-78 voice board (VG-11A) as 14 voices on 15 MIDI notes.
Source: the Roland CR-78 service notes (June 1979).

Each voice follows the circuit the service notes show, not a sample or a generic drum model:
  * ringing oscillators (BD, SD tone, HB, LB, LC) and the LC tanks of RS and C are *pinged resonators*: a pulse into a damped
    2-pole rotation (poles at exp(-1/tau) e^{+-jw}), tau = decay(to 1/10) / ln 10, so frequency and decay are exactly the table's;
  * one shared noise source feeds SD, HH, CY, M and Tb; HH/CY/M are the same filtered noise (one LC band-pass) with three
    envelopes that sum rather than choke (the band-pass is linear, so three parallel copies sound the same as one summed VCA
    and can still be panned apart);
  * MB: three free-running square oscillators -> VCA (50 ms envelope) -> tank;
  * CB: two free-running sine-ish oscillators 800 / 555 Hz -> VCA (60 ms envelope) -> tank;
  * Tb: noise x envelope (optionally kicked twice) -> tank;
  * GU: an astable multivibrator that runs while its note is held (125 Hz H / 77 Hz L), each pulse pinging a tank.

Hits arrive as counters (tr0..tr14, bumped by cr_midi.js) with their velocity in vl0..vl14; a change in the counter is a hit.
The guiro also reads gt12 / gt13 (the note is held), so the note length is the stroke length.

First-compile trap (playbook §4): no ternary / max / min / clamp on an expression that depends only on Params at the top
level. Everything below selects arithmetically; the one min/max pair (the output limiter) works on signals.
"""

import re

# (prefix, display name, MIDI note) in slot order (slot = the tr / vl number)
SLOTS = [("bd", "Bass Drum", 36), ("rs", "Rimshot", 37), ("sd", "Snare", 38), ("hh", "Hi-Hat", 42), ("mb", "Metallic Beat", 44),
         ("cy", "Cymbal", 49), ("tb", "Tambourine", 54), ("cb", "Cowbell", 56), ("hb", "High Bongo", 60), ("lb", "Low Bongo", 61),
         ("lc", "Low Conga", 64), ("ma", "Maracas", 70), ("guH", "Guiro Short", 73), ("guL", "Guiro Long", 74), ("cl", "Clave", 75)]
SLOT = {p: i for i, (p, _, _) in enumerate(SLOTS)}

# factory table (service notes p.15): frequency Hz, decay to 1/10 amplitude in ms, amplitude Vpp
TABLE = {
    "bd": (62.5, 100, 0.4), "sd": (340, 60, 0.4), "rs": (1480, 5, 0.8), "hh": (None, 60, 0.4), "cy": (None, 350, 0.4),
    "ma": (None, 20, 0.4), "cl": (2630, 18, 0.15), "hb": (600, 40, 0.15), "lb": (400, 40, 0.15), "lc": (208, 150, 0.3),
    "cb": ((800, 555), 60, 0.2), "tb": (None, 220, 0.25), "gu": ((125, 77), None, 0.3), "mb": ((6170, 5620, 4080), 50, 0.35),
}
# tank frequencies the service notes do not give legibly (README: "unverified"): Hz
# hat / tb fitted (single band-pass, ~4 dB rms) and cb / mb fitted (harmonic + intermodulation levels) to the Core Library C78 samples
TANK = {"hat": 8700.0, "mb": 6200.0, "cb": 1660.0, "tb": 4400.0, "gu": 5900.0}
TANK_Q = {"hat": 11.0, "mb": 5.0, "cb": 1.73, "tb": 17.5}
# CB: each phase-shift oscillator's own 2nd / 3rd harmonic (s + c2 (s^2 - 1/2) + c3 s^3), then the VCA's quadratic (m + a m^2)
CB_C2, CB_C3, CB_VCA = (0.324, 0.061), (0.077, 0.044), 0.036
MB_VCA = 0.3              # MB: the VCA's quadratic on the three mixed squares (difference tones at -41..-53 dB as in the sample)
# guiro: each pulse opens a sin^3 grain of noise into a resonant high-pass, fitted to Ableton's Core Library "Guiro C78" samples
# (grain 50 % width ~3 ms, 10 % width ~7 ms, level spread cv ~0.27; spectrum peak ~5.9 kHz, -50/-37/-23 dB at 1/2/4 kHz)
GU_GRAIN = 0.009          # grain length at the 77 Hz rate, s (scales with the rate so faster strokes keep the same duty)
GU_JIT = 0.38             # grain level spread: uniform +-38 % (measured cv ~0.27 after the filter)
GU_Q = 10.0               # high-pass resonance
GU_LP = 6000.0            # gentle top roll-off, Hz
TB_SHAKE_MS = 70.0        # tambourine: second kick after this long when Shake is on (assumption)
GU_HOLD_MS = 20.0         # a guiro note always runs at least this long (a note shorter than an audio block would be lost)
GU_MAX_S = 1.0            # longest guiro stroke
LN10 = 2.302585093

# per-voice level trim so the voice's peak at default settings is its table amplitude (tests/calibrate.js prints these)
CAL = {"bd": 1, "sd": 0.1147, "rs": 1.0004, "hh": 3.4821, "cy": 2.8825, "ma": 4.0487, "cl": 1.0126, "hb": 1.0001, "lb": 1.0003, "lc": 0.9996, "cb": 2.9763, "tb": 5.1149, "gu": 0.3407, "mb": 1.4093}

# ── UI parameter table: (name, long name, short name, min, max, default, units, hover text); `kind` picks the units string
UNITS = {"st": "%+.2f st", "oct": "%+.2f oct", "vpp": "%.2f Vpp", "pct": "%.0f %", "pan": "%+.0f"}


def _voice_params():
    out = []

    def tune(p, name, info="The factory pitch is 0. This is the trim pot: up to an octave either way."):
        out.append((p + "Tune", f"{name} Tune", "Tune", -12, 12, 0, "st", info))

    def decay(p, name, info=None):
        out.append((p + "Dec", f"{name} Decay", "Decay", -2, 2, 0, "oct", info or
                    "Decay trim pot. 0 is the factory time (to 1/10 amplitude); each +1 doubles it, each -1 halves it (x0.25 to x4)."))

    def level(p, name, vpp):
        out.append((p + "Lvl", f"{name} Level", "Level", 0, 1, vpp, "vpp", f"Output level, in the service notes' volts peak-to-peak: the default is the factory amplitude ({vpp} Vpp)."))

    def pan(p, name):
        out.append((p + "Pan", f"{name} Pan", "Pan", -100, 100, 0, "pan", f"{name} position in the stereo field. The CR-78 itself is mono."))

    for p, name, kind in (("bd", "Bass Drum", 0), ("sd", "Snare", 0), ("rs", "Rimshot", 0), ("cl", "Clave", 0), ("hb", "High Bongo", 0),
                          ("lb", "Low Bongo", 0), ("lc", "Low Conga", 0)):
        info = "The tuning pot of the ringing oscillator: up to an octave either way. 0 is the factory frequency." if p in ("bd", "sd", "hb", "lb", "lc") else \
            "The inductor of the LC tank: up to an octave either way. 0 is the factory frequency."
        tune(p, name, info)
        decay(p, name)
        if p == "sd":
            out.append(("sdNoise", "Snare Noise", "Noise", 0, 200, 100, "pct", "Noise part of the snare, from the shared noise source. 100 % matches the CR-78 snare recording's noise level."))
        level(p, name, TABLE[p][2])
        pan(p, name)
    for p, name in (("hh", "Hi-Hat"), ("cy", "Cymbal"), ("ma", "Maracas")):
        decay(p, name, "How long the noise burst rings. 0 is the factory time (to 1/10 amplitude); each +1 doubles it.")
        if p == "hh":
            out.append(("hatTone", "Hat Cym Maracas Tone", "Tone", -12, 12, 0, "st",
                        "The LC band-pass that hi-hat, cymbal and maracas all pass through (one shared VCA and tank on the real board). Its factory frequency is not legible in the scan: 6.5 kHz is my estimate."))
        level(p, name, TABLE[p][2])
        pan(p, name)
    tune("mb", "Metallic Beat", "Moves all three square oscillators (6170, 5620 and 4080 Hz) together, up to an octave either way.")
    decay("mb", "Metallic Beat")
    out.append(("mbAmt", "Metallic Beat Amount", "Amount", 0, 100, 50, "pct", "How loud the Metallic Beat is when it is layered on hi-hat and cymbal (see On Hats), as a share of its own Level."))
    out.append(("mbHats", "Metallic Beat On Hats", "On Hats", 0, 1, 0, "tog", "When on, hi-hat and cymbal notes also fire the Metallic Beat, like the hat/cymbal layer on the real machine."))
    level("mb", "Metallic Beat", TABLE["mb"][2])
    pan("mb", "Metallic Beat")
    tune("cb", "Cowbell", "Moves both oscillators (800 and 555 Hz) together, up to an octave either way.")
    decay("cb", "Cowbell")
    out.append(("cbTone", "Cowbell Tone", "Tone", -12, 12, 0, "st", "The LC tank after the cowbell VCA. Its value is not legible in the scan: about 2.9 kHz is my estimate."))
    level("cb", "Cowbell", TABLE["cb"][2])
    pan("cb", "Cowbell")
    decay("tb", "Tambourine")
    out.append(("tbTone", "Tambourine Tone", "Tone", -12, 12, 0, "st", "Frequency of the tank the noise rings (about 4.5 kHz, from forum reports)."))
    out.append(("tbShake", "Tambourine Shake", "Shake", 0, 1, 0, "tog", "When on, each hit kicks the envelope a second time 70 ms later (the board has two trigger lines into it): a double shake."))
    level("tb", "Tambourine", TABLE["tb"][2])
    pan("tb", "Tambourine")
    out.append(("guRate", "Guiro Rate", "Rate", -12, 12, 0, "st", "Speed of the multivibrator for both notes: 0 is the factory 125 Hz (short note) and 77 Hz (long note)."))
    out.append(("guTone", "Guiro Tone", "Tone", -12, 12, 0, "st", "Centre of the scrape's resonance (5.9 kHz at 0, fitted to CR-78 guiro recordings)."))
    decay("gu", "Guiro", "Length of each scrape grain: 0 is 9 ms at the long note's rate; each +1 doubles it, each -1 halves it.")
    level("gu", "Guiro", TABLE["gu"][2])
    pan("gu", "Guiro")
    out.append(("accent", "Accent", "Accent", 0, 100, 60, "pct", "How much velocity lifts or lowers a hit, like the accent stage of the board. 0 = every hit equal; 100 = level follows velocity (velocity 100 is the factory level)."))
    out.append(("drive", "Drive", "Drive", 0, 100, 0, "pct", "Transistor-style saturation on the ringing oscillators (bass drum, snare tone, bongos, conga). 0 = clean."))
    out.append(("master", "Master Volume", "Master", 0, 150, 100, "pct", "Output level of the whole kit."))
    return out


PARAMS = _voice_params()
EXTERNAL = [(f"tr{i}", 0) for i in range(len(SLOTS))] + [(f"vl{i}", 1) for i in range(len(SLOTS))] + [("gt12", 0), ("gt13", 0)]


def params():
    return [(n, d) for n, _, _, _, _, d, _, _ in PARAMS]


def hist(p, names):
    return [f"History {p}{n}(0);" for n in names]


def hit(i, extra):
    """detect a hit on slot i; hg{i} is its gain (velocity 100 = 1, Accent scales the rest)"""
    return (f"hit{i} = tr{i} != pt{i}; pt{i} = tr{i}; hg{i} = (1 - accA) + 1.27 * accA * vl{i};\n"
            f"if (hit{i}) {{ {extra} }}")


def svf_coefs(n, g, k):
    return f"{n}a1 = 1 / (1 + {g} * ({g} + {k})); {n}a2 = {g} * {n}a1; {n}a3 = {g} * {n}a2;"


def svf(c, s, x, k):
    """one zero-delay-feedback state-variable step with coefficients c, state s (History {s}i1, {s}i2); leaves {s}bp: the
    band-pass normalised to unity gain at resonance (a tank driven by a current source)"""
    return (f"{s}v3 = {x} - {s}i2; {s}b = {c}a1 * {s}i1 + {c}a2 * {s}v3; {s}l = {s}i2 + {c}a2 * {s}i1 + {c}a3 * {s}v3; "
            f"{s}i1 = 2 * {s}b - {s}i1; {s}i2 = 2 * {s}l - {s}i2; {s}bp = {k} * {s}b;")


def square(ph, dt):
    return f"(2 * ({ph} < 0.5) - 1 + blep({ph}, {dt}) - blep(fract({ph} + 0.5), {dt}))"


FUNCS = """
blep(t, dt) {
	bl = 0;
	if (t < dt) {
		x = t / dt;
		bl = x + x - x * x - 1;
	} else if (t > 1 - dt) {
		x = (t - 1) / dt;
		bl = x * x + x + x + 1;
	}
	return bl;
}
"""


def ring(p, f, td_ms, drive=True):
    """a pinged resonator at f Hz whose amplitude falls to 1/10 in td_ms (x 2^Decay). Output {p}_ring, first peak = 1."""
    slot = SLOT[p]
    decl = hist(p, ["S", "Q"]) + [f"History pt{slot}(0);"]
    top = f"""
{p}Wt = twopi * {f} / samplerate;
{p}Ta = {td_ms} * 0.001 * exp2({p}Dec) / {LN10};                          // decay constant (s)
{p}Rr = exp(-1 / ({p}Ta * samplerate));
{p}Cc = cos({p}Wt); {p}Sn = sin({p}Wt);
{p}Wn = {p}Wt * {p}Ta * samplerate;
{p}Ps = atan({p}Wn);
{p}Ag = 1 / (exp(-{p}Ps / {p}Wn) * sin({p}Ps));                        // 1 / the first peak of e^-t sin(wt)
"""
    body = f"""
{hit(slot, f"{p}Q = {p}Q + {p}Ag * hg{slot};")}
{p}Xt = {p}Rr * ({p}Cc * {p}S - {p}Sn * {p}Q); {p}Q = {p}Rr * ({p}Sn * {p}S + {p}Cc * {p}Q); {p}S = {p}Xt;
{p}_ring = {"tanh(drK * (0 - " + p + "S)) * drN" if drive else "0 - " + p + "S"};
"""
    return decl, top, body


def bd():
    d, t, b = ring("bd", "62.5 * exp2(bdTune / 12)", 100)
    return d, t, b + "bd_out = bd_ring;\n"


def lc():
    d, t, b = ring("lc", "208 * exp2(lcTune / 12)", 150)
    return d, t, b + "lc_out = lc_ring;\n"


def hb():
    d, t, b = ring("hb", "600 * exp2(hbTune / 12)", 40)
    return d, t, b + "hb_out = hb_ring;\n"


def lb():
    d, t, b = ring("lb", "400 * exp2(lbTune / 12)", 40)
    return d, t, b + "lb_out = lb_ring;\n"


def rs():
    d, t, b = ring("rs", "1480 * exp2(rsTune / 12)", 5, drive=False)
    return d, t, b + "rs_out = rs_ring;\n"


def cl():
    d, t, b = ring("cl", "2630 * exp2(clTune / 12)", 18, drive=False)
    return d, t, b + "cl_out = cl_ring;\n"


def sd():
    """ringing oscillator (Q505) + shared noise through the Q506 VCA and its own envelope; the noise's level and 2 kHz high-pass are
    fitted to the Core Library "Snare C78" sample (band levels within ~2 dB), not read from the board"""
    d, t, b = ring("sd", "340 * exp2(sdTune / 12)", 60)
    d += hist("sd", ["Ne", "Nz", "Nh", "Ny", "Np", "Nl"])
    t += f"""
sdTn = 60 * 0.001 * exp2(sdDec) / {LN10};
sdRn = exp(-1 / (sdTn * samplerate));
sdLk = exp(-twopi * 2000 / samplerate); sdLl = 1 - exp(-twopi * 9000 / samplerate);
sdNg = sdNoise * 0.01 * 14;
"""
    b = b.replace("if (hit2) { sdQ = sdQ + sdAg * hg2; }", "if (hit2) { sdQ = sdQ + sdAg * hg2; sdNe = hg2; }")
    b += """sdNz = sdLk * (sdNz + nz - sdNh); sdNh = nz;                 // two one-pole high-passes at 2 kHz
sdNy = sdLk * (sdNy + sdNz - sdNp); sdNp = sdNz;
sdNl = sdNl + sdLl * (sdNy - sdNl);                          // and a gentle 9 kHz low-pass
sd_out = sd_ring + sdNl * sdNe * sdNg;
sdNe = sdNe * sdRn;
"""
    return d, t, b


def hat_voice(p, td_ms, layer=True):
    """HH / CY / M: noise x its own envelope -> the shared LC band-pass. layer: hat and cymbal hits also fire the Metallic Beat (On Hats)"""
    slot = SLOT[p]
    decl = hist(p, ["E", "i1", "i2"]) + [f"History pt{slot}(0);"]
    top = f"{p}Re = exp(-1 / ({td_ms} * 0.001 * exp2({p}Dec) / {LN10} * samplerate));\n"
    extra = f"{p}E = hg{slot};"
    if layer and p in ("hh", "cy"):
        extra += f" mbHit = mbHit + (mbHats > 0.5) * hg{slot} * mbAmt * 0.01;"
    body = f"""
{hit(slot, extra)}
{svf("ha", p, "(nz * " + p + "E)", "hak")}
{p}E = {p}E * {p}Re;
{p}_out = {p}bp;
"""
    return decl, top, body


def hat_top():
    return f"""
haf = {TANK['hat']} * exp2(hatTone / 12);
hag = tan(pi * haf / samplerate); hak = {1 / TANK_Q['hat']};
{svf_coefs("ha", "hag", "hak")}
"""


def mb(layer=True):
    slot = SLOT["mb"]
    freqs = TABLE["mb"][0]
    decl = hist("mb", ["E", "Sl", "i1", "i2"] + [f"P{j}" for j in range(3)]) + [f"History pt{slot}(0);"]
    top = f"""
mbRs = 0.9 / (50 * 0.001 * exp2(mbDec) * samplerate);                  // linear ramp: 1/10 at the table's 50 ms
mbf = {TANK['mb']};
mbg = tan(pi * mbf / samplerate); mbk = {1 / TANK_Q['mb']};
{svf_coefs("mb", "mbg", "mbk")}
mbTu = exp2(mbTune / 12);
"""
    body = f"""
{hit(slot, f"mbE = hg{slot}; mbSl = mbE * mbRs;")}
""" + ("if (mbHit > 0) { mbE = mbHit; mbSl = mbE * mbRs; mbHit = 0; }\n" if layer else "")
    for j, f in enumerate(freqs):
        body += f"mbd{j} = {f} * mbTu / samplerate; mbP{j} = fract(mbP{j} + mbd{j});\n"
    body += f"mbsq = ({' + '.join(square(f'mbP{j}', f'mbd{j}') for j in range(3))}) * 0.3333;\n"
    body += f"mbv = mbsq * mbE; mbv = mbv + {MB_VCA} * mbv * mbv;\n"
    body += svf("mb", "mb", "mbv", "mbk") + "\nmbE = max(mbE - mbSl, 0);\nmb_out = mbbp;\n"
    if layer:
        decl.append("History mbHit(0);")
    return decl, top, body


def cb():
    slot = SLOT["cb"]
    decl = hist("cb", ["E", "Sl", "i1", "i2", "P1", "P2"]) + [f"History pt{slot}(0);"]
    top = f"""
cbRs = 0.9 / (60 * 0.001 * exp2(cbDec) * samplerate);                  // linear ramp: 1/10 at the table's 60 ms
cbf = {TANK['cb']} * exp2(cbTone / 12);
cbg = tan(pi * cbf / samplerate); cbk = {1 / TANK_Q['cb']};
{svf_coefs("cb", "cbg", "cbk")}
cbTu = exp2(cbTune / 12);
"""
    body = f"""
{hit(slot, f"cbE = hg{slot}; cbSl = cbE * cbRs;")}
cbP1 = fract(cbP1 + 800 * cbTu / samplerate); cbP2 = fract(cbP2 + 555 * cbTu / samplerate);
cbs1 = sin(twopi * cbP1); cbs2 = sin(twopi * cbP2);                    // phase-shift oscillators: sine-ish, each lopsided
cbo = 0.5 * (cbs2 + {CB_C2[0]} * (cbs2 * cbs2 - 0.5) + {CB_C3[0]} * cbs2 * cbs2 * cbs2 + cbs1 + {CB_C2[1]} * (cbs1 * cbs1 - 0.5) + {CB_C3[1]} * cbs1 * cbs1 * cbs1);
cbv = cbo * cbE; cbv = cbv + {CB_VCA} * cbv * cbv;
{svf("cb", "cb", "cbv", "cbk")}
cbE = max(cbE - cbSl, 0);
cb_out = cbbp;
"""
    return decl, top, body


def tb():
    slot = SLOT["tb"]
    decl = hist("tb", ["E", "i1", "i2", "D", "G"]) + [f"History pt{slot}(0);"]
    top = f"""
tbRe = exp(-1 / (220 * 0.001 * exp2(tbDec) / {LN10} * samplerate));
tbf = {TANK['tb']} * exp2(tbTone / 12);
tbg = tan(pi * tbf / samplerate); tbk = {1 / TANK_Q['tb']};
{svf_coefs("tb", "tbg", "tbk")}
tbDl = {TB_SHAKE_MS} * 0.001 * samplerate * (tbShake > 0.5);
"""
    body = f"""
{hit(slot, f"tbE = hg{slot}; tbG = hg{slot}; tbD = tbDl;")}
if (tbD > 0.5) {{ tbD = tbD - 1; if (tbD < 0.5) {{ tbE = 0.8 * tbG; }} }}
{svf("tb", "tb", "(nz * tbE)", "tbk")}
tbE = tbE * tbRe;
tb_out = tbbp;
"""
    return decl, top, body


def gu():
    s12, s13 = SLOT["guH"], SLOT["guL"]
    decl = hist("gu", ["i1", "i2", "Lo", "A", "Ph", "Rt", "T", "H", "Ge", "G"]) + ["History guW(1);", f"History pt{s12}(0);", f"History pt{s13}(0);"]
    top = f"""
gug = tan(pi * {TANK['gu']} * exp2(guTone / 12) / samplerate); guk = {1 / GU_Q};
{svf_coefs("gu", "gug", "guk")}
guLp = 1 - exp(-twopi * {GU_LP} / samplerate);
guWs = 1 / ({GU_GRAIN} * exp2(guDec) * samplerate);
guRu = exp2(guRate / 12);
guKa = 1 - exp(-1 / (0.001 * samplerate)); guKr = 1 - exp(-1 / (0.004 * samplerate));
"""
    body = f"""
{hit(s12, f"guRt = 125 * guRu; guPh = 1; guT = 0; guH = {GU_HOLD_MS} * 0.001 * samplerate; guGe = 1; guG = hg{s12};")}
{hit(s13, f"guRt = 77 * guRu; guPh = 1; guT = 0; guH = {GU_HOLD_MS} * 0.001 * samplerate; guGe = 1; guG = hg{s13};")}
guOn = ((gt12 + gt13) > 0.5) + (guH > 0.5);
guOn = (guOn > 0.5) * (guT < {GU_MAX_S} * samplerate);                  // the note length is the stroke, up to 1 s
guT = guT + 1; guH = guH - (guH > 0.5);
guGe = guGe + (guOn * guKa + (1 - guOn) * guKr) * (guOn - guGe);
guPh = guPh + guOn * guRt / samplerate;
guPu = guPh >= 1; guPh = guPh - guPu;
if (guPu) {{ guW = 0; guA = 1 + {GU_JIT} * nz; }}                    // each pulse opens one scrape grain, its level random
guW = guW + (guW < 1) * guWs * guRt / 77;
guSw = sin(pi * min(guW, 1)); guX = nz * guSw * guSw * guSw * guA * guG * guGe;
guv3 = guX - gui2; gub = gua1 * gui1 + gua2 * guv3; gul = gui2 + gua2 * gui1 + gua3 * guv3;
gui1 = 2 * gub - gui1; gui2 = 2 * gul - gui2;
guLo = guLo + guLp * (guX - guk * gub - gul - guLo);                      // resonant high-pass, then a gentle low-pass
gu_out = guLo;
"""
    return decl, top, body


# voice order, prefix -> generator; the output prefix is the voice's own
VOICES = [("bd", bd), ("rs", rs), ("sd", sd), ("hh", lambda layer=True: hat_voice("hh", 60, layer)),
          ("cy", lambda layer=True: hat_voice("cy", 350, layer)), ("ma", lambda layer=True: hat_voice("ma", 20, layer)), ("mb", mb), ("tb", tb), ("cb", cb), ("hb", hb), ("lb", lb), ("lc", lc),
          ("gu", gu), ("cl", cl)]


def gen_code():
    voices = [(p, *g()) for p, g in VOICES]
    code = [FUNCS] + [f"Param {n}({d});" for n, d in params() + EXTERNAL]
    for _, d, _, _ in voices:
        code += d
    code.append("""
accA = accent * 0.01;
drK = 0.01 + 0.04 * drive; drN = 1 / tanh(drK);
masterG = master * 0.01;
""" + hat_top())
    code += [t for _, _, t, _ in voices]
    code.append("nz = noise();                                   // the one noise source every noise voice shares")
    code += [b for _, _, _, b in voices]
    L, R = [], []
    for p, _ in VOICES:
        code.append(f"{p}pn = {p}Pan * 0.01; {p}gl = cos(({p}pn + 1) * pi * 0.25); {p}gr = sin(({p}pn + 1) * pi * 0.25); "
                    f"{p}vg = {p}Lvl * {CAL[p]:.6f};")
        L.append(f"{p}_out * {p}vg * {p}gl")
        R.append(f"{p}_out * {p}vg * {p}gr")
    code.append("mixl = (" + " + ".join(L) + ") * masterG; mixr = (" + " + ".join(R) + ") * masterG;")
    # soft limiter: linear below 0.8, tanh knee above (the instrument has no audio input; naming in1/in2 keeps the codebox's inlets)
    for ch, i in (("l", 1), ("r", 2)):
        code.append(f"ax{ch} = abs(mix{ch}); out{i} = sign(mix{ch}) * (min(ax{ch}, 0.8) + 0.2 * tanh(max(ax{ch} - 0.8, 0) * 5)) + 0 * in{i};")
    return "\n".join(code) + "\n"


LAYERED = ("hh", "cy", "ma", "mb")   # voices whose generator takes `layer` (the On Hats link)


def voice_code(only, names):
    """gen~ code for a single-voice device: just the voices in `only` (prefixes; the two bongos or the two guiro strokes may share one),
    the engine params in `names` (a voice's own controls, Accent, Drive) and `vol`, the Volume in dB (0 = the table amplitude, so with
    the same params and hits the output equals the full engine's mono sum, Level default, centre pan, sample for sample). No Pan,
    Master, layering or other voice; one limiter on both outputs. Hits arrive as in the full device (tr / vl, gt for the guiro)."""
    voices = [(p, *(g(False) if p in LAYERED else g())) for p, g in VOICES if p in only]
    slots = [SLOT[s] for p in only for s in (("guH", "guL") if p == "gu" else (p,))]
    meta = {n: d for n, d in params()}
    ext = [(f"tr{i}", 0) for i in slots] + [(f"vl{i}", 1) for i in slots] + ([("gt12", 0), ("gt13", 0)] if "gu" in only else [])
    code = [FUNCS] if "mb" in only else []
    code += [f"Param {n}({d});" for n, d in [(n, meta[n]) for n in names] + [("vol", 0)] + ext]
    for _, d, _, _ in voices:
        code += d
    hats = any(p in only for p in ("hh", "cy", "ma"))
    code.append("accA = accent * 0.01;\nvolG = dbtoa(vol);" + ("\ndrK = 0.01 + 0.04 * drive; drN = 1 / tanh(drK);" if "drive" in names else "") +
                ("\n" + hat_top() if hats else ""))
    code += [t for _, _, t, _ in voices]
    bodies = [b for _, _, _, b in voices]
    if any(re.search(r"\bnz\b", b) for b in bodies):
        code.append("nz = noise();                                   // the one noise source")
    code += bodies
    code.append("vmix = (" + " + ".join(f"{p}_out * volG * {TABLE[p][2]} * {CAL[p]:.6f}" for p, _, _, _ in voices) + ");")
    # the same soft limiter as the full device (naming in1 / in2 keeps the codebox's inlets)
    code.append("axm = abs(vmix); out1 = sign(vmix) * (min(axm, 0.8) + 0.2 * tanh(max(axm - 0.8, 0) * 5)) + 0 * in1;\nout2 = out1 + 0 * in2;")
    return "\n".join(code) + "\n"


if __name__ == "__main__":
    print(gen_code())
