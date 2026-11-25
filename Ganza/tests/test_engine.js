// node tests/test_engine.js — runs the generated gen~ code (scripts/ganza_engine.py) in the Node shim, plus ganza_midi.js with a fake outlet
// and Task: stability, silence, both Types x forward / back against the CC recordings (tests/refs.json, from tests/fit_refs.js --write), the 16th-note
// pattern, accent, end-cap click, ring modes, every control, the note map. Deterministic (seeded noise).
var assert = require("assert"), fs = require("fs"), path = require("path"), vm = require("vm"), cp = require("child_process");
var M = require("./ganza_measure.js"), SR = M.SR;
var REFS = JSON.parse(fs.readFileSync(path.join(__dirname, "refs.json"), "utf8"));
var info = JSON.parse(cp.execFileSync("python3", ["-c", "import sys,json;sys.path.insert(0,'" + path.join(__dirname, "../scripts") +
    "');import ganza_engine as E;print(json.dumps({'names':E.NAMES,'target':E.TARGET}))"], { encoding: "utf8" }));
var NAMES = info.names, fails = 0, passed = 0;
function check(ok, what) { if (ok) { passed++; if (process.env.V) console.log("ok   " + what); } else { fails++; console.log("FAIL " + what); } }
function fmt(v) { return isFinite(v) ? v.toFixed(2) : String(v); }
function stroke(params, vel, dir, sec, acc) { var e = M.engine(params), n = Math.round(sec * SR), x = new Float64Array(n), r = new Float64Array(n); e.st.vl = vel; e.st.dir = dir || 0; e.st.acc = acc || 0; e.st.tr = 1; for (var i = 0; i < n; i++) { e.tick(); x[i] = e.st.out1; r[i] = e.st.out2; } return [x, r, e]; }
function peak10(x) { return M.measure(x).peak; }
function maxAbs(x, a, b) { var m = 0; for (var i = a || 0; i < (b || x.length); i++) m = Math.max(m, Math.abs(x[i])); return m; }
function finite(x) { for (var i = 0; i < x.length; i++) if (!isFinite(x[i])) return false; return true; }
function mean(a) { return a.reduce(function (s, v) { return s + v; }, 0) / a.length; }
function thirdRms(a, b) { var s = 0; for (var i = 0; i < a.length; i++) { var d = Math.max(-45, a[i]) - Math.max(-45, b[i]); s += d * d; } return Math.sqrt(s / a.length); }

// ── 1. stability: every Type at the extremes, all controls min then max; finite, inside +-1; energy dies to exact silence
var LIM = { beads: [0.25, 4], damp: [0.25, 4], shake: [0.25, 4], rattle: [0, 1], tone: [-12, 12], back: [0, 2], vol: [-36, 6], pan: [-1, 1] };
NAMES.forEach(function (name, ty) {
    [0, 1].forEach(function (w) {
        var p = { type: ty }; Object.keys(LIM).forEach(function (k) { p[k] = LIM[k][w]; });
        var e = M.engine(p), x = new Float64Array(4 * SR), ok = true, big = 0;
        for (var i = 0; i < x.length; i++) {
            if (i % 2400 === 0 && i < 2 * SR) { e.st.vl = 1; e.st.dir = (i / 2400) % 2; e.st.acc = (i / 2400) % 3 === 0 ? 1 : 0; e.st.tr = (i / 2400 + 1) % 65536; }
            e.tick(); x[i] = e.st.out1; if (!isFinite(e.st.out1) || !isFinite(e.st.out2)) ok = false; big = Math.max(big, Math.abs(e.st.out1), Math.abs(e.st.out2));
        }
        check(ok && big <= 1, name + " with every control at " + (w ? "max" : "min") + ", 40 strokes in 2 s (back and accents mixed): finite, peak " + big.toFixed(3));
    });
    var s = stroke({ type: ty, damp: 4, shake: 4, rattle: 1, beads: 4 }, 1, 0, 14, 1), x = s[0];
    var tail = maxAbs(x, 10 * SR);
    check(finite(x) && tail < 1e-12 && s[2].st.en === 0, name + " dies to silence: max over 10-14 s " + tail.toExponential(1) + ", energy " + s[2].st.en);
});

