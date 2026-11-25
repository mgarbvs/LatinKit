#!/usr/bin/env python3
"""build_maxpat.py — emit m4l/Guiro.maxpat, a scraper instrument, güiro and reco-reco (source of truth; never hand-edit the output).

    notein -> pack -> guiro_midi.js (note = stroke, hold-to-roll) -> gen~ (scripts/guiro_engine.py) -> plugout~
    every live.dial / box -> [scale to engine units] -> [prepend <param>] -> gen~   (Roll goes to the js instead)
Styled after Ableton's Drum Synth devices like Cuica: a dark LCD panel with a line drawing of the instrument with a stick that scrapes across the ridges with every
stroke (guiro_view.js), the Type menu as the big orange word, orange-outlined value boxes and a strip of live.dials. Colours follow the Live theme.
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import guiro_engine as E  # noqa: E402
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "..", "MaxForLiveTools"))
import push_screen as PS  # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WIDTH = 180
# Baked Push banks (longnames); guiro_push.js PK_BANKS must match the order.
PUSH_BANKS = [("Scrape", ["Type", "Stroke", "Length", "Speed", "Ridge", "Vary", "Tone", "Level"]), ("Out", ["Roll", "Pan"])]
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
# destination: an engine param, or "midi:<msg>" for guiro_midi.js. kind: "menu" = the big orange Type word, "box" = orange-outlined value
# box, "dirmenu" = the Stroke menu, "dial" = a live.dial in the bottom strip
CX = [8, 68, 116]   # column x of the three headers; col 0 is 52 wide, the others 44
BOX = lambda c, r: [CX[c], 69 + 13 * r, 44, 12]  # noqa: E731
DIAL = lambda i: [45 * i, 116, 45, 50]  # noqa: E731
DIALS = [
    ("type", "Type", 0, 1, 0, None, None, 1, "type", 1, "menu", [CX[0], 75, 58, 24],
     "Type: Güiro (a gourd with cut ridges: a dry, bright tick per ridge and a low body knock, fitted to recordings) or Reco (the samba reco-reco: a metal box with tensioned steel springs "
     "scraped by a rod: a bright, raspy scrape over ringing spring lines; fitted to one amateur recording, so rougher than the Güiro)."),
    ("length", "Length", 100, 1500, 450, CUSTOM, "%d ms", 1, "len", 1, "box", BOX(1, 0),
     "Length: how long the Long stroke is, in milliseconds (the recordings run 450-600 ms). Up, Down and Top have their own fixed lengths."),
    ("roll", "Roll", 0, 12, 0, CUSTOM, "%.1f Hz", 1, "midi:roll", 1, "box", BOX(1, 1),
     "Roll: 0 is off (one stroke per note). Above 0, a held note keeps scraping, this many strokes per second, until you let go: Up and Down alternate."),
    ("stroke", "Stroke", 0, 5, 0, None, None, 1, "midi:strokemode", 1, "dirmenu", [CX[1] - 2, 69 + 13 * 2 + 1, 56, 12],   # wider than the boxes: "Alternate" and the arrow need 56 (the Out column's third row is empty)
     "Stroke: which stroke a note plays. Key: by the note, C Up, C# Down, D Long, D# Top, then the same again (E Up ...). Up / Down / Long / Top: always that stroke, "
     "for a Drum Rack pad that sends one fixed note. Alternate: Up, Down, Up ... on every new note."),
    ("pan", "Pan", -100, 100, 0, CUSTOM, "%+d", 1, "pan", 0.01, "box", BOX(2, 0), "Position in the stereo field."),
    ("volume", "Level", -36, 6, -6, DB, None, 1, "vol", 1, "box", BOX(2, 1), "Output level. Velocity is the stroke's energy."),
    ("speed", "Speed", 25, 400, 100, PCT, None, LOGEXP, "speed", 0.01, "dial", DIAL(0),
     "Speed: how fast the hand moves the stick: 200 % crosses the same ridges in half the time (twice the ticks per second, a stroke half as long); 50 % is slow and twice as long. The loudness stays the same."),
    ("ridge", "Ridge", 25, 400, 100, PCT, None, LOGEXP, "ridge", 0.01, "dial", DIAL(1),
     "Ridge: how many ridges there are along the instrument (the density): few and wide apart are separate ticks, many a rasp; the stroke keeps its length. 100 % is the middle of the recordings "
     "(about 100-170 ridges a second); the four takes in the pack range from 40 to 250."),
    ("tone", "Tone", -12, 12, 0, CUSTOM, "%+.1f st", 1, "tone", 1, "dial", DIAL(2),
     "Tone: moves the click's filters and the body modes up or down, in semitones: a smaller or bigger instrument."),
    ("vary", "Vary", 0, 100, 50, PCT, None, 1, "vary", 0.01, "dial", DIAL(3),
     "Vary: how uneven the hand is: ridge-to-ridge timing (up to +-17 %) and level (up to -3 dB). 0 is a machine."),
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
    obj("midi", "js guiro_midi.js", outs=2)
    wire("midi", "engine")
    obj("notein", "notein", outs=3, outtype=["int", "int", "int"])
    obj("note_pack", "pack 0 0", ins=2)
    wire("notein", "note_pack", 0, 0)
    wire("notein", "note_pack", 1, 1)
    wire("note_pack", "midi")

    add(id="view", varname="view", maxclass="jsui", numinlets=1, numoutlets=0, filename="guiro_view.js", border=0, parameter_enable=0,
        annotation_name="Guiro", annotation="The instrument: the last note, and the stick scraping across the ridges with every stroke.", **pres([8, 8, WIDTH - 16, 48]))
    wire("midi", "view", 1)
    pk = PS.add(boxes, lines, "guiro_push.js", "thisdev")   # Push 3 screen (guiro_push.js on push_kit.js)
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
                  "parameter_enum": ["Key", "Up", "Down", "Long", "Top", "Alternate"], "parameter_mmax": 5,
                  "parameter_initial_enable": 1, "parameter_initial": [init]}
        elif kind == "dial":
            cls = dict(maxclass="live.dial", numinlets=1, numoutlets=2, outlettype=["", "float"])
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
    assert params - {"tr", "vl", "stk"} <= wired, f"engine params without a control: {params - wired}"
    patcher = {
        "fileversion": 1,
        "appversion": {"major": 9, "minor": 0, "revision": 0, "architecture": "x64", "modernui": 1},
        "classnamespace": "box", "rect": [60.0, 60.0, 1900.0, 1300.0],
        "openrect": [0.0, 0.0, float(WIDTH), DEVICE_H], "openinpresentation": 1,
        "devicewidth": float(WIDTH),
        "default_fontname": "Ableton Sans Medium", "default_fontsize": 9.0, "gridsize": [8.0, 8.0],
        "description": "Guiro: a scraper (guiro, samba reco-reco): a train of ridge impacts at a stroke-speed rate ringing the instrument, the guiro fitted to Latin Percussion recordings, the reco-reco (metal box with springs) to a Freesound one.",
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
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "m4l", "Guiro.maxpat")
    json.dump(build(), open(out, "w"), indent="\t")
    PS.copy_kit(os.path.dirname(os.path.abspath(out)))
