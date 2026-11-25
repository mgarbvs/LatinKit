// guiro_push.js — Guiro on the Push 3 screen (push_kit.js: Live 13 / Looplet style).
// Scrape page: under Type + Stroke the instrument with its ridges and the stroke's path (arrow); a hit lights the ridges the
// stick crosses. Under Length + Speed the stroke on a time axis (Speed shortens it); Vary: ticks off the beat; Tone: the instrument
// bigger or smaller. Ridge and Level keep Push's dials (the ridge count shows in the instrument). Out page: Roll chevrons, Pan.
// in: hit <note> <velocity 0..1> <stroke 0..3> (guiro_midi.js out 1)
inlets = 1;
var PK_BANKS = ["Scrape", "Out"];               // must match build_maxpat.py PUSH_BANKS
var PK_LAYOUT = { Scrape: "CCCCDCCD", Out: "CCDDDDDD" };
include("push_kit.js");

var BASE = [80, 115, 0, 0];             // ms of Up, Down, (Long = the Length control), Top
var SLOW = [3, 3, 1, 1];                // the eye sees Up and Down this much slower than they sound
var flash = 0, lastK = 0, k0 = 0, t0 = 0, pos = 0, playing = false, lit = [], lastT = 0, rollN = 0;
for (var i = 0; i < 40; i++) lit.push(0);

function hit(n, v, k) {
    var now = new Date().getTime(), hz = pkVal("roll");
    flash = 0.4 + 0.6 * v; lastK = k; k0 = k; t0 = now;
    rollN = (now - lastT > (hz > 0 ? 2000 / hz : 400) ? 0 : rollN) + 1; lastT = now;
    for (var j = 0; j < 40; j++) lit[j] = 0;
}

function strokeMs(k, len, speed) { return Math.max(1, (k === 2 ? len : BASE[k]) * 100 / speed); }
function ridgeCount(type, ridge) { return clampi((type ? 18 : 12) * ridge / 100, 3, 40); }

function pkTick() {
    var now = new Date().getTime(), nr = ridgeCount(clampi(pkVal("type"), 0, 1), pkVal("ridge") || 100);
    var dur = strokeMs(k0, pkVal("length") || 450, pkVal("speed") || 100) * SLOW[k0];
    var u = Math.min(1, (now - t0) / dur);
    pos = k0 === 1 ? 1 - u : k0 === 3 ? 0.5 : u;
    playing = t0 > 0 && u < 1;
    if (playing) lit[Math.min(nr - 1, Math.floor(pos * nr))] = 1;
    for (var j = 0; j < 40; j++) lit[j] *= 0.85;
    flash *= 0.85; if (flash < 0.02) flash = 0;
    if (now - lastT > 1500) rollN = 0;
}

function body(g, x, y, w, h, type, c) {
    g.set_source_rgba(c); g.set_line_width(1.5);
    if (type) {   // reco-reco: a metal box with three springs, on a grip
        g.rectangle_rounded(x, y, w, h, 4, 4); g.stroke();
        g.set_line_width(1);
        for (var s = 1; s <= 3; s++) { g.move_to(x + 4, y + h * s / 4); g.line_to(x + w - 4, y + h * s / 4); }
        g.stroke();
    } else { g.rectangle_rounded(x, y, w, h, h / 2, h / 2); g.stroke(); }   // a gourd
}

function drawInstrument(g, type, nr, shown, hot, stickHot) {
    var yt = type ? 88 : 92, h = type ? 38 : 32, rh = type ? 24 : 10, c = hot ? PK_WHITE : PK_LIGHT, i, x;
    body(g, 14, yt, 212, h, type, flash > 0 ? pkMix(c, pkAccent, flash) : c);
    for (i = 0; i < nr; i++) {
        x = 24 + 192 * (i + 0.5) / nr;
        pkFill(g, lit[i] > 0.05 ? pkMix(PK_MID, pkAccent, lit[i]) : hot ? PK_WHITE : PK_MID, x, yt + 2, 1.2, rh + 5 * lit[i], 0);
    }
    var on = stickHot ? PK_WHITE : PK_LIGHT, sx = 24 + 192 * (playing ? pos : shown === 1 ? 1 : shown === 3 ? 0.5 : 0), lift = shown === 3 && t0 ? 6 * Math.max(0, 1 - (new Date().getTime() - t0) / 120) : 0;
    g.set_source_rgba(on); g.set_line_width(2);
    g.move_to(sx, yt - 2 - lift); g.line_to(sx + 14, yt - 26 - lift); g.stroke();
    if (shown === 3) { g.set_source_rgba(PK_DIM); g.set_line_width(1); g.ellipse(sx - 6, yt - 5, 12, 6); g.stroke(); }
    else arrow(g, stickHot ? PK_WHITE : PK_MID, shown === 1 ? 216 : 24, shown === 1 ? 24 : 216, 134, shown === 2 ? 3 : 1.2);
}

