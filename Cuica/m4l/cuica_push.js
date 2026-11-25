// cuica_push.js — Cuica on the Push 3 screen (push_kit.js: Live 13 / Looplet style).
// Rub page: under Pressure, the cloth gripping the rod (it slides along the rod through every stroke); under Stroke, Pull and
// Scoop, the pitch path of one stroke: a push (lit) and a pull (grey, Pull semitones higher), each starting Scoop semitones away
// and riding into its note, swept by a playhead as long as Stroke; under Thumb and Glide, how the mod wheel's pitch rise
// settles (a dot marks the wheel's target now). Tune and Speed keep Push's dials.
// Head page: under Head, Rasp and Tone, the head's resonance (its peak follows Head, a lowpass follows Tone, a rough floor
// is Rasp) and the last note's pitch on a log frequency axis; under Decay, the ring-out after the rub. Volume and Alt keep Push's dials.
// in: hit <note> <velocity 0..1> (cuica_midi.js); mw <0..1> (the mod wheel, from the same js's engine outlet).
// Tune, Pressure, Stroke, Pull, Scoop, Thumb, Glide, Head, Rasp, Tone, Decay are read from the controls.
inlets = 1;
var PK_BANKS = ["Rub", "Head"];                // must match build_maxpat.py PUSH_BANKS
var PK_LAYOUT = { Rub: "DCDCCCCC", Head: "CCCCDDDD" };
include("push_kit.js");

var GMIN = 0.135, GSP = 0.9, GD = GMIN + GSP * 0.55 * 0.55, COMP = 49;   // the engine's grip law (cuica_engine.py)
var note = 60, flash = 0, sweep = -1, ring = -1, mw = 0;
var RING_WIN = 1;                              // seconds shown in the Decay picture
var PY = 3;                                    // px per semitone in the pitch pictures

function hit(n, v) { note = n; flash = 0.4 + 0.6 * v; sweep = 0; ring = 0; }
function mwheel(v) { mw = v; }

function pkTick() {
    flash *= 0.85; if (flash < 0.02) flash = 0;
    var st = pkVal("stroke") || 300;
    if (sweep >= 0) { sweep += 0.033 / (st / 1000); if (sweep > 1.05) sweep = -1; }
    if (ring >= 0) { ring += 0.033 / RING_WIN; if (ring > 1.05) ring = -1; }
}

function smooth(x) { x = Math.max(0, Math.min(1, x)); return x * x * (3 - 2 * x); }
// The scoop's remaining distance at phase t (0..1 of the stroke): it arrives at 60 % (the engine's prg).
function scoopLeft(t) { return 1 - smooth((t - 0.25) / 0.35); }
// Net flattening (cents) of full grip beyond the default Pressure (percent), mid-stroke.
function flatCents(pressPct) { var p = pressPct / 100, gp = GMIN + GSP * p * p; return COMP * Math.max(0, gp - GD); }
// Pitch rise (semitones) t seconds after the wheel jumps to full: the engine glides to it, 95 % after Glide ms.
function thumbRise(t, thumb, glideMs) { return thumb * (1 - Math.exp(-3 * t * 1000 / Math.max(glideMs, 0.5))); }
// Head resonance (dB) at f: its peak sits at 250 Hz x 4^Head, as sharp as 4 + 36 Head.
function headDb(f, head) {
    var fm = 250 * Math.pow(4, head), q = 4 + 36 * head, x = f / fm, a = 1 - x * x;
    return 10 * Math.log(1 / (a * a + x * x / (q * q))) / Math.LN10;
}
// Tone's lowpass (dB) at f: corner at fm x (1.2 + 3 Tone).
function toneDb(f, head, tone) { var x = f / (250 * Math.pow(4, head) * (1.2 + 3 * tone)); return -10 * Math.log(1 + x * x * x * x) / Math.LN10; }
function mtof(n) { return 440 * Math.pow(2, (n - 69) / 12); }

