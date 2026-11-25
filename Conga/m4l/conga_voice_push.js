// conga_voice_push.js — Conga Voice on the Push 3 screen (push_kit.js: Live 13 / Looplet style).
// Drum page: under Drum, the conga in line art (sized by Drum); under Stroke, the head from above with
// where this stroke lands; under Tune + Decay, the ring: a wave whose pitch follows Tune and whose length
// follows Decay, swept by a playhead on every hit. Skin, Slap, Shell, Volume keep Push's dials.
// in: hit <velocity 0..1> (conga_voice_midi.js). Drum, Stroke, Tune, Decay are read from the controls.
inlets = 1;
var PK_BANKS = ["Drum", "Hand"];               // must match build_voice.py PUSH_BANKS
var PK_LAYOUT = { Drum: "CCCCDDDD" };
include("push_kit.js");

var STROKES = ["Open", "Slap", "Mute", "Bass", "Heel", "Toe"];
var SIZE = [[26, 50], [30, 55], [34, 60]];     // quinto, conga, tumba: head radius, barrel height (px)
var HZ = [366, 266, 219];                      // open tone at Tune 0
// where each stroke lands, from the rim (1) to the centre (0), toward the player; palm = flat hand
var SPOT = [[0.86, 0], [0.8, 0], [0.62, 1], [0, 1], [0.32, 1], [0.5, 0]];
var flash = 0, sweep = -1;

function hit(v) { flash = 0.4 + 0.6 * v; sweep = 0; }

function pkTick() {
    flash *= 0.85; if (flash < 0.02) flash = 0;
    if (sweep >= 0) { sweep += 0.033; if (sweep > 1.2) sweep = -1; }
}

// Ring-out envelope at t (0..1 of the window): decay% scales the time constant; bigger drums ring longer.
function ringEnv(t, decayPct, drum) { return Math.exp(-t * 4.5 / (decayPct / 100) / (1 + 0.15 * drum)); }
// Cycles shown across the window: the drum's open tone and Tune, scaled down to a readable count.
function ringCycles(tune, drum) { return 9 * (HZ[drum] / 266) * Math.pow(2, tune / 12); }

function drawConga(g, cx, top, r, h, c) {
    var ry = r * 0.28, bot = top + h, foot = r * 0.6;
    if (flash > 0) { g.set_source_rgba(pkMix(PK_BLACK, pkAccent, flash)); g.ellipse(cx - r, top - ry, 2 * r, 2 * ry); g.fill(); }
    g.set_source_rgba(c); g.set_line_width(1.5);
    g.ellipse(cx - r, top - ry, 2 * r, 2 * ry); g.stroke();
    g.ellipse(cx - r + 4, top - ry + 2, 2 * r - 8, 2 * ry - 4); g.stroke();   // the hoop
    for (var k = -1; k <= 1; k += 2) {
        g.move_to(cx + k * r, top);
        g.curve_to(cx + k * r * 1.12, top + h * 0.35, cx + k * r * 0.95, top + h * 0.75, cx + k * foot, bot); g.stroke();
        g.move_to(cx + k * r * 0.55, top + ry * 0.85); g.line_to(cx + k * r * 0.62, top + h * 0.45); g.stroke();
    }
    g.move_to(cx - foot, bot); g.curve_to(cx - foot, bot + ry * 1.2, cx + foot, bot + ry * 1.2, cx + foot, bot); g.stroke();
}

function drawHead(g, cx, cy, r, stroke) {
    var hot = pkTouched[1];
    g.set_source_rgba(hot ? PK_WHITE : PK_MID); g.set_line_width(1.5);
    g.ellipse(cx - r, cy - r, 2 * r, 2 * r); g.stroke();
    g.set_source_rgba(PK_DIM); g.set_line_width(1);
    g.ellipse(cx - r + 4, cy - r + 4, 2 * r - 8, 2 * r - 8); g.stroke();
    for (var s = 0; s < 6; s++) {   // every stroke's spot, the current one lit
        var sp = SPOT[s], x = cx, y = cy + sp[0] * (r - 6), on = s === stroke;
        if (!on) { pkFill(g, PK_DIM, x - 2, y - 2, 4, 4, 2); continue; }
        var c = hot ? PK_WHITE : flash > 0 ? pkMix(pkAccent, PK_WHITE, flash * 0.6) : pkAccent;
        g.set_source_rgba(c);
        if (sp[1]) { g.ellipse(x - 13, y - 7, 26, 14); g.fill(); }   // palm
        else { g.ellipse(x - 5, y - 5, 10, 10); g.fill(); }          // fingers
    }
}

function drawRing(g, x0, x1, tune, decay, drum) {
    var y = 99, a = 30, n = 160, cyc = ringCycles(tune, drum), wave = pkTouched[2], env = pkTouched[3];
    var col = wave ? PK_WHITE : pkAccent;
    pkFill(g, PK_LANE, x0, y, x1 - x0, 1, 0);
    g.set_line_width(1.2);
    for (var i = 0; i < n; i++) {   // the wave, lit up to the playhead
        var t0 = i / n, t1 = (i + 1) / n;
        var on = sweep >= 0 && t1 <= sweep;
        g.set_source_rgba(on || wave ? col : PK_MID);
        g.move_to(x0 + (x1 - x0) * t0, y - a * ringEnv(t0, decay, drum) * Math.sin(2 * Math.PI * cyc * t0));
        g.line_to(x0 + (x1 - x0) * t1, y - a * ringEnv(t1, decay, drum) * Math.sin(2 * Math.PI * cyc * t1));
        g.stroke();
    }
    g.set_source_rgba(env ? PK_WHITE : PK_DIM); g.set_line_width(1);   // the envelope, above and below
    for (var s = -1; s <= 1; s += 2) {
        for (i = 0; i <= n; i++) {
            var t = i / n, py = y - s * a * ringEnv(t, decay, drum);
            if (i) g.line_to(x0 + (x1 - x0) * t, py); else g.move_to(x0, py);
        }
        g.stroke();
    }
    if (sweep >= 0 && sweep <= 1) pkFill(g, PK_WHITE, x0 + (x1 - x0) * sweep, y - a - 2, 1, 2 * a + 4, 0);
}

function pkDraw(g, bank) {
    if (bank !== "Drum") return;
    var drum = Math.max(0, Math.min(2, Math.round(pkVal("drum")))), s = SIZE[drum];
    drawConga(g, 60, 68 + (60 - s[1]) / 2, s[0], s[1], pkTouched[0] ? PK_WHITE : PK_LIGHT);
    drawHead(g, 180, 99, 34, Math.max(0, Math.min(5, Math.round(pkVal("stroke")))));
    drawRing(g, 252, 468, pkVal("tune"), pkVal("decay") || 100, drum);
}

if (typeof module !== "undefined" && module.exports) module.exports = { ringEnv: ringEnv, ringCycles: ringCycles, SPOT: SPOT, PK_BANKS: PK_BANKS };
