// node tests/test_voice.js -- Timbales (m4l/Timbales.maxpat) in the Node shim: stability, every drum x stroke sounds, tuning, stroke changes over a ringing
// drum (a muted stroke damps the head, a cascara barely touches it), the controls, extremes, and timbales_midi.js.
var fs = require("fs"), path = require("path"), S = require("./gen_shim.js"), SR = S.SR;
var CODE = S.loadCode(path.join(__dirname, "../m4l/Timbales.maxpat"));
var fails = 0, count = 0, passed = 0;
function check(ok, what) { console.log((ok ? "ok   " : "FAIL ") + what); if (ok) passed++; else fails++; }
var DB = function (x) { return 20 * Math.log10(x + 1e-12); };
var F1 = [200, 120], DR = ["High", "Low"], ST = ["open", "rimshot", "cascara", "paila", "rim click", "muted"];
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
for (var d = 0; d < 2; d++) for (var s = 0; s < 6; s++) [1, 0.4].forEach(function (v) {
    var r = render([[0, d, s, v]], 1.0, {}), pk = peak(r.L), same = true;
    for (var i = 0; i < r.L.length; i++) if (r.L[i] !== r.R[i]) { same = false; break; }
    check(finite(r.L) && pk > 0.02 && pk < 1 && same, DR[d] + " " + ST[s] + " vel " + v + ": peak " + DB(pk).toFixed(1) + " dBFS, finite, L == R");
});

// 2. the open tone at Tune 0 and +7 st (head fundamental 60..400 ms in)
for (d = 0; d < 2; d++) [0, 7].forEach(function (t) {
    var r = render([[0, d, 0, 0.8]], 0.7, { tune: t }), want = F1[d] * Math.pow(2, t / 12), sp = spec(r.L, 0.1, 0.5, want * 0.85, want * 1.15);
    check(Math.abs(1200 * Math.log2(sp.f / want)) < 25, DR[d] + " open, Tune " + t + ": " + sp.f.toFixed(1) + " Hz, want " + want.toFixed(1));
});

// 3. a stroke changed over a ringing drum: head ring (around f1) 150..400 ms after the second hit, relative to the free ring
(function () {
    var free = render([[0, 0, 0, 0.9]], 1.0, {}).L;
    function head(script) { var r = render(script, 1.0, {}).L; return spec(r, 0.55, 0.9, 170, 240).db - spec(free, 0.55, 0.9, 170, 240).db; }
    var mut = head([[0, 0, 0, 0.9], [0.3, 0, 5, 0.01]]), cas = head([[0, 0, 0, 0.9], [0.3, 0, 2, 0.6]]), pai = head([[0, 0, 0, 0.9], [0.3, 0, 3, 0.6]]);
    check(mut < -10, "High open, then a (very soft) Muted at 300 ms: the head's ring 250..600 ms later is " + mut.toFixed(1) + " dB re free (need < -10)");
    check(cas > -4, "High open, then Cascara at 300 ms: the head ring is barely touched (" + cas.toFixed(1) + " dB re free, need > -4)");
    check(pai > -4, "High open, then Paila at 300 ms: the head ring is barely touched (" + pai.toFixed(1) + " dB re free, need > -4)");
})();

// 4. the shell: Shell 0 silences it, Ring lengthens it, a Cascara is mostly shell (energy above 1.5 kHz exceeds the head's below 400 Hz)
(function () {
    var a = render([[0, 0, 3, 0.9]], 0.8, { shell: 50 }).L, b = render([[0, 0, 3, 0.9]], 0.8, { shell: 0 }).L;
    var d1 = spec(a, 0.02, 0.3, 1500, 3000).db - spec(b, 0.02, 0.3, 1500, 3000).db;   // above the High head's top mode (1.4 kHz): shell only
    check(d1 > 15, "Paila: Shell 0 takes the shell out (1.5-3 kHz " + d1.toFixed(1) + " dB lower than at 50, need > 15)");
    var r1 = render([[0, 0, 3, 0.9]], 1.2, { ring: 100 }).L, r2 = render([[0, 0, 3, 0.9]], 1.2, { ring: 250 }).L;
    var dr = spec(r2, 0.3, 0.6, 700, 1800).db - spec(r1, 0.3, 0.6, 700, 1800).db;
    check(dr > 4, "Paila: Ring 250 % keeps the shell ringing (300..600 ms, " + dr.toFixed(1) + " dB above Ring 100, need > 4)");
    var c = render([[0, 0, 2, 0.9]], 0.5, {}).L;
    check(spec(c, 0, 0.1, 1500, 11000).db > spec(c, 0, 0.1, 100, 400).db + 10, "Cascara: highs (1.5-11 kHz) are > 10 dB over the head's band (100-400 Hz)");
})();