function drawRod(g, press) {
    var cx = 180, hot = pkTouched[1], gap = 2 + 11 * (1 - press / 100), y = sweep >= 0 ? 130 - 62 * Math.min(sweep, 1) : 99;
    g.set_source_rgba(PK_MID); g.set_line_width(1.5);
    g.move_to(cx, 64); g.line_to(cx, 138); g.stroke();
    g.set_source_rgba(hot ? PK_WHITE : sweep >= 0 ? pkAccent : PK_LIGHT);
    for (var k = -1; k <= 1; k += 2) { g.rectangle_rounded(k < 0 ? cx - gap - 7 : cx + gap, y - 14, 7, 28, 3, 3); g.stroke(); }
    var c = flatCents(press);
    if (c >= 0.5) pkText(g, "-" + Math.round(c) + " ct", cx + 22, 138, 10, hot ? PK_WHITE : PK_MID, PK_FONT, 0);
}

function drawPath(g, x0, x1, base, off, scoop, col, lit) {
    var n = 60, i, t;
    g.set_line_width(1.5);
    for (i = 0; i < n; i++) {
        t = i / n;
        g.set_source_rgba(lit && sweep >= 0 && (i + 1) / n <= sweep ? pkAccent : col);
        g.move_to(x0 + (x1 - x0) * t, base - PY * Math.max(-12, Math.min(13, off + scoop * scoopLeft(t))));
        t = (i + 1) / n;
        g.line_to(x0 + (x1 - x0) * t, base - PY * Math.max(-12, Math.min(13, off + scoop * scoopLeft(t))));
        g.stroke();
    }
}

function drawPitch(g, x0, x1, pull, scoop) {
    var base = 99, i, hot = pkAny(3, 5);
    pkFill(g, PK_LANE, x0, base, x1 - x0, 1, 0);          // the note's own pitch
    g.set_source_rgba(PK_DIM); g.set_line_width(1);        // the rub's effort, along the bottom
    for (i = 0; i <= 40; i++) {
        var t = i / 40, y = 138 - 12 * 0.5 * (1 - Math.cos(2 * Math.PI * t)), x = x0 + (x1 - x0) * t;
        if (i) g.line_to(x, y); else g.move_to(x, y);
    }
    g.stroke();
    drawPath(g, x0, x1, base, pull, scoop, pkTouched[4] ? PK_WHITE : PK_DIM, false);
    drawPath(g, x0, x1, base, 0, scoop, hot && !pkTouched[4] ? PK_WHITE : PK_LIGHT, true);
    pkText(g, "pull", x1, base - PY * pull - 4, 9, pkTouched[4] ? PK_WHITE : PK_DIM, PK_FONT, 1);
    if (sweep >= 0 && sweep <= 1) pkFill(g, PK_WHITE, x0 + (x1 - x0) * sweep, 62, 1, 78, 0);
}

function drawThumb(g, x0, x1, thumb, glide) {
    var base = 136, n = 50, i, th = pkTouched[6], gl = pkTouched[7], top = base - PY * thumb;
    pkFill(g, PK_LANE, x0, base, x1 - x0, 1, 0);
    pkFill(g, th ? PK_WHITE : PK_DIM, x0, top, x1 - x0, 1, 0);   // the full wheel's pitch
    g.set_source_rgba(gl ? PK_WHITE : PK_LIGHT); g.set_line_width(1.5);
    for (i = 0; i <= n; i++) {
        var t = i / n * 0.7, x = x0 + (x1 - x0) * i / n, y = base - PY * thumbRise(t, thumb, glide);
        if (i) g.line_to(x, y); else g.move_to(x, y);
    }
    g.stroke();
    g.set_source_rgba(mw > 0.01 ? pkAccent : PK_MID);            // the wheel's pitch now
    g.ellipse(x1 - 4, base - PY * thumb * mw - 4, 8, 8); g.fill();
}

function xOf(f, x0, x1) { return x0 + (x1 - x0) * (Math.log(f) - Math.log(100)) / (Math.log(4000) - Math.log(100)); }

