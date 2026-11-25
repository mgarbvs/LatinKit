// bongo_push.js — Bongo on the Push 3 screen (push_kit.js: Live 13 / Looplet style).
// Drum page: under Drum, the pair joined by their bar (the selected drum lit, the Macho the smaller); under Stroke, the selected head from
// above with where the fingers land; under Tune + Decay, the head's ring (pitch follows Tune and the drum, length follows Decay) swept by a
// playhead on every hit; under Skin, the head's overtones (Skin tilts them up); under Shell, the 125 Hz body thump. Touch, Volume keep Push's dials.
// in: hit <velocity 0..1> (bongo_midi.js). Drum, Stroke, Tune, Decay, Skin, Shell are read from the controls.
inlets = 1;
var PK_BANKS = ["Drum", "Hand"];               // must match build_voice.py PUSH_BANKS
var PK_LAYOUT = { Drum: "CCCCCCDD" };
include("push_kit.js");

var R = [23, 29], H = [44, 52];                // head radius, shell height (px): macho, hembra
var HZ = [365, 325];                           // open tone at Tune 0
// where each stroke lands on the head seen from above (units of the radius, the player at the bottom): [x, y, w, h] dots, w/h in px
var SPOT = [
    [[0.4, 0.45, 9, 9]],                                                     // open: one finger
    [[-0.32, 0.2, 7, 7], [0, 0.2, 7, 7], [0.32, 0.2, 7, 7]],                  // open 3F: three fingers side by side
    [[-0.4, 0.8, 7, 7], [-0.05, 0.9, 7, 7], [0.3, 0.8, 7, 7]],                // slap: three fingers snapping at the edge
    [[-0.1, 0.5, 28, 11]],                                                   // heel: the heel of the hand, flat
    [[0, 0, 5, 5]],                                                          // tip: a fingertip at the centre
    [[0.62, 0.74, 8, 8]],                                                    // rim: finger on the hoop
    [[0.4, 0.45, 9, 9], [0.52, 0.3, 9, 9]]                                   // flam: two taps
];
var flash = 0, sweep = -1;

function hit(v) { flash = 0.4 + 0.6 * v; sweep = 0; }

function pkTick() {
    flash *= 0.85; if (flash < 0.02) flash = 0;
    if (sweep >= 0) { sweep += 0.033; if (sweep > 1.2) sweep = -1; }
}

// Ring-out envelope at t (0..1 of the window): a bongo's T60 is about a third of a second, so it is short; decay% scales the time constant.
function ringEnv(t, decayPct) { return Math.exp(-t * 6 / (decayPct / 100)); }
// Cycles shown across the window: the drum's open tone and Tune, scaled down to a readable count.
function ringCycles(tune, drum) { return 12 * (HZ[drum] / 325) * Math.pow(2, tune / 12); }
// Height 0..1 of overtone k (0 = fundamental): Skin 50 is the recording, more tilts the strength up the series.
function partial(skin, k) { return Math.min(1, 0.85 * Math.pow(0.6, k) * Math.pow(2.2, (skin - 50) / 50 * k)); }

function drawBongo(g, cx, top, r, h, c, lit) {
    var ry = r * 0.3, bot = top + h;
    if (lit > 0) { g.set_source_rgba(pkMix(PK_BLACK, pkAccent, lit)); g.ellipse(cx - r, top - ry, 2 * r, 2 * ry); g.fill(); }
    g.set_source_rgba(c); g.set_line_width(1.5);
    g.ellipse(cx - r, top - ry, 2 * r, 2 * ry); g.stroke();
    g.ellipse(cx - r + 3, top - ry + 1.5, 2 * r - 6, 2 * ry - 3); g.stroke();      // the hoop
    g.move_to(cx - r, top); g.line_to(cx - r * 0.8, bot); g.stroke();              // the shell tapers
    g.move_to(cx + r, top); g.line_to(cx + r * 0.8, bot); g.stroke();
    g.move_to(cx - r * 0.8, bot); g.curve_to(cx - r * 0.8, bot + ry * 1.2, cx + r * 0.8, bot + ry * 1.2, cx + r * 0.8, bot); g.stroke();
}

function drawPair(g, drum) {
    var cx = [31, 87], top = [80, 74], i, k;
    g.set_source_rgba(PK_DIM); g.set_line_width(1.5);   // the bar that joins them
    g.move_to(cx[0] + R[0] * 0.85, top[0] + H[0] * 0.5); g.line_to(cx[1] - R[1] * 0.85, top[1] + H[1] * 0.5); g.stroke();
    g.move_to(cx[0] + R[0] * 0.87, top[0] + H[0] * 0.62); g.line_to(cx[1] - R[1] * 0.87, top[1] + H[1] * 0.62); g.stroke();
    for (k = 0; k < 2; k++) {
        i = k === drum;
        drawBongo(g, cx[k], top[k], R[k], H[k], i ? (pkTouched[0] ? PK_WHITE : PK_LIGHT) : PK_DIM, i ? flash : 0);
    }
}

