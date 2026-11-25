#!/usr/bin/env python3
"""cuica_engine.py — generates the Cuica gen~ codebox (GenExpr). Imported by build_maxpat.py; never hand-edit the output.

A monophonic friction drum, deliberately simple (docs/SPEC.md):
  rod     : (round 6) the damp cloth's friction on the rod, against the head's first 3 modes (mode 1 at the note, 2 and 3 at 3.5x and
            6.2x, Vienna Talk 2015's head). A hyperbolic friction law, stick or slip solved in closed form every sample (one sqrt, no
            iteration: docs/research/friction.md section 3). Its inputs are the rub velocity (the stroke envelope x Speed x velocity) and
            the normal force = grip (Pressure, or MPE Slide set to Grip) x the stroke's speed, so the regimes depend only on grip and on
            the rub's rise and fall. Out of that come: grip flattening the note (mode 1 is tuned sharp to cancel it up to the default
            Pressure, so only a harder grip goes flat, ~35 ct at full: tests/test_engine.js 3c measures +9 ct at the default, -25 at full), the sag as the rub eases, the creak and raucous or period-2 motion
            when a slow rub meets a hard grip (stroke ends, light MPE pressure), and a noisier onset on low notes. Rasp is the
            wildness: mode 2-3's mobility (how much of the head joins in) and the SDT friction noise. Still set by hand: the hand's bite
            at a stroke's start (extra force for 30 ms, so low notes speak quickly), the grip letting go as the rub stops, and a tuning
            correction for sampling (high notes run sharp). The rod's velocity drives the head colour below. (Earlier: a bowed waveguide,
            then a scripted stick-slip wave with jitter, burst and sag: rounds 1-5.)
  strokes : every note is one stroke, a raised-cosine rub velocity over Stroke ms, started at quarter phase (already moving,
            so it speaks within a few ms) and done at 3/4 of Stroke, however long the note is held. Alt: On alternates push and pull note by note; Auto alternates
            only quick notes (within one Stroke of the last) and starts again on a push after a pause;
            the pull is Pull semitones higher and a bit louder. MPE pressure (pr) rubs on for as long as it is held: the rub
            velocity is the larger of the stroke and the pressure (times MPE Pressure, pram). MPE Slide (sld) goes to the thumb, the
            head's tension, the brightness or the grip, or nowhere.
  head    : what we hear is the membrane, not the rod: the rod's motion drives the head's first mode, a resonant low-pass (two
            cascaded SVFs) at max(f, Head Hz). A high stroke sits on the resonance and comes out nearly sinusoidal; a low stroke (the
            grunt) stick-slips below it, so its low harmonics are lifted and everything above ~1 kHz is gone (fitted to the Latin
            Percussion pack's cuica samples, tests/analyze.py). 3 quiet resonators on the inharmonic modes (f * 2.296, 3.598, 4.903).
  release : when the rubbing stops (stroke over, no pressure) the head rings on for Decay (time to -60 dB) at the pitch the rod last
            made (mode 1's zero crossings), the resonators too.
  pitch   : target = note + Tune + bend + MPE bend + Thumb * max(wheel, MPE slide if Slide is Thumb) + Pull * pullstroke; a new (non-legato) note starts at target + Scoop and
            glides with a time constant of Glide / 3 (so Glide is about the time to settle). A legato note glides from where it is.

Params from cuica_midi.js: nt note, vl velocity 0..1, hold gate, lg legato flag (a note was already held), tr note-on counter (a change =
a new note: gen~ only sees the last Param value per block, so gate edges cannot be used: see gen-param-gate-collapse), mw 0..1,
bend semitones.
"""

RATIO = [2.296, 3.598, 4.903]
# the rod: a hyperbolic friction law (mu = MUD + (MUS - MUD) * V0 / (V0 + slip)) against the head's first 3 modes
MUS, MUD, V0 = 0.8, 0.3, 0.1
GF = 0.8   # normal force per unit grip, re the mode's m * w0 and the stroke's speed: the regimes sit at the same grip at every
          # pitch and speed, and only the rub's rise and fall within a stroke moves them
GMIN, GSP = 0.135, 0.9   # grip = GMIN + GSP * Pressure^2 (the cloth always touches; full grip is ~35 ct flatter than the default mid-stroke, measured)
COMP = 49   # cents mode 1 is tuned sharp per unit grip, up to the default Pressure's grip (GD): it cancels the flattening there, so
            # light grips sit in tune and only gripping harder than the default flattens (it emerges, it is not added)
