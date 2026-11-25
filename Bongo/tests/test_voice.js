// node tests/test_voice.js -- Bongo (m4l/Bongo.maxpat) in the Node shim: stability, every drum x stroke sounds, tuning, stroke changes over a ringing
// drum (a heel damps the head, an open stroke barely touches it), the flam, the controls, extremes, and bongo_midi.js.
var fs = require("fs"), path = require("path"), S = require("./gen_shim.js"), SR = S.SR;
var CODE = S.loadCode(path.join(__dirname, "../m4l/Bongo.maxpat"));
var fails = 0, count = 0, passed = 0;
function check(ok, what) { console.log((ok ? "ok   " : "FAIL ") + what); if (ok) passed++; else fails++; }
var DB = function (x) { return 20 * Math.log10(x + 1e-12); };
var F1 = [365, 325], DR = ["Macho", "Hembra"], ST = ["open", "open3", "slap", "heel", "tip", "rim", "flam"];
function mk(params) { var e = new S.Engine(CODE); Object.keys(params || {}).forEach(function (k) { e.set(k, params[k]); }); return e; }
// script: [[t seconds, drum, stroke, velocity]] -> {L, R}
function render(script, sec, params, mw) {
    var e = mk(params); if (mw !== undefined) e.set("mw", mw);
    var n = Math.round(sec * SR), L = new Float64Array(n), R = new Float64Array(n), i = 0;
    function upto(t) { for (; i < Math.min(n, Math.round(t * SR)); i++) { e.tick(); L[i] = e.st.out1; R[i] = e.st.out2; } }
    script.forEach(function (h) { upto(h[0]); e.set("drum", h[1]); e.set("stroke", h[2]); e.set("vel", h[3]); e.set("trg", ++count); });
    upto(sec);
    return { L: L, R: R };
}
function peak(x) { var p = 0; for (var i = 0; i < x.length; i++) p = Math.max(p, Math.abs(x[i])); return p; }
function finite(x) { for (var i = 0; i < x.length; i++) if (!isFinite(x[i])) return false; return true; }
function fft(re, im) {
    var n = re.length;
    for (var i = 1, j = 0; i < n; i++) { var bit = n >> 1; for (; j & bit; bit >>= 1) j ^= bit; j ^= bit; if (i < j) { var t = re[i]; re[i] = re[j]; re[j] = t; t = im[i]; im[i] = im[j]; im[j] = t; } }
    for (var len = 2; len <= n; len <<= 1) {
        var ang = -2 * Math.PI / len, wr = Math.cos(ang), wi = Math.sin(ang);
        for (i = 0; i < n; i += len) { var cr = 1, ci = 0; for (j = 0; j < len / 2; j++) {
            var ur = re[i + j], ui = im[i + j], vr = re[i + j + len / 2] * cr - im[i + j + len / 2] * ci, vi = re[i + j + len / 2] * ci + im[i + j + len / 2] * cr;
            re[i + j] = ur + vr; im[i + j] = ui + vi; re[i + j + len / 2] = ur - vr; im[i + j + len / 2] = ui - vi; var nr = cr * wr - ci * wi; ci = cr * wi + ci * wr; cr = nr; } }
    }
}
// power (dB) in [lo, hi] Hz over x[t0, t1) (Hann window), and the peak frequency in that range
function spec(x, t0, t1, lo, hi) {
    var N = 1 << 16, re = new Float64Array(N), im = new Float64Array(N), a = Math.round(t0 * SR), b = Math.round(t1 * SR);
    for (var i = a; i < b; i++) re[i - a] = x[i] * (0.5 - 0.5 * Math.cos(2 * Math.PI * (i - a) / (b - a)));
    fft(re, im);
    var p = 0, bk = 0, bv = 0;
    for (var k = Math.ceil(lo * N / SR); k < hi * N / SR; k++) { var v = re[k] * re[k] + im[k] * im[k]; p += v; if (v > bv) { bv = v; bk = k; } }
    return { db: 10 * Math.log10(p + 1e-30), f: bk * SR / N };
}

