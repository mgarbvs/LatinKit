// fit_refs.js [--write] [--ab] — ours vs the Ableton reference one-shots, per Type: rise / t20 / t30 (ms), spectral centroid, grain
// fluctuation (cvE early, cvL tail), the 9 octave-ish band levels (dB re the stroke's total) and the 1/3-octave spectral error.
//   --write  writes tests/refs.json (the measured reference ranges tests/test_engine.js holds the engine to; numbers only, no audio)
//   --ab     writes docs/types_ab.wav: for every reference file, the reference then ours (gitignored: contains Ableton's audio)
// Ours = Type at default settings, velocity 1, forward stroke, mean of 24 strokes; a looped reference (stroke:false) is matched with a roll of strokes.
var M = require("./shaker_measure.js"), R = require("./refs.js"), fs = require("fs"), path = require("path"), cp = require("child_process");
var NAMES = JSON.parse(cp.execFileSync("python3", ["-c", "import sys,json;sys.path.insert(0,'" + path.join(__dirname, "../scripts") +
    "');import shaker_engine as E;print(json.dumps(E.NAMES))"], { encoding: "utf8" }));
var write = process.argv.indexOf("--write") >= 0, ab = process.argv.indexOf("--ab") >= 0;
var ref = R.measured();
function f0(v) { return v === Infinity ? "inf" : isNaN(v) ? "nan" : v.toFixed(0); }
function f2(v) { return isNaN(v) ? "nan" : v.toFixed(2); }
function rmsThird(a, b) { var s = 0; for (var i = 0; i < a.length; i++) { var d = Math.max(-45, a[i]) - Math.max(-45, b[i]); s += d * d; } return Math.sqrt(s / a.length); }
var ranges = {}, abL = [], gap = new Float64Array(Math.round(0.35 * M.SR));

NAMES.forEach(function (name, ty) {
    var t = ref[name], ours = M.strokes({ type: ty, vol: 0, pan: -1 }, 24, 1, 0, 0.9);
    console.log("== " + name);
    console.log("  " + "".padEnd(30) + "rise t20  t30  cent   cvE  cvL | octave bands: 0.5 1 2 4 6 8 12 16 24 kHz");
    function row(label, m) {
        console.log("  " + label.padEnd(30) + [f0(m.rise), f0(m.t20), f0(m.t30), f0(m.cent), f2(m.cvE), f2(m.cvL)].map(function (v) { return v.padStart(4); }).join(" ") +
            " | " + m.bands.map(function (v) { return v.toFixed(0).padStart(4); }).join(""));
    }
    t.files.forEach(function (f) { row(f.name + (f.stroke ? "" : " (roll)"), f.m); });
    row("ours", ours);
    console.log("  1/3-octave spectrum, rms diff to the refs: " + rmsThird(ours.third, t.all.third).toFixed(1) + " dB");
    var S = t.files.filter(function (f) { return f.stroke; }).map(function (f) { return f.m; }), rg = {};
    ["rise", "t20", "t30", "cent", "cvE", "cvL"].forEach(function (k) {
        var v = S.map(function (m) { return m[k]; }).filter(isFinite);
        rg[k] = v.length ? [Math.min.apply(null, v), Math.max.apply(null, v)] : null;
    });
    rg.bands = t.all.bands.map(function (v) { return +v.toFixed(1); });
    rg.third = t.all.third.map(function (v) { return +v.toFixed(1); });
    ranges[name] = rg;
    if (ab) t.files.forEach(function (f) {
        var x = R.load(f.name), n = Math.min(x.length, Math.round(0.9 * M.SR)), seg = x.subarray(0, n);
        var ev = f.stroke ? [{ t: 0.02, vel: 1, dir: 0 }] : [0, 1, 2, 3, 4, 5, 6, 7].map(function (k) { return { t: 0.02 + 0.055 * k, vel: k % 2 ? 0.7 : 1, dir: k % 2 }; });
        var o = M.render({ type: ty, vol: 0, pan: -1, damp: f.stroke ? 1 : 2.5 }, ev, n / M.SR).l;
        var g = M.measure(seg).peak / Math.max(1e-9, M.measure(o).peak);   // same 10 ms RMS peak
        var og = new Float64Array(n); for (var i = 0; i < n; i++) og[i] = o[i] * g;
        abL.push(seg, gap, og, gap, gap);
    });
});
if (write) {
    fs.writeFileSync(path.join(__dirname, "refs.json"), JSON.stringify(ranges, null, 1));
    console.log("wrote tests/refs.json");
}
if (ab) {
    var n = abL.reduce(function (a, b) { return a + b.length; }, 0), all = new Float64Array(n), p = 0;
    abL.forEach(function (b) { all.set(b, p); p += b.length; });
    var file = path.join(__dirname, "../docs/types_ab.wav");
    M.writeWav(file, [all], 0.9);
    console.log(file + ": " + (n / M.SR).toFixed(1) + " s, reference then ours, per file");
}
