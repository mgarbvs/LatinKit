// caxixi_push.js — Caxixi on the Push 3 screen (push_kit.js: Live 13 / Looplet style).
// Shake page: under Stroke the basket (a palm under it for Hand, motion arcs for FX), jerked left and right by each hit; under
// Length + Rate the FX phrase on a 2 s axis: one tick per burst, rising in, tailing out (a phrase lights burst by burst; dim for
// Open and Hand, which are one stroke); under Beads + Damping + Shake the energy of the seeds after a hit (builds up, decays, with
// a slow tail) and every collision as a tick (a hit sweeps a playhead across it); under Rattle one collision's grain.
// Tone keeps Push's dial. Out page: Level bar, Pan.
// in: hit <note> <velocity 0..1> <stroke 0 Open | 1 Hand | 2 FX burst> (caxixi_midi.js out 1)
inlets = 1;
var PK_BANKS = ["Shake", "Out"];                // must match build_maxpat.py PUSH_BANKS
var PK_LAYOUT = { Shake: "CCCCCCCD", Out: "CCDDDDDD" };
include("push_kit.js");

var SYS = [28.87, 25.38, 28.87];                // energy decay (ms) per Stroke, from caxixi_engine.py (FX = Open)
var SHK = [13.92, 4.356, 13.92];                // build-up (ms)
var GS = [0.05853, 0.09471, 0.05853], SS = [200.2, 142.2, 200.2];   // the slow tail: share and decay (ms)
var DENS = [0.6, 0.7, 0.6];                     // how crowded the collisions look (the engine's rates, squeezed to fit the picture)
var RAMP = [-8.5, -3, -1.5], TAIL = [-1.5, -9]; // an FX phrase's first and last bursts, dB (caxixi_midi.js)
var PHR = 2000;                                 // ms across the phrase picture
var flash = 0, sweep = -1, shift = 0, lastDir = 0, lastT = 0, litN = 0;

function hit(n, v, k) {
    var now = new Date().getTime(), hz = pkVal("rate");
    flash = 0.4 + 0.6 * v; sweep = 0; shift = 1; lastDir = 1 - lastDir;
    litN = (now - lastT > 2000 / Math.max(1, hz) ? 0 : litN) + 1; lastT = now;
}

function pkTick() {
    var now = new Date().getTime();
    flash *= 0.85; if (flash < 0.02) flash = 0;
    shift *= 0.8; if (shift < 0.02) shift = 0;
    if (sweep >= 0) { sweep += 0.033; if (sweep > 1.2) sweep = -1; }
    if (now - lastT > 1500) litN = 0;
}

// level of burst i of n, 0..1
function burstLevel(i, n) {
    var db = (i < RAMP.length ? RAMP[i] : 0) + (n - i <= TAIL.length ? TAIL[TAIL.length - (n - i)] : 0);
    return Math.pow(10, db / 20);
}
function burstCount(len, rate) { return Math.max(1, Math.round(len / 1000 * rate)); }

// Length / Rate: the FX phrase, a tick per burst; Open and Hand are one stroke, so the phrase is only a ghost
function drawPhrase(g, x0, len, rate, stroke) {
    var n = burstCount(len, rate), u = 224 / PHR, y = 100, i, h, c;
    pkFill(g, PK_LANE, x0 + 8, y, PHR * u, 1, 0);
    pkFill(g, pkAny(1, 2) ? PK_WHITE : PK_DIM, x0 + 8, y + 24, Math.min(PHR, len) * u, 1, 0);
    pkText(g, "0", x0 + 8, 139, 9, PK_MID, PK_FONT, 0); pkText(g, "2 s", x0 + 8 + PHR * u, 139, 9, PK_MID, PK_FONT, 1);
    for (i = 0; i < n; i++) {
        h = 30 * burstLevel(i, n);
        c = stroke !== 2 ? PK_DIM : pkAny(1, 2) ? PK_WHITE : i < litN ? pkAccent : PK_LIGHT;
        pkFill(g, c, x0 + 8 + Math.min(PHR, i * 1000 / rate) * u, y - h, 1.6, 2 * h, 0);
    }
}

