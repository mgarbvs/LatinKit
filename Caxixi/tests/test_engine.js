// node tests/test_engine.js — runs the generated gen~ code (scripts/caxixi_engine.py) in the Node shim, plus caxixi_midi.js (tests/midi_sim.js: a fake
// outlet and Task on a virtual clock, seeded random): stability, silence, the three strokes against the Latin Percussion previews (tests/refs.json,
// from tests/fit_refs.js --write), the FX phrase, every control, the note map. Deterministic (seeded noise).
var assert = require("assert"), fs = require("fs"), path = require("path"), cp = require("child_process");
var M = require("./caxixi_measure.js"), SR = M.SR, F = require("./fx_measure.js"), S = require("./midi_sim.js");
var REFS = JSON.parse(fs.readFileSync(path.join(__dirname, "refs.json"), "utf8"));
var info = JSON.parse(cp.execFileSync("python3", ["-c", "import sys,json;sys.path.insert(0,'" + path.join(__dirname, "../scripts") +
    "');import caxixi_engine as E;print(json.dumps({'names':E.NAMES,'target':E.TARGET}))"], { encoding: "utf8" }));
var NAMES = info.names, fails = 0, passed = 0;
function check(ok, what) { if (ok) { passed++; if (process.env.V) console.log("ok   " + what); } else { fails++; console.log("FAIL " + what); } }
function fmt(v) { return isFinite(v) ? v.toFixed(2) : String(v); }
function stroke(params, vel, sec) { var e = M.engine(params), n = Math.round(sec * SR), x = new Float64Array(n), r = new Float64Array(n); e.st.vl = vel; e.st.tr = 1; for (var i = 0; i < n; i++) { e.tick(); x[i] = e.st.out1; r[i] = e.st.out2; } return [x, r, e]; }
function peak10(x) { return M.measure(x).peak; }
function maxAbs(x, a, b) { var m = 0; for (var i = a || 0; i < (b || x.length); i++) m = Math.max(m, Math.abs(x[i])); return m; }
function finite(x) { for (var i = 0; i < x.length; i++) if (!isFinite(x[i])) return false; return true; }
function mean(a) { return a.reduce(function (s, v) { return s + v; }, 0) / a.length; }
function thirdRms(a, b) { var s = 0; for (var i = 0; i < a.length; i++) { var d = Math.max(-45, a[i]) - Math.max(-45, b[i]); s += d * d; } return Math.sqrt(s / a.length); }
// an FX phrase from the js (seeded scatter), rendered through the engine (type 2); returns the mono left channel
function phrase(seed, params, len, rate, sec) {
    var J = S.load(seed); J.c.strokemode(2); if (len) J.c.length(len); if (rate) J.c.rate(rate);
    var ev = J.play(60, 127).map(function (e) { return { t: 0.01 + e.t, vel: e.vel }; });
    return M.render(Object.assign({ type: 2, vol: 0, pan: -1 }, params || {}), ev, sec || 2.2).l;
}

// ── 1. stability: every stroke at the extremes, all controls min then max; finite, inside +-1; energy dies to exact silence
var LIM = { beads: [0.25, 4], damp: [0.25, 4], shake: [0.25, 4], rattle: [0, 1], tone: [-12, 12], vol: [-36, 6], pan: [-1, 1] };
NAMES.forEach(function (name, ty) {
    [0, 1].forEach(function (w) {
        var p = { type: ty }; Object.keys(LIM).forEach(function (k) { p[k] = LIM[k][w]; });
        var e = M.engine(p), x = new Float64Array(4 * SR), ok = true, big = 0;
        for (var i = 0; i < x.length; i++) {
            if (i % 2400 === 0 && i < 2 * SR) { e.st.vl = 1; e.st.tr = (i / 2400 + 1) % 65536; }
            e.tick(); x[i] = e.st.out1; if (!isFinite(e.st.out1) || !isFinite(e.st.out2)) ok = false; big = Math.max(big, Math.abs(e.st.out1), Math.abs(e.st.out2));
        }
        check(ok && big <= 1, name + " with every control at " + (w ? "max" : "min") + ", 40 strokes in 2 s: finite, peak " + big.toFixed(3));
    });
    var s = stroke({ type: ty, damp: 4, shake: 4, rattle: 1, beads: 4 }, 1, 14), x = s[0];
    var tail = maxAbs(x, 10 * SR);
    check(finite(x) && tail < 1e-12 && s[2].st.en === 0, name + " dies to silence: max over 10-14 s " + tail.toExponential(1) + ", energy " + s[2].st.en);
});

