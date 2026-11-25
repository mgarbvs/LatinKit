// timbales_view.js -- Timbales' display, in the style of Ableton's Drum Synth devices (and Shaker / Conga Voice): one timbal in orange line art
// (sized by the Drum menu), a stick that touches it where the current Stroke is played, the stroke's name in grey, and a flash (the display
// fills orange, then fades; the stick jumps and a spark marks the contact) on every hit. Display only.
// in: drum <0 high|1 low> | stroke <0..5> | hit <velocity 0..1> | <theme colour name> r g b a (live.colors)
mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;
inlets = 1;
outlets = 0;

var STROKE = ["open", "rimshot", "cáscara", "paila", "rim click", "muted"];
var THEME = { lcd_control_fg: [1, 0.678, 0.337, 1], display_scale_text: [0.682, 0.686, 0.714, 1] };
var SIZE = [[14, 15], [16.5, 15]];                      // head radius, shell height (pt): the high drum is the smaller (13 in vs 14 in)
var drum = 0, stroke = 2, flash = jsarguments.length > 1 ? Number(jsarguments[1]) : 0;   // an argument holds a flash (for screenshots)
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
    else if (messagename === "stroke") stroke = Math.max(0, Math.min(5, Math.round(a[0])));
    else if (a.length === 4 && THEME[messagename]) THEME[messagename] = a;
    else return;
    mgraphics.redraw();
}

function rgba(c, k) { mgraphics.set_source_rgba(c[0], c[1], c[2], c[3] * (k === undefined ? 1 : k)); }

function line(x0, y0, x1, y1) { mgraphics.move_to(x0, y0); mgraphics.line_to(x1, y1); mgraphics.stroke(); }

function drawDrum(cx, top, r, h) {
    // a timbal: the head's ellipse with its hoop, a straight shallow shell, a bottom edge, and a stand (two legs)
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
    line(cx - r * 0.5, bot + ry * 1.0, cx - r * 0.8, bot + h * 0.9);
    line(cx + r * 0.5, bot + ry * 1.0, cx + r * 0.8, bot + h * 0.9);
}

// where the stick touches, relative to the head's centre (cx, top) and the shell, and the direction it comes from
function contact(cx, top, r, h) {
    var ry = r * 0.3;
    switch (stroke) {
    case 0: return { x: cx - r * 0.25, y: top, dx: 12, dy: -17, across: 0 };                  // open: the head, off centre
    case 1: return { x: cx + r * 0.72, y: top + ry * 0.35, dx: 12, dy: -16, across: 0 };       // rimshot: head edge and rim together
    case 2: return { x: cx + r, y: top + h * 0.18, dx: 14, dy: -12, across: 0 };               // cascara: shell, near the top edge
    case 3: return { x: cx + r, y: top + h * 0.62, dx: 14, dy: -12, across: 0 };               // paila: shell, middle
    case 4: return { x: cx + r * 0.7, y: top - ry * 0.45, dx: 13, dy: -9, across: r * 1.5 };    // rim click: laid across the head, touching the rim
    default: return { x: cx, y: top - ry * 0.2, dx: 4, dy: -20, across: 0 };                   // muted: pressed into the head
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
    mgraphics.move_to(28 - mgraphics.text_measure(STROKE[stroke])[0] / 2, h / 2 + 4);   // centred over the Drum column
    mgraphics.show_text(STROKE[stroke]);
    rgba(o);
    mgraphics.set_line_width(1.5);
    var cx = w * 0.56, top = h / 2 - s[1] / 2 - 2;
    drawDrum(cx, top, s[0], s[1]);
    var c = contact(cx, top, s[0], s[1]), lift = flash > 0 ? flash * 14 : 0;     // the stick is lifted off the contact between hits
    var tx = c.x, ty = c.y;
    mgraphics.set_line_width(2);
    if (c.across) line(tx - c.across, ty + c.across * 0.12, tx + 5, ty - 1);               // rim click: the stick lies across the head
    line(tx + (c.across ? 5 : 0), ty - (c.across ? 1 : 0) - lift * 0.3, tx + c.dx + (c.across ? 5 : 0) + lift * 0.5, ty + c.dy - lift);
    if (flash > 0) {     // the spark at the contact
        rgba(o, Math.min(1, flash * 6));
        mgraphics.set_line_width(1);
        for (var k = 0; k < 3; k++) {
            var a = -0.9 + k * 0.9;
            line(tx + Math.cos(a) * 2, ty + Math.sin(a) * 2, tx + Math.cos(a) * 6, ty + Math.sin(a) * 6);
        }
    }
}
