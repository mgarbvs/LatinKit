// pandeiro_view.js -- Pandeiro's display, in the style of Ableton's Drum Synth devices (and Bongo / Shaker): the instrument in orange line art (a pandeiro with its
// jingles, or a tamborim), the hand or stick where the stroke the instrument actually plays is struck, that stroke's name in grey, and a flash (the display fills
// orange, then fades; the hand jumps, a spark marks the contact, the jingles jitter) on every hit. Display only.
// in: inst <0 pandeiro|1 tamborim> | stroke <0..7 the menu> | hit <velocity 0..1> | <theme colour name> r g b a (live.colors)
mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;
inlets = 1;
outlets = 0;

// the stroke each menu entry plays on each instrument (scripts/pandeiro_engine.py MAP; tests/test_strokes.py checks this line against it)
var EFF = [["Thumb", "Finger", "Slap", "Rim", "Shake", "Roll", "Thumb", "Finger"], ["Open", "Finger", "Open", "Open", "Finger", "Roll", "Open", "Mute"]];   // MAP
var THEME = { lcd_control_fg: [1, 0.678, 0.337, 1], display_scale_text: [0.682, 0.686, 0.714, 1] };
var inst = 0, stroke = 0, flash = jsarguments.length > 1 ? Number(jsarguments[1]) : 0, jit = 0;   // an argument holds a flash (for screenshots)
var anim = new Task(fade, this);
anim.interval = 33;

function hit(vel) {
    flash = 0.12 + 0.1 * vel;   // peak alpha
    jit = 1;
    if (!anim.running) anim.repeat();
    mgraphics.redraw();
}

function fade() {
    flash *= 0.8;
    jit = -jit * 0.7;
    if (flash < 0.01) { flash = 0; jit = 0; anim.cancel(); }
    mgraphics.redraw();
}

function anything() {   // inst <n> | stroke <n>, or live.colors: <name> r g b a
    var a = arrayfromargs(arguments);
    if (messagename === "inst") inst = Math.max(0, Math.min(1, Math.round(a[0])));
    else if (messagename === "stroke") stroke = Math.max(0, Math.min(7, Math.round(a[0])));
    else if (a.length === 4 && THEME[messagename]) THEME[messagename] = a;
    else return;
    mgraphics.redraw();
}

function rgba(c, k) { mgraphics.set_source_rgba(c[0], c[1], c[2], c[3] * (k === undefined ? 1 : k)); }
function line(x0, y0, x1, y1) { mgraphics.move_to(x0, y0); mgraphics.line_to(x1, y1); mgraphics.stroke(); }

function drawHead(cx, cy, r, depth) {
    // a drum seen from above and in front: the head's ellipse with its hoop, the shell below it
    var ry = r * 0.38;
    mgraphics.ellipse(cx - r, cy - ry, 2 * r, 2 * ry);
    mgraphics.stroke();
    mgraphics.ellipse(cx - r + 2, cy - ry + 1, 2 * r - 4, 2 * ry - 2);
    mgraphics.stroke();
    line(cx - r, cy, cx - r, cy + depth);
    line(cx + r, cy, cx + r, cy + depth);
    mgraphics.move_to(cx - r, cy + depth);
    mgraphics.curve_to(cx - r, cy + depth + ry * 1.1, cx + r, cy + depth + ry * 1.1, cx + r, cy + depth);
    mgraphics.stroke();
}

function drawJingles(cx, cy, r, j) {
    // the platinelas: pairs of small discs in slots in the hoop, four slots round the frame; they jitter on a hit
    for (var k = 0; k < 4; k++) {
        var sx = cx + [-0.92, -0.45, 0.45, 0.92][k] * r, sy = cy + [0.08, -0.34, -0.34, 0.08][k] * r;
        var d = j * ((k % 2) ? 1 : -1) * 1.2;
        mgraphics.ellipse(sx - 2.2, sy - 3 + d, 4.4, 1.8);
        mgraphics.stroke();
        mgraphics.ellipse(sx - 2.2, sy + 0.5 - d, 4.4, 1.8);
        mgraphics.stroke();
    }
}

