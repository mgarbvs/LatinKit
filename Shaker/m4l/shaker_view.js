// shaker_view.js -- the Shaker's display, in the style of Ableton's Drum Synth devices (and Cuica): a line drawing of the current Type (orange,
// theme colour), the last note's name in grey over the Type column, a flash (the display fills orange, then fades) and a jerk of the drawing
// along the stroke's direction with every note-on. Display only.
// in: hit <note> <velocity 0..1> <dir 0|1> | type <0..4> | <theme colour name> r g b a
mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;
inlets = 1;
outlets = 0;

var NAMES = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
var THEME = { lcd_control_fg: [1, 0.678, 0.337, 1], display_scale_text: [0.682, 0.686, 0.714, 1] };
var name = "C3", type = 0, flash = jsarguments.length > 1 ? Number(jsarguments[1]) : 0;   // an argument holds a flash (for screenshots)
var shift = 0, sign = 1, anim = new Task(fade, this);
anim.interval = 33;

function hit(n, vel, d) {
    name = NAMES[n % 12] + (Math.floor(n / 12) - 2);
    flash = 0.12 + 0.1 * vel;   // peak alpha
    sign = d ? -1 : 1;
    shift = 1;
    if (!anim.running) anim.repeat();
    mgraphics.redraw();
}

function fade() {
    flash *= 0.78;   // ~170 ms to fade out at 30 fps
    shift *= 0.7;
    if (flash < 0.01) { flash = 0; shift = 0; anim.cancel(); }
    mgraphics.redraw();
}

function setType(v) { type = Math.max(0, Math.min(4, Math.round(v))); mgraphics.redraw(); }
function msg_int(v) { setType(v); }

function anything() {   // type <n>, or live.colors: <name> r g b a
    var a = arrayfromargs(arguments);
    if (messagename === "type") setType(a[0]);
    else if (a.length === 4 && THEME[messagename]) { THEME[messagename] = a; mgraphics.redraw(); }
}

function rgba(c, k) { mgraphics.set_source_rgba(c[0], c[1], c[2], c[3] * (k === undefined ? 1 : k)); }

function dots(pts, r) { for (var i = 0; i < pts.length; i++) { mgraphics.ellipse(pts[i][0] - r, pts[i][1] - r, 2 * r, 2 * r); mgraphics.fill(); } }

// each shaker is drawn about the origin, ~34 px tall, tilted a little
var ART = [
    function maraca() {   // the gourd head and its handle
        mgraphics.ellipse(-12, -26, 24, 24); mgraphics.stroke();
        mgraphics.move_to(0, -2); mgraphics.line_to(0, 12); mgraphics.stroke();
        mgraphics.rectangle_rounded(-3, 10, 6, 14, 3, 3); mgraphics.stroke();
        dots([[-4, -20], [3, -14], [-2, -9], [5, -22]], 1.2);
    },
    function cabasa() {   // a steel drum wrapped in a bead chain, a handle at the end
        mgraphics.rectangle_rounded(-16, -12, 32, 22, 6, 6); mgraphics.stroke();
        mgraphics.rectangle_rounded(16, -5, 14, 8, 3, 3); mgraphics.stroke();
        for (var r = 0; r < 3; r++) { var p = []; for (var c = 0; c < 7; c++) p.push([-12 + c * 4.2, -7 + r * 7]); dots(p, 1); }
    },
    function shekere() {   // a gourd in a net of beads, a short neck
        mgraphics.ellipse(-14, -22, 28, 30); mgraphics.stroke();
        mgraphics.rectangle_rounded(-4, -32, 8, 11, 3, 3); mgraphics.stroke();
        var p = []; for (var r = 0; r < 3; r++) for (var c = 0; c < 4; c++) p.push([-9 + c * 6 + (r % 2) * 3, -15 + r * 7]);
        dots(p, 1.2);
    },
    function ganza() {   // a metal tube, its hand grip at the end
        mgraphics.rectangle_rounded(-22, -9, 44, 18, 9, 9); mgraphics.stroke();
        mgraphics.move_to(-8, -9); mgraphics.line_to(-8, 9); mgraphics.move_to(8, -9); mgraphics.line_to(8, 9); mgraphics.stroke();
        dots([[-15, 0], [0, -3], [0, 3], [15, 0]], 1);
    },
    function egg() {   // the egg, and a few beads
        mgraphics.ellipse(-12, -17, 24, 32); mgraphics.stroke();
        mgraphics.move_to(-9, -2); mgraphics.line_to(9, -2); mgraphics.stroke();
        dots([[-3, 6], [3, 9], [0, 4]], 1.2);
    }
];

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
    mgraphics.move_to(24 - mgraphics.text_measure(name)[0] / 2, h / 2 + 4);   // centred over the Type column (x 8..60 on the device, 8 in from the display)
    mgraphics.show_text(name);
    rgba(o);
    mgraphics.set_line_width(1.6);
    mgraphics.save();
    mgraphics.translate(w * 0.62 + sign * shift * 7, h / 2 + 4);
    mgraphics.rotate(-0.35 + sign * shift * 0.12);
    ART[type]();
    mgraphics.restore();
}
