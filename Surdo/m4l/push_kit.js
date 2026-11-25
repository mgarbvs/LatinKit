// push_kit.js — shared Push 3 screen kit for Max for Live devices, in Live 13's own flat style
// (after Ableton's Looplet): black canvas, grey line art, the track colour for what is active,
// white for what you're touching. Push's own parameter names and values stay on top.
//
// Use: a device's push script (a [js], 4 outlets, built by push_screen.py) sets
//     var PK_BANKS = ["Drum", "Tone"];                  // the baked bank names, in order
//     var PK_LAYOUT = { Drum: "CCCCDDDD" };             // per bank: D = Push's dial, C = our picture owns the column
//     include("push_kit.js");
//     function pkDraw(g, bank) { ... }                  // draw y 58..140 for this bank name; called ~30 fps while viewed
//     function pkTick() { ... }                          // optional: once per frame before pkDraw (fades)
// and handles its own data messages (hit, drum, ...). Read pkTouched[0..7], pkAccent, pkVal(varname).
// Wiring (push_screen.py): live.thisdevice -> bang; outlet 0 -> live.push; 1 -> Push id to live.observer
// and live.object right inlets; 2 -> observer left inlet; 3 -> live.object; observer -> [prepend view_state] -> in.
//
// Push rules (measured on a Push 3, Live 13 Beta; NAMMaxInstrument_CombinedOnly/docs/push-debugging.md):
// - The Push adds our picture's light and ignores alpha: the kit paints y 23..141 opaque black first, so
//   translucency blends onto black inside MGraphics. Black is invisible; nothing can darken Live's background.
// - Live draws each parameter's name (y 25-34) and value (y 40-55) on top: graphics live in y 58..140.
//   Push's own dials (D columns) sit at y 75-115 and draw on top too.
// - One 120 px column per encoder: put a graphic under the encoder that drives it.
// - Fixed colours arrive with red and blue swapped: write them B,G,R. Greys and pkAccent (TrackColor) are fine.
// - Needs Live 13's view_state API; in Live 12 nothing draws (harmless).

outlets = 4;

var PK_W = 960, PK_H = 160, PK_TOP = 23, PK_BOT = 141, PK_COL = 120, PK_Y0 = 58;
// Looplet's greys (#5B5B5B, #797979, #A5A5A5; lanes 0.12 / 0.27)
var PK_WHITE = [1, 1, 1, 1], PK_LIGHT = [0.65, 0.65, 0.65, 1], PK_MID = [0.475, 0.475, 0.475, 1];
var PK_DIM = [0.27, 0.27, 0.27, 1], PK_LANE = [0.12, 0.12, 0.12, 1], PK_BLACK = [0, 0, 0, 1];
var PK_ORANGE = [0.28, 0.7, 1, 1];   // B,G,R: the fallback accent until TrackColor arrives
var PK_FONT = "Ableton Sans Medium", PK_BOLD = "Ableton Sans Bold";

function pkStyles(name) {
    var l = (typeof PK_LAYOUT !== "undefined" && PK_LAYOUT[name]) || "DDDDDDDD", vis = [], val = [];
    for (var i = 0; i < 8; i++) {
        vis.push(l[i] === "D" ? "Default" : "None");
        val.push(l[i] === "D" ? "Normal" : "Small");
    }
    return { EncodersVisualStyle: vis, EncodersValueStyle: val };
}

// Observing view_state fires on every request (even no-ops): send once per bank while viewed.
function pkNeedsSend(active, bank, sent) { return active && bank >= 0 && bank !== sent; }

// Opt-in trace: touch /tmp/pushkit.on, reload the device, read /tmp/pushkit.log.
function pkLog(s) {
    var on = new File("/tmp/pushkit.on", "read"), ok = on.isopen;
    on.close();
    if (!ok) return;
    var f = new File("/tmp/pushkit.log", "readwrite");
    f.position = f.eof;
    f.writeline(new Date().toISOString() + " " + (typeof PK_BANKS !== "undefined" ? PK_BANKS.join("/") : "?") + ": " + s);
    f.close();
}

// ─── state ───────────────────────────────────────────────────────────────────
var pkStarted = false, pkThisId = 0, pkPushApi = null, pkActive = false, pkTask = null;
var pkBank = -1, pkSent = -1, pkTouched = [0, 0, 0, 0, 0, 0, 0, 0], pkAccent = PK_ORANGE, pkMatrix = null;
var pkPatcher = this.patcher;

// live.thisdevice bang: the Live API is usable from here on.
function bang() {
    if (pkStarted) return;
    pkStarted = true;
    pkThisId = parseInt(new LiveAPI("this_device").id, 10);
    pkLog("bang: this_device id " + pkThisId);
    var app = new LiveAPI(pkOnSurfaces, "live_app");
    app.property = "control_surfaces";
}

