// node tests/test_engine.js — runs the generated gen~ code (scripts/shaker_engine.py) in the Node shim, plus shaker_midi.js with a fake outlet
// and Task: stability, silence, the five Types against the Ableton one-shots (tests/refs.json, from tests/fit_refs.js --write), strokes, direction,
// every control, the note map. Deterministic (seeded noise).
var assert = require("assert"), fs = require("fs"), path = require("path"), vm = require("vm"), cp = require("child_process");
var M = require("./shaker_measure.js"), SR = M.SR;
var REFS = JSON.parse(fs.readFileSync(path.join(__dirname, "refs.json"), "utf8"));
var info = JSON.parse(cp.execFileSync("python3", ["-c", "import sys,json;sys.path.insert(0,'" + path.join(__dirname, "../scripts") +
    "');import shaker_engine as E;print(json.dumps({'names':E.NAMES,'target':E.TARGET}))"], { encoding: "utf8" }));
var NAMES = info.names, fails = 0, passed = 0;
function check(ok, what) { if (ok) { passed++; if (process.env.V) console.log("ok   " + what); } else { fails++; console.log("FAIL " + what); } }
function fmt(v) { return isFinite(v) ? v.toFixed(2) : String(v); }
function stroke(params, vel, dir, sec) { var e = M.engine(params), n = Math.round(sec * SR), x = new Float64Array(n), r = new Float64Array(n); e.st.vl = vel; e.st.dir = dir || 0; e.st.tr = 1; for (var i = 0; i < n; i++) { e.tick(); x[i] = e.st.out1; r[i] = e.st.out2; } return [x, r, e]; }
function peak10(x) { return M.measure(x).peak; }
function maxAbs(x, a, b) { var m = 0; for (var i = a || 0; i < (b || x.length); i++) m = Math.max(m, Math.abs(x[i])); return m; }
function finite(x) { for (var i = 0; i < x.length; i++) if (!isFinite(x[i])) return false; return true; }
function mean(a) { return a.reduce(function (s, v) { return s + v; }, 0) / a.length; }
function thirdRms(a, b) { var s = 0; for (var i = 0; i < a.length; i++) { var d = Math.max(-45, a[i]) - Math.max(-45, b[i]); s += d * d; } return Math.sqrt(s / a.length); }

// ── 1. stability: every Type at the extremes, all controls min then max; finite, inside +-1; energy dies to exact silence
var LIM = { beads: [0.25, 4], damp: [0.25, 4], shake: [0.25, 4], rattle: [0, 1], tone: [-12, 12], back: [0, 1], vol: [-36, 6], pan: [-1, 1] };
NAMES.forEach(function (name, ty) {
    [0, 1].forEach(function (w) {
        var p = { type: ty }; Object.keys(LIM).forEach(function (k) { p[k] = LIM[k][w]; });
        var e = M.engine(p), x = new Float64Array(4 * SR), ok = true, big = 0;
        for (var i = 0; i < x.length; i++) {
            if (i % 2400 === 0 && i < 2 * SR) { e.st.vl = 1; e.st.dir = (i / 2400) % 2; e.st.tr = (i / 2400 + 1) % 65536; }
            e.tick(); x[i] = e.st.out1; if (!isFinite(e.st.out1) || !isFinite(e.st.out2)) ok = false; big = Math.max(big, Math.abs(e.st.out1), Math.abs(e.st.out2));
        }
        check(ok && big <= 1, name + " with every control at " + (w ? "max" : "min") + ", 40 strokes in 2 s: finite, peak " + big.toFixed(3));
    });
    var s = stroke({ type: ty, damp: 4, shake: 4, rattle: 1, beads: 4 }, 1, 0, 14), x = s[0];
    var tail = maxAbs(x, 10 * SR);
    check(finite(x) && tail < 1e-12 && s[2].st.en === 0, name + " dies to silence: max over 10-14 s " + tail.toExponential(1) + ", energy " + s[2].st.en);
});

