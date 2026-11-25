// node tests/test_musical.js -- Pandeiro Musical (m4l/PandeiroMusical.maxpat) in the Node shim: the MIDI key sets the head's pitch (settled fundamental = mtof(key) x 2^(Tune/12)), the jingles
// and the body do not follow it, modes above 0.45 x the sample rate are left out, every key is finite, pandeiro_midi_musical.js sends the key before the hit, and the device is FROZEN:
// its gen~ code must hash to FROZEN_SHA (taken when the kit was last the sound the Musical device keeps). Re-fitting the kit must not move it.
var fs = require("fs"), path = require("path"), crypto = require("crypto"), S = require("./gen_shim.js"), SR = S.SR;
var CODE = S.loadCode(path.join(__dirname, "../m4l/PandeiroMusical.maxpat"));
var FROZEN_SHA = "c7bcf38fd34012a37db50213e0d1e4ea3e7d81be94d6c15b0470d782ff8b117d";
var fails = 0, passed = 0, count = 0;
function check(ok, what) { console.log((ok ? "ok   " : "FAIL ") + what); if (ok) passed++; else fails++; }
var DR = ["Pandeiro", "Tamborim"], ROW = [0, 6];            // the menu entry that plays each instrument's own open row: Thumb, Open
function mtof(n) { return 440 * Math.pow(2, (n - 69) / 12); }
function render(script, sec, params) {   // script: [[t, inst, stroke, vel, note]] -> Float64Array (mono)
    var e = new S.Engine(CODE); Object.keys(params || {}).forEach(function (k) { e.set(k, params[k]); });
    var n = Math.round(sec * SR), L = new Float64Array(n), i = 0;
    function upto(t) { for (; i < Math.min(n, Math.round(t * SR)); i++) { e.tick(); L[i] = e.st.out1; } }
    script.forEach(function (h) { upto(h[0]); e.set("inst", h[1]); e.set("stroke", h[2]); e.set("vel", h[3]); e.set("note", h[4]); e.set("trg", ++count); });
    upto(sec);
    return L;
}
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
// spectrum of x[t0, t1) (Hann, 2^17 points): {f: peak frequency in [lo, hi] (parabolic on the log magnitude), db: band power, peakdb: peak over median}
function spec(x, t0, t1, lo, hi) {
    var N = 1 << 17, re = new Float64Array(N), im = new Float64Array(N), a = Math.round(t0 * SR), b = Math.round(t1 * SR);
    for (var i = a; i < b; i++) re[i - a] = x[i] * (0.5 - 0.5 * Math.cos(2 * Math.PI * (i - a) / (b - a)));
    fft(re, im);
    var mag = new Float64Array(N / 2), p = 0, bk = 0, bv = 0, k0 = Math.ceil(lo * N / SR), k1 = Math.floor(hi * N / SR), band = [];
    for (var k = 0; k < N / 2; k++) mag[k] = Math.sqrt(re[k] * re[k] + im[k] * im[k]);
    for (k = k0; k <= k1; k++) { p += mag[k] * mag[k]; band.push(mag[k]); if (mag[k] > bv) { bv = mag[k]; bk = k; } }
    var l = Math.log(mag[bk - 1] + 1e-30), c = Math.log(mag[bk] + 1e-30), r = Math.log(mag[bk + 1] + 1e-30);
    band.sort(function (u, v) { return u - v; });
    return { f: (bk + 0.5 * (l - r) / (l - 2 * c + r)) * SR / N, db: 10 * Math.log10(p + 1e-30), peakdb: 20 * Math.log10(bv / (band[band.length >> 1] + 1e-30)) };
}
var ct = function (f, f0) { return 1200 * Math.log2(f / f0); };
function head(inst, note, params, mw, sec) {      // the ring 0.15..0.5 s after a hit, the head's fundamental +-4 %
    var e = Object.assign({ vary: 0, jingles: 0 }, params || {});
    return render([[0.02, inst, ROW[inst], 0.8, note]], sec || 0.55, Object.assign(e, mw === undefined ? {} : { mw: mw }));
}

// 0. the device is frozen
var sha = crypto.createHash("sha256").update(CODE).digest("hex");
check(sha === FROZEN_SHA, "the Musical gen~ code is the frozen one (sha256 " + sha.slice(0, 16) + "..., frozen " + FROZEN_SHA.slice(0, 16) + "...): the kit's re-fit and generator changes do not reach it");

// 1. the key sets the head's fundamental: mtof(key), Tune 0, within 5 ct (keys 48 = 131 Hz .. 108 = 4.2 kHz; below that the 125 Hz body and the higher modes crowd the window)
DR.forEach(function (name, d) {
    var worst = 0, wk = 0;
    [48, 55, 60, 66, 72, 84, 96, 108].forEach(function (k) {
        var f0 = mtof(k), f = spec(head(d, k), 0.15, 0.5, f0 * 0.96, f0 * 1.04).f;
        if (Math.abs(ct(f, f0)) > worst) { worst = Math.abs(ct(f, f0)); wk = k; }
    });
    check(worst < 5, name + ": the head's fundamental sits on mtof(key) for keys 48..108 (worst " + worst.toFixed(2) + " ct at key " + wk + ", need < 5)");
    var a = spec(head(d, 60), 0.15, 0.5, 250, 275).f, b = spec(head(d, 72), 0.15, 0.5, 500, 550).f;
    check(Math.abs(ct(b, a) - 1200) < 5, name + ": key 60 -> 72 is " + ct(b, a).toFixed(1) + " ct (want 1200 +- 5)");
});

