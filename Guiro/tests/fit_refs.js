// fit_refs.js [--write] [--ab] — prints our strokes (Güiro, Reco-reco; velocity 1, mean of 24) against the reference RANGE over the takes per stroke.
//   --write  refreshes tests/refs.json (numbers only: per stroke the min / max of each metric over the takes, the pooled and the per-take range of the octave band levels, and the pooled 1/3-octave levels)
//   --ab     writes docs/strokes_ab.wav (gitignored): for each stroke, each reference take then ours, peak-normalised, 0.4 s of silence between;
//            prints the cue list (time -> take / stroke)
var M = require("./guiro_measure.js"), R = require("./refs.js"), fs = require("fs"), path = require("path"), cp = require("child_process");
var SR = M.SR, KINDS = ["Up", "Down", "Long", "Top"], KEYS = ["rise", "t10", "t20", "t30", "len", "tail", "span", "rate", "r1", "r2", "r3", "lv3", "cent", "cvE"];
var args = process.argv.slice(2), ref = R.measured();
function fmt(v) { return isFinite(v) ? (Math.abs(v) >= 100 ? v.toFixed(0) : v.toFixed(1)) : String(v); }
function range(files, k) { var v = files.map(function (f) { return f.m[k]; }).filter(isFinite); return v.length ? [Math.min.apply(null, v), Math.max.apply(null, v)] : null; }

if (args.indexOf("--write") >= 0) {
    var out = {};
    KINDS.forEach(function (k) {
        var o = out[k] = { takes: ref[k].files.map(function (f) { return f.name; }) };
        KEYS.forEach(function (key) { o[key] = range(ref[k].files, key); });
        o.bands = ref[k].all.bands.map(function (v) { return +v.toFixed(1); });
        o.bandsR = o.bands.map(function (_, i) { var v = ref[k].files.map(function (f) { return f.m.bands[i]; }); return [+Math.min.apply(null, v).toFixed(1), +Math.max.apply(null, v).toFixed(1)]; });   // the range over the takes, per octave band
        o.third = ref[k].all.third.map(function (v) { return +v.toFixed(1); });
    });
    fs.writeFileSync(path.join(__dirname, "refs.json"), JSON.stringify(out, null, 1));
    console.log("refs.json written");
}

var NAMES = JSON.parse(cp.execFileSync("python3", ["-c", "import sys,json;sys.path.insert(0,'" + path.join(__dirname, "../scripts") + "');import guiro_engine as E;print(json.dumps(E.NAMES))"], { encoding: "utf8" }));
console.log("stroke  metric   ours (Guiro)  [Reco-reco]   reference range over the takes");
KINDS.forEach(function (k, i) {
    var g = M.strokes({ type: 0, vol: 0, pan: -1 }, 24, 1, i, k === "Long" ? 0.9 : 0.5), rr = M.strokes({ type: 1, vol: 0, pan: -1 }, 24, 1, i, k === "Long" ? 0.9 : 0.5);
    KEYS.forEach(function (key) {
        var r = range(ref[k].files, key);
        console.log((key === KEYS[0] ? k : "").padEnd(6) + "  " + key.padEnd(6) + "  " + fmt(g[key]).padStart(7) + "  [" + fmt(rr[key]).padStart(7) + "]   " + (r ? fmt(r[0]) + " .. " + fmt(r[1]) : "-"));
    });
    console.log("        bands " + g.bands.map(function (v) { return v.toFixed(0); }).join(" ") + "   refs " + ref[k].all.bands.map(function (v) { return v.toFixed(0); }).join(" "));
});

if (args.indexOf("--ab") >= 0) {
    var chunks = [], cues = [], t = 0, gap = Math.round(0.4 * SR);
    function add(label, x) {
        var m = 0, i; for (i = 0; i < x.length; i++) m = Math.max(m, Math.abs(x[i]));
        var y = new Float64Array(x.length + gap); for (i = 0; i < x.length; i++) y[i] = x[i] / (m || 1) * 0.8;
        cues.push([t / SR, label]); chunks.push(y); t += y.length;
    }
    KINDS.forEach(function (k, i) {
        ref[k].files.forEach(function (f) { add("ref " + f.name, R.load(f.name)); });
        var e = M.engine({ type: 0, vol: 0, pan: -1 }); for (var j = 0; j < 13; j++) e.st.noise();
        e.st.vl = 1; e.st.stk = i; e.st.tr = 1; var n = Math.round((k === "Long" ? 0.9 : 0.5) * SR), x = new Float64Array(n);
        for (var q = 0; q < n; q++) { e.tick(); x[q] = e.st.out1; }
        add("OURS " + k, x);
    });
    var tot = new Float64Array(t), p = 0; chunks.forEach(function (c) { tot.set(c, p); p += c.length; });
    M.writeWav(path.join(__dirname, "../docs/strokes_ab.wav"), [tot]);
    console.log("docs/strokes_ab.wav cues (s):"); cues.forEach(function (c) { console.log("  " + c[0].toFixed(2).padStart(6) + "  " + c[1]); });
}
