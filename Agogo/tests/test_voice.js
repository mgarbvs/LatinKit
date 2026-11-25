// node tests/test_voice.js -- Agogo (m4l/Agogo.maxpat) in the Node shim: stability, every bell x stroke sounds, tuning, the doublet partners, Mute damping the ring
// (and Open not), bell changed between hits, the controls, extremes, Vary, and agogo_midi.js.
var fs = require("fs"), path = require("path"), S = require("./gen_shim.js"), SR = S.SR;
var CODE = S.loadCode(path.join(__dirname, "../m4l/Agogo.maxpat"));
var T = JSON.parse(fs.readFileSync(path.join(__dirname, "../scripts/agogo_tables.json"), "utf8"));
var fails = 0, count = 0, passed = 0;
function check(ok, what) { console.log((ok ? "ok   " : "FAIL ") + what); if (ok) passed++; else fails++; }
var DB = function (x) { return 20 * Math.log10(x + 1e-12); };
var F1 = [T.bells[0].f1, T.bells[1].f1], BL = ["High", "Low"], ST = ["open", "mute"];
function mk(params) { var e = new S.Engine(CODE); Object.keys(params || {}).forEach(function (k) { e.set(k, params[k]); }); return e; }
// script: [[t seconds, bell, stroke, velocity]] -> {L, R}
function render(script, sec, params) {
    var e = mk(params);
    var n = Math.round(sec * SR), L = new Float64Array(n), R = new Float64Array(n), i = 0;
    function upto(t) { for (; i < Math.min(n, Math.round(t * SR)); i++) { e.tick(); L[i] = e.st.out1; R[i] = e.st.out2; } }
    script.forEach(function (h) { upto(h[0]); e.set("bell", h[1]); e.set("stroke", h[2]); e.set("vel", h[3]); e.set("trg", ++count); });
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


// 1. every bell x stroke, velocity 1 and 0.4: finite, audible, under full scale, L == R
for (var d = 0; d < 2; d++) for (var s = 0; s < 2; s++) [1, 0.4].forEach(function (v) {
    var r = render([[0, d, s, v]], 1.5, {}), pk = peak(r.L), same = true;
    for (var i = 0; i < r.L.length; i++) if (r.L[i] !== r.R[i]) { same = false; break; }
    check(finite(r.L) && pk > 0.02 && pk < 1 && same, BL[d] + " " + ST[s] + " vel " + v + ": peak " + DB(pk).toFixed(1) + " dBFS, finite, L == R");
});

// 2. the table's fundamentals: Tune 0 puts the strongest tone 0.1..0.7 s in at the recorded f1 (+-15 ct); Tune +7 st moves it a fifth; Low is below High
var fund = [];
for (d = 0; d < 2; d++) {
    var f0 = spec(render([[0, d, 0, 0.8]], 0.8, { tune: 0, vary: 0 }).L, 0.1, 0.7, F1[d] * 0.8, F1[d] * 1.2).f, f7 = spec(render([[0, d, 0, 0.8]], 0.8, { tune: 7, vary: 0 }).L, 0.1, 0.7, F1[d] * 0.8 * 1.4983, F1[d] * 1.2 * 1.4983).f;
    fund.push(f0);
    check(Math.abs(1200 * Math.log2(f0 / F1[d])) < 15, BL[d] + " open, Tune 0: strongest tone " + f0.toFixed(1) + " Hz (table f1 " + F1[d] + " Hz, +-15 ct)");
    check(Math.abs(1200 * Math.log2(f7 / f0) - 700) < 20, BL[d] + " open: Tune 0 -> +7 st moves it " + f0.toFixed(1) + " -> " + f7.toFixed(1) + " Hz (" + (1200 * Math.log2(f7 / f0)).toFixed(0) + " ct, want 700)");
}
check(fund[1] < fund[0] * 0.8, "Low's tone " + fund[1].toFixed(0) + " Hz is well below High's " + fund[0].toFixed(0) + " Hz");

// 3. the doublet: High open has a second partner about 10 Hz above the fundamental (11 dB down in the fit): 0.3..1.2 s in, the band 1474..1485 Hz holds more than the band
// 1488..1499 Hz (a single sinusoid's window leakage would fall away on both sides alike)
(function () {
    var x = render([[0, 0, 0, 0.8]], 1.3, { vary: 0 }).L, f1 = F1[0];
    var partner = spec(x, 0.3, 1.2, f1 + 5, f1 + 16).db, away = spec(x, 0.3, 1.2, f1 + 22, f1 + 33).db, below = spec(x, 0.3, 1.2, f1 - 33, f1 - 22).db;
    check(partner > away + 6 && partner > below + 6, "High open: the doublet partner (+5..16 Hz) holds " + (partner - away).toFixed(1) + " dB more than +22..33 Hz and " + (partner - below).toFixed(1) + " dB more than -33..-22 Hz (need > 6)");
})();

// 4. Mute: short; the ring on the bell is stopped by it, an Open does not stop it; a Mute is quieter than the Open
(function () {
    function ring(x, a, b) { return spec(x, a, b, F1[0] * 0.5, F1[0] * 4).db; }
    var op = render([[0, 0, 0, 0.8]], 1.0, { vary: 0 }).L, mu = render([[0, 0, 1, 0.8]], 1.0, { vary: 0 }).L;
    var drop = ring(mu, 0.3, 0.5) - ring(op, 0.3, 0.5);
    check(drop < -25, "High: Mute's 0.3..0.5 s is " + drop.toFixed(1) + " dB under the Open's (need < -25)");
    check(peak(mu) < peak(op), "High: Mute is quieter than Open (" + DB(peak(mu)).toFixed(1) + " vs " + DB(peak(op)).toFixed(1) + " dBFS)");
    function after(stroke) { var r = render([[0, 0, 0, 0.9], [0.2, 0, stroke, 0.01]], 1.2, { vary: 0 }).L; return ring(r, 0.5, 0.9) - ring(render([[0, 0, 0, 0.9]], 1.2, { vary: 0 }).L, 0.5, 0.9); }
    var m = after(1), o = after(0);
    check(m < -12, "High open, then a (very soft) Mute at 200 ms: the ring 0.5..0.9 s is " + m.toFixed(1) + " dB re free (need < -12)");
    check(o > -3, "High open, then a (very soft) Open at 200 ms: the ring is untouched (" + o.toFixed(1) + " dB re free, need > -3)");
})();

// 5. the controls: Decay, Tone, Touch, velocity, Volume
(function () {
    function slope(dc) { var r = render([[0, 1, 0, 0.9]], 2.4, { decay: dc, vary: 0 }).L; return spec(r, 0.3, 0.6, 900, 1100).db - spec(r, 0.05, 0.35, 900, 1100).db; }
    var s100 = slope(100), s200 = slope(200);
    check(s200 > s100 + 4, "Low open: Decay 200 % holds the tone longer (0.3-0.6 s vs 0.05-0.35 s: " + s200.toFixed(1) + " dB vs " + s100.toFixed(1) + ")");
    function tilt(t) { var r = render([[0, 0, 0, 0.9]], 0.5, { tone: t, vary: 0 }).L; return spec(r, 0.01, 0.15, 5000, 11000).db - spec(r, 0.01, 0.15, 1300, 1700).db; }
    check(tilt(100) > tilt(0) + 8, "Tone 100 vs 0: the 5-11 kHz partials are " + (tilt(100) - tilt(0)).toFixed(1) + " dB stronger against the fundamental (need > 8)");
    var lo = peak(render([[0, 0, 0, 0.2]], 0.5, {}).L), hi = peak(render([[0, 0, 0, 1]], 0.5, {}).L);
    check(DB(hi / lo) > 10, "velocity 0.2 -> 1 spans " + DB(hi / lo).toFixed(1) + " dB (> 10)");
    var v1 = peak(render([[0, 0, 1, 1]], 0.4, { volume: -9 }).L), v2 = peak(render([[0, 0, 1, 1]], 0.4, { volume: -21 }).L);
    check(Math.abs(DB(v1 / v2) - 12) < 1.5, "Volume -9 -> -21 dB lowers the peak by " + DB(v1 / v2).toFixed(1) + " dB (want 12)");
    function hf(t) { return spec(render([[0.02, 0, 0, 0.9]], 0.3, { touch: t, vary: 0 }).L, 0.01, 0.07, 3000, 11000).db; }
    var t1 = hf(90) - hf(10);
    check(t1 > 3, "Touch 90 vs 10: " + t1.toFixed(1) + " dB more energy at 3-11 kHz in the first 50 ms (need > 3)");
})();

// 6. Bell changed between hits: High then Low: the Low sounds at its own pitch
(function () {
    var r = render([[0, 0, 0, 0.8], [1.0, 1, 0, 0.8]], 1.9, { vary: 0 }).L, lo = render([[0, 1, 0, 0.8]], 0.8, { vary: 0 }).L;
    var fr = spec(r, 1.1, 1.7, F1[1] * 0.8, F1[1] * 1.2).f, fl = spec(lo, 0.1, 0.7, F1[1] * 0.8, F1[1] * 1.2).f;
    check(finite(r) && Math.abs(1200 * Math.log2(fr / fl)) < 20, "High open then Low open: the Low sounds at " + fr.toFixed(1) + " Hz (alone " + fl.toFixed(1) + ")");
})();

// 7. Vary: eight High opens 2 s apart; each mode's gain jitters (1.5 dB std per mode at 100 %): the fundamental band's level differs hit to hit, at Vary 0 it does not
(function () {
    function sd(vary) {
        var r = render([0, 1, 2, 3, 4, 5, 6, 7].map(function (k) { return [2 * k, 0, 0, 0.8]; }), 16.1, { vary: vary }).L, v = [];
        for (var k = 0; k < 8; k++) v.push(spec(r.subarray(Math.round(2 * k * SR), Math.round((2 * k + 1.5) * SR)), 0.02, 0.5, F1[0] - 3, F1[0] + 3).db);
        var m = v.reduce(function (a, b) { return a + b; }) / 8;
        return Math.sqrt(v.reduce(function (a, b) { return a + (b - m) * (b - m); }, 0) / 7);
    }
    var s100 = sd(100), s0 = sd(0);
    check(s100 > 0.5 && s100 < 4 && s0 < 0.3, "Vary 100: the fundamental's level differs hit to hit by " + s100.toFixed(2) + " dB (want 0.5..4); Vary 0: " + s0.toFixed(2) + " dB (want < 0.3)");
})();

// 8. extremes: every control at min / max, all 4 bell x stroke back to back: finite, under full scale
[0, 1].forEach(function (a) {
    var p = { tune: a ? 12 : -12, decay: a ? 300 : 30, tone: a ? 100 : 0, touch: a ? 100 : 0, volume: 6 }, bad = 0, worst = 0;
    var e = mk(p);
    for (var d = 0; d < 2; d++) for (var k = 0; k < 2; k++) { e.set("bell", d); e.set("stroke", k); e.set("vel", 1); e.set("trg", ++count); var o = e.run(0.12); if (!finite(o[0])) bad++; worst = Math.max(worst, peak(o[0])); }
    check(!bad && worst <= 1.0001, "controls at " + (a ? "max" : "min") + ", 4 strokes back to back: finite, peak " + worst.toFixed(3));
});

// 9. agogo_midi.js: any note, velocity, running status, note-offs and the mod wheel ignored
(function () {
    var src = fs.readFileSync(path.join(__dirname, "../m4l/agogo_midi.js"), "utf8"), out = [];
    var m = new Function("outlet", src + "\nreturn { msg_int: msg_int };")(function () { out.push([].slice.call(arguments)); });
    function send() { [].slice.call(arguments).forEach(function (b) { m.msg_int(b); }); }
    send(0x90, 61, 127);
    check(out.length === 3 && out[0][1] === "vel" && out[0][2] === 1 && out[1][1] === "trg" && out[1][2] === 1 && out[2][0] === 1 && out[2][1] === "hit", "note 61 -> vel 1, trg 1, display hit");
    out.length = 0; send(0x80, 61, 0); check(out.length === 0, "note-off is ignored");
    out.length = 0; send(0x91, 20, 64, 99, 100);
    check(out.filter(function (o) { return o[1] === "trg"; }).map(function (o) { return o[2]; }).join() === "2,3", "running status: notes 20 and 99 -> trg 2, 3");
    out.length = 0; send(0xB0, 1, 127); check(out.length === 0, "CC1 (mod wheel) is ignored: Agogo has no wheel function");
    out.length = 0; send(0x90, 60, 0); check(out.length === 0, "note-on velocity 0 is a note-off");
})();

console.log(fails ? fails + " FAILED (" + passed + " passed)" : "all " + passed + " passed");
process.exit(fails ? 1 : 0);