// ── 2. the Types against the Ableton one-shots
var ours = {};
NAMES.forEach(function (name, ty) {
    var m = ours[name] = M.strokes({ type: ty, vol: 0, pan: -1 }, 24, 1, 0, 0.9), r = REFS[name];
    var bad = [];
    // a band the references have above -30 dB must match within 6 dB; below that the references sit on their recording noise floor (-35..-45), so ours may only not be above it
    for (var i = 0; i < 9; i++) if (m.bands[i] > r.bands[i] + 6 || (r.bands[i] > -30 && m.bands[i] < r.bands[i] - 6)) bad.push("band " + i + ": " + m.bands[i].toFixed(1) + " vs " + r.bands[i]);
    check(!bad.length, name + ": octave bands within 6 dB of the references (" + (bad.join("; ") || "all") + ")");
    check(thirdRms(m.third, r.third) < 7, name + ": 1/3-octave spectrum within 7 dB rms of the references (" + thirdRms(m.third, r.third).toFixed(1) + ")");
    check(m.cent > 0.88 * r.cent[0] && m.cent < 1.12 * r.cent[1], name + ": centroid " + m.cent.toFixed(0) + " Hz, references " + r.cent.map(Math.round).join("-"));
    function inr(k, lo, hi) { var v = m[k], t = r[k]; return t && isFinite(v) && v >= lo(t[0]) && v <= hi(t[1]); }
    check(inr("rise", function (a) { return a * 0.5 - 6; }, function (b) { return b * 1.6 + 10; }), name + ": rise " + m.rise.toFixed(0) + " ms, references " + r.rise.map(Math.round).join("-"));
    if (r.t20) check(inr("t20", function (a) { return a * 0.6; }, function (b) { return b * 1.8; }), name + ": t20 " + fmt(m.t20) + " ms, references " + r.t20.map(Math.round).join("-"));
    if (r.t30) check(inr("t30", function (a) { return a * 0.6; }, function (b) { return b * 1.8; }), name + ": t30 " + fmt(m.t30) + " ms, references " + r.t30.map(Math.round).join("-"));
    check(inr("cvE", function (a) { return a - 0.1; }, function (b) { return b + 0.1; }), name + ": early grain fluctuation " + fmt(m.cvE) + ", references " + r.cvE.map(function (v) { return v.toFixed(2); }).join("-"));
    if (r.cvL) check(inr("cvL", function (a) { return a - 0.12; }, function (b) { return b + 0.12; }), name + ": tail grain fluctuation " + fmt(m.cvL) + ", references " + r.cvL.map(function (v) { return v.toFixed(2); }).join("-"));
    var pks = []; for (var k = 0; k < 16; k++) { var e2 = M.engine({ type: ty, vol: 0, pan: -1 }); for (var j = 0; j < k * 7919 + 13; j++) e2.st.noise(); e2.st.vl = 1; e2.st.tr = 1; var xx = new Float64Array(Math.round(0.6 * SR)); for (var q = 0; q < xx.length; q++) { e2.tick(); xx[q] = e2.st.out1; } pks.push(peak10(xx)); }
    check(Math.abs(mean(pks) / info.target - 1) < 0.08, name + ": 10 ms RMS peak at velocity 1, Level 0 dB = " + mean(pks).toFixed(3) + " (target " + info.target + ")");
});
// the five Types differ: pairwise 1/3-octave spectra or envelopes
var pairs = 0, same = [];
for (var a = 0; a < 5; a++) for (var b = a + 1; b < 5; b++) {
    pairs++;
    var A = ours[NAMES[a]], B = ours[NAMES[b]];
    var d = thirdRms(A.third, B.third), dt = Math.abs(Math.log(A.t20 / B.t20)), dc = Math.abs(Math.log(A.cvE / B.cvE));
    if (d < 1.5 && dt < 0.3 && dc < 0.3) same.push(NAMES[a] + "/" + NAMES[b]);
}
check(!same.length, "all " + pairs + " pairs of Types differ in spectrum, decay or grain texture (alike: " + (same.join(", ") || "none") + ")");

