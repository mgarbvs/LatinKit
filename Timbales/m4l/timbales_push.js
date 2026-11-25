// timbales_push.js — Timbales on the Push 3 screen (push_kit.js: Live 13 / Looplet style).
// Drum page: under Drum + Stroke, the pair of metal-shelled drums on their stand (the selected one lit) and the stick where the current stroke lands:
// head, rim, or on the shell (cascara near the top edge, paila mid-shell); under Tune + Decay, the head's ring; under Shell + Ring, the metal
// shell's own ring (a short bright shimmer: its size follows Shell, its length Ring); under Stick, the contact click (harder = sharper).
// Volume keeps Push's dial. in: hit <velocity 0..1> (timbales_midi.js). Drum, Stroke, Tune, Decay, Shell, Ring, Stick are read from the controls.
inlets = 1;
var PK_BANKS = ["Drum", "Hand"];               // must match build_voice.py PUSH_BANKS
var PK_LAYOUT = { Drum: "CCCCCCCD" };
include("push_kit.js");

var R = [24, 30], H = 38;                      // head radius (high, low), shell height (px)
var HZ = [200, 120];                           // open tone at Tune 0
var CX = [62, 178], TOP = 80;                  // the two drums' centres, head top
var flash = 0, sweep = -1;

function hit(v) { flash = 0.4 + 0.6 * v; sweep = 0; }

function pkTick() {
    flash *= 0.85; if (flash < 0.02) flash = 0;
    if (sweep >= 0) { sweep += 0.033; if (sweep > 1.2) sweep = -1; }
}

// Envelope at t (0..1 of the window): pct scales the time constant, k the base rate.
function env(t, pct, k) { return Math.exp(-t * k / (pct / 100)); }
// Cycles of the head's tone across the window: the drum's open tone and Tune, scaled down to a readable count.
function ringCycles(tune, drum) { return 8 * (HZ[drum] / 160) * Math.pow(2, tune / 12); }
// Where the stick lands on a drum (x, y relative to the head centre in units of r; shell y in units of h, below the top), and whether it is on the shell.
// 0 open, 1 rimshot, 2 cascara, 3 paila, 4 rim click (laid across the head), 5 muted
var AT = [[-0.25, 0, 0], [0.72, 0.1, 0], [1, 0.18, 1], [1, 0.62, 1], [0.7, -0.3, 0], [0, -0.05, 0]];
function contact(stroke, cx, top, r, h) {
    var a = AT[stroke], ry = r * 0.3;
    return { x: cx + a[0] * r, y: a[2] ? top + a[1] * h : top + a[1] * ry * 3, shell: a[2] };
}

function drawTimbal(g, cx, r, c, lit, ring) {
    var ry = r * 0.3, bot = TOP + H;
    if (lit > 0) { g.set_source_rgba(pkMix(PK_BLACK, pkAccent, lit)); g.ellipse(cx - r, TOP - ry, 2 * r, 2 * ry); g.fill(); }
    g.set_source_rgba(c); g.set_line_width(1.5);
    g.ellipse(cx - r, TOP - ry, 2 * r, 2 * ry); g.stroke();
    g.ellipse(cx - r + 3, TOP - ry + 1.5, 2 * r - 6, 2 * ry - 3); g.stroke();      // the hoop
    g.move_to(cx - r, TOP); g.line_to(cx - r, bot); g.stroke();                    // a straight metal shell
    g.move_to(cx + r, TOP); g.line_to(cx + r, bot); g.stroke();
    g.move_to(cx - r, bot); g.curve_to(cx - r, bot + ry * 1.3, cx + r, bot + ry * 1.3, cx + r, bot); g.stroke();
    if (ring > 0) {   // the shell rings: a band of light on it
        g.set_source_rgba(pkMix(PK_BLACK, pkAccent, ring * 0.6)); g.rectangle(cx - r + 1, TOP + 2, 2 * r - 2, H - 2); g.fill();
    }
}

function drawStand(g) {   // one stand for both: legs from the shells down, a cross brace
    var k;
    g.set_source_rgba(PK_DIM); g.set_line_width(1.5);
    for (k = 0; k < 2; k++) {
        g.move_to(CX[k] - R[k] * 0.45, TOP + H + R[k] * 0.4); g.line_to(CX[k] - R[k] * 0.75, 140); g.stroke();
        g.move_to(CX[k] + R[k] * 0.45, TOP + H + R[k] * 0.4); g.line_to(CX[k] + R[k] * 0.75, 140); g.stroke();
    }
    g.move_to(CX[0], TOP + H + 13); g.line_to(CX[1], TOP + H + 13); g.stroke();
}

function drawStick(g, drum, stroke) {
    var r = R[drum], c = contact(stroke, CX[drum], TOP, r, H), hot = pkTouched[1], lift = flash > 0 ? flash * 14 : 0, col = hot ? PK_WHITE : flash > 0 ? pkMix(pkAccent, PK_WHITE, flash * 0.6) : pkAccent, s, k, d;
    for (s = 0; s < 6; s++) {   // where each stroke lands on the selected drum, dim
        if (s === stroke) continue;
        d = contact(s, CX[drum], TOP, r, H);
        pkFill(g, PK_DIM, d.x - 1, d.y - 1, 2, 2, 1);
    }
    g.set_source_rgba(col); g.set_line_width(2);
    if (stroke === 4) { g.move_to(c.x - r * 1.5, c.y + r * 0.18); g.line_to(c.x + 5, c.y - 1); g.stroke(); }   // rim click: the stick lies across the head
    g.move_to(c.x + (stroke === 4 ? 5 : 0), c.y - lift * 0.3); g.line_to(c.x + 20 + lift * 0.5, c.y - 22 - lift); g.stroke();
    g.ellipse(c.x - 3, c.y - 3, 6, 6); g.fill();
    if (flash > 0) {
        g.set_line_width(1);
        for (k = 0; k < 3; k++) { s = -0.9 + k * 0.9; g.move_to(c.x + Math.cos(s) * 5, c.y + Math.sin(s) * 5); g.line_to(c.x + Math.cos(s) * 10, c.y + Math.sin(s) * 10); g.stroke(); }
    }
}

