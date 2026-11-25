#!/usr/bin/env python3
"""build_maxpat.py — emit m4l/Cuica.maxpat, a friction-drum instrument (source of truth; never hand-edit the output).

    midiin -> cuica_midi.js (raw bytes; mono, last-note priority, one stroke per note, wheel, bend, MPE) -> gen~ (scripts/cuica_engine.py) -> plugout~
    every live.dial -> [scale to engine units] -> [prepend <param>] -> gen~
Styled after Ableton's Drum Synth devices (DS Kick): a dark LCD panel with a line-art cuica that flashes on every note (cuica_view.js),
big orange Tune number, orange-outlined value boxes, and a strip of live.dials. All colours follow the Live theme.
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "..", "MaxForLiveTools"))
import cuica_engine as E  # noqa: E402
import push_screen as PS  # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WIDTH = 216
# Baked Push banks (longnames); cuica_push.js PK_BANKS must match the order.
PUSH_BANKS = [
    ("Rub", ["Tune", "Pressure", "Speed", "Stroke", "Pull", "Scoop", "Thumb", "Glide"]),
    ("Head", ["Head", "Rasp", "Tone", "Decay", "Volume", "Alt"]),
]
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
# (varname, long name, lo, hi, default, unitstyle, units, exponent, engine param, scale, kind, rect, hover text)
# kind: "big" = the big orange number, "box" = orange-outlined value box, "dial" = a live.dial in the bottom strip
CX = [8, 64, 112, 160]   # column x of the four headers; col 0 is 48 wide, the others 44
BOX = lambda c, r: [CX[c], 77 + 16 * r, 44, 13]  # noqa: E731
DIAL = lambda i: [36 * i, 116, 36, 50]  # noqa: E731
DIALS = [
    ("tune", "Tune", -24, 24, 0, INT, None, 1, "tune", 1, "big", [CX[0], 78, 48, 24], "Transposes the notes, in semitones."),
    ("pressure", "Pressure", 0, 100, 55, PCT, None, 1, "press", 0.01, "box", BOX(1, 0),
     "Pressure: how hard the cloth grips the rod. As on a real cuica, gripping harder lowers the note (in tune up to the default, about 35 cents flatter at full) and makes a slow rub creak and break up."),
    ("speed", "Speed", 0, 100, 60, PCT, None, 1, "speed", 0.01, "box", BOX(1, 1),
     "Speed: how fast the hand rubs: louder and brighter. MIDI velocity scales it too."),
    ("stroke", "Stroke", 40, 800, 300, TIME, None, 2.0, "stroke", 1, "box", BOX(2, 0),
     "Stroke: length of one rub, push or pull. Every note is one stroke, however long it is held; with MPE, pressure keeps rubbing."),
    ("pull", "Pull", -7, 7, 2, CUSTOM, "%+d", 1, "pull", 1, "box", [CX[2], 93, 17, 13],
     "Pull: how many semitones higher a pull is (it is also a little louder). Alt decides which notes are pulls."),
    ("thumb", "Thumb", 0, 24, 12, CUSTOM, "%d st", 1, "thumb", 1, "box", BOX(3, 0),
     "Thumb: how far the mod wheel raises the pitch: pressing the head with the thumb gives the cuica its laugh and cry."),
    ("scoop", "Scoop", -12, 12, -4, CUSTOM, "%d st", 1, "scoop", 1, "box", BOX(3, 1),
     "Scoop: a new note starts this far from its pitch and rides the stroke into it, the cuica's squeak (a little different every stroke)."),
    ("glide", "Glide", 0, 500, 60, TIME, None, 2.0, "glide", 1, "dial", DIAL(0),
     "How long pitch changes take to settle: the mod wheel and legato notes."),
    ("head", "Head", 0, 100, 50, PCT, None, 1, "head", 0.01, "dial", DIAL(1),
     "The head's tension: its own resonance, from 250 Hz to 1 kHz. Notes at or above it sing almost pure; notes below it grunt, their low overtones lifted by the head."),
    ("rasp", "Rasp", 0, 100, 25, PCT, None, 1, "rasp", 0.01, "dial", DIAL(2), "The damp cloth on the rod: its scrape, and how wild the rub gets: more of the head joins in, so slow or hard-gripped strokes creak and break up sooner."),
    ("tone", "Tone", 0, 100, 60, PCT, None, 1, "tone", 0.01, "dial", DIAL(3), "Brightness: how much of the rod's overtones get through the head."),
    ("decay", "Decay", 10, 2000, 400, TIME, None, 2.0, "decay", 1, "dial", DIAL(4),
     "How long the head rings on after the rub (time to fade by 60 dB)."),
    ("volume", "Volume", -36, 6, -6, DB, None, 1, "vol", 1, "dial", DIAL(5), "Output level."),
]
HEADERS = [("Tune", 0, 48), ("Rub", 1, 44), ("Stroke", 2, 44), ("Thumb", 3, 44)]
# the MPE page, over the display (x 8..208, y 8..56) when the MPE button is on: (varname, long name, kind, lo/hi or enum, default,
# units, where it goes (js message or engine param), scale, column, hover text)
MX = [14, 62, 110, 158]
MPE = [
    ("mpe_on", "MPE", "toggle", ["Off", "On"], 1, None, ("midi", "mpe"), 1, 0,
     "MPE: on, a note's own channel carries its pressure, slide and pitch bend (Live sends per-note channels to this device). Off: they are ignored."),
    ("mpe_bend", "MPE Bend", "box", (1, 96), 48, "%d st", ("midi", "pbrange"), 1, 1,
     "MPE Bend: the per-note pitch bend range, in semitones (48 is the MPE standard; match your controller)."),
    ("mpe_press", "MPE Pressure", "box", (0, 100), 100, None, ("engine", "pram"), 0.01, 2,
     "MPE Pressure: how strongly finger pressure keeps the cloth rubbing. 0: every note is just its one stroke."),
    ("mpe_slide", "MPE Slide", "menu", ["Off", "Thumb", "Head", "Tone", "Grip"], 1, None, ("engine", "sld"), 1, 3,
     "MPE Slide (CC74): what moving the finger along the key does: press the head with the thumb (pitch up by Thumb), tighten the Head, brighten the Tone, or grip the rod harder (lower and rougher, like Pressure)."),
]


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
        saved_attribute_attributes={"bgfillcolor": {"expression": "themecolor.live_lcd_bg"}}, **pres([4, 4, 208, 108]))

    obj("thisdev", "live.thisdevice", outs=3, outtype=["bang", "int", "int"])
    obj("load", "t b", outs=1)
    wire("thisdev", "load")
    obj("engine", "gen~", ins=1, outs=2, outtype=["signal", "signal"], patcher=gen_patcher())
    obj("plugout", "plugout~", ins=2, outs=0)
    wire("engine", "plugout", 0, 0)
    wire("engine", "plugout", 1, 1)
    obj("midi", "js cuica_midi.js", outs=2)
    wire("midi", "engine")
    obj("midiin", "midiin", ins=1, outs=1, outtype=["int"])
    wire("midiin", "midi")   # raw bytes: the js needs each message's channel for MPE

    add(id="view", varname="view", maxclass="jsui", numinlets=1, numoutlets=0, filename="cuica_view.js", border=0, parameter_enable=0,
        annotation_name="Cuica", annotation="The cuica: the last note, and a flash with every note you play.", **pres([8, 8, 200, 48]))
    wire("midi", "view", 1)

    # the MPE page: a button in the display's corner flips the display to the MPE settings (all real parameters)
    lcdtxt = dict(fontname="Ableton Sans Medium", fontsize=9.0)
    def outline(vid, rect):
        add(id=f"ol_{vid}", varname=f"ol_{vid}", maxclass="panel", numinlets=1, numoutlets=0, mode=0, border=1, rounded=2,
            bgfillcolor=[0, 0, 0, 0], bordercolor=THEME["lcd_control_fg"],
            saved_attribute_attributes={"bordercolor": {"expression": "themecolor.live_lcd_control_fg"}}, **pres(rect))
    def textcolors(kw):   # an LCD toggle: outlined, orange text; on = filled orange with dark text
        themed(kw, textcolor="lcd_control_fg", activetextcolor="lcd_control_fg", bgoncolor="lcd_control_fg",
               activebgoncolor="lcd_control_fg", textoncolor="lcd_bg", activetextoncolor="lcd_bg", bordercolor="lcd_control_fg")
        kw["bgcolor"] = kw["activebgcolor"] = [0, 0, 0, 0]
        return kw
    kw = textcolors({})
    saa = kw.pop("saved_attribute_attributes")
    saa["valueof"] = {"parameter_longname": "MPE Page", "parameter_shortname": "MPE Page", "parameter_type": 2,
                      "parameter_enum": ["Drum", "MPE"], "parameter_mmax": 1, "parameter_initial_enable": 1, "parameter_initial": [0],
                      "parameter_invisible": 1}   # stored with the set, not automatable: it is only a view
    add(id="mpe_page", varname="mpe_page", maxclass="live.text", numinlets=1, numoutlets=2, outlettype=["", ""], parameter_enable=1,
        mode=1, text="MPE", texton="MPE", rounded=2, annotation_name="MPE settings",
        annotation="Shows the MPE settings in the display (and back to the drum).", saved_attribute_attributes=saa, **lcdtxt, **kw,
        **pres([178, 11, 27, 11]))
    page_names = []
    for (vid, long_, kind, rng, init, units, (dst, msg), scale, col, info) in MPE:
        x = MX[col]
        lbl = f"lbl_{vid}"
        add(id=lbl, varname=lbl, maxclass="comment", text=long_.replace("MPE ", "") if vid != "mpe_on" else "MPE", numinlets=1,
            numoutlets=0, fontname="Ableton Sans Medium", fontsize=9.5, textjustification=1, textcolor=THEME["display_scale_text"],
            saved_attribute_attributes={"textcolor": {"expression": "themecolor.live_display_scale_text"}}, **pres([x - 2, 20, 48, 14]))
        rect = [x, 36, 44, 13]
        if kind == "toggle":
            kw = textcolors({})
            saa = kw.pop("saved_attribute_attributes")
            saa["valueof"] = {"parameter_longname": long_, "parameter_shortname": long_, "parameter_type": 2, "parameter_enum": rng,
                              "parameter_mmax": 1, "parameter_initial_enable": 1, "parameter_initial": [init]}
            add(id=vid, varname=vid, maxclass="live.text", numinlets=1, numoutlets=2, outlettype=["", ""], parameter_enable=1, mode=1,
                text=rng[0], texton=rng[1], rounded=2, annotation_name=long_, annotation=info, saved_attribute_attributes=saa,
                **lcdtxt, **kw, **pres(rect))
        elif kind == "menu":
            kw = themed({}, lcdcolor="lcd_control_fg")
            saa = kw.pop("saved_attribute_attributes")
            saa["valueof"] = {"parameter_longname": long_, "parameter_shortname": long_, "parameter_type": 2, "parameter_enum": rng,
                              "parameter_mmax": len(rng) - 1, "parameter_initial_enable": 1, "parameter_initial": [init]}
            add(id=vid, varname=vid, maxclass="live.menu", numinlets=1, numoutlets=3, outlettype=["", "", "float"], parameter_enable=1,
                appearance=1, lcdbgcolor=[0, 0, 0, 0], annotation_name=long_, annotation=info, saved_attribute_attributes=saa,
                **lcdtxt, **kw, **pres(rect))
            outline(vid, rect)
            page_names.append(f"ol_{vid}")
        else:
            kw = themed({}, lcdcolor="lcd_control_fg")
            saa = kw.pop("saved_attribute_attributes")
            saa["valueof"] = valueof(long_, long_, rng[0], rng[1], init, CUSTOM if units else PCT, units=units)
            add(id=vid, varname=vid, maxclass="live.numbox", numinlets=1, numoutlets=1, outlettype=["float"], parameter_enable=1,
                appearance=4, lcdbgcolor=[0, 0, 0, 0], bordercolor=[0, 0, 0, 0], annotation_name=long_, annotation=info,
                saved_attribute_attributes=saa, **lcdtxt, **kw, **pres(rect))
            outline(vid, rect)
            page_names.append(f"ol_{vid}")
        page_names += [vid, lbl]
        nxt = vid
        if scale != 1:
            obj(f"sc_{vid}", f"* {scale}")
            wire(vid, f"sc_{vid}")
            nxt = f"sc_{vid}"
        obj(f"pre_{vid}", f"prepend {msg}")
        wire(nxt, f"pre_{vid}")
        wire(f"pre_{vid}", dst)
        if kind != "toggle":   # a bang would flip a toggle (it sends its own state on load)
            wire("load", vid)
    for b in boxes:   # the drum page shows first; the button's stored state then sets the page on load
        if b["box"].get("varname") in page_names:
            b["box"]["hidden"] = 1
    # Alt: a menu (Off / Auto / On). cuica_alt.js draws the box (filled orange when Auto or On); a transparent live.menu on top
    # does the picking, so a click opens the list
    rect = [CX[2] + 19, 93, 25, 13]
    add(id="altface", varname="altface", maxclass="jsui", numinlets=1, numoutlets=0, filename="cuica_alt.js", border=0,
        parameter_enable=0, ignoreclick=1, **pres(rect))
    saa = {"valueof": {"parameter_longname": "Alt", "parameter_shortname": "Alt", "parameter_type": 2,
                       "parameter_enum": ["Off", "Auto", "On"], "parameter_mmax": 2, "parameter_initial_enable": 1, "parameter_initial": [1]}}
    add(id="alt", varname="alt", maxclass="live.menu", numinlets=1, numoutlets=3, outlettype=["", "", "float"], parameter_enable=1,
        appearance=1, lcdcolor=[0, 0, 0, 0], lcdbgcolor=[0, 0, 0, 0], inactivelcdcolor=[0, 0, 0, 0], annotation_name="Alt",
        annotation="Alt: push and pull, like the hand going back and forth on the rod (the pull is Pull semitones higher, a little "
                   "louder). Auto: quick notes (within one Stroke of the last) alternate, and after a pause the next note is a push again. "
                   "On: every other note is a pull. Off: every note is a push, at its own pitch.",
        saved_attribute_attributes=saa, **lcdtxt, **pres(rect))
    wire("load", "alt")
    wire("alt", "altface")
    wire("colors", "altface")
    obj("pre_alt", "prepend alt")
    wire("alt", "pre_alt")
    wire("pre_alt", "engine")
    obj("page", "js cuica_page.js " + " ".join(page_names), outs=0)
    wire("mpe_page", "page")
    obj("colors", "live.colors", outs=2)
    add(id="msg_colors", maxclass="message", text="everything", numinlets=2, numoutlets=1, outlettype=[""],
        patching_rect=[300, 570, 70, 22])
    wire("load", "msg_colors", 0)
    wire("msg_colors", "colors")
    wire("colors", "view")
    wire("colors", "msg_colors", 1)
    for text, col, w in HEADERS:
        add(id=f"hdr_{text}", maxclass="comment", text=text, numinlets=1, numoutlets=0, fontname="Ableton Sans Medium", fontsize=9.5,
            textjustification=1, textcolor=THEME["display_scale_text"],
            saved_attribute_attributes={"textcolor": {"expression": "themecolor.live_display_scale_text"}}, **pres([CX[col] - 2, 62, w + 4, 14]))
    add(id="unit_tune", maxclass="comment", text="st", numinlets=1, numoutlets=0, fontname="Ableton Sans Medium", fontsize=9.5,
        textjustification=1, textcolor=THEME["display_scale_text"],
        saved_attribute_attributes={"textcolor": {"expression": "themecolor.live_display_scale_text"}}, **pres([CX[0] - 2, 100, 52, 14]))

    for (vid, long_, lo, hi, init, unit, units, expo, param, scale, kind, rect, info) in DIALS:
        extra = {}
        if kind == "dial":
            cls = dict(maxclass="live.dial", numinlets=1, numoutlets=2, outlettype=["", "float"])
        else:
            cls = dict(maxclass="live.numbox", numinlets=1, numoutlets=1, outlettype=["float"], appearance=4)
            themed(extra, lcdcolor="lcd_control_fg")
            extra["lcdbgcolor"] = [0, 0, 0, 0]
            if kind == "box":
                themed(extra, bordercolor="lcd_control_fg")
                extra["fontname"], extra["fontsize"] = "Ableton Sans Medium", 9.0
            else:
                extra["bordercolor"] = [0, 0, 0, 0]
                extra["fontname"], extra["fontsize"] = "Ableton Sans Medium", 20.0
        vo = valueof(long_, long_, lo, hi, init, unit, exponent=expo, units=units)
        if unit == INT:
            vo["parameter_type"] = 1
        saa = extra.pop("saved_attribute_attributes", {})
        saa["valueof"] = vo
        add(id=vid, varname=vid, parameter_enable=1, annotation_name=long_, annotation=info,
            saved_attribute_attributes=saa, **cls, **extra, **pres(rect))
        if kind == "box":   # the orange outline (live.numbox's own border isn't drawn in every theme)
            add(id=f"ol_{vid}", maxclass="panel", numinlets=1, numoutlets=0, mode=0, border=1, rounded=2, bgfillcolor=[0, 0, 0, 0],
                bordercolor=THEME["lcd_control_fg"], saved_attribute_attributes={"bordercolor": {"expression": "themecolor.live_lcd_control_fg"}},
                **pres(rect))
        nxt = vid
        if scale != 1:
            obj(f"sc_{vid}", f"* {scale}")
            wire(vid, f"sc_{vid}")
            nxt = f"sc_{vid}"
        obj(f"pre_{vid}", f"prepend {param}")
        wire(nxt, f"pre_{vid}")
        wire(f"pre_{vid}", "engine")
        wire("load", vid)
    # Push 3 screen (cuica_push.js on push_kit.js)
    pk = PS.add(boxes, lines, "cuica_push.js", "thisdev")
    wire("midi", pk, 1)                      # hit <note> <velocity>
    obj("mw_route", "route mw", outs=2)
    obj("mw_pre", "prepend mwheel")
    wire("midi", "mw_route")
    wire("mw_route", "mw_pre")
    wire("mw_pre", pk)
    params = {p for p, _ in E.PARAMS}
    wired = {b["box"]["text"].split()[1] for b in boxes if b["box"].get("text", "").startswith("prepend ")}
    assert params - {"nt", "vl", "hold", "lg", "tr", "mw", "bend", "pr", "sl", "pbn"} <= wired | {"pram", "sld", "alt"}, f"engine params without a control: {params - wired}"
    patcher = {
        "fileversion": 1,
        "appversion": {"major": 9, "minor": 0, "revision": 0, "architecture": "x64", "modernui": 1},
        "classnamespace": "box", "rect": [60.0, 60.0, 1900.0, 1300.0],
        "openrect": [0.0, 0.0, float(WIDTH), DEVICE_H], "openinpresentation": 1, "is_mpe": 1,   # Live sends MPE (per-note channels)
        "devicewidth": float(WIDTH),
        "default_fontname": "Ableton Sans Medium", "default_fontsize": 9.0, "gridsize": [8.0, 8.0],
        "description": "Cuica: a Brazilian friction drum (bowed rod and membrane) with strokes, pull, scoop and a thumb on the mod wheel.",
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
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "m4l", "Cuica.maxpat")
    json.dump(build(), open(out, "w"), indent="\t")
    PS.copy_kit(os.path.dirname(os.path.abspath(out)))