// Callback args: ["control_surfaces", "id", 1, "id", 2, ...]; pick the Push.
function pkOnSurfaces(args) {
    var id = 0;
    for (var i = 1; i + 1 < args.length; i += 2) {
        if (args[i + 1] && /^Push/.test(new LiveAPI("id " + args[i + 1]).type)) id = args[i + 1];
    }
    pkLog("push surface id " + id);
    pkSetActive(false);
    outlet(1, "id", id);
    outlet(2, "property", "view_state");
    pkPushApi = id ? new LiveAPI(pkOnViewDevice, "id " + id) : null;
    if (pkPushApi) pkPushApi.property = "view_device";
}

// Callback args: ["view_device", "id", N]
function pkOnViewDevice(args) { pkLog("view_device " + args.join(" ")); pkSetActive(parseInt(args[2], 10) === pkThisId); }

function pkSetActive(on) {
    if (on === pkActive) return;
    pkActive = on;
    pkSent = -1;
    if (!on) { if (pkTask) pkTask.cancel(); return; }
    if (!pkTask) { pkTask = new Task(pkFrame); pkTask.interval = 33; }   // ~30 fps while viewed
    pkTask.repeat();
    pkSync();
}

// "view_state dictionary <name>" from live.observer; anything else (<empty>) is ignored.
function view_state(kind, name) {
    if (kind !== "dictionary") return;
    var d = new Dict(name);
    pkBank = d.get("BankIndex");
    var t = d.get("EncodersTouched");
    if (t && t.length === 8) pkTouched = t;
    var r = d.get("TrackColor::red");
    pkAccent = typeof r === "number" ? [r / 255, d.get("TrackColor::green") / 255, d.get("TrackColor::blue") / 255, 1] : PK_ORANGE;
    pkSync();
}

function pkSync() {
    if (!pkNeedsSend(pkActive, pkBank, pkSent)) return;
    pkSent = pkBank;
    pkLog("bank " + pkBank + " (" + PK_BANKS[pkBank] + "): sending encoder styles");
    var d = new Dict();
    d.parse(JSON.stringify(pkStyles(PK_BANKS[pkBank])));   // one dict with every key: only the latest request applies
    outlet(3, "call", "request_view_state_change", "dictionary", d.name);
}

function pkRender() {
    var g = new MGraphics(PK_W, PK_H);
    if (!pkMatrix) pkMatrix = new JitterMatrix(4, "char", PK_W, PK_H);
    pkFill(g, PK_BLACK, 0, PK_TOP, PK_W, PK_BOT - PK_TOP, 0);
    if (PK_BANKS[pkBank] !== undefined) pkDraw(g, PK_BANKS[pkBank]);
    new Image(g).tonamedmatrix(pkMatrix.name);
}

function pkFrame() {
    try {
        if (typeof pkTick === "function") pkTick();
        pkRender();
        outlet(0, "jit_matrix", pkMatrix.name);
    } catch (e) { pkLog("frame error: " + e + " line " + e.lineNumber); }
}

// Preview in standalone Max (push_preview.py): draw one bank with these touches and save a PNG.
function pkShot(bankName, touched, path) {
    pkBank = PK_BANKS.indexOf(bankName); pkTouched = touched || [0, 0, 0, 0, 0, 0, 0, 0];
    if (typeof pkTick === "function") pkTick();
    pkRender();
    pkMatrix.exportimage(path, "png");
}

// ─── helpers ─────────────────────────────────────────────────────────────────
function pkVal(varname) { var b = pkPatcher && pkPatcher.getnamed(varname); return b ? Number(b.getvalueof()) : 0; }
function pkAny(a, b) { for (var i = a; i <= b; i++) if (pkTouched[i]) return true; return false; }
function pkDim(c, k) { return [c[0], c[1], c[2], c[3] * k]; }
function pkMix(a, b, k) { return [a[0] + (b[0] - a[0]) * k, a[1] + (b[1] - a[1]) * k, a[2] + (b[2] - a[2]) * k, 1]; }
function pkFill(g, c, x, y, w, h, r) {
    g.set_source_rgba(c);
    if (r) g.rectangle_rounded(x, y, w, h, r, r); else g.rectangle(x, y, w, h);
    g.fill();
}
function pkStroke(g, c, x, y, w, h, r, lw) {
    g.set_source_rgba(c); g.set_line_width(lw || 1);
    if (r) g.rectangle_rounded(x, y, w, h, r, r); else g.rectangle(x, y, w, h);
    g.stroke();
}
function pkText(g, s, x, y, size, c, font, align) {   // align: 0 left, 0.5 centre, 1 right
    g.select_font_face(font || PK_FONT); g.set_font_size(size); g.set_source_rgba(c);
    g.move_to(x - (align ? g.text_measure(String(s))[0] * align : 0), y); g.show_text(String(s));
}