// ── 3. strokes: velocity, direction, overlap, determinism
var P = { type: 0, vol: 0, pan: -1 };
var v1 = mean([1, 2, 3, 4, 5, 6].map(function (k) { var e = M.engine(P); for (var j = 0; j < k * 977; j++) e.st.noise(); e.st.vl = 1; e.st.tr = 1; var x = new Float64Array(0.5 * SR); for (var i = 0; i < x.length; i++) { e.tick(); x[i] = e.st.out1; } return peak10(x); }));
var vh = mean([1, 2, 3, 4, 5, 6].map(function (k) { var e = M.engine(P); for (var j = 0; j < k * 977; j++) e.st.noise(); e.st.vl = 0.5; e.st.tr = 1; var x = new Float64Array(0.5 * SR); for (var i = 0; i < x.length; i++) { e.tick(); x[i] = e.st.out1; } return peak10(x); }));
var dB = 20 * Math.log10(vh / v1);
check(dB < -4.5 && dB > -12, "half the velocity is " + dB.toFixed(1) + " dB quieter");
var fwp = mean([1, 2, 3, 4, 5, 6, 7, 8].map(function (k) { var e = M.engine(P); for (var j = 0; j < k * 311; j++) e.st.noise(); e.st.vl = 1; e.st.dir = 0; e.st.tr = 1; var x = new Float64Array(0.5 * SR); for (var i = 0; i < x.length; i++) { e.tick(); x[i] = e.st.out1; } return peak10(x); }));
var bkp = mean([1, 2, 3, 4, 5, 6, 7, 8].map(function (k) { var e = M.engine(P); for (var j = 0; j < k * 311; j++) e.st.noise(); e.st.vl = 1; e.st.dir = 1; e.st.tr = 1; var x = new Float64Array(0.5 * SR); for (var i = 0; i < x.length; i++) { e.tick(); x[i] = e.st.out1; } return peak10(x); }));
check(bkp / fwp > 0.5 && bkp / fwp < 0.85, "a back stroke at Back 70 % is " + (bkp / fwp).toFixed(2) + " of a forward one (levels follow ~Back^1.5: the rate follows the energy too)");
check(maxAbs(stroke(Object.assign({ back: 0 }, P), 1, 1, 0.5)[0]) === 0, "Back 0 makes the back stroke silent");
var bk1 = M.strokes(Object.assign({ back: 1 }, P), 12, 1, 1, 0.6), fw1 = M.strokes(Object.assign({ back: 1 }, P), 12, 1, 0, 0.6);
check(bk1.rise > fw1.rise * 1.03, "a back stroke builds up a little slower: rise " + bk1.rise.toFixed(1) + " vs " + fw1.rise.toFixed(1) + " ms (Back 100 %)");
// overlap: a second stroke 30 ms after the first adds to it, nothing clips, the sum is finite
var P6 = { type: 0, vol: -6, pan: -1 };
var ev = [{ t: 0.0, vel: 1, dir: 0 }, { t: 0.03, vel: 1, dir: 1 }, { t: 0.06, vel: 1, dir: 0 }], o = M.render(P6, ev, 1);
var single = M.render(P6, ev.slice(0, 1), 1);
check(finite(o.l) && maxAbs(o.l) < 1 && M.measure(o.l).peak > 1.2 * M.measure(single.l).peak, "strokes 30 ms apart add up (peak " + M.measure(o.l).peak.toFixed(3) + " vs " + M.measure(single.l).peak.toFixed(3) + " alone)");
var s1 = stroke(P, 1, 0, 0.3)[0], s2 = stroke(P, 1, 0, 0.3)[0];
var same2 = true; for (var i = 0; i < s1.length; i++) if (s1[i] !== s2[i]) { same2 = false; break; }
check(same2, "the same stroke renders identically (seeded noise)");
// a retrigger of the same counter value is not a stroke (only a change is)
var e3 = M.engine(P); e3.st.vl = 1; e3.st.tr = 7; for (var i = 0; i < 4800; i++) e3.tick(); var pk3 = e3.st.en; e3.st.vl = 1; e3.st.tr = 7; for (i = 0; i < 4800; i++) e3.tick();
check(e3.st.en < pk3, "an unchanged tr counter is not a new stroke");
var base = ours.Maraca;