// ── 2. Open and Hand against the previews (the ranges are over all 8 takes; the bands and the 1/3-octave spectrum are of the fitted takes 2, 3, 4, 7)
var ours = {};
["Open", "Hand"].forEach(function (name) {
    var ty = NAMES.indexOf(name), m = ours[name] = M.strokes({ type: ty, vol: 0, pan: -1 }, 24, 1, 0.9), r = REFS[name];
    var bad = [];
    // a band the references have above -30 dB must match within 6 dB; below that the references sit on their recording noise floor (-35..-45), so ours may only not be above it
    for (var i = 0; i < 9; i++) if (m.bands[i] > r.bandsFit[i] + 6 || (r.bandsFit[i] > -30 && m.bands[i] < r.bandsFit[i] - 6)) bad.push("band " + i + ": " + m.bands[i].toFixed(1) + " vs " + r.bandsFit[i]);
    check(!bad.length, name + ": octave bands within 6 dB of the fitted takes (" + (bad.join("; ") || "all") + ")");
    check(thirdRms(m.third, r.thirdFit) < 5, name + ": 1/3-octave spectrum within 5 dB rms of the fitted takes (" + thirdRms(m.third, r.thirdFit).toFixed(1) + ")");
    check(thirdRms(m.third, r.third) < 8, name + ": 1/3-octave spectrum within 8 dB rms of all 8 takes (" + thirdRms(m.third, r.third).toFixed(1) + ")");
    check(m.cent > 0.88 * r.cent[0] && m.cent < 1.12 * r.cent[1], name + ": centroid " + m.cent.toFixed(0) + " Hz, takes " + r.cent.map(Math.round).join("-"));
    function inr(k, lo, hi) { var v = m[k], t = r[k]; return t && isFinite(v) && v >= lo(t[0]) && v <= hi(t[1]); }
    check(inr("rise", function (a) { return a * 0.5 - 6; }, function (b) { return b * 1.3 + 6; }), name + ": rise " + m.rise.toFixed(0) + " ms, takes " + r.rise.map(Math.round).join("-"));
    check(inr("t20", function (a) { return a * 0.6; }, function (b) { return b * 1.3; }), name + ": t20 " + fmt(m.t20) + " ms, takes " + r.t20.map(Math.round).join("-"));
    check(inr("t30", function (a) { return a * 0.6; }, function (b) { return b * 1.3; }), name + ": t30 " + fmt(m.t30) + " ms, takes " + r.t30.map(Math.round).join("-"));
    check(inr("t40", function (a) { return a * 0.6; }, function (b) { return b * 1.3; }), name + ": t40 " + fmt(m.t40) + " ms, takes " + r.t40.map(Math.round).join("-"));
    check(inr("t50", function (a) { return a * 0.6; }, function (b) { return b * 1.3; }), name + ": t50 " + fmt(m.t50) + " ms, takes " + r.t50.map(Math.round).join("-"));
    check(inr("cvE", function (a) { return a - 0.1; }, function (b) { return b + 0.1; }), name + ": early grain fluctuation " + fmt(m.cvE) + ", takes " + r.cvE.map(function (v) { return v.toFixed(2); }).join("-"));
    check(inr("cvL", function (a) { return a - 0.1; }, function (b) { return b + 0.1; }), name + ": tail grain fluctuation " + fmt(m.cvL) + ", takes " + r.cvL.map(function (v) { return v.toFixed(2); }).join("-"));
});
// every stroke, FX's burst included, plays at the calibrated level
NAMES.forEach(function (name, ty) {
    var pks = []; for (var k = 0; k < 16; k++) { var e2 = M.engine({ type: ty, vol: 0, pan: -1 }); for (var j = 0; j < k * 7919 + 13; j++) e2.st.noise(); e2.st.vl = 1; e2.st.tr = 1; var xx = new Float64Array(Math.round(0.6 * SR)); for (var q = 0; q < xx.length; q++) { e2.tick(); xx[q] = e2.st.out1; } pks.push(peak10(xx)); }
    check(Math.abs(mean(pks) / info.target - 1) < 0.08, name + ": 10 ms RMS peak at velocity 1, Level 0 dB = " + mean(pks).toFixed(3) + " (target " + info.target + ")");
});
// Hand is the hard bottom on the palm: more 2-4 kHz than Open (the previews: +5 dB at 2.5-3.2 kHz) and a shorter t20 (45 vs 72 ms)
check(ours.Hand.bands[3] > ours.Open.bands[3] + 3, "Hand has more 2-4 kHz than Open: " + ours.Hand.bands[3].toFixed(1) + " vs " + ours.Open.bands[3].toFixed(1) + " dB (re the stroke)");
check(ours.Hand.t20 < 0.85 * ours.Open.t20, "Hand's first 20 dB are shorter than Open's: t20 " + ours.Hand.t20.toFixed(0) + " vs " + ours.Open.t20.toFixed(0) + " ms");