// 2. Tune adds to the key in semitones; both instruments sit on the same pitch at the same key (their modes differ, the fundamental does not)
DR.forEach(function (name, d) {
    var res = [[60, 7], [60, -12], [72, -12], [48, 12], [66, 3.5]].map(function (kt) {
        var want = mtof(kt[0]) * Math.pow(2, kt[1] / 12), f = spec(head(d, kt[0], { tune: kt[1] }), 0.15, 0.5, want * 0.96, want * 1.04).f;
        return ct(f, want);
    });
    check(Math.max.apply(null, res.map(Math.abs)) < 5, name + ": key + Tune add in semitones (key 60 +7, 60 -12, 72 -12, 48 +12, 66 +3.5 st: errors " + res.map(function (r) { return r.toFixed(1); }).join(", ") + " ct, need < 5)");
});
(function () {
    var f = [0, 1].map(function (d) { return spec(head(d, 66), 0.15, 0.5, 340, 380).f; });
    check(Math.abs(ct(f[0], f[1])) < 5, "Pandeiro and Tamborim at key 66 have the same fundamental (" + f[0].toFixed(2) + " / " + f[1].toFixed(2) + " Hz)");
})();

// 3. the mod wheel still presses the head by Press semitones, on top of the key
DR.forEach(function (name, d) {
    var w0 = spec(head(d, 60, { press: 12 }, 0), 0.15, 0.5, 250, 275).f, w1 = spec(head(d, 60, { press: 12 }, 1), 0.15, 0.5, 500, 550).f;
    check(Math.abs(ct(w1, w0) - 1200) < 5, name + ": mod wheel at full with Press 12 at key 60: " + w0.toFixed(1) + " -> " + w1.toFixed(1) + " Hz (" + ct(w1, w0).toFixed(1) + " ct, want 1200)");
});

// 4. the jingles and the body do not follow the key: the Pandeiro Slap's 8-15 kHz power over its first 0.25 s is the same at key 36 and key 84 (Vary 0, the noise is seeded)
(function () {
    function hf(k) { return spec(render([[0.02, 0, 2, 0.9, k]], 0.4, { vary: 0 }), 0.02, 0.27, 8000, 15000).db; }
    var a = hf(36), b = hf(84);
    check(Math.abs(a - b) < 0.5, "Pandeiro Slap: the jingles' 8-15 kHz power is " + a.toFixed(1) + " dB at key 36, " + b.toFixed(1) + " dB at key 84 (they do not retune; within 0.5 dB)");
    var sh = spec(render([[0.02, 0, 4, 0.9, 36]], 0.6, { vary: 0 }), 0.0, 0.3, 8000, 15000).db - spec(render([[0.02, 0, 4, 0.9, 96]], 0.6, { vary: 0 }), 0.0, 0.3, 8000, 15000).db;
    check(Math.abs(sh) < 0.5, "Pandeiro Shake (jingles alone): 8-15 kHz power differs by " + sh.toFixed(2) + " dB between key 36 and key 96 (within 0.5)");
})();

// 5. every key plays: 0..127, both instruments, every stroke (Roll included) at the extremes of Tune, wheel: finite, under full scale, audible; no mode folds back above 0.45 x the sample rate
(function () {
    var bad = 0, worst = 0, quiet = 0, alias = -1e9;
    for (var d = 0; d < 2; d++) [0, 1, 12, 36, 60, 84, 100, 108, 116, 120, 127].forEach(function (k) {
        for (var s = 0; s < 8; s++) {
            var x = render([[0.02, d, s, 1, k]], 1.4, { tune: 12, mw: 1, press: 12 }), pk = 0, ok = true;
            for (var i = 0; i < x.length; i++) { if (!isFinite(x[i])) ok = false; pk = Math.max(pk, Math.abs(x[i])); }
            if (!ok) bad++;
            worst = Math.max(worst, pk);
            if (pk < 0.02) quiet++;
        }
        var y = render([[0.02, d, ROW[d], 0.8, k]], 0.7, { vary: 0, jingles: 0 });
        alias = Math.max(alias, spec(y, 0.15, 0.6, 0.45 * SR, 0.499 * SR).peakdb);
    });
    check(!bad && worst <= 1.0001 && !quiet, "keys 0..127 (11 of them), both instruments, all 8 strokes, Tune +12, wheel full: finite " + (!bad) + ", peak " + worst.toFixed(3) + ", silent strokes " + quiet);
    check(alias < 25, "no mode folds back over Nyquist: the strongest line above 0.45 x sr stands " + alias.toFixed(1) + " dB over its band's median, at the worst of keys 0..127 (an ungated mode stands 47..97 dB; need < 25)");
})();

// 6. pandeiro_midi_musical.js: the key goes out before the velocity and the hit counter
(function () {
    var src = fs.readFileSync(path.join(__dirname, "../m4l/pandeiro_midi_musical.js"), "utf8"), out = [];
    var m = new Function("outlet", src + "\nreturn { msg_int: msg_int };")(function () { out.push([].slice.call(arguments)); });
    [0x90, 61, 127, 0x91, 20, 64, 99, 100, 0xB0, 1, 127, 0x80, 61, 0].forEach(function (b) { m.msg_int(b); });
    var s = out.filter(function (o) { return o[0] === 0; }).map(function (o) { return o[1] + " " + o[2]; }).join(", ");
    check(s === "note 61, vel 1, trg 1, note 20, vel 0.5039370078740157, trg 2, note 99, vel 0.7874015748031497, trg 3, mw 1", "note-ons send note, vel, trg in that order (running status too); CC1 -> mw; note-offs ignored: " + s);
})();

console.log(fails ? fails + " FAILED (" + passed + " passed)" : "all " + passed + " passed");
process.exit(fails ? 1 : 0);
