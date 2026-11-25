// render_strokes.js — docs/compare/ours_<Stroke>_<n>.wav: three draws of every stroke from the Node engine (velocity 1, Level 0 dB, mono), for compare.py
// (FX: three phrases through caxixi_midi.js at the defaults)
var M = require("./caxixi_measure.js"), S = require("./midi_sim.js"), path = require("path"), fs = require("fs");
var dir = path.join(__dirname, "../docs/compare"); fs.mkdirSync(dir, { recursive: true });
["Open", "Hand"].forEach(function (nm, ty) {
    for (var d = 0; d < 3; d++) {
        var e = M.engine({ type: ty, vol: 0, pan: -1 }); for (var j = 0; j < 13 + d * 7919; j++) e.st.noise();
        e.st.vl = 1; e.st.tr = 1;
        var n = Math.round(0.7 * M.SR), x = new Float64Array(n);
        for (var q = 0; q < n; q++) { e.tick(); x[q] = e.st.out1; }
        M.writeWav(path.join(dir, "ours_" + nm + "_" + d + ".wav"), [x], 0.8);
    }
});
for (var d = 0; d < 3; d++) {
    var J = S.load(101 * (d + 1)); J.c.strokemode(2);
    var ev = J.play(60, 127).map(function (e) { return { t: 0.01 + e.t, vel: e.vel }; });
    M.writeWav(path.join(dir, "ours_FX_" + d + ".wav"), [M.render({ type: 2, vol: 0, pan: -1 }, ev, 2.0).l], 0.8);
}
console.log("written to " + dir);
