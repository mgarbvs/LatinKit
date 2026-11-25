// cuica_view.js -- the Cuica's display, in the style of Ableton's Drum Synth devices: a line drawing of the drum (orange, theme colour),
// the last note's name in grey over the Tune column, and a flash (the whole display fills orange, then fades) with every note-on. Display only.
// in: hit <note> <velocity 0..1> | page <0|1> (1: the MPE settings sit on top; only the flash is drawn) | <theme colour name> r g b a
mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;
inlets = 1;
outlets = 0;

var NAMES = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
var THEME = { lcd_control_fg: [1, 0.678, 0.337, 1], display_scale_text: [0.682, 0.686, 0.714, 1] };
var name = "C3", flash = jsarguments.length > 1 ? Number(jsarguments[1]) : 0;   // an argument holds a flash (for screenshots)
var pg = 0, anim = new Task(fade, this);
anim.interval = 33;

function hit(n, vel) {
    name = NAMES[n % 12] + (Math.floor(n / 12) - 2);
    flash = 0.12 + 0.1 * vel;   // peak alpha
    if (!anim.running) anim.repeat();
    mgraphics.redraw();
}

function page(v) { pg = v ? 1 : 0; mgraphics.redraw(); }

function fade() {
    flash *= 0.78;   // ~170 ms to fade out at 30 fps
    if (flash < 0.01) { flash = 0; anim.cancel(); }
    mgraphics.redraw();
}

function anything() {   // live.colors: <name> r g b a
    var a = arrayfromargs(arguments);
    if (a.length === 4 && THEME[messagename]) { THEME[messagename] = a; mgraphics.redraw(); }
}

function rgba(c, k) { mgraphics.set_source_rgba(c[0], c[1], c[2], c[3] * (k === undefined ? 1 : k)); }

function paint() {
    var w = box.rect[2] - box.rect[0], h = box.rect[3] - box.rect[1], o = THEME.lcd_control_fg;
    if (flash > 0) {
        rgba(o, flash);
        mgraphics.rectangle_rounded(0, 0, w, h, 5, 5);
        mgraphics.fill();
    }
    if (pg) return;
    mgraphics.select_font_face("Ableton Sans Medium");
    mgraphics.set_font_size(11);
    rgba(THEME.display_scale_text);
    mgraphics.move_to(24 - mgraphics.text_measure(name)[0] / 2, h / 2 + 4);   // centred over the Tune column (x 8..56 on the device, 8 in from the display)
    mgraphics.show_text(name);

    // the drum in three-quarter view like DS Kick's: the open end towards us (lower left), the head at the back, the rod tied to
    // the head's centre running out of the opening to the cloth, tension rods along the shell
    var D = 40, a = 6.5, b = 14, wi = 1.6, th = -0.3, c = Math.cos(th), s = Math.sin(th);
    var ey = Math.sqrt(a * a * s * s + b * b * c * c);       // the rims' half-height once rotated: centre the drum on the display
    var top = Math.min(-ey, D * s - ey), bot = Math.max(ey, D * s + ey);
    rgba(o);
    mgraphics.set_line_width(wi);
    mgraphics.save();
    mgraphics.translate(w / 2 - D * c / 2 + 8, h / 2 - (top + bot) / 2);
    mgraphics.rotate(th);
    mgraphics.ellipse(D - a, -b, 2 * a, 2 * b);              // the head
    mgraphics.stroke();
    mgraphics.move_to(0, -b); mgraphics.line_to(D, -b);     // the shell
    mgraphics.move_to(0, b); mgraphics.line_to(D, b);
    mgraphics.stroke();
    mgraphics.ellipse(-a, -b, 2 * a, 2 * b);                 // the open rim, doubled
    mgraphics.stroke();
    mgraphics.set_line_width(1);
    mgraphics.ellipse(-a + 2.5, -b + 2.5, 2 * a - 5, 2 * b - 5);
    mgraphics.stroke();
    for (var k = -1; k <= 1; k += 2) {                       // tension rods
        mgraphics.move_to(3, k * (b - 4)); mgraphics.line_to(D + 3, k * (b - 4));
        mgraphics.stroke();
    }
    mgraphics.set_line_width(wi);
    mgraphics.ellipse(D - 2.2, -2.2, 4.4, 4.4);              // the knot on the head
    mgraphics.fill();
    mgraphics.move_to(D, 0); mgraphics.line_to(-20, 4);      // the rod
    mgraphics.stroke();
    mgraphics.rectangle_rounded(-21, -2, 10, 11, 4, 4);      // the cloth between finger and thumb
    mgraphics.stroke();
    mgraphics.restore();
}
