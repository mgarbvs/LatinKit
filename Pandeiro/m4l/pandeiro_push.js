// pandeiro_push.js — Pandeiro / Tamborim on the Push 3 screen (push_kit.js: Live 13 / Looplet style). Two pages.
// Head: under Instrument, the pandeiro (frame, head, platinelas that jiggle on a hit) or the tamborim; under Stroke, the head from above with
// where the stroke played lands; under Tune + Decay, the ring: a wave whose pitch follows Tune and whose length follows Decay, swept by a playhead
// on every hit. Skin, Shell, Touch, Volume keep Push's dials.
// Jingles: a rail of platinela pairs that fling open and clatter on every hit, as far as Jingles lets them and as long as Decay lets them ring;
// a Shake keeps them going, a Roll rattles them. A tamborim has none. Press and Vary keep Push's dials.
// in: hit <velocity 0..1> (pandeiro_midi.js / pandeiro_midi_musical.js). Instrument, Stroke, Tune, Decay, Jingles are read from the controls.
inlets = 1;
var PK_BANKS = ["Head", "Jingles"];            // must match build_voice.py PUSH_BANKS
var PK_LAYOUT = { Head: "CCCCDDDD", Jingles: "CDDCCCCC" };
include("push_kit.js");

// the stroke each menu entry plays on each instrument (pandeiro_engine.py MAP; pandeiro_view.js EFF)
var EFF = [["Thumb", "Finger", "Slap", "Rim", "Shake", "Roll", "Thumb", "Finger"], ["Open", "Finger", "Open", "Open", "Finger", "Roll", "Open", "Mute"]];
var flash = 0, sweep = -1, shake = 0, roll = 0, fr = 0;

function eff() { return EFF[Math.max(0, Math.min(1, Math.round(pkVal("inst"))))][Math.max(0, Math.min(7, Math.round(pkVal("stroke"))))]; }

function hit(v) {
    var s = eff();
    flash = 0.4 + 0.6 * v; sweep = s === "Shake" ? -1 : 0;
    shake = Math.max(shake, s === "Shake" ? 1 : v);
    if (s === "Roll") roll = 33;                    // 1.1 s of rapid taps
}

function pkTick() {
    fr++;
    flash *= 0.85; if (flash < 0.02) flash = 0;
    if (sweep >= 0) { sweep += 0.033; if (sweep > 1.2) sweep = -1; }
    if (roll > 0) { roll--; shake = Math.max(shake, 0.6); flash = Math.max(flash, 0.3); }
    shake *= jingleKeep(pkVal("decay") || 100); if (shake < 0.01) shake = 0;
}

// Per-frame keep of the jingles' motion: Decay stretches how long they ring (30..300 %).
function jingleKeep(decayPct) { return 1 - 0.1 * 100 / decayPct; }
// Ring-out envelope at t (0..1 of the window): decay% scales the time constant.
function ringEnv(t, decayPct) { return Math.exp(-t * 4.5 / (decayPct / 100)); }
// Cycles shown across the window: the head's open tone (250 / 450 Hz) scaled down to a readable count, Tune in semitones.
function ringCycles(tune, inst) { return 8 * (inst ? 1.6 : 1) * Math.pow(2, tune / 12); }
// How far (px, up to 8) one platinela pair is flung open at frame f, slot k: motion x Jingles; a tamborim has none.
function jingleOpen(k, f, motion, amount, inst) { return inst ? 0 : 8 * motion * amount * (0.55 + 0.45 * Math.sin(f * 0.9 + k * 1.7)); }

function pair(g, x, y, open, lit, w, h) {   // two stacked discs; open px apart each
    g.set_source_rgba(lit); g.set_line_width(1.2);
    g.ellipse(x - w / 2, y - 1.5 * h - open, w, h); g.stroke();
    g.ellipse(x - w / 2, y + 0.5 * h + open, w, h); g.stroke();
}

function drawFrame(g, cx, cy, inst, c) {
    var r = inst ? 22 : 36, a, k, amt = pkVal("jingles") / 100;
    g.set_source_rgba(flash > 0 ? pkMix(c, pkAccent, flash) : c); g.set_line_width(1.5);
    g.ellipse(cx - r, cy - r, 2 * r, 2 * r); g.stroke();
    g.set_source_rgba(PK_DIM); g.set_line_width(1);
    g.ellipse(cx - r + 5, cy - r + 5, 2 * r - 10, 2 * r - 10); g.stroke();
    if (inst) return;
    for (k = 0; k < 5; k++) {   // platinela slots round the frame, shaken by the hit
        a = -Math.PI / 2 + (k - 2) * 0.62;
        var open = jingleOpen(k, fr, shake, amt, inst);
        pair(g, cx + Math.cos(a) * (r + 1), cy + Math.sin(a) * (r + 1) - 4, open * 0.4, open > 2 ? pkAccent : PK_LIGHT, 9, 3);
    }
}

