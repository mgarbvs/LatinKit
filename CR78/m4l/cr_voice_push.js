// cr_voice_push.js — a CR78 voice on the Push 3 screen (push_kit.js: Live 13 / Looplet style). One script for all 13 voices: the first
// argument names the voice (kick snare rim clave bongo conga hat cymbal maracas metal cowbell tamb guiro), the patch sends it `hit <note> <velocity 0..1>`.
// One page, the same look for every voice: under Tune/Tone/Rate + Decay (encoders 1-2) the voice in time (its ringing oscillator, noise burst, three
// squares... under the envelope the board gives it), swept by a playhead on every hit; under the extras (encoders 3-5) the voice's tone circuit as a
// spectrum (bridged-T ring, LC band-pass, the oscillators' lines through the tank); under Drive its soft-clip curve; under Accent what velocity does
// to the level. Volume (encoder 8) keeps Push's dial.
// Controls are read by varname: tune tone rate decay noise bongo shake stroke drive accent.
inlets = 1;
var PK_BANKS = ["Voice"];                       // must match build_voices.py push_bank()
var PK_LAYOUT = { Voice: "CCCCCCCD" };
include("push_kit.js");

// k: ring (one pinged resonator), snare (ring + shared noise), noise (noise burst through an LC band-pass), mb (three squares), cb (two oscillators
// through a tank), gu (scrape grains). f: oscillator Hz; td: ms to 1/10 amplitude; q: tank Q; main: the first encoder's control;
// ex: the extras (encoders 3-5); drv: has Drive; tx: the extras change the time picture.
var SPEC = {
    kick:    { k: "ring",  f: 62.5, td: 100, drv: 1, main: "tune", ex: [] },
    snare:   { k: "snare", f: 340,  td: 60,  drv: 1, main: "tune", ex: ["noise"], tx: 1 },
    rim:     { k: "ring",  f: 1480, td: 5,   main: "tune", ex: [] },
    clave:   { k: "ring",  f: 2630, td: 18,  main: "tune", ex: [] },
    bongo:   { k: "ring",  f: 600,  td: 40,  drv: 1, main: "tune", ex: ["bongo"], tx: 1 },
    conga:   { k: "ring",  f: 208,  td: 150, drv: 1, main: "tune", ex: [] },
    hat:     { k: "noise", f: 8700, td: 60,  q: 11, main: "tone", ex: [] },
    cymbal:  { k: "noise", f: 8700, td: 350, q: 11, main: "tone", ex: [] },
    maracas: { k: "noise", f: 8700, td: 20,  q: 11, main: "tone", ex: [] },
    metal:   { k: "mb",    f: 6200, td: 50,  q: 5,  main: "tune", ex: [] },
    cowbell: { k: "cb",    f: 1660, td: 60,  q: 1.73, main: "tune", ex: ["tone"] },
    tamb:    { k: "noise", f: 4400, td: 220, q: 17.5, main: "tone", ex: ["shake"], tx: 1 },
    guiro:   { k: "gu",    f: 5900, td: 0,   q: 10, main: "rate", ex: ["stroke", "tone"], tx: 1 }
};
var NAME = "kick", V = SPEC.kick;
var MB = [6170, 5620, 4080], MB_CYC = [18, 16.4, 11.9], CB = [800, 555];   // metal / cowbell oscillators: Hz, cycles drawn in the window
var FMIN = 30, FMAX = 20000;
var flash = 0, sweep = -1, lastVel = -1;

function setVoice(n) { NAME = n; V = SPEC[n]; }
setVoice(jsarguments.length > 1 && SPEC[String(jsarguments[1])] ? String(jsarguments[1]) : "kick");

function hit(n, v) { flash = 0.4 + 0.6 * v; sweep = 0; lastVel = v; }

function pkTick() {
    flash *= 0.85; if (flash < 0.02) flash = 0;
    if (sweep >= 0) { sweep += 33 / Math.max(winMs(), 300); if (sweep > 1.2) sweep = -1; }
}