// ── 4. controls, each on Maraca against the defaults
function ctl(label, p, fn, lo, hi) { var m = M.strokes(Object.assign({}, P, p), 16, 1, 0, 0.9), v = fn(m); check(v > lo && v < hi, label + ": " + v.toFixed(2) + " (want " + lo + ".." + hi + ")"); }
ctl("Beads 400 %: smoother (grain fluctuation / default)", { beads: 4 }, function (m) { return m.cvE / base.cvE; }, 0.1, 0.9);
ctl("Beads 25 %: sparser (grain fluctuation / default)", { beads: 0.25 }, function (m) { return m.cvE / base.cvE; }, 1.15, 10);
function lvlRatio(p) { var a = [], b = []; for (var k = 1; k <= 8; k++) { [[P, a], [Object.assign({}, P, p), b]].forEach(function (pr) { var e = M.engine(pr[0]); for (var j = 0; j < k * 523; j++) e.st.noise(); e.st.vl = 1; e.st.tr = 1; var x = new Float64Array(0.6 * SR); for (var i = 0; i < x.length; i++) { e.tick(); x[i] = e.st.out1; } pr[1].push(peak10(x)); }); } return mean(b) / mean(a); }
[["Beads 400 %", { beads: 4 }], ["Beads 25 %", { beads: 0.25 }], ["Rattle 0", { rattle: 0 }], ["Rattle 1", { rattle: 1 }], ["Shake 400 %", { shake: 4 }], ["Shake 25 %", { shake: 0.25 }]].forEach(function (c) {
    var r = lvlRatio(c[1]), d = 20 * Math.log10(r);
    check(Math.abs(d) < 2.5, c[0] + " moves the loudness by " + d.toFixed(1) + " dB (texture, not level: within 2.5 dB)");
});
ctl("Damping 400 %: longer (t20 / default)", { damp: 4 }, function (m) { return m.t20 / base.t20; }, 1.8, 8);
ctl("Damping 25 %: shorter (t20 / default)", { damp: 0.25 }, function (m) { return m.t20 / base.t20; }, 0.12, 0.65);
ctl("Shake 400 %: slower build (rise / default)", { shake: 4 }, function (m) { return m.rise / base.rise; }, 1.5, 10);
ctl("Shake 25 %: faster build (rise / default)", { shake: 0.25 }, function (m) { return m.rise / base.rise; }, 0.1, 0.8);
ctl("Tone +12 st raises the centroid (x)", { tone: 12 }, function (m) { return m.cent / base.cent; }, 1.2, 3);
ctl("Tone -12 st lowers the centroid (x)", { tone: -12 }, function (m) { return m.cent / base.cent; }, 0.3, 0.85);
ctl("Rattle 1: longer grains, smoother (grain fluctuation / default)", { rattle: 1 }, function (m) { return m.cvE / base.cvE; }, 0.1, 0.95);
ctl("Rattle 0: shorter grains, sparser (grain fluctuation / default)", { rattle: 0 }, function (m) { return m.cvE / base.cvE; }, 1.05, 10);
var lv0 = peak10(stroke({ type: 0, vol: 0, pan: -1 }, 1, 0, 0.5)[0]), lv6 = peak10(stroke({ type: 0, vol: -6, pan: -1 }, 1, 0, 0.5)[0]);
check(Math.abs(20 * Math.log10(lv6 / lv0) + 6.02) < 0.05, "Level -6 dB is exactly -6.02 dB (" + (20 * Math.log10(lv6 / lv0)).toFixed(2) + ")");
var L = stroke({ type: 0, pan: -1 }, 1, 0, 0.5), Rr = stroke({ type: 0, pan: 1 }, 1, 0, 0.5), C = stroke({ type: 0, pan: 0 }, 1, 0, 0.5);
check(maxAbs(L[1]) === 0 && maxAbs(L[0]) > 0 && maxAbs(Rr[0]) < 1e-12 * maxAbs(Rr[1]) && maxAbs(Rr[1]) > 0 && Math.abs(maxAbs(C[0]) / maxAbs(C[1]) - 1) < 1e-9,
    "Pan hard left / hard right / centre (equal power: centre " + (maxAbs(C[0]) / maxAbs(L[0])).toFixed(3) + " of the hard-pan level)");
check(Math.abs(maxAbs(C[0]) / maxAbs(L[0]) - Math.SQRT1_2) < 1e-9, "Pan is constant power (centre is -3 dB per side)");
var dflt = peak10(stroke({ type: 0 }, 100 / 127, 0, 0.5)[0]);
check(maxAbs(stroke({ type: 0 }, 1, 0, 0.5)[0]) < 0.9 && maxAbs(stroke({ type: 1 }, 1, 0, 0.5)[0]) < 0.9, "defaults (Level -6 dB, velocity 127) peak well under full scale");
// type menu: a Type change between strokes is clean
var e4 = M.engine({ type: 0 }); e4.st.vl = 1; e4.st.tr = 1; var okT = true; for (var i = 0; i < 2 * SR; i++) { if (i % 2000 === 0) e4.set("type", (i / 2000) % 5); e4.tick(); if (!isFinite(e4.st.out1)) okT = false; }
check(okT, "switching Type every 40 ms while ringing stays finite");

