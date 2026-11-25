// node tests/test_musical.js -- Surdo Musical (m4l/SurdoMusical.maxpat) in the Node shim: the played key sets the open tone (mtof(key) x 2^(Tune/12)), Tune adds in
// semitones, modes above 0.45 sr are muted, extreme keys stay finite, surdo_musical_midi.js sends the key ahead of the trigger.
var fs = require("fs"), path = require("path"), S = require("./gen_shim.js"), SR = S.SR;
var CODE = S.loadCode(path.join(__dirname, "../m4l/SurdoMusical.maxpat"));
var fails = 0, passed = 0, count = 0;
function check(ok, what) { console.log((ok ? "ok   " : "FAIL ") + what); if (ok) passed++; else fails++; }
var mtof = function (k) { return 440 * Math.pow(2, (k - 69) / 12); };
function mk(params) { var e = new S.Engine(CODE); Object.keys(params || {}).forEach(function (k) { e.set(k, params[k]); }); return e; }
function hit(e, key, stroke, vel) { e.set("key", key); e.set("stroke", stroke); e.set("vel", vel); e.set("trg", ++count); }
function render(key, sec, params, stroke, vel) { var e = mk(params); hit(e, key, stroke || 0, vel || 0.8); return e.run(sec)[0]; }
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
// peak frequency in [lo, hi] Hz over x[t0, t1) (Hann window, parabolic interpolation of log power)
function peakHz(x, t0, t1, lo, hi) {
    var N = 1 << 17, re = new Float64Array(N), im = new Float64Array(N), a = Math.round(t0 * SR), b = Math.round(t1 * SR);
    for (var i = a; i < b; i++) re[i - a] = x[i] * (0.5 - 0.5 * Math.cos(2 * Math.PI * (i - a) / (b - a)));
    fft(re, im);
    var bk = 0, bv = 0, P = function (k) { return re[k] * re[k] + im[k] * im[k]; };
    for (var k = Math.ceil(lo * N / SR); k < hi * N / SR; k++) if (P(k) > bv) { bv = P(k); bk = k; }
    var l = Math.log(P(bk - 1) + 1e-30), c = Math.log(P(bk) + 1e-30), r = Math.log(P(bk + 1) + 1e-30);
    return (bk + 0.5 * (l - r) / (l - 2 * c + r)) * SR / N;
}
function f0(key, tune) { var f = mtof(key) * Math.pow(2, (tune || 0) / 12); return peakHz(render(key, 1.3, { tune: tune || 0, vary: 0 }), 0.5, 1.2, 0.93 * f, 1.08 * f); }   // the Open's settled tone (the glide is gone by 0.5 s)
function ct(a, b) { return 1200 * Math.log2(a / b); }
function finite(x) { for (var i = 0; i < x.length; i++) if (!isFinite(x[i])) return false; return true; }
function peak(x) { var p = 0; for (var i = 0; i < x.length; i++) p = Math.max(p, Math.abs(x[i])); return p; }

// 1. the engine's f1 is exactly mtof(key) x 2^(Tune/12) (the Hz the head modes are built on), for every key and Tune -12 / 0 / +12 / +3.3
(function () {
    var worst = 0;
    [-12, 0, 12, 3.3].forEach(function (t) { for (var k = 0; k < 128; k++) {
        var e = mk({ tune: t }); hit(e, k, 0, 0.8); e.run(0.01);
        worst = Math.max(worst, Math.abs(ct(e.st.vF1, mtof(k) * Math.pow(2, t / 12))));
    } });
    check(worst < 0.01, "f1 = mtof(key) x 2^(Tune/12) for all 128 keys, Tune -12 / 0 / 12 / 3.3: worst error " + worst.toFixed(4) + " ct");
})();

// 2. key 41 vs key 53: the open tone is 12 st higher
(function () {
    var a = f0(41), b = f0(53);
    check(Math.abs(ct(b, a) - 1200) < 5, "key 41 -> 53: the open tone " + a.toFixed(2) + " -> " + b.toFixed(2) + " Hz (" + ct(b, a).toFixed(1) + " ct, want 1200 +-5)");
})();

// 3. measured open tone against mtof(key), keys 28..60: within 5 cents
(function () {
    var worst = 0, wk = 0;
    for (var k = 28; k <= 60; k++) { var e = ct(f0(k), mtof(k)); if (Math.abs(e) > Math.abs(worst)) { worst = e; wk = k; } }
    check(Math.abs(worst) < 5, "keys 28..60 (41 .. 262 Hz): measured open tone within 5 ct of mtof(key); worst " + worst.toFixed(2) + " ct at key " + wk);
})();

