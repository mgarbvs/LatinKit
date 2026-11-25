#!/usr/bin/env python3
"""build_voices.py — emit m4l/CR78 <Name>.maxpat for each of the 13 single-voice devices (source of truth; never hand-edit the output).

One CR-78 voice as its own instrument, for Drum Rack pads: any MIDI note plays it, velocity is the accent. The same voice code as CR78
(scripts/cr_engine.py voice_code()); a gen~ holds only that voice. Styled after Ableton's Drum Synth devices and Shaker: a dark LCD panel
with an orange line drawing (m4l/cr_voice_view.js), orange value boxes / menus, a strip of three live.dials under it.

    notein -> pack -> cr_voice_midi.js <slots> -> gen~ (cr_engine.voice_code)  ;  every control -> [prepend <param>] -> gen~
    python3 scripts/build_voices.py [outdir]        # default m4l/
    python3 scripts/build_voices.py --params        # every device's parameters and ranges
"""
import json
import os
import sys

HERE_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE_DIR)
import build_maxpat as B  # noqa: E402  (its box / wire helpers; state reset per device)
import cr_engine as E  # noqa: E402
sys.path.insert(0, os.path.join(HERE_DIR, "..", "..", "..", "MaxForLiveTools"))
import push_screen as PS  # noqa: E402

HERE = B.HERE
WIDTH, DEVICE_H = 180, 169.0
THEME = {"lcd_bg": [0.1098, 0.1216, 0.1569, 1], "lcd_control_fg": [1, 0.6784, 0.3373, 1],
         "display_scale_text": [0.6824, 0.6863, 0.7137, 1]}
UNITS = {"st": "%+.2f st", "oct": "%+.2f oct", "pct": "%.0f %"}
BOXUNITS = {"st": "%+.1f st", "oct": "%+.1f oct", "pct": "%.0f %"}
META = B.META
DB, CUSTOM = 4, 9    # parameter_unitstyle

def ctl(kind, label, *names, info=None, items=None):
    """kind: dial = a live.dial in the bottom strip, box = orange-outlined value box, menu = the big orange word (items).
    names: the engine params it sets ("vol" = the Volume in dB); a menu with none picks the note's slot in the js instead"""
    return dict(kind=kind, label=label, names=list(names), info=info, items=items)


VOL_INFO = ("Output level in dB. 0 dB is the factory level of this voice (the service notes' amplitude: what the full CR78 plays at Level's default, "
            "before its pan law; Live's meter reads about 3 dB lower than the sample peak). Down to -36 dB, up to +6 dB.")
ACC_INFO = "How much velocity lifts or lowers a hit, like the accent stage of the board. 0 = every hit equal; 100 = level follows velocity (velocity 100 is the factory level)."
DRIVE_INFO = "Transistor-style saturation on the ringing oscillator. 0 = clean."
HAT_TONE = "The LC band-pass the noise rings in: its centre moves up to an octave either way. 0 is the fitted 8.7 kHz (the scan does not show the factory value)."
VOL = ctl("dial", "Volume", "vol", info=VOL_INFO)
ACC, DRV = ctl("box", "Accent", "accent", info=ACC_INFO), ctl("box", "Drive", "drive", info=DRIVE_INFO)


def dials(p):
    return [ctl("dial", "Tune", p + "Tune"), ctl("dial", "Decay", p + "Dec"), VOL]


def hats(p):
    return [ctl("dial", "Tone", "hatTone", info=HAT_TONE), ctl("dial", "Decay", p + "Dec"), VOL, ACC]


