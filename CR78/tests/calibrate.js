// calibrate.js — prints the per-voice level trims (CAL in scripts/cr_engine.py): the factor that brings each voice's peak at
// default settings to its table amplitude. Noise voices use the median over 24 hits. Run, paste the printed CAL, rebuild, run again.
var M = require("./cr_measure.js");
var VPP = { bd: 0.4, sd: 0.4, rs: 0.8, hh: 0.4, cy: 0.4, ma: 0.4, cl: 0.15, hb: 0.15, lb: 0.15, lc: 0.3, cb: 0.2, tb: 0.25, guH: 0.3, mb: 0.35 };
var cal = {}, cur = require("child_process").execSync("python3 -c \"import sys;sys.path.insert(0,'" + __dirname + "/../scripts');import cr_engine as E;print(E.CAL)\"", { encoding: "utf8" });
cur = JSON.parse(cur.replace(/'/g, '"'));
Object.keys(VPP).forEach(function (v) {
    var slot = v, key = v === "guH" ? "gu" : v;
    var noisy = ["sd", "hh", "cy", "ma", "tb", "guH"].indexOf(v) >= 0;
    var pk = M.peakLevel(slot, {}, noisy ? 24 : 2, noisy ? 0.6 : 0.5, v === "guH" ? 0.3 : 0);
    cal[key] = +(cur[key] * VPP[v] / pk).toFixed(4);
    console.log(v + ": peak " + pk.toFixed(4) + " (want " + VPP[v] + ") -> CAL " + cal[key]);
});
console.log("CAL = " + JSON.stringify(cal).replace(/"/g, '"'));
