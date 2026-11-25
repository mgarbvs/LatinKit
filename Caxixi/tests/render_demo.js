// render_demo.js — docs/demo.wav: ours only (Node-rendered, 16-bit 48 kHz stereo) playing the rhythm of the pack's "Afro Cuban Caxixi 120 bpm" clip: its onsets
// (6 ms RMS maxima, 50 ms apart, within -22 dB of the loudest), velocity from their level, Hand for the onsets with the more 2-3.5 kHz against 8-14 kHz
// (above the clip's median: the previews' Hand has ~3 dB more of it than Open), Open for the rest; then two FX phrases. The clip itself is Ableton's audio
// and never leaves ref_wav/; docs/ab_clip.wav (gitignored) is the clip, then ours.
var M = require("./caxixi_measure.js"), S = require("./midi_sim.js"), path = require("path"), SR = M.SR;
var clip = M.readWav(path.join(__dirname, "../ref_wav/clip_Afro_Cuban_Caxixi-120bpm.wav"));
var e = M.movRms(clip, Math.round(0.006 * SR)), mx = 0, i, j;
for (i = 0; i < e.length; i++) mx = Math.max(mx, e[i]);
var W = Math.round(0.05 * SR), on = [];
for (i = W; i < e.length - W; i++) {
    if (e[i] < mx * Math.pow(10, -22 / 20)) continue;
    var ok = true;
    for (j = i - W; j <= i + W; j++) if (e[j] > e[i] || (e[j] === e[i] && j < i)) { ok = false; break; }
    if (ok) on.push(i);
}
function midHi(a) {   // dB, 2-3.5 kHz over 8-14 kHz in the 80 ms from the onset
    var N = 8192, re = new Float64Array(N), im = new Float64Array(N), n = Math.round(0.08 * SR), m = 0, h = 0;
    for (var k = 0; k < n; k++) re[k] = clip[a + k] * (0.5 - 0.5 * Math.cos(2 * Math.PI * k / n));
    M.fft(re, im);
    for (k = 1; k < N / 2; k++) { var f = k * SR / N, p = re[k] * re[k] + im[k] * im[k]; if (f >= 2000 && f < 3500) m += p; if (f >= 8000 && f < 14000) h += p; }
    return 10 * Math.log10(m / h);
}
var mh = on.map(midHi), med = mh.slice().sort(function (a, b) { return a - b; })[mh.length >> 1];
var ev = on.map(function (a, k) { return { t: 0.1 + a / SR, vel: 0.15 + 0.85 * Math.pow(e[a] / mx, 0.5), kind: mh[k] > med ? 1 : 0 }; });
var total = 0.1 + clip.length / SR + 1.0 + 3.6, n = Math.round(total * SR), L = new Float64Array(n), R = new Float64Array(n);
function add(o, g) { for (var k = 0; k < n; k++) { L[k] += o.l[k] * g; R[k] += o.r[k] * g; } }
[0, 1].forEach(function (kind) {
    add(M.render({ type: kind, vol: -6, pan: kind ? 0.25 : -0.25 }, ev.filter(function (x) { return x.kind === kind; }), total), 1);
});
var t0 = 0.1 + clip.length / SR + 0.6, J = S.load(5);
J.c.strokemode(2); var ph = J.play(60, 110).map(function (x) { return { t: t0 + x.t, vel: x.vel }; });
J = S.load(9); J.c.length(1800); J.c.rate(10.5);
ph = ph.concat(J.play(60, 127).map(function (x) { return { t: t0 + 1.6 + x.t, vel: x.vel }; }));
add(M.render({ type: 2, vol: -6, pan: 0 }, ph, total), 1);
var file = path.join(__dirname, "../docs/demo.wav");
M.writeWav(file, [L, R], 0.9);
console.log(file + ": " + total.toFixed(1) + " s, " + on.length + " onsets from the clip (" + ev.filter(function (x) { return x.kind; }).length + " Hand), then FX phrases of 1.0 s / 9.3 Hz and 1.8 s / 10.5 Hz");
if (process.argv.indexOf("--ab") >= 0) {   // the clip, then ours (peak-normalised alike), 0.6 s apart
    var mono = new Float64Array(n); for (i = 0; i < n; i++) mono[i] = (L[i] + R[i]) / Math.SQRT2;
    var cut = Math.round((0.1 + clip.length / SR + 0.3) * SR), ours = mono.subarray(0, cut), ab = new Float64Array(clip.length + Math.round(0.6 * SR) + cut);
    var m1 = 0, m2 = 0; for (i = 0; i < clip.length; i++) m1 = Math.max(m1, Math.abs(clip[i])); for (i = 0; i < ours.length; i++) m2 = Math.max(m2, Math.abs(ours[i]));
    for (i = 0; i < clip.length; i++) ab[i] = clip[i] / m1 * 0.8;
    for (i = 0; i < ours.length; i++) ab[clip.length + Math.round(0.6 * SR) + i] = ours[i] / m2 * 0.8;
    M.writeWav(path.join(__dirname, "../docs/ab_clip.wav"), [ab], 0);
    console.log("docs/ab_clip.wav: the clip (0 s), ours at " + ((clip.length / SR) + 0.6).toFixed(2) + " s");
}
