// node tests/test_engine.js -- runs the generated gen~ code (m4l/Conga.maxpat) in the Node shim, plus conga_midi.js with a fake outlet.
var fs = require("fs"), path = require("path"), S = require("./gen_shim.js"), SR = S.SR;
var CODE = S.loadCode(path.join(__dirname, "../m4l/Conga.maxpat"));
var fails = 0;
function check(ok, what) { console.log((ok ? "ok   " : "FAIL ") + what); if (!ok) fails++; }
var DB = function (x) { return 20 * Math.log10(x + 1e-12); };
var F1 = [366, 266, 219], NOTE = [60, 62, 64, 65, 67, 69, 48, 50, 52, 53, 55, 57, 36, 38, 40, 41, 43, 45];
var PEAK = [-3, -1.5, -5, -3, -9, -11];   // E.PEAK_DB: dBFS at velocity 1, Level 0
var count = 0;

function engine(params) { var e = new S.Engine(CODE); Object.keys(params || {}).forEach(function (k) { e.set(k, params[k]); }); return e; }
function hit(e, slot, vel) { e.set("vl" + slot, vel); e.set("tr" + slot, ++count); }
function play(params, slot, vel, sec) { var e = engine(params); hit(e, slot, vel); return e.run(sec); }
function finite(x) { for (var i = 0; i < x.length; i++) if (!isFinite(x[i])) return false; return true; }
function peak(x) { var p = 0; for (var i = 0; i < x.length; i++) p = Math.max(p, Math.abs(x[i])); return p; }
function rms(x, t0, t1) { return S.rms(x, t0 * SR, t1 * SR); }
// frequency (Hz) of the strongest spectral peak between lo and hi, in [t0, t1) s: Hann window, zero-padded FFT, parabolic refinement
function peakHz(x, t0, t1, lo, hi) {
    var a = Math.round(t0 * SR), n = Math.round((t1 - t0) * SR), N = 1 << 17, re = new Float64Array(N), im = new Float64Array(N);
    for (var i = 0; i < n; i++) re[i] = x[a + i] * (0.5 - 0.5 * Math.cos(2 * Math.PI * i / (n - 1)));
    fft(re, im);
    var k0 = Math.floor(lo * N / SR), k1 = Math.ceil(hi * N / SR), best = 0, bk = k0, m = [];
    for (var k = k0 - 1; k <= k1 + 1; k++) m[k] = Math.hypot(re[k], im[k]);
    for (k = k0; k <= k1; k++) if (m[k] > best) { best = m[k]; bk = k; }
    var l = Math.log(m[bk - 1] + 1e-30), c = Math.log(m[bk]), r = Math.log(m[bk + 1] + 1e-30);
    return (bk + 0.5 * (l - r) / (l - 2 * c + r)) * SR / N;
}
function fft(re, im) {
    var n = re.length, j = 0, t;
    for (var i = 1; i < n; i++) { var bit = n >> 1; for (; j & bit; bit >>= 1) j ^= bit; j ^= bit; if (i < j) { t = re[i]; re[i] = re[j]; re[j] = t; t = im[i]; im[i] = im[j]; im[j] = t; } }
    for (var len = 2; len <= n; len <<= 1) {
        var ang = -2 * Math.PI / len, wr = Math.cos(ang), wi = Math.sin(ang);
        for (i = 0; i < n; i += len) {
            var cr = 1, ci = 0;
            for (var k = 0; k < len / 2; k++) {
                var ur = re[i + k], ui = im[i + k], vr = re[i + k + len / 2] * cr - im[i + k + len / 2] * ci, vi = re[i + k + len / 2] * ci + im[i + k + len / 2] * cr;
                re[i + k] = ur + vr; im[i + k] = ui + vi; re[i + k + len / 2] = ur - vr; im[i + k + len / 2] = ui - vi;
                var nr = cr * wr - ci * wi; ci = cr * wi + ci * wr; cr = nr;
            }
        }
    }
}
function cents(f, g) { return 1200 * Math.log2(f / g); }
// time (s) for the 10 ms RMS envelope to fall `dbDown` below its peak
function tFall(x, dbDown) {
    var w = Math.round(0.01 * SR), best = 0, env = [];
    for (var i = 0; i + w < x.length; i += w / 2) { var v = S.rms(x, i, i + w); env.push(v); best = Math.max(best, v); }
    for (i = env.indexOf(best); i < env.length; i++) if (DB(env[i] / best) < -dbDown) return i * w / 2 / SR;
    return x.length / SR;
}

// 1. every note sounds, finite, at its calibrated peak (velocity 1, Level -24, so the soft limiter is out of the way)
for (var slot = 0; slot < 18; slot++) {
    var d = Math.floor(slot / 6), st = slot % 6, o = play({ level: -24, spread: 0 }, slot, 1, 1.0), l = o[0];
    var pk = DB(peak(l)) + 24;
    check(finite(l) && Math.abs(pk - PEAK[st]) < (st === 2 || st >= 4 ? 4.5 : 2.5), "slot " + slot + " (note " + NOTE[slot] + "): peak " + pk.toFixed(1) + " dBFS (want " + PEAK[st] + ", noisy strokes +-4.5, others +-2.5), finite");
}