// ── 2. both Types, forward and back, against the recordings (ranges over the reference strokes; bands / 1/3-octave spectrum of their mean)
var ours = {};
NAMES.forEach(function (name, ty) {
    ours[name] = {};
    ["fwd", "back"].forEach(function (dn, dir) {
        var r = REFS[name][dn], trunc = REFS[name].trunc, m = ours[name][dn] = M.strokes({ type: ty, vol: 0, pan: -1 }, 24, 1, dir, trunc ? 0.5 : 0.9), lab = name + " " + dn;
        var bad = [];
        // a band the references have above -30 dB must match within 6 dB; below that the references sit on their recording noise floor (-35..-45), so ours may only not be above it
        for (var i = 0; i < 9; i++) if (m.bands[i] > r.bands[i] + 6 || (r.bands[i] > -30 && m.bands[i] < r.bands[i] - 6)) bad.push("band " + i + ": " + m.bands[i].toFixed(1) + " vs " + r.bands[i]);
        check(!bad.length, lab + ": octave bands within 6 dB of the references (" + (bad.join("; ") || "all") + ")");
        check(thirdRms(m.third, r.third) < 6, lab + ": 1/3-octave spectrum within 6 dB rms of the references (" + thirdRms(m.third, r.third).toFixed(1) + ")");
        check(m.cent > 0.9 * r.cent[0] && m.cent < 1.1 * r.cent[1], lab + ": centroid " + m.cent.toFixed(0) + " Hz, references " + r.cent.map(Math.round).join("-"));
        function inr(k, lo, hi) { var v = m[k], t = r[k]; return t && isFinite(v) && v >= lo(t[0]) && v <= hi(t[1]); }
        check(inr("rise", function (a) { return a * 0.5 - 6; }, function (b) { return b * 1.5 + 8; }), lab + ": rise " + m.rise.toFixed(0) + " ms, references " + r.rise.map(Math.round).join("-"));
        ["t20", "t30", "t40", "t50"].forEach(function (k) {
            if (r[k] && (!trunc || k === "t20")) check(inr(k, function (a) { return a * 0.6; }, function (b) { return b * 1.5; }), lab + ": " + k + " " + fmt(m[k]) + " ms, references " + r[k].map(Math.round).join("-"));
        });
        check(inr("cvE", function (a) { return a - 0.1; }, function (b) { return b + 0.1; }), lab + ": early grain fluctuation " + fmt(m.cvE) + ", references " + r.cvE.map(function (v) { return v.toFixed(2); }).join("-"));
        if (r.cvL) check(inr("cvL", function (a) { return a - 0.12; }, function (b) { return b + 0.12; }), lab + ": tail grain fluctuation " + fmt(m.cvL) + ", references " + r.cvL.map(function (v) { return v.toFixed(2); }).join("-"));
    });
    var pks = []; for (var k = 0; k < 16; k++) { var e2 = M.engine({ type: ty, vol: 0, pan: -1 }); for (var j = 0; j < k * 7919 + 13; j++) e2.st.noise(); e2.st.vl = 1; e2.st.tr = 1; var xx = new Float64Array(Math.round(0.6 * SR)); for (var q = 0; q < xx.length; q++) { e2.tick(); xx[q] = e2.st.out1; } pks.push(peak10(xx)); }
    check(Math.abs(mean(pks) / info.target - 1) < 0.08, name + ": 10 ms RMS peak of a forward stroke at velocity 1, Level 0 dB = " + mean(pks).toFixed(3) + " (target " + info.target + ")");
    // the back stroke: level, build-up, tail and brightness against the recordings
    var fw = ours[name].fwd, bk = ours[name].back, lv = [], lb = [];
    for (k = 1; k <= 12; k++) { [[0, lv], [1, lb]].forEach(function (pr) { var e3 = M.engine({ type: ty, vol: 0, pan: -1 }); for (var j2 = 0; j2 < k * 311; j2++) e3.st.noise(); e3.st.vl = 1; e3.st.dir = pr[0]; e3.st.tr = 1; var x3 = new Float64Array(0.5 * SR); for (var i3 = 0; i3 < x3.length; i3++) { e3.tick(); x3[i3] = e3.st.out1; } pr[1].push(peak10(x3)); }); }
    var dBk = 20 * Math.log10(mean(lb) / mean(lv));
    check(Math.abs(dBk - REFS[name].backdB) < 3, name + ": the back stroke is " + dBk.toFixed(1) + " dB under the forward one (the recordings: " + REFS[name].backdB + " dB)");
    check(bk.rise > fw.rise * 1.05, name + ": a back stroke builds up slower: rise " + bk.rise.toFixed(1) + " vs " + fw.rise.toFixed(1) + " ms");
    check(bk.t20 > fw.t20 * 1.1, name + ": a back stroke lasts longer: t20 " + bk.t20.toFixed(0) + " vs " + fw.t20.toFixed(0) + " ms");
    var cr = REFS[name].back.cent[0] + REFS[name].back.cent[1] > REFS[name].fwd.cent[0] + REFS[name].fwd.cent[1];   // the recordings' back strokes are brighter (chocalho) or darker (ganzá)
    check(cr ? bk.cent > fw.cent : bk.cent < fw.cent, name + ": a back stroke is " + (cr ? "brighter" : "darker") + " like the recordings: centroid " + bk.cent.toFixed(0) + " vs " + fw.cent.toFixed(0) + " Hz");
});
var pairs = 0, same = [];
var A0 = ours.Ganza.fwd, B0 = ours.Chocalho.fwd;
check(!(thirdRms(A0.third, B0.third) < 1.5 && Math.abs(Math.log(A0.t20 / B0.t20)) < 0.3), "Ganza and Chocalho differ in spectrum or decay");
check(maxAbs(stroke({ type: 0, back: 0 }, 1, 1, 0.5)[0]) === 0, "Back 0 makes the back stroke silent");