// ── 2b. the FX phrase through caxixi_midi.js: bursts, interval, ripple, spectrum, against the 8 FX previews
(function () {
    var r = REFS.FX, ms = [], x;
    for (var s = 1; s <= 12; s++) ms.push(F.measureFX(phrase(s * 101)));
    var av = function (k) { return mean(ms.map(function (m) { return m[k]; })); };
    var th = ms[0].third.map(function (_, i) { return 10 * Math.log10(mean(ms.map(function (m) { return Math.pow(10, m.third[i] / 10); }))); });
    check(av("bursts") >= 8 && av("bursts") <= 10, "FX default (1000 ms, 9.3 Hz): " + av("bursts").toFixed(1) + " bursts found (previews " + r.bursts.join("-") + ": 8 of the 8-burst takes at ~1 s)");
    check(av("iv") > 0.95 * r.iv[0] && av("iv") < 1.05 * Math.min(r.iv[1], 125), "FX burst interval " + av("iv").toFixed(0) + " ms (previews " + r.iv.map(Math.round).join("-") + ", 7 of 8 at 106-121)");
    check(av("ivsd") > 6 && av("ivsd") < 1.25 * r.ivsd[1], "FX interval scatter sd " + av("ivsd").toFixed(0) + " ms (previews " + r.ivsd.map(Math.round).join("-") + ")");
    check(av("ripple") > 0.6 * r.ripple[0] && av("ripple") < 1.2 * r.ripple[1], "FX ripple (burst peak to trough) " + av("ripple").toFixed(1) + " dB (previews " + r.ripple.map(function (v) { return v.toFixed(1); }).join("-") + ")");
    check(av("first") < -5 && av("last") < -5, "FX swells in and fades out: first burst " + av("first").toFixed(0) + ", last " + av("last").toFixed(0) + " dB re the loudest (previews " + r.first.map(Math.round).join("..") + ", " + r.last.map(Math.round).join(".."));
    check(av("cent") > 0.88 * r.cent[0] && av("cent") < 1.12 * r.cent[1], "FX steady centroid " + av("cent").toFixed(0) + " Hz (previews " + r.cent.map(Math.round).join("-") + ")");
    check(thirdRms(th, r.thirdFit) < 7, "FX steady 1/3-octave spectrum within 7 dB rms of the fitted takes (" + thirdRms(th, r.thirdFit).toFixed(1) + ")");
    x = phrase(7, { vol: -6 });
    check(finite(x) && maxAbs(x) < 1, "FX phrase at Level -6 dB stays inside +-1 (peak " + maxAbs(x).toFixed(2) + ")");
})();
var pairs = 0, same = [];
for (var a = 0; a < 2; a++) for (var b = a + 1; b < 2; b++) {
    pairs++;
    var A = ours[NAMES[a]], B = ours[NAMES[b]];
    var d = thirdRms(A.third, B.third), dt = Math.abs(Math.log(A.t20 / B.t20)), dc = Math.abs(Math.log(A.cvE / B.cvE));
    if (d < 1.5 && dt < 0.3 && dc < 0.3) same.push(NAMES[a] + "/" + NAMES[b]);
}
check(!same.length, "Open and Hand differ in spectrum, decay or grain texture (alike: " + (same.join(", ") || "none") + ")");

