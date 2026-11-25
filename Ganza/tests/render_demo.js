// render_demo.js — docs/demo.wav: a samba pattern through the generated gen~ code in Node, 16-bit 48 kHz stereo: the ganzá in 16ths, forward on the beat
// and back between, accents on the 2nd 16th of the bar's 1, 3, 6 (a surdo-ish figure), a chocalho joining in 8ths on the back strokes, a roll to finish.
// Not a transcription of anything.
var M = require("./ganza_measure.js"), path = require("path");
var SR = M.SR, BPM = 112, STEP = 60 / BPM / 4, BAR = 16 * STEP, BARS = 8, T0 = 0.1;
var parts = [];
// strokes: [bar, step, velocity 0..127, dir, acc]
function ganza(first, last) {
    var out = [];
    for (var b = first; b <= last; b++) for (var s = 0; s < 16; s++) {
        var fwd = s % 2 === 0, acc = fwd && (s === 0 || s === 6 || s === 10) ? 1 : 0;
        out.push([b, s, fwd ? (acc ? 112 : 90) : 72, fwd ? 0 : 1, acc]);
    }
    return out;
}
function choc(first, last) {
    var out = [];
    for (var b = first; b <= last; b++) for (var s = 0; s < 16; s += 2) out.push([b, s, s % 4 === 0 ? 100 : 80, s % 4 === 0 ? 0 : 1, 0]);
    return out;
}
parts.push([0, { pan: -0.25 }, 1.0, ganza(0, 7)]);
parts.push([1, { pan: 0.4 }, 0.7, choc(2, 7)]);
var roll = []; for (var k = 0; k < 14; k++) roll.push([7, 8 + k * 0.5, 60 + k * 4, k % 2, 0]);   // the last half bar: 16 strokes a second, getting louder (it joins the ganzá)
parts.push([0, { pan: 0.1, tone: 1 }, 0.6, roll]);
var total = T0 + BARS * BAR + 1.2, n = Math.round(total * SR), L = new Float64Array(n), R = new Float64Array(n);
parts.forEach(function (p) {
    var ev = p[3].map(function (s) { return { t: T0 + s[0] * BAR + s[1] * STEP, vel: s[2] / 127, dir: s[3], acc: s[4] }; });
    var o = M.render(Object.assign({ type: p[0], vol: -6 }, p[1]), ev, total);
    for (var i = 0; i < n; i++) { L[i] += o.l[i] * p[2]; R[i] += o.r[i] * p[2]; }
});
var file = path.join(__dirname, "../docs/demo.wav");
M.writeWav(file, [L, R], 0.9);
console.log(file + ": " + total.toFixed(1) + " s, " + BPM + " BPM, " + parts.length + " parts");
