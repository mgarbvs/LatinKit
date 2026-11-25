// repinique_view.js -- Repinique's display, in the style of Ableton's Drum Synth devices (and Shaker / Conga Voice / Bongo): the repinique in orange line art (a small metal drum
// with its hoop and lugs), the stick or hand where the current Stroke is played, the stroke's name in grey, and a flash (the display fills orange,
// then fades; the stick jumps and a spark marks the contact) on every hit. Display only.
// in: stroke <0..5> | hit <velocity 0..1> | <theme colour name> r g b a (live.colors)
mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;
inlets = 1;
outlets = 0;

var STROKE = ["open", "rimshot", "rim", "hand", "mute", "flam"];
var THEME = { lcd_control_fg: [1, 0.678, 0.337, 1], display_scale_text: [0.682, 0.686, 0.714, 1] };
var stroke = 0, flash = jsarguments.length > 1 ? Number(jsarguments[1]) : 0;   // an argument holds a flash (for screenshots)
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

function anything() {   // stroke <n>, or live.colors: <name> r g b a
    var a = arrayfromargs(arguments);
    if (messagename === "stroke") stroke = Math.max(0, Math.min(5, Math.round(a[0])));
    else if (a.length === 4 && THEME[messagename]) THEME[messagename] = a;
    else return;
    mgraphics.redraw();
}

function rgba(c, k) { mgraphics.set_source_rgba(c[0], c[1], c[2], c[3] * (k === undefined ? 1 : k)); }

function line(x0, y0, x1, y1) { mgraphics.move_to(x0, y0); mgraphics.line_to(x1, y1); mgraphics.stroke(); }

function drawRepinique(cx, top, r, h) {
    // a repinique: a small, squat metal drum: the head's ellipse with its hoop, a straight shell with a bead, tension lugs, a bottom edge
    var ry = r * 0.3, bot = top + h;
    mgraphics.ellipse(cx - r, top - ry, 2 * r, 2 * ry);
    mgraphics.stroke();
    mgraphics.ellipse(cx - r + 2, top - ry + 1, 2 * r - 4, 2 * ry - 2);
    mgraphics.stroke();
    line(cx - r, top, cx - r, bot);
    line(cx + r, top, cx + r, bot);
    mgraphics.move_to(cx - r, bot);
    mgraphics.curve_to(cx - r, bot + ry * 1.3, cx + r, bot + ry * 1.3, cx + r, bot);
    mgraphics.stroke();
    for (var k = -2; k <= 2; k++) line(cx + k * r * 0.4, top + ry * 0.95, cx + k * r * 0.4, top + ry * 0.95 + 4);   // the lugs under the hoop
    mgraphics.move_to(cx - r, top + h * 0.5);                  // the shell's bead
    mgraphics.curve_to(cx - r, top + h * 0.5 + ry * 1.3, cx + r, top + h * 0.5 + ry * 1.3, cx + r, top + h * 0.5);
    mgraphics.stroke();
}

function stick(x, y, lift) {       // the one stick, its tip at x, y
    line(x, y - lift, x + 14 + lift * 0.4, y - 18 - lift);
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
    mgraphics.move_to(30 - mgraphics.text_measure(STROKE[stroke])[0] / 2, h / 2 + 4);   // centred over the Stroke column
    mgraphics.show_text(STROKE[stroke]);
    var cx = w * 0.64, r = 17, top = 13, dh = 22;
    mgraphics.set_line_width(1.5);
    rgba(o);
    drawRepinique(cx, top, r, dh);
    var lift = flash > 0 ? flash * 14 : 0;       // the stick / hand is lifted off between hits
    var tx, ty;
    mgraphics.set_line_width(2);
    if (stroke === 0 || stroke === 5) {   // open (and flam: a second stick mark beside it): the stick in the middle of the head
        tx = cx; ty = top - 1;
        stick(tx, ty, lift);
        if (stroke === 5) { stick(tx - 7, ty + 1, lift * 0.5); }
    } else if (stroke === 1) {   // rimshot: the stick across the head and the rim together
        tx = cx + r * 0.8; ty = top + 0.5;
        line(tx - 15, ty - 9 - lift, tx + 4, ty - 1 - lift * 0.3);
        line(tx + 4, ty - 1 - lift * 0.3, tx + 10, ty + 1 - lift * 0.3);
    } else if (stroke === 2) {   // rim: the stick on the hoop only
        tx = cx + r * 0.95; ty = top + 0.5;
        line(tx - 12, ty - 14 - lift, tx + 1, ty - 1 - lift * 0.3);
    } else if (stroke === 3) {   // hand: the open palm and fingers
        tx = cx - 3; ty = top - 1;
        line(tx - 9, ty - 2 - lift * 0.4, tx + 9, ty - 4 - lift * 0.4);
        line(tx + 9, ty - 4 - lift * 0.4, tx + 17 + lift * 0.4, ty - 11 - lift);
    } else {                     // mute: the flat hand pressed on the head, fingers spread
        tx = cx; ty = top - 1;
        line(tx - 11, ty - 1, tx + 11, ty - 1);
        line(tx - 11, ty - 1, tx - 15, ty - 8 - lift * 0.5);
        line(tx + 11, ty - 1, tx + 15, ty - 8 - lift * 0.5);
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