// ── 2b. the ganzá's 16th-note pattern against the loop (tests/refs.json "pattern"): strokes alternate forward / back, the troughs between them, loud vs soft
(function () {
    var r = REFS.pattern, ev = []; for (var k = 0; k < 16; k++) ev.push({ t: 0.09 + k * 0.1175, vel: 1, dir: 1 - (k % 2), acc: 0 });
    var p = M.pattern(M.render({ type: 0, vol: 0, pan: -1 }, ev, 2.2).l);
    check(p.n >= 14 && p.n <= 17, "Ganza 16ths at 127 BPM (alternating): " + p.n + " strokes found (the loop: " + r.n + ")");
    check(p.depth > r.depth - 6 && p.depth < r.depth + 6, "peak-to-trough depth " + p.depth.toFixed(1) + " dB (the loop " + r.depth.toFixed(1) + ")");
    check(p.alt > 0.4 * r.alt && p.alt < 1.8 * r.alt, "forward vs back strokes differ by " + p.alt.toFixed(1) + " dB (the loop " + r.alt.toFixed(1) + ", accents included)");
    check(p.centLoud > p.centSoft, "forward strokes are brighter than back strokes in the pattern: " + p.centLoud.toFixed(0) + " vs " + p.centSoft.toFixed(0) + " Hz (the loop " + r.centLoud.toFixed(0) + " / " + r.centSoft.toFixed(0) + ")");
})();

