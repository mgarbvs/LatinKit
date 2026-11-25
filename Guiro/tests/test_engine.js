// node tests/test_engine.js — runs the generated gen~ code (scripts/guiro_engine.py) in the Node shim, plus guiro_midi.js with a fake outlet and Task:
// stability, silence, the gesture itself (the engine's own impact times, `fire`, against the design), every stroke against the Latin Percussion
// previews (tests/refs.json: the range over takes A-D, from tests/fit_refs.js --write), every control, the note map, and that the built patch carries
// the same code. Deterministic (seeded noise).
var assert = require("assert"), fs = require("fs"), path = require("path"), vm = require("vm"), cp = require("child_process");
var M = require("./guiro_measure.js"), SR = M.SR;
var REFS = JSON.parse(fs.readFileSync(path.join(__dirname, "refs.json"), "utf8"));
var info = JSON.parse(cp.execFileSync("python3", ["-c", "import sys,json;sys.path.insert(0,'" + path.join(__dirname, "../scripts") +
    "');import guiro_engine as E;print(json.dumps({'names':E.NAMES,'target':E.TARGET,'stk':E.STK,'base':E.BASE_RATE,'types':{n:E.flat(n) for n in E.NAMES}}))"], { encoding: "utf8" }));
var NAMES = info.names, KINDS = ["Up", "Down", "Long", "Top"], fails = 0, passed = 0;
function check(ok, what) { if (ok) { passed++; if (process.env.V) console.log("ok   " + what); } else { fails++; console.log("FAIL " + what); } }
function fmt(v) { return isFinite(v) ? v.toFixed(2) : String(v); }
function mean(a) { return a.reduce(function (s, v) { return s + v; }, 0) / a.length; }
function std(a) { var m = mean(a); return Math.sqrt(mean(a.map(function (v) { return (v - m) * (v - m); }))); }
function maxAbs(x, a, b) { var m = 0; for (var i = a || 0; i < (b || x.length); i++) m = Math.max(m, Math.abs(x[i])); return m; }
function finite(x) { for (var i = 0; i < x.length; i++) if (!isFinite(x[i])) return false; return true; }
function thirdRms(a, b) { var s = 0; for (var i = 0; i < a.length; i++) { var d = Math.max(-45, a[i]) - Math.max(-45, b[i]); s += d * d; } return Math.sqrt(s / a.length); }
// one stroke on a fresh engine; fires: sample index of every impact the engine itself made
function stroke(params, vel, stk, sec, burn) {
    var e = M.engine(params), n = Math.round(sec * SR), x = new Float64Array(n), r = new Float64Array(n), fires = [];
    for (var j = 0; j < (burn || 0); j++) e.st.noise();
    e.st.vl = vel; e.st.stk = stk; e.st.tr = 1;
    for (var i = 0; i < n; i++) { e.tick(); x[i] = e.st.out1; r[i] = e.st.out2; if (e.st.fire > 0.5) fires.push(i); }
    return { x: x, r: r, e: e, fires: fires };
}
function peak10(x) { return M.measure(x).peak; }
function lvl(p, stk, sec, k0) {   // mean 10 ms RMS peak over 10 strokes (single strokes are as random as the noise)
    var a = []; for (var k = 1; k <= 10; k++) a.push(peak10(stroke(p, 1, stk, sec || 0.6, (k0 || 0) + k * 523).x)); return mean(a);
}

