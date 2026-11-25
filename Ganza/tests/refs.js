// refs.js — the CC recordings each Type is fitted to (Ganza/ref_wav, gitignored, see docs/RESEARCH.md; tests/segment_refs.py cuts the ganzá loop), measured with ganza_measure.js.
// Ganza: strokes 2, 4 ... 14 of ganza_arroz.wav (the loud ones: forward) and 1, 3 ... 13 (the soft ones: back); each is cut trough to trough, so it carries its
//   neighbour's tail: `trunc` = t30 / t40 / t50 are not measurable (the fit and the tests skip them).
// Chocalho: CamTarn's Samba Chocalho de Platinela Forward 1-7 and Back 1-7 (single strokes, full tails).
var M = require("./ganza_measure.js"), path = require("path");
var DIR = process.env.GANZA_REF_DIR || path.join(__dirname, "../ref_wav");
function seq(a, b, s) { var o = []; for (var i = a; i <= b; i += s) o.push(i); return o; }
var REFS = {
    Ganza: { trunc: true, fwd: seq(2, 14, 2).map(function (i) { return "arroz_s" + ("0" + i).slice(-2); }), back: seq(1, 13, 2).map(function (i) { return "arroz_s" + ("0" + i).slice(-2); }) },
    Chocalho: { trunc: false, fwd: seq(1, 7, 1).map(function (i) { return "choc_fwd" + i; }), back: seq(1, 7, 1).map(function (i) { return "choc_back" + i; }) }
};
function load(name) { return M.readWav(path.join(DIR, name.replace(/\.wav$/, "") + ".wav")); }
function pool(names) {
    var files = names.map(function (n) { return { name: n, m: M.measure(load(n)) }; });
    return { files: files, avg: M.average(files.map(function (f) { return f.m; })) };
}
// per type: {trunc, fwd: {files, avg}, back: {files, avg}, stroke: = fwd.avg, all: = fwd.avg}  (stroke / all are what fit_types.js reads)
function measured() {
    var out = {};
    Object.keys(REFS).forEach(function (t) {
        var f = pool(REFS[t].fwd), b = pool(REFS[t].back);
        out[t] = { trunc: REFS[t].trunc, fwd: f, back: b, stroke: f.avg, all: f.avg };
    });
    return out;
}
module.exports = { REFS: REFS, load: load, measured: measured, DIR: DIR };
