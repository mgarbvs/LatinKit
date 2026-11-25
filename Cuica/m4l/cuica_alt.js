// cuica_alt.js -- the face of the Alt menu (a transparent live.menu on top does the picking): an LCD box, outlined orange when
// Off, filled orange with dark text when Auto or On (like the MPE toggles). in: <0|1|2> (the menu's index) | <theme colour> r g b a
mgraphics.init();
mgraphics.relative_coords = 0;
mgraphics.autofill = 0;
inlets = 1;
outlets = 0;
var LABELS = ["Off", "Auto", "On"], val = 1;
var THEME = { lcd_control_fg: [1, 0.678, 0.337, 1], lcd_bg: [0.11, 0.122, 0.157, 1] };

function msg_int(v) { val = Math.max(0, Math.min(2, v)); mgraphics.redraw(); }
function msg_float(v) { msg_int(Math.round(v)); }

function anything() {   // live.colors: <name> r g b a
    var a = arrayfromargs(arguments);
    if (a.length === 4 && THEME[messagename]) { THEME[messagename] = a; mgraphics.redraw(); }
}

function paint() {
    var w = box.rect[2] - box.rect[0], h = box.rect[3] - box.rect[1], o = THEME.lcd_control_fg, on = val > 0;
    mgraphics.set_source_rgba(o);
    mgraphics.rectangle_rounded(0.5, 0.5, w - 1, h - 1, 3, 3);
    if (on) mgraphics.fill(); else { mgraphics.set_line_width(1); mgraphics.stroke(); }
    mgraphics.select_font_face("Ableton Sans Medium");
    mgraphics.set_font_size(9);
    mgraphics.set_source_rgba(on ? THEME.lcd_bg : o);
    var t = LABELS[val], m = mgraphics.text_measure(t);
    mgraphics.move_to((w - m[0]) / 2, h / 2 + 3.2);
    mgraphics.show_text(t);
}