// ── 1. stability: every Type at the extremes, 40 strokes of every kind in 2 s; finite, inside +-1; the ring dies to silence
var LIM = { len: [100, 1500], speed: [0.25, 4], ridge: [0.25, 4], tone: [-12, 12], vary: [0, 1], vol: [-36, 6], pan: [-1, 1] };
NAMES.forEach(function (name, ty) {
    [0, 1].forEach(function (w) {
        var p = { type: ty }; Object.keys(LIM).forEach(function (k) { p[k] = LIM[k][w]; });
        var e = M.engine(p), ok = true, big = 0;
        for (var i = 0; i < 4 * SR; i++) {
            if (i % 2400 === 0 && i < 2 * SR) { e.st.vl = 1; e.st.stk = (i / 2400) % 4; e.st.tr = (i / 2400 + 1) % 65536; }
            e.tick(); if (!isFinite(e.st.out1) || !isFinite(e.st.out2)) ok = false; big = Math.max(big, Math.abs(e.st.out1), Math.abs(e.st.out2));
        }
        check(ok && big <= 1, name + " with every control at " + (w ? "max" : "min") + ", 40 strokes in 2 s: finite, peak " + big.toFixed(3));
    });
    KINDS.forEach(function (k, i) {
        var s = stroke({ type: ty, len: 1500 }, 1, i, 14);
        var tail = maxAbs(s.x, 10 * SR);
        check(finite(s.x) && tail < 1e-12 && s.e.st.snd === 0, name + " " + k + " dies to silence: max over 10-14 s " + tail.toExponential(1));
    });
});

// ── 2. the gesture: the engine's own impact times against the design
var BASE = info.base;
KINDS.slice(0, 3).forEach(function (k, i) {
    var st = info.stk[k], dur = k === "Long" ? 450 : st.dur;
    var s = stroke({ type: 0, vary: 0, len: 450 }, 1, i, 0.9, 0), f = s.fires, ms = f.map(function (v) { return v / SR * 1000; });
    var want = BASE * info.types.Guiro.trm * st.rm * dur / 1000;
    check(f[0] === 0, k + ": the first impact fires with the note");
    check(Math.abs(f.length - want) < 0.08 * want + 1.5, k + ": " + f.length + " impacts in " + dur + " ms, design " + want.toFixed(1) + " (rate " + (BASE * st.rm).toFixed(0) + " /s)");
    check(ms[ms.length - 1] <= dur + 1, k + ": nothing after the stroke's " + dur + " ms (last impact " + ms[ms.length - 1].toFixed(1) + " ms)");
    // the curve: Down slows down (the second half has fewer impacts), Up is flat
    var h1 = ms.filter(function (t) { return t < dur / 2; }).length, h2 = f.length - h1;
    if (k === "Down") check(h2 < 0.9 * h1, "Down slows down over the stroke: " + h1 + " impacts in the first half, " + h2 + " in the second");
    if (k === "Up") check(Math.abs(h1 - h2) <= 2, "Up is even: " + h1 + " / " + h2);
});
check(stroke({ type: 0 }, 1, 3, 0.5).fires.length === 1, "Top is a single impact");
(function () {
    var a = stroke({ type: 0, vary: 0, len: 450 }, 1, 2, 1.2).fires.length, tw = function (p) { return stroke(Object.assign({ type: 0, vary: 0, len: 450 }, p), 1, 2, 1.2).fires.length; };
    var last = function (p) { var f = stroke(Object.assign({ type: 0, vary: 0, len: 450 }, p), 1, 2, 1.2).fires; return f[f.length - 1] / SR * 1000; };
    check(Math.abs(tw({ speed: 2 }) / a - 1) < 0.12 && last({ speed: 2 }) < 0.6 * last({}), "Speed 200 %: the same ridges in half the time (" + tw({ speed: 2 }) + " impacts vs " + a + ", the last at " + last({ speed: 2 }).toFixed(0) + " vs " + last({}).toFixed(0) + " ms)");
    check(Math.abs(tw({ ridge: 2 }) / a - 2) < 0.15, "Ridge 200 %: twice the impacts (" + tw({ ridge: 2 }) + " vs " + a + ")");
    check(Math.abs(stroke({ type: 0, vary: 0, len: 450, speed: 0.5 }, 1, 2, 1.2).fires.length / a - 1) < 0.12, "Speed 50 %: the same ridges in twice the time");
    var l2 = tw({ len: 900 });
    check(Math.abs(l2 / a - 2) < 0.15, "Length 900 ms: twice the impacts, twice as long (" + l2 + " vs " + a + ")");
    var iv = function (v) { var f = stroke({ type: 0, vary: v, len: 450, ridge: 2 }, 1, 0, 0.3).fires, d = []; for (var i = 1; i < f.length; i++) d.push(f[i] - f[i - 1]); return d; };
    var d0 = iv(0), d1 = iv(1);
    check(std(d0) / mean(d0) < 0.05, "Vary 0: even ridges (interval spread " + (std(d0) / mean(d0)).toFixed(3) + ")");
    check(std(d1) / mean(d1) > 0.05 && std(d1) / mean(d1) < 0.35 && Math.min.apply(null, d1) > 0.3 * mean(d1), "Vary 100 %: uneven, never close to backwards (spread " + (std(d1) / mean(d1)).toFixed(3) + ", shortest " + (Math.min.apply(null, d1) / mean(d1)).toFixed(2) + " of the mean)");
    check(Math.abs(mean(d1) / mean(d0) - 1) < 0.06, "Vary keeps the mean rate (" + (mean(d1) / mean(d0)).toFixed(3) + ")");
})();
(function () {   // a new note restarts the gesture; an unchanged counter does not
    var e = M.engine({ type: 0, vary: 0 }), f = [], i;
    e.st.vl = 1; e.st.stk = 2; e.st.tr = 1;
    for (i = 0; i < 0.2 * SR; i++) { e.tick(); if (e.st.fire > 0.5) f.push(i); }
    var n1 = f.length; e.st.tr = 1; for (i = 0; i < 0.05 * SR; i++) { e.tick(); if (e.st.fire > 0.5) f.push(0.2 * SR + i); }
    check(f.length > n1 + 3 && f[n1] > 0.2 * SR, "an unchanged tr counter is not a new stroke (the gesture just goes on)");
    e.st.tr = 2; e.tick(); check(e.st.fire > 0.5, "a changed counter fires an impact at once (the gesture restarts)");
})();
(function () {
    var s1 = stroke({ type: 0 }, 1, 2, 0.3).x, s2 = stroke({ type: 0 }, 1, 2, 0.3).x, same = true;
    for (var i = 0; i < s1.length; i++) if (s1[i] !== s2[i]) { same = false; break; }
    check(same, "the same stroke renders identically (seeded noise)");
})();

