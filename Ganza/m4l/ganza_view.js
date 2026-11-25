// ganza_view.js -- the Ganza's display, in the style of Ableton's Drum Synth devices (and Cuica): a line drawing of the current Type (orange,
// theme colour), the last note's name in grey over the Type column, a flash (the display fills orange, then fades) and a jerk of the drawing
// along the stroke's direction with every note-on. Display only.
// in: hit <note> <velocity 0..1> <dir 0|1> <acc 0|1> | type <0..1> | <theme colour name> r g b a
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

function hit(n, vel, d, a) {
    name = NAMES[n % 12] + (Math.floor(n / 12) - 2);
    flash = (0.12 + 0.1 * vel) * (a ? 1.6 : 1);   // peak alpha
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

function setType(v) { type = Math.max(0, Math.min(1, Math.round(v))); mgraphics.redraw(); }
function msg_int(v) { setType(v); }

function anything() {   // type <n>, or live.colors: <name> r g b a
    var a = arrayfromargs(arguments);
    if (messagename === "type") setType(a[0]);
    else if (a.length === 4 && THEME[messagename]) { THEME[messagename] = a; mgraphics.redraw(); }
}

function rgba(c, k) { mgraphics.set_source_rgba(c[0], c[1], c[2], c[3] * (k === undefined ? 1 : k)); }

function dots(pts, r) { for (var i = 0; i < pts.length; i++) { mgraphics.ellipse(pts[i][0] - r, pts[i][1] - r, 2 * r, 2 * r); mgraphics.fill(); } }

// each instrument is drawn about the origin, ~34 px tall, tilted a little
var ART = [
    function ganza() {   // a metal tube, two ribs, an end cap at each end, the beads inside (they slide to the end the stroke is heading to)
        mgraphics.rectangle_rounded(-24, -9, 48, 18, 4, 4); mgraphics.stroke();
        mgraphics.move_to(-18, -9); mgraphics.line_to(-18, 9); mgraphics.move_to(18, -9); mgraphics.line_to(18, 9); mgraphics.stroke();
        mgraphics.move_to(-24, 0); mgraphics.line_to(-30, 0); mgraphics.stroke();   // hand grip
        var e = sign * shift * 14;
        dots([[-9 + e * 0.3, 3], [-3 + e * 0.5, 5], [2 + e * 0.5, 3], [8 + e * 0.7, 5], [13 + e, 2], [4 + e * 0.6, -3]], 1.3);
        if (shift > 0.25) { mgraphics.move_to(sign * 29, -6); mgraphics.line_to(sign * 33, -9); mgraphics.move_to(sign * 29, 6); mgraphics.line_to(sign * 33, 9); mgraphics.stroke(); }   // the cap impact
    },
    function chocalho() {   // a frame with three rows of platinelas (jingle pairs) and a handle
        mgraphics.rectangle(-26, -16, 52, 32); mgraphics.stroke();
        mgraphics.move_to(26, 0); mgraphics.line_to(34, 0); mgraphics.stroke();
        for (var r = 0; r < 3; r++) {
            var y = -9 + r * 9;
            mgraphics.move_to(-26, y); mgraphics.line_to(26, y); mgraphics.stroke();
            for (var c = 0; c < 6; c++) { var x = -20 + c * 8 + sign * shift * 2 * (r - 1); mgraphics.ellipse(x - 2.6, y - 2.6 + shift * (c % 2 ? 1.5 : -1.5), 5.2, 5.2); mgraphics.stroke(); }
        }
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
