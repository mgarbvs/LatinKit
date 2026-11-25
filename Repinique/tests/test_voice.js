// node tests/test_voice.js -- Repinique (m4l/Repinique.maxpat) in the Node shim: stability, every stroke sounds, tuning (the head follows Tune, the shell does not), no glide, the flam, stroke changes over a ringing
// drum (a mute damps the head, an open stroke barely touches it), the controls, extremes, and repinique_midi.js.
var fs = require("fs"), path = require("path"), S = require("./gen_shim.js"), SR = S.SR;
var CODE = S.loadCode(path.join(__dirname, "../m4l/Repinique.maxpat"));
var fails = 0, count = 0, passed = 0;
function check(ok, what) { console.log((ok ? "ok   " : "FAIL ") + what); if (ok) passed++; else fails++; }
var DB = function (x) { return 20 * Math.log10(x + 1e-12); };
var F1 = 356.5, ST = ["open", "rimshot", "rim", "hand", "mute", "flam"];
function mk(params) { var e = new S.Engine(CODE); Object.keys(params || {}).forEach(function (k) { e.set(k, params[k]); }); return e; }
// script: [[t seconds, stroke, velocity]] -> {L, R}
function render(script, sec, params, mw) {
    var e = mk(params); if (mw !== undefined) e.set("mw", mw);
    var n = Math.round(sec * SR), L = new Float64Array(n), R = new Float64Array(n), i = 0;
    function upto(t) { for (; i < Math.min(n, Math.round(t * SR)); i++) { e.tick(); L[i] = e.st.out1; R[i] = e.st.out2; } }
    script.forEach(function (h) { upto(h[0]); e.set("stroke", h[1]); e.set("vel", h[2]); e.set("trg", ++count); });
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
    var N = 1 << 17, re = new Float64Array(N), im = new Float64Array(N), a = Math.round(t0 * SR), b = Math.round(t1 * SR);
    for (var i = a; i < b; i++) re[i - a] = x[i] * (0.5 - 0.5 * Math.cos(2 * Math.PI * (i - a) / (b - a)));
    fft(re, im);
    var p = 0, bk = 0, bv = 0, P = function (k) { return re[k] * re[k] + im[k] * im[k]; };
    for (var k = Math.ceil(lo * N / SR); k < hi * N / SR; k++) { var v = P(k); p += v; if (v > bv) { bv = v; bk = k; } }
    var l = Math.log(P(bk - 1) + 1e-30), c = Math.log(P(bk) + 1e-30), r = Math.log(P(bk + 1) + 1e-30);     // parabolic interpolation of the peak (log power)
    return { db: 10 * Math.log10(p + 1e-30), f: (bk + 0.5 * (l - r) / (l - 2 * c + r)) * SR / N };
}

// 1. every stroke, velocity 1 and 0.4: finite, audible, under full scale, L == R
for (var s = 0; s < 6; s++) [1, 0.4].forEach(function (v) {
    var r = render([[0, s, v]], 1.2, {}), pk = peak(r.L), same = true;
    for (var i = 0; i < r.L.length; i++) if (r.L[i] !== r.R[i]) { same = false; break; }
    check(finite(r.L) && pk > 0.02 && pk < 1 && same, ST[s] + " vel " + v + ": peak " + DB(pk).toFixed(1) + " dBFS, finite, L == R");
});

// 2. the head follows Tune: Tune 0 puts the open tone at the recorded 356 Hz, -7 st a fifth lower; the shell's 1117 Hz does not move (Rimshot, 0.05-0.4 s)
(function () {
    var f0 = spec(render([[0, 0, 0.8]], 1.0, { tune: 0, vary: 0 }).L, 0.15, 0.6, 330, 385).f, f7 = spec(render([[0, 0, 0.8]], 1.0, { tune: -7, vary: 0 }).L, 0.15, 0.6, 215, 265).f;
    check(Math.abs(1200 * Math.log2(f7 / f0) + 700) < 25, "open: Tune 0 -> -7 st moves the open tone " + f0.toFixed(1) + " -> " + f7.toFixed(1) + " Hz (" + (1200 * Math.log2(f7 / f0)).toFixed(0) + " ct, want -700)");
    check(Math.abs(1200 * Math.log2(f0 / F1)) < 25, "open, Tune 0: the settled tone is " + f0.toFixed(1) + " Hz (recorded: 356-357)");
    var s0 = spec(render([[0, 1, 0.8]], 0.6, { tune: 0, vary: 0 }).L, 0.05, 0.4, 1090, 1145).f, s1 = spec(render([[0, 1, 0.8]], 0.6, { tune: 12, vary: 0 }).L, 0.05, 0.4, 1090, 1145).f;
    check(Math.abs(1200 * Math.log2(s1 / s0)) < 6, "rimshot: the shell's 1117 Hz mode stays put under Tune 0 -> +12 st (" + s0.toFixed(1) + " -> " + s1.toFixed(1) + " Hz)");
})();

