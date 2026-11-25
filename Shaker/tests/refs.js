// refs.js — the Ableton Core Library shaker one-shots each Type is fitted to, converted to mono 48 kHz 16-bit WAVs in a scratch dir
// (SHAKER_REF_DIR, default <tmp>/shaker_ref; never in the repo: Ableton's audio) and measured with shaker_measure.js.
// stroke: false = a looped / sustained roll, not one stroke: only its spectrum counts.
var M = require("./shaker_measure.js"), cp = require("child_process"), fs = require("fs"), os = require("os"), path = require("path");
var SRC = "/Applications/Ableton Live 12 Suite.app/Contents/App-Resources/Core Library/Samples/One Shots/Drums/Shaker/";
var REFS = {
    Maraca: [["Shake Maracas Hard.aif", true], ["Shake Maracas Soft.aif", true]],
    Cabasa: [["Cabasa LD.aif", true], ["Cabasa Short Mid.aif", true], ["Shake Cabasa Short.aif", true]],
    Shekere: [["Shaker SeedPodBangle.wav", true], ["Shaker Acoustic.aif", false]],
    Ganza: [["Shaker Short.aif", true], ["Shaker Long.aif", false]],
    Egg: [["Shaker Egg.aif", true]]
};
var DIR = process.env.SHAKER_REF_DIR || path.join(os.tmpdir(), "shaker_ref");

function load(file) {
    fs.mkdirSync(DIR, { recursive: true });
    var out = path.join(DIR, file.replace(/\.\w+$/, "").replace(/ /g, "_") + ".wav");
    if (!fs.existsSync(out)) cp.execFileSync("afconvert", ["-f", "WAVE", "-d", "LEI16@48000", "-c", "1", SRC + file, out]);
    return M.readWav(out);
}

// measured refs per type: {all: pooled metrics of every file, stroke: pooled metrics of the single-stroke files, files: [{name, stroke, m}]}
function measured() {
    var out = {};
    Object.keys(REFS).forEach(function (t) {
        var files = REFS[t].map(function (r) { return { name: r[0], stroke: r[1], m: M.measure(load(r[0])) }; });
        out[t] = { files: files, all: M.average(files.map(function (f) { return f.m; })),
            stroke: M.average(files.filter(function (f) { return f.stroke; }).map(function (f) { return f.m; })) };
    });
    return out;
}
module.exports = { REFS: REFS, load: load, measured: measured, DIR: DIR };