function drawHead(g, cx, cy, r, stroke) {
    var hot = pkTouched[1], c = hot ? PK_WHITE : flash > 0 ? pkMix(pkAccent, PK_WHITE, flash * 0.6) : pkAccent, s, d, sp;
    g.set_source_rgba(hot ? PK_WHITE : PK_MID); g.set_line_width(1.5);
    g.ellipse(cx - r, cy - r, 2 * r, 2 * r); g.stroke();
    g.set_source_rgba(PK_DIM); g.set_line_width(1);
    g.ellipse(cx - r + 4, cy - r + 4, 2 * r - 8, 2 * r - 8); g.stroke();
    for (s = 0; s < 7; s++) {   // every stroke's contact, the current one lit
        for (d = 0; d < SPOT[s].length; d++) {
            sp = SPOT[s][d];
            if (s !== stroke) { pkFill(g, PK_DIM, cx + sp[0] * (r - 5) - 1, cy + sp[1] * (r - 5) - 1, 2, 2, 1); continue; }
            g.set_source_rgba(c);
            g.ellipse(cx + sp[0] * (r - 5) - sp[2] / 2, cy + sp[1] * (r - 5) - sp[3] / 2, sp[2], sp[3]); g.fill();
        }
    }
}

function drawRing(g, x0, x1, tune, decay, drum) {
    var y = 99, a = 30, n = 160, cyc = ringCycles(tune, drum), wave = pkTouched[2], env = pkTouched[3], i, s, t, t0, t1, on;
    var col = wave ? PK_WHITE : pkAccent;
    pkFill(g, PK_LANE, x0, y, x1 - x0, 1, 0);
    g.set_line_width(1.2);
    for (i = 0; i < n; i++) {   // the wave, lit up to the playhead
        t0 = i / n; t1 = (i + 1) / n;
        on = sweep >= 0 && t1 <= sweep;
        g.set_source_rgba(on || wave ? col : PK_MID);
        g.move_to(x0 + (x1 - x0) * t0, y - a * ringEnv(t0, decay) * Math.sin(2 * Math.PI * cyc * t0));
        g.line_to(x0 + (x1 - x0) * t1, y - a * ringEnv(t1, decay) * Math.sin(2 * Math.PI * cyc * t1));
        g.stroke();
    }
    g.set_source_rgba(env ? PK_WHITE : PK_DIM); g.set_line_width(1);   // the envelope, above and below
    for (s = -1; s <= 1; s += 2) {
        for (i = 0; i <= n; i++) {
            t = i / n;
            if (i) g.line_to(x0 + (x1 - x0) * t, y - s * a * ringEnv(t, decay)); else g.move_to(x0, y - s * a * ringEnv(t, decay));
        }
        g.stroke();
    }
    if (sweep >= 0 && sweep <= 1) pkFill(g, PK_WHITE, x0 + (x1 - x0) * sweep, y - a - 2, 1, 2 * a + 4, 0);
}

function drawPartials(g, x0, skin) {   // five stems: the fundamental and four overtones (line art, like the drums)
    var k, h, x, c = pkTouched[4] ? PK_WHITE : pkAccent;
    pkFill(g, PK_LANE, x0, 130, 96, 1, 0);
    for (k = 0; k < 5; k++) {
        h = 54 * partial(skin, k); x = x0 + 8 + k * 20;
        var col = k === 0 || pkTouched[4] ? c : PK_LIGHT;
        pkFill(g, col, x - 0.75, 130 - h, 1.5, h, 0);
        g.set_source_rgba(col); g.ellipse(x - 3, 130 - h - 3, 6, 6); g.fill();
    }
}

function drawBody(g, x0, shell) {   // the 125 Hz thump: a couple of fast-dying cycles, as big as Shell
    var a = 4 + 26 * shell / 100, n = 80, i, t, c = pkTouched[5] ? PK_WHITE : flash > 0 ? pkMix(PK_MID, pkAccent, flash) : PK_MID;
    pkFill(g, PK_LANE, x0, 99, 96, 1, 0);
    g.set_source_rgba(c); g.set_line_width(1.2);
    for (i = 0; i <= n; i++) {
        t = i / n;
        if (i) g.line_to(x0 + 96 * t, 99 - a * Math.exp(-t * 3) * Math.sin(2 * Math.PI * 2.5 * t)); else g.move_to(x0, 99);
    }
    g.stroke();
}

function pkDraw(g, bank) {
    if (bank !== "Drum") return;
    var drum = Math.max(0, Math.min(1, Math.round(pkVal("drum"))));
    drawPair(g, drum);
    drawHead(g, 180, 99, 30 + 4 * drum, Math.max(0, Math.min(6, Math.round(pkVal("stroke")))));
    drawRing(g, 252, 468, pkVal("tune"), pkVal("decay") || 100, drum);
    drawPartials(g, 492, pkVal("skin"));
    drawBody(g, 612, pkVal("shell"));
}

if (typeof module !== "undefined" && module.exports) module.exports = { ringEnv: ringEnv, ringCycles: ringCycles, partial: partial, SPOT: SPOT, PK_BANKS: PK_BANKS };
