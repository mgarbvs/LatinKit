// render_demo.js — docs/demo.wav: a short pattern through the generated gen~ code in Node, 16-bit 48 kHz stereo: maraca 16ths alternating forward / back,
// a cabasa joining, shekere accents (3+3+2), ganza and egg shaker on top, a roll to finish. Not a transcription of anything.
var M = require("./shaker_measure.js"), path = require("path");
var SR = M.SR, BPM = 100, STEP = 60 / BPM / 4, BAR = 16 * STEP, BARS = 8, T0 = 0.1;
var mix = [], parts = [];
// [Type, params, pan, gain, strokes: [bar, step, velocity, dir]]
function every(firstBar, lastBar, steps, vel, dirOf) {   // helper: steps within each bar
    var out = [];
    for (var b = firstBar; b <= lastBar; b++) steps.forEach(function (s, i) { out.push([b, s, Array.isArray(vel) ? vel[i % vel.length] : vel, dirOf ? dirOf(s, i) : 0]); });
    return out;
}
var all16 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
parts.push([0, { pan: -0.3 }, 1.0, every(0, 7, all16, [105, 70, 90, 70], function (s) { return s % 2; })]);   // maraca: forward on the beat, back between
parts.push([1, { pan: 0.35 }, 0.8, every(2, 7, [0, 2, 4, 6, 8, 10, 12, 14], [100, 75, 90, 75], function (s, i) { return i % 2; })]);   // cabasa 8ths
parts.push([2, { pan: -0.55 }, 0.9, every(4, 7, [0, 3, 6, 8, 11, 14], [105, 80, 95], function (s, i) { return i % 2; })]);   // shekere 3+3+2 accents
parts.push([3, { pan: 0.55, tone: 2 }, 0.7, every(5, 7, [0, 2, 3, 6, 8, 10, 11, 14], [95, 70, 80], function (s, i) { return i % 2; })]);   // ganza
parts.push([4, { pan: 0.1, damp: 1.4 }, 0.8, every(6, 7, [2, 6, 10, 14], 90, function () { return 1; })]);   // egg on the off-beats
// a roll to finish: maraca, 12 strokes/s for the last half bar, getting louder
var roll = []; for (var k = 0; k < 14; k++) roll.push([7, 8 + k * 0.5, 60 + k * 4, k % 2]);
parts.push([0, { pan: 0 }, 1.0, roll]);
var total = T0 + BARS * BAR + 1.2, n = Math.round(total * SR), L = new Float64Array(n), R = new Float64Array(n);
parts.forEach(function (p) {
    var ev = p[3].map(function (s) { return { t: T0 + s[0] * BAR + s[1] * STEP, vel: s[2] / 127, dir: s[3] }; });
    var o = M.render(Object.assign({ type: p[0], vol: -6 }, p[1]), ev, total);
    for (var i = 0; i < n; i++) { L[i] += o.l[i] * p[2]; R[i] += o.r[i] * p[2]; }
});
var file = path.join(__dirname, "../docs/demo.wav");
M.writeWav(file, [L, R], 0.9);
console.log(file + ": " + total.toFixed(1) + " s, " + BPM + " BPM, " + parts.length + " parts");