// 3. no glide (the recordings' head tone is flat): the open tone 0.05-0.2 s and 0.3-0.7 s in agree within 25 ct, at velocity 0.9 and 0.3
(function () {
    [0.9, 0.3].forEach(function (v) {
        var r = render([[0, 0, v]], 1.0, { vary: 0 }).L, ct = 1200 * Math.log2(spec(r, 0.05, 0.2, 330, 385).f / spec(r, 0.3, 0.7, 330, 385).f);
        check(Math.abs(ct) < 25, "open velocity " + v + ": the tone's pitch early vs late differs by " + ct.toFixed(1) + " ct (want < 25: no glide)");
    });
})();

// 3b. the flam: two Open hits 42 ms apart, the second 0.45 x as loud; its first 40 ms are the Open's (Vary 0); a new stroke cancels the second hit
(function () {
    var o = render([[0, 0, 0.8]], 0.3, { vary: 0 }).L, f = render([[0, 5, 0.8]], 0.3, { vary: 0 }).L, same = true;
    for (var i = 0; i < Math.round(0.04 * SR); i++) if (Math.abs(o[i] - f[i]) > 1e-9) { same = false; break; }
    check(same, "Flam: the first 40 ms are exactly the Open's (Vary 0)");
    function rms(x, t0, t1) { var s = 0, a = Math.round(t0 * SR), b = Math.round(t1 * SR); for (var i = a; i < b; i++) s += x[i] * x[i]; return Math.sqrt(s / (b - a)); }
    var up = DB(rms(f, 0.042, 0.050) / rms(f, 0.034, 0.042));
    check(up > DB(rms(o, 0.042, 0.050) / rms(o, 0.034, 0.042)) + 2, "Flam: the energy rises again at 42 ms (" + up.toFixed(1) + " dB) against the Open's " + DB(rms(o, 0.042, 0.050) / rms(o, 0.034, 0.042)).toFixed(1) + " dB");
    var c = render([[0, 5, 0.8], [0.01, 2, 0.8]], 0.3, { vary: 0 }).L, t = render([[0.01, 2, 0.8]], 0.3, { vary: 0 }).L;
    check(DB(rms(c, 0.06, 0.1) / rms(t, 0.05, 0.09)) < 8, "Flam, then a Rim 10 ms later: the pending second hit is cancelled (" + DB(rms(c, 0.06, 0.1) / rms(t, 0.05, 0.09)).toFixed(1) + " dB, need < 8)");
})();

// 4. a stroke changed over a ringing drum (an Open rings 0.5 s): head ring (250-420 Hz) 0.1..0.25 s after the second hit at 0.2 s, relative to the free ring
(function () {
    var free = render([[0, 0, 0.9]], 1.0, {}).L;
    function head(script) { var r = render(script, 1.0, {}).L; return spec(r, 0.3, 0.45, 250, 420).db - spec(free, 0.3, 0.45, 250, 420).db; }
    var mu = head([[0, 0, 0.9], [0.2, 4, 0.01]]), op = head([[0, 0, 0.9], [0.2, 0, 0.01]]), ha = head([[0, 0, 0.9], [0.2, 3, 0.01]]);
    check(mu < -10, "open, then a (very soft) Mute at 0.2 s: the head's ring 0.1..0.25 s later is " + mu.toFixed(1) + " dB re free (need < -10)");
    check(mu < op - 3 && mu < ha - 3, "the Mute damps the ringing head more than an Open (" + op.toFixed(1) + ") or a Hand (" + ha.toFixed(1) + ") does (" + mu.toFixed(1) + " dB re free)");
})();