// ── 3. the strokes against the previews: Güiro, ranges over takes A-D
var ours = {};
KINDS.forEach(function (k, ki) {
    var m = ours[k] = M.strokes({ type: 0, vol: 0, pan: -1 }, 24, 1, ki, k === "Long" ? 0.9 : 0.5), r = REFS[k];
    function inr(key, lo, hi) { var t = r[key], v = m[key]; return t && isFinite(v) && v >= lo(t[0]) && v <= hi(t[1]); }
    function rng(key, lo, hi, label) { check(inr(key, lo, hi), k + ": " + (label || key) + " " + fmt(m[key]) + ", references " + (r[key] ? r[key].map(fmt).join(" .. ") : "-")); }
    var mul = function (c) { return function (v) { return v * c; }; }, add = function (c) { return function (v) { return v + c; }; };
    rng("len", mul(0.7), mul(1.35), "length (ms, onset to the last -20 dB)");
    if (k === "Top") ["t10", "t20", "t30"].forEach(function (key) { rng(key, mul(0.6), mul(1.7)); });
    else {
        rng("rate", mul(0.7), mul(1.3), "impact rate (/s, detected)");
        rng("lv3", add(-6), add(6), "last third's level re the first (dB)");
        check(m.tail > 0.4 * r.tail[0] && m.tail < 1.6 * r.tail[1] + 15, k + ": tail " + fmt(m.tail) + " ms (-20 to -35 dB), references " + r.tail.map(fmt).join(" .. "));
    }
    rng("cent", mul(0.8), mul(1.2), "centroid (Hz)");
    rng("cvE", add(-0.15), add(0.15), "grain fluctuation");
    var bad = [];
    // each octave band within 6 dB of the range the takes span (A-D are different instruments); under -35 dB the previews sit on their own noise floor, so only an upper bound
    for (var i = 0; i < 10; i++) { var lo = r.bandsR[i][0], hi = r.bandsR[i][1]; if (m.bands[i] > hi + 6 || (hi > -35 && m.bands[i] < lo - 6)) bad.push("band " + i + ": " + m.bands[i].toFixed(1) + " vs " + lo + " .. " + hi); }
    check(!bad.length, k + ": octave bands within 6 dB of the range over the takes (" + (bad.join("; ") || "all") + ")");
    check(thirdRms(m.third, r.third) < 8, k + ": 1/3-octave spectrum within 8 dB rms of the pooled references (" + thirdRms(m.third, r.third).toFixed(1) + ")");
    check(Math.abs(lvl({ type: 0, vol: 0, pan: -1 }, ki, 0.9) / info.target - 1) < 0.08, k + ": 10 ms RMS peak at velocity 1, Level 0 dB = target " + info.target);
});
(function () {   // the four strokes differ from one another
    var same = [];
    for (var a = 0; a < 4; a++) for (var b = a + 1; b < 4; b++) {
        var A = ours[KINDS[a]], B = ours[KINDS[b]];
        if (Math.abs(Math.log(A.len / B.len)) < 0.25 && Math.abs(Math.log(A.rate / B.rate || 1)) < 0.2) same.push(KINDS[a] + "/" + KINDS[b]);
    }
    check(!same.length, "all strokes differ in length or rate (alike: " + (same.join(", ") || "none") + ")");
    check(ours.Up.len < ours.Down.len && ours.Down.len < ours.Long.len && ours.Top.len < ours.Up.len, "length order: Top < Up < Down < Long (" + KINDS.map(function (k) { return fmt(ours[k].len); }).join(", ") + " ms)");
})();