GD = GMIN + GSP * 0.55 ** 2
MR, MQ = [1, 3.5, 6.2], [80, 30, 30]   # head mode ratios (Vienna Talk 2015: 220, 750/820, 942, 1360 Hz) and Qs
IM2, IMR = 0.1, 1.6   # mode 2's mobility re mode 1 (mode 3 half of it); Rasp adds IMR: the head joins in, the motion turns wild
MW = 0.3   # how much modes 2-3 radiate, re mode 1 (the friction force as the source instead: richer, but its period-2 and spikes broke
           # every stroke measure)
DSC = 0.03   # stick and slip land on sample boundaries, so high notes run sharp (+14 ct at 2 kHz, 48 kHz): ~50 ct per radian/sample back
ERL = 0.06   # the hand lets go of the grip over the last ERL of the rub (or the cloth would clamp the head dead at the turn)
S3 = 20   # friction noise: S3 * Rasp * noise * sqrt(|v| * force) (SDT)
ATT = 0.035   # s, the rub's attack ramp
BITE, BT = 3, 0.03   # the grip's bite at a stroke's start: up to 1 + BITE times, gone in BT s
RG = 0.2   # the head ringing on after the rub, re the membrane output
HPF = 200
DRV = 2   # the head stiffens as it swings: a symmetric soft limit lifts H3 to about H2, as in the real strokes
MK, MG = 0.2, 4.5   # head mode damping (1/Q) and the output gain of the membrane
FMIN, FMAX = 12, 112   # MIDI range of the pitch target

# Params: name -> default (engine units). The builder maps live.* controls onto these.
PARAMS = [("tune", 0), ("press", 0.55), ("speed", 0.6), ("stroke", 300), ("pull", 2), ("scoop", -4), ("glide", 60),
          ("thumb", 12), ("head", 0.5), ("rasp", 0.25), ("tone", 0.6), ("decay", 400), ("vol", -6),
          ("nt", 60), ("vl", 0), ("hold", 0), ("lg", 0), ("tr", 0), ("mw", 0), ("bend", 0), ("pr", 0), ("sl", 0), ("pbn", 0), ("pram", 1), ("sld", 1), ("alt", 1)]


def f(x):   # plain decimals only: exponent literals break the codebox
    s = f"{x:.10f}".rstrip("0")
    return s + "0" if s.endswith(".") else s


