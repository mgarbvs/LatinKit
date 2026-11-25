// guiro_view.js -- the Guiro's display, in the style of Ableton's Drum Synth devices (and Cuica, Shaker): a line drawing of the current Type (orange,
// theme colour) with a stick that scrapes across the ridges with every note (Up left to right, Down right to left, Long slowly, Top a tap),
// the ridges it crosses light up and fade, the last note's name in grey over the Type column, and a faint flash. Display only.
// in: hit <note> <velocity 0..1> <stroke 0..3> | type <0|1> | <theme colour name> r g b a
mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;
inlets = 1;
outlets = 0;

var NAMES = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
var THEME = { lcd_control_fg: [1, 0.678, 0.337, 1], display_scale_text: [0.682, 0.686, 0.714, 1] };
var name = "C3", type = 0, flash = jsarguments.length > 1 ? Number(jsarguments[1]) : 0;   // an argument holds a flash (for screenshots)
var RIDGES = [9, 15];                     // ridges drawn per Type
var DURS = [150, 200, 450, 120];          // how long the stick takes to cross, per stroke (ms): the real strokes are faster; this is for the eye
var stk = 0, t0 = 0, pos = 0.5, lit = [], anim = new Task(fade, this);
anim.interval = 33;
for (var i = 0; i < 15; i++) lit.push(0);

function hit(n, vel, k) {
    name = NAMES[n % 12] + (Math.floor(n / 12) - 2);
    flash = 0.1 + 0.08 * vel;
    stk = k;
    t0 = new Date().getTime();
    for (var i = 0; i < lit.length; i++) lit[i] = 0;
    if (!anim.running) anim.repeat();
    mgraphics.redraw();
}

function fade() {
    var u = Math.min(1, (new Date().getTime() - t0) / DURS[stk]);
    pos = stk === 0 ? u : stk === 1 ? 1 - u : stk === 2 ? u : 0.5;
    var nr = RIDGES[type];
    var k = Math.max(0, Math.min(nr - 1, Math.floor(pos * nr)));
    if (stk < 3 && u < 1) lit[k] = 1;
    if (stk === 3 && u < 1) lit[Math.floor(nr / 2)] = 1;
    var alive = u < 1;
    for (var i = 0; i < lit.length; i++) { lit[i] *= 0.82; if (lit[i] > 0.02) alive = true; }
    flash *= 0.8;
    if (flash < 0.01) flash = 0; else alive = true;
    if (!alive) anim.cancel();
    mgraphics.redraw();
}

function setType(v) { type = Math.max(0, Math.min(1, Math.round(v))); mgraphics.redraw(); }
function msg_int(v) { setType(v); }

function anything() {   // type <n>, or live.colors: <name> r g b a
    var a = arrayfromargs(arguments);
    if (messagename === "type") setType(a[0]);
    else if (a.length === 4 && THEME[messagename]) { THEME[messagename] = a; mgraphics.redraw(); }
}

function rgba(c, k) { mgraphics.set_source_rgba(c[0], c[1], c[2], c[3] * (k === undefined ? 1 : k)); }

// each instrument is drawn about the origin, 46 px wide, its ridged top edge at y = -8 and the ridges' x from -18 to 18
function ridges(nr, h) {
    var o = THEME.lcd_control_fg;
    for (var r = 0; r < nr; r++) {
        var x = -18 + 36 * (r + 0.5) / nr;
        rgba(o, 0.45 + 0.55 * lit[r]);
        mgraphics.set_line_width(1.2 + 1.4 * lit[r]);
        mgraphics.move_to(x, -8); mgraphics.line_to(x, -8 + h + 3 * lit[r]); mgraphics.stroke();
    }
}

function paint() {
    var w = box.rect[2] - box.rect[0], h = box.rect[3] - box.rect[1], o = THEME.lcd_control_fg;
    if (flash > 0) {
        rgba(o, flash);
        mgraphics.rectangle_rounded(0, 0, w, h, 5, 5);
        mgraphics.fill();
    }
    mgraphics.select_font_face("Ableton Sans Medium");
    mgraphics.set_font_size(11);
    rgba(THEME.display_scale_text);
    mgraphics.move_to(24 - mgraphics.text_measure(name)[0] / 2, h / 2 + 4);   // centred over the Type column
    mgraphics.show_text(name);
    mgraphics.save();
    mgraphics.translate(w * 0.62, h / 2 + 6);
    mgraphics.rotate(-0.12);
    rgba(o);
    mgraphics.set_line_width(1.6);
    if (type === 0) {   // a gourd: a long oval, its stem end at the right
        mgraphics.move_to(-22, 2); mgraphics.curve_to(-22, -10, -10, -8, 0, -8); mgraphics.curve_to(12, -8, 20, -10, 24, -6);
        mgraphics.curve_to(28, -3, 28, 4, 24, 6); mgraphics.curve_to(16, 12, -22, 14, -22, 2); mgraphics.stroke();
        ridges(RIDGES[0], 8);
    } else {   // a reco-reco: a metal box with three tensioned springs along it (the coils are the ridges), on a hand grip
        mgraphics.rectangle_rounded(-22, -8, 44, 16, 3, 3); mgraphics.stroke();
        mgraphics.move_to(-22, 8); mgraphics.line_to(-22, 14); mgraphics.move_to(22, 8); mgraphics.line_to(22, 14); mgraphics.stroke();
        rgba(o, 0.35); mgraphics.set_line_width(1);
        for (var sp = 0; sp < 3; sp++) { mgraphics.move_to(-20, -4 + 4 * sp); mgraphics.line_to(20, -4 + 4 * sp); }
        mgraphics.stroke();
        mgraphics.set_line_width(1.6);
        ridges(RIDGES[1], 15);
    }
    var sx = -18 + 36 * pos, lift = stk === 3 ? 6 * (1 - Math.abs(pos - 0.5) * 2) * Math.max(0, 1 - (new Date().getTime() - t0) / DURS[3]) : 0;
    rgba(THEME.display_scale_text);
    mgraphics.set_line_width(2);
    mgraphics.move_to(sx, -8 - lift); mgraphics.line_to(sx + 12, -24 - lift); mgraphics.stroke();   // the stick
    mgraphics.restore();
}