// ── 3. strokes: velocity, overlap, determinism
var P = { type: 0, vol: 0, pan: -1 };
var v1 = mean([1, 2, 3, 4, 5, 6].map(function (k) { var e = M.engine(P); for (var j = 0; j < k * 977; j++) e.st.noise(); e.st.vl = 1; e.st.tr = 1; var x = new Float64Array(0.5 * SR); for (var i = 0; i < x.length; i++) { e.tick(); x[i] = e.st.out1; } return peak10(x); }));
var vh = mean([1, 2, 3, 4, 5, 6].map(function (k) { var e = M.engine(P); for (var j = 0; j < k * 977; j++) e.st.noise(); e.st.vl = 0.5; e.st.tr = 1; var x = new Float64Array(0.5 * SR); for (var i = 0; i < x.length; i++) { e.tick(); x[i] = e.st.out1; } return peak10(x); }));
var dB = 20 * Math.log10(vh / v1);
check(dB < -4.5 && dB > -12, "half the velocity is " + dB.toFixed(1) + " dB quieter");
// overlap: a second stroke 30 ms after the first adds to it, nothing clips, the sum is finite
var P6 = { type: 0, vol: -6, pan: -1 };
var ev = [{ t: 0.0, vel: 1 }, { t: 0.03, vel: 1 }, { t: 0.06, vel: 1 }], o = M.render(P6, ev, 1);
var single = M.render(P6, ev.slice(0, 1), 1);
check(finite(o.l) && maxAbs(o.l) < 1 && M.measure(o.l).peak > 1.2 * M.measure(single.l).peak, "strokes 30 ms apart add up (peak " + M.measure(o.l).peak.toFixed(3) + " vs " + M.measure(single.l).peak.toFixed(3) + " alone)");
var s1 = stroke(P, 1, 0.3)[0], s2 = stroke(P, 1, 0.3)[0];
var same2 = true; for (var i = 0; i < s1.length; i++) if (s1[i] !== s2[i]) { same2 = false; break; }
check(same2, "the same stroke renders identically (seeded noise)");
// a retrigger of the same counter value is not a stroke (only a change is)
var e3 = M.engine(P); e3.st.vl = 1; e3.st.tr = 7; for (var i = 0; i < 4800; i++) e3.tick(); var pk3 = e3.st.en; e3.st.vl = 1; e3.st.tr = 7; for (i = 0; i < 4800; i++) e3.tick();
check(e3.st.en < pk3, "an unchanged tr counter is not a new stroke");
var base = ours.Open;

