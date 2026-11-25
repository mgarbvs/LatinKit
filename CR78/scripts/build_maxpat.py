#!/usr/bin/env python3
"""build_maxpat.py — emit m4l/CR78.maxpat, the Roland CR-78 voice board (source of truth; never hand-edit the output).

    notein -> cr_midi.js (note map, guiro gate, TRIG buttons) -> tr<n> / vl<n> / gt<n> -> gen~ (scripts/cr_engine.py) -> plugout~
    every live.* control -> [prepend <param>] -> gen~   (display units are engine units: no scaling stages)

Functional panel (the look comes in a later round): a vertical tab picks one of four pages of voice strips (DRUMS, LATIN, NOISE,
PERC); each strip is a name, TRIG button(s) and that voice's dials. Accent, Drive and Master are always visible on the right.
Boxes with a view condition are shown or hidden by cr_view.js. Boxes are emitted reversed so later boxes draw on top.
"""
import contextlib
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import cr_engine as E  # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DEVICE_H = 169.0
WIDTH = 904
COLX = [68, 420]            # x of the two strip columns
ROWY = [6, 88]              # y of the two strip rows
LABW, DW, DH = 60, 48, 56   # label column, dial pitch, dial height
GX = 782                    # global column
PCT, FLOAT, PAN = 5, 1, 6   # parameter_unitstyle

boxes, lines = [], []
VIEW = {}                      # varname -> {group: [allowed values]}
VIEW_DEFAULT = {"pg": 0}
_cond = {}


@contextlib.contextmanager
def view(**cond):
    prev = dict(_cond)
    _cond.update({g: [v] for g, v in cond.items()})
    yield
    _cond.clear()
    _cond.update(prev)


def add(**kw):
    if _cond and kw.get("presentation"):
        kw.setdefault("varname", kw["id"])
        VIEW[kw["varname"]] = {g: list(v) for g, v in _cond.items()}
        if any(VIEW_DEFAULT[g] not in v for g, v in _cond.items()):
            kw["hidden"] = 1
    boxes.append({"box": kw})
    return kw["id"]


def wire(src, dst, outlet=0, inlet=0):
    lines.append({"patchline": {"source": [src, outlet], "destination": [dst, inlet]}})


_row = [0]