function basket(g) {
    g.move_to(-8, -28); g.line_to(-12, -4); g.move_to(8, -28); g.line_to(12, -4); g.stroke();
    g.ellipse(-8, -31, 16, 6); g.stroke();
    for (var r = 0; r < 4; r++) { var y = -23 + r * 5.5, w = 9 + r * 0.9; g.move_to(-w, y); g.line_to(w, y); } g.stroke();
    g.move_to(-12, -4); g.curve_to(-11, 6, 11, 6, 12, -4); g.stroke();   // the hard bottom
}
var ART = [
    function (g, dc) { basket(g); dots(g, [[-3, -17], [4, -12], [-5, -9], [2, -22]], 1.4, dc); },   // seeds in the basket
    function (g, dc) {   // the bottom struck on the palm: a flat palm under it and impact ticks
        basket(g); g.move_to(-17, 10); g.line_to(17, 10); g.stroke();
        g.move_to(-15, 5); g.line_to(-19, 3); g.move_to(15, 5); g.line_to(19, 3); g.stroke();
        dots(g, [[-3, -17], [4, -12], [-5, -9]], 1.4, dc);
    },
    function (g, dc) {   // a shaken phrase: motion arcs either side
        basket(g); g.move_to(-17, -20); g.curve_to(-21, -14, -21, -8, -17, -2); g.move_to(17, -20); g.curve_to(21, -14, 21, -8, 17, -2); g.stroke();
        dots(g, [[-3, -16], [3, -11], [-1, -7]], 1.4, dc);
    }
];

function pkDraw(g, bank) {
    if (bank === "Out") {
        drawLevel(g, 0, pkVal("volume"), pkTouched[0]);
        drawPan(g, 120, pkVal("pan"), pkTouched[1]);
        return;
    }
    var type = clampi(pkVal("type"), 0, 2);
    drawInstrument(g, 60, 112, ART[type], pkTouched[0]);
    drawPhrase(g, 120, pkVal("length") || 1000, pkVal("rate") || 9.3, type);
    drawEnergy(g, 368, 712, envShape(SYS[type] * (pkVal("damping") || 100) / 100, SHK[type] * (pkVal("shake") || 100) / 100, GS[type], SS[type], 120), DENS[type], pkVal("beads") || 100);
    drawGrain(g, 728, pkVal("rattle"));
}

function clampi(v, lo, hi) { return Math.max(lo, Math.min(hi, Math.round(v))); }
function hash(i, k) { var x = Math.sin(i * 12.9898 + k * 78.233) * 43758.5453; return x - Math.floor(x); }

// one arrow from xa to xb with its head at xb
function arrow(g, c, xa, xb, y, lw) {
    var d = xb > xa ? -1 : 1;
    g.set_source_rgba(c); g.set_line_width(lw);
    g.move_to(xa, y); g.line_to(xb, y); g.move_to(xb + d * 6, y - 4); g.line_to(xb, y); g.line_to(xb + d * 6, y + 4); g.stroke();
}

// a lane with a dot: Pan
function drawPan(g, x0, pan, hot) {
    var y = 100;
    pkFill(g, PK_DIM, x0 + 10, y, 100, 1, 0); pkFill(g, PK_DIM, x0 + 10, y - 5, 1, 11, 0); pkFill(g, PK_DIM, x0 + 109, y - 5, 1, 11, 0);
    pkFill(g, PK_LANE, x0 + 60, y - 5, 1, 11, 0);
    g.set_source_rgba(hot ? PK_WHITE : PK_LIGHT);
    g.ellipse(x0 + 60 + 50 * Math.max(-1, Math.min(1, pan / 100)) - 5, y - 5, 10, 10); g.fill();
}

// a bar filled to the level, 0 dB marked; a hit lights it
function drawLevel(g, x0, db, hot) {
    var top = 66, h = 70, p = Math.max(0, Math.min(1, (db + 36) / 42)), x = x0 + 53;
    pkFill(g, hot ? PK_WHITE : flash > 0 ? pkMix(PK_MID, pkAccent, flash) : PK_MID, x, top + h * (1 - p), 14, h * p, 0);
    pkStroke(g, hot ? PK_WHITE : PK_DIM, x, top, 14, h, 0, 1);
    pkFill(g, PK_LIGHT, x - 5, top + h * (1 - 36 / 42), 24, 1, 0);
}


var WIN = 160;   // ms of energy shown across the three columns