// 4. Tune adds to the key in semitones: key 41 + Tune 7 = key 48 + Tune 0; Tune -12 at key 53 = key 41
(function () {
    var a = f0(41, 7), b = f0(48, 0), c = f0(53, -12), d = f0(41, 0);
    check(Math.abs(ct(a, b)) < 5 && Math.abs(ct(c, d)) < 5, "Tune adds: key 41 +7 st vs key 48: " + ct(a, b).toFixed(1) + " ct; key 53 -12 st vs key 41: " + ct(c, d).toFixed(1) + " ct");
})();

// 5. modes above 0.45 sr are muted: key 110 (4.7 kHz): the 1.0 ratio mode (4.7 kHz) sounds, the 5.86 ratio (27 kHz) is off; key 127 + Tune 12 (25 kHz): exactly the modes whose frequency passes 0.45 sr are off
(function () {
    var e = mk({}); hit(e, 110, 0, 1); e.run(0.01);
    check(e.st.vW5 > 0 && e.st.vW16 === 0, "key 110: the fundamental's gain is kept (" + e.st.vW5.toExponential(1) + "), the 5.86x mode above 0.45 sr is muted");
    var e2 = mk({ tune: 12 }); hit(e2, 127, 0, 1); e2.run(0.01);
    var RATIOS = [0.30, 0.42, 0.54, 0.74, 0.85, 1.00, 1.20, 1.45, 1.65, 1.85, 2.40, 2.76, 3.00, 3.83, 4.40, 5.20, 5.86], wrong = 0, off = 0;   // a mode within 10 % of the limit may go either way (the glide is up to 6 % sharp at the hit)
    RATIOS.forEach(function (r, m) { var muted = e2.st["vW" + m] === 0, x = mtof(127) * 2 * r / (0.45 * SR); off += muted; if (Math.abs(x - 1) > 0.1 && muted !== (x > 1)) wrong++; });
    check(wrong === 0 && off >= 12, "key 127 + Tune 12 (25 kHz): " + off + " of 17 head modes above 0.45 sr are muted, the lower ones sound (" + wrong + " wrong)");
})();

// 6. extremes: keys 0 .. 127 in steps, Tune -12 / +12, every stroke, wheel full: finite, under full scale
(function () {
    var bad = 0, worst = 0;
    [0, 5, 12, 28, 41, 60, 84, 100, 115, 127].forEach(function (k) { [-12, 12].forEach(function (t) { for (var s = 0; s < 4; s++) {
        var e = mk({ tune: t, press: 12, volume: 6 }); e.set("mw", 1); hit(e, k, s, 1); var o = e.run(0.4)[0];
        if (!finite(o)) bad++; worst = Math.max(worst, peak(o));
    } }); });
    check(!bad && worst <= 1.0001, "keys 0..127, Tune +-12, 4 strokes, wheel full, Volume +6: finite, peak " + worst.toFixed(3));
    var e = mk({}); var seq = 0;
    [41, 100, 20, 127, 0, 53].forEach(function (k, i) { hit(e, k, i % 4, 1); var o = e.run(0.05)[0]; if (!finite(o)) seq++; });
    check(!seq, "six notes in a row across the keyboard (new note = new hit, mono): finite");
})();

// 7. surdo_musical_midi.js: key goes out before vel and trg; the plain Surdo's surdo_midi.js is unchanged (test_voice.js checks it)
(function () {
    var src = fs.readFileSync(path.join(__dirname, "../m4l/surdo_musical_midi.js"), "utf8"), out = [];
    var m = new Function("outlet", src + "\nreturn { msg_int: msg_int };")(function () { out.push([].slice.call(arguments)); });
    [0x90, 38, 100].forEach(function (b) { m.msg_int(b); });
    check(out.length === 4 && out[0][1] === "key" && out[0][2] === 38 && out[1][1] === "vel" && out[2][1] === "trg" && out[3][0] === 1, "note 38 -> key 38, vel, trg, display hit (in this order)");
    out.length = 0; [0x80, 38, 0].forEach(function (b) { m.msg_int(b); }); check(out.length === 0, "note-off is ignored");
    out.length = 0; [0x90, 45, 90].forEach(function (b) { m.msg_int(b); }); check(out[0][1] === "key" && out[0][2] === 45, "running status: note 45 -> key 45");
})();

console.log(fails ? fails + " FAILED (" + passed + " passed)" : "all " + passed + " passed");
process.exit(fails ? 1 : 0);
