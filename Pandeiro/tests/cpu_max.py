"""cpu_max.py [device.amxd ...] -- Max's CPU (percent of one core, from `top`, 5 s intervals) with the harness's DSP off, then on with each device loaded and idle (a gen~ costs the same
whether or not a note plays: it computes every sample). Default devices: m4l/Pandeiro.amxd and ../Bongo/m4l/Bongo.amxd (the engine this was forked from) for scale.

    python3 <withlock.py> uv run --directory $MAXTEST_DIR python $PWD/tests/cpu_max.py
"""
import os
import subprocess
import sys
import time

sys.path.insert(0, os.environ["MAXTEST_DIR"])
import server  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))


def max_cpu():
    pid = subprocess.run(["pgrep", "-f", "^/Applications/Max.app/Contents/MacOS/Max"], capture_output=True, text=True).stdout.split()[0]
    out = subprocess.run(["top", "-pid", pid, "-l", "3", "-s", "5", "-stats", "cpu"], capture_output=True, text=True).stdout.strip().splitlines()
    return float(out[-1])


devs = sys.argv[1:] or [os.path.join(HERE, "../m4l/Pandeiro.amxd"), os.path.join(HERE, "../../Bongo/m4l/Bongo.amxd")]
for d in devs:
    server.load_device(os.path.abspath(d))
    server.call([[0, "dsp", "stop"]], 500)
    time.sleep(2)
    off = max_cpu()
    server.call([[0, "dsp", "start"]], 1500)
    time.sleep(2)
    on = max_cpu()
    print(f"{os.path.basename(d)}: DSP off {off:.1f} %, DSP on {on:.1f} % of one core -> the device costs about {on - off:.1f} %")