// Energy of the beads after a hit, peak = 1: the build-up (tb ms) then the decay (ts ms), plus the slow tail (share gs, decay ss ms).
function envShape(ts, tb, gs, ss, n) {
    var e = [], pf = 0, pk = 0, i, t;
    for (i = 0; i <= n; i++) {
        t = WIN * i / n;
        e.push(Math.abs(ts - tb) < 0.01 * ts ? t / ts * Math.exp(-t / ts) : Math.abs(Math.exp(-t / ts) - Math.exp(-t / tb)));
        pf = Math.max(pf, e[i]);
    }
    for (i = 0; i <= n; i++) {
        t = WIN * i / n;
        e[i] = e[i] / pf + (gs || 0) * Math.exp(-t / (ss || 1)) * (1 - Math.exp(-t / tb));
        pk = Math.max(pk, e[i]);
    }
    for (i = 0; i <= n; i++) e[i] /= pk;
    return e;
}

// the collisions (a tick each, as tall as the energy there) under the energy envelope: Beads / Damping / Shake
function drawEnergy(g, x0, x1, e, dens, beads) {
    var y = 99, a = 32, n = e.length - 1, w = x1 - x0, i, k, s, h;
    pkFill(g, PK_LANE, x0, y, w, 1, 0);
    for (i = 0; i < 120; i++) {
        k = Math.min(n, Math.round(n * i / 120));
        if (hash(i, 1) > Math.min(1, dens * beads / 100 * Math.sqrt(e[k]))) continue;
        h = a * e[k] * (0.3 + 0.7 * hash(i, 2));
        pkFill(g, pkTouched[3] ? PK_WHITE : sweep >= 0 && i / 120 <= sweep ? pkAccent : PK_MID, x0 + w * i / 120, y - h, 1.2, 2 * h, 0);
    }
    g.set_source_rgba(pkAny(4, 5) ? PK_WHITE : PK_DIM); g.set_line_width(1);
    for (s = -1; s <= 1; s += 2) {
        for (i = 0; i <= n; i++) { if (i) g.line_to(x0 + w * i / n, y - s * a * e[i]); else g.move_to(x0, y - s * a * e[i]); }
        g.stroke();
    }
    pkText(g, "0", x0, 139, 9, PK_MID, PK_FONT, 0); pkText(g, WIN + " ms", x1, 139, 9, PK_MID, PK_FONT, 1);
    if (sweep >= 0 && sweep <= 1) pkFill(g, PK_WHITE, x0 + w * sweep, y - a - 2, 1, 2 * a + 4, 0);
}

// one collision's grain: Rattle makes it ring longer
function drawGrain(g, x0, rattle) {
    var y = 99, a = 28, n = 150, w = 104, tau = 0.12 * Math.pow(4, (rattle / 100 - 0.5) * 2), i, t, py;
    pkFill(g, PK_LANE, x0, y, w, 1, 0);
    g.set_source_rgba(pkTouched[6] ? PK_WHITE : flash > 0 ? pkMix(PK_LIGHT, pkAccent, flash) : PK_LIGHT); g.set_line_width(1.2);
    for (i = 0; i <= n; i++) {
        t = i / n; py = y - a * Math.exp(-t / tau) * Math.sin(2 * Math.PI * 9 * t);
        if (i) g.line_to(x0 + w * t, py); else g.move_to(x0, py);
    }
    g.stroke();
}

function dots(g, pts, r, c) {
    g.set_source_rgba(c);
    for (var i = 0; i < pts.length; i++) { g.ellipse(pts[i][0] - r, pts[i][1] - r, 2 * r, 2 * r); g.fill(); }
}

// the instrument, tilted and jerked along the last stroke; art(g, dotColour, sign * shift) draws it about the origin, ~34 px tall
function drawInstrument(g, cx, cy, art, hot) {
    var S = 1.4, sg = lastDir ? -1 : 1, c = hot ? PK_WHITE : flash > 0 ? pkMix(PK_LIGHT, pkAccent, flash) : PK_LIGHT;
    g.save(); g.translate(cx + sg * shift * 9, cy); g.rotate(-0.35 + sg * shift * 0.12); g.scale(S, S);
    g.set_source_rgba(c); g.set_line_width(1.3 / S);
    art(g, flash > 0.05 ? pkAccent : hot ? PK_WHITE : PK_MID, sg * shift);
    g.restore();
}


if (typeof module !== "undefined" && module.exports) module.exports = { envShape: envShape, hash: hash, burstLevel: burstLevel, burstCount: burstCount, SYS: SYS, PK_BANKS: PK_BANKS };