// ── pure helpers (node test) ──
function log2(x) { return Math.log(x) / Math.LN2; }
function tanh(x) { var e = Math.exp(2 * x); return (e - 1) / (e + 1); }
function hash(i) { var s = Math.sin(i * 12.9898) * 43758.5453; return s - Math.floor(s); }
function expEnv(t, td, dec) { return Math.exp(-t * Math.LN10 / (td * dec)); }          // t, td in ms: 1/10 amplitude at td
function linEnv(t, td, dec) { return Math.max(0, 1 - 0.9 * t / (td * dec)); }          // metal / cowbell: a linear ramp
function accGain(acc, v) { var a = acc / 100; return (1 - a) + 1.27 * a * v; }         // cr_engine hit(): velocity 100 = 1
function driveCurve(x, drive) { var k = 0.01 + 0.04 * drive; return tanh(k * x) / tanh(k); }
function bp(f, f0, q) { var r = f / f0 - f0 / f; return 1 / Math.sqrt(1 + q * q * r * r); }
function hp(f, f0, q) { var x = f / f0; return x * x / Math.sqrt((1 - x * x) * (1 - x * x) + x * x / (q * q)); }
function cycles(f) { return Math.min(20, Math.max(5, 6 + 2.5 * log2(f / 62.5))); }     // cycles drawn for a ring of f Hz, readable
function ringQ(f, td, dec) { return Math.max(1.2, Math.PI * f * td * dec / 1000 / Math.LN10); }
function bankFor(n) {
    var s = SPEC[n], m = { tune: "Tune", tone: "Tone", rate: "Rate" }, e = [m[s.main], "Decay"], i;
    for (i = 0; i < s.ex.length; i++) e.push(s.ex[i].charAt(0).toUpperCase() + s.ex[i].slice(1));
    while (e.length < 5) e.push("-");
    return e.concat([s.drv ? "Drive" : "-", "Accent", "Volume"]);
}
function winMs() { return V.k === "gu" ? 160 : 2.5 * V.td; }

// ── pictures ──
function path(g, x0, x1, step, cut, yf) {
    for (var x = x0, n = 0; x <= cut + 0.01; x += step, n++) {
        if (n) g.line_to(x, yf(x)); else g.move_to(x, yf(x));
    }
}
function plot(g, x0, x1, step, cut, yf, cDim, cLit) {        // a curve: grey, then lit up to the playhead
    g.set_source_rgba(cDim); path(g, x0, x1, step, x1, yf); g.stroke();
    if (cut > x0) { g.set_source_rgba(cLit); path(g, x0, x1, step, Math.min(cut, x1), yf); g.stroke(); }
}
function bars(g, x0, x1, cy, cut, hf, cDim, cLit) {          // vertical lines, h px each side of the axis
    for (var pass = 0; pass < 2; pass++) {
        g.set_source_rgba(pass ? cLit : cDim);
        for (var x = x0, i = 0; x <= x1; x += 2, i++) {
            if ((x < cut) !== (pass === 1)) continue;
            var h = hf((x - x0) / (x1 - x0), i); g.move_to(x, cy - h); g.line_to(x, cy + h);
        }
        g.stroke();
    }
}

