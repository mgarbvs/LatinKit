#!/usr/bin/env python3
"""make_kit.py -- install the Latin percussion voice devices (Conga Voice, Bongo, Guiro, Shaker, Cuica, Timbales, Agogo, Surdo, Repinique, Pandeiro, Caxixi, Ganza, CR78 <voice>) and write a Drum Rack preset:

    <dest>/Presets/Instruments/Max Instrument/Latin/        the .amxd devices + their js (they find their files next to them)
    <dest>/Presets/Instruments/Drum Rack/Latin/Latin Kit.adg   the pads in PADS below, from C1 (36) up

    python3 LatinKit/make_kit.py [--dest "<User Library>"]      (default ~/Music/Ableton/User Library)

The .adg format and the device XML are in drum_rack.py; templates/*.xml were written by Live. The built devices are in the
repo; after changing one, rebuild it with its build.sh.
"""
import argparse
import glob
import os
import re
import shutil
import sys

LK = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, LK)
import drum_rack as P  # noqa: E402

# device -> its project folder (the .amxd, its generated .maxpat and its js are in <folder>/m4l)
DEVICES = {"Conga Voice": "Conga", "Bongo": "Bongo", "Guiro": "Guiro", "Shaker": "Shaker", "Cuica": "Cuica", "Timbales": "Timbales", **{d: d for d in ("Agogo", "Surdo", "Repinique", "Pandeiro", "Caxixi", "Ganza")}, **{f"CR78 {v}": "CR78" for v in
           ("Kick", "Snare", "Rim", "Clave", "Bongo", "Conga", "Hat", "Cymbal", "Maracas", "Metal", "Cowbell", "Tamb", "Guiro")}}

# pad name, device, {parameter long name: value} (the rest stay at their defaults), choke group
# The strokes of one drum share a choke group: in one device a new stroke damps the ring already on the head; across pads the
# choke stands in for that hand.
PADS = [
    ("Tumba Open", "Conga Voice", {"Drum": 2, "Stroke": 0}, 1),
    ("Tumba Slap", "Conga Voice", {"Drum": 2, "Stroke": 1}, 1),
    ("Conga Open", "Conga Voice", {"Drum": 1, "Stroke": 0}, 2),
    ("Conga Slap", "Conga Voice", {"Drum": 1, "Stroke": 1}, 2),
    ("Conga Mute", "Conga Voice", {"Drum": 1, "Stroke": 2}, 2),
    ("Conga Heel", "Conga Voice", {"Drum": 1, "Stroke": 4}, 2),
    ("Conga Toe", "Conga Voice", {"Drum": 1, "Stroke": 5}, 2),
    ("Quinto Open", "Conga Voice", {"Drum": 0, "Stroke": 0}, 3),
    ("Quinto Slap", "Conga Voice", {"Drum": 0, "Stroke": 1}, 3),
    ("Bongo Hi", "CR78 Bongo", {"Bongo": 0}, 0),
    ("Bongo Lo", "CR78 Bongo", {"Bongo": 1}, 0),
    ("Clave", "CR78 Clave", {}, 0),
    ("Cowbell", "CR78 Cowbell", {}, 0),
    ("Guiro", "CR78 Guiro", {}, 0),
    ("Maraca", "Shaker", {"Type": 0, "Direction": 1}, 0),
    ("Cabasa", "Shaker", {"Type": 1, "Direction": 1}, 0),
    # pads play C3 (the pad's sending note), so Tune sets the cuica's pitch; Alt Auto = quick repeats alternate push / pull
    ("Cuica High", "Cuica", {"Tune": 5}, 4),
    ("Cuica Low", "Cuica", {"Tune": -7}, 4),
    # no choke: a cascara on the shell leaves the head ringing (the device's own stroke physics)
    ("Cascara Hi", "Timbales", {"Drum": 0, "Stroke": 2}, 0),
    ("Cascara Lo", "Timbales", {"Drum": 1, "Stroke": 2}, 0),
    ("Timbal Rimshot", "Timbales", {"Drum": 0, "Stroke": 1}, 0),
    ("Timbal Lo Open", "Timbales", {"Drum": 1, "Stroke": 0}, 0),
    ("Macho Open", "Bongo", {"Drum": 0, "Stroke": 0}, 5),
    ("Macho Slap", "Bongo", {"Drum": 0, "Stroke": 2}, 5),
    ("Hembra Open", "Bongo", {"Drum": 1, "Stroke": 0}, 6),
    ("Hembra Slap", "Bongo", {"Drum": 1, "Stroke": 2}, 6),
    # long-short-short = Guiro Long, Up, Down
    ("Guiro Long", "Guiro", {"Stroke": 3}, 0),
    ("Guiro Up", "Guiro", {"Stroke": 1}, 0),
    ("Guiro Down", "Guiro", {"Stroke": 2}, 0),
    # samba section: a mute damps its own bell/drum, so strokes of one instrument choke
    ("Agogo High", "Agogo", {"Bell": 0, "Stroke": 0}, 7),
    ("Agogo High Mute", "Agogo", {"Bell": 0, "Stroke": 1}, 7),
    ("Agogo Low", "Agogo", {"Bell": 1, "Stroke": 0}, 8),
    ("Surdo Open", "Surdo", {"Stroke": 0}, 9),
    ("Surdo Mute", "Surdo", {"Stroke": 1}, 9),
    ("Repinique Open", "Repinique", {"Stroke": 0}, 10),
    ("Repinique Rimshot", "Repinique", {"Stroke": 1}, 10),
    ("Repinique Hand", "Repinique", {"Stroke": 3}, 10),
    ("Pandeiro Thumb", "Pandeiro", {"Instrument": 0, "Stroke": 0}, 11),
    ("Pandeiro Slap", "Pandeiro", {"Instrument": 0, "Stroke": 2}, 11),
    ("Pandeiro Shake", "Pandeiro", {"Instrument": 0, "Stroke": 4}, 11),
    ("Tamborim Open", "Pandeiro", {"Instrument": 1, "Stroke": 6}, 12),
    ("Tamborim Mute", "Pandeiro", {"Instrument": 1, "Stroke": 7}, 12),
    ("Caxixi Open", "Caxixi", {"Stroke": 0}, 0),
    ("Caxixi Hand", "Caxixi", {"Stroke": 1}, 0),
    ("Ganza Forward", "Ganza", {"Type": 0, "Stroke": 2}, 0),
    ("Ganza Back", "Ganza", {"Type": 0, "Stroke": 3}, 0),
    ("Ganza Accent", "Ganza", {"Type": 0, "Stroke": 4}, 0),
    ("Reco Long", "Guiro", {"Type": 1, "Stroke": 3}, 0),
    ("Reco Up", "Guiro", {"Type": 1, "Stroke": 1}, 0),
    ("Reco Down", "Guiro", {"Type": 1, "Stroke": 2}, 0),
]