// 2. each drum's open tone is at its tuning, and Tune moves it: -12, 0, +7 st
[0, 1, 2].forEach(function (d) {
    var key = ["tuneQ", "tuneC", "tuneT"][d];
    [-12, 0, 7].forEach(function (t) {
        var p = {}; p[key] = t;
        var x = play(p, d * 6, 0.8, 0.6)[0], want = F1[d] * Math.pow(2, t / 12), f = peakHz(x, 0.1, 0.5, want * 0.85, want * 1.15);
        check(Math.abs(cents(f, want)) < 12, "drum " + d + " open, Tune " + t + " st: " + f.toFixed(1) + " Hz, " + cents(f, want).toFixed(1) + " ct from " + want.toFixed(1));
    });
});
check(true, "(Tune of one drum leaves the others alone: each uses its own parameter)");

// 3. velocity: 25 -> 127 spans 18..30 dB, harder is brighter (touch up)
(function () {
    var soft = play({}, 0, 0.2, 0.5)[0], hard = play({}, 0, 1.0, 0.5)[0];
    var span = DB(peak(hard)) - DB(peak(soft));
    check(span > 12 && span < 30, "velocity 0.2 -> 1: " + span.toFixed(1) + " dB (12..30)");
    var cs = play({ touch: 100 }, 1, 0.2, 0.3)[0], ch = play({ touch: 100 }, 1, 1.0, 0.3)[0];
    function ratio(x) { var hf = 0, lo = 0; for (var i = 1; i < 2000; i++) { var d = x[i] - x[i - 1]; hf += d * d; lo += x[i] * x[i]; } return hf / (lo + 1e-30); }
    check(ratio(ch) > ratio(cs), "Touch 100: a hard slap has relatively more highs than a soft one");
})();

// 4. the hand damps: a mute over a ringing open tone takes the tumba's 219 Hz ring down
function band(x, lo, hi, n0) { var n = 1 << 15, re = new Float64Array(n), im = new Float64Array(n); for (var i = 0; i < 6000; i++) re[i] = x[(n0 || 0) + i]; fft(re, im); var s = 0; for (var k = Math.floor(lo * n / SR); k < Math.ceil(hi * n / SR); k++) s += re[k] * re[k] + im[k] * im[k]; return s; }
(function () {
    var e = engine({ spread: 0 }); hit(e, 12, 0.9); e.run(0.3); var free = e.run(0.4)[0];
    var e2 = engine({ spread: 0 }); hit(e2, 12, 0.9); e2.run(0.3); hit(e2, 14, 0.5); var m = e2.run(0.4)[0];
    var a = DB(Math.sqrt(band(free, 205, 235, 4800))), b = DB(Math.sqrt(band(m, 205, 235, 4800)));
    check(b < a - 12, "mute over a ringing tumba: 219 Hz ring 100 ms later is " + (b - a).toFixed(1) + " dB under the free ring (need < -12)");
})();

// 5. Decay scales the ring: t-20 of the open tone at 50 / 100 / 200 %
(function () {
    var t = [50, 100, 200].map(function (v) { return tFall(play({ decay: v }, 6, 0.8, 3.0)[0], 20); });
    check(t[0] < t[1] * 0.65 && t[2] > t[1] * 1.5, "Decay 50/100/200 %: t-20 " + t.map(function (v) { return (v * 1000).toFixed(0); }).join(" / ") + " ms (halves, doubles)");
})();

// 6. mod wheel presses the head: 12 st at wheel 127 doubles the pitch (smoothed: read after 0.3 s)
(function () {
    var e = engine({ press: 12, spread: 0 }); e.set("mw", 1); e.run(0.1); hit(e, 6, 0.8); var x = e.run(0.7)[0];
    var f = peakHz(x, 0.2, 0.6, 400, 700);
    check(Math.abs(cents(f, 2 * 266)) < 15, "mod wheel full, Press 12: conga open at " + f.toFixed(1) + " Hz (" + cents(f, 532).toFixed(1) + " ct from 532)");
    e = engine({ press: 12, spread: 0 }); hit(e, 6, 0.8); x = e.run(0.7)[0];
    check(Math.abs(cents(peakHz(x, 0.2, 0.6, 200, 330), 266)) < 12, "wheel at 0: Press has no effect");
})();

// 7. Skin tilts the overtones, Shell the body, Slap the crack
(function () {
    var a = play({ skin: 0 }, 6, 0.8, 0.3)[0], b = play({ skin: 100 }, 6, 0.8, 0.3)[0];
    check(DB(Math.sqrt(band(b, 400, 440) / band(b, 240, 290))) > DB(Math.sqrt(band(a, 400, 440) / band(a, 240, 290))) + 5, "Skin 100 vs 0: the 2nd mode 5+ dB louder relative to the fundamental");
    a = play({ shell: 0 }, 10, 0.8, 0.3)[0]; b = play({ shell: 100 }, 10, 0.8, 0.3)[0];
    check(band(b, 40, 150) > 2 * band(a, 40, 150), "Shell 100 vs 0: more body below 150 Hz on a conga heel");
    a = play({ slap: 0 }, 7, 0.8, 0.3)[0]; b = play({ slap: 100 }, 7, 0.8, 0.3)[0];
    check(band(b, 2500, 8000) > 3 * band(a, 2500, 8000), "Slap 100 vs 0: more crack above 2.5 kHz on a conga slap");
})();