// 5. Decay lengthens the head; Press with the wheel raises it; velocity spans; Volume
(function () {
    function ring(dc) { var r = render([[0, 1, 0, 0.9]], 3.2, { decay: dc }).L; return spec(r, 1.0, 1.6, 100, 140).db - spec(r, 0.1, 0.7, 100, 140).db; }
    var r100 = ring(100), r200 = ring(200);
    check(r200 > r100 + 4, "Low open: Decay 200 % holds the head longer (1.0-1.6 s vs 0.1-0.7 s: " + r200.toFixed(1) + " dB vs " + r100.toFixed(1) + ")");
    var w = render([[0, 0, 0, 0.8]], 0.7, { press: 12 }, 1).L, sp = spec(w, 0.2, 0.55, 300, 500);
    check(Math.abs(1200 * Math.log2(sp.f / 400)) < 60, "mod wheel at full with Press 12: High open's fundamental -> " + sp.f.toFixed(1) + " Hz (want about 400)");
    var lo = peak(render([[0, 0, 0, 0.2]], 0.5, {}).L), hi = peak(render([[0, 0, 0, 1]], 0.5, {}).L);
    check(DB(hi / lo) > 10, "velocity 0.2 -> 1 spans " + DB(hi / lo).toFixed(1) + " dB (> 10)");
    var v1 = peak(render([[0, 0, 1, 1]], 0.4, { volume: -9 }).L), v2 = peak(render([[0, 0, 1, 1]], 0.4, { volume: -21 }).L);
    check(Math.abs(DB(v1 / v2) - 12) < 1.5, "Volume -9 -> -21 dB lowers the peak by " + DB(v1 / v2).toFixed(1) + " dB (want 12)");
    var s1 = spec(render([[0, 0, 0, 0.9]], 0.3, { stick: 90 }).L, 0, 0.03, 3000, 11000).db - spec(render([[0, 0, 0, 0.9]], 0.3, { stick: 10 }).L, 0, 0.03, 3000, 11000).db;
    check(s1 > 3, "Stick 90 vs 10: " + s1.toFixed(1) + " dB more energy at 3-11 kHz in the first 30 ms (need > 3)");
})();

// 6. Drum changed between hits: the new drum sounds at its own pitch
(function () {
    var r = render([[0, 0, 0, 0.8], [0.4, 1, 0, 0.8]], 1.2, {}).L, sp = spec(r, 0.6, 1.1, 100, 140);
    check(finite(r) && Math.abs(1200 * Math.log2(sp.f / F1[1])) < 80, "High open then Low open: the Low sounds at " + sp.f.toFixed(1) + " Hz (want about " + F1[1] + ")");
})();

// 7. extremes: every control at min / max, all 12 drum x stroke back to back: finite, under full scale
[0, 1].forEach(function (a) {
    var p = { tune: a ? 12 : -12, decay: a ? 300 : 30, shell: a ? 100 : 0, ring: a ? 300 : 30, stick: a ? 100 : 0, press: 12, volume: 6 }, bad = 0, worst = 0;
    var e = mk(p); e.set("mw", 1);
    for (var d = 0; d < 2; d++) for (var k = 0; k < 6; k++) { e.set("drum", d); e.set("stroke", k); e.set("vel", 1); e.set("trg", ++count); var o = e.run(0.12); if (!finite(o[0])) bad++; worst = Math.max(worst, peak(o[0])); }
    check(!bad && worst <= 1.0001, "controls at " + (a ? "max" : "min") + ", 12 strokes back to back: finite, peak " + worst.toFixed(3));
});

// 8. timbales_midi.js: any note, velocity, running status, wheel, note-offs ignored
(function () {
    var src = fs.readFileSync(path.join(__dirname, "../m4l/timbales_midi.js"), "utf8"), out = [];
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
