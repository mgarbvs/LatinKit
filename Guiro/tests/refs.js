// refs.js — the Latin Percussion güiro previews (Guiro/ref_wav, see decode_refs.sh; Ableton's audio, gitignored) per stroke, measured with
// guiro_measure.js. Takes A-D are four different instruments/hands (A: coarse, separate ridges; C: fine, blurred into noise), so a stroke's
// reference is a RANGE over its takes. "D Reverse Up" is a reversed recording: kept out of the Up pool.
var M = require("./guiro_measure.js"), path = require("path");
var DIR = process.env.GUIRO_REF_DIR || path.join(__dirname, "../ref_wav");
var REFS = {
    Up: ["A", "B", "C", "D"], Down: ["A", "B", "C"], Long: ["A", "B", "C", "D"], Top: ["A", "B", "C", "D"]
};
function load(name) { return M.readWav(path.join(DIR, "Guiro_" + name + ".wav")); }
// per stroke: {files: [{name, m}], all: pooled-mean metrics}
function measured() {
    var out = {};
    Object.keys(REFS).forEach(function (k) {
        var files = REFS[k].map(function (t) { return { name: t + "_" + k, m: M.measure(load(t + "_" + k)) }; });
        out[k] = { files: files, all: M.average(files.map(function (f) { return f.m; })) };
    });
    return out;
}
module.exports = { REFS: REFS, load: load, measured: measured, DIR: DIR };