// ── 5. shaker_midi.js
function loadMidi() {
    var out = [], tasks = [], ctx = {
        outlet: function (n) { out.push([n].concat([].slice.call(arguments, 1))); },
        Task: function (fn) { var t = { fn: fn, at: null, cancel: function () { t.at = null; }, schedule: function (ms) { t.at = ms; } }; tasks.push(t); return t; },
        Math: Math, Number: Number
    };
    vm.createContext(ctx);
    vm.runInContext(fs.readFileSync(path.join(__dirname, "../m4l/shaker_midi.js"), "utf8"), ctx);
    return { c: ctx, out: out, task: tasks[0] };
}
var J = loadMidi();
J.c.list(60, 100);
assert.deepStrictEqual(J.out.map(function (o) { return o.slice(0, 2).join(" "); }), ["0 vl", "0 dir", "0 tr", "1 hit"]);
check(J.out[0][2] === 100 / 127 && J.out[1][2] === 0 && J.out[2][2] === 1 && J.out[3][2] === 60 && J.out[3][4] === 0, "note-on C3: vl, dir 0 (even = forward), tr 1, then the display's hit");
J.c.list(60, 0); J.out.length = 0; J.c.list(61, 64);
check(J.out[1][2] === 1 && J.out[2][2] === 2 && J.out[3][4] === 1, "C#3 (odd) is the back stroke and bumps the counter");
J.out.length = 0; J.c.list(61, 0); J.c.list(61, 90); J.c.list(61, 0);
check(J.out.filter(function (o) { return o[1] === "tr"; }).length === 1 && J.out[2][2] === 3, "the same key twice in a row still bumps tr (a changed counter, never an unchanged one)");
check(J.out.every(function (o) { return o[1] !== "vl" || (o[2] > 0 && o[2] <= 1); }), "velocity 1..127 -> vl in (0, 1]");
J = loadMidi(); J.c.list(60, 0);
check(J.out.length === 0, "a note-off alone does nothing");
J = loadMidi(); J.c.roll(8); J.c.list(60, 100);
check(J.task.at === 125, "Roll 8 Hz: the next stroke is scheduled 125 ms after the note-on");
J.out.length = 0; J.task.fn(); var d1 = J.out[1][2]; J.task.fn(); var d2 = J.out[1 + 4][2];
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
// Direction menu: 0 Key, 1 Alternate, 2 Forward, 3 Back
function dirs(mode, notes, rollTicks) {
    var j = loadMidi(), seq = [];
    function grab() { var r = j.out.filter(function (o) { return o[1] === "dir"; }).map(function (o) { return o[2]; }); j.out.length = 0; return r; }
    j.c.direction(mode);
    notes.forEach(function (n) { j.c.list(n, 100); j.c.list(n, 0); seq = seq.concat(grab()); });
    if (rollTicks) { j.c.roll(8); j.c.list(60, 100); seq = seq.concat(grab()); for (var i = 0; i < rollTicks; i++) { j.task.fn(); seq = seq.concat(grab()); } }
    return seq.join("");
}
check(dirs(0, [60, 60, 61, 62, 61]) === "00101", "Direction Key: parity, same note twice stays");
check(dirs(1, [60, 60, 61, 72, 60]) === "01010", "Direction Alternate: forward, back, forward ... whatever the notes");
check(dirs(2, [60, 61, 61, 62], 2) === "0000000", "Direction Forward: every stroke forward, Roll too");
check(dirs(3, [60, 61, 62], 2) === "111111", "Direction Back: every stroke back, Roll too");
check(dirs(1, [60], 3) === "01010", "Direction Alternate across Roll: the roll ticks keep alternating from the note");
check(dirs(1, [60, 61], 2) === "01" + "0" + "10", "Direction Alternate: a roll after two notes continues from the last stroke");
J = loadMidi(); J.c.direction(7); J.c.list(61, 100);
check(J.out[1][2] === 1, "Direction out of range is clamped (7 -> Back)");

// ── 6. the built patch carries the same code and every control
var mp = path.join(__dirname, "../m4l/Shaker.maxpat");
if (fs.existsSync(mp)) {
    var code = M.code(), got = require("./gen_shim.js").loadCode(mp);
    check(got.trim() === code.trim(), "m4l/Shaker.maxpat's gen~ codebox is exactly scripts/shaker_engine.py's code (rebuild with ./build.sh if not)");
}
console.log(passed + " passed" + (fails ? ", " + fails + " FAILED" : ""));
process.exit(fails ? 1 : 0);