// 5. the controls: Decay, Press with the wheel, velocity, Volume, Touch, Skin
(function () {
    function ring(dc) { var r = render([[0, 0, 0.9]], 4.0, { decay: dc, vary: 0 }).L; return spec(r, 0.5, 0.8, 250, 420).db - spec(r, 0.1, 0.4, 250, 420).db; }
    var r100 = ring(100), r200 = ring(200);
    check(r200 > r100 + 4, "open: Decay 200 % holds the tone longer (0.5-0.8 s vs 0.1-0.4 s: " + r200.toFixed(1) + " dB vs " + r100.toFixed(1) + ")");
    var w0 = spec(render([[0, 0, 0.8]], 1.0, { press: 12, tune: -12, vary: 0 }, 0).L, 0.15, 0.6, 150, 210).f, w = spec(render([[0, 0, 0.8]], 1.0, { press: 12, tune: -12, vary: 0 }, 1).L, 0.15, 0.6, 320, 400).f;
    check(Math.abs(1200 * Math.log2(w / w0) - 1200) < 60, "mod wheel at full with Press 12 (Tune -12): the open tone " + w0.toFixed(1) + " -> " + w.toFixed(1) + " Hz (" + (1200 * Math.log2(w / w0)).toFixed(0) + " ct, want 1200)");
    var lo = peak(render([[0, 0, 0.2]], 0.5, {}).L), hi = peak(render([[0, 0, 1]], 0.5, {}).L);
    check(DB(hi / lo) > 10, "velocity 0.2 -> 1 spans " + DB(hi / lo).toFixed(1) + " dB (> 10)");
    var v1 = peak(render([[0, 1, 1]], 0.4, { volume: -9 }).L), v2 = peak(render([[0, 1, 1]], 0.4, { volume: -21 }).L);
    check(Math.abs(DB(v1 / v2) - 12) < 1.5, "Volume -9 -> -21 dB lowers the peak by " + DB(v1 / v2).toFixed(1) + " dB (want 12)");
    var t1 = spec(render([[0, 0, 0.9]], 0.3, { touch: 90, vary: 0 }).L, 0, 0.03, 3000, 11000).db - spec(render([[0, 0, 0.9]], 0.3, { touch: 10, vary: 0 }).L, 0, 0.03, 3000, 11000).db;
    check(t1 > 3, "open, Touch 90 vs 10: " + t1.toFixed(1) + " dB more energy at 3-11 kHz in the first 30 ms (need > 3)");
    var o1 = spec(render([[0, 0, 0.9]], 0.5, { touch: 90, vary: 0 }).L, 0, 0.1, 1000, 3000).db - spec(render([[0, 0, 0.9]], 0.5, { touch: 10, vary: 0 }).L, 0, 0.1, 1000, 3000).db;
    check(o1 > 3, "open, Touch 90 vs 10: " + o1.toFixed(1) + " dB more energy at 1-3 kHz in the first 100 ms (the stick's hardness; need > 3)");
    function tilt(sk) { var r = render([[0, 1, 0.9]], 0.4, { skin: sk, vary: 0 }).L; return spec(r, 0.0, 0.1, 1500, 4000).db - spec(r, 0.0, 0.1, 250, 500).db; }
    check(tilt(100) > tilt(0) + 8, "rimshot, Skin 100 vs 0: the 1.5-4 kHz part is " + (tilt(100) - tilt(0)).toFixed(1) + " dB stronger against 250-500 Hz (need > 8)");
})();

// 6. extremes: every control at min / max, all 6 strokes back to back: finite, under full scale
[0, 1].forEach(function (a) {
    var p = { tune: a ? 12 : -12, decay: a ? 300 : 30, skin: a ? 100 : 0, touch: a ? 100 : 0, press: 12, volume: 6 }, bad = 0, worst = 0;
    var e = mk(p); e.set("mw", 1);
    for (var k = 0; k < 6; k++) { e.set("stroke", k); e.set("vel", 1); e.set("trg", ++count); var o = e.run(0.15); if (!finite(o[0])) bad++; worst = Math.max(worst, peak(o[0])); }
    check(!bad && worst <= 1.0001, "controls at " + (a ? "max" : "min") + ", 6 strokes back to back: finite, peak " + worst.toFixed(3));
});

// 7. repinique_midi.js: any note, velocity, running status, wheel, note-offs ignored
(function () {
    var src = fs.readFileSync(path.join(__dirname, "../m4l/repinique_midi.js"), "utf8"), out = [];
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
