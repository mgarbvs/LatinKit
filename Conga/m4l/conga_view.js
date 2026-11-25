// conga_view.js -- the Conga's display, in the style of Ableton's Drum Synth devices: the three drums in orange line art, tumba | conga | quinto
// as on the keyboard (the same order as the pitch), and a flash over a drum's third (the whole third fills orange, then fades) with the
// name of the stroke it was hit with. Display only.
// in: hit <drum 0 quinto|1 conga|2 tumba> <stroke 0..5> <velocity 0..1> | <theme colour name> r g b a (live.colors)
mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;
inlets = 1;
outlets = 0;

var STROKE = ["open", "slap", "mute", "bass", "heel", "toe"];
var THEME = { lcd_control_fg: [1, 0.678, 0.337, 1], display_scale_text: [0.682, 0.686, 0.714, 1] };
var flash = [0, 0, 0], label = ["", "", ""];             // per engine drum: flash alpha, last stroke name
var SIZE = [15, 17, 19];                                  // head radius per drum: quinto smallest, tumba widest (pt)
var anim = new Task(fade, this);
anim.interval = 33;

function hit(d, s, vel) {
    flash[d] = 0.12 + 0.1 * vel;   // peak alpha
    label[d] = STROKE[s];
    if (!anim.running) anim.repeat();
    mgraphics.redraw();
}

function fade() {
    var live = 0;
    for (var d = 0; d < 3; d++) { flash[d] *= 0.8; if (flash[d] < 0.01) flash[d] = 0; else live = 1; }
    if (!live) anim.cancel();
    mgraphics.redraw();
}

function anything() {   // live.colors: <name> r g b a
    var a = arrayfromargs(arguments);
    if (a.length === 4 && THEME[messagename]) { THEME[messagename] = a; mgraphics.redraw(); }
}

function rgba(c, k) { mgraphics.set_source_rgba(c[0], c[1], c[2], c[3] * (k === undefined ? 1 : k)); }

function drawDrum(cx, top, r, h) {
    // a conga: the head's ellipse on top, a barrel that swells a little and narrows to the foot, a base ring, two tension rods
    var ry = r * 0.28, bot = top + h, foot = r * 0.6;
    mgraphics.ellipse(cx - r, top - ry, 2 * r, 2 * ry);
    mgraphics.stroke();
    mgraphics.ellipse(cx - r + 2.5, top - ry + 1, 2 * r - 5, 2 * ry - 2);   // the hoop
    mgraphics.stroke();
    mgraphics.move_to(cx - r, top);
    mgraphics.curve_to(cx - r * 1.12, top + h * 0.35, cx - r * 0.95, top + h * 0.75, cx - foot, bot);
    mgraphics.stroke();
    mgraphics.move_to(cx + r, top);
    mgraphics.curve_to(cx + r * 1.12, top + h * 0.35, cx + r * 0.95, top + h * 0.75, cx + foot, bot);
    mgraphics.stroke();
    mgraphics.move_to(cx - foot, bot);
    mgraphics.curve_to(cx - foot, bot + ry * 1.2, cx + foot, bot + ry * 1.2, cx + foot, bot);
    mgraphics.stroke();
    for (var k = -1; k <= 1; k += 2) {
        mgraphics.move_to(cx + k * r * 0.55, top + ry * 0.85);
        mgraphics.line_to(cx + k * r * 0.62, top + h * 0.45);
        mgraphics.stroke();
    }
}

function paint() {
    var w = box.rect[2] - box.rect[0], h = box.rect[3] - box.rect[1], o = THEME.lcd_control_fg, colw = w / 3;
    mgraphics.select_font_face("Ableton Sans Medium");
    mgraphics.set_font_size(9.5);
    for (var c = 0; c < 3; c++) {
        var d = 2 - c;                                    // column 0 is the tumba (engine drum 2)
        if (flash[d] > 0) {
            rgba(o, flash[d]);
            mgraphics.rectangle_rounded(c * colw + 1, 0, colw - 2, h, 5, 5);
            mgraphics.fill();
            rgba(THEME.display_scale_text, Math.min(1, flash[d] * 8));
            mgraphics.move_to(c * colw + 5, 10);
            mgraphics.show_text(label[d]);
        }
        rgba(o);
        mgraphics.set_line_width(1.5);
        drawDrum(c * colw + colw / 2, 11 + (2 - d) * 0 + (d === 0 ? 3 : d === 1 ? 1 : 0), SIZE[d], 31 + (d === 0 ? -3 : d === 2 ? 3 : 0));
    }
}
