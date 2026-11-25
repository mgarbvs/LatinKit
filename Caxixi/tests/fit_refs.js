// fit_refs.js [--write] [--ab] — ours vs the Latin Percussion caxixi previews (8 takes per stroke): rise / t20 / t30 (ms), spectral centroid, grain
// fluctuation (cvE early, cvL tail), the 9 octave-ish band levels (dB re the stroke's total) and the 1/3-octave spectral error; FX (a phrase) by
// fx_measure.js: burst interval, ripple, first / last burst, steady-part centroid.
//   --write  writes tests/refs.json (the measured reference ranges tests/test_engine.js holds the engine to; numbers only, no audio)
//   --ab     writes docs/strokes_ab.wav: per stroke the eight takes, then ours (gitignored: contains Ableton's audio)
// Ours = Stroke at default settings, velocity 1, mean of 24 strokes (FX: 12 phrases of Length 1000 ms, Rate 9.3 Hz through caxixi_midi.js).
var M = require("./caxixi_measure.js"), R = require("./refs.js"), F = require("./fx_measure.js"), S = require("./midi_sim.js"), fs = require("fs"), path = require("path");
var write = process.argv.indexOf("--write") >= 0, ab = process.argv.indexOf("--ab") >= 0;
var ref = R.measured();
function f0(v) { return v === Infinity ? "inf" : isNaN(v) ? "nan" : v.toFixed(0); }
function f2(v) { return isNaN(v) ? "nan" : v.toFixed(2); }
function rmsThird(a, b) { var s = 0; for (var i = 0; i < a.length; i++) { var d = Math.max(-45, a[i]) - Math.max(-45, b[i]); s += d * d; } return Math.sqrt(s / a.length); }
var ranges = {}, abL = [], gap = new Float64Array(Math.round(0.4 * M.SR));