// where the stroke touches the head (cx, cy, r); n = fingers/dots, shake draws the frame tilting
function drawHead(g, cx, cy, r, name) {
    var hot = pkTouched[1], c = hot ? PK_WHITE : flash > 0 ? pkMix(pkAccent, PK_WHITE, flash * 0.6) : pkAccent, x, y;
    g.set_source_rgba(hot ? PK_WHITE : PK_MID); g.set_line_width(1.5);
    g.ellipse(cx - r, cy - r, 2 * r, 2 * r); g.stroke();
    g.set_source_rgba(PK_DIM); g.set_line_width(1);
    g.ellipse(cx - r + 4, cy - r + 4, 2 * r - 8, 2 * r - 8); g.stroke();
    g.set_source_rgba(c);
    if (name === "Thumb") { g.ellipse(cx + r * 0.5 - 6, cy + r * 0.4 - 4, 12, 8); g.fill(); }
    else if (name === "Finger") { g.ellipse(cx + 4 - 5, cy - 5, 10, 10); g.fill(); }
    else if (name === "Slap") { g.ellipse(cx - 14, cy - 7, 28, 14); g.fill(); }
    else if (name === "Rim") { g.ellipse(cx + r * 0.88 - 5, cy - 5, 10, 10); g.fill(); }
    else if (name === "Open") { g.ellipse(cx + r * 0.25 - 5, cy - 5, 10, 10); g.fill(); }
    else if (name === "Roll") { g.ellipse(cx - 12, cy - 4, 8, 8); g.fill(); g.ellipse(cx + 5, cy - 4, 8, 8); g.fill(); }
    else if (name === "Mute") {
        g.ellipse(cx - r * 0.5 - 6, cy - 5, 24, 14); g.fill();                   // the hand resting
        pkFill(g, PK_LIGHT, cx + r * 0.3, cy - 4, 8, 8, 4);                       // the stick's contact
    } else {                                                                      // shake: the frame is held and rattled
        g.set_line_width(1.5);
        for (x = -1; x <= 1; x += 2) { g.move_to(cx + x * (r + 6), cy - 10); g.curve_to(cx + x * (r + 12), cy - 4, cx + x * (r + 12), cy + 4, cx + x * (r + 6), cy + 10); g.stroke(); }
    }
}

function drawRing(g, x0, x1, tune, decay, inst) {
    var y = 99, a = 30, n = 120, cyc = ringCycles(tune, inst), wave = pkTouched[2], env = pkTouched[3], i;
    pkFill(g, PK_LANE, x0, y, x1 - x0, 1, 0);
    g.set_line_width(1.2);
    for (i = 0; i < n; i++) {   // the wave, lit up to the playhead
        var t0 = i / n, t1 = (i + 1) / n;
        g.set_source_rgba(wave ? PK_WHITE : sweep >= 0 && t1 <= sweep ? pkAccent : PK_MID);
        g.move_to(x0 + (x1 - x0) * t0, y - a * ringEnv(t0, decay) * Math.sin(2 * Math.PI * cyc * t0));
        g.line_to(x0 + (x1 - x0) * t1, y - a * ringEnv(t1, decay) * Math.sin(2 * Math.PI * cyc * t1));
        g.stroke();
    }
    g.set_source_rgba(env ? PK_WHITE : PK_DIM); g.set_line_width(1);
    for (var s = -1; s <= 1; s += 2) {
        for (i = 0; i <= n; i++) {
            var t = i / n, py = y - s * a * ringEnv(t, decay);
            if (i) g.line_to(x0 + (x1 - x0) * t, py); else g.move_to(x0, py);
        }
        g.stroke();
    }
    if (sweep >= 0 && sweep <= 1) pkFill(g, PK_WHITE, x0 + (x1 - x0) * sweep, y - a - 2, 1, 2 * a + 4, 0);
}

function drawRail(g, inst) {
    var amt = pkVal("jingles") / 100, k, x;
    pkFill(g, PK_DIM, 380, 99, 560, 1, 0);
    for (k = 0; k < 12; k++) {
        x = 400 + k * 48;
        var open = jingleOpen(k, fr, shake, amt, inst), on = open > 2;
        pkFill(g, PK_DIM, x, 90, 1, 18, 0);                                       // the slot's pin
        pair(g, x, 99, open, pkTouched[0] ? PK_WHITE : on ? pkAccent : inst ? PK_DIM : PK_MID, 24, 6);
    }
    if (inst) pkText(g, "none on a tamborim", 660, 132, 10, PK_MID, PK_FONT, 0.5);
}

function pkDraw(g, bank) {
    var inst = Math.max(0, Math.min(1, Math.round(pkVal("inst"))));
    if (bank === "Head") {
        drawFrame(g, 60, 102, inst, pkTouched[0] ? PK_WHITE : PK_LIGHT);
        drawHead(g, 180, 99, 34, eff());
        drawRing(g, 252, 468, pkVal("tune"), pkVal("decay") || 100, inst);
    } else {
        var amt = pkVal("jingles") / 100, open = jingleOpen(0, fr, shake, amt, inst);
        pair(g, 60, 99, 3 + open * 0.7, pkTouched[0] ? PK_WHITE : open > 2 ? pkAccent : inst ? PK_DIM : pkMix(PK_DIM, PK_LIGHT, amt), 44, 11);
        drawRail(g, inst);
    }
}

if (typeof module !== "undefined" && module.exports) module.exports = { ringEnv: ringEnv, ringCycles: ringCycles, jingleOpen: jingleOpen, jingleKeep: jingleKeep, EFF: EFF, PK_BANKS: PK_BANKS };
