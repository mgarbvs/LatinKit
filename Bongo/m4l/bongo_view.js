// bongo_view.js -- Bongo's display, in the style of Ableton's Drum Synth devices (and Shaker / Conga Voice / Timbales): the pair of bongos in orange line art
// (the drum the Drum menu selects in orange, the other dim), the hand where the current Stroke is played, the stroke's name in grey, and a flash (the display
// fills orange, then fades; the hand jumps and a spark marks the contact) on every hit. Display only.
// in: drum <0 macho|1 hembra> | stroke <0..6> | hit <velocity 0..1> | <theme colour name> r g b a (live.colors)
mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;
inlets = 1;
outlets = 0;

var STROKE = ["open", "open 3F", "slap", "heel", "tip", "rim", "flam"];
var THEME = { lcd_control_fg: [1, 0.678, 0.337, 1], display_scale_text: [0.682, 0.686, 0.714, 1] };
var DRUM = [{ r: 12, h: 15 }, { r: 14.5, h: 17 }];      // head radius, shell height (pt): the macho is the smaller drum
var drum = 0, stroke = 0, flash = jsarguments.length > 1 ? Number(jsarguments[1]) : 0;   // an argument holds a flash (for screenshots)
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
    if (messagename === "drum") drum = Math.max(0, Math.min(1, Math.round(a[0])));
    else if (messagename === "stroke") stroke = Math.max(0, Math.min(6, Math.round(a[0])));
    else if (a.length === 4 && THEME[messagename]) THEME[messagename] = a;
    else return;
    mgraphics.redraw();
}

function rgba(c, k) { mgraphics.set_source_rgba(c[0], c[1], c[2], c[3] * (k === undefined ? 1 : k)); }

function line(x0, y0, x1, y1) { mgraphics.move_to(x0, y0); mgraphics.line_to(x1, y1); mgraphics.stroke(); }

function drawDrum(cx, top, r, h) {
    // a bongo: the head's ellipse with its hoop, a slightly tapering shell, a bottom edge
    var ry = r * 0.3, bot = top + h;
    mgraphics.ellipse(cx - r, top - ry, 2 * r, 2 * ry);
    mgraphics.stroke();
    mgraphics.ellipse(cx - r + 2, top - ry + 1, 2 * r - 4, 2 * ry - 2);
    mgraphics.stroke();
    line(cx - r, top, cx - r * 0.82, bot);
    line(cx + r, top, cx + r * 0.82, bot);
    mgraphics.move_to(cx - r * 0.82, bot);
    mgraphics.curve_to(cx - r * 0.82, bot + ry * 1.2, cx + r * 0.82, bot + ry * 1.2, cx + r * 0.82, bot);
    mgraphics.stroke();
}

// where the hand touches the selected drum (head centre cx, top), the direction the hand comes from, and how many fingers
function contact(cx, top, r, h) {
    var ry = r * 0.3;
    switch (stroke) {
    case 0: return { x: cx + r * 0.35, y: top + ry * 0.1, dx: 10, dy: -16, n: 1 };            // open: one finger, near the rim
    case 1: return { x: cx + r * 0.1, y: top, dx: 10, dy: -16, n: 3 };                         // open 3F: three fingers
    case 2: return { x: cx + r * 0.78, y: top + ry * 0.2, dx: 9, dy: -15, n: 3 };              // slap: the fingers snap at the edge
    case 3: return { x: cx - r * 0.2, y: top + ry * 0.1, dx: 11, dy: -9, n: 0 };               // heel: the heel of the hand, flat
    case 4: return { x: cx, y: top - ry * 0.1, dx: 5, dy: -17, n: 1 };                          // tip: a fingertip at the centre
    case 5: return { x: cx + r * 0.95, y: top + ry * 0.05, dx: 8, dy: -16, n: 1 };              // rim: the finger on the hoop
    default: return { x: cx + r * 0.35, y: top + ry * 0.1, dx: 10, dy: -16, n: 1 };            // flam: two taps
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
    rgba(THEME.display_scale_text, Math.min(1, 0.6 + flash * 4));
    mgraphics.move_to(28 - mgraphics.text_measure(STROKE[stroke])[0] / 2, h / 2 + 4);   // centred over the Drum column
    mgraphics.show_text(STROKE[stroke]);
    var cx = [w * 0.46, w * 0.77], top = [h / 2 - 3, h / 2 - 4];
    mgraphics.set_line_width(1.5);
    for (var k = 0; k < 2; k++) {   // the selected drum in full colour, the other dim
        rgba(o, drum === k ? 1 : 0.3);
        drawDrum(cx[k], top[k], DRUM[k].r, DRUM[k].h);
    }
    mgraphics.set_line_width(1.5);
    rgba(o, 0.3);
    line(cx[0] + DRUM[0].r * 0.82, top[0] + DRUM[0].h * 0.55, cx[1] - DRUM[1].r * 0.82, top[1] + DRUM[1].h * 0.55);   // the bridge between the shells
    rgba(o);
    var c = contact(cx[drum], top[drum], DRUM[drum].r, DRUM[drum].h), lift = flash > 0 ? flash * 14 : 0;   // the hand is lifted off between hits
    var tx = c.x, ty = c.y;
    mgraphics.set_line_width(2);
    if (c.n === 0) {                       // heel: a short flat stroke across the head
        line(tx - 4, ty - lift * 0.3, tx + 6, ty - 2 - lift * 0.3);
        line(tx + 6, ty - 2 - lift * 0.3, tx + c.dx + 4 + lift * 0.4, ty + c.dy - lift);
    } else {
        for (var f = 0; f < c.n; f++) {    // one finger, or three side by side
            var ox = (f - (c.n - 1) / 2) * 3.2;
            line(tx + ox, ty - lift * 0.3, tx + ox + c.dx * 0.8 + lift * 0.5, ty + c.dy - lift);
        }
    }
    if (flash > 0) {     // the spark at the contact
        rgba(o, Math.min(1, flash * 6));
        mgraphics.set_line_width(1);
        for (var j = 0; j < 3; j++) {
            var a = -0.9 + j * 0.9;
            line(tx + Math.cos(a) * 2, ty + Math.sin(a) * 2, tx + Math.cos(a) * 6, ty + Math.sin(a) * 6);
        }
    }
}
