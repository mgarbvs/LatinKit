// render_strokes.js — docs/compare/ours_<Type>_<Stroke>_<n>.wav: three draws of every stroke from the Node engine (velocity 1, Level 0 dB, mono), for compare.py
var M = require("./guiro_measure.js"), path = require("path"), fs = require("fs");
var dir = path.join(__dirname, "../docs/compare"); fs.mkdirSync(dir, { recursive: true });
["Guiro", "Recoreco"].forEach(function (nm, ty) {
    ["Up", "Down", "Long", "Top"].forEach(function (k, i) {
        for (var d = 0; d < 3; d++) {
            var e = M.engine({ type: ty, vol: 0, pan: -1 }); for (var j = 0; j < 13 + d * 7919; j++) e.st.noise();
            e.st.vl = 1; e.st.stk = i; e.st.tr = 1;
            var n = Math.round((k === "Long" ? 0.9 : 0.5) * M.SR), x = new Float64Array(n);
            for (var q = 0; q < n; q++) { e.tick(); x[q] = e.st.out1; }
            M.writeWav(path.join(dir, "ours_" + nm + "_" + k + "_" + d + ".wav"), [x], 0.8);
        }
    });
});
console.log("written to " + dir);
