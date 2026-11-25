// surdo_push.js — Surdo on the Push 3 screen (push_kit.js: Live 13 / Looplet style). One page, "Drum".
// Under Stroke: the surdo in line art with the mallet or hand where this stroke lands; it lights on every hit.
// Under Tune + Decay: the ring, a wave whose pitch follows Tune and whose length follows Decay and the stroke, swept by a playhead on every hit.
// Under Skin: the head's overtones, tilted by Skin. Under Touch: the contact force pulse (soft = wide and low, hard = narrow and tall).
// Vary, Press, Volume keep Push's dials.
// in: hit <velocity 0..1> (surdo_midi.js / surdo_musical_midi.js). Stroke, Tune, Decay, Skin, Touch are read from the controls.
inlets = 1;
var PK_BANKS = ["Drum"];                       // must match build_voice.py PUSH_BANKS
var PK_LAYOUT = { Drum: "CCCCCDDD" };
include("push_kit.js");

var RATIO = [1.0, 1.45, 1.85, 2.4, 3.0, 4.4, 5.86];   // some head modes, ratio to the open tone (surdo_engine.py HEAD)
var RING = [1, 0.25, 0.5, 0.4];                       // how long each stroke rings against Open: Mute damps, Rim and Finger are short
var flash = 0, sweep = -1;

function hit(v) { flash = 0.4 + 0.6 * v; sweep = 0; }

function pkTick() {
    flash *= 0.85; if (flash < 0.02) flash = 0;
    if (sweep >= 0) { sweep += 0.033; if (sweep > 1.2) sweep = -1; }
}

// Ring-out envelope at t (0..1 of the window): decay% scales the time constant, ring = the stroke's length.
function ringEnv(t, decayPct, ring) { return Math.exp(-t * 4.5 / (decayPct / 100 * ring)); }
// Cycles shown across the window: the surdo's 86 Hz scaled down to a readable count, Tune in semitones.
function ringCycles(tune) { return 7 * Math.pow(2, tune / 12); }
// Height 0..1 of the overtone at ratio r: Skin tilts +-6 dB per octave of ratio around the open tone.
function skinAmp(r, skin) { return Math.min(1, 0.55 * Math.pow(r, (skin - 50) * 0.02 - 0.5)); }
// Contact pulse (0..1) at u (0..1 across its width): sin^2 bump.
function pulse(u) { var s = Math.sin(Math.PI * u); return s * s; }

function drawDrum(g, cx, top, r, h, c, stroke) {
    var ry = r * 0.27, bot = top + h, k;
    if (flash > 0) { g.set_source_rgba(pkMix(PK_BLACK, pkAccent, flash)); g.ellipse(cx - r, top - ry, 2 * r, 2 * ry); g.fill(); }
    g.set_source_rgba(c); g.set_line_width(1.5);
    g.ellipse(cx - r, top - ry, 2 * r, 2 * ry); g.stroke();
    g.ellipse(cx - r + 3, top - ry + 1.5, 2 * r - 6, 2 * ry - 3); g.stroke();   // the hoop
    g.move_to(cx - r, top); g.line_to(cx - r, bot); g.stroke();
    g.move_to(cx + r, top); g.line_to(cx + r, bot); g.stroke();
    g.move_to(cx - r, bot); g.curve_to(cx - r, bot + ry * 1.3, cx + r, bot + ry * 1.3, cx + r, bot); g.stroke();
    g.set_source_rgba(PK_DIM); g.set_line_width(1);
    for (k = -2; k <= 2; k++) { g.move_to(cx + k * r * 0.4, top + ry); g.line_to(cx + k * r * 0.4, bot - 6); g.stroke(); }   // tension rods
    g.move_to(cx - r, bot - 6); g.curve_to(cx - r, bot - 6 + ry * 1.3, cx + r, bot - 6 + ry * 1.3, cx + r, bot - 6); g.stroke();   // the lower hoop
    var lift = flash > 0 ? 9 * flash : 0, tx, ty = top;
    g.set_source_rgba(pkTouched[0] ? PK_WHITE : flash > 0 ? pkMix(PK_LIGHT, pkAccent, flash) : PK_LIGHT); g.set_line_width(2);
    if (stroke === 0) {            // open: the mallet in the middle of the head
        g.move_to(cx + 4, ty - 4 - lift); g.line_to(cx + 16, ty - 18 - lift); g.stroke();
        g.ellipse(cx - 3, ty - 5 - lift * 0.5, 6, 6); g.fill();
    } else if (stroke === 1) {     // mute: the flat hand laid on the head
        g.move_to(cx - 12, ty - 2 - lift * 0.4); g.line_to(cx + 10, ty - 4 - lift * 0.4); g.line_to(cx + 20, ty - 14 - lift); g.stroke();
    } else if (stroke === 2) {     // rim: the stick across the hoop
        tx = cx + r * 0.92;
        g.move_to(tx - 12, ty - 16 - lift); g.line_to(tx + 1, ty - 1 - lift * 0.3); g.stroke();
    } else {                       // finger: a fingertip on the head near the edge
        tx = cx + r * 0.45;
        g.move_to(tx, ty - lift * 0.3); g.line_to(tx + 8, ty - 16 - lift); g.stroke();
    }
}