// ours: an FX phrase from the js, rendered through the engine (type 2); seed varies the scatter
function phrase(seed, params, len, rate) {
    var J = S.load(seed); J.c.strokemode(2); if (len) J.c.length(len); if (rate) J.c.rate(rate);
    var ev = J.play(60, 127).map(function (e) { return { t: 0.01 + e.t, vel: e.vel }; });
    return M.render(Object.assign({ type: 2, vol: 0, pan: -1 }, params || {}), ev, 2.2).l;
}
function rowOf(label, m) {
    console.log("  " + label.padEnd(24) + [f0(m.rise), f0(m.t20), f0(m.t30), f0(m.t40), f0(m.t50), f0(m.cent), f2(m.cvE), f2(m.cvL)].map(function (v) { return v.padStart(5); }).join(" ") +
        " | " + m.bands.map(function (v) { return v.toFixed(0).padStart(4); }).join(""));
}
["Open", "Hand"].forEach(function (name, ty) {
    var t = ref[name], ours = M.strokes({ type: ty, vol: 0, pan: -1 }, 24, 1, 0.9);
    console.log("== " + name);
    console.log("  " + "".padEnd(24) + " rise  t20  t30  t40  t50  cent   cvE   cvL | octave bands: 0.5 1 2 4 6 8 12 16 24 kHz");
    t.files.forEach(function (f) { rowOf(f.name + (R.FIT[name].some(function (i) { return f.name === "Caxixi_" + i + "_" + name; }) ? " *" : ""), f.m); });
    rowOf("pooled, all 8", t.pooled);
    rowOf("pooled, fitted (*)", t.all);
    rowOf("ours", ours);
    console.log("  1/3-octave spectrum, rms diff of ours to the fitted refs: " + rmsThird(ours.third, t.all.third).toFixed(1) + " dB; to all 8: " + rmsThird(ours.third, t.pooled.third).toFixed(1) + " dB");
    var rg = {};
    ["rise", "t20", "t30", "t40", "t50", "cent", "cvE", "cvL"].forEach(function (k) {
        var v = t.files.map(function (f) { return f.m[k]; }).filter(isFinite);
        rg[k] = [Math.min.apply(null, v), Math.max.apply(null, v)];
    });
    rg.bands = t.pooled.bands.map(function (v) { return +v.toFixed(1); });
    rg.third = t.pooled.third.map(function (v) { return +v.toFixed(1); });
    rg.bandsFit = t.all.bands.map(function (v) { return +v.toFixed(1); });
    rg.thirdFit = t.all.third.map(function (v) { return +v.toFixed(1); });
    ranges[name] = rg;
    if (ab) {
        t.files.forEach(function (f) { var x = R.load(f.name); abL.push(x.subarray(0, Math.min(x.length, Math.round(0.7 * M.SR))), gap); });
        var xs = [];
        for (var k = 0; k < 2; k++) { var e = M.engine({ type: ty, vol: 0, pan: -1 }); for (var j = 0; j < 13 + k * 7919; j++) e.st.noise(); e.st.vl = 1; e.st.tr = 1; var o = new Float64Array(Math.round(0.7 * M.SR)); for (var i = 0; i < o.length; i++) { e.tick(); o[i] = e.st.out1; } xs.push(o); }
        xs.forEach(function (o) { abL.push(o, gap); });
        abL.push(gap, gap);
    }
});
// FX
(function () {
    var files = R.TAKES.map(function (i) { var x = R.load("Caxixi_" + i + "_FX"); return { name: "Caxixi_" + i + "_FX", x: x, m: F.measureFX(x) }; });
    console.log("== FX (a phrase)   bursts  interval ms (sd)  ripple dB  first / last dB  centroid");
    function row(l, m) { console.log("  " + l.padEnd(20) + String(m.bursts).padStart(6) + " " + (m.iv.toFixed(0) + " (" + m.ivsd.toFixed(0) + ")").padStart(14) + m.ripple.toFixed(1).padStart(11) + (m.first.toFixed(0) + " / " + m.last.toFixed(0)).padStart(14) + m.cent.toFixed(0).padStart(10)); }
    files.forEach(function (f) { row(f.name, f.m); });
    var oursM = [], oursX = [];
    for (var s = 1; s <= 12; s++) { var x = phrase(s * 101); oursX.push(x); oursM.push(F.measureFX(x)); }
    var avg = function (k) { return oursM.reduce(function (a, m) { return a + m[k]; }, 0) / oursM.length; };
    var om = { bursts: avg("bursts"), iv: avg("iv"), ivsd: avg("ivsd"), ripple: avg("ripple"), first: avg("first"), last: avg("last"), cent: avg("cent"),
        third: oursM[0].third.map(function (_, i) { return oursM.reduce(function (a, m) { return a + Math.pow(10, m.third[i] / 10); }, 0) / oursM.length; }).map(function (v) { return 10 * Math.log10(v); }) };
    row("ours (mean of 12)", om);
    var pooled = files[0].m.third.map(function (_, i) { return 10 * Math.log10(files.reduce(function (a, f) { return a + Math.pow(10, f.m.third[i] / 10); }, 0) / files.length); });
    console.log("  1/3-octave steady spectrum, rms diff of ours to the pooled refs: " + rmsThird(om.third, pooled).toFixed(1) + " dB");
    var fitted = files.filter(function (f) { return R.FIT.FX.some(function (i) { return f.name === "Caxixi_" + i + "_FX"; }); });
    var pooledFit = files[0].m.third.map(function (_, i) { return 10 * Math.log10(fitted.reduce(function (a, f) { return a + Math.pow(10, f.m.third[i] / 10); }, 0) / fitted.length); });
    console.log("  ... to the fitted takes (" + R.FIT.FX.join(", ") + "): " + rmsThird(om.third, pooledFit).toFixed(1) + " dB");
    var rg = {};
    ["bursts", "iv", "ivsd", "ripple", "first", "last", "cent"].forEach(function (k) { var v = files.map(function (f) { return f.m[k]; }); rg[k] = [Math.min.apply(null, v), Math.max.apply(null, v)]; });
    rg.third = pooled.map(function (v) { return +v.toFixed(1); });
    rg.thirdFit = pooledFit.map(function (v) { return +v.toFixed(1); });
    ranges.FX = rg;
    if (ab) {
        files.forEach(function (f) { abL.push(f.x.subarray(0, Math.min(f.x.length, Math.round(2.0 * M.SR))), gap); });
        [0, 1].forEach(function (k) { abL.push(oursX[k].subarray(0, Math.round(2.0 * M.SR)), gap); });
        abL.push(gap, gap);
    }
})();
if (write) {
    fs.writeFileSync(path.join(__dirname, "refs.json"), JSON.stringify(ranges, null, 1));
    console.log("wrote tests/refs.json");
}
if (ab) {
    var n = abL.reduce(function (a, b) { return a + b.length; }, 0), all = new Float64Array(n), p = 0, cues = [], pos = 0;
    abL.forEach(function (b) { all.set(b, p); p += b.length; });
    var file = path.join(__dirname, "../docs/strokes_ab.wav");
    // segments are peak-normalised alike (the previews are peak-normalised): scale the whole file, then each segment separately
    var q = 0;
    abL.forEach(function (b) { if (b !== gap) { var m = 0, i; for (i = 0; i < b.length; i++) m = Math.max(m, Math.abs(all[q + i])); if (m > 0) for (i = 0; i < b.length; i++) all[q + i] *= 0.8 / m; } q += b.length; });
    M.writeWav(file, [all], 0);
    p = 0; abL.forEach(function (b) { if (b !== gap) cues.push((p / M.SR).toFixed(2)); p += b.length; });
    console.log(file + ": " + (n / M.SR).toFixed(1) + " s; cues (s): " + cues.join(" "));
}