function drawHeadRing(g, x0, x1, tune, decay, drum) {
    var y = 99, a = 30, n = 120, cyc = ringCycles(tune, drum), wave = pkTouched[2], en = pkTouched[3], i, s, t0, t1, on;
    pkFill(g, PK_LANE, x0, y, x1 - x0, 1, 0);
    g.set_line_width(1.2);
    for (i = 0; i < n; i++) {
        t0 = i / n; t1 = (i + 1) / n; on = sweep >= 0 && t1 <= sweep;
        g.set_source_rgba(on || wave ? (wave ? PK_WHITE : pkAccent) : PK_MID);
        g.move_to(x0 + (x1 - x0) * t0, y - a * env(t0, decay, 4.5) * Math.sin(2 * Math.PI * cyc * t0));
        g.line_to(x0 + (x1 - x0) * t1, y - a * env(t1, decay, 4.5) * Math.sin(2 * Math.PI * cyc * t1));
        g.stroke();
    }
    g.set_source_rgba(en ? PK_WHITE : PK_DIM); g.set_line_width(1);
    for (s = -1; s <= 1; s += 2) {
        for (i = 0; i <= n; i++) {
            if (i) g.line_to(x0 + (x1 - x0) * i / n, y - s * a * env(i / n, decay, 4.5)); else g.move_to(x0, y - s * a);
        }
        g.stroke();
    }
    if (sweep >= 0 && sweep <= 1) pkFill(g, PK_WHITE, x0 + (x1 - x0) * sweep, y - a - 2, 1, 2 * a + 4, 0);
}

// the metal shell: a dense bright shimmer (two inharmonic partials), its size from Shell, its length from Ring
function drawShellRing(g, x0, x1, shell, ring) {
    var y = 99, a = 4 + 26 * shell / 100, n = 240, i, t0, t1, on, hot = pkTouched[4] || pkTouched[5];
    pkFill(g, PK_LANE, x0, y, x1 - x0, 1, 0);
    g.set_line_width(1);
    for (i = 0; i < n; i++) {
        t0 = i / n; t1 = (i + 1) / n; on = sweep >= 0 && t1 <= sweep;
        g.set_source_rgba(hot ? PK_WHITE : on ? pkAccent : PK_MID);
        g.move_to(x0 + (x1 - x0) * t0, y - a * env(t0, ring, 6) * shimmer(t0));
        g.line_to(x0 + (x1 - x0) * t1, y - a * env(t1, ring, 6) * shimmer(t1));
        g.stroke();
    }
    g.set_source_rgba(PK_DIM);
    for (i = 0; i <= 60; i++) {
        if (i) g.line_to(x0 + (x1 - x0) * i / 60, y - a * env(i / 60, ring, 6)); else g.move_to(x0, y - a);
    }
    g.stroke();
}
function shimmer(t) { return 0.6 * Math.sin(2 * Math.PI * 41 * t) + 0.4 * Math.sin(2 * Math.PI * 67 * t + 1); }

// the stick's contact: a click whose width shrinks (and height grows) as Stick gets harder
function clickWidth(stick) { return 22 - 18 * stick / 100; }
function drawClick(g, x0, stick) {
    var w = clickWidth(stick), h = 14 + 32 * stick / 100, cx = x0 + 48, y = 126, i, x, hot = pkTouched[6];
    pkFill(g, PK_LANE, x0, y, 96, 1, 0);
    g.set_source_rgba(hot ? PK_WHITE : flash > 0 ? pkMix(PK_LIGHT, pkAccent, flash) : PK_LIGHT); g.set_line_width(1.5);
    for (i = -30; i <= 30; i++) {
        x = i / 30 * 42;
        if (i > -30) g.line_to(cx + x, y - h * Math.exp(-Math.pow(x / w, 2) * (x < 0 ? 4 : 1))); else g.move_to(cx + x, y);
    }
    g.stroke();
}

function pkDraw(g, bank) {
    if (bank !== "Drum") return;
    var drum = Math.max(0, Math.min(1, Math.round(pkVal("drum")))), stroke = Math.max(0, Math.min(5, Math.round(pkVal("stroke"))));
    var onShell = AT[stroke][2], k, i;
    drawStand(g);
    for (k = 0; k < 2; k++) {
        i = k === drum;
        drawTimbal(g, CX[k], R[k], i ? (pkTouched[0] ? PK_WHITE : PK_LIGHT) : PK_DIM, i && !onShell ? flash : 0, i && onShell ? flash : 0);
    }
    drawStick(g, drum, stroke);
    drawHeadRing(g, 252, 468, pkVal("tune"), pkVal("decay") || 100, drum);
    drawShellRing(g, 492, 708, pkVal("shell"), pkVal("ring") || 100);
    drawClick(g, 732, pkVal("stick"));
}

if (typeof module !== "undefined" && module.exports) module.exports = { env: env, ringCycles: ringCycles, contact: contact, clickWidth: clickWidth, AT: AT, PK_BANKS: PK_BANKS };