// 1. every drum x stroke, velocity 1 and 0.4: finite, audible, under full scale, L == R
for (var d = 0; d < 2; d++) for (var s = 0; s < 7; s++) [1, 0.4].forEach(function (v) {
    var r = render([[0, d, s, v]], 1.0, {}), pk = peak(r.L), same = true;
    for (var i = 0; i < r.L.length; i++) if (r.L[i] !== r.R[i]) { same = false; break; }
    check(finite(r.L) && pk > 0.02 && pk < 1 && same, DR[d] + " " + ST[s] + " vel " + v + ": peak " + DB(pk).toFixed(1) + " dBFS, finite, L == R");
});

// 2. Tune +7 st moves the head's strongest tone up a fifth (the ring 100..500 ms in, 250..1000 Hz: head modes, not the 125 Hz body)
for (d = 0; d < 2; d++) {
    var f0 = spec(render([[0, d, 0, 0.8]], 0.6, { tune: 0, vary: 0 }).L, 0.1, 0.5, 250, 1000).f, f7 = spec(render([[0, d, 0, 0.8]], 0.6, { tune: 7, vary: 0 }).L, 0.1, 0.5, 250, 1000 * 1.5).f;
    check(Math.abs(1200 * Math.log2(f7 / f0) - 700) < 40, DR[d] + " open: Tune 0 -> +7 st moves the strongest head tone " + f0.toFixed(1) + " -> " + f7.toFixed(1) + " Hz (" + (1200 * Math.log2(f7 / f0)).toFixed(0) + " ct, want 700)");
    var f1 = spec(render([[0, d, 0, 0.8]], 0.6, { vary: 0 }).L, 0.1, 0.5, F1[d] * 0.8, F1[d] * 1.2).f;
    check(Math.abs(1200 * Math.log2(f1 / F1[d])) < 150, DR[d] + " open, Tune 0: the head's lowest group peaks at " + f1.toFixed(1) + " Hz (want about " + F1[d] + " +-150 ct: a cluster of modes)");
}

// 3. a stroke changed over a ringing drum (a bongo rings ~0.3 s): head ring (250..450 Hz) 120..320 ms after the second hit at 80 ms, relative to the free ring
(function () {
    var free = render([[0, 0, 0, 0.9]], 0.6, {}).L;
    function head(script) { var r = render(script, 0.6, {}).L; return spec(r, 0.2, 0.4, 250, 450).db - spec(free, 0.2, 0.4, 250, 450).db; }
    var hl = head([[0, 0, 0, 0.9], [0.08, 0, 3, 0.01]]), op = head([[0, 0, 0, 0.9], [0.08, 0, 0, 0.01]]), tp = head([[0, 0, 0, 0.9], [0.08, 0, 4, 0.01]]);
    check(hl < -10, "Macho open, then a (very soft) Heel at 80 ms: the head's ring 120..320 ms later is " + hl.toFixed(1) + " dB re free (need < -10)");
    check(tp < -3, "Macho open, then a (very soft) Tip at 80 ms: the fingertip damps the head too (" + tp.toFixed(1) + " dB re free, need < -3)");
    check(hl < op - 3, "the Heel damps the ringing head more than an Open does (" + hl.toFixed(1) + " vs " + op.toFixed(1) + " dB re free)");
})();