def code():
    L = ["// Cuica engine. GENERATED by scripts/cuica_engine.py: do not edit."]
    for n, d in PARAMS:
        L.append(f"Param {n}({f(d)});")
    for n, d in (("ctl", 0), ("ltr", 0), ("pcur", 60), ("tg", 60), ("kg", 0.01), ("phs", 1), ("since", 1000000), ("pullf", 1), ("vlv", 0.8),
                 ("cont", 0), ("kc", 0.01), ("kr", 0.001), ("dph", 0.0001), ("tlp", 1),
                 ("ma1", 0), ("ma2", 0), ("ma3", 0), ("mb1", 0), ("mb2", 0), ("mb3", 0), ("mc1", 0), ("mc2", 0),
                 ("md1", 0), ("md2", 0), ("scp", 0), ("katt", 0.001), ("kbt", 0.001), ("fql", 440), ("gc", 0), ("gq", 0), ("gg", 0), ("g1", 0), ("g2", 0), ("he1", 0), ("he2", 0), ("hg", 0.01), ("ha1", 1), ("ha2", 0), ("ha3", 0), ("dcx", 0), ("dcy", 0), ("newn", 0), ("hmix", 0.4), ("grp", 0.55), ("zx1", 0), ("zxp", 0), ("zn", 0), ("zr", 1), ("zv1", 0), ("zx2", 0), ("zv2", 0), ("zx3", 0), ("zv3", 0)):
        L.append(f"History {n}({f(d)});")
    for k in range(3):
        for n in ("c", "q", "g", "a", "b"):
            L.append(f"History r{n}{k}(0);")
    L.append(f"""
ctl = ctl + 1;
ctl = ctl * (ctl < 32);
upd = ctl == 0;
newn = 0;
if (tr != ltr) {{
    ltr = tr;
    newn = 1;
    vlv = vl;
    phs = 0.25;
    scp = (lg < 0.5) * scoop * (1 + 0.25 * noise());   // the squeak: this stroke's scoop, a little different every time
    // Alt: 0 Off (every note a push), 1 Auto (a note within one Stroke of the last one alternates; after a pause, a push), 2 On
    quick = since < stroke * 0.001 * samplerate;
    pullf = ((alt > 1.5) + (abs(alt - 1) < 0.5) * quick > 0) * (1 - pullf);
    since = 0;
    if (lg < 0.5) {{
        pcur = clamp(nt + tune + bend + pbn + thumb * max(mw, sl * (abs(sld - 1) < 0.5)) + pull * pullf, {FMIN}, {FMAX});
    }}
}}
if (upd + newn) {{
    hd = min(head + sl * (abs(sld - 2) < 0.5), 1);   // MPE slide can raise the head's tension or the brightness
    tn = min(tone + sl * (abs(sld - 3) < 0.5), 1);
    tg = clamp(nt + tune + bend + pbn + thumb * max(mw, sl * (abs(sld - 1) < 0.5)) + pull * pullf, {FMIN}, {FMAX});
    kg = 1 - exp(-3 / (max(glide, 0.5) * 0.001 * samplerate));
    kc = 1 - exp(-1 / (0.003 * samplerate));
    dph = 1 / (max(stroke, 20) * 0.001 * samplerate);
    kr = 1 - exp(-6.9078 / (0.04 * samplerate));   // the cloth leaves the rod: the drive is gone in 40 ms, the head rings on
    katt = 1 / ({f(ATT)} * samplerate);
    kbt = 1 / ({f(BT)} * samplerate);
    grp = min(press + sl * (abs(sld - 4) < 0.5), 1);   // MPE slide can grip harder
    f0 = mtof(pcur);
    hq = 4 + 36 * hd;
    hmix = 0.15;
    fm = min(max(f0, 250 * pow(4, hd)), samplerate * 0.4);
    gm = tan(3.1415927 * fm / samplerate);
    gtn = tan(3.1415927 * min(fm * (1.2 + 3 * tn), samplerate * 0.4) / samplerate);
    ma1 = 1 / (1 + gm * (gm + MK));
    ma2 = gm * ma1;
    ma3 = gm * ma2;
    hg = tan(3.1415927 * HPF / samplerate);
    ha1 = 1 / (1 + hg * (hg + 1.4142));
    ha2 = hg * ha1;
    ha3 = hg * ha2;
    mb1 = 1 / (1 + gtn * (gtn + 1.4142));
    mb2 = gtn * mb1;
    mb3 = gtn * mb2;
    rdec = exp(-6.9078 / (max(decay, 5) * 0.001 * samplerate));
    wg = twopi * min(fql, samplerate * 0.45) / samplerate;   // the head's free ring at the sounding pitch, Decay to -60 dB
    gc = 2 * rdec * cos(wg);
    gq = rdec * rdec;
    gg = 2 * (1 - rdec) * sin(wg);""")
    for k, r in enumerate(RATIO):
        L.append(f"""    fk = f0 * {f(r)};
    ok = fk < samplerate * 0.45;
    wk = twopi * min(fk, samplerate * 0.45) / samplerate;
    rk = exp(-3.1415927 * fk / (hq * samplerate)) * pow(rdec, 1 - cont);
    rc{k} = 2 * rk * cos(wk);
    rq{k} = rk * rk;
    rg{k} = 2 * (1 - rk) * sin(wk) * ok;""")
    L.append(f"""}}

// ---- strokes
phs = min(phs + dph, 1);
since = min(since + 1, 1000000);
prh = pr * pram * (hold > 0.5);
env0 = max(0.5 * (1 - cos(twopi * phs)), prh);
env = env0 * min(since * katt, 1);
prg = clamp((phs - 0.25) * 2.8571, 0, 1);   // the scoop rides the stroke: arrives at 60 % of it, just past the hardest rub
prg = prg * prg * (3 - 2 * prg);
rub = (phs < 1) + (prh > 0.01) > 0;
vnm = (0.08 + 0.55 * speed) * (0.4 + 0.6 * vlv) * (1 + 0.2 * pullf);   // this stroke's speed
vb = env * vnm * cont;
cont = cont + (rub - cont) * (kr + (kc - kr) * rub);
pcur = pcur + (tg - pcur) * kg;

// ---- the rod: the cloth's friction (hyperbolic law) on the head's first 3 modes, stick or slip solved in closed form each sample.
// Grip flattens the pitch; a slow rub under grip sticks longer: the sag, the creak, raucous or period-2 motion. None of it is scripted.
gp = {f(GMIN)} + {f(GSP)} * grp * grp;
fq = mtof(pcur + scp * (1 - prg) + {f(COMP / 100)} * min(gp, {f(GD)}));
th1 = twopi * fq / samplerate;
th1 = min(th1 * (1 - {f(DSC)} * th1), 1.5);   // stick and slip happen on sample boundaries, which sharpens high notes: tuned back
// the normal force: the hand bites as a stroke starts (a clean attack needs extra force, Guettler 2002) and lets go as the rub stops
fnr = gp * vnm * th1 * samplerate * {f(GF)} * cont * min(env0 * {f(1 / ERL)}, 1) * (1 + {f(BITE)} * max(1 - since * kbt, 0));
imb = {f(IM2)} + {f(IMR)} * rasp;""")
    for k, (r, q) in enumerate(zip(MR, MQ), 1):
        L.append(f"""thz = min(th1 * {f(r)}, 1.5);
ez = 2 * sin(thz * 0.5) * samplerate;
oz{k} = th1 * {f(r)} < 1.5;
zt{k} = zv{k} - (ez / {f(q)} * zv{k} + ez * ez * zx{k}) / samplerate;""")
    L.append(f"""im2 = imb * oz2;
im3 = imb * 0.5 * oz3;
hh = (1 + im2 + im3) / samplerate;
dz = vb - zt1 - zt2 * oz2 - zt3 * oz3;   // the slip velocity if the cloth let go
adz = abs(dz);
fa = {f(MUD)} * fnr;
fbb = {f(V0)} + adz;
dsc = (fbb - fa * hh) * (fbb - fa * hh) - 4 * hh * fnr * {f((MUS - MUD) * V0)};
sti = adz <= {f(MUS)} * fnr * hh;
ff = sti * dz / hh + (1 - sti) * sign(dz) * ((fbb + fa * hh) - sqrt(max(dsc, 0))) / (2 * hh);
ff = ff + {f(S3)} * rasp * noise() * sqrt(abs(vb) * fnr);
zv1 = clamp(zt1 + ff / samplerate, -4, 4);   // guards: no state can run away
zv2 = clamp(zt2 + im2 * ff / samplerate, -4, 4);
zv3 = clamp(zt3 + im3 * ff / samplerate, -4, 4);
zx1 = clamp(zx1 + zv1 / samplerate, -1, 1);
zx2 = clamp(zx2 + zv2 / samplerate, -1, 1);
zx3 = clamp(zx3 + zv3 / samplerate, -1, 1);
fil = zv1 + {f(MW)} * (zv2 * oz2 + zv3 * oz3);   // the higher modes have cancelling zones: they radiate less than they move
// the head rings on at the pitch the rod actually made (grip and sag move it off fq): mode 1's upward zero crossings while rubbed
// give the ratio to fq, so the ring still follows glides and the thumb at once
zc = (zx1 > 0) * (zxp <= 0);
zxp = zx1;
zn = zn + 1;
zq = samplerate / max(zn, 1) / fq;
zr = zr + zc * (fnr > 0) * (zq > 0.67) * (zq < 1.2) * (zq - zr) * 0.5;   // near 1 only: the head rings at its own pitch, not a creak's
zr = newn + (1 - newn) * zr;
fql = fq * zr;
zn = zn * (1 - zc);

// ---- the head's first mode: two cascaded TPT state-variable low-passes at fm (the first resonant)
v3 = fil - mc2;
v1 = ma1 * mc1 + ma2 * v3;
v2 = mc2 + ma2 * mc1 + ma3 * v3;
mc1 = 2 * v1 - mc1;
mc2 = 2 * v2 - mc2;
w3 = v2 - md2;
w1 = mb1 * md1 + mb2 * w3;
w2 = md2 + mb2 * md1 + mb3 * w3;
md1 = 2 * w1 - md1;
md2 = 2 * w2 - md2;
// a small drum barely radiates its lowest notes: a 2-pole high-pass at HPF Hz (a low stroke's fundamental sits ~9 dB under H2-H4)
u3 = w2 - he2;
u1 = ha1 * he1 + ha2 * u3;
u2 = he2 + ha2 * he1 + ha3 * u3;
he1 = 2 * u1 - he1;
he2 = 2 * u2 - he2;
mem = w2 - 1.4142 * u1 - u2;

// ---- membrane resonators
res = 0;""")
    for k in range(3):
        L.append(f"""ry{k} = rc{k} * ra{k} - rq{k} * rb{k} + rg{k} * mem;
rb{k} = ra{k};
ra{k} = ry{k};
res = res + ry{k};""")
    L.append("""
hm = tanh(mem * DRV) / DRV * MG / (1 + fq * 0.0005);
gy = gc * g1 - gq * g2 + gg * hm;
g2 = g1;
g1 = gy;
mx = hm + RG * gy + hmix * res * 3;
dcy = mx - dcx + 0.995 * dcy;
dcx = mx;
y = tanh(dcy * dbtoa(vol) * 0.6);
out1 = y;
out2 = y + 0 * in1;""")
    return "\n".join(L).replace("MK", f(MK)).replace("MG", f(MG)).replace("HPF", f(HPF)).replace("DRV", f(DRV)).replace("RG", f(RG)) + "\n"


if __name__ == "__main__":
    print(code())
