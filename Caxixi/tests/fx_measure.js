// fx_measure.js — measures a shaken phrase (the previews' FX, or ours through caxixi_midi.js) with one piece of code: bursts (local maxima of the 12 ms RMS
// at least 70 ms apart and above -16 dB of the loudest), their interval (mean, sd), the ripple (dB from a burst's peak down to the trough before the next, mean),
// the level of the first and last burst against the loudest, and the spectrum of the steady part (0.25-0.9 s): centroid and 1/3 octaves.
var M = require("./caxixi_measure.js"), SR = M.SR;
function measureFX(x) {
    var e = M.movRms(x, Math.round(0.012 * SR)), n = x.length, pk = 0, i, j, mx = 0, W = Math.round(0.06 * SR);
    for (i = 0; i < n; i++) mx = Math.max(mx, e[i]);
    var cand = [];
    for (i = W; i < n - W; i++) {
        if (e[i] < mx * 0.158) continue;
        var ok = true;
        for (j = i - W; j <= i + W; j++) if (e[j] > e[i] || (e[j] === e[i] && j < i)) { ok = false; break; }
        if (ok) cand.push(i);
    }
    var iv = [], dep = [], lv = cand.map(function (k) { return 20 * Math.log10(e[k] / mx); });
    for (i = 1; i < cand.length; i++) {
        iv.push((cand[i] - cand[i - 1]) / SR * 1000);
        var tr = 1e9; for (j = cand[i - 1]; j <= cand[i]; j++) tr = Math.min(tr, e[j]);
        dep.push(20 * Math.log10(Math.min(e[cand[i - 1]], e[cand[i]]) / tr));
    }
    var mean = function (a) { return a.length ? a.reduce(function (s, v) { return s + v; }, 0) / a.length : NaN; };
    var m = mean(iv), sd = Math.sqrt(mean(iv.map(function (v) { return (v - m) * (v - m); })));
    var a0 = Math.round(0.25 * SR), a1 = Math.min(n, Math.round(0.9 * SR)), seg = x.subarray(a0, a1), sp = M.measure(seg);   // measure(): spectrum over its first 100 ms from the onset: use a longer window below
    var len = a1 - a0, N = 1; while (N < len) N <<= 1;
    var re = new Float64Array(N), im = new Float64Array(N); for (i = 0; i < len; i++) re[i] = seg[i] * (0.5 - 0.5 * Math.cos(2 * Math.PI * i / len));
    M.fft(re, im);
    var th = new Float64Array(M.THIRDS.length - 1), tot = 0, cen = 0;
    for (i = 1; i < N / 2; i++) { var f = i * SR / N, p = re[i] * re[i] + im[i] * im[i]; tot += p; cen += p * f; if (f >= M.THIRDS[0] && f < M.THIRDS[M.THIRDS.length - 1]) th[Math.min(th.length - 1, Math.floor(3 * Math.log2(f / 500)))] += p; }
    return { bursts: cand.length, iv: m, ivsd: sd, ripple: mean(dep), first: lv[0], last: lv[lv.length - 1], lv: lv, cent: cen / tot,
        third: Array.prototype.map.call(th, function (v) { return 10 * Math.log10(v / tot + 1e-12); }) };
}
module.exports = { measureFX: measureFX };