function drawRing(g, x0, x1, tune, decay, ring) {
    var y = 99, a = 30, n = 120, cyc = ringCycles(tune), wave = pkTouched[1], env = pkTouched[2], i;
    pkFill(g, PK_LANE, x0, y, x1 - x0, 1, 0);
    g.set_line_width(1.2);
    for (i = 0; i < n; i++) {   // the wave, lit up to the playhead
        var t0 = i / n, t1 = (i + 1) / n;
        g.set_source_rgba(wave ? PK_WHITE : sweep >= 0 && t1 <= sweep ? pkAccent : PK_MID);
        g.move_to(x0 + (x1 - x0) * t0, y - a * ringEnv(t0, decay, ring) * Math.sin(2 * Math.PI * cyc * t0));
        g.line_to(x0 + (x1 - x0) * t1, y - a * ringEnv(t1, decay, ring) * Math.sin(2 * Math.PI * cyc * t1));
        g.stroke();
    }
    g.set_source_rgba(env ? PK_WHITE : PK_DIM); g.set_line_width(1);
    for (var s = -1; s <= 1; s += 2) {
        for (i = 0; i <= n; i++) {
            var t = i / n, py = y - s * a * ringEnv(t, decay, ring);
            if (i) g.line_to(x0 + (x1 - x0) * t, py); else g.move_to(x0, py);
        }
        g.stroke();
    }
    if (sweep >= 0 && sweep <= 1) pkFill(g, PK_WHITE, x0 + (x1 - x0) * sweep, y - a - 2, 1, 2 * a + 4, 0);
}

function drawSkin(g, x0, skin) {
    var base = 134, top = 66, i;
    pkFill(g, PK_LANE, x0, base, 104, 1, 0);
    for (i = 0; i < RATIO.length; i++) {
        var h = (base - top) * skinAmp(RATIO[i], skin);
        pkFill(g, pkTouched[3] ? PK_WHITE : flash > 0 ? pkMix(PK_MID, pkAccent, flash) : PK_MID, x0 + 2 + i * 15, base - h, 9, h, 0);
    }
}

function drawTouch(g, x0, touch) {
    var base = 126, w = 100 * (1.5 - touch / 100 * 1.1) / 1.5 + 14, hgt = 22 + touch * 0.4, n = 40, i;
    pkFill(g, PK_LANE, x0, base, 104, 1, 0);
    g.set_source_rgba(pkTouched[4] ? PK_WHITE : flash > 0 ? pkMix(PK_LIGHT, pkAccent, flash) : PK_LIGHT); g.set_line_width(1.5);
    for (i = 0; i <= n; i++) {
        var u = i / n, px = x0 + 2 + (100 - w) / 2 + w * u, py = base - hgt * pulse(u);
        if (i) g.line_to(px, py); else g.move_to(px, py);
    }
    g.stroke();
}

function pkDraw(g, bank) {
    var stroke = Math.max(0, Math.min(3, Math.round(pkVal("stroke"))));
    drawDrum(g, 60, 84, 34, 42, pkTouched[0] ? PK_WHITE : PK_MID, stroke);
    drawRing(g, 132, 348, pkVal("tune"), pkVal("decay") || 100, RING[stroke]);
    drawSkin(g, 368, pkVal("skin"));
    drawTouch(g, 488, pkVal("touch"));
}

if (typeof module !== "undefined" && module.exports) module.exports = { ringEnv: ringEnv, ringCycles: ringCycles, skinAmp: skinAmp, pulse: pulse, RING: RING, PK_BANKS: PK_BANKS };
