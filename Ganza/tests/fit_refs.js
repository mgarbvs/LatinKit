// fit_refs.js [--write] [--ab] — ours vs the CC reference strokes (tests/refs.js), per Type and direction: rise / t20 / t30 / t40 / t50 (ms), centroid, grain
// fluctuation (cvE early, cvL tail), the octave bands (dB re the stroke's total) and the 1/3-octave spectral error; the 16th-note pattern of the ganzá loop.
//   --write  writes tests/refs.json (the measured reference ranges tests/test_engine.js holds the engine to; numbers only, no audio)
//   --ab     writes docs/strokes_ab.wav (gitignored: it contains the references): per Type and direction each reference stroke then ours; then the ganzá loop
//            (2 s) then ours at the same strokes; cues are printed.
var M = require("./ganza_measure.js"), R = require("./refs.js"), fs = require("fs"), path = require("path");
var NAMES = ["Ganza", "Chocalho"];
var write = process.argv.indexOf("--write") >= 0, ab = process.argv.indexOf("--ab") >= 0;
var ref = R.measured();
function f0(v) { return v === Infinity ? "inf" : isNaN(v) ? "nan" : v.toFixed(0); }
function f2(v) { return isNaN(v) ? "nan" : v.toFixed(2); }
function rmsThird(a, b) { var s = 0; for (var i = 0; i < a.length; i++) { var d = Math.max(-45, a[i]) - Math.max(-45, b[i]); s += d * d; } return Math.sqrt(s / a.length); }
function mean(a) { return a.reduce(function (s, v) { return s + v; }, 0) / a.length; }
var ranges = {}, abL = [], cues = [], gap = new Float64Array(Math.round(0.35 * M.SR));

