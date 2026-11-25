// repinique_push.js — Repinique on the Push 3 screen (push_kit.js: Live 13 / Looplet style). One page, "Drum".
// Under Stroke: the repinique in line art with the stick or hand where this stroke lands; it lights on every hit (a Flam lights twice).
// Under Tune + Decay: the ring, a wave whose pitch follows Tune and whose length follows Decay and the stroke, swept by a playhead on every hit.
// Under Skin: the drum's tones, tilted by Skin (the shell tones above 700 Hz are drawn too). Under Touch: the contact force pulse.
// Vary, Press, Volume keep Push's dials.
// in: hit <velocity 0..1> (repinique_midi.js). Stroke, Tune, Decay, Skin, Touch are read from the controls.
inlets = 1;
var PK_BANKS = ["Drum"];                       // must match build_voice.py PUSH_BANKS
var PK_LAYOUT = { Drum: "CCCCCDDD" };
include("push_kit.js");

var RATIO = [0.70, 1.0, 1.23, 1.62, 1.9, 2.64, 3.82, 5.88];   // tones of the recorded drum / 356.5 Hz (repinique_engine.py HZ)
var RING = [1, 1, 0.5, 0.8, 0.3, 1];                           // how long each stroke rings against Open: Rim is short, Mute damps
var flash = 0, sweep = -1, flam = 0;

function hit(v) {
    flash = 0.4 + 0.6 * v; sweep = 0;
    if (Math.round(pkVal("stroke")) === 5) flam = 4;           // Flam: the second stroke follows 4 frames later
}

function pkTick() {
    flash *= 0.85; if (flash < 0.02) flash = 0;
    if (flam > 0 && --flam === 0) { flash = Math.max(flash, 0.7); sweep = 0; }
    if (sweep >= 0) { sweep += 0.033; if (sweep > 1.2) sweep = -1; }
}

// Ring-out envelope at t (0..1 of the window): decay% scales the time constant, ring = the stroke's length.
function ringEnv(t, decayPct, ring) { return Math.exp(-t * 4.5 / (decayPct / 100 * ring)); }
// Cycles shown across the window: the open tone (356 Hz) scaled down to a readable count, Tune in semitones.
function ringCycles(tune) { return 12 * Math.pow(2, tune / 12); }
// Height 0..1 of the tone at ratio r: Skin tilts +-6 dB per octave of ratio around the open tone.
function skinAmp(r, skin) { return Math.min(1, 0.55 * Math.pow(r, (skin - 50) * 0.02 - 0.5)); }
// Contact pulse (0..1) at u (0..1 across its width): sin^2 bump.
function pulse(u) { var s = Math.sin(Math.PI * u); return s * s; }

function stick(g, tx, ty, lift) {   // a stick ending in a bead at the contact
    g.move_to(tx + 16 + lift * 0.5, ty - 17 - lift); g.line_to(tx + 1, ty - 1 - lift * 0.3); g.stroke();
    g.ellipse(tx - 2.5, ty - 3.5 - lift * 0.3, 5, 5); g.fill();
}

function drawDrum(g, cx, top, r, h, c, stroke) {
    var ry = r * 0.27, bot = top + h, lift = flash > 0 ? 9 * flash : 0, k;
    if (flash > 0) { g.set_source_rgba(pkMix(PK_BLACK, pkAccent, flash)); g.ellipse(cx - r, top - ry, 2 * r, 2 * ry); g.fill(); }
    g.set_source_rgba(c); g.set_line_width(1.5);
    g.ellipse(cx - r, top - ry, 2 * r, 2 * ry); g.stroke();
    g.ellipse(cx - r + 3, top - ry + 1.5, 2 * r - 6, 2 * ry - 3); g.stroke();   // the hoop
    g.move_to(cx - r, top); g.line_to(cx - r, bot); g.stroke();
    g.move_to(cx + r, top); g.line_to(cx + r, bot); g.stroke();
    g.move_to(cx - r, bot); g.curve_to(cx - r, bot + ry * 1.3, cx + r, bot + ry * 1.3, cx + r, bot); g.stroke();
    g.set_source_rgba(PK_DIM); g.set_line_width(1);
    for (k = -2; k <= 2; k++) { g.move_to(cx + k * r * 0.4, top + ry); g.line_to(cx + k * r * 0.4, bot - 6); g.stroke(); }   // tension rods
    g.set_source_rgba(pkTouched[0] ? PK_WHITE : flash > 0 ? pkMix(PK_LIGHT, pkAccent, flash) : PK_LIGHT); g.set_line_width(2);
    if (stroke === 0) stick(g, cx + 6, top, lift);                                    // open
    else if (stroke === 1) {                                                          // rimshot: head and rim together
        stick(g, cx + r * 0.72, top + 2, lift);
        g.set_line_width(1); g.move_to(cx + r + 3, top - 8); g.line_to(cx + r + 8, top - 12); g.stroke();   // the crack
    } else if (stroke === 2) stick(g, cx + r * 0.97, top - 2, lift);                  // rim
    else if (stroke === 3) {                                                          // hand: three fingers flat on the head
        for (k = -1; k <= 1; k++) { g.move_to(cx + k * 4, top - lift * 0.3); g.line_to(cx + k * 4 + 7 + lift * 0.4, top - 15 - lift); g.stroke(); }
    } else if (stroke === 4) {                                                        // mute: the hand pressed on the head, a stick beside it
        g.move_to(cx - 14, top - 1); g.line_to(cx - 2, top - 3); g.line_to(cx + 4, top - 12); g.stroke();
        stick(g, cx + 14, top, lift);
    } else {                                                                          // flam: a grace stick close beside the main one
        stick(g, cx - 8, top, flam > 0 ? lift : lift * 0.5);
        stick(g, cx + 8, top, lift);
    }
}

function drawRing(g, x0, x1, tune, decay, ring) {
    var y = 99, a = 30, n = 140, cyc = ringCycles(tune), wave = pkTouched[1], env = pkTouched[2], i;
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
        pkFill(g, pkTouched[3] ? PK_WHITE : flash > 0 ? pkMix(PK_MID, pkAccent, flash) : PK_MID, x0 + 2 + i * 13, base - h, 8, h, 0);
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
    var stroke = Math.max(0, Math.min(5, Math.round(pkVal("stroke"))));
    drawDrum(g, 60, 84, 30, 44, pkTouched[0] ? PK_WHITE : PK_MID, stroke);
    drawRing(g, 132, 348, pkVal("tune"), pkVal("decay") || 100, RING[stroke]);
    drawSkin(g, 368, pkVal("skin"));
    drawTouch(g, 488, pkVal("touch"));
}

if (typeof module !== "undefined" && module.exports) module.exports = { ringEnv: ringEnv, ringCycles: ringCycles, skinAmp: skinAmp, pulse: pulse, RING: RING, PK_BANKS: PK_BANKS };
