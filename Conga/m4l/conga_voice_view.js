// conga_voice_view.js -- Conga Voice's display, in the style of Ableton's Drum Synth devices (and Shaker): one conga in orange line art, sized
// by the Drum menu, the current Stroke's name in grey beside it, and a flash (the display fills orange, then fades) with the name lit up on every hit.
// Display only.
// in: drum <0 quinto|1 conga|2 tumba> | stroke <0..5> | hit <velocity 0..1> | <theme colour name> r g b a (live.colors)
mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;
inlets = 1;
outlets = 0;

var STROKE = ["open", "slap", "mute", "bass", "heel", "toe"];
var THEME = { lcd_control_fg: [1, 0.678, 0.337, 1], display_scale_text: [0.682, 0.686, 0.714, 1] };
var SIZE = [[11, 24], [12.5, 27], [14, 30]];            // head radius, barrel height (pt): quinto smallest, tumba widest and tallest
var drum = 1, stroke = 0, flash = jsarguments.length > 1 ? Number(jsarguments[1]) : 0;   // an argument holds a flash (for screenshots)
var anim = new Task(fade, this);
anim.interval = 33;

function hit(vel) {
    flash = 0.12 + 0.1 * vel;   // peak alpha
    if (!anim.running) anim.repeat();
    mgraphics.redraw();
}

function fade() {
    flash *= 0.8;
    if (flash < 0.01) { flash = 0; anim.cancel(); }
    mgraphics.redraw();
}

function anything() {   // drum <n> | stroke <n>, or live.colors: <name> r g b a
    var a = arrayfromargs(arguments);
    if (messagename === "drum") drum = Math.max(0, Math.min(2, Math.round(a[0])));
    else if (messagename === "stroke") stroke = Math.max(0, Math.min(5, Math.round(a[0])));
    else if (a.length === 4 && THEME[messagename]) THEME[messagename] = a;
    else return;
    mgraphics.redraw();
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
    var w = box.rect[2] - box.rect[0], h = box.rect[3] - box.rect[1], o = THEME.lcd_control_fg, s = SIZE[drum];
    if (flash > 0) {
        rgba(o, flash);
        mgraphics.rectangle_rounded(0, 0, w, h, 5, 5);
        mgraphics.fill();
    }
    mgraphics.select_font_face("Ableton Sans Medium");
    mgraphics.set_font_size(11);
    rgba(THEME.display_scale_text, Math.min(1, 0.6 + flash * 4));
    mgraphics.move_to(28 - mgraphics.text_measure(STROKE[stroke])[0] / 2, h / 2 + 4);   // centred over the Drum column (x 8..80 on the device, 8 in from the display)
    mgraphics.show_text(STROKE[stroke]);
    rgba(o);
    mgraphics.set_line_width(1.6);
    drawDrum(w * 0.62, h / 2 - s[1] / 2 + 1, s[0], s[1]);
}