function drawTime(g, x0, ms, hot) {
    var u = 224 / 1500, w = Math.max(6, ms * u), y = 100, i;
    for (i = 0; i <= 3; i++) pkFill(g, PK_DIM, x0 + 8 + 500 * u * i, y + 14, 1, 5, 0);
    pkFill(g, PK_DIM, x0 + 8, y + 18, 1500 * u, 1, 0);
    pkText(g, "0", x0 + 8, 137, 9, PK_MID, PK_FONT, 0); pkText(g, "1.5 s", x0 + 8 + 1500 * u, 137, 9, PK_MID, PK_FONT, 1);
    for (i = 0; i < w; i += 3) pkFill(g, hot ? PK_WHITE : PK_LIGHT, x0 + 8 + i, y - 10, 1.2, 20, 0);
    if (playing) {   // the stick's progress along the stroke
        var u2 = Math.min(1, (new Date().getTime() - t0) / (ms * SLOW[k0]));
        if (u2 < 1 && k0 !== 3) pkFill(g, pkAccent, x0 + 8 + w * u2, y - 14, 1.5, 28, 0);
    }
}

function drawVary(g, x0, vary, hot) {
    var i, x, a = 6 * vary / 100;
    for (i = 0; i < 9; i++) {
        x = x0 + 16 + 11 * i;
        pkFill(g, PK_DIM, x, 118, 1, 6, 0);
        pkFill(g, hot ? PK_WHITE : flash > 0 ? pkMix(PK_LIGHT, pkAccent, flash) : PK_LIGHT, x + (hash(i, 1) - 0.5) * 2 * a, 90 + 12 * vary / 100 * hash(i, 2), 1.4, 26 - 12 * vary / 100 * hash(i, 2), 0);
    }
}

function drawTone(g, x0, tone, type, hot) {
    var s = Math.pow(2, -tone / 24), w = 76, h = type ? 34 : 26, cx = x0 + 60;
    g.set_source_rgba(PK_DIM); g.set_line_width(1); g.rectangle_rounded(cx - w / 2, 100 - h / 2, w, h, type ? 3 : h / 2, type ? 3 : h / 2); g.stroke();
    body(g, cx - w * s / 2, 100 - h * s / 2, w * s, h * s, type, hot ? PK_WHITE : PK_LIGHT);
}

function pkDraw(g, bank) {
    var type = clampi(pkVal("type"), 0, 1);
    if (bank === "Out") {
        drawRoll(g, 10, pkVal("roll"), rollN, -1, pkTouched[0]);
        drawPan(g, 120, pkVal("pan"), pkTouched[1]);
        return;
    }
    var sm = clampi(pkVal("stroke"), 0, 5), shown = sm >= 1 && sm <= 4 ? sm - 1 : lastK;
    drawInstrument(g, type, ridgeCount(type, pkVal("ridge") || 100), shown, pkTouched[0], pkTouched[1]);
    drawTime(g, 240, strokeMs(shown, pkVal("length") || 450, pkVal("speed") || 100), pkAny(2, 3));
    drawVary(g, 600, pkVal("vary"), pkTouched[5]);
    drawTone(g, 720, pkVal("tone"), type, pkTouched[6]);
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

if (typeof module !== "undefined" && module.exports) module.exports = { strokeMs: strokeMs, ridgeCount: ridgeCount, PK_BANKS: PK_BANKS };