function drawTime(g, x0, x1) {
    var cy = 99, a = 30, W = winMs(), dec = Math.pow(2, pkVal("decay")), tn = pkVal(V.main), hot = pkAny(0, 1) || (V.tx && pkAny(2, 4));
    var cut = sweep >= 0 ? x0 + (x1 - x0) * sweep : x0, cLit = hot ? PK_WHITE : pkAccent, cDim = hot ? PK_WHITE : PK_MID, k = V.k;
    var tr = V.main === "tune" ? Math.pow(2, tn / 12) : 1, f = V.f, e;
    if (k === "ring" && NAME === "bongo" && pkVal("bongo") > 0.5) f = 400;
    var env = function (u) { return k === "mb" || k === "cb" ? linEnv(u * W, V.td, dec) : expEnv(u * W, V.td, dec); };
    if (k === "tb" || NAME === "tamb") env = function (u) {   // Shake: the envelope is kicked again at 70 ms to 0.8
        var t = u * W; return pkVal("shake") > 0.5 && t >= 70 ? 0.8 * expEnv(t - 70, V.td, dec) : expEnv(t, V.td, dec);
    };
    pkFill(g, PK_LANE, x0, cy, x1 - x0, 1, 0);
    g.set_line_width(1);
    if (k !== "gu") {   // the envelope, above and below
        g.set_source_rgba(PK_DIM);
        for (var s = -1; s <= 1; s += 2) {
            for (var x = x0; x <= x1; x += 2) { e = cy - s * a * env((x - x0) / (x1 - x0)); if (x > x0) g.line_to(x, e); else g.move_to(x, e); }
            g.stroke();
        }
    }
    g.set_line_width(1.2);
    var uOf = function (x) { return (x - x0) / (x1 - x0); };
    if (k === "ring" || k === "snare") {
        var cyc = cycles(f) * tr;
        if (k === "snare") {   // the shared noise under the ring, as loud as Noise says
            var nz = pkVal("noise") / 200;
            bars(g, x0, x1, cy, cut, function (u, i) { return a * 0.8 * nz * hash(i + 1) * expEnv(u * W, V.td, dec); }, PK_DIM, cLit);
        }
        plot(g, x0, x1, 1, cut, function (x) { var u = uOf(x); return cy - a * env(u) * Math.sin(2 * Math.PI * cyc * u); }, cDim, cLit);
    } else if (k === "mb") {
        var sq = function (u, j) { return Math.sin(2 * Math.PI * MB_CYC[j] * tr * u) < 0 ? -1 : 1; };
        plot(g, x0, x1, 0.5, cut, function (x) { var u = uOf(x); return cy - a * env(u) * (sq(u, 0) + sq(u, 1) + sq(u, 2)) / 3; }, cDim, cLit);
    } else if (k === "cb") {
        plot(g, x0, x1, 1, cut, function (x) {
            var u = uOf(x); return cy - a * env(u) * 0.5 * (Math.sin(2 * Math.PI * 16 * tr * u) + Math.sin(2 * Math.PI * 11.1 * tr * u));
        }, cDim, cLit);
    } else if (k === "gu") {   // grains of noise, one per pulse; Rate sets the pulse rate, Stroke the note, Decay the grain length
        var rate = (pkVal("stroke") > 0.5 ? 77 : 125) * Math.pow(2, tn / 12), duty = Math.min(1, 0.693 * dec);
        bars(g, x0, x1, cy, cut, function (u, i) {
            var p = u * W / 1000 * rate, n = Math.floor(p), q = (p - n) / duty, sn = q < 1 ? Math.sin(Math.PI * q) : 0;
            return a * (1 + 0.38 * (2 * hash(n) - 1)) / 1.38 * sn * sn * sn * (0.35 + 0.65 * hash(i + 1));
        }, PK_MID, cLit);
    } else {   // noise
        bars(g, x0, x1, cy, cut, function (u, i) { return a * env(u) * (0.2 + 0.8 * hash(i + 1)); }, cDim, cLit);
    }
    if (sweep >= 0 && sweep <= 1) pkFill(g, PK_WHITE, cut, cy - a - 2, 1, 2 * a + 4, 0);
    pkText(g, Math.round(W) + " ms", x1, 138, 9, PK_DIM, PK_FONT, 1);
}

function hz(f) { return f >= 1000 ? (f / 1000).toFixed(1) + "k" : String(Math.round(f)); }

