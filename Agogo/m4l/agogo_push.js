// agogo_push.js — Agogo on the Push 3 screen (push_kit.js: Live 13 / Looplet style).
// Bell page: under Bell + Stroke, the double bell (the selected bell lit, flashing on a hit; Mute shows the hand on the
// mouth); under Tune + Decay, the ring-out (a wave at the bell's pitch, its length from Decay, swept by a playhead on
// every hit); under Tone + Touch, the bell's strongest overtones as lines on a log frequency axis, tilted by Tone and
// lowpassed by Touch. Vary and Volume keep Push's dials.
// in: hit <velocity 0..1> (agogo_midi.js). Bell, Stroke, Tune, Decay, Tone, Touch are read from the controls.
inlets = 1;
var PK_BANKS = ["Bell"];                       // must match build_voice.py PUSH_BANKS
var PK_LAYOUT = { Bell: "CCCCCCDD" };
include("push_kit.js");

// the 12 strongest modes of each bell from agogo_tables.json: f1 (Hz), then [ratio, open dB, muted dB]
var BELLS = [
    { f: 1469, p: [[1, -14, -15], [1.902, -19, -22], [2.725, -20, -24], [4.111, -19, -24], [4.765, -18, -23], [4.895, 0, -6], [5.761, -8, -14], [5.883, -21, -27], [6.361, -21, -27], [6.93, -14, -21], [7.412, -17, -24], [7.494, -7, -14]] },
    { f: 1002, p: [[0.989, -4, -4], [1, 0, 0], [1.996, -12, -14], [6.676, -11, -16], [7.67, -17, -23], [8.01, -11, -17], [8.301, -16, -22], [8.501, -16, -22], [8.844, -11, -17], [9.087, -17, -24], [9.582, -13, -19], [10.693, -17, -24]] }
];
var T60 = [1.37, 0.5];                         // the ring-out of the bell's main mode (s) at Decay 100 %
var WIN = 2;                                   // seconds shown in the ring picture
var flash = 0, sweep = -1, vel = 0.8;

function hit(v) { flash = 0.4 + 0.6 * v; sweep = 0; vel = v; }

function pkTick() {
    flash *= 0.85; if (flash < 0.02) flash = 0;
    if (sweep >= 0) { sweep += 0.033 / WIN; if (sweep > 1.1) sweep = -1; }
}

// Ring-out envelope at t seconds: Decay % scales the time to fall 60 dB; a muted bell dies about 16 times faster.
function ringEnv(t, decayPct, bell, mute) { return Math.exp(-6.9078 * t / (T60[bell] * decayPct / 100 / (mute ? 16 : 1))); }
// Cycles shown across the window: the bell's pitch with Tune, scaled down to a readable count.
function ringCycles(tune, bell) { return 14 * (BELLS[bell].f / 1469) * Math.pow(2, tune / 12); }
// Level (dB) of one mode: Tone tilts it by +-6 dB per octave of ratio, Touch lowpasses it (two one-poles, as the engine's contact).
function modeDb(q, mute, tone, touch, f) {
    var fc = 9000 * Math.pow(2, (touch - 50) * 0.03 + (vel - 0.6) * 0.8), fr = 9000 * Math.pow(2, 0.2 * 0.8);
    return q[mute ? 2 : 1] + (tone - 50) * 0.12 * Math.log(q[0]) / Math.LN2 + contact(f, fc) - contact(f, fr);
}
function contact(f, fc) {
    var k = 1 - Math.exp(-2 * Math.PI * Math.min(fc, 18000) / 48000), w = 2 * Math.PI * f / 48000;
    return 20 * Math.log(k * k / (1 - 2 * (1 - k) * Math.cos(w) + (1 - k) * (1 - k))) / Math.LN10;
}

function drawBell(g, cx, top, r, h, c, lit) {
    var ry = r * 0.28, bot = top + h, rt = 3;
    if (lit > 0) { g.set_source_rgba(pkMix(PK_BLACK, pkAccent, lit)); g.ellipse(cx - r, bot - ry, 2 * r, 2 * ry); g.fill(); }
    g.set_source_rgba(c); g.set_line_width(1.5);
    g.ellipse(cx - rt, top - 1.5, 2 * rt, 3); g.stroke();
    g.move_to(cx - rt, top); g.line_to(cx - r, bot); g.stroke();
    g.move_to(cx + rt, top); g.line_to(cx + r, bot); g.stroke();
    g.ellipse(cx - r, bot - ry, 2 * r, 2 * ry); g.stroke();
}

