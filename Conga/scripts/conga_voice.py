"""conga_voice.py -- gen~ code for Conga Voice: ONE drum (14 resonators) whose drum and stroke are chosen at run time.
Same model, tables and arithmetic as conga_engine.py (the full device); only the selection differs. Any note plays it (a counter `trg`
with the velocity `vel`), the Params `drum` (0 quinto, 1 conga, 2 tumba) and `stroke` (0 open, 1 slap, 2 mute, 3 bass, 4 heel, 5 toe)
are read when the hit lands, so changing Stroke between hits works and the new stroke's hand damps the ring still on the head
(kp, G, tau act on the live resonator state, exactly as one drum of the full device does when a mute follows an open).
Output is mono (the full device's centre pan, 0.7071 per side, so the level matches Conga at Spread 0).

First-compile trap (playbook 4): no ternary / max / min / clamp on an expression that depends only on Params at the top level.
`stroke`, `drum`, `vel` are Params, so everything derived from them lives inside the hit block and is multiplied by vh (a comparison of
`trg` with the History `pt`), the way the full engine's stroke index comes from its History-compared counters; the tuning (drum, tune) is
computed in the control-rate block, whose condition is a History too.
"""
import math

import conga_engine as E

# (name, long name, min, max, default, unit, hover text). Names are the gen~ Params; menus have unit None and an enum
DRUM_MENU = [d for _, d in E.DRUMS]
STROKE_MENU = [s.capitalize() for s in E.STROKES]
PARAMS = [
    ("drum", "Drum", 0, 2, 1, None, "Which drum: Quinto (the high one, open tone 366 Hz), Conga (266 Hz) or Tumba (the low one, 219 Hz). Any MIDI note plays it."),
    ("stroke", "Stroke", 0, 5, 0, None, "Which hand stroke a note plays: Open (abierto, the ringing tone), Slap (seco, the crack), Mute (tapado, the dead thud), "
                                         "Bass (palm in the middle), Heel (the heel of the hand) or Toe (fingertips). Changing it between hits works: the new stroke damps the ring already on the head."),
    ("tune", "Tune", -12, 12, 0, "st", "Tuning in semitones. 0 is the drum's open tone (quinto 366 Hz, conga 266 Hz, tumba 219 Hz)."),
    ("decay", "Decay", 30, 300, 100, "pct", "How long the head rings, in percent of the natural time (the open tone's T60 is about half a second)."),
    ("skin", "Skin", 0, 100, 50, "pct", "Brightness of the head: tilts the strength of the overtones against the fundamental. 50 % is the recording."),
    ("slap", "Slap", 0, 100, 50, "pct", "Character of the Slap stroke: the crack of the fingers on the rim (noise) and how far up the overtones are driven. No effect on other strokes."),
    ("shell", "Shell", 0, 100, 50, "pct", "The body of the drum: how much the low modes (air in the shell, the heel and bass thump) speak."),
    ("touch", "Touch", 0, 100, 50, "pct", "How much velocity changes the tone: harder hits are shorter in contact (brighter) as well as louder."),
    ("press", "Press", 0, 12, 5, "st", "The mod wheel presses the head (elbow or palm on it): this many semitones up at full wheel."),
    ("volume", "Volume", -36, 6, -9, "db", "Output level."),
]
EXTERNAL = [("trg", 0), ("vel", 1), ("mw", 0)]
CENTRE = math.cos(math.pi * 0.25)       # the full device's conga at Spread 0 / any drum at centre pan