def obj(bid, text, ins=1, outs=1, outtype=None, **kw):
    _row[0] += 1
    return add(id=bid, maxclass="newobj", text=text, numinlets=ins, numoutlets=outs,
               outlettype=outtype if outtype is not None else [""] * outs,
               patching_rect=[20 + (_row[0] // 40) * 260, 20 + (_row[0] % 40) * 30, max(40, 7 * len(text)), 22], **kw)


def pres(rect):
    _row[0] += 1
    return dict(presentation=1, presentation_rect=[float(v) for v in rect],
                patching_rect=[1600 + (_row[0] % 8) * 70, 20 + (_row[0] // 8) * 60, rect[2], rect[3]])


def label(bid, text, rect, size=9.5):
    return add(id=bid, maxclass="comment", text=text, numinlets=1, numoutlets=0, fontname="Ableton Sans Bold", fontsize=size,
               varname=bid, textcolor=[0.85, 0.85, 0.85, 1.0],
               saved_attribute_attributes={"textcolor": {"expression": "themecolor.live_control_fg"}}, **pres(rect))


def valueof(longname, short, lo, hi, init, unitstyle, ptype=0, enum=None, units=None):
    v = {"parameter_longname": longname, "parameter_shortname": short, "parameter_type": ptype,
         "parameter_mmin": float(lo), "parameter_mmax": float(hi),
         "parameter_initial_enable": 1, "parameter_initial": [init], "parameter_unitstyle": unitstyle}
    if enum:
        v["parameter_enum"] = enum
    if units:
        v["parameter_units"] = units
    return v


META = {n: (long_, short, lo, hi, d, kind, info) for n, long_, short, lo, hi, d, kind, info in E.PARAMS}


def control(name, x, y):
    """a live.dial (or, for kind "tog", a toggle live.text) for engine parameter `name`, wired to gen~"""
    long_, short, lo, hi, d, kind, info = META[name]
    if kind == "tog":
        add(id=name, varname=name, maxclass="live.text", numinlets=1, numoutlets=2, outlettype=["", ""], mode=1, text=short,
            texton=short, fontname="Ableton Sans Bold", fontsize=8.5, parameter_enable=1, annotation_name=long_, annotation=info,
            saved_attribute_attributes={"valueof": valueof(long_, short, 0, 1, d, 0, 2, ["off", "on"])},
            **pres([x + 2, y + 14, DW - 4, 26]))
    else:
        unit = {"pan": PAN}.get(kind, FLOAT)
        add(id=name, varname=name, maxclass="live.dial", numinlets=1, numoutlets=2, outlettype=["", "float"], parameter_enable=1,
            annotation_name=long_, annotation=info,
            saved_attribute_attributes={"valueof": valueof(long_, short, lo, hi, d, 9, units=E.UNITS[kind])}, **pres([x, y, DW, DH]))
        wire("loadbang_t", name, 2)
    obj(f"pre_{name}", f"prepend {name}")
    wire(name, f"pre_{name}")
    wire(f"pre_{name}", "engine")


def trig_button(bid, longname, text, rect, slot, info):
    """a TRIG button: pressing it sends a hit (velocity 100) for trigger slot `slot` through the MIDI script. A live.text button
    outputs a bang on press, so the bang and a 1 both fire the message."""
    add(id=bid, varname=bid, maxclass="live.text", numinlets=1, numoutlets=2, outlettype=["", ""], mode=0, text=text,
        fontname="Ableton Sans Bold", fontsize=8.5, parameter_enable=1, annotation_name=longname, annotation=info,
        saved_attribute_attributes={"valueof": valueof(longname, text, 0, 1, 0, 0, 2, ["off", "on"])}, **pres(rect))
    obj(f"sel_{bid}", "sel 1", ins=2, outs=2)
    obj(f"rb_{bid}", "route bang", outs=2)
    add(id=f"msg_{bid}", maxclass="message", text=f"trig {slot} 100", numinlets=2, numoutlets=1, outlettype=[""],
        patching_rect=[1200, 20, 80, 22])
    wire(bid, f"sel_{bid}")
    wire(bid, f"rb_{bid}")
    wire(f"sel_{bid}", f"msg_{bid}")
    wire(f"rb_{bid}", f"msg_{bid}")
    wire(f"msg_{bid}", "midi")


# pages -> strips -> (voice prefix, title, [controls]); the TRIG slot(s) come from E.SLOT
PAGES = [
    ("DRUMS", [("bd", "BASS DRUM", ["bdTune", "bdDec", "bdLvl", "bdPan"]),
               ("sd", "SNARE", ["sdTune", "sdDec", "sdNoise", "sdLvl", "sdPan"]),
               ("rs", "RIMSHOT", ["rsTune", "rsDec", "rsLvl", "rsPan"]),
               ("cl", "CLAVE", ["clTune", "clDec", "clLvl", "clPan"])]),
    ("LATIN", [("hb", "HIGH BONGO", ["hbTune", "hbDec", "hbLvl", "hbPan"]),
               ("lb", "LOW BONGO", ["lbTune", "lbDec", "lbLvl", "lbPan"]),
               ("lc", "LOW CONGA", ["lcTune", "lcDec", "lcLvl", "lcPan"])]),
    ("NOISE", [("hh", "HI-HAT", ["hhDec", "hatTone", "hhLvl", "hhPan"]),
               ("cy", "CYMBAL", ["cyDec", "cyLvl", "cyPan"]),
               ("ma", "MARACAS", ["maDec", "maLvl", "maPan"]),
               ("mb", "MET. BEAT", ["mbTune", "mbDec", "mbAmt", "mbHats", "mbLvl", "mbPan"])]),
    ("PERC", [("cb", "COWBELL", ["cbTune", "cbDec", "cbTone", "cbLvl", "cbPan"]),
              ("tb", "TAMBOURINE", ["tbDec", "tbTone", "tbShake", "tbLvl", "tbPan"]),
              ("gu", "GUIRO", ["guRate", "guTone", "guDec", "guLvl", "guPan"])]),
]
TITLE = {p: t for _, strips in PAGES for p, t, _ in strips}
NAME = {p: n for p, n, _ in E.SLOTS}


def tab(items, rect):
    long_ = "Page"
    info = "Chooses which voices' controls are shown. Every voice keeps playing; Accent, Drive and Master on the right are always visible."
    kw = dict(id="pgtab", maxclass="live.tab", varname="pgtab", numinlets=1, numoutlets=3, outlettype=["", "", "float"],
              num_lines_patching=len(items), num_lines_presentation=len(items), parameter_enable=1,
              annotation_name=long_, annotation=info, fontname="Ableton Sans Medium", fontsize=9.0, **pres(rect))
    kw["saved_attribute_attributes"] = {"valueof": dict(valueof(long_, "Page", 0, len(items) - 1, 0, 0, 2, items), parameter_invisible=1)}
    add(**kw)
    obj("pre_pgtab", "prepend pg")
    wire("pgtab", "pre_pgtab")
    wire("pre_pgtab", "view")


def build():
    code = E.gen_code()
    gen_patcher = {
        "fileversion": 1,
        "appversion": {"major": 9, "minor": 0, "revision": 0, "architecture": "x64", "modernui": 1},
        "classnamespace": "dsp.gen", "rect": [100.0, 100.0, 900.0, 900.0],
        "boxes": [{"box": {"id": "code", "maxclass": "codebox", "code": code, "fontface": 0,
                           "fontname": "<Monospaced>", "fontsize": 11.0, "numinlets": 2, "numoutlets": 2,
                           "outlettype": ["", ""], "patching_rect": [20.0, 60.0, 850.0, 800.0]}}]
                 + [{"box": {"id": f"in{i}", "maxclass": "newobj", "text": f"in {i}", "numinlets": 0, "numoutlets": 1,
                             "outlettype": [""], "patching_rect": [20.0 + 70 * i, 20.0, 40.0, 22.0]}} for i in (1, 2)]
                 + [{"box": {"id": f"out{i}", "maxclass": "newobj", "text": f"out {i}", "numinlets": 1,
                             "numoutlets": 0, "patching_rect": [20.0 + 70 * i, 870.0, 40.0, 22.0]}} for i in (1, 2)],
        "lines": [{"patchline": {"source": [f"in{i}", 0], "destination": ["code", i - 1]}} for i in (1, 2)]
                 + [{"patchline": {"source": ["code", i - 1], "destination": [f"out{i}", 0]}} for i in (1, 2)],
    }
    obj("view", "js cr_view.js")
    obj("thisdev", "live.thisdevice", outs=3, outtype=["bang", "int", "int"])
    obj("loadbang_t", "t b b b", outs=3)
    wire("thisdev", "loadbang_t")
    obj("plugin", "plugin~", ins=2, outs=2, outtype=["signal", "signal"])
    obj("engine", "gen~", ins=2, outs=2, outtype=["signal"] * 2, patcher=gen_patcher)
    obj("plugout", "plugout~", ins=2, outs=0)
    wire("plugin", "engine", 0, 0)
    wire("plugin", "engine", 1, 1)
    wire("engine", "plugout", 0, 0)
    wire("engine", "plugout", 1, 1)
    obj("notein", "notein", outs=3, outtype=["int", "int", "int"])
    obj("note_pack", "pack 0 0", ins=2)
    obj("midi", "js cr_midi.js")
    wire("notein", "note_pack", 0, 0)
    wire("notein", "note_pack", 1, 1)
    wire("note_pack", "midi")
    wire("midi", "engine")

    tab([n for n, _ in PAGES], [4, 6, 58, 156])
    for pg, (_, strips) in enumerate(PAGES):
        with view(pg=pg):
            for k, (p, title, ctrls) in enumerate(strips):
                x0, y0 = COLX[k % 2], ROWY[k // 2]
                label(f"lbl_{p}", title, [x0, y0, LABW, 14], size=9)
                if p == "gu":
                    for j, (s, t) in enumerate((("guH", "H"), ("guL", "L"))):
                        trig_button(f"{s}Trig", f"{NAME[s]} Trigger", t, [x0 + j * 28, y0 + 18, 26, 16], E.SLOT[s],
                                    f"Plays the {NAME[s].lower()} guiro stroke for about 0.3 s (a MIDI note runs it for as long as it is held).")
                else:
                    trig_button(f"{p}Trig", f"{NAME[p]} Trigger", "TRIG", [x0, y0 + 18, 54, 16], E.SLOT[p],
                                f"Plays {NAME[p].lower()} (velocity 100), like its MIDI note.")
                for j, name in enumerate(ctrls):
                    control(name, x0 + LABW + j * DW, y0)
    control("accent", GX, ROWY[0])
    control("master", GX + DW, ROWY[0])
    control("drive", GX, ROWY[1])

    patcher = {
        "fileversion": 1,
        "appversion": {"major": 9, "minor": 0, "revision": 0, "architecture": "x64", "modernui": 1},
        "classnamespace": "box", "rect": [60.0, 60.0, 1900.0, 1300.0],
        "openrect": [0.0, 0.0, float(WIDTH), DEVICE_H], "openinpresentation": 1, "devicewidth": float(WIDTH),
        "default_fontname": "Ableton Sans Medium", "default_fontsize": 9.0, "gridsize": [8.0, 8.0],
        "description": "CR78: the Roland CR-78 voice board: bass drum, snare, rimshot, clave, bongos, conga, cowbell, hi-hat, cymbal, maracas, tambourine, guiro and metallic beat.",
        "boxes": boxes[::-1], "lines": lines, "dependency_cache": [], "autosave": 0,
        "project": {
            "version": 1, "creationdate": 3871731238, "modificationdate": 3871731238,
            "viewrect": [0.0, 0.0, 300.0, 500.0], "autoorganize": 1, "hideprojectwindow": 1,
            "showdependencies": 1, "autolocalize": 0, "contents": {"patchers": {}}, "layout": {},
            "searchpath": {}, "detailsvisible": 0, "amxdtype": 1768515945, "readonly": 0,
            "devpathtype": 0, "devpath": ".", "sortmode": 0, "viewmode": 0, "includepackages": 0,
        },
    }
    wired = {b["box"]["text"].split()[1] for b in boxes if b["box"].get("text", "").startswith("prepend ") and b["box"]["id"] != "pre_pgtab"}
    missing = {n for n, _ in E.params()} - wired
    assert not missing, f"engine params without a control: {sorted(missing)}"
    return {"patcher": patcher}


VIEW_JS = """// cr_view.js -- shows / hides boxes as the page tab changes. GENERATED by scripts/build_maxpat.py: do not edit.
// Each "<group> <value>" message (from a tab) re-evaluates every box whose view condition mentions that group.
inlets = 1;
outlets = 1;
var VIEW = %s;
var STATE = %s;
function anything() {
    var v = arguments[0];
    if (v === undefined || !STATE.hasOwnProperty(messagename)) return;
    STATE[messagename] = Math.round(v);
    for (var name in VIEW) {
        var c = VIEW[name];
        if (!c.hasOwnProperty(messagename)) continue;
        var show = true;
        for (var g in c) if (c[g].indexOf(STATE[g]) < 0) { show = false; break; }
        var o = this.patcher.getnamed(name);
        if (o) o.hidden = !show;
    }
}
"""

MIDI_JS = """// cr_midi.js -- MIDI and the TRIG buttons to the CR78 engine. GENERATED by scripts/build_maxpat.py: do not edit.
// in: list <pitch> <velocity> (notein) | trig <slot> <velocity> (a TRIG button)
// out 0: vl<slot> <v 0..1> then tr<slot> <count>; the engine plays a slot whenever its counter changes (a counter, not a gate, so a
// note-off and the next note-on in one audio block can't swallow the hit). The two guiro slots also get gt<slot> 1 / 0: the note is held.
// Slots: 0 BD 36, 1 RS 37, 2 SD 38, 3 HH 42, 4 MB 44, 5 CY 49, 6 Tb 54, 7 CB 56, 8 HB 60, 9 LB 61, 10 LC 64, 11 M 70, 12 GU short 73, 13 GU long 74, 14 C 75.
inlets = 1;
outlets = 1;
var NOTE = %s;
var GUIRO = {12: 1, 13: 1};
var count = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
var tasks = {};

function hit(slot, vel) {
    count[slot] = (count[slot] + 1) %% 65536;
    if (GUIRO[slot]) outlet(0, "gt" + slot, 1);
    outlet(0, "vl" + slot, Math.max(0.01, Math.min(1, vel / 127)));
    outlet(0, "tr" + slot, count[slot]);
}

function release(slot) { outlet(0, "gt" + slot, 0); }

function trig(slot, vel) {
    hit(slot, vel);
    if (GUIRO[slot]) {   // a button has no note length: hold the stroke for 0.3 s
        if (!tasks[slot]) tasks[slot] = new Task(release, this, slot);
        tasks[slot].cancel();
        tasks[slot].schedule(300);
    }
}

function list(p, v) {
    for (var s = 0; s < NOTE.length; s++) {
        if (NOTE[s] !== p) continue;
        if (v > 0) hit(s, v);
        else if (GUIRO[s]) release(s);
    }
}
"""

if __name__ == "__main__":
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "m4l", "CR78.maxpat")
    doc = build()
    with open(out, "w") as f:
        json.dump(doc, f, indent="\t")
    d = os.path.dirname(os.path.abspath(out))
    with open(os.path.join(d, "cr_view.js"), "w") as f:
        f.write(VIEW_JS % (json.dumps(VIEW), json.dumps(VIEW_DEFAULT)))
    with open(os.path.join(d, "cr_midi.js"), "w") as f:
        f.write(MIDI_JS % json.dumps([n for _, _, n in E.SLOTS]))