// ── 3b. Reco-reco against the Freesound reco-reco (tests/refs_reco.json from tests/fit_reco.js --write; a single recording, so loose bounds) and the Güiro's identity
(function () {
    var RR = JSON.parse(fs.readFileSync(path.join(__dirname, "refs_reco.json"), "utf8")), pool = [], p = { type: 1, vol: 0, pan: -1 };
    [0, 1, 2].forEach(function (i) { pool = pool.concat(M.strokes(p, 12, 1, i, i === 2 ? 0.9 : 0.5).each); });
    var a = M.average(pool), rms = thirdRms(a.third, RR.third);
    check(rms < 5, "Reco-reco: 1/3-octave spectrum of Up + Down + Long within 5 dB rms of the reco-reco clips (" + rms.toFixed(1) + ")");
    check(a.cent > 0.75 * RR.cent && a.cent < 1.3 * RR.cent, "Reco-reco: centroid " + a.cent.toFixed(0) + " Hz, recording " + RR.cent + " Hz");
    var rt = M.strokes(p, 12, 1, 3, 0.6);
    check(rt.t20 > 0.5 * RR.ring.t20 && rt.t20 < 2 * RR.ring.t20 && rt.t30 > 0.5 * RR.ring.t30 && rt.t30 < 2 * RR.ring.t30,
        "Reco-reco: the Top tap rings like the ring-out after a run (t20 " + fmt(rt.t20) + " / t30 " + fmt(rt.t30) + " ms, recording " + fmt(RR.ring.t20) + " / " + fmt(RR.ring.t30) + ")");
    var fr = stroke({ type: 1, vary: 0, len: 450 }, 1, 2, 0.9, 0).fires.length, want = BASE * info.types.Recoreco.trm * info.stk.Long.rm * 450 / 1000;
    check(Math.abs(fr - want) < 0.08 * want + 1.5, "Reco-reco: " + fr + " impacts in a Long stroke, design " + want.toFixed(0) + " (trm " + info.types.Recoreco.trm + ")");
    // the Güiro must not move when the Reco-reco is refitted: a fingerprint of its four strokes (sum of |out1| and out1 at fixed samples)
    var h = require("crypto").createHash("sha256");
    [0, 1, 2, 3].forEach(function (i) { var s = stroke({ type: 0, vary: 0.5, len: 450 }, 0.8, i, 0.7, 0).x; for (var k = 0; k < s.length; k += 7) h.update(s[k].toFixed(10)); });
    check(h.digest("hex").slice(0, 16) === "9efc3af0ea91287e", "Güiro render is bit-for-bit what it was before the Reco-reco was fitted (fingerprint)");
})();

