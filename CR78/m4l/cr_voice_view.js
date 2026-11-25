// cr_voice_view.js -- the display of the CR78 single-voice devices, in the style of Ableton's Drum Synth devices (and Shaker): a line drawing of the
// voice (orange, theme colour), the last note's name in grey over the first column, and a flash (the display fills orange, then fades) and a small
// pulse of the drawing with every note-on. Display only. One js for every device: the first argument names the voice.
// args: <voice> [flash]   (voice: kick snare rim clave bongo conga hat cymbal maracas metal cowbell tamb guiro; a flash holds, for screenshots)
// in: hit <note> <velocity 0..1> | variant <0|1> (bongo: high / low, guiro: short / long) | <theme colour name> r g b a (live.colors)
mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;
inlets = 1;
outlets = 0;

var NAMES = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
var THEME = { lcd_control_fg: [1, 0.678, 0.337, 1], display_scale_text: [0.682, 0.686, 0.714, 1] };
var voice = jsarguments.length > 1 ? String(jsarguments[1]) : "kick";
var name = "C3", variant = 0, flash = jsarguments.length > 2 ? Number(jsarguments[2]) : 0;
var shift = 0, anim = new Task(fade, this);
anim.interval = 33;

function hit(n, vel) {
    name = NAMES[n % 12] + (Math.floor(n / 12) - 2);
    flash = 0.12 + 0.1 * vel;   // peak alpha
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

function anything() {   // variant <n>, or live.colors: <name> r g b a
    var a = arrayfromargs(arguments);
    if (messagename === "variant") variant = a[0] ? 1 : 0;
    else if (a.length === 4 && THEME[messagename]) THEME[messagename] = a;
    else return;
    mgraphics.redraw();
}

function rgba(c, k) { mgraphics.set_source_rgba(c[0], c[1], c[2], c[3] * (k === undefined ? 1 : k)); }
function line(x0, y0, x1, y1) { mgraphics.move_to(x0, y0); mgraphics.line_to(x1, y1); mgraphics.stroke(); }
function curve(x0, y0, a, b, c, d, x1, y1) { mgraphics.move_to(x0, y0); mgraphics.curve_to(a, b, c, d, x1, y1); mgraphics.stroke(); }
function oval(cx, cy, w, h) { mgraphics.ellipse(cx - w / 2, cy - h / 2, w, h); mgraphics.stroke(); }
function dots(pts, r) { for (var i = 0; i < pts.length; i++) { mgraphics.ellipse(pts[i][0] - r, pts[i][1] - r, 2 * r, 2 * r); mgraphics.fill(); } }
function stick(x0, y0, x1, y1) { line(x0, y0, x1, y1); dots([[x1, y1]], 1.8); }

function cone(cx, cy, w, h, len) {   // a small drum: the head's ellipse on top, a body tapering to the foot
    oval(cx, cy, w, h);
    line(cx - w / 2, cy, cx - w / 2 + 3, cy + len);
    line(cx + w / 2, cy, cx + w / 2 - 3, cy + len);
    curve(cx - w / 2 + 3, cy + len, cx - w / 2 + 3, cy + len + h * 0.8, cx + w / 2 - 3, cy + len + h * 0.8, cx + w / 2 - 3, cy + len);
}

function stand(x, y) {   // a cymbal stand: pole and tripod feet
    line(x, y, x, y + 20);
    line(x, y + 20, x - 9, y + 24); line(x, y + 20, x + 9, y + 24);
}

function maraca(x, a) {
    mgraphics.save(); mgraphics.translate(x, 2); mgraphics.rotate(a);
    oval(0, -13, 15, 15);
    line(0, -5, 0, 4);
    mgraphics.rectangle_rounded(-2.5, 3, 5, 11, 2.5, 2.5); mgraphics.stroke();
    dots([[-3, -15], [2, -11], [-1, -8]], 1);
    mgraphics.restore();
}

// each voice is drawn about the origin, ~40 px tall
var ART = {
    kick: function () {   // a bass drum seen from the front: head, hoop, tension lugs
        oval(0, 0, 36, 36); oval(0, 0, 25, 25);
        for (var k = 0; k < 8; k++) { var t = k * Math.PI / 4; line(12.5 * Math.cos(t), 12.5 * Math.sin(t), 18 * Math.cos(t), 18 * Math.sin(t)); }
        dots([[0, 0]], 2);
    },
    snare: function () {   // a shallow drum, the stick above it
        oval(0, -6, 40, 12);
        line(-20, -6, -20, 10); line(20, -6, 20, 10);
        curve(-20, 10, -20, 17, 20, 17, 20, 10);
        curve(-20, 3, -20, 9, 20, 9, 20, 3);
        stick(-22, -22, -6, -9);
    },
    rim: function () {   // the head, and a stick laid across the rim: the crack
        oval(0, 4, 40, 14); oval(0, 4, 30, 9);
        line(-20, 4, -20, 14); line(20, 4, 20, 14);
        curve(-20, 14, -20, 20, 20, 20, 20, 14);
        stick(-22, -18, 8, -2);
        line(12, -8, 17, -12); line(14, -3, 20, -4); line(11, -13, 12, -19);
    },
    clave: function () {   // two sticks crossed
        mgraphics.save(); mgraphics.translate(0, 2); mgraphics.rotate(-0.55);
        mgraphics.rectangle_rounded(-19, -3.5, 38, 7, 3.5, 3.5); mgraphics.stroke(); mgraphics.restore();
        mgraphics.save(); mgraphics.translate(0, -2); mgraphics.rotate(0.55);
        mgraphics.rectangle_rounded(-19, -3.5, 38, 7, 3.5, 3.5); mgraphics.stroke(); mgraphics.restore();
    },
    bongo: function () {   // a pair: the small high one on the left, the big low one on the right; the played one is bold
        mgraphics.set_line_width(variant ? 1.0 : 1.9); rgba(THEME.lcd_control_fg, variant ? 0.5 : 1);
        cone(-12, -8, 18, 7, 16);
        mgraphics.set_line_width(variant ? 1.9 : 1.0); rgba(THEME.lcd_control_fg, variant ? 1 : 0.5);
        cone(11, -6, 22, 9, 18);
    },
    conga: function () {   // a tall barrel drum
        oval(0, -18, 24, 8);
        curve(-12, -18, -19, -4, -14, 8, -8, 19);
        curve(12, -18, 19, -4, 14, 8, 8, 19);
        curve(-8, 19, -6, 24, 6, 24, 8, 19);
        curve(-15, -8, -8, -5, 8, -5, 15, -8);
        line(-12, -14, -13, -9); line(12, -14, 13, -9);
    },
    hat: function () {   // two cymbals on a stand
        oval(0, -10, 44, 9); oval(0, -4, 44, 9); oval(0, -14, 9, 4);
        stand(0, 1);
    },
    cymbal: function () {   // a crash on a stand, tilted
        mgraphics.save(); mgraphics.rotate(-0.18);
        oval(0, -9, 46, 11); oval(0, -9, 30, 7); oval(0, -12, 9, 4);
        mgraphics.restore();
        stand(0, -4);
    },
    maracas: function () {
        maraca(-11, -0.4); maraca(11, 0.4);
    },
    metal: function () {   // a triangle and its beater: metal, ringing (the beat is three metallic oscillators)
        mgraphics.move_to(-6, 15); mgraphics.line_to(-19, 15); mgraphics.line_to(0, -19); mgraphics.line_to(19, 15); mgraphics.line_to(8, 15); mgraphics.stroke();
        stick(24, -14, 10, -2);
    },
    cowbell: function () {   // a cowbell from the front: the narrow top, the open mouth
        mgraphics.move_to(-12, -14); mgraphics.line_to(-20, 12); mgraphics.stroke();
        mgraphics.move_to(12, -14); mgraphics.line_to(20, 12); mgraphics.stroke();
        oval(0, -14, 24, 6); oval(0, 12, 40, 9);
        mgraphics.rectangle_rounded(-4, -22, 8, 8, 2, 2); mgraphics.stroke();
    },
    tamb: function () {   // a frame drum with jingle slots
        oval(0, 0, 40, 40); oval(0, 0, 31, 31);
        for (var k = 0; k < 4; k++) { var t = k * Math.PI / 2 + 0.4; oval(17.5 * Math.cos(t), 17.5 * Math.sin(t), 5, 5); }
        dots([[0, 0]], 1.5);
    },
    guiro: function () {   // a ridged gourd (short or long) and its scraper
        var h = variant ? 25 : 16, n = variant ? 9 : 5;
        mgraphics.rectangle_rounded(-h, -9, 2 * h, 18, 9, 9); mgraphics.stroke();
        for (var k = 0; k < n; k++) { var x = -h + 9 + k * (2 * h - 18) / (n - 1); line(x, -5, x, 5); }
        stick(-6, -20, 8, -8);
    }
};

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
    mgraphics.move_to(24 - mgraphics.text_measure(name)[0] / 2, h / 2 + 4);   // centred over the first column (x 8..60 on the device, 8 in from the display)
    mgraphics.show_text(name);
    rgba(o);
    mgraphics.set_line_width(1.6);
    mgraphics.save();
    mgraphics.translate(w * 0.62, h / 2 + 3);
    mgraphics.scale(1 + 0.1 * shift, 1 + 0.1 * shift);
    if (ART[voice]) ART[voice]();
    mgraphics.restore();
}