def stored(vo, x):
    """Live stores an exponent dial linear in knob travel (memory: live-exponent-param-storage), not in display units"""
    e = vo.get("parameter_exponent", 1)
    if e == 1:
        return x
    lo, hi = vo["parameter_mmin"], vo["parameter_mmax"]
    return lo + (hi - lo) * ((x - lo) / (hi - lo)) ** (1 / e)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dest", default=os.path.expanduser("~/Music/Ableton/User Library"))
    lib = ap.parse_args().dest
    dev = os.path.join(lib, "Presets", "Instruments", "Max Instrument", "Latin")
    os.makedirs(dev, exist_ok=True)
    for name in sorted({d for _, d, _, _ in PADS}):
        m4l = os.path.join(LK, DEVICES[name], "m4l")
        for f in [os.path.join(m4l, name + ".amxd")] + glob.glob(os.path.join(m4l, "*.js")):
            shutil.copy2(f, dev)
    t = os.path.join(LK, "templates")
    rack = open(os.path.join(t, "rack.xml")).read()
    pad = re.sub(r"<DrumCell Id=\"0\">.*</DrumCell>", "@@DEVICE@@", open(os.path.join(t, "pad.xml")).read(), flags=re.S)
    pad = pad.replace('<DeviceId Name="DrumCell" />', '<DeviceId Name="" />')
    out = []
    for i, (name, d, set_, choke) in enumerate(PADS):
        defs = P.params_of(os.path.join(LK, DEVICES[d], "m4l", d + ".maxpat"))
        vals = {v: defs[v]["parameter_initial"][0] for v in defs}
        by_long = {defs[v]["parameter_longname"]: v for v in defs}
        for k, x in set_.items():
            vals[by_long[k]] = x   # KeyError = a name in PADS that the device doesn't have
        vals = {v: stored(defs[v], x) for v, x in vals.items()}
        defs = {v: dict(vo, parameter_initial=[stored(vo, vo["parameter_initial"][0])]) for v, vo in defs.items()}
        out.append(pad.replace("@@DEVICE@@", P.device_xml(os.path.join(dev, d + ".amxd"), lib, defs, vals, top=False))
                   .replace("@@ID@@", str(i)).replace("@@NAME@@", P.q(name)).replace("@@NOTE@@", str(128 - (36 + i)))
                   .replace('<ChokeGroup Value="0" />', f'<ChokeGroup Value="{choke}" />'))
    path = os.path.join(lib, "Presets", "Instruments", "Drum Rack", "Latin", "Latin Kit.adg")
    P.write_gz(path, rack.replace("@@PADS@@", "".join(out)).replace('<UserName Value="Rattle Kit" />', '<UserName Value="Latin Kit" />'))
    print(f"Latin Kit: {len(PADS)} pads -> {path}")


if __name__ == "__main__":
    main()