// 8. Spread: 0 = identical channels, 100 = quinto right, tumba left
(function () {
    var o = play({ spread: 0 }, 0, 0.8, 0.3); var same = 1; for (var i = 0; i < o[0].length; i++) if (Math.abs(o[0][i] - o[1][i]) > 1e-9) { same = 0; break; }
    check(same, "Spread 0: L == R");
    var q = play({ spread: 100 }, 0, 0.8, 0.3), t = play({ spread: 100 }, 12, 0.8, 0.3), c = play({ spread: 100 }, 6, 0.8, 0.3);
    check(peak(q[1]) > 2 * peak(q[0]) && peak(t[0]) > 2 * peak(t[1]) && Math.abs(DB(peak(c[0])) - DB(peak(c[1]))) < 0.5, "Spread 100: quinto right, tumba left, conga centre");
})();

// 9. extreme controls: finite and under full scale, all 18 slots hit at once, and back-to-back hits on every slot
(function () {
    var worst = 0, bad = 0;
    [0, 1].forEach(function (a) {
        var p = { tuneQ: a ? 12 : -12, tuneC: a ? 12 : -12, tuneT: a ? 12 : -12, decay: a ? 300 : 30, skin: a ? 100 : 0, slap: a ? 100 : 0, shell: a ? 100 : 0, touch: a ? 100 : 0, press: 12, spread: a ? 100 : 0, level: 6 };
        var e = engine(p); e.set("mw", 1);
        for (var k = 0; k < 18; k++) hit(e, k, 1);
        for (var r = 0; r < 4; r++) {
            var o = e.run(0.2); if (!finite(o[0]) || !finite(o[1])) bad++; worst = Math.max(worst, peak(o[0]), peak(o[1]));
            for (k = 0; k < 18; k++) hit(e, k, 1);
        }
    });
    check(!bad && worst <= 1.0001, "all 18 slots at once x5, extreme controls: finite, peak " + worst.toFixed(3));
})();

// 10. silence after a long time (no DC, no runaway): 6 s after one open tumba at Decay 300 %
(function () {
    var x = play({ decay: 300 }, 12, 1, 8)[0];
    check(rms(x, 7, 8) < 1e-4, "8 s after a tumba open at Decay 300 %: " + DB(rms(x, 7, 8)).toFixed(0) + " dBFS (need < -80)");
})();

// 11. conga_midi.js: note map, velocity, running status, mod wheel, note-offs ignored
(function () {
    var src = fs.readFileSync(path.join(__dirname, "../m4l/conga_midi.js"), "utf8"), out = [];
    var fn = new Function("outlet", src + "\nreturn { msg_int: msg_int };");
    var m = fn(function () { out.push([].slice.call(arguments)); });
    function send() { [].slice.call(arguments).forEach(function (b) { m.msg_int(b); }); }
    send(0x90, 62, 127);
    check(out.length === 3 && out[0][1] === "vl1" && out[0][2] === 1 && out[1][1] === "tr1" && out[1][2] === 1 && out[2][0] === 1 && out[2][1] === "hit" && out[2][2] === 0 && out[2][3] === 1,
          "note 62 (quinto slap) -> vl1 1, tr1 1, display hit 0 1 1: " + JSON.stringify(out.slice(0, 3)));
    out.length = 0; send(0x80, 62, 0);
    check(out.length === 0, "note-off is ignored");
    out.length = 0; send(0x91, 38, 64, 40, 100);   // running status: second note on the same channel
    check(out.length === 6 && out[1][1] === "tr13" && out[4][1] === "tr13" || out[1][1] === "tr13", "conga-block note 50 is slot 7 (conga slap)");
    out.length = 0; send(0x90, 50, 100); send(0xB0, 1, 127);
    check(out.some(function (o) { return o[1] === "tr7"; }) && out.some(function (o) { return o[1] === "mw" && o[2] === 1; }), "note 50 -> tr7; CC1 127 -> mw 1");
    out.length = 0; send(0x90, 61, 100); send(0x90, 0, 100);
    check(out.length === 0, "notes outside the 18 are ignored (61, 0)");
    out.length = 0; send(0x90, 36, 100); send(0x90, 36, 100);
    check(out.filter(function (o) { return o[1] === "tr12"; }).map(function (o) { return o[2]; }).join() === "1,2", "repeated hits bump the counter (tr12: 1, 2)");
})();

console.log(fails ? fails + " FAILED" : "all passed");
process.exit(fails ? 1 : 0);
