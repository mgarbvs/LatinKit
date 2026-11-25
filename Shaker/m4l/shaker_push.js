// shaker_push.js — Shaker on the Push 3 screen (push_kit.js: Live 13 / Looplet style).
// Shake page: under Type the shaker, jerked along each stroke and lit by it; under Direction + Back a forward and a back arrow (the
// back one as long as it is loud); under Beads + Damping + Shake the energy of the beads after a hit (it builds up, then decays)
// with every collision as a tick (a hit sweeps a playhead across it); under Rattle one collision's grain. Tone keeps Push's dial.
// Out page: Roll chevrons (one second of strokes), Level bar, Pan.
// in: hit <note> <velocity 0..1> <dir 0 forward | 1 back> (shaker_midi.js out 1)
inlets = 1;
var PK_BANKS = ["Shake", "Out"];                // must match build_maxpat.py PUSH_BANKS
var PK_LAYOUT = { Shake: "CCCCCCCD", Out: "CCCDDDDD" };
include("push_kit.js");

var SYS = [19.87, 12.84, 30, 12.51, 13.55];     // energy decay (ms) per Type, from shaker_engine.py
var SHK = [4.866, 6.902, 45, 13.3, 2.285];      // build-up (ms)
var DENS = [0.6, 1, 0.6, 1, 0.3];              // how crowded the collisions look (the engine's rates, squeezed to fit the picture)
var flash = 0, sweep = -1, shift = 0, lastDir = 0, lastT = 0, litN = 0;

function hit(n, v, d) {
    var now = new Date().getTime(), hz = pkVal("roll");
    flash = 0.4 + 0.6 * v; sweep = 0; shift = 1; lastDir = d;
    litN = (now - lastT > (hz > 0 ? 2000 / hz : 400) ? 0 : litN) + 1; lastT = now;
}

function pkTick() {
    var now = new Date().getTime();
    flash *= 0.85; if (flash < 0.02) flash = 0;
    shift *= 0.8; if (shift < 0.02) shift = 0;
    if (sweep >= 0) { sweep += 0.033; if (sweep > 1.2) sweep = -1; }
    if (now - lastT > 1500) litN = 0;
}

var ART = [
    function (g, dc) {   // maraca
        g.ellipse(-12, -26, 24, 24); g.stroke(); g.move_to(0, -2); g.line_to(0, 12); g.stroke(); g.rectangle_rounded(-3, 10, 6, 14, 3, 3); g.stroke();
        dots(g, [[-4, -20], [3, -14], [-2, -9], [5, -22]], 1.4, dc);
    },
    function (g, dc) {   // cabasa: a drum wrapped in a bead chain
        g.rectangle_rounded(-16, -12, 32, 22, 6, 6); g.stroke(); g.rectangle_rounded(16, -5, 14, 8, 3, 3); g.stroke();
        for (var r = 0; r < 3; r++) { var p = []; for (var c = 0; c < 7; c++) p.push([-12 + c * 4.2, -7 + r * 7]); dots(g, p, 1.1, dc); }
    },
    function (g, dc) {   // shekere: a gourd in a net of beads
        g.ellipse(-14, -22, 28, 30); g.stroke(); g.rectangle_rounded(-4, -32, 8, 11, 3, 3); g.stroke();
        var p = []; for (var r = 0; r < 3; r++) for (var c = 0; c < 4; c++) p.push([-9 + c * 6 + (r % 2) * 3, -15 + r * 7]);
        dots(g, p, 1.3, dc);
    },
    function (g, dc) {   // ganza: a tube of pellets
        g.rectangle_rounded(-22, -9, 44, 18, 9, 9); g.stroke(); g.move_to(-8, -9); g.line_to(-8, 9); g.move_to(8, -9); g.line_to(8, 9); g.stroke();
        dots(g, [[-15, 0], [0, -3], [0, 3], [15, 0]], 1.1, dc);
    },
    function (g, dc) {   // egg
        g.ellipse(-12, -17, 24, 32); g.stroke(); g.move_to(-9, -2); g.line_to(9, -2); g.stroke();
        dots(g, [[-3, 6], [3, 9], [0, 4]], 1.3, dc);
    }
];

function pkDraw(g, bank) {
    var mode = clampi(pkVal("direction"), 0, 3);
    if (bank === "Out") {
        drawRoll(g, 10, pkVal("roll"), litN, mode > 1 ? mode - 2 : -1, pkTouched[0]);
        drawLevel(g, 120, pkVal("volume"), pkTouched[1]);
        drawPan(g, 240, pkVal("pan"), pkTouched[2]);
        return;
    }
    var type = clampi(pkVal("type"), 0, 4);
    drawInstrument(g, 60, 102, ART[type], pkTouched[0]);
    drawDirs(g, 120, mode !== 3, mode !== 2, pkVal("back") / 100, false);
    drawEnergy(g, 368, 712, envShape(SYS[type] * (pkVal("damping") || 100) / 100, SHK[type] * (pkVal("shake") || 100) / 100, 0, 1, 120), DENS[type], pkVal("beads") || 100);
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

// one second of strokes: a chevron per stroke (right = forward / up, left = back / down), flipping as the strokes do; fixed: 0 / 1 = always that way, -1 = flip
function drawRoll(g, x0, hz, lit, fixed, hot) {
    var y = 100, w = 100, n = Math.max(1, Math.floor(hz)), i, x, d;
    pkFill(g, PK_LANE, x0, y, w, 1, 0);
    for (i = 0; i < n; i++) {
        x = x0 + 4 + (w - 8) * i / Math.max(1, hz); d = fixed >= 0 ? (fixed ? -1 : 1) : (i % 2 ? -1 : 1);
        g.set_source_rgba(i < lit ? pkAccent : hot ? PK_WHITE : hz < 0.5 ? PK_DIM : PK_LIGHT); g.set_line_width(1.2);
        g.move_to(x - 2 * d, y - 5); g.line_to(x + 2 * d, y); g.line_to(x - 2 * d, y + 5); g.stroke();
    }
}

var WIN = 120;   // ms of energy shown across the three columns

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

// Direction / Back: a forward arrow and a back arrow, the back one as long as it is loud against the forward one; off = this stroke never plays
function drawDirs(g, x0, fwdOn, backOn, back, accentFwd) {
    var fc = pkTouched[1] ? PK_WHITE : fwdOn ? PK_LIGHT : PK_DIM, bc = pkAny(1, 2) ? PK_WHITE : backOn ? PK_LIGHT : PK_DIM;
    if (flash > 0) { if (lastDir) bc = pkMix(bc, pkAccent, flash); else fc = pkMix(fc, pkAccent, flash); }
    arrow(g, fc, x0 + 14, x0 + 84, 88, accentFwd ? 3.5 : 1.5);
    arrow(g, bc, x0 + 226, x0 + 226 - 70 * Math.max(0.03, back), 118, 1.5);
}

if (typeof module !== "undefined" && module.exports) module.exports = { envShape: envShape, hash: hash, SYS: SYS, SHK: SHK, PK_BANKS: PK_BANKS };
