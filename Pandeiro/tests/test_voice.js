// node tests/test_voice.js -- Pandeiro (m4l/Pandeiro.maxpat) in the Node shim: stability, every instrument x menu stroke sounds, the stroke map (a fallback plays the mapped row exactly),
// tuning, a stroke changed over a ringing head, the Roll, the jingles (Jingles control, Tamborim has none), the controls, extremes, and pandeiro_midi.js.
var fs = require("fs"), path = require("path"), S = require("./gen_shim.js"), SR = S.SR;
var CODE = S.loadCode(path.join(__dirname, "../m4l/Pandeiro.maxpat"));
var fails = 0, count = 0, passed = 0;
function check(ok, what) { console.log((ok ? "ok   " : "FAIL ") + what); if (ok) passed++; else fails++; }
var DB = function (x) { return 20 * Math.log10(x + 1e-12); };
var F1 = [250, 450], DR = ["Pandeiro", "Tamborim"], ST = ["Thumb", "Finger", "Slap", "Rim", "Shake", "Roll", "Open", "Mute"];
// the engine's own stroke map (scripts/pandeiro_engine.py MAP): menu entry -> table row, per instrument
var MAP = JSON.parse(require("child_process").execFileSync("python3", ["-c", "import sys,json;sys.path.insert(0,'" + path.join(__dirname, "../scripts") + "');import pandeiro_engine as E;print(json.dumps(E.MAP))"], { encoding: "utf8" }));
function mk(params) { var e = new S.Engine(CODE); Object.keys(params || {}).forEach(function (k) { e.set(k, params[k]); }); return e; }
// script: [[t seconds, instrument, menu stroke, velocity]] -> {L, R}
function render(script, sec, params, mw) {
    var e = mk(params); if (mw !== undefined) e.set("mw", mw);
    var n = Math.round(sec * SR), L = new Float64Array(n), R = new Float64Array(n), i = 0;
    function upto(t) { for (; i < Math.min(n, Math.round(t * SR)); i++) { e.tick(); L[i] = e.st.out1; R[i] = e.st.out2; } }
    script.forEach(function (h) { upto(h[0]); e.set("inst", h[1]); e.set("stroke", h[2]); e.set("vel", h[3]); e.set("trg", ++count); });
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

// 1. every instrument x menu stroke, velocity 1 and 0.4: finite, audible, under full scale, L == R
for (var d = 0; d < 2; d++) for (var s = 0; s < 8; s++) [1, 0.4].forEach(function (v) {
    var r = render([[0, d, s, v]], 1.6, {}), pk = peak(r.L), same = true;
    for (var i = 0; i < r.L.length; i++) if (r.L[i] !== r.R[i]) { same = false; break; }
    check(finite(r.L) && pk > 0.02 && pk < 1 && same, DR[d] + " " + ST[s] + " vel " + v + ": peak " + DB(pk).toFixed(1) + " dBFS, finite, L == R");
});

// 1b. the stroke map: a menu entry the instrument lacks plays the mapped row exactly (Vary 0: the same noise draws, so the render is identical sample for sample)
for (d = 0; d < 2; d++) for (s = 0; s < 8; s++) for (var s2 = s + 1; s2 < 8; s2++) if (MAP[d][s] === MAP[d][s2] && s !== 5 && s2 !== 5) (function () {
    var a = render([[0, d, s, 0.8]], 0.5, { vary: 0 }).L, b = render([[0, d, s2, 0.8]], 0.5, { vary: 0 }).L, same = true;
    for (var i = 0; i < a.length; i++) if (a[i] !== b[i]) { same = false; break; }
    check(same, DR[d] + ": menu " + ST[s] + " and " + ST[s2] + " both play row " + MAP[d][s] + ", identical output");
})();
(function () {   // and different rows differ
    var a = render([[0, 0, 0, 0.8]], 0.3, { vary: 0 }).L, b = render([[0, 0, 1, 0.8]], 0.3, { vary: 0 }).L, df = 0;
    for (var i = 0; i < a.length; i++) df = Math.max(df, Math.abs(a[i] - b[i]));
    check(df > 0.01, "Pandeiro Thumb and Finger are different strokes (max sample difference " + df.toFixed(3) + ")");
})();

// 2. Tune +7 st moves the head's strongest tone up a fifth (the ring 100..500 ms in, above the 125 Hz body)
for (d = 0; d < 2; d++) {
    var lo = d ? 250 : 150, hi = d ? 2000 : 1500, st = d ? 6 : 0;
    var f0 = spec(render([[0, d, st, 0.8]], 0.6, { tune: 0, vary: 0 }).L, 0.1, 0.5, lo, hi).f, f7 = spec(render([[0, d, st, 0.8]], 0.6, { tune: 7, vary: 0 }).L, 0.1, 0.5, lo, hi * 1.5).f;
    check(Math.abs(1200 * Math.log2(f7 / f0) - 700) < 40, DR[d] + " " + ST[st] + ": Tune 0 -> +7 st moves the strongest head tone " + f0.toFixed(1) + " -> " + f7.toFixed(1) + " Hz (" + (1200 * Math.log2(f7 / f0)).toFixed(0) + " ct, want 700)");
}
(function () {   // the instruments are tuned differently: the tamborim's head is higher (more of its ring above 700 Hz than below)
    function bal(L) { return spec(L, 0.05, 0.25, 700, 3000).db - spec(L, 0.05, 0.25, 150, 700).db; }
    var p = bal(render([[0, 0, 0, 0.8]], 0.6, { vary: 0, jingles: 0 }).L), t = bal(render([[0, 1, 6, 0.8]], 0.6, { vary: 0, jingles: 0 }).L);
    check(t > p + 6, "Tamborim Open's ring has " + t.toFixed(1) + " dB more at 0.7-3 kHz than at 0.15-0.7 kHz; the Pandeiro Thumb's " + p.toFixed(1) + " (need 6 dB higher)");
})();

// 3. a stroke changed over a ringing head: the head's ring 120..320 ms after the second hit at 80 ms, relative to the free ring
(function () {
    var free = render([[0, 1, 6, 0.9]], 0.6, {}).L;
    function head(script) { var r = render(script, 0.6, {}).L; return spec(r, 0.2, 0.4, 350, 1200).db - spec(free, 0.2, 0.4, 350, 1200).db; }
    var mu = head([[0, 1, 6, 0.9], [0.08, 1, 7, 0.01]]), op = head([[0, 1, 6, 0.9], [0.08, 1, 6, 0.01]]);
    check(mu < -6, "Tamborim Open, then a (very soft) Mute at 80 ms: the head's ring 120..320 ms later is " + mu.toFixed(1) + " dB re free (need < -6)");
    check(mu < op - 3, "the Mute damps the ringing head more than an Open does (" + mu.toFixed(1) + " vs " + op.toFixed(1) + " dB re free)");
})();

// 4. the Roll: ROLL_N taps 1/18.2 s apart (the Finger row repeated), cancelled by a new stroke. The tamborim's (no jingles) shows the taps themselves; the pandeiro's taps are 19 dB under its jingles.
(function () {
    var r = render([[0, 1, 5, 0.8]], 2.0, { vary: 0 }).L, N = Math.round(0.06 * SR);   // 60 ms: > one tap period, so the window always holds a tap
    function lvl(x, t) { var s = 0, a = Math.round(t * SR); for (var i = a; i < a + N; i++) s += x[i] * x[i]; return Math.sqrt(s / N); }
    var late = lvl(r, 0.9), early = lvl(r, 0.3), quiet = lvl(r, 1.6);
    // 0.9 s is inside the fade over the last ROLL_FADE_N taps (up to ROLL_FADE_DB = 12 dB, fitted to the recording; tap levels also
    // spread +-3 dB), so "still tapping" is judged against the roll's own early level, not a fixed floor.
    check(early > 0.003 && DB(late / early) > -18 && DB(quiet / late) < -25, "Tamborim Roll: still tapping at 0.3 s and 0.9 s (" + DB(early).toFixed(0) + ", " + DB(late).toFixed(0) + " dB: within 18 dB of the early taps), silent by 1.6 s (" + DB(quiet).toFixed(0) + " dB)");
    var env = new Float64Array(Math.round(1.1 * SR)), w = Math.round(0.002 * SR);
    for (var i = 0; i < env.length; i++) { var s = 0; for (var k = 0; k < w && i + k < r.length; k++) s += r[i + k] * r[i + k]; env[i] = Math.sqrt(s / w); }
    var m = 0; for (i = 0; i < env.length; i++) m += env[i]; m /= env.length;
    var best = 0, bf = 0;
    for (var f = 8; f <= 40; f += 0.1) { var re = 0, im = 0; for (i = 0; i < env.length; i += 4) { var a = 2 * Math.PI * f * i / SR; re += (env[i] - m) * Math.cos(a); im += (env[i] - m) * Math.sin(a); } var p = re * re + im * im; if (p > best) { best = p; bf = f; } }
    check(Math.abs(bf - 18.2) < 1.5, "Tamborim Roll: the envelope's strongest 8-40 Hz line is " + bf.toFixed(1) + " Hz (the tap rate, want 18.2)");
    var c = render([[0, 1, 5, 0.8], [0.2, 1, 6, 0.8]], 1.5, { vary: 0 }).L, last = 0, t = Math.round(0.8 * SR);
    for (i = t; i < c.length; i++) last = Math.max(last, Math.abs(c[i]));
    check(DB(last) < -50, "a Roll cancelled by a new stroke at 0.2 s: nothing after 0.8 s (" + DB(last).toFixed(0) + " dBFS)");
    var pr = render([[0, 0, 5, 0.8]], 2.0, { vary: 0 }).L;
    check(lvl(pr, 0.9) > 0.01 && DB(lvl(pr, 1.6) / lvl(pr, 0.9)) < -25, "Pandeiro Roll: jingles still going at 0.9 s (" + DB(lvl(pr, 0.9)).toFixed(0) + " dB), gone by 1.6 s (" + DB(lvl(pr, 1.6)).toFixed(0) + " dB)");
    var h = render([[0, 0, 5, 0.8]], 2.0, { vary: 0, jingles: 0 }).L;
    check(DB(lvl(h, 0.9)) < DB(lvl(pr, 0.9)) - 15, "Pandeiro Roll: its head taps alone (Jingles 0) are " + (DB(lvl(pr, 0.9)) - DB(lvl(h, 0.9))).toFixed(0) + " dB under the jingles (the recording's balance: need > 15)");
})();

// 5. the jingles: the Jingles control, Shake without them, and the tamborim's none
(function () {
    function hfe(L, t0, t1) { return spec(L, t0, t1, 8000, 15000).db; }
    var on = render([[0, 0, 2, 0.9]], 0.5, { vary: 0, jingles: 100 }).L, off = render([[0, 0, 2, 0.9]], 0.5, { vary: 0, jingles: 0 }).L;
    check(hfe(on, 0, 0.2) - hfe(off, 0, 0.2) > 20, "Pandeiro Slap: Jingles 100 puts " + (hfe(on, 0, 0.2) - hfe(off, 0, 0.2)).toFixed(1) + " dB more into 8-15 kHz than Jingles 0 (need > 20)");
    var h = render([[0, 0, 2, 0.9]], 0.5, { vary: 0, jingles: 50 }).L;
    check(Math.abs(hfe(on, 0, 0.2) - hfe(h, 0, 0.2) - 6) < 3, "Jingles 50 is " + (hfe(on, 0, 0.2) - hfe(h, 0, 0.2)).toFixed(1) + " dB under Jingles 100 at 8-15 kHz (want about 6)");
    var sh = render([[0, 0, 4, 0.9]], 0.8, { vary: 0 }).L, shoff = render([[0, 0, 4, 0.9]], 0.8, { vary: 0, jingles: 0 }).L;
    check(hfe(sh, 0, 0.3) - hfe(shoff, 0, 0.3) > 20 && peak(sh) > 0.05, "Pandeiro Shake: the jingles are the stroke (Jingles 0: " + (hfe(sh, 0, 0.3) - hfe(shoff, 0, 0.3)).toFixed(1) + " dB less at 8-15 kHz; peak " + DB(peak(sh)).toFixed(1) + " dBFS)");
    var ta = render([[0, 1, 6, 0.9]], 0.5, { vary: 0, jingles: 100 }).L, tb = render([[0, 1, 6, 0.9]], 0.5, { vary: 0, jingles: 0 }).L, df = 0;
    for (var i = 0; i < ta.length; i++) df = Math.max(df, Math.abs(ta[i] - tb[i]));
    check(df === 0, "Tamborim Open: the Jingles control changes nothing (max sample difference " + df + ")");
    var d1 = render([[0, 0, 4, 0.9]], 1.0, { vary: 0, decay: 100 }).L, d2 = render([[0, 0, 4, 0.9]], 1.0, { vary: 0, decay: 250 }).L;
    check(hfe(d2, 0.25, 0.5) - hfe(d1, 0.25, 0.5) > 6, "Decay 250 % lengthens the jingles' ring (8-15 kHz at 0.25-0.5 s: " + (hfe(d2, 0.25, 0.5) - hfe(d1, 0.25, 0.5)).toFixed(1) + " dB more, need > 6)");
})();

// 6. the controls: Shell (the 125 Hz body), Decay, Press with the wheel, velocity, Volume, Touch, Skin
(function () {
    var a = render([[0, 0, 1, 0.9]], 0.5, { shell: 100, vary: 0 }).L, b = render([[0, 0, 1, 0.9]], 0.5, { shell: 0, vary: 0 }).L;
    var d1 = spec(a, 0.0, 0.05, 100, 150).db - spec(b, 0.0, 0.05, 100, 150).db;
    check(d1 > 2, "Pandeiro Finger: Shell 100 vs 0 puts " + d1.toFixed(1) + " dB more into 100-150 Hz (the body; need > 2)");
    function ring(dc) { var r = render([[0, 1, 6, 0.9]], 2.0, { decay: dc, jingles: 0 }).L; return spec(r, 0.5, 0.9, 350, 1200).db - spec(r, 0.05, 0.45, 350, 1200).db; }
    var r100 = ring(100), r200 = ring(200);
    check(r200 > r100 + 4, "Tamborim Open: Decay 200 % holds the head longer (0.5-0.9 s vs 0.05-0.45 s: " + r200.toFixed(1) + " dB vs " + r100.toFixed(1) + ")");
    var w0 = spec(render([[0, 1, 6, 0.8]], 0.7, { press: 12, vary: 0 }, 0).L, 0.1, 0.5, 250, 2000).f, w = spec(render([[0, 1, 6, 0.8]], 0.7, { press: 12, vary: 0 }, 1).L, 0.1, 0.5, 250, 4000).f;
    check(Math.abs(1200 * Math.log2(w / w0) - 1200) < 80, "mod wheel at full with Press 12: Tamborim Open's strongest tone " + w0.toFixed(1) + " -> " + w.toFixed(1) + " Hz (" + (1200 * Math.log2(w / w0)).toFixed(0) + " ct, want 1200)");
    var lo = peak(render([[0, 1, 6, 0.2]], 0.5, {}).L), hi = peak(render([[0, 1, 6, 1]], 0.5, {}).L);
    check(DB(hi / lo) > 10, "velocity 0.2 -> 1 spans " + DB(hi / lo).toFixed(1) + " dB (> 10)");
    var v1 = peak(render([[0, 1, 6, 0.5]], 0.4, { volume: -9 }).L), v2 = peak(render([[0, 1, 6, 0.5]], 0.4, { volume: -21 }).L);   // vel 0.5: under the soft limiter
    check(Math.abs(DB(v1 / v2) - 12) < 1.5, "Volume -9 -> -21 dB lowers the peak by " + DB(v1 / v2).toFixed(1) + " dB (want 12)");
    var t1 = spec(render([[0, 1, 6, 0.9]], 0.3, { touch: 90, vary: 0 }).L, 0, 0.03, 3000, 11000).db - spec(render([[0, 1, 6, 0.9]], 0.3, { touch: 10, vary: 0 }).L, 0, 0.03, 3000, 11000).db;
    check(t1 > 3, "Touch 90 vs 10: " + t1.toFixed(1) + " dB more energy at 3-11 kHz in the first 30 ms (need > 3)");
    function tilt(sk) { var r = render([[0, 1, 6, 0.9]], 0.4, { skin: sk, vary: 0 }).L; return spec(r, 0.01, 0.2, 1800, 4000).db - spec(r, 0.01, 0.2, 350, 700).db; }
    check(tilt(100) > tilt(0) + 8, "Skin 100 vs 0: the 1.8-4 kHz overtones are " + (tilt(100) - tilt(0)).toFixed(1) + " dB stronger against the fundamental (need > 8)");
})();

// 7. Instrument changed between hits: the new instrument sounds at its own pitch
(function () {
    var r = render([[0, 0, 0, 0.8], [0.4, 1, 6, 0.8]], 1.2, { vary: 0, jingles: 0 }).L, p = render([[0, 0, 0, 0.8]], 0.6, { vary: 0, jingles: 0 }).L, t = render([[0, 1, 6, 0.8]], 0.6, { vary: 0, jingles: 0 }).L;
    var ft = spec(t, 0.1, 0.35, 150, 3000).f, fp = spec(p, 0.1, 0.35, 150, 3000).f, fr = spec(r, 0.5, 0.75, 150, 3000).f;
    check(finite(r) && Math.abs(1200 * Math.log2(fr / ft)) < 60 && ft > fp, "Pandeiro Thumb then Tamborim Open: the Tamborim sounds at " + fr.toFixed(1) + " Hz (alone " + ft.toFixed(1) + ", Pandeiro " + fp.toFixed(1) + ")");
})();

// 8. extremes: every control at min / max, all 16 instrument x menu strokes back to back: finite, under full scale
[0, 1].forEach(function (a) {
    var p = { tune: a ? 12 : -12, decay: a ? 300 : 30, skin: a ? 100 : 0, shell: a ? 100 : 0, touch: a ? 100 : 0, press: 12, jingles: a ? 100 : 0, volume: 6 }, bad = 0, worst = 0;
    var e = mk(p); e.set("mw", 1);
    for (var d = 0; d < 2; d++) for (var k = 0; k < 8; k++) { e.set("inst", d); e.set("stroke", k); e.set("vel", 1); e.set("trg", ++count); var o = e.run(0.12); if (!finite(o[0])) bad++; worst = Math.max(worst, peak(o[0])); }
    check(!bad && worst <= 1.0001, "controls at " + (a ? "max" : "min") + ", 16 strokes back to back: finite, peak " + worst.toFixed(3));
});

// 9. pandeiro_midi.js: any note, velocity, running status, wheel, note-offs ignored
(function () {
    var src = fs.readFileSync(path.join(__dirname, "../m4l/pandeiro_midi.js"), "utf8"), out = [];
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
