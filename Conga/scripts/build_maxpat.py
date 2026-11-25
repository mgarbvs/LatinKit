#!/usr/bin/env python3
"""build_maxpat.py -- emit m4l/Conga.maxpat (+ conga_midi.js, conga_view.js), a three-drum conga instrument (source of truth; never hand-edit the output).

    midiin -> conga_midi.js (note map: 3 drums x 6 strokes, mod wheel) -> tr<slot> / vl<slot> / mw -> gen~ (scripts/conga_engine.py) -> plugout~
    every live.dial / live.numbox -> [prepend <param>] -> gen~
Styled after Ableton's Drum Synth devices (as the Cuica): a dark LCD panel with the three drums in line art (conga_view.js) that flash when
hit and name the stroke, orange-outlined value boxes for the three tunings, and a strip of live.dials. All colours follow the Live theme.
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import conga_engine as E  # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WIDTH = 288
DEVICE_H = 169.0
boxes, lines = [], []
_row = [0]


def add(**kw):
    boxes.append({"box": kw})
    return kw["id"]


def wire(src, dst, outlet=0, inlet=0):
    lines.append({"patchline": {"source": [src, outlet], "destination": [dst, inlet]}})


def obj(bid, text, ins=1, outs=1, outtype=None, **kw):
    _row[0] += 1
    return add(id=bid, maxclass="newobj", text=text, numinlets=ins, numoutlets=outs,
               outlettype=outtype if outtype is not None else [""] * outs,
               patching_rect=[20 + (_row[0] // 40) * 260, 20 + (_row[0] % 40) * 30, max(40, 7 * len(text)), 22], **kw)


def pres(rect):
    _row[0] += 1
    return dict(presentation=1, presentation_rect=[float(v) for v in rect],
                patching_rect=[1600 + (_row[0] % 8) * 90, 20 + (_row[0] // 8) * 80, rect[2], rect[3]])


def valueof(longname, short, lo, hi, init, unitstyle, units=None):
    v = {"parameter_longname": longname, "parameter_shortname": short, "parameter_type": 0,
         "parameter_mmin": float(lo), "parameter_mmax": float(hi),
         "parameter_initial_enable": 1, "parameter_initial": [init], "parameter_unitstyle": unitstyle}
    if units:
        v["parameter_units"] = units
    return v


DB, CUSTOM = 4, 9
THEME = {"lcd_bg": [0.1098, 0.1216, 0.1569, 1], "lcd_control_fg": [1, 0.6784, 0.3373, 1],
         "display_scale_text": [0.6824, 0.6863, 0.7137, 1]}
UNITS = {"st": "%+.1f st", "pct": "%.0f %", "db": None, "stp": "%d st"}
# display columns, left to right as on the keyboard: tumba, conga, quinto (engine drum index 2, 1, 0)
COLX = [48, 144, 240]
TUNES = [("tuneT", 2), ("tuneC", 1), ("tuneQ", 0)]
DIALS = ["decay", "skin", "slap", "shell", "touch", "press", "spread", "level"]


def themed(kw, **attrs):
    saa = kw.setdefault("saved_attribute_attributes", {})
    for a, tok in attrs.items():
        kw[a] = THEME[tok]
        saa[a] = {"expression": f"themecolor.live_{tok}"}
    return kw


def gen_patcher():
    return {
        "fileversion": 1,
        "appversion": {"major": 9, "minor": 0, "revision": 0, "architecture": "x64", "modernui": 1},
        "classnamespace": "dsp.gen", "rect": [100.0, 100.0, 900.0, 900.0],
        "boxes": [{"box": {"id": "code", "maxclass": "codebox", "code": E.code(), "fontface": 0, "fontname": "<Monospaced>",
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
    info = {n: (ln, sn, lo, hi, d, u, h) for n, ln, sn, lo, hi, d, u, h in E.PARAMS}
    lcdtxt = dict(fontname="Ableton Sans Medium", fontsize=9.0)
    # the LCD panel: added first: the box list is emitted reversed, so it draws underneath
    add(id="lcd", maxclass="panel", numinlets=1, numoutlets=0, mode=0, border=0, rounded=8, bgfillcolor=THEME["lcd_bg"],
        saved_attribute_attributes={"bgfillcolor": {"expression": "themecolor.live_lcd_bg"}}, **pres([4, 4, WIDTH - 8, 108]))

    obj("thisdev", "live.thisdevice", outs=3, outtype=["bang", "int", "int"])
    obj("load", "t b", outs=1)
    wire("thisdev", "load")
    obj("engine", "gen~", ins=1, outs=2, outtype=["signal", "signal"], patcher=gen_patcher())
    obj("plugout", "plugout~", ins=2, outs=0)
    wire("engine", "plugout", 0, 0)
    wire("engine", "plugout", 1, 1)
    obj("midi", "js conga_midi.js", outs=2)
    wire("midi", "engine")
    obj("midiin", "midiin", ins=1, outs=1, outtype=["int"])
    wire("midiin", "midi")
    add(id="view", varname="view", maxclass="jsui", numinlets=1, numoutlets=0, filename="conga_view.js", border=0, parameter_enable=0,
        annotation_name="Congas", annotation="The three drums: each flashes when it is hit, with the name of the stroke.", **pres([8, 8, WIDTH - 16, 52]))
    wire("midi", "view", 1)
    obj("colors", "live.colors", outs=2)
    add(id="msg_colors", maxclass="message", text="everything", numinlets=2, numoutlets=1, outlettype=[""], patching_rect=[300, 570, 70, 22])
    wire("load", "msg_colors", 0)
    wire("msg_colors", "colors")
    wire("colors", "view")
    wire("colors", "msg_colors", 1)

    def label(bid, text, rect, size=9.5):
        add(id=bid, maxclass="comment", text=text, numinlets=1, numoutlets=0, fontname="Ableton Sans Medium", fontsize=size,
            textjustification=1, textcolor=THEME["display_scale_text"],
            saved_attribute_attributes={"textcolor": {"expression": "themecolor.live_display_scale_text"}}, **pres(rect))

    def control(name, kind, rect):
        long_, short, lo, hi, init, unit, hover = info[name]
        units = UNITS[unit]
        us = DB if unit == "db" else CUSTOM
        vo = valueof(long_, short, lo, hi, init, us, units=units)
        extra = {}
        if kind == "dial":
            cls = dict(maxclass="live.dial", numinlets=1, numoutlets=2, outlettype=["", "float"])
        else:
            cls = dict(maxclass="live.numbox", numinlets=1, numoutlets=1, outlettype=["float"], appearance=4)
            themed(extra, lcdcolor="lcd_control_fg")
            extra["lcdbgcolor"] = [0, 0, 0, 0]
            extra["bordercolor"] = [0, 0, 0, 0]
            extra["fontname"], extra["fontsize"] = "Ableton Sans Medium", 12.0
        saa = extra.pop("saved_attribute_attributes", {})
        saa["valueof"] = vo
        add(id=name, varname=name, parameter_enable=1, annotation_name=long_, annotation=hover, saved_attribute_attributes=saa,
            **cls, **extra, **pres(rect))
        if kind == "box":   # the orange outline (live.numbox's own border isn't drawn in every theme)
            add(id=f"ol_{name}", maxclass="panel", numinlets=1, numoutlets=0, mode=0, border=1, rounded=2, bgfillcolor=[0, 0, 0, 0],
                bordercolor=THEME["lcd_control_fg"], saved_attribute_attributes={"bordercolor": {"expression": "themecolor.live_lcd_control_fg"}},
                **pres(rect))
        obj(f"pre_{name}", f"prepend {name}")
        wire(name, f"pre_{name}")
        wire(f"pre_{name}", "engine")
        wire("load", name)

    for (name, d), x in zip(TUNES, COLX):
        label(f"hdr_{name}", E.DRUMS[d][1], [x - 36, 64, 72, 14])
        control(name, "box", [x - 32, 80, 64, 20])
    for i, name in enumerate(DIALS):
        control(name, "dial", [36 * i, 116, 36, 50])
    wired = {b["box"]["text"].split()[1] for b in boxes if b["box"].get("text", "").startswith("prepend ")}
    missing = {n for n, _ in E.params()} - wired
    assert not missing, f"engine params without a control: {sorted(missing)}"
    patcher = {
        "fileversion": 1,
        "appversion": {"major": 9, "minor": 0, "revision": 0, "architecture": "x64", "modernui": 1},
        "classnamespace": "box", "rect": [60.0, 60.0, 1900.0, 1300.0],
        "openrect": [0.0, 0.0, float(WIDTH), DEVICE_H], "openinpresentation": 1, "devicewidth": float(WIDTH),
        "default_fontname": "Ableton Sans Medium", "default_fontsize": 9.0, "gridsize": [8.0, 8.0],
        "description": "Conga: three drums (quinto, conga, tumba) with open, slap, mute, bass, heel and toe strokes, as a modal membrane model.",
        "boxes": boxes[::-1], "lines": lines, "dependency_cache": [], "autosave": 0,
        "project": {
            "version": 1, "creationdate": 3871731238, "modificationdate": 3871731238,
            "viewrect": [0.0, 0.0, 300.0, 500.0], "autoorganize": 1, "hideprojectwindow": 1,
            "showdependencies": 1, "autolocalize": 0, "contents": {"patchers": {}}, "layout": {},
            "searchpath": {}, "detailsvisible": 0, "amxdtype": 1768515945, "readonly": 0,
            "devpathtype": 0, "devpath": ".", "sortmode": 0, "viewmode": 0, "includepackages": 0,
        },
    }
    return {"patcher": patcher}


MIDI_JS = """// conga_midi.js -- MIDI to the Conga engine. GENERATED by scripts/build_maxpat.py: do not edit.
// in: raw MIDI bytes from midiin (running status aware).
// out 0 (engine): vl<slot> <v 0..1> then tr<slot> <count>; mw <0..1> (mod wheel). The engine plays a slot whenever its counter changes (a counter,
// not a gate, so a note-off and the next note-on in one audio block can't swallow the hit). Note-offs are ignored: a conga stroke is its own length.
// out 1 (display): hit <drum> <stroke> <velocity 0..1>
// slot = drum * 6 + stroke; drum 0 quinto (C3..A3), 1 conga (C2..A2), 2 tumba (C1..A1); stroke 0 open C, 1 slap D, 2 mute E, 3 bass F, 4 heel G, 5 toe A.
inlets = 1;
outlets = 2;
var NOTE = %s;
var count = [];
for (var i = 0; i < NOTE.length; i++) count.push(0);
var status = 0, data = [];

function hit(slot, vel) {
    count[slot] = (count[slot] + 1) %% 65536;
    var v = Math.max(0.01, Math.min(1, vel / 127));
    outlet(0, "vl" + slot, v);
    outlet(0, "tr" + slot, count[slot]);
    outlet(1, "hit", Math.floor(slot / 6), slot %% 6, v);
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
    if (hi === 0x90 && d1 > 0) { var s = NOTE.indexOf(d0); if (s >= 0) hit(s, d1); }
    else if (hi === 0xB0 && d0 === 1) outlet(0, "mw", d1 / 127);
}
"""

if __name__ == "__main__":
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "m4l", "Conga.maxpat")
    json.dump(build(), open(out, "w"), indent="\t")
    d = os.path.dirname(os.path.abspath(out))
    open(os.path.join(d, "conga_midi.js"), "w").write(MIDI_JS % json.dumps(E.NOTES))