// ── 2c. accent, end-cap click, ring modes
function crest(x) { var e1 = M.movRms(x, Math.round(0.001 * SR)), m = 0; for (var i = 0; i < Math.round(0.02 * SR); i++) m = Math.max(m, e1[i]); return m / M.measure(x).peak; }
function avgOver(f, n) { var a = []; for (var k = 1; k <= n; k++) a.push(f(k)); return mean(a); }
function oneStroke(p, vel, dir, acc, k, sec) { var e = M.engine(Object.assign({ vol: 0, pan: -1 }, p)); for (var j = 0; j < k * 977; j++) e.st.noise(); e.st.vl = vel; e.st.dir = dir; e.st.acc = acc; e.st.tr = 1; var x = new Float64Array((sec || 0.5) * SR); for (var i = 0; i < x.length; i++) { e.tick(); x[i] = e.st.out1; } return x; }
NAMES.forEach(function (name, ty) {
    var fwd = avgOver(function (k) { return peak10(oneStroke({ type: ty }, 1, 0, 0, k)); }, 12), acc = avgOver(function (k) { return peak10(oneStroke({ type: ty }, 1, 0, 1, k)); }, 12);
    var d = 20 * Math.log10(acc / fwd);
    check(d > 2 && d < 8, name + ": an accent is " + d.toFixed(1) + " dB louder than a forward stroke (2..8)");
    var cf = avgOver(function (k) { return crest(oneStroke({ type: ty }, 1, 0, 0, k)); }, 12), ca = avgOver(function (k) { return crest(oneStroke({ type: ty }, 1, 0, 1, k)); }, 12), cb = avgOver(function (k) { return crest(oneStroke({ type: ty }, 1, 1, 0, k)); }, 12);
    if (ty !== 0) return;   // the chocalho's platinelas have no end cap to hit (the recordings' forward strokes swell, crest 0.4 vs the ganzá's 1.2)
    check(ca > cf * 1.02 || ca > cf + 0.01, name + ": an accent's front is harder (1 ms RMS peak / 10 ms RMS peak in the first 20 ms: accent " + ca.toFixed(2) + " vs forward " + cf.toFixed(2) + ")");
    check(cf > cb * 1.1, name + ": a forward stroke's front is harder than a back stroke's (" + cf.toFixed(2) + " vs " + cb.toFixed(2) + "; the recordings 1.24 vs 0.92)");
    check(cf > 0.9 && cf < 1.7, name + ": the forward front's crest " + cf.toFixed(2) + " is near the recordings' (1.24, range 0.45-1.57)");
});
(function () {   // the ganzá's tube-wall ring: a narrow ring mode prominent in a long noisy stretch; measured as 1/20-octave band power vs the +-12 % neighbours
    var ring = JSON.parse(cp.execFileSync("python3", ["-c", "import sys,json;sys.path.insert(0,'" + path.join(__dirname, "../scripts") + "');import ganza_engine as E;print(json.dumps({n:E.TYPES[n]['rings'] for n in E.NAMES}))"], { encoding: "utf8" }));
    NAMES.forEach(function (name, ty) {
        var ev = []; for (var k = 0; k < 40; k++) ev.push({ t: 0.05 + k * 0.118, vel: 1, dir: k % 2, acc: k % 8 === 0 ? 1 : 0 });
        var x = M.render({ type: ty, vol: 0, pan: -1 }, ev, 5).l, n = 65536, re = new Float64Array(n), im = new Float64Array(n);
        for (var i = 0; i < n; i++) re[i] = x[i + 4000] * (0.5 - 0.5 * Math.cos(2 * Math.PI * i / n));
        M.fft(re, im);
        function pw(a, b) { var s = 0, c = 0; for (var q = Math.floor(a * n / SR); q <= Math.floor(b * n / SR); q++) { s += re[q] * re[q] + im[q] * im[q]; c++; } return s / c; }
        ring[name].forEach(function (rg) {
            if (rg[2] === 0) return;
            var f = rg[0], on = pw(f * 0.985, f * 1.015), off = (pw(f * 0.8, f * 0.88) + pw(f * 1.14, f * 1.25)) / 2, db = 10 * Math.log10(on / off);
            check(db > 1.5 && db < 9, name + ": the ring mode at " + f + " Hz stands " + db.toFixed(1) + " dB over its neighbours (faint: 1.5..9; the recordings' lines +3..5)");
        });
    });
})();

