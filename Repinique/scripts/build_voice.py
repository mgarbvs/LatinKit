#!/usr/bin/env python3
"""build_voice.py -- emit m4l/Repinique.maxpat (+ repinique_midi.js): ONE repinique as an instrument, for Drum Rack pads (source of truth; never hand-edit the
output). Any MIDI note plays it; a Stroke menu (Open, Rimshot, Rim, Hand, Mute, Flam) chooses what it plays.

    midiin -> repinique_midi.js (any note -> vel, trg; CC1 -> mw) -> gen~ (scripts/repinique_engine.py) ; Stroke menu -> prepend -> gen~ and -> repinique_view.js
    every live.dial / live.numbox -> [prepend <param>] -> gen~
Layout after Shaker / Conga Voice / Bongo (180 x 169): a dark LCD with the repinique in line art (a stick that flashes), the menu as an orange word, four
orange-outlined value boxes (Skin, Touch, Press, Vary) and three live.dials (Tune, Decay, Volume). repinique_view.js is hand-written.
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import mx as B  # noqa: E402
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "..", "MaxForLiveTools"))
import push_screen as PS  # noqa: E402
import repinique_engine as V  # noqa: E402

HERE = B.HERE
NAME = "Repinique"
MIDI_NAME = "repinique_midi.js"
WIDTH = 180
# Baked Push banks (longnames); repinique_push.js PK_BANKS must match the order.
PUSH_BANKS = [("Drum", ["Stroke", "Tune", "Decay", "Skin", "Touch", "Vary", "Press", "Volume"])]
INFO = {n: (ln, lo, hi, d, u, h) for n, ln, lo, hi, d, u, h in V.PARAMS}
UNITS = {"tune": "%+.1f st", "decay": "%.0f %", "skin": "Skin %.0f", "touch": "Touch %.0f", "press": "Press %.0f st", "vary": "Vary %.0f", "volume": None}
MENUS = {"stroke": (V.STROKE_MENU, [8, 60, 80, 16])}
BOXES = {"skin": [8, 81, 52, 13], "touch": [64, 81, 52, 13], "press": [120, 81, 52, 13], "vary": [8, 96, 52, 13]}
DIALS = {"tune": [0, 116, 60, 50], "decay": [60, 116, 60, 50], "volume": [120, 116, 60, 50]}


def gen_patcher():
    return {
        "fileversion": 1,
        "appversion": {"major": 9, "minor": 0, "revision": 0, "architecture": "x64", "modernui": 1},
        "classnamespace": "dsp.gen", "rect": [100.0, 100.0, 900.0, 900.0],
        "boxes": [{"box": {"id": "code", "maxclass": "codebox", "code": V.code(), "fontface": 0, "fontname": "<Monospaced>",
                           "fontsize": 11.0, "numinlets": 1, "numoutlets": 2, "outlettype": ["", ""],
                           "patching_rect": [20.0, 60.0, 850.0, 800.0]}},
                  {"box": {"id": "in1", "maxclass": "newobj", "text": "in 1", "numinlets": 0, "numoutlets": 1, "outlettype": [""],
                           "patching_rect": [20.0, 20.0, 40.0, 22.0]}}]
                 + [{"box": {"id": f"out{i}", "maxclass": "newobj", "text": f"out {i}", "numinlets": 1, "numoutlets": 0,
                             "patching_rect": [20.0 + 70 * i, 870.0, 40.0, 22.0]}} for i in (1, 2)],
        "lines": [{"patchline": {"source": ["in1", 0], "destination": ["code", 0]}}]
                 + [{"patchline": {"source": ["code", i - 1], "destination": [f"out{i}", 0]}} for i in (1, 2)],
    }


def build():
    obj, wire, add = B.obj, B.wire, B.add
    # the LCD panel: added first: the box list is emitted reversed, so it draws underneath
    add(id="lcd", maxclass="panel", numinlets=1, numoutlets=0, mode=0, border=0, rounded=8, bgfillcolor=B.THEME["lcd_bg"],
        saved_attribute_attributes={"bgfillcolor": {"expression": "themecolor.live_lcd_bg"}}, **B.pres([4, 4, WIDTH - 8, 108]))

    obj("thisdev", "live.thisdevice", outs=3, outtype=["bang", "int", "int"])
    obj("load", "t b", outs=1)
    wire("thisdev", "load")
    obj("engine", "gen~", ins=1, outs=2, outtype=["signal", "signal"], patcher=gen_patcher())
    obj("plugout", "plugout~", ins=2, outs=0)
    wire("engine", "plugout", 0, 0)
    wire("engine", "plugout", 1, 1)
    obj("midi", f"js {MIDI_NAME}", outs=2)
    wire("midi", "engine")
    obj("midiin", "midiin", ins=1, outs=1, outtype=["int"])
    wire("midiin", "midi")
    add(id="view", varname="view", maxclass="jsui", numinlets=1, numoutlets=0, filename="repinique_view.js", border=0, parameter_enable=0,
        annotation_name="Repinique", annotation="The repinique in orange line art, the mallet or hand where the current stroke is played and its name: it flashes when a note hits.", **B.pres([8, 8, WIDTH - 16, 40]))
    wire("midi", "view", 1)
    pk = PS.add(B.boxes, B.lines, "repinique_push.js", "thisdev")   # Push 3 screen (repinique_push.js on push_kit.js)
    wire("midi", pk, 1)                                     # hit <velocity>
    obj("colors", "live.colors", outs=2)
    add(id="msg_colors", maxclass="message", text="everything", numinlets=2, numoutlets=1, outlettype=[""], patching_rect=[300, 570, 70, 22])
    wire("load", "msg_colors", 0)
    wire("msg_colors", "colors")
    wire("colors", "view")
    wire("colors", "msg_colors", 1)

    for text, x in (("Stroke", 8),):
        add(id=f"hdr_{text}", maxclass="comment", text=text, numinlets=1, numoutlets=0, fontname="Ableton Sans Medium", fontsize=9.5,
            textjustification=0, textcolor=B.THEME["display_scale_text"],
            saved_attribute_attributes={"textcolor": {"expression": "themecolor.live_display_scale_text"}}, **B.pres([x - 2, 49, 60, 14]))

    for name, (long_, lo, hi, init, unit, hover) in INFO.items():
        extra = {}
        if name in MENUS:     # the big orange word
            names, rect = MENUS[name]
            cls = dict(maxclass="live.menu", numinlets=1, numoutlets=3, outlettype=["", "", "float"], appearance=1)
            B.themed(extra, lcdcolor="lcd_control_fg")
            extra["lcdbgcolor"] = [0, 0, 0, 0]
            extra["fontname"], extra["fontsize"] = "Ableton Sans Medium", 11.0
            vo = {"parameter_longname": long_, "parameter_shortname": long_, "parameter_type": 2, "parameter_enum": names,
                  "parameter_mmax": len(names) - 1, "parameter_initial_enable": 1, "parameter_initial": [init]}
        elif name in DIALS:
            rect = DIALS[name]
            cls = dict(maxclass="live.dial", numinlets=1, numoutlets=2, outlettype=["", "float"])
            vo = B.valueof(long_, long_, lo, hi, init, B.DB if unit == "db" else B.CUSTOM, units=UNITS[name])
        else:
            rect = BOXES[name]
            cls = dict(maxclass="live.numbox", numinlets=1, numoutlets=1, outlettype=["float"], appearance=4)
            B.themed(extra, lcdcolor="lcd_control_fg")
            extra["lcdbgcolor"] = [0, 0, 0, 0]
            extra["bordercolor"] = [0, 0, 0, 0]
            extra["fontname"], extra["fontsize"] = "Ableton Sans Medium", 9.0
            vo = B.valueof(long_, long_, lo, hi, init, B.CUSTOM, units=UNITS[name])
        saa = extra.pop("saved_attribute_attributes", {})
        saa["valueof"] = vo
        add(id=name, varname=name, parameter_enable=1, annotation_name=long_, annotation=hover, saved_attribute_attributes=saa,
            **cls, **extra, **B.pres(rect))
        if name in BOXES:   # the orange outline (live.numbox's own border isn't drawn in every theme)
            add(id=f"ol_{name}", maxclass="panel", numinlets=1, numoutlets=0, mode=0, border=1, rounded=2, bgfillcolor=[0, 0, 0, 0],
                bordercolor=B.THEME["lcd_control_fg"], saved_attribute_attributes={"bordercolor": {"expression": "themecolor.live_lcd_control_fg"}},
                **B.pres(rect))
        obj(f"pre_{name}", f"prepend {name}")
        wire(name, f"pre_{name}")
        wire(f"pre_{name}", "engine")
        if name in MENUS:    # the drawing follows the menu
            obj(f"pre_{name}_view", f"prepend {name}")
            wire(name, f"pre_{name}_view")
            wire(f"pre_{name}_view", "view")
        wire("load", name)
    wired = {b["box"]["text"].split()[1] for b in B.boxes if b["box"].get("text", "").startswith("prepend ")}
    missing = {p[0] for p in V.PARAMS} - wired
    assert not missing, f"engine params without a control: {sorted(missing)}"
    patcher = {
        "fileversion": 1,
        "appversion": {"major": 9, "minor": 0, "revision": 0, "architecture": "x64", "modernui": 1},
        "classnamespace": "box", "rect": [60.0, 60.0, 1900.0, 1300.0],
        "openrect": [0.0, 0.0, float(WIDTH), B.DEVICE_H], "openinpresentation": 1, "devicewidth": float(WIDTH),
        "default_fontname": "Ableton Sans Medium", "default_fontsize": 9.0, "gridsize": [8.0, 8.0],
        "description": "Repinique: one samba repinique (open, rimshot, rim, hand, mute or flam) as a modal head and shell model fitted to recordings, for Drum Rack pads.",
        "boxes": B.boxes[::-1], "lines": B.lines, "dependency_cache": [], "autosave": 0,
        "parameters": PS.banks(B.boxes, PUSH_BANKS),
        "project": {
            "version": 1, "creationdate": 3871731238, "modificationdate": 3871731238,
            "viewrect": [0.0, 0.0, 300.0, 500.0], "autoorganize": 1, "hideprojectwindow": 1,
            "showdependencies": 1, "autolocalize": 0, "contents": {"patchers": {}}, "layout": {},
            "searchpath": {}, "detailsvisible": 0, "amxdtype": 1768515945, "readonly": 0,
            "devpathtype": 0, "devpath": ".", "sortmode": 0, "viewmode": 0, "includepackages": 0,
        },
    }
    return {"patcher": patcher}


MIDI_JS = """// repinique_midi.js -- any MIDI note plays Repinique. GENERATED by scripts/build_voice.py: do not edit.
// in: raw MIDI bytes from midiin (running status aware).
// out 0 (engine): vel <0..1> then trg <count>; mw <0..1> (mod wheel). The engine plays a hit whenever the counter changes (a counter, not a
// gate, so a note-off and the next note-on in one audio block can't swallow the hit). Note-offs are ignored: a stroke is as long as the drum rings.
// out 1 (display): hit <velocity 0..1>
inlets = 1;
outlets = 2;
var count = 0;
var status = 0, data = [];

function hit(vel) {
    count = (count + 1) % 65536;
    var v = Math.max(0.01, Math.min(1, vel / 127));
    outlet(0, "vel", v);
    outlet(0, "trg", count);
    outlet(1, "hit", v);
}

function msg_int(b) {
    if (b >= 0xF8) return;                 // realtime
    if (b >= 0x80) { status = b < 0xF0 ? b : 0; data = []; return; }
    if (!status) return;
    data.push(b);
    var hi = status & 0xF0;
    var need = hi === 0xC0 || hi === 0xD0 ? 1 : 2;
    if (data.length < need) return;
    var d0 = data[0], d1 = data[1];
    data = [];
    if (hi === 0x90 && d1 > 0) hit(d1);
    else if (hi === 0xB0 && d0 === 1) outlet(0, "mw", d1 / 127);
}
"""

if __name__ == "__main__":
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "m4l", NAME + ".maxpat")
    json.dump(build(), open(out, "w"), indent="\t")
    open(os.path.join(os.path.dirname(os.path.abspath(out)), MIDI_NAME), "w").write(MIDI_JS)
    PS.copy_kit(os.path.dirname(os.path.abspath(out)))