def code(tables=None, cal=(1.0, 1.0, 1.0)):  # noqa: C901
    T = tables or E.load_tables()
    S = [T[s] for s in E.STROKES]
    sel, NM = E.sel, E.NM

    def by_drum(f):     # 18 values, drum-major, for sel(vk, ...)
        return [f(i, d) for d in range(3) for i in range(6)]

    out = [f"Param {n}({d});" for n, d in [(p[0], p[4]) for p in PARAMS] + EXTERNAL]
    out += ["History cnt(0);", "History pf(1);", "History pt(0);", "History vC(0);", "History vCk(0.99);", "History vE1(0);",
            "History vE2(0);", "History vK(0.5);", "History vNe(0);", "History vNr(0.99);", "History vI1(0);", "History vI2(0);",
            "History vNa1(0);", "History vNa2(0);", "History vNa3(0);", "History vNk(1);", "History vAm(0);", "History vF1(300);"]
    for m in range(NM):
        out += [f"History vX{m}(0);", f"History vY{m}(0);", f"History vW{m}(0);", f"History vG{m}(1);", f"History vCc{m}(1);",
                f"History vSn{m}(0);", f"History vR{m}(0.999);"]
    out.append("""
decayS = decay * 0.01;
skinT = (skin - 50) * 0.02 * 6 / 6.0206;                      // +-6 dB per octave of mode ratio at the ends
shellG = shell * 0.02;
slapG = slap * 0.02;
touchG = touch * 0.01 * 1.0;
pfT = exp2(mw * press / 12);
masterG = dbtoa(volume);""")
    for m, (u, _) in enumerate(E.MODES):
        out.append(f"vSk{m} = exp(skinT * {math.log(u):.6f})" + (" * shellG;" if m < 2 else ";"))
    out.append(f"cnt = cnt + 1; ctl = cnt >= {E.CTL}; cnt = cnt - ctl * {E.CTL};\nif (ctl) {{ pf = pf + 0.2 * (pfT - pf); }}")
    out.append("nz = noise();")
    out.append("vh = trg != pt; pt = trg;")
    hit = ["vds = vh * stroke;                                   // History-derived: the stroke and velocity at the hit",
           "vdv = vh * vel;",
           "vk = drum * 6 + vds;",
           "vs1 = abs(vds - 1) < 0.5;",
           "vg = pow(vdv, 1.4);",
           f"vAm = vg * ({sel('vk', by_drum(lambda i, d: S[i]['A'][d] * cal[d]))});",
           "vIm = vAm;",
           f"vfc = ({sel('vds', [S[i]['fc'] for i in range(6)])}) * exp2((touchG * (vdv - 0.6) * 2) + vs1 * (slapG - 1));",
           "vK = 1 - exp(-twopi * min(vfc, 18000) / samplerate);",
           "vC = 1;",
           f"vCk = exp(-{E.CTL} / (({sel('vds', [S[i]['tau'] for i in range(6)])}) * samplerate));",
           f"vNe = vAm * ({sel('drum', E.NOISE_DRUM)}) * ({sel('vds', [S[i]['nl'] for i in range(6)])}) * (1 + vs1 * (slapG * 2 - 2));",
           f"vNr = exp(-1 / (({sel('vds', [S[i]['nt'] for i in range(6)])}) * samplerate));",
           f"vNg = tan(pi * ({sel('vds', [S[i]['nf'] for i in range(6)])}) / samplerate); vNk = 1 / ({sel('vds', [S[i]['nq'] for i in range(6)])});",
           E.svf_coefs("vN", "vNg", "vNk")]
    for m in range(NM):
        ws = [E.db(S[i]["W"][m]) for i in range(6)]
        gs = [S[i]["G"][m] for i in range(6)]
        hit.append(f"vW{m} = ({sel('vds', ws)}) * vSk{m}; vG{m} = {sel('vds', gs)};")
    hit.append(f"vkp = {sel('vds', [S[i]['kp'] for i in range(6)])};")
    for m in range(NM):
        hit.append(f"vX{m} = vX{m} * vkp; vY{m} = vY{m} * vkp;")
    # vIm must be 0 on the samples between hits: the exciter is one impulse
    out.append("vIm = 0;")
    out.append("if (vh > 0.5) {\n" + "\n".join(hit) + "\n}")
    out.append("vE1 = vE1 + vK * (vIm - vE1); vE2 = vE2 + vK * (vE1 - vE2);")
    ctl = [f"vC = vC * vCk;", f"vF1 = ({sel('drum', E.F1)}) * exp2(tune / 12);"]
    for m, (u, t60) in enumerate(E.MODES):
        ctl.append(f"vw = twopi * vF1 * pf * {u} / samplerate; vCc{m} = cos(vw); vSn{m} = sin(vw); "
                   f"vR{m} = exp(-{E.LN60 / t60:.6f} * (1 + (vG{m} - 1) * vC) / (decayS * {E.T60_DRUM[0]} * samplerate));")
    out.append("if (ctl) {\n" + "\n".join(ctl) + "\n}")
    for m in range(NM):
        out.append(f"vXn = vR{m} * (vCc{m} * vX{m} - vSn{m} * vY{m}) + vW{m} * vE2; "
                   f"vY{m} = vR{m} * (vSn{m} * vX{m} + vCc{m} * vY{m}); vX{m} = vXn;")
    out.append("vSm = " + " + ".join(f"vY{m}" for m in range(NM)) + ";")
    out.append("vNx = nz * vNe; vNe = vNe * vNr;")
    out.append("vNv3 = vNx - vI2; vNb = vNa1 * vI1 + vNa2 * vNv3; vNl = vI2 + vNa2 * vI1 + vNa3 * vNv3; "
               "vI1 = 2 * vNb - vI1; vI2 = 2 * vNl - vI2;")
    out.append(f"vmix = (vSm + vNk * vNb) * {CENTRE:.15f} * masterG;")
    out.append("vax = abs(vmix); vlim = sign(vmix) * (min(vax, 0.8) + 0.2 * tanh(max(vax - 0.8, 0) * 5));")
    out.append("out1 = vlim + 0 * in1; out2 = vlim + 0 * in2;")
    return "\n".join(out) + "\n"


if __name__ == "__main__":
    print(code())