// where the hand or stick touches (head centre cx, cy, radius r), for the stroke actually played; dx dy = the way the hand comes from
function contact(name, cx, cy, r) {
    var ry = r * 0.38;
    switch (name) {
    case "Thumb": return { x: cx + r * 0.55, y: cy + ry * 0.35, dx: 6, dy: -14, n: 1 };            // the thumb at the edge of the head
    case "Finger": return { x: cx + r * 0.1, y: cy, dx: 9, dy: -15, n: 1 };                        // a fingertip near the centre
    case "Slap": return { x: cx - r * 0.05, y: cy, dx: 10, dy: -14, n: 3 };                        // the flat of the fingers
    case "Rim": return { x: cx + r * 0.9, y: cy - ry * 0.1, dx: 8, dy: -16, n: 1 };                // finger on the hoop
    case "Shake": return { x: cx, y: cy + ry * 1.3, dx: 0, dy: 0, n: -1 };                        // the hand holds and shakes the frame
    case "Roll": return { x: cx + r * 0.2, y: cy, dx: 8, dy: -15, n: 2 };                          // fast alternating fingers
    case "Mute": return { x: cx - r * 0.3, y: cy + ry * 0.2, dx: 0, dy: 0, n: -2 };                // the stick hits, the other hand rests on the head
    default: return { x: cx + r * 0.25, y: cy, dx: 14, dy: -14, n: 0 };                            // Open: the stick
    }
}

function paint() {
    var w = box.rect[2] - box.rect[0], h = box.rect[3] - box.rect[1], o = THEME.lcd_control_fg;
    var name = EFF[inst][Math.max(0, Math.min(7, stroke))];
    if (flash > 0) {
        rgba(o, flash);
        mgraphics.rectangle_rounded(0, 0, w, h, 5, 5);
        mgraphics.fill();
    }
    mgraphics.select_font_face("Ableton Sans Medium");
    mgraphics.set_font_size(11);
    rgba(THEME.display_scale_text, Math.min(1, 0.6 + flash * 4));
    mgraphics.move_to(28 - mgraphics.text_measure(name)[0] / 2, h / 2 + 4);   // centred over the Instrument column
    mgraphics.show_text(name);
    var r = inst === 0 ? 20 : 12, cx = w * 0.66, cy = h / 2 - (inst === 0 ? 5 : 3), depth = inst === 0 ? 7 : 9;
    mgraphics.set_line_width(1.5);
    rgba(o, 1);
    drawHead(cx, cy, r, depth);
    if (inst === 0) drawJingles(cx, cy, r, jit);
    var c = contact(name, cx, cy, r), lift = flash > 0 ? flash * 14 : 0;   // the hand is lifted off between hits
    mgraphics.set_line_width(2);
    if (c.n === -1) {                       // shake: a hand under the frame, the frame tilts
        line(cx - r * 0.5, cy + depth + r * 0.5, cx - r * 0.1 - jit * 2, cy + depth + r * 0.15);
        line(cx + r * 0.5, cy + depth + r * 0.5, cx + r * 0.1 + jit * 2, cy + depth + r * 0.15);
    } else {
        var tx = c.x, ty = c.y;
        if (inst === 1) {                   // tamborim: a stick (a thin line ending in a bead) from upper right
            line(tx + 18 + lift * 0.3, ty - 17 - lift, tx + 1, ty - lift * 0.3);
            if (name === "Mute") line(cx - r * 0.5, cy + 3, cx - r * 0.05, cy + 3);       // the hand on the head
            if (name === "Finger") line(tx - 2, ty - lift * 0.3, tx - 2 + 6, ty - 12 - lift);   // a fingertip instead
        } else {
            var nf = Math.max(1, c.n);
            for (var f = 0; f < nf; f++) {
                var ox = (f - (nf - 1) / 2) * 3.2;
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
}