// 4. the flam: two Open hits 42 ms apart, the second 0.45 x as loud; its first 40 ms are the Open's (Vary 0); a new stroke cancels the second hit
(function () {
    var o = render([[0, 0, 0, 0.8]], 0.3, { vary: 0 }).L, f = render([[0, 0, 6, 0.8]], 0.3, { vary: 0 }).L, same = true;
    for (var i = 0; i < Math.round(0.04 * SR); i++) if (Math.abs(o[i] - f[i]) > 1e-9) { same = false; break; }
    check(same, "Flam: the first 40 ms are exactly the Open's (Vary 0)");
    function rms(x, t0, t1) { var s = 0, a = Math.round(t0 * SR), b = Math.round(t1 * SR); for (var i = a; i < b; i++) s += x[i] * x[i]; return Math.sqrt(s / (b - a)); }
    var up = DB(rms(f, 0.042, 0.050) / rms(f, 0.034, 0.042));
    check(up > 1 && DB(rms(o, 0.042, 0.050) / rms(o, 0.034, 0.042)) < 0, "Flam: the energy rises again at 42 ms (" + up.toFixed(1) + " dB) where the Open keeps falling");
    var c = render([[0, 0, 6, 0.8], [0.01, 0, 4, 0.8]], 0.3, { vary: 0 }).L, t = render([[0, 0, 4, 0.8]], 0.3, { vary: 0 }).L;
    check(DB(rms(c, 0.06, 0.1) / rms(t, 0.05, 0.09)) < 8, "Flam, then a Tip 10 ms later: the pending second hit is cancelled (no extra hit at 42 ms)");
})();

// 5. the controls: Shell (the 125 Hz body), Decay, Press with the wheel, velocity, Volume, Touch, Skin
(function () {
    var a = render([[0, 1, 4, 0.9]], 0.5, { shell: 100, vary: 0 }).L, b = render([[0, 1, 4, 0.9]], 0.5, { shell: 0, vary: 0 }).L;
    var d1 = spec(a, 0.0, 0.05, 100, 150).db - spec(b, 0.0, 0.05, 100, 150).db;
    check(d1 > 4, "Hembra tip: Shell 100 vs 0 puts " + d1.toFixed(1) + " dB more into 100-150 Hz (the body; need > 4)");
    function ring(dc) { var r = render([[0, 1, 0, 0.9]], 2.2, { decay: dc }).L; return spec(r, 0.7, 1.2, 250, 450).db - spec(r, 0.05, 0.55, 250, 450).db; }
    var r100 = ring(100), r200 = ring(200);
    check(r200 > r100 + 4, "Hembra open: Decay 200 % holds the head longer (0.7-1.2 s vs 0.05-0.55 s: " + r200.toFixed(1) + " dB vs " + r100.toFixed(1) + ")");
    var w0 = spec(render([[0, 0, 0, 0.8]], 0.7, { press: 12, vary: 0 }, 0).L, 0.1, 0.5, 250, 1000).f, w = spec(render([[0, 0, 0, 0.8]], 0.7, { press: 12, vary: 0 }, 1).L, 0.1, 0.5, 250, 2000).f;
    check(Math.abs(1200 * Math.log2(w / w0) - 1200) < 80, "mod wheel at full with Press 12: Macho open's strongest tone " + w0.toFixed(1) + " -> " + w.toFixed(1) + " Hz (" + (1200 * Math.log2(w / w0)).toFixed(0) + " ct, want 1200)");
    var lo = peak(render([[0, 0, 0, 0.2]], 0.5, {}).L), hi = peak(render([[0, 0, 0, 1]], 0.5, {}).L);
    check(DB(hi / lo) > 10, "velocity 0.2 -> 1 spans " + DB(hi / lo).toFixed(1) + " dB (> 10)");
    var v1 = peak(render([[0, 0, 3, 1]], 0.4, { volume: -9 }).L), v2 = peak(render([[0, 0, 3, 1]], 0.4, { volume: -21 }).L);
    check(Math.abs(DB(v1 / v2) - 12) < 1.5, "Volume -9 -> -21 dB lowers the peak by " + DB(v1 / v2).toFixed(1) + " dB (want 12)");
    var t1 = spec(render([[0, 0, 0, 0.9]], 0.3, { touch: 90, vary: 0 }).L, 0, 0.03, 3000, 11000).db - spec(render([[0, 0, 0, 0.9]], 0.3, { touch: 10, vary: 0 }).L, 0, 0.03, 3000, 11000).db;
    check(t1 > 3, "Touch 90 vs 10: " + t1.toFixed(1) + " dB more energy at 3-11 kHz in the first 30 ms (need > 3)");
    function tilt(sk) { var r = render([[0, 0, 0, 0.9]], 0.4, { skin: sk, vary: 0 }).L; return spec(r, 0.01, 0.2, 1500, 4000).db - spec(r, 0.01, 0.2, 250, 500).db; }
    check(tilt(100) > tilt(0) + 8, "Skin 100 vs 0: the 1.5-4 kHz overtones are " + (tilt(100) - tilt(0)).toFixed(1) + " dB stronger against the fundamental (need > 8)");
})();

