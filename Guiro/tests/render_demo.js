// render_demo.js — docs/demo.wav: a short son montuno güiro pattern through the generated gen~ code in Node, 16-bit 48 kHz stereo. 150 BPM, a two-beat cell
// of long - short - short (the Latin Percussion groove clips: a Long scrape about 0.9 beat, then two short ones at beats 1 and 1.5), accented, with a
// Top tap on the "and" of 2 now and then, four bars on the Güiro, four on the Reco-reco, a fill of rolled Up / Down strokes to finish.
// Not a transcription of any one clip.
var M = require("./guiro_measure.js"), path = require("path");
var SR = M.SR, BPM = 150, BEAT = 60 / BPM, BARS = 8, T0 = 0.1, ev = [[], []];   // per Type
for (var b = 0; b < BARS; b++) {
    var ty = b < 4 ? 0 : 1, e = ev[ty];
    for (var c = 0; c < 2; c++) {
        var t = T0 + (b * 4 + c * 2) * BEAT, acc = c === 0 ? 1 : 0.85;
        e.push({ t: t - 0.01, vel: 0.95 * acc, stk: 2, len: 0.85 * BEAT * 1000 });
        e.push({ t: t + 1.0 * BEAT, vel: 0.7 * acc, stk: 0 });
        e.push({ t: t + 1.5 * BEAT, vel: 0.62 * acc, stk: 1 });
        if (c === 1 && b % 2 === 1) e.push({ t: t + 1.75 * BEAT, vel: 0.5, stk: 3 });
    }
}
var fill = ev[1], tf = T0 + 31 * BEAT;   // the last beat of bar 8: rolled Up / Down at 12 strokes a second, getting louder
fill.length -= 3; // the last cell's shorts make way for the fill
for (var k = 0; k < 14; k++) fill.push({ t: tf + k / 12, vel: 0.45 + 0.04 * k, stk: k % 2 });
var total = T0 + BARS * 4 * BEAT + 1.2, n = Math.round(total * SR), L = new Float64Array(n), R = new Float64Array(n);
[0, 1].forEach(function (ty) {
    var o = M.render({ type: ty, vol: -6, pan: ty ? 0.25 : -0.25 }, ev[ty], total);
    for (var i = 0; i < n; i++) { L[i] += o.l[i]; R[i] += o.r[i]; }
});
var file = path.join(__dirname, "../docs/demo.wav");
M.writeWav(file, [L, R], 0.9);
console.log(file + ": " + total.toFixed(1) + " s, " + BPM + " BPM");