// ── 3. strokes: velocity, overlap, determinism
var P = { type: 0, vol: 0, pan: -1 };
var v1 = avgOver(function (k) { return peak10(oneStroke(P, 1, 0, 0, k)); }, 8), vh = avgOver(function (k) { return peak10(oneStroke(P, 0.5, 0, 0, k)); }, 8);
var dB = 20 * Math.log10(vh / v1);
check(dB < -4.5 && dB > -12, "half the velocity is " + dB.toFixed(1) + " dB quieter");
var P6 = { type: 0, vol: -6, pan: -1 };
var ev = [{ t: 0.0, vel: 1, dir: 0 }, { t: 0.03, vel: 1, dir: 1 }, { t: 0.06, vel: 1, dir: 0 }], o = M.render(P6, ev, 1);
var single = M.render(P6, ev.slice(0, 1), 1);
check(finite(o.l) && maxAbs(o.l) < 1 && M.measure(o.l).peak > 1.2 * M.measure(single.l).peak, "strokes 30 ms apart add up (peak " + M.measure(o.l).peak.toFixed(3) + " vs " + M.measure(single.l).peak.toFixed(3) + " alone)");
var s1 = stroke(P, 1, 0, 0.3)[0], s2 = stroke(P, 1, 0, 0.3)[0];
var same2 = true; for (var i = 0; i < s1.length; i++) if (s1[i] !== s2[i]) { same2 = false; break; }
check(same2, "the same stroke renders identically (seeded noise)");
var e3 = M.engine(P); e3.st.vl = 1; e3.st.tr = 7; for (var i = 0; i < 4800; i++) e3.tick(); var pk3 = e3.st.en; e3.st.vl = 1; e3.st.tr = 7; for (i = 0; i < 4800; i++) e3.tick();
check(e3.st.en < pk3, "an unchanged tr counter is not a new stroke");
var base = ours.Ganza.fwd;

// ── 4. controls, each on the Ganza forward stroke against the defaults
function ctl(label, p, fn, lo, hi) { var m = M.strokes(Object.assign({}, P, p), 16, 1, 0, 0.9), v = fn(m); check(v > lo && v < hi, label + ": " + v.toFixed(2) + " (want " + lo + ".." + hi + ")"); }
ctl("Beads 400 %: smoother (grain fluctuation / default)", { beads: 4 }, function (m) { return m.cvE / base.cvE; }, 0.1, 0.9);
ctl("Beads 25 %: sparser (grain fluctuation / default)", { beads: 0.25 }, function (m) { return m.cvE / base.cvE; }, 1.1, 10);
function lvlRatio(p) { return avgOver(function (k) { return peak10(oneStroke(Object.assign({}, P, p), 1, 0, 0, k, 0.6)); }, 8) / avgOver(function (k) { return peak10(oneStroke(P, 1, 0, 0, k, 0.6)); }, 8); }
[["Beads 400 %", { beads: 4 }], ["Beads 25 %", { beads: 0.25 }], ["Rattle 0", { rattle: 0 }], ["Rattle 1", { rattle: 1 }], ["Shake 400 %", { shake: 4 }], ["Shake 25 %", { shake: 0.25 }]].forEach(function (c) {
    var d = 20 * Math.log10(lvlRatio(c[1]));
    check(Math.abs(d) < 3, c[0] + " moves the loudness by " + d.toFixed(1) + " dB (texture, not level: within 3 dB)");
});
// Damping works on the tail (t50): the stroke's first 20 dB are limited by its build-up (Shake), so t20 barely moves on the ganzá
var base15 = M.strokes(P, 16, 1, 0, 1.5);
function ctl50(label, p, lo, hi) { var v = M.strokes(Object.assign({}, P, p), 16, 1, 0, 1.5).t50 / base15.t50; check(v > lo && v < hi, label + ": " + v.toFixed(2) + " (want " + lo + ".." + hi + ")"); }
ctl50("Damping 400 %: longer (t50 / default)", { damp: 4 }, 1.8, 8);
ctl50("Damping 25 %: shorter (t50 / default)", { damp: 0.25 }, 0.12, 0.7);
ctl("Shake 400 %: slower build (rise / default)", { shake: 4 }, function (m) { return m.rise / base.rise; }, 1.4, 10);
ctl("Shake 25 %: faster build (rise / default)", { shake: 0.25 }, function (m) { return m.rise / base.rise; }, 0.1, 0.85);
ctl("Tone +12 st raises the centroid (x)", { tone: 12 }, function (m) { return m.cent / base.cent; }, 1.1, 3);
ctl("Tone -12 st lowers the centroid (x)", { tone: -12 }, function (m) { return m.cent / base.cent; }, 0.3, 0.9);
ctl("Rattle 1: longer grains, smoother (grain fluctuation / default)", { rattle: 1 }, function (m) { return m.cvE / base.cvE; }, 0.1, 0.97);
ctl("Rattle 0: shorter grains, sparser (grain fluctuation / default)", { rattle: 0 }, function (m) { return m.cvE / base.cvE; }, 1.03, 10);
var bk1 = avgOver(function (k) { return peak10(oneStroke({ type: 0, back: 1 }, 1, 1, 0, k)); }, 12), bk2 = avgOver(function (k) { return peak10(oneStroke({ type: 0, back: 2 }, 1, 1, 0, k)); }, 12);
check(bk2 / bk1 > 1.6 && bk2 / bk1 < 3, "Back 200 % is " + (bk2 / bk1).toFixed(2) + " x the level of Back 100 % (~2)");
var lv0 = peak10(stroke({ type: 0, vol: 0, pan: -1 }, 1, 0, 0.5)[0]), lv6 = peak10(stroke({ type: 0, vol: -6, pan: -1 }, 1, 0, 0.5)[0]);
check(Math.abs(20 * Math.log10(lv6 / lv0) + 6.02) < 0.05, "Level -6 dB is exactly -6.02 dB (" + (20 * Math.log10(lv6 / lv0)).toFixed(2) + ")");
var L = stroke({ type: 0, pan: -1 }, 1, 0, 0.5), Rr = stroke({ type: 0, pan: 1 }, 1, 0, 0.5), C = stroke({ type: 0, pan: 0 }, 1, 0, 0.5);
check(maxAbs(L[1]) === 0 && maxAbs(L[0]) > 0 && maxAbs(Rr[0]) < 1e-12 * maxAbs(Rr[1]) && maxAbs(Rr[1]) > 0 && Math.abs(maxAbs(C[0]) / maxAbs(C[1]) - 1) < 1e-9,
    "Pan hard left / hard right / centre (equal power: centre " + (maxAbs(C[0]) / maxAbs(L[0])).toFixed(3) + " of the hard-pan level)");