function drawSpec(g, x0, x1) {
    var base = 132, H = 60, k = V.k, dec = Math.pow(2, pkVal("decay")), tn = pkVal(V.main), tone = pkVal("tone");
    var hot = pkAny(2, 4) || (pkTouched[0] && k !== "gu") || (pkTouched[1] && (k === "ring" || k === "snare"));
    var cc = hot ? PK_WHITE : pkMix(PK_MID, pkAccent, flash), cs = hot ? PK_WHITE : pkMix(PK_LIGHT, pkAccent, flash);
    var span = Math.log(FMAX / FMIN), fx = function (f) { return x0 + (x1 - x0) * Math.log(f / FMIN) / span; };
    var curve = function (c, rf) {
        g.set_source_rgba(c); g.set_line_width(1.2);
        for (var x = x0; x <= x1; x += 2) { var y = base - H * rf(FMIN * Math.exp((x - x0) / (x1 - x0) * span)); if (x > x0) g.line_to(x, y); else g.move_to(x, y); }
        g.stroke();
    };
    var spike = function (f, h) { if (f < FMIN || f > FMAX) return; g.set_source_rgba(cs); g.set_line_width(1.5); g.move_to(fx(f), base); g.line_to(fx(f), base - H * Math.max(h, 0.06)); g.stroke(); };
    var f0, label, tr = Math.pow(2, tn / 12);
    pkFill(g, PK_LANE, x0, base, x1 - x0, 1, 0);
    if (k === "ring" || k === "snare") {
        f0 = V.f * tr; if (NAME === "bongo" && pkVal("bongo") > 0.5) f0 = 400 * tr;
        var q = ringQ(f0, V.td, dec);
        if (k === "snare") curve(hot && pkTouched[2] ? PK_WHITE : PK_DIM, function (f) { var h = f / 2000, l = 1 / Math.sqrt(1 + f * f / 8.1e7); return pkVal("noise") / 200 * 0.9 * h * h / (1 + h * h) * l * 1.5; });
        curve(cc, function (f) { return bp(f, f0, q); });
        label = f0;
    } else if (k === "noise") {
        f0 = V.f * Math.pow(2, (NAME === "tamb" ? tone : tn) / 12);
        curve(cc, function (f) { return bp(f, f0, V.q); });
        label = f0;
    } else if (k === "mb") {
        f0 = V.f; curve(PK_DIM, function (f) { return bp(f, f0, V.q); });
        for (var j = 0; j < 3; j++) spike(MB[j] * tr, bp(MB[j] * tr, f0, V.q));
        label = f0;
    } else if (k === "cb") {
        f0 = V.f * Math.pow(2, tone / 12); curve(cc, function (f) { return bp(f, f0, V.q); });
        for (var m = 0; m < 2; m++) spike(CB[m] * tr, bp(CB[m] * tr, f0, V.q));
        label = f0;
    } else {   // guiro: the resonant high-pass the grains go through, then a gentle low-pass
        f0 = V.f * Math.pow(2, tone / 12);
        var gf = function (f) { return hp(f, f0, V.q) / Math.sqrt(1 + f * f / 3.6e7); }, mx = 0;
        for (var i = 0; i < 200; i++) mx = Math.max(mx, gf(FMIN * Math.exp(i / 200 * span)));
        curve(cc, function (f) { return gf(f) / mx; });
        label = f0;
    }
    var lx = Math.max(x0 + 14, Math.min(x1 - 14, fx(label)));
    pkText(g, hz(label), lx, 66, 9, hot ? PK_WHITE : PK_MID, PK_FONT, 0.5);
}

function drawDrive(g, cx) {
    var r = 28, cy = 99, d = pkVal("drive"), hot = pkTouched[5];
    pkFill(g, PK_LANE, cx - r, cy, 2 * r, 1, 0); pkFill(g, PK_LANE, cx, cy - r, 1, 2 * r, 0);
    g.set_line_width(1); g.set_source_rgba(PK_DIM);
    g.move_to(cx - r, cy + r); g.line_to(cx + r, cy - r); g.stroke();   // clean
    g.set_source_rgba(hot ? PK_WHITE : pkMix(PK_MID, pkAccent, flash)); g.set_line_width(1.5);
    for (var i = 0; i <= 56; i++) { var x = i / 28 - 1, y = cy - r * driveCurve(x, d); if (i) g.line_to(cx + x * r, y); else g.move_to(cx + x * r, y); }
    g.stroke();
}

function drawAccent(g, x0) {
    var w = 60, base = 128, H = 56, acc = pkVal("accent"), hot = pkTouched[6];
    pkFill(g, PK_LANE, x0, base, w, 1, 0); pkFill(g, PK_LANE, x0, base - H, 1, H, 0);
    g.set_source_rgba(hot ? PK_WHITE : PK_MID); g.set_line_width(1.5);
    g.move_to(x0, base - H * accGain(acc, 0) / 1.27); g.line_to(x0 + w, base - H * accGain(acc, 1) / 1.27); g.stroke();
    if (lastVel >= 0) {   // the last hit, on the line
        var c = hot ? PK_WHITE : pkMix(PK_LIGHT, pkAccent, flash);
        pkFill(g, c, x0 + w * lastVel - 3, base - H * accGain(acc, lastVel) / 1.27 - 3, 6, 6, 3);
    }
}

function pkDraw(g, bank) {
    if (bank !== "Voice") return;
    drawTime(g, 12, 228);
    drawSpec(g, 258, V.drv ? 586 : 706);
    if (V.drv) drawDrive(g, 660);
    drawAccent(g, 750);
}

if (typeof module !== "undefined" && module.exports) module.exports = {
    expEnv: expEnv, linEnv: linEnv, accGain: accGain, driveCurve: driveCurve, bp: bp, ringQ: ringQ, cycles: cycles, bankFor: bankFor, SPEC: SPEC,
    PK_BANKS: PK_BANKS, PK_LAYOUT: PK_LAYOUT
};