function drawHead(g, x0, x1, head, rasp, tone, tune) {
    var base = 138, i, hot = pkAny(0, 0), n = 96, f, ts = pkAny(2, 2);
    pkFill(g, PK_LANE, x0, base, x1 - x0, 1, 0);
    g.set_line_width(1.5);
    g.set_source_rgba(pkTouched[0] ? PK_WHITE : PK_LIGHT);        // the head's resonance
    for (i = 0; i <= n; i++) {
        f = 100 * Math.pow(40, i / n);
        var y = base - Math.max(0, Math.min(78, (headDb(f, head) + 12) * 1.6));
        if (i) g.line_to(xOf(f, x0, x1), y); else g.move_to(x0, y);
    }
    g.stroke();
    g.set_source_rgba(ts ? PK_WHITE : PK_DIM); g.set_line_width(1);   // Tone's lowpass, drawn at the head's peak level
    var top = base - (headDb(250 * Math.pow(4, head), head) + 12) * 1.6;
    for (i = 0; i <= n; i++) {
        f = 100 * Math.pow(40, i / n);
        var yt = Math.max(60, Math.min(138, top + 4 - toneDb(f, head, tone) * 1.6));
        if (i) g.line_to(xOf(f, x0, x1), yt); else g.move_to(x0, yt);
    }
    g.stroke();
    g.set_source_rgba(pkTouched[1] ? PK_WHITE : PK_MID); g.set_line_width(1);   // Rasp: a rough floor
    for (i = 0; i < 40; i++) {
        var x = x0 + (x1 - x0) * i / 40, hh = rasp / 100 * 14 * (0.35 + 0.65 * Math.abs(Math.sin(i * 12.9898) * 43758.5453 % 1));
        g.move_to(x, base - 1); g.line_to(x, base - 1 - hh); g.stroke();
    }
    var nx = xOf(Math.max(100, Math.min(4000, mtof(note + tune))), x0, x1);   // the last note
    pkFill(g, flash > 0 ? pkMix(PK_LIGHT, pkAccent, flash) : PK_MID, nx, 62, 1.5, base - 62, 0);
}

function drawRing(g, x0, x1, decay) {
    var y = 99, a = 30, n = 120, i, hot = pkTouched[3];
    pkFill(g, PK_LANE, x0, y, x1 - x0, 1, 0);
    for (var s = -1; s <= 1; s += 2) {
        g.set_line_width(1.2);
        for (i = 0; i < n; i++) {
            var t0 = i / n, t1 = (i + 1) / n;
            g.set_source_rgba(hot ? PK_WHITE : ring >= 0 && t1 <= ring ? pkAccent : PK_MID);
            g.move_to(x0 + (x1 - x0) * t0, y - s * a * Math.exp(-6.9078 * t0 * RING_WIN * 1000 / decay));
            g.line_to(x0 + (x1 - x0) * t1, y - s * a * Math.exp(-6.9078 * t1 * RING_WIN * 1000 / decay));
            g.stroke();
        }
    }
    if (ring >= 0 && ring <= 1) pkFill(g, PK_WHITE, x0 + (x1 - x0) * ring, y - a - 2, 1, 2 * a + 4, 0);
}

function pkDraw(g, bank) {
    if (bank === "Rub") {
        drawRod(g, pkVal("pressure"));
        drawPitch(g, 372, 708, pkVal("pull"), pkVal("scoop"));
        drawThumb(g, 740, 940, pkVal("thumb"), pkVal("glide"));
    } else {
        drawHead(g, 14, 346, (pkVal("head") || 0) / 100, pkVal("rasp"), (pkVal("tone") || 0) / 100, pkVal("tune"));
        drawRing(g, 372, 468, pkVal("decay") || 400);
    }
}

if (typeof module !== "undefined" && module.exports) module.exports = { scoopLeft: scoopLeft, flatCents: flatCents, thumbRise: thumbRise, headDb: headDb, toneDb: toneDb, PK_BANKS: PK_BANKS };
