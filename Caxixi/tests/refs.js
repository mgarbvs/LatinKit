// refs.js — the Latin Percussion caxixi previews (Caxixi/ref_wav, see decode_refs.sh; Ableton's audio, gitignored), measured with caxixi_measure.js.
// Open and Hand: 8 takes each (8 caxixis or 8 takes of one: the spectra differ by 2.5-7 dB rms, so a RANGE over takes). FX is a shaken phrase (not one
// stroke): handled by fx_measure in fit_refs.js. stroke:false = spectrum only.
var M = require("./caxixi_measure.js"), path = require("path");
var DIR = process.env.CAXIXI_REF_DIR || path.join(__dirname, "../ref_wav");
var TAKES = [1, 2, 3, 4, 5, 6, 7, 8];
var REFS = {
    Open: TAKES.map(function (i) { return ["Caxixi_" + i + "_Open", true]; }),
    Hand: TAKES.map(function (i) { return ["Caxixi_" + i + "_Hand", true]; })
};
// The 8 takes are 8 instruments (or hands): how mid-heavy a take is correlates across the strokes (Open-Hand 0.90, Open-FX 0.76, Hand-FX 0.88 on the
// 1.5-4.5 kHz to 8-14 kHz ratio). Takes 2, 3, 4, 7 are the fuller, mid-rich ones (Hand centroid 6.7-7.5 kHz), 1, 5, 6, 8 the thinner, brighter ones (10.1-11.1 kHz):
// a mean of the two shapes sounds like neither, so every stroke is FITTED to takes 2, 3, 4, 7 (FIT) and the tests hold it to the range over all eight.
var TAKESET = (process.env.CAXIXI_FIT_TAKES || "2,3,4,7").split(",").map(Number);   // CAXIXI_FIT_TAKES=1,5,6,8 refits (fit_types.js) to the thinner instruments
var FIT = { Open: TAKESET, Hand: TAKESET, FX: TAKESET };
function load(name) { return M.readWav(path.join(DIR, name.replace(/\.wav$/, "") + ".wav")); }
// measured refs per type: {all: pooled metrics of every file, stroke: pooled metrics of the single-stroke files, files: [{name, stroke, m}]}
function measured() {
    var out = {};
    Object.keys(REFS).forEach(function (t) {
        var files = REFS[t].map(function (r) { return { name: r[0], stroke: r[1], m: M.measure(load(r[0])) }; });
        var sel = files.filter(function (f) { return !FIT[t] || FIT[t].some(function (i) { return f.name === "Caxixi_" + i + "_" + t; }); });
        out[t] = { files: files, fitfiles: sel, all: M.average(sel.map(function (f) { return f.m; })),
            stroke: M.average(sel.filter(function (f) { return f.stroke; }).map(function (f) { return f.m; })),
            pooled: M.average(files.map(function (f) { return f.m; })) };
    });
    return out;
}
module.exports = { REFS: REFS, load: load, measured: measured, DIR: DIR, TAKES: TAKES, FIT: FIT };
