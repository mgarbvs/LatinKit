// calibrate.js — prints CAL (scripts/caxixi_engine.py): the per-type trim that puts the 10 ms RMS peak of a forward stroke at velocity 1,
// Level 0 dB, at TARGET. Mean of 16 strokes (the noise makes each differ). Run, paste the printed CAL, rebuild, run again (it should print 1.000).
var M = require("./caxixi_measure.js"), cp = require("child_process"), path = require("path");
var info = JSON.parse(cp.execFileSync("python3", ["-c", "import sys,json;sys.path.insert(0,'" + path.join(__dirname, "../scripts") +
    "');import caxixi_engine as E;print(json.dumps({'cal':E.CAL,'target':E.TARGET,'names':E.NAMES}))"], { encoding: "utf8" }));
var cal = {};
info.names.forEach(function (name, ty) {
    var list = [];
    for (var k = 0; k < 16; k++) {
        var e = M.engine({ type: ty, vol: 0, pan: -1 });
        for (var j = 0; j < k * 7919 + 13; j++) e.st.noise();
        e.st.vl = 1; e.st.tr = 1;
        var n = Math.round(0.8 * M.SR), x = new Float64Array(n);
        for (var i = 0; i < n; i++) { e.tick(); x[i] = e.st.out1; }
        list.push(M.measure(x).peak);
    }
    var pk = list.reduce(function (a, b) { return a + b; }, 0) / list.length;
    cal[name] = +(info.cal[name] * info.target / pk).toFixed(4);
    console.log(name + ": 10 ms RMS peak " + pk.toFixed(4) + " (want " + info.target + ") -> CAL " + cal[name]);
});
console.log("CAL = " + JSON.stringify(cal));
if (process.argv.indexOf("--write") >= 0) {   // patch the CAL line of the engine in place
    var fs = require("fs"), f = path.join(__dirname, "../scripts/caxixi_engine.py"), s = fs.readFileSync(f, "utf8");
    s = s.replace(/^CAL = \{.*\}$/m, "CAL = " + JSON.stringify(cal).replace(/:/g, ": ").replace(/,/g, ", "));
    fs.writeFileSync(f, s);
    console.log("CAL written to " + f);
}