function drawBells(g, bell, mute) {
    var cx = [96, 186], top = [100, 86], r = [18, 24], h = [34, 46], hot = pkAny(0, 1), k;
    g.set_source_rgba(PK_DIM); g.set_line_width(1.5);   // the U-shaped handle joining the two bells
    g.move_to(cx[0], top[0] - 2); g.curve_to(cx[0], 70, cx[1], 64, cx[1], top[1] - 2); g.stroke();
    for (k = 0; k < 2; k++) {
        var on = k === bell;
        drawBell(g, cx[k], top[k], r[k], h[k], on ? (pkTouched[0] ? PK_WHITE : flash > 0 ? pkMix(pkAccent, PK_WHITE, flash * 0.5) : PK_LIGHT) : PK_DIM, on ? flash : 0);
    }
    var sc = hot && pkTouched[1] ? PK_WHITE : PK_LIGHT, tx = cx[bell] + r[bell] * 0.8, ty = top[bell] + h[bell] * 0.6, lift = flash * 14;
    g.set_source_rgba(sc); g.set_line_width(1.5);          // the stick lands on the cone's right side
    g.move_to(tx + 14 + lift * 0.5, ty - 22 - lift); g.line_to(tx, ty); g.stroke();
    if (mute) {                                            // the other hand holds the mouth
        var bot = top[bell] + h[bell], x = cx[bell] - r[bell];
        g.set_source_rgba(pkTouched[1] ? PK_WHITE : pkAccent);
        g.move_to(x - 12, bot - 6); g.line_to(x + r[bell] * 0.8, bot + 5); g.stroke();
        g.move_to(x - 12, bot - 6); g.line_to(x - 12, bot - 20); g.stroke();
    }
}

function drawRing(g, x0, x1, tune, decay, bell, mute) {
    var y = 99, a = 30, n = 160, cyc = ringCycles(tune, bell), wave = pkTouched[2], env = pkTouched[3], i;
    pkFill(g, PK_LANE, x0, y, x1 - x0, 1, 0);
    g.set_line_width(1.2);
    for (i = 0; i < n; i++) {   // the wave, lit up to the playhead
        var t0 = i / n, t1 = (i + 1) / n, on = sweep >= 0 && t1 <= sweep;
        g.set_source_rgba(on || wave ? (wave ? PK_WHITE : pkAccent) : PK_MID);
        g.move_to(x0 + (x1 - x0) * t0, y - a * ringEnv(t0 * WIN, decay, bell, mute) * Math.sin(2 * Math.PI * cyc * t0));
        g.line_to(x0 + (x1 - x0) * t1, y - a * ringEnv(t1 * WIN, decay, bell, mute) * Math.sin(2 * Math.PI * cyc * t1));
        g.stroke();
    }
    g.set_source_rgba(env ? PK_WHITE : PK_DIM); g.set_line_width(1);   // the envelope, above and below
    for (var s = -1; s <= 1; s += 2) {
        for (i = 0; i <= n; i++) {
            var py = y - s * a * ringEnv(i / n * WIN, decay, bell, mute);
            if (i) g.line_to(x0 + (x1 - x0) * i / n, py); else g.move_to(x0, py);
        }
        g.stroke();
    }
    if (sweep >= 0 && sweep <= 1) pkFill(g, PK_WHITE, x0 + (x1 - x0) * sweep, y - a - 2, 1, 2 * a + 4, 0);
}

function drawSpectrum(g, x0, x1, bell, mute, tone, touch, tune) {
    var base = 136, hmax = 72, lo = Math.log(700), hi = Math.log(12000), b = BELLS[bell], hot = pkAny(4, 5), i;
    pkFill(g, PK_LANE, x0, base, x1 - x0, 1, 0);
    var ticks = [1000, 2000, 4000, 8000];
    for (i = 0; i < 4; i++) {
        var tx = x0 + (x1 - x0) * (Math.log(ticks[i]) - lo) / (hi - lo);
        pkFill(g, PK_DIM, tx, base, 1, 3, 0);
        pkText(g, ticks[i] / 1000 + "k", tx, base + 11, 9, PK_DIM, PK_FONT, 0.5);
    }
    for (i = 0; i < b.p.length; i++) {
        var f = b.f * b.p[i][0] * Math.pow(2, tune / 12), db = modeDb(b.p[i], mute, tone, touch, f);
        var x = x0 + (x1 - x0) * (Math.log(f) - lo) / (hi - lo), h = Math.max(0, Math.min(1, (db + 40) / 40)) * hmax;
        if (x < x0 || x > x1 || h < 1) continue;
        pkFill(g, hot ? PK_WHITE : pkMix(PK_MID, pkAccent, 0.5 + 0.5 * flash), x - 1, base - h, 2, h, 0);
    }
}

function pkDraw(g, bank) {
    var bell = Math.max(0, Math.min(1, Math.round(pkVal("bell")))), mute = Math.round(pkVal("stroke")) === 1;
    drawBells(g, bell, mute);
    drawRing(g, 252, 468, pkVal("tune"), pkVal("decay") || 100, bell, mute);
    drawSpectrum(g, 496, 704, bell, mute, pkVal("tone"), pkVal("touch"), pkVal("tune"));
}

if (typeof module !== "undefined" && module.exports) module.exports = { ringEnv: ringEnv, ringCycles: ringCycles, modeDb: modeDb, BELLS: BELLS, PK_BANKS: PK_BANKS };
