// calibrate.js [--write] — prints CAL (scripts/guiro_engine.py): the per Type x stroke trim that puts the 10 ms RMS peak of a velocity-1 stroke at
// Level 0 dB at TARGET. Mean of 16 strokes (the noise makes each differ). Run with --write until it prints peaks of 0.2500.
var M = require("./guiro_measure.js"), cp = require("child_process"), path = require("path"), fs = require("fs");
var info = JSON.parse(cp.execFileSync("python3", ["-c", "import sys,json;sys.path.insert(0,'" + path.join(__dirname, "../scripts") +
    "');import guiro_engine as E;print(json.dumps({'cal':E.CAL,'target':E.TARGET,'names':E.NAMES}))"], { encoding: "utf8" }));
var cal = {};
info.names.forEach(function (name, ty) {
    cal[name] = [];
    [0, 1, 2, 3].forEach(function (stk) {
        var list = [];
        for (var k = 0; k < 16; k++) {
            var e = M.engine({ type: ty, vol: -40, pan: -1 });   // quiet: the engine clamps at +-1, and an uncalibrated stroke is far louder
            for (var j = 0; j < k * 7919 + 13; j++) e.st.noise();
            e.st.vl = 1; e.st.stk = stk; e.st.tr = 1;
            var n = Math.round(0.9 * M.SR), x = new Float64Array(n);
            for (var i = 0; i < n; i++) { e.tick(); x[i] = e.st.out1; }
            list.push(M.measure(x).peak * 100);   // back to Level 0 dB
        }
        var pk = list.reduce(function (a, b) { return a + b; }, 0) / list.length;
        cal[name].push(+(info.cal[name][stk] * info.target / pk).toFixed(4));
        console.log(name + " stroke " + stk + ": 10 ms RMS peak " + pk.toFixed(4) + " (want " + info.target + ") -> CAL " + cal[name][stk]);
    });
});
if (process.argv.indexOf("--write") >= 0) {
    var f = path.join(__dirname, "../scripts/guiro_engine.py"), s = fs.readFileSync(f, "utf8");
    s = s.replace(/^CAL = \{.*\}$/m, "CAL = " + JSON.stringify(cal).replace(/:/g, ": ").replace(/,(?=")/g, ", "));
    fs.writeFileSync(f, s);
    console.log("CAL written to " + f);
}