# name, view drawing, voices (cr_engine prefixes), controls (the three dials first, in order), the notes' slots (cr_voice_midi.js), description
DEVICES = [
    ("Kick", "kick", ["bd"], dials("bd") + [ACC, DRV], [0], "bass drum"),
    ("Snare", "snare", ["sd"], dials("sd") + [ctl("box", "Noise", "sdNoise"), ACC, DRV], [2], "snare drum"),
    ("Rim", "rim", ["rs"], dials("rs") + [ACC], [1], "rimshot"),
    ("Clave", "clave", ["cl"], dials("cl") + [ACC], [14], "claves"),
    ("Bongo", "bongo", ["hb", "lb"],
     [ctl("dial", "Tune", "hbTune", "lbTune"), ctl("dial", "Decay", "hbDec", "lbDec"), VOL,
      ctl("menu", "Bongo", items=["High", "Low"], info="Which bongo a note plays: the high one (600 Hz) or the low one (400 Hz). The ringing tail of the other one is not cut."),
      ACC, DRV], [8, 9], "high and low bongo"),
    ("Conga", "conga", ["lc"], dials("lc") + [ACC, DRV], [10], "low conga"),
    ("Hat", "hat", ["hh"], hats("hh"), [3], "hi-hat"),
    ("Cymbal", "cymbal", ["cy"], hats("cy"), [5], "cymbal"),
    ("Maracas", "maracas", ["ma"], hats("ma"), [11], "maracas"),
    ("Metal", "metal", ["mb"], dials("mb") + [ACC], [4], "metallic beat"),
    ("Cowbell", "cowbell", ["cb"], dials("cb") + [ctl("box", "Tone", "cbTone"), ACC], [7], "cowbell"),
    ("Tamb", "tamb", ["tb"], [ctl("dial", "Tone", "tbTone"), ctl("dial", "Decay", "tbDec"), VOL, ctl("menu", "Shake", "tbShake", items=["Off", "On"]), ACC],
     [6], "tambourine"),
    ("Guiro", "guiro", ["gu"],
     [ctl("dial", "Rate", "guRate"), ctl("dial", "Decay", "guDec"), VOL,
      ctl("menu", "Stroke", items=["Short", "Long"], info="Which note of the board a hit plays: the short guiro (125 Hz pulses) or the long one (77 Hz). It runs for as long as the note is held (at most 1 s)."),
      ctl("box", "Tone", "guTone"), ACC], [12, 13], "guiro"),
]


def push_bank(dev):
    """The one baked Push page (8 encoders): main tone control, Decay, the voice's extras, then Drive / Accent / Volume always at 5 / 6 / 7
    (cr_voice_push.js lays its pictures out by the same rule and checks this in tests/test_push.js)"""
    labels = [c["label"] for c in dev[3]]
    main = [labels[0], "Decay"]
    extra = [l for l in labels[2:] if l not in ("Volume", "Accent", "Drive")]
    return main + extra + ["-"] * (5 - len(main) - len(extra)) + ["Drive" if "Drive" in labels else "-", "Accent", "Volume"]


def range_of(c):
    """(lo, hi, default, unit key) of a dial / box, from its first engine param (Volume is ours)"""
    if c["names"] == ["vol"]:
        return -36, 6, 0, "db"
    _, _, lo, hi, d, k, _ = META[c["names"][0]]
    return lo, hi, d, k


