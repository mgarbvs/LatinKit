"""mx.py -- helpers to emit Max patcher JSON (boxes, lines, presentation rects, Live theme colours). Shared by build_voice.py."""
import json
import os
import sys


HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
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


def themed(kw, **attrs):
    saa = kw.setdefault("saved_attribute_attributes", {})
    for a, tok in attrs.items():
        kw[a] = THEME[tok]
        saa[a] = {"expression": f"themecolor.live_{tok}"}
    return kw