// ── 4. controls, each on Open against the defaults
function ctl(label, p, fn, lo, hi) { var m = M.strokes(Object.assign({}, P, p), 16, 1, 0.9), v = fn(m); check(v > lo && v < hi, label + ": " + v.toFixed(2) + " (want " + lo + ".." + hi + ")"); }
ctl("Beads 400 %: smoother (grain fluctuation / default)", { beads: 4 }, function (m) { return m.cvE / base.cvE; }, 0.1, 0.9);
ctl("Beads 25 %: sparser (grain fluctuation / default)", { beads: 0.25 }, function (m) { return m.cvE / base.cvE; }, 1.15, 10);
function lvlRatio(p) { var a = [], b = []; for (var k = 1; k <= 8; k++) { [[P, a], [Object.assign({}, P, p), b]].forEach(function (pr) { var e = M.engine(pr[0]); for (var j = 0; j < k * 523; j++) e.st.noise(); e.st.vl = 1; e.st.tr = 1; var x = new Float64Array(0.6 * SR); for (var i = 0; i < x.length; i++) { e.tick(); x[i] = e.st.out1; } pr[1].push(peak10(x)); }); } return mean(b) / mean(a); }
[["Beads 400 %", { beads: 4 }], ["Beads 25 %", { beads: 0.25 }], ["Rattle 0", { rattle: 0 }], ["Rattle 1", { rattle: 1 }], ["Shake 400 %", { shake: 4 }], ["Shake 25 %", { shake: 0.25 }]].forEach(function (c) {
    var r = lvlRatio(c[1]), d = 20 * Math.log10(r);
    check(Math.abs(d) < 2.5, c[0] + " moves the loudness by " + d.toFixed(1) + " dB (texture, not level: within 2.5 dB)");
});
ctl("Damping 400 %: longer (t20 / default)", { damp: 4 }, function (m) { return m.t20 / base.t20; }, 1.8, 8);
ctl("Damping 25 %: shorter (t20 / default)", { damp: 0.25 }, function (m) { return m.t20 / base.t20; }, 0.12, 0.75);
ctl("Shake 400 %: slower build (rise / default)", { shake: 4 }, function (m) { return m.rise / base.rise; }, 1.5, 10);
ctl("Shake 25 %: faster build (rise / default)", { shake: 0.25 }, function (m) { return m.rise / base.rise; }, 0.1, 0.8);
ctl("Tone +12 st raises the centroid (x)", { tone: 12 }, function (m) { return m.cent / base.cent; }, 1.2, 3);
ctl("Tone -12 st lowers the centroid (x)", { tone: -12 }, function (m) { return m.cent / base.cent; }, 0.3, 0.85);
ctl("Rattle 1: longer grains, smoother (grain fluctuation / default)", { rattle: 1 }, function (m) { return m.cvE / base.cvE; }, 0.1, 0.95);
ctl("Rattle 0: shorter grains, sparser (grain fluctuation / default)", { rattle: 0 }, function (m) { return m.cvE / base.cvE; }, 1.05, 10);
var lv0 = peak10(stroke({ type: 0, vol: 0, pan: -1 }, 1, 0.5)[0]), lv6 = peak10(stroke({ type: 0, vol: -6, pan: -1 }, 1, 0.5)[0]);
check(Math.abs(20 * Math.log10(lv6 / lv0) + 6.02) < 0.05, "Level -6 dB is exactly -6.02 dB (" + (20 * Math.log10(lv6 / lv0)).toFixed(2) + ")");
var L = stroke({ type: 0, pan: -1 }, 1, 0.5), Rr = stroke({ type: 0, pan: 1 }, 1, 0.5), C = stroke({ type: 0, pan: 0 }, 1, 0.5);
check(maxAbs(L[1]) === 0 && maxAbs(L[0]) > 0 && maxAbs(Rr[0]) < 1e-12 * maxAbs(Rr[1]) && maxAbs(Rr[1]) > 0 && Math.abs(maxAbs(C[0]) / maxAbs(C[1]) - 1) < 1e-9,
    "Pan hard left / hard right / centre (equal power: centre " + (maxAbs(C[0]) / maxAbs(L[0])).toFixed(3) + " of the hard-pan level)");