def build(dev):
    name, voice, prefixes, controls, slots, what = dev
    B.boxes.clear()
    B.lines.clear()
    B._row[0] = 0
    add, wire, obj, pres, valueof = B.add, B.wire, B.obj, B.pres, B.valueof
    engine_names = [n for c in controls for n in c["names"] if n != "vol"]
    code = E.voice_code(prefixes, engine_names)
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

    def themed(kw, **attrs):
        saa = kw.setdefault("saved_attribute_attributes", {})
        for a, tok in attrs.items():
            kw[a] = THEME[tok]
            saa[a] = {"expression": f"themecolor.live_{tok}"}
        return kw

    # the LCD panel first: the box list is emitted reversed, so it draws underneath
    add(id="lcd", maxclass="panel", numinlets=1, numoutlets=0, mode=0, border=0, rounded=8, bgfillcolor=THEME["lcd_bg"],
        saved_attribute_attributes={"bgfillcolor": {"expression": "themecolor.live_lcd_bg"}}, **pres([4, 4, WIDTH - 8, 108]))
    obj("thisdev", "live.thisdevice", outs=3, outtype=["bang", "int", "int"])
    obj("load", "t b", outs=1)
    wire("thisdev", "load")
    obj("plugin", "plugin~", ins=2, outs=2, outtype=["signal", "signal"])
    obj("engine", "gen~", ins=2, outs=2, outtype=["signal"] * 2, patcher=gen_patcher)
    obj("plugout", "plugout~", ins=2, outs=0)
    wire("plugin", "engine", 0, 0)
    wire("plugin", "engine", 1, 1)
    wire("engine", "plugout", 0, 0)
    wire("engine", "plugout", 1, 1)
    obj("notein", "notein", outs=3, outtype=["int", "int", "int"])
    obj("note_pack", "pack 0 0", ins=2)
    obj("midi", "js cr_voice_midi.js " + " ".join(str(s) for s in slots), outs=2)
    wire("notein", "note_pack", 0, 0)
    wire("notein", "note_pack", 1, 1)
    wire("note_pack", "midi")
    wire("midi", "engine")
    pk = PS.add(B.boxes, B.lines, "cr_voice_push.js " + voice, "thisdev")   # Push 3 screen (cr_voice_push.js on push_kit.js)
    wire("midi", pk, 1)   # hit <note> <velocity>

    add(id="view", varname="view", maxclass="jsui", numinlets=1, numoutlets=0, filename="cr_voice_view.js", border=0, parameter_enable=0,
        jsarguments=[voice], annotation_name=name, annotation=f"The {what}: the last note, and a flash with every hit.", **pres([8, 8, WIDTH - 16, 48]))
    wire("midi", "view", 1)
    obj("colors", "live.colors", outs=2)
    add(id="msg_colors", maxclass="message", text="everything", numinlets=2, numoutlets=1, outlettype=[""], patching_rect=[300, 570, 70, 22])
    wire("load", "msg_colors", 0)
    wire("msg_colors", "colors")
    wire("colors", "view")
    wire("colors", "msg_colors", 1)

    # the three dials, then the boxes / menus in one centred row, each under a header
    dials = [c for c in controls if c["kind"] == "dial"]
    upper = [c for c in controls if c["kind"] != "dial"]
    wid = [52 if c["kind"] == "menu" else 48 for c in upper]
    x = (WIDTH - sum(wid) - 8 * (len(wid) - 1)) / 2
    rect = {}
    for i, c in enumerate(dials):
        rect[c["label"]] = [60 * i, 116, 60, 50]
    for c, w in zip(upper, wid):
        rect[c["label"]] = [x, 82, w, 22]
        x += w + 8
    for c in controls:
        kind, label, names = c["kind"], c["label"], c["names"]
        vid, r, extra = label.lower(), rect[label], {}
        if kind == "menu":
            items = c["items"]
            cls = dict(maxclass="live.menu", numinlets=1, numoutlets=3, outlettype=["", "", "float"], appearance=1)
            themed(extra, lcdcolor="lcd_control_fg")
            extra["lcdbgcolor"] = [0, 0, 0, 0]
            extra["fontname"], extra["fontsize"] = "Ableton Sans Medium", 11.0
            vo = {"parameter_longname": label, "parameter_shortname": label, "parameter_type": 2, "parameter_enum": items,
                  "parameter_mmax": len(items) - 1, "parameter_initial_enable": 1, "parameter_initial": [0]}
            info = c["info"] or META[names[0]][6]
        else:
            lo, hi, d, k = range_of(c)
            info = c["info"] or META[names[0]][6]
            vo = valueof(label, label, lo, hi, d, DB) if k == "db" else valueof(label, label, lo, hi, d, CUSTOM, units=(BOXUNITS if kind == "box" else UNITS)[k])
            if kind == "dial":
                cls = dict(maxclass="live.dial", numinlets=1, numoutlets=2, outlettype=["", "float"])
            else:
                cls = dict(maxclass="live.numbox", numinlets=1, numoutlets=1, outlettype=["float"], appearance=4)
                themed(extra, lcdcolor="lcd_control_fg")
                themed(extra, bordercolor="lcd_control_fg")
                extra["lcdbgcolor"] = [0, 0, 0, 0]
                extra["fontname"], extra["fontsize"] = "Ableton Sans Medium", 10.0
        saa = extra.pop("saved_attribute_attributes", {})
        saa["valueof"] = vo
        add(id=vid, varname=vid, parameter_enable=1, annotation_name=label, annotation=info, saved_attribute_attributes=saa, **cls, **extra, **pres(r))
        if kind != "dial":
            add(id=f"hdr_{vid}", maxclass="comment", text=label, numinlets=1, numoutlets=0, fontname="Ableton Sans Medium", fontsize=9.5,
                textjustification=1, textcolor=THEME["display_scale_text"],
                saved_attribute_attributes={"textcolor": {"expression": "themecolor.live_display_scale_text"}}, **pres([r[0] - 2, 66, r[2] + 4, 14]))
        if kind == "box":   # the orange outline (live.numbox's own border isn't drawn in every theme)
            add(id=f"ol_{vid}", maxclass="panel", numinlets=1, numoutlets=0, mode=0, border=1, rounded=2, bgfillcolor=[0, 0, 0, 0],
                bordercolor=THEME["lcd_control_fg"], saved_attribute_attributes={"bordercolor": {"expression": "themecolor.live_lcd_control_fg"}},
                **pres(r))
        if kind == "menu" and not names:   # which note's slot the js plays, and which one the drawing shows
            for dest, msg in (("midi", "pick"), ("view", "variant")):
                obj(f"pre_{vid}_{msg}", f"prepend {msg}")
                wire(vid, f"pre_{vid}_{msg}")
                wire(f"pre_{vid}_{msg}", dest)
        for n in names:   # the value goes to every engine param it sets
            obj(f"pre_{vid}_{n}", f"prepend {n}")
            wire(vid, f"pre_{vid}_{n}")
            wire(f"pre_{vid}_{n}", "engine")
        wire("load", vid)
    wired = {b["box"]["text"].split()[1] for b in B.boxes if b["box"].get("text", "").startswith("prepend ")}
    missing = (set(engine_names) | {"vol"}) - wired
    assert not missing, f"{name}: engine params without a control: {sorted(missing)}"
    patcher = {
        "fileversion": 1,
        "appversion": {"major": 9, "minor": 0, "revision": 0, "architecture": "x64", "modernui": 1},
        "classnamespace": "box", "rect": [60.0, 60.0, 1900.0, 1300.0],
        "openrect": [0.0, 0.0, float(WIDTH), DEVICE_H], "openinpresentation": 1, "devicewidth": float(WIDTH),
        "default_fontname": "Ableton Sans Medium", "default_fontsize": 9.0, "gridsize": [8.0, 8.0],
        "description": f"CR78 {name}: the Roland CR-78 {what} as its own instrument, for Drum Rack pads. Any note plays it; velocity is the accent.",
        "boxes": B.boxes[::-1], "lines": B.lines, "dependency_cache": [], "autosave": 0,
        "parameters": PS.banks(B.boxes, [("Voice", push_bank(dev))]),
        "project": {
            "version": 1, "creationdate": 3871731238, "modificationdate": 3871731238,
            "viewrect": [0.0, 0.0, 300.0, 500.0], "autoorganize": 1, "hideprojectwindow": 1,
            "showdependencies": 1, "autolocalize": 0, "contents": {"patchers": {}}, "layout": {},
            "searchpath": {}, "detailsvisible": 0, "amxdtype": 1768515945, "readonly": 0,
            "devpathtype": 0, "devpath": ".", "sortmode": 0, "viewmode": 0, "includepackages": 0,
        },
    }
    return {"patcher": patcher}


def listing():
    """every device's live parameters: name, range, default, units"""
    out = []
    for name, _, _, controls, _, _ in DEVICES:
        for c in controls:
            if c["kind"] == "menu":
                out.append(f"CR78 {name}: {c['label']}  menu {'/'.join(c['items'])}  default {c['items'][0]}")
            else:
                lo, hi, d, k = range_of(c)
                out.append(f"CR78 {name}: {c['label']}  {lo:g} .. {hi:g}  default {d:g}  {'dB' if k == 'db' else UNITS[k].split()[-1].replace('%', 'percent')}")
    return "\n".join(out)


if __name__ == "__main__":
    if "--push-banks" in sys.argv:
        print(json.dumps({d[1]: push_bank(d) for d in DEVICES}))
        sys.exit(0)
    if "--params" in sys.argv:
        print(listing())
        sys.exit(0)
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "m4l")
    for dev in DEVICES:
        with open(os.path.join(out, f"CR78 {dev[0]}.maxpat"), "w") as f:
            json.dump(build(dev), f, indent="\t")
    PS.copy_kit(out)