check(Math.abs(maxAbs(C[0]) / maxAbs(L[0]) - Math.SQRT1_2) < 1e-9, "Pan is constant power (centre is -3 dB per side)");
check([0, 1].every(function (t) { return [[0, 0], [0, 1], [1, 0]].every(function (da) { return maxAbs(stroke({ type: t }, 1, da[0], 0.5, da[1])[0]) < 0.9; }); }), "defaults (Level -6 dB, velocity 127) peak well under full scale: both Types, forward, accent, back");
var e4 = M.engine({ type: 0 }); e4.st.vl = 1; e4.st.tr = 1; var okT = true; for (var i = 0; i < 2 * SR; i++) { if (i % 2000 === 0) e4.set("type", (i / 2000) % 2); e4.tick(); if (!isFinite(e4.st.out1)) okT = false; }
check(okT, "switching Type every 40 ms while ringing stays finite");

// ── 5. ganza_midi.js
function loadMidi() {
    var out = [], tasks = [], ctx = {
        outlet: function (n) { out.push([n].concat([].slice.call(arguments, 1))); },
        Task: function (fn) { var t = { fn: fn, at: null, cancel: function () { t.at = null; }, schedule: function (ms) { t.at = ms; } }; tasks.push(t); return t; },
        Math: Math, Number: Number
    };
    vm.createContext(ctx);
    vm.runInContext(fs.readFileSync(path.join(__dirname, "../m4l/ganza_midi.js"), "utf8"), ctx);
    return { c: ctx, out: out, task: tasks[0] };
}
var J = loadMidi();
J.c.list(60, 100);
assert.deepStrictEqual(J.out.map(function (o) { return o.slice(0, 2).join(" "); }), ["0 vl", "0 dir", "0 acc", "0 tr", "1 hit"]);
check(J.out[0][2] === 100 / 127 && J.out[1][2] === 0 && J.out[2][2] === 0 && J.out[3][2] === 1 && J.out[4][2] === 60 && J.out[4][4] === 0 && J.out[4][5] === 0, "note-on C3: vl, dir 0 (even = forward), acc 0, tr 1, then the display's hit");
J.c.list(60, 0); J.out.length = 0; J.c.list(61, 64);
check(J.out[1][2] === 1 && J.out[3][2] === 2 && J.out[4][4] === 1, "C#3 (odd) is the back stroke and bumps the counter");
J.out.length = 0; J.c.list(61, 0); J.c.list(61, 90); J.c.list(61, 0);
check(J.out.filter(function (o) { return o[1] === "tr"; }).length === 1 && J.out[3][2] === 3, "the same key twice in a row still bumps tr (a changed counter, never an unchanged one)");
check(J.out.every(function (o) { return o[1] !== "vl" || (o[2] > 0 && o[2] <= 1); }), "velocity 1..127 -> vl in (0, 1]");
J = loadMidi(); J.c.list(60, 0);
check(J.out.length === 0, "a note-off alone does nothing");
J = loadMidi(); J.c.roll(8); J.c.list(60, 100);
check(J.task.at === 125, "Roll 8 Hz: the next stroke is scheduled 125 ms after the note-on");
J.out.length = 0; J.task.fn(); var d1 = J.out[1][2]; J.task.fn(); var d2 = J.out[1 + 5][2];
check(d1 === 1 && d2 === 0 && J.task.at === 125, "a rolling note alternates direction (back, forward ...) and keeps scheduling");
J.c.list(60, 0);
check(J.task.at === null, "Roll stops at note-off");
J = loadMidi(); J.c.roll(0); J.c.list(60, 100);
check(J.task.at === null, "Roll 0: one stroke per note");
J = loadMidi(); J.c.list(60, 100); J.c.roll(4);
check(J.task.at === 250, "Roll turned up while a note is held starts rolling");
J.c.roll(0);
check(J.task.at === null, "Roll turned down to 0 while rolling stops it");
J = loadMidi(); J.c.roll(8); J.c.list(60, 100); J.c.list(62, 100); J.c.list(62, 0);
check(J.task.at === 125, "releasing one of two held keys keeps rolling");
// Stroke menu: 0 Key, 1 Alternate, 2 Forward, 3 Back, 4 Accent
function dirs(mode, notes, rollTicks, field) {
    var j = loadMidi(), seq = [];
    function grab() { var r = j.out.filter(function (o) { return o[1] === (field || "dir"); }).map(function (o) { return o[2]; }); j.out.length = 0; return r; }
    j.c.direction(mode);
    notes.forEach(function (n) { j.c.list(n, 100); j.c.list(n, 0); seq = seq.concat(grab()); });
    if (rollTicks) { j.c.roll(8); j.c.list(60, 100); seq = seq.concat(grab()); for (var i = 0; i < rollTicks; i++) { j.task.fn(); seq = seq.concat(grab()); } }
    return seq.join("");
}
check(dirs(0, [60, 60, 61, 62, 61]) === "00101", "Stroke Key: parity, same note twice stays");
check(dirs(1, [60, 60, 61, 72, 60]) === "01010", "Stroke Alternate: forward, back, forward ... whatever the notes");
check(dirs(2, [60, 61, 61, 62], 2) === "0000000", "Stroke Forward: every stroke forward, Roll too");
check(dirs(3, [60, 61, 62], 2) === "111111", "Stroke Back: every stroke back, Roll too");
check(dirs(1, [60], 3) === "01010", "Stroke Alternate across Roll: the roll ticks keep alternating from the note");
check(dirs(1, [60, 61], 2) === "01" + "0" + "10", "Stroke Alternate: a roll after two notes continues from the last stroke");
check(dirs(4, [60, 61, 62]) === "000" && dirs(4, [60, 61, 62], 0, "acc") === "111", "Stroke Accent: every note is a forward stroke with acc 1");
check(dirs(4, [], 3, "acc") === "1000" && dirs(4, [], 3) === "0101", "Stroke Accent with Roll: only the note's own stroke is an accent, the roll goes back, forward, back");
J = loadMidi(); J.c.direction(9); J.c.list(61, 100);
check(J.out[2][2] === 1 && J.out[1][2] === 0, "Stroke out of range is clamped (9 -> Accent: forward, acc 1)");

// ── 6. the built patch carries the same code and every control
var mp = path.join(__dirname, "../m4l/Ganza.maxpat");
if (fs.existsSync(mp)) {
    var code = M.code(), got = require("./gen_shim.js").loadCode(mp);
    check(got.trim() === code.trim(), "m4l/Ganza.maxpat's gen~ codebox is exactly scripts/ganza_engine.py's code (rebuild with ./build.sh if not)");
}
console.log(passed + " passed" + (fails ? ", " + fails + " FAILED" : ""));
process.exit(fails ? 1 : 0);
