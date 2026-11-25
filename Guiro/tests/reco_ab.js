// reco_ab.js — docs/reco_ab.wav (gitignored): excerpts of the Freesound reco-reco (ref_wav/reco_texture.wav, tests/reco_refs.sh), then ours (Reco Type), peak-normalised
// per excerpt, 0.4 s apart. Prints the cue list. Ours: Up, Down, Long, Top, a back-and-forth run of Up / Down at 10 strokes a second (the recording's runs are 6-16 a second), a Long.
var M = require("./guiro_measure.js"), path = require("path"), SR = M.SR;
var tex = M.readWav(path.join(__dirname, "../ref_wav/reco_texture.wav"));
var chunks = [], cues = [], t = 0, gap = Math.round(0.4 * SR);
function add(label, x) {
    var m = 0, i; for (i = 0; i < x.length; i++) m = Math.max(m, Math.abs(x[i]));
    var y = new Float64Array(x.length + gap); for (i = 0; i < x.length; i++) y[i] = x[i] / (m || 1) * 0.8;
    cues.push([t / SR, label]); chunks.push(y); t += y.length;
}
[[0.46, 1.6, "recording: a run, 0.46 s"], [2.48, 3.5, "recording: a run, 2.48 s"], [4.55, 6.0, "recording: a run ending in a ring-out, 4.55 s"], [8.4, 9.6, "recording: 8.4 s"], [11.7, 13.4, "recording: 11.7 s"]].forEach(function (c) {
    add(c[2], tex.subarray(Math.round(c[0] * SR), Math.round(c[1] * SR)));
});
var P = { type: 1, vol: 0, pan: -1 };
function render(events, sec) { return M.render(P, events, sec, 1).l; }
["Up", "Down", "Long", "Top"].forEach(function (k, i) { add("OURS " + k, render([{ t: 0.02, vel: 1, stk: i, len: 450 }], k === "Long" ? 0.9 : 0.5)); });
var run = []; for (var k = 0; k < 14; k++) run.push({ t: 0.02 + k * 0.1, vel: 0.7 + 0.3 * (k % 2), stk: k % 2 });
add("OURS run of Up / Down at 10 a second", render(run, 1.8));
add("OURS Long then a Top tap", render([{ t: 0.02, vel: 1, stk: 2, len: 600 }, { t: 0.8, vel: 0.8, stk: 3 }], 1.6));
var tot = new Float64Array(t), p = 0; chunks.forEach(function (c) { tot.set(c, p); p += c.length; });
M.writeWav(path.join(__dirname, "../docs/reco_ab.wav"), [tot]);
console.log("docs/reco_ab.wav cues (s):"); cues.forEach(function (c) { console.log("  " + c[0].toFixed(2).padStart(6) + "  " + c[1]); });
