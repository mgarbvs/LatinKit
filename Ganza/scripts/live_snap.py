"""live_snap.py <device.maxpat> <out.png> [varname=value ...] [region=x0-x1] — build a temp copy
of the device (the named controls/tabs start at the given values; region keeps one slice), load it into the running Live (LiveTestMCP
harness, "LT DUT" track), show it in the device view and screenshot just the device. Design aid.

    uv run --with pillow --directory ../../LiveTestMCP python $PWD/scripts/live_snap.py $PWD/m4l/Wavetable.maxpat out.png osctab=1
"""
import glob
import json
import os
import shutil
import subprocess
import sys
import tempfile
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "../../../LiveTestMCP"))
sys.path.insert(0, os.path.join(HERE, "../../../MaxForLiveTools"))
import server  # noqa: E402
from build_amxd import build_amxd  # noqa: E402
from PIL import Image  # noqa: E402

src, out = os.path.abspath(sys.argv[1]), os.path.abspath(sys.argv[2])
sets = dict(a.split("=") for a in sys.argv[3:])
region = sets.pop("region", None)   # region=x0-x1: only that slice of the panel (Live scrolls a wide
doc = json.load(open(src))          # device chain, cutting off its left edge on narrow screens)
if region:
    x0, x1 = map(float, region.split("-"))
    for b in doc["patcher"]["boxes"]:
        r = b["box"].get("presentation_rect")
        if r and b["box"].get("presentation"):
            if r[0] + r[2] <= x0 or r[0] >= x1:
                b["box"]["presentation"] = 0
            else:
                r[0] -= x0
    doc["patcher"]["devicewidth"] = x1 - x0
    doc["patcher"]["openrect"][2] = x1 - x0
flash = sets.pop("flash", None)   # flash=0.2: hold the display's note-on flash at that alpha
for b in doc["patcher"]["boxes"]:
    if flash and b["box"].get("varname") == "view":
        b["box"]["jsarguments"] = [float(flash)]
    vo = b["box"].get("saved_attribute_attributes", {}).get("valueof")
    if b["box"].get("varname") in sets and vo:
        vo["parameter_initial"] = [float(sets[b["box"]["varname"]])]
tmp = tempfile.mkdtemp()
for f in glob.glob(os.path.join(os.path.dirname(src), "*.js")) + glob.glob(os.path.join(os.path.dirname(src), "*.wav")):
    shutil.copy(f, tmp)
name = os.path.splitext(os.path.basename(src))[0]
json.dump(doc, open(os.path.join(tmp, name + ".maxpat"), "w"))
build_amxd(os.path.join(tmp, name + ".maxpat"), os.path.join(tmp, name + ".amxd"), "iiii")
os.remove(os.path.join(tmp, name + ".maxpat"))
r = server.setup(os.path.join(tmp, name + ".amxd"), "instrument")
browser = server.live_exec(f"""
import Live
t = [t for t in song.tracks if t.name == "LT DUT"][0]
song.view.selected_track = t
song.view.select_device([d for d in t.devices if d.name == {name!r}][0])
for i in reversed(range(len(t.devices))):   # harness devices aren't needed for a still picture
    if t.devices[i].name.startswith("LT_"):
        t.delete_device(i)
app = Live.Application.get_application().view
app.show_view("Detail/DeviceChain")
result = app.is_view_visible("Browser")
if result:
    app.hide_view("Browser")   # room for the whole chain; shown again after the capture
""")
time.sleep(1.5)
wins = subprocess.run([os.path.join(HERE, ".winid")], capture_output=True, text=True).stdout.splitlines()
wid = [w.split()[0] for w in wins if w.split()[1:2] == ["Live"] and not w.rstrip().endswith("|")][0]
subprocess.run(["screencapture", "-x", "-o", "-l", wid, out], check=True)
if browser:
    server.live_exec('import Live\nLive.Application.get_application().view.show_view("Browser")')
im = Image.open(out)
W, H = im.size
# ponytail: fixed crop of the device-view band for a full-height Live window (retina); find the
# band by color if the window layout changes
im.crop((0, H - 456, W, H - 66)).save(out)
print(out, "; console:", [l for l in r["console"] if "error" in l.lower()] or "clean")
shutil.rmtree(tmp)