check(Math.abs(maxAbs(C[0]) / maxAbs(L[0]) - Math.SQRT1_2) < 1e-9, "Pan is constant power (centre is -3 dB per side)");
check([0, 1, 2].every(function (t) { return maxAbs(stroke({ type: t }, 1, 0.5)[0]) < 0.9; }), "defaults (Level -6 dB, velocity 127) peak well under full scale, every stroke");
// stroke menu: a change between strokes is clean
var e4 = M.engine({ type: 0 }); e4.st.vl = 1; e4.st.tr = 1; var okT = true; for (var i = 0; i < 2 * SR; i++) { if (i % 2000 === 0) e4.set("type", (i / 2000) % 3); e4.tick(); if (!isFinite(e4.st.out1)) okT = false; }
check(okT, "switching Stroke every 40 ms while ringing stays finite");

// ── 5. caxixi_midi.js (tests/midi_sim.js: fake outlet, fake Task on a virtual clock, seeded Math.random)
var J = S.load(1);
J.c.list(60, 100);
assert.deepStrictEqual(J.out.map(function (o) { return o.slice(0, 2).join(" "); }), ["0 vl", "0 tr", "1 hit"]);
check(J.out[0][2] === 100 / 127 && J.out[1][2] === 1 && J.out[2][2] === 60 && J.out[2][4] === 0 && J.task.at === null, "Open, note-on C3: vl, tr 1, then the display's hit (stroke 0); nothing scheduled");
J.c.list(60, 0); J.out.length = 0; J.c.list(61, 64);
check(J.out[1][2] === 2 && J.out[2][2] === 61, "every note is a stroke (C#3 the same as C3) and bumps the counter");
J.out.length = 0; J.c.list(61, 0); J.c.list(61, 90); J.c.list(61, 0);
check(J.out.filter(function (o) { return o[1] === "tr"; }).length === 1 && J.out[1][2] === 3, "the same key twice in a row still bumps tr (a changed counter, never an unchanged one)");
J = S.load(1); J.c.list(60, 0);
check(J.out.length === 0, "a note-off alone does nothing");
J = S.load(1); J.c.strokemode(1); J.c.list(60, 127);
check(J.out[2][4] === 1 && J.out[0][2] === 1, "Stroke Hand: the display's hit says 1, velocity 127 -> vl 1");
J = S.load(1); J.c.strokemode(9); J.c.list(60, 100);
check(J.out[2][4] === 2 && J.task.at !== null, "Stroke out of range is clamped (9 -> FX, which schedules the phrase)");
// FX
function fxEvents(seed, len, rate, vel) { var j = S.load(seed); j.c.strokemode(2); if (len) j.c.length(len); if (rate) j.c.rate(rate); return j.play(60, vel || 127); }
var ev1 = fxEvents(3);
check(ev1.length === 9 && ev1.every(function (e) { return e.kind === 2; }), "FX at the defaults (1000 ms, 9.3 Hz) plays " + ev1.length + " bursts (round(1 s x 9.3) = 9), every hit says stroke 2");
check(ev1[0].t === 0 && Math.abs(ev1.map(function (e) { return e.t; }).pop() - 8 * 0.1075) < 0.1 && ev1.every(function (e) { return e.vel > 0 && e.vel <= 1; }), "FX: the first burst is the note itself, the last at ~" + (8 * 0.1075).toFixed(2) + " s, velocities in (0, 1]");
var ivs = [], lv = [];
for (var sd = 1; sd <= 200; sd++) { var q = fxEvents(sd); for (var k = 1; k < q.length; k++) ivs.push((q[k].t - q[k - 1].t) * 1000); lv.push(q.map(function (e) { return 20 * Math.log10(e.vel); })); }
var mi = mean(ivs), sdv = Math.sqrt(mean(ivs.map(function (v) { return (v - mi) * (v - mi); })));
check(Math.abs(mi - 1000 / 9.3) < 2 && sdv > 9 && sdv < 18 && Math.min.apply(null, ivs) >= 0.79 * 1000 / 9.3 && Math.max.apply(null, ivs) <= 1.21 * 1000 / 9.3, "FX intervals over 200 phrases: mean " + mi.toFixed(1) + " ms (108), sd " + sdv.toFixed(1) + " ms (+-20 % uniform = 12.4), within 80-120 %");
var col = function (i) { return mean(lv.map(function (v) { return v[i]; })); };
check(col(0) < -9 && col(0) > -14 && col(1) < -5 && col(1) > -9 && col(4) > -4.5 && col(4) < -1 && col(7) < -4 && col(8) < -9, "FX level contour (dB re the note): burst 1 " + col(0).toFixed(1) + ", 2 " + col(1).toFixed(1) + ", 5 " + col(4).toFixed(1) + ", 8 " + col(7).toFixed(1) + ", last " + col(8).toFixed(1) + " (previews -11, -5.7, -1.5, -4.5, -11.5 re the loudest)");
var lo = fxEvents(5, 2000, 12);
check(lo.length === 24 && fxEvents(5, 300, 16).length === 5, "Length 2000 ms x Rate 12 Hz plays " + lo.length + " bursts (24); Length 300 at 16 Hz plays " + fxEvents(5, 300, 16).length + " (5)");
check(fxEvents(5, 50, 9.3).length === 3 && fxEvents(5, 1000, 0.1).length === 1, "Length is clamped to 300 ms (50 -> 3 bursts at 9.3 Hz), Rate to 1 Hz (0.1 -> one burst in a second)");
J = S.load(2); J.c.strokemode(2); J.c.list(60, 100); var n1 = J.out.filter(function (o) { return o[1] === "tr"; }).length; J.c.list(60, 0);
check(J.task.at !== null && n1 === 1, "FX: a note-off does not cut the phrase (the next burst is still scheduled)");
J = S.load(2); J.c.strokemode(2); J.c.list(60, 100); J.out.length = 0; J.play(62, 100);
var hits = J.out.filter(function (o) { return o[1] === "hit"; });
check(hits.length === 9 && hits.every(function (o) { return o[2] === 62; }), "a new note restarts the phrase: 9 more bursts, all on the new note, none left of the old phrase (a single Task)");
J = S.load(2); J.c.strokemode(2); J.c.list(60, 100); J.c.strokemode(0); var nn = J.out.length; J.c.list(62, 100);
check(J.task.at === null && J.out.length === nn + 3, "a note on Open after FX cancels the phrase and is one stroke");
var sa = fxEvents(11).map(function (e) { return e.t.toFixed(5) + e.vel.toFixed(5); }).join(), sb = fxEvents(11).map(function (e) { return e.t.toFixed(5) + e.vel.toFixed(5); }).join(), sc = fxEvents(12).map(function (e) { return e.t.toFixed(5) + e.vel.toFixed(5); }).join();
check(sa === sb && sa !== sc, "the scatter is the seeded Math.random: the same seed gives the same phrase, another seed another");
var half = fxEvents(4, 1000, 9.3, 64), full = fxEvents(4, 1000, 9.3, 127);
check(half.every(function (e, i) { return Math.abs(e.vel / full[i].vel - 64 / 127) < 1e-9; }), "FX velocity scales every burst");

// ── 6. the built patch carries the same code and every control
var mp = path.join(__dirname, "../m4l/Caxixi.maxpat");
if (fs.existsSync(mp)) {
    var code = M.code(), got = require("./gen_shim.js").loadCode(mp);
    check(got.trim() === code.trim(), "m4l/Caxixi.maxpat's gen~ codebox is exactly scripts/caxixi_engine.py's code (rebuild with ./build.sh if not)");
}
console.log(passed + " passed" + (fails ? ", " + fails + " FAILED" : ""));
process.exit(fails ? 1 : 0);
