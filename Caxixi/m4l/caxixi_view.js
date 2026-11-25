// caxixi_view.js -- the Caxixi's display, in the style of Ableton's Drum Synth devices (and Cuica): a line drawing of the current Stroke (orange,
// theme colour), the last note's name in grey over the Type column, a flash (the display fills orange, then fades) and a jerk of the drawing
// with every stroke (the phrase of the FX stroke flashes at each of its bursts). Display only.
// in: hit <note> <velocity 0..1> <stroke 0..2> | type <0..2> | <theme colour name> r g b a
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

function hit(n, vel, d) {   // d: the stroke; the jerk alternates left / right per hit, as a shaken basket does
    name = NAMES[n % 12] + (Math.floor(n / 12) - 2);
    flash = 0.12 + 0.1 * vel;   // peak alpha
    sign = -sign;
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

function setType(v) { type = Math.max(0, Math.min(2, Math.round(v))); mgraphics.redraw(); }
function msg_int(v) { setType(v); }

function anything() {   // type <n>, or live.colors: <name> r g b a
    var a = arrayfromargs(arguments);
    if (messagename === "type") setType(a[0]);
    else if (a.length === 4 && THEME[messagename]) { THEME[messagename] = a; mgraphics.redraw(); }
}

function rgba(c, k) { mgraphics.set_source_rgba(c[0], c[1], c[2], c[3] * (k === undefined ? 1 : k)); }

function dots(pts, r) { for (var i = 0; i < pts.length; i++) { mgraphics.ellipse(pts[i][0] - r, pts[i][1] - r, 2 * r, 2 * r); mgraphics.fill(); } }

// the caxixi is drawn about the origin, ~34 px tall, tilted a little: a woven basket (hatched) on a hard round bottom (the gourd or leather disc)
function basket() {
    mgraphics.move_to(-8, -28); mgraphics.line_to(-12, -4); mgraphics.move_to(8, -28); mgraphics.line_to(12, -4); mgraphics.stroke();
    mgraphics.ellipse(-8, -31, 16, 6); mgraphics.stroke();
    for (var r = 0; r < 4; r++) { var y = -23 + r * 5.5, w = 9 + r * 0.9; mgraphics.move_to(-w, y); mgraphics.line_to(w, y); } mgraphics.stroke();
    mgraphics.move_to(-12, -4); mgraphics.curve_to(-11, 6, 11, 6, 12, -4); mgraphics.stroke();   // the hard bottom
}
var ART = [
    function open() { basket(); dots([[-3, -17], [4, -12], [-5, -9], [2, -22]], 1.2); },   // seeds in the basket
    function hand() {   // the bottom struck on the palm: a flat palm under it and impact ticks
        basket(); mgraphics.move_to(-17, 10); mgraphics.line_to(17, 10); mgraphics.stroke();
        mgraphics.move_to(-15, 5); mgraphics.line_to(-19, 3); mgraphics.move_to(15, 5); mgraphics.line_to(19, 3); mgraphics.stroke();
    },
    function fx() {   // a shaken phrase: motion arcs either side
        basket(); mgraphics.move_to(-17, -20); mgraphics.curve_to(-21, -14, -21, -8, -17, -2);
        mgraphics.move_to(17, -20); mgraphics.curve_to(21, -14, 21, -8, 17, -2); mgraphics.stroke();
        dots([[-3, -16], [3, -11], [-1, -7]], 1.2);
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
    mgraphics.translate(w * 0.62 + sign * shift * 7, h / 2 + 7);
    mgraphics.rotate(-0.35 + sign * shift * 0.12);
    mgraphics.scale(0.85, 0.85);
    ART[type]();
    mgraphics.restore();
}
