#!/usr/bin/env python3
"""build_maxpat.py — emit m4l/Shaker.maxpat, a PhISEM shaker instrument (source of truth; never hand-edit the output).

    notein -> pack -> shaker_midi.js (note parity = stroke direction, hold-to-roll) -> gen~ (scripts/shaker_engine.py) -> plugout~
    every live.dial / box -> [scale to engine units] -> [prepend <param>] -> gen~   (Roll goes to the js instead)
Styled after Ableton's Drum Synth devices like Cuica: a dark LCD panel with a line drawing of the shaker that flashes and jerks with every
stroke (shaker_view.js), the Type menu as the big orange word, orange-outlined value boxes and a strip of live.dials. Colours follow the Live theme.
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import shaker_engine as E  # noqa: E402
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "..", "MaxForLiveTools"))
import push_screen as PS  # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WIDTH = 180
# Baked Push banks (longnames); shaker_push.js PK_BANKS must match the order.
PUSH_BANKS = [("Shake", ["Type", "Direction", "Back", "Beads", "Damping", "Shake", "Rattle", "Tone"]), ("Out", ["Roll", "Level", "Pan"])]
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


def valueof(longname, short, lo, hi, init, unitstyle, exponent=1.0, units=None):
    v = {"parameter_longname": longname, "parameter_shortname": short, "parameter_type": 0,
         "parameter_mmin": float(lo), "parameter_mmax": float(hi),
         "parameter_initial_enable": 1, "parameter_initial": [init], "parameter_unitstyle": unitstyle}
    if exponent != 1.0:
        v["parameter_exponent"] = exponent
    if units:
        v["parameter_units"] = units
    return v


PCT, TIME, DB, SEMI, CUSTOM, INT = 5, 2, 4, 8, 9, 0
THEME = {"lcd_bg": [0.1098, 0.1216, 0.1569, 1], "lcd_control_fg": [1, 0.6784, 0.3373, 1],
         "display_scale_text": [0.6824, 0.6863, 0.7137, 1]}
LOGEXP = 2.32   # a 25..400 dial whose middle is 100: (100 - 25) / 375 = 0.5 ** 2.32
# (varname, long name, lo, hi, default, unitstyle, units, exponent, destination, scale, kind, rect, hover text)
# destination: an engine param, or "midi:<msg>" for shaker_midi.js. kind: "menu" = the big orange Type word, "box" = orange-outlined value
# box, "dial" = a live.dial in the bottom strip
CX = [8, 68, 116]   # column x of the three headers; col 0 is 52 wide, the others 44
BOX = lambda c, r: [CX[c], 69 + 13 * r, 44, 12]  # noqa: E731
DIAL = lambda i: [36 * i, 116, 36, 50]  # noqa: E731
DIALS = [
    ("type", "Type", 0, 4, 0, None, None, 1, "type", 1, "menu", [CX[0], 75, 58, 24],
     "Type: which shaker. Maraca (gourd of seeds, loose and mid-bright), Cabasa (a steel bead chain on a drum: dense, fast, very bright), "
     "Shekere (a gourd in a net of beads: softer, slower to build), Ganza (metal tube of pellets, bright), Egg (a few small beads: sparse, "
     "tiny). Each type is fitted to recordings."),
    ("back", "Back", 0, 100, 70, PCT, None, 1, "back", 0.01, "box", BOX(1, 0),
     "Back: how loud the back stroke is against the forward one. Which strokes go back is set by Direction; a back stroke also builds up a little slower."),
    ("roll", "Roll", 0, 16, 0, CUSTOM, "%.1f Hz", 1, "midi:roll", 1, "box", BOX(1, 1),
     "Roll: 0 is off (one stroke per note). Above 0, a held note keeps shaking back and forth, this many strokes per second, until you let go."),
    ("direction", "Direction", 0, 3, 0, None, None, 1, "midi:direction", 1, "dirmenu", [CX[1] - 2, 69 + 13 * 2 + 1, 56, 12],   # wider than the boxes: "Alternate" and the arrow need 56 (the Out column's third row is empty)
     
     "Direction: which way each stroke goes. Key: by the note, even notes (C3) forward and odd notes (C#3) back. Alternate: every new note flips, "
     "forward, back, forward ... (a Roll keeps alternating). Forward / Back: every stroke the same way, for a Drum Rack pad that sends one fixed note."),
    ("pan", "Pan", -100, 100, 0, CUSTOM, "%+d", 1, "pan", 0.01, "box", BOX(2, 0), "Position in the stereo field."),
    ("volume", "Level", -36, 6, -6, DB, None, 1, "vol", 1, "box", BOX(2, 1), "Output level."),
    ("beads", "Beads", 25, 400, 100, PCT, None, LOGEXP, "beads", 0.01, "dial", DIAL(0),
     "Beads: how many particles. More beads collide more often: from separate clicks to a smooth hiss. The loudness stays the same. 100 % is the fitted instrument."),
    ("damping", "Damping", 25, 400, 100, PCT, None, LOGEXP, "damp", 0.01, "dial", DIAL(1),
     "Damping: how long the shaking energy lasts (PhISEM's system decay). 100 % is the fitted decay; 25 % is a short snap, 400 % a long swish."),
    ("shake", "Shake", 25, 400, 100, PCT, None, LOGEXP, "shake", 0.01, "dial", DIAL(2),
     "Shake: the length of the stroke: how long the beads take to build up. Short is a flick, long is a slow sweep of the hand."),
    ("rattle", "Rattle", 0, 100, 50, PCT, None, 1, "rattle", 0.01, "dial", DIAL(3),
     "Rattle: the beads' own damping. Low: dull, each collision a tiny tick. High: each collision rings a little (grains four times longer, like hard beads on a hard shell)."),
    ("tone", "Tone", -12, 12, 0, CUSTOM, "%+.1f st", 1, "tone", 1, "dial", DIAL(4),
     "Tone: moves the shaker's resonances and the high-pass up or down, in semitones: a bigger or smaller vessel."),
]
HEADERS = [("Type", 0, 58), ("Stroke", 1, 44), ("Out", 2, 44)]


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
    obj("midi", "js shaker_midi.js", outs=2)
    wire("midi", "engine")
    obj("notein", "notein", outs=3, outtype=["int", "int", "int"])
    obj("note_pack", "pack 0 0", ins=2)
    wire("notein", "note_pack", 0, 0)
    wire("notein", "note_pack", 1, 1)
    wire("note_pack", "midi")

    add(id="view", varname="view", maxclass="jsui", numinlets=1, numoutlets=0, filename="shaker_view.js", border=0, parameter_enable=0,
        annotation_name="Shaker", annotation="The shaker: the last note, and a flash and a jerk with every stroke.", **pres([8, 8, WIDTH - 16, 48]))
    wire("midi", "view", 1)
    pk = PS.add(boxes, lines, "shaker_push.js", "thisdev")   # Push 3 screen (shaker_push.js on push_kit.js)
    wire("midi", pk, 1)                                      # hit <note> <velocity> ...
    obj("colors", "live.colors", outs=2)
    add(id="msg_colors", maxclass="message", text="everything", numinlets=2, numoutlets=1, outlettype=[""], patching_rect=[300, 570, 70, 22])
    wire("load", "msg_colors", 0)
    wire("msg_colors", "colors")
    wire("colors", "view")
    wire("colors", "msg_colors", 1)

    lcdtxt = dict(fontname="Ableton Sans Medium", fontsize=9.0)
    for text, col, w in HEADERS:
        add(id=f"hdr_{text}", maxclass="comment", text=text, numinlets=1, numoutlets=0, fontname="Ableton Sans Medium", fontsize=9.5,
            textjustification=1, textcolor=THEME["display_scale_text"],
            saved_attribute_attributes={"textcolor": {"expression": "themecolor.live_display_scale_text"}}, **pres([CX[col] - 2, 55, w + 4, 14]))

    for (vid, long_, lo, hi, init, unit, units, expo, dest, scale, kind, rect, info) in DIALS:
        extra = {}
        if kind == "menu":   # the big orange word
            names = E.MENU
            cls = dict(maxclass="live.menu", numinlets=1, numoutlets=3, outlettype=["", "", "float"], appearance=1)
            themed(extra, lcdcolor="lcd_control_fg")
            extra["lcdbgcolor"] = [0, 0, 0, 0]
            extra["fontname"], extra["fontsize"] = "Ableton Sans Medium", 11.0
            vo = {"parameter_longname": long_, "parameter_shortname": long_, "parameter_type": 2, "parameter_enum": names,
                  "parameter_mmax": len(names) - 1, "parameter_initial_enable": 1, "parameter_initial": [init]}
        elif kind == "dirmenu":   # an orange-outlined menu in the Stroke column
            cls = dict(maxclass="live.menu", numinlets=1, numoutlets=3, outlettype=["", "", "float"], appearance=1)
            themed(extra, lcdcolor="lcd_control_fg")
            extra["lcdbgcolor"] = [0, 0, 0, 0]
            extra["fontname"], extra["fontsize"] = "Ableton Sans Medium", 9.0
            vo = {"parameter_longname": long_, "parameter_shortname": long_, "parameter_type": 2,
                  "parameter_enum": ["Key", "Alternate", "Forward", "Back"], "parameter_mmax": 3,
                  "parameter_initial_enable": 1, "parameter_initial": [init]}
        elif kind == "dial":
            cls = dict(maxclass="live.dial", numinlets=1, numoutlets=2, outlettype=["", "float"])
            extra["fontname"], extra["fontsize"] = "Ableton Sans Medium", 8.0   # five dials in 180: 9 pt runs the values together
            vo = valueof(long_, long_, lo, hi, init, unit, exponent=expo, units=units)
        else:
            cls = dict(maxclass="live.numbox", numinlets=1, numoutlets=1, outlettype=["float"], appearance=4)
            themed(extra, lcdcolor="lcd_control_fg")
            themed(extra, bordercolor="lcd_control_fg")
            extra["lcdbgcolor"] = [0, 0, 0, 0]
            extra["fontname"], extra["fontsize"] = "Ableton Sans Medium", 9.0
            vo = valueof(long_, long_, lo, hi, init, unit, exponent=expo, units=units)
        saa = extra.pop("saved_attribute_attributes", {})
        saa["valueof"] = vo
        add(id=vid, varname=vid, parameter_enable=1, annotation_name=long_, annotation=info,
            saved_attribute_attributes=saa, **cls, **extra,
            **pres([rect[0], rect[1] - 2, *rect[2:]] if kind == "dirmenu" else rect))   # live.menu draws its text low: lift it inside the outline
        if kind in ("box", "dirmenu"):   # the orange outline (live.numbox's own border isn't drawn in every theme)
            add(id=f"ol_{vid}", maxclass="panel", numinlets=1, numoutlets=0, mode=0, border=1, rounded=2, bgfillcolor=[0, 0, 0, 0],
                bordercolor=THEME["lcd_control_fg"], saved_attribute_attributes={"bordercolor": {"expression": "themecolor.live_lcd_control_fg"}},
                **pres(rect))
        nxt = vid
        if scale != 1:
            obj(f"sc_{vid}", f"* {scale}")
            wire(vid, f"sc_{vid}")
            nxt = f"sc_{vid}"
        msg = dest.split(":")[1] if dest.startswith("midi:") else dest
        obj(f"pre_{vid}", f"prepend {msg}")
        wire(nxt, f"pre_{vid}")
        wire(f"pre_{vid}", "midi" if dest.startswith("midi:") else "engine")
        if kind == "menu":   # the drawing follows the type
            obj("pre_type_view", "prepend type")
            wire(vid, "pre_type_view")
            wire("pre_type_view", "view")
        wire("load", vid)
    params = {p for p, _ in E.PARAMS}
    wired = {b["box"]["text"].split()[1] for b in boxes if b["box"].get("text", "").startswith("prepend ")}
    assert params - {"tr", "vl", "dir"} <= wired, f"engine params without a control: {params - wired}"
    patcher = {
        "fileversion": 1,
        "appversion": {"major": 9, "minor": 0, "revision": 0, "architecture": "x64", "modernui": 1},
        "classnamespace": "box", "rect": [60.0, 60.0, 1900.0, 1300.0],
        "openrect": [0.0, 0.0, float(WIDTH), DEVICE_H], "openinpresentation": 1,
        "devicewidth": float(WIDTH),
        "default_fontname": "Ableton Sans Medium", "default_fontsize": 9.0, "gridsize": [8.0, 8.0],
        "description": "Shaker: maraca, cabasa, shekere, ganza and egg shaker from Perry Cook's PhISEM stochastic particle model, fitted to recordings.",
        "boxes": boxes[::-1], "lines": lines, "dependency_cache": [], "autosave": 0,
        "parameters": PS.banks(boxes, PUSH_BANKS),
        "project": {
            "version": 1, "creationdate": 3871731238, "modificationdate": 3871731238,
            "viewrect": [0.0, 0.0, 300.0, 500.0], "autoorganize": 1, "hideprojectwindow": 1,
            "showdependencies": 1, "autolocalize": 0, "contents": {"patchers": {}}, "layout": {},
            "searchpath": {}, "detailsvisible": 0, "amxdtype": 1768515945, "readonly": 0,
            "devpathtype": 0, "devpath": ".", "sortmode": 0, "viewmode": 0, "includepackages": 0,
        },
    }
    return {"patcher": patcher}


if __name__ == "__main__":
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "m4l", "Shaker.maxpat")
    json.dump(build(), open(out, "w"), indent="\t")
    PS.copy_kit(os.path.dirname(os.path.abspath(out)))