NAMES.forEach(function (name, ty) {
    var t = ref[name], rg = ranges[name] = { trunc: t.trunc };
    ["fwd", "back"].forEach(function (dn, dir) {
        var tp = t[dn], ours = M.strokes({ type: ty, vol: 0, pan: -1 }, 24, 1, dir, t.trunc ? 0.5 : 0.9);
        console.log("== " + name + " " + dn);
        console.log("  " + "".padEnd(26) + "rise t20  t30  t40  t50  cent   cvE  cvL | octave bands: 0.5 1 2 4 6 8 12 16 24 kHz");
        function row(label, m) {
            console.log("  " + label.padEnd(26) + [f0(m.rise), f0(m.t20), f0(m.t30), f0(m.t40), f0(m.t50), f0(m.cent), f2(m.cvE), f2(m.cvL)].map(function (v) { return v.padStart(4); }).join(" ") +
                " | " + m.bands.map(function (v) { return v.toFixed(0).padStart(4); }).join(""));
        }
        tp.files.forEach(function (f) { row(f.name, f.m); });
        row("ours", ours);
        console.log("  1/3-octave spectrum, rms diff to the refs: " + rmsThird(ours.third, tp.avg.third).toFixed(1) + " dB");
        var r = rg[dn] = {};
        ["rise", "t20", "t30", "t40", "t50", "cent", "cvE", "cvL"].forEach(function (k) {
            var v = tp.files.map(function (f) { return f.m[k]; }).filter(isFinite);
            r[k] = v.length >= Math.ceil(tp.files.length / 2) ? [Math.min.apply(null, v), Math.max.apply(null, v)] : null;
        });
        r.bands = tp.avg.bands.map(function (v) { return +v.toFixed(1); });
        r.third = tp.avg.third.map(function (v) { return +v.toFixed(1); });
        r.peakdB = 20 * Math.log10(mean(tp.files.map(function (f) { return f.m.peak; })));
        if (ab) tp.files.forEach(function (f, i) {
            var x = R.load(f.name), n = Math.min(x.length, Math.round(0.9 * M.SR)), seg = x.subarray(0, n);
            var o = M.render({ type: ty, vol: 0, pan: -1 }, [{ t: 0.02, vel: 1, dir: dir }], n / M.SR).l;
            var g = M.measure(seg).peak / Math.max(1e-9, M.measure(o).peak);
            var og = new Float64Array(n); for (var q = 0; q < n; q++) og[q] = o[q] * g;
            var at = abL.reduce(function (a, b) { return a + b.length; }, 0) / M.SR;
            cues.push(name + " " + dn + " " + (i + 1) + ": ref " + at.toFixed(2) + " s, ours " + (at + (n + gap.length) / M.SR).toFixed(2) + " s");
            abL.push(seg, gap, og, gap, gap);
        });
    });
    var d = ranges[name].back.peakdB - ranges[name].fwd.peakdB;
    rg.backdB = +d.toFixed(1);
    console.log("  back stroke level re forward (10 ms RMS peak): " + d.toFixed(1) + " dB");
});
// the ganzá loop: 16th notes, forward (loud) / back (soft)
var loop = R.load("ganza_arroz"), lp = M.pattern(loop);
ranges.pattern = { n: lp.n, depth: lp.depth, alt: lp.alt, centLoud: lp.centLoud, centSoft: lp.centSoft };
console.log("== ganzá loop (ganza_arroz.wav): " + lp.n + " strokes, peak-to-trough " + lp.depth.toFixed(1) + " dB, loud vs soft " + lp.alt.toFixed(1) + " dB, centroids " + lp.centLoud.toFixed(0) + " / " + lp.centSoft.toFixed(0));
function patternOurs(seed, vels) {
    var ev = []; for (var k = 0; k < 16; k++) ev.push({ t: 0.09 + k * 0.1175, vel: vels ? vels[k] : 1, dir: k % 2, acc: 0 });
    return M.render({ type: 0, vol: 0, pan: -1 }, ev, 2.2).l;
}
var po = M.pattern(patternOurs());
console.log("   ours (alternating, velocity 1): " + po.n + " strokes, " + po.depth.toFixed(1) + " dB, " + po.alt.toFixed(1) + " dB, " + po.centLoud.toFixed(0) + " / " + po.centSoft.toFixed(0));
if (write) {
    fs.writeFileSync(path.join(__dirname, "refs.json"), JSON.stringify(ranges, null, 1));
    console.log("wrote tests/refs.json");
}
if (ab) {
    // the loop, then ours with the loop's accent pattern (even strokes forward, the loudest as accents)
    var at2 = abL.reduce(function (a, b) { return a + b.length; }, 0) / M.SR, seg2 = loop.subarray(0, Math.round(2 * M.SR));
    var vels = [0.8, 1, 0.8, 1, 0.85, 1, 0.8, 1, 0.8, 1, 0.8, 1, 0.85, 1, 0.8, 1], ev2 = [];
    for (var k = 0; k < 16; k++) ev2.push({ t: 0.09 + k * 0.1175, vel: vels[k], dir: 1 - (k % 2), acc: k === 7 ? 1 : 0 });
    var o2 = M.render({ type: 0, vol: 0, pan: -1 }, ev2, 2.0).l, g2 = M.measure(seg2).peak / Math.max(1e-9, M.measure(o2).peak), og2 = new Float64Array(o2.length);
    for (var q = 0; q < o2.length; q++) og2[q] = o2[q] * g2;
    cues.push("ganzá loop: ref " + at2.toFixed(2) + " s, ours " + (at2 + 2.35).toFixed(2) + " s");
    abL.push(seg2, gap, gap, og2);
    var n = abL.reduce(function (a, b) { return a + b.length; }, 0), all = new Float64Array(n), p = 0;
    abL.forEach(function (b) { all.set(b, p); p += b.length; });
    var file = path.join(__dirname, "../docs/strokes_ab.wav");
    M.writeWav(file, [all], 0.9);
    console.log(file + ": " + (n / M.SR).toFixed(1) + " s, reference then ours\n" + cues.join("\n"));
}