// 6. Drum changed between hits: the new drum sounds at its own pitch (Hembra's open tone cluster is lower than Macho's)
(function () {
    var r = render([[0, 0, 0, 0.8], [0.4, 1, 0, 0.8]], 1.2, { vary: 0 }).L, m = render([[0, 0, 0, 0.8]], 0.6, { vary: 0 }).L, h = render([[0, 1, 0, 0.8]], 0.6, { vary: 0 }).L;
    var fh = spec(h, 0.1, 0.5, 250, 450).f, fm = spec(m, 0.1, 0.5, 250, 450).f, fr = spec(r, 0.6, 1.1, 250, 450).f;
    check(finite(r) && Math.abs(1200 * Math.log2(fr / fh)) < 60 && fh < fm, "Macho open then Hembra open: the Hembra sounds at " + fr.toFixed(1) + " Hz (alone " + fh.toFixed(1) + ", Macho " + fm.toFixed(1) + ")");
})();

// 7. extremes: every control at min / max, all 14 drum x stroke back to back: finite, under full scale
[0, 1].forEach(function (a) {
    var p = { tune: a ? 12 : -12, decay: a ? 300 : 30, skin: a ? 100 : 0, shell: a ? 100 : 0, touch: a ? 100 : 0, press: 12, volume: 6 }, bad = 0, worst = 0;
    var e = mk(p); e.set("mw", 1);
    for (var d = 0; d < 2; d++) for (var k = 0; k < 7; k++) { e.set("drum", d); e.set("stroke", k); e.set("vel", 1); e.set("trg", ++count); var o = e.run(0.12); if (!finite(o[0])) bad++; worst = Math.max(worst, peak(o[0])); }
    check(!bad && worst <= 1.0001, "controls at " + (a ? "max" : "min") + ", 14 strokes back to back: finite, peak " + worst.toFixed(3));
});

// 8. bongo_midi.js: any note, velocity, running status, wheel, note-offs ignored
(function () {
    var src = fs.readFileSync(path.join(__dirname, "../m4l/bongo_midi.js"), "utf8"), out = [];
    var m = new Function("outlet", src + "\nreturn { msg_int: msg_int };")(function () { out.push([].slice.call(arguments)); });
    function send() { [].slice.call(arguments).forEach(function (b) { m.msg_int(b); }); }
    send(0x90, 61, 127);
    check(out.length === 3 && out[0][1] === "vel" && out[0][2] === 1 && out[1][1] === "trg" && out[1][2] === 1 && out[2][0] === 1 && out[2][1] === "hit", "note 61 -> vel 1, trg 1, display hit");
    out.length = 0; send(0x80, 61, 0); check(out.length === 0, "note-off is ignored");
    out.length = 0; send(0x91, 20, 64, 99, 100);
    check(out.filter(function (o) { return o[1] === "trg"; }).map(function (o) { return o[2]; }).join() === "2,3", "running status: notes 20 and 99 -> trg 2, 3");
    out.length = 0; send(0xB0, 1, 127); check(out.length === 1 && out[0][1] === "mw" && out[0][2] === 1, "CC1 127 -> mw 1");
    out.length = 0; send(0x90, 60, 0); check(out.length === 0, "note-on velocity 0 is a note-off");
})();

console.log(fails ? fails + " FAILED (" + passed + " passed)" : "all " + passed + " passed");
process.exit(fails ? 1 : 0);