// ── 4. controls
var P = { type: 0, vol: 0, pan: -1 };
(function () {
    var base = ours.Long, ctl = function (label, p, stk, key, lo, hi, ref) {
        var m = M.strokes(Object.assign({}, P, p), 12, 1, stk, 0.9), r = ref || ours[KINDS[stk]], v = m[key] / r[key]; check(v > lo && v < hi, label + ": x" + v.toFixed(2) + " (want " + lo + ".." + hi + ")");
    };
    ctl("Tone +12 st raises the centroid", { tone: 12 }, 2, "cent", 1.3, 3.2);
    ctl("Tone -12 st lowers the centroid", { tone: -12 }, 2, "cent", 0.3, 0.8);
    ctl("Speed 200 %: more impacts per second (detected)", { speed: 2 }, 1, "rate", 1.4, 2.3);
    ctl("Speed 200 %: a shorter stroke (len)", { speed: 2 }, 2, "len", 0.35, 0.65);
    ctl("Ridge 50 %: fewer impacts per second (detected)", { ridge: 0.5 }, 1, "rate", 0.35, 0.75);
    ctl("Ridge 400 %: smoother (grain fluctuation)", { ridge: 4 }, 2, "cvE", 0.1, 0.8);
    ctl("Ridge 25 %: a quarter of the impacts per second (detected)", { ridge: 0.25 }, 2, "rate", 0.15, 0.45);
    ctl("Length 900 ms doubles the Long stroke (len)", { len: 900 }, 2, "len", 1.6, 2.3, { len: base.len });
    ctl("Length 200 ms shortens it (len)", { len: 200 }, 2, "len", 0.3, 0.6, { len: base.len });
    var lv = function (p, stk) { return 20 * Math.log10(lvl(Object.assign({}, P, p), stk, 0.9, 77) / lvl(P, stk, 0.9, 77)); };
    [["Speed 200 %", { speed: 2 }, 1], ["Speed 50 %", { speed: 0.5 }, 1], ["Ridge 400 %", { ridge: 4 }, 2], ["Ridge 25 %", { ridge: 0.25 }, 2], ["Vary 0", { vary: 0 }, 1], ["Vary 100 %", { vary: 1 }, 1]].forEach(function (c) {
        var d = lv(c[1], c[2]); check(Math.abs(d) < 4.5, c[0] + " moves the loudness by " + d.toFixed(1) + " dB (texture, not level: within 4.5 dB)");
    });
    var h = lvl(P, 2, 0.9, 5), hv = mean([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map(function (k) { return peak10(stroke(P, 0.5, 2, 0.9, 5 + k * 523).x); }));
    var dB = 20 * Math.log10(hv / h); check(dB < -4.5 && dB > -8, "half the velocity is " + dB.toFixed(1) + " dB quieter");
    var lv0 = peak10(stroke({ type: 0, vol: -12, pan: -1 }, 1, 2, 0.5).x), lv6 = peak10(stroke({ type: 0, vol: -18, pan: -1 }, 1, 2, 0.5).x);   // quiet enough not to touch the clamp
    check(Math.abs(20 * Math.log10(lv6 / lv0) + 6.02) < 0.05, "Level -6 dB is exactly -6.02 dB (" + (20 * Math.log10(lv6 / lv0)).toFixed(2) + ")");
    var L = stroke({ type: 0, pan: -1 }, 1, 2, 0.5), Rr = stroke({ type: 0, pan: 1 }, 1, 2, 0.5), C = stroke({ type: 0, pan: 0 }, 1, 2, 0.5);
    check(maxAbs(L.r) === 0 && maxAbs(L.x) > 0 && maxAbs(Rr.x) < 1e-12 * maxAbs(Rr.r) && maxAbs(Rr.r) > 0 && Math.abs(maxAbs(C.x) / maxAbs(C.r) - 1) < 1e-9 && Math.abs(maxAbs(C.x) / maxAbs(L.x) - Math.SQRT1_2) < 1e-9,
        "Pan hard left / hard right / centre (constant power, centre -3 dB per side)");
    check(KINDS.every(function (k, i) { return maxAbs(stroke({ type: 0 }, 1, i, 0.9).x) < 0.9 && maxAbs(stroke({ type: 1 }, 1, i, 0.9).x) < 0.9; }), "defaults (Level -6 dB, velocity 127) peak well under full scale");
    // Reco-reco: a different instrument (brighter, rings longer); same controls
    var G = M.strokes({ type: 0, vol: 0, pan: -1 }, 12, 1, 2, 0.9), Rc = M.strokes({ type: 1, vol: 0, pan: -1 }, 12, 1, 2, 0.9);
    check(Rc.cent > 1.15 * G.cent, "Reco-reco is brighter than the Güiro (centroid " + Rc.cent.toFixed(0) + " vs " + G.cent.toFixed(0) + " Hz)");
    var Gt = M.strokes({ type: 0, vol: 0, pan: -1 }, 12, 1, 3, 0.9), Rt = M.strokes({ type: 1, vol: 0, pan: -1 }, 12, 1, 3, 0.9);
    check(Rt.t20 > 1.2 * Gt.t20, "Reco-reco's Top rings longer than the Güiro's (t20 " + fmt(Rt.t20) + " vs " + fmt(Gt.t20) + " ms)");
    check(Math.abs(Rc.rate / G.rate - 1) > 0.1, "Reco-reco's ridges are at a different rate (" + fmt(Rc.rate) + " vs " + fmt(G.rate) + " /s)");
    // type menu: a Type change between strokes is clean
    var e4 = M.engine({ type: 0 }); e4.st.vl = 1; e4.st.stk = 2; e4.st.tr = 1; var okT = true;
    for (var i = 0; i < 2 * SR; i++) { if (i % 2000 === 0) e4.set("type", (i / 2000) % 2); e4.tick(); if (!isFinite(e4.st.out1)) okT = false; }
    check(okT, "switching Type every 40 ms while scraping stays finite");
})();

// ── 5. guiro_midi.js
function loadMidi() {
    var out = [], tasks = [], ctx = {
        outlet: function (n) { out.push([n].concat([].slice.call(arguments, 1))); },
        Task: function (fn) { var t = { fn: fn, at: null, cancel: function () { t.at = null; }, schedule: function (ms) { t.at = ms; } }; tasks.push(t); return t; },
        Math: Math, Number: Number
    };
    vm.createContext(ctx);
    vm.runInContext(fs.readFileSync(path.join(__dirname, "../m4l/guiro_midi.js"), "utf8"), ctx);
    return { c: ctx, out: out, task: tasks[0] };
}
function strokes(j) { var r = j.out.filter(function (o) { return o[1] === "stk"; }).map(function (o) { return o[2]; }); j.out.length = 0; return r.join(""); }
var J = loadMidi();
J.c.list(60, 100);
assert.deepStrictEqual(J.out.map(function (o) { return o.slice(0, 2).join(" "); }), ["0 stk", "0 vl", "0 tr", "1 hit"]);
check(J.out[0][2] === 0 && J.out[1][2] === 100 / 127 && J.out[2][2] === 1 && J.out[3][2] === 60 && J.out[3][4] === 0, "note-on C3: stk 0 (Up), vl, tr 1, then the display's hit");
J.c.list(60, 0); J.out.length = 0;
[["C3 Up", 60, 0], ["C#3 Down", 61, 1], ["D3 Long", 62, 2], ["D#3 Top", 63, 3], ["E3 Up again", 64, 0], ["B3 Top", 71, 3]].forEach(function (c) {
    J.c.list(c[1], 90); J.c.list(c[1], 0); check(strokes(J) === String(c[2]), "Key: " + c[0]);
});
J = loadMidi(); J.c.list(61, 100); J.c.list(61, 0); J.c.list(61, 90); J.c.list(61, 0);
check(J.out.filter(function (o) { return o[1] === "tr"; }).map(function (o) { return o[2]; }).join() === "1,2", "the same key twice in a row still bumps tr (a changed counter, never an unchanged one)");
check(J.out.every(function (o) { return o[1] !== "vl" || (o[2] > 0 && o[2] <= 1); }), "velocity 1..127 -> vl in (0, 1]");
J = loadMidi(); J.c.list(60, 0);
check(J.out.length === 0, "a note-off alone does nothing");
function seq(mode, notes, rollTicks) {
    var j = loadMidi(), s = "";
    j.c.strokemode(mode);
    notes.forEach(function (n) { j.c.list(n, 100); j.c.list(n, 0); s += strokes(j); });
    if (rollTicks) { j.c.roll(8); j.c.list(notes[0], 100); s += strokes(j); for (var i = 0; i < rollTicks; i++) { j.task.fn(); s += strokes(j); } }
    return s;
}
check(seq(1, [60, 61, 62, 63]) === "0000" && seq(2, [60, 62]) === "11" && seq(3, [60, 61]) === "22" && seq(4, [60, 61]) === "33", "Stroke Up / Down / Long / Top: always that stroke, whatever the note");
check(seq(5, [60, 60, 72, 60, 61]) === "01010", "Stroke Alternate: Up, Down, Up ... whatever the notes");
check(seq(0, [60], 4) === "0" + "0" + "1010" && seq(0, [61], 3) === "1" + "1" + "010", "Roll on Key Up / Down notes alternates Up / Down (the note's own stroke first)");
check(seq(0, [62], 3) === "22222" && seq(0, [63], 2) === "3333" && seq(3, [60], 2) === "2222" && seq(1, [60], 3) === "00000", "Roll repeats Long, Top and the fixed entries");
check(seq(5, [60, 61], 2) === "01" + "0" + "10", "Stroke Alternate: a roll after two notes continues from the last stroke");
J = loadMidi(); J.c.roll(8); J.c.list(60, 100);
check(J.task.at === 125, "Roll 8 Hz: the next stroke is scheduled 125 ms after the note-on");
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
J = loadMidi(); J.c.strokemode(9); J.c.list(61, 100); var sa = strokes(J);
J = loadMidi(); J.c.strokemode(-3); J.c.list(61, 100);
check(sa === "0" && strokes(J) === "1", "Stroke out of range is clamped (9 -> Alternate, -3 -> Key)");

// ── 6. the built patch carries the same code and every control
var mp = path.join(__dirname, "../m4l/Guiro.maxpat");
if (fs.existsSync(mp)) {
    var code = M.code(), got = require("./gen_shim.js").loadCode(mp);
    check(got.trim() === code.trim(), "m4l/Guiro.maxpat's gen~ codebox is exactly scripts/guiro_engine.py's code (rebuild with ./build.sh if not)");
}
console.log(passed + " passed" + (fails ? ", " + fails + " FAILED" : ""));
process.exit(fails ? 1 : 0);
