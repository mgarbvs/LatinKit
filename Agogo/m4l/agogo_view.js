// agogo_view.js -- Agogo's display, in the style of Ableton's Drum Synth devices (and Bongo / Shaker / Conga Voice / Timbales): the double bell in orange line art
// (the bell the Bell menu selects in orange, the other dim) on its U-shaped handle, the stick where a stroke lands, the stroke's name in grey, and a flash (the display
// fills orange, then fades; the stick jumps and a spark marks the contact) on every hit. Mute shows the other hand's palm holding the bell's mouth. Display only.
// in: bell <0 high|1 low> | stroke <0 open|1 mute> | hit <velocity 0..1> | <theme colour name> r g b a (live.colors)
mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;
inlets = 1;
outlets = 0;

var STROKE = ["open", "mute"];
var THEME = { lcd_control_fg: [1, 0.678, 0.337, 1], display_scale_text: [0.682, 0.686, 0.714, 1] };
var BELL = [{ r: 8, h: 21 }, { r: 11, h: 27 }];      // mouth radius, height (pt): the high bell is the small one
var bell = 0, stroke = 0, flash = jsarguments.length > 1 ? Number(jsarguments[1]) : 0;   // an argument holds a flash (for screenshots)
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

function anything() {   // bell <n> | stroke <n>, or live.colors: <name> r g b a
    var a = arrayfromargs(arguments);
    if (messagename === "bell") bell = Math.max(0, Math.min(1, Math.round(a[0])));
    else if (messagename === "stroke") stroke = Math.max(0, Math.min(1, Math.round(a[0])));
    else if (a.length === 4 && THEME[messagename]) THEME[messagename] = a;
    else return;
    mgraphics.redraw();
}

function rgba(c, k) { mgraphics.set_source_rgba(c[0], c[1], c[2], c[3] * (k === undefined ? 1 : k)); }

function line(x0, y0, x1, y1) { mgraphics.move_to(x0, y0); mgraphics.line_to(x1, y1); mgraphics.stroke(); }

// a bell: the narrow top (a small ellipse at the handle), a flaring cone, the mouth's ellipse at the bottom
function drawBell(cx, top, r, h) {
    var ry = r * 0.28, bot = top + h, rt = 2.2;
    mgraphics.ellipse(cx - rt, top - 1, 2 * rt, 2);
    mgraphics.stroke();
    line(cx - rt, top, cx - r, bot);
    line(cx + rt, top, cx + r, bot);
    mgraphics.ellipse(cx - r, bot - ry, 2 * r, 2 * ry);
    mgraphics.stroke();
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
    mgraphics.move_to(28 - mgraphics.text_measure(STROKE[stroke])[0] / 2, h / 2 + 4);   // centred over the Bell column
    mgraphics.show_text(STROKE[stroke]);
    var cx = [w * 0.5, w * 0.78], top = [h / 2 - 12, h / 2 - 18];
    var hy = h / 2 - 20;
    mgraphics.set_line_width(1.5);
    rgba(o, 0.3);                                            // the U-shaped handle joining the two bells at their tops
    mgraphics.move_to(cx[0], top[0] - 1);
    mgraphics.curve_to(cx[0], hy - 4, cx[1], hy - 4, cx[1], top[1] - 1);
    mgraphics.stroke();
    for (var k = 0; k < 2; k++) {                            // the selected bell in full colour, the other dim
        rgba(o, bell === k ? 1 : 0.3);
        drawBell(cx[k], top[k], BELL[k].r, BELL[k].h);
    }
    var r = BELL[bell].r, bot = top[bell] + BELL[bell].h, lift = flash > 0 ? flash * 14 : 0;
    rgba(o);
    mgraphics.set_line_width(2);
    var tx = cx[bell] + r * 0.9, ty = bot - BELL[bell].h * 0.45;     // the stick lands on the cone's right side
    line(tx + 3 + lift * 0.5, ty - 14 - lift, tx, ty);
    if (stroke === 1) {                                      // mute: the other hand's palm on the mouth
        mgraphics.set_line_width(2);
        rgba(o, 0.9);
        line(cx[bell] - r - 6, bot - 4, cx[bell] - r * 0.2, bot + 3);
        line(cx[bell] - r - 6, bot - 4, cx[bell] - r - 6, bot - 14);
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
