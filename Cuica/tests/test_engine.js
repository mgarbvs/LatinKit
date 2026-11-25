// node tests/test_engine.js — runs the generated gen~ code (m4l/Cuica.maxpat) in the Node shim, plus cuica_midi.js with a fake outlet.
var fs = require("fs");
var path = require("path");
var S = require("./gen_shim.js");
var SR = S.SR;
var CODE = S.loadCode(path.join(__dirname, "../m4l/Cuica.maxpat"));
var fails = 0;
function check(ok, what) { console.log((ok ? "ok   " : "FAIL ") + what); if (!ok) fails++; }
function db(x) { return 20 * Math.log10(x + 1e-12); }
function mtof(m) { return 440 * Math.pow(2, (m - 69) / 12); }
function cents(f, g) { return 1200 * Math.log2(f / g); }

var count = 0;
function engine(params) {
    var e = new S.Engine(CODE);
    Object.keys(params || {}).forEach(function (k) { e.set(k, params[k]); });
    return e;
}
function noteOn(e, note, vel, legato) {
    e.set("nt", note); e.set("vl", vel); e.set("lg", legato ? 1 : 0); e.set("hold", 1); e.set("tr", ++count);
}
function play(params, note, vel, sec) { var e = engine(params); noteOn(e, note, vel); return e.run(sec)[0]; }
function finite(x) { for (var i = 0; i < x.length; i++) if (!isFinite(x[i])) return false; return true; }
function peak(x) { var p = 0; for (var i = 0; i < x.length; i++) p = Math.max(p, Math.abs(x[i])); return p; }
function rmsW(x, t0, t1) { return S.rms(x, t0 * SR, t1 * SR); }
// pitch (Hz) in [t0, t1) s: autocorrelation peak within -7..+7 semitones of `near`, parabolic refinement
function pitch(x, near, t0, t1) {
    var a = Math.round(t0 * SR), n = Math.round((t1 - t0) * SR), lo = Math.floor(SR / near / 1.5), hi = Math.ceil(SR / near * 1.5);
    var c = [], best = -1e30, bl = lo;
    for (var lag = lo - 1; lag <= hi + 1; lag++) {
        var s = 0;
        for (var i = 0; i < n; i++) s += x[a + i] * x[a + i + lag];
        c[lag - lo + 1] = s;
    }
    for (lag = lo; lag <= hi; lag++) { var v = c[lag - lo + 1]; if (v > best && v >= c[lag - lo] && v >= c[lag - lo + 2]) { best = v; bl = lag; } }
    var p0 = c[bl - lo], p1 = c[bl - lo + 1], p2 = c[bl - lo + 2];
    return SR / (bl + 0.5 * (p0 - p2) / (p0 - 2 * p1 + p2));
}

// 1. in tune at the defaults (push stroke): the scoop rides the stroke and arrives at 60 % of it (0.105 s at Stroke 300), before
// the rub eases below a third (0.165 s) and the pitch sags
[60, 72, 84].forEach(function (n) {
    var x = play({}, n, 0.8, 0.3), ct = cents(pitch(x, mtof(n), 0.11, 0.15), mtof(n));
    check(Math.abs(ct) <= 10 && finite(x) && peak(x) < 1 && rmsW(x, 0.11, 0.15) > 0.01,
          "MIDI " + n + " defaults: " + ct.toFixed(1) + " ct, rms " + db(rmsW(x, 0.11, 0.15)).toFixed(1) + " dBFS");
});

// 2. self-oscillation starts within 40 ms at velocity 100
[48, 60, 72, 84, 96].forEach(function (n) {
    var x = play({}, n, 100 / 127, 0.25), steady = rmsW(x, 0.1, 0.14), t = 0;
    while (t < 0.2 && rmsW(x, t, t + 0.004) < 0.5 * steady) t += 0.001;
    check(steady > 0.01 && t <= 0.04, "MIDI " + n + ": sound at " + (t * 1000).toFixed(0) + " ms (need <= 40), steady " + db(steady).toFixed(1) + " dBFS");
});

// 3. extreme dials: finite and below full scale
(function () {
    var worst = 0, bad = 0, sets = [];
    [0, 1].forEach(function (a) {
        [0, 1].forEach(function (b) {
            sets.push({ press: a, speed: b, tone: a, head: b, rasp: 1 - a, stroke: a ? 40 : 800, pull: a ? 7 : -7, scoop: a ? 12 : -12,
                        glide: a ? 0 : 500, thumb: 24, decay: a ? 10 : 2000, vol: 6, tune: a ? 24 : -24 });
        });
    });
    sets.forEach(function (p) {
        [24, 60, 100].forEach(function (n) {
            var e = engine(p); noteOn(e, n, 1); e.set("mw", 1);
            var x = e.run(0.4)[0];
            if (!finite(x)) bad++;
            worst = Math.max(worst, peak(x));
        });
    });
    check(bad === 0 && worst < 1, "extreme dials: " + bad + " non-finite renders, worst peak " + worst.toFixed(3) + " (need < 1)");
})();

// 3b. the friction core never runs away (round 5's creak once ran the rod's phase backwards until reload): 60 short strokes at full
// Rasp and grip, then every dial at its minimum, all on ONE engine; the head's mode states stay bounded and a default note is in tune
(function () {
    var e = engine({ rasp: 1, press: 1, speed: 1, stroke: 40, tone: 1, head: 1, vol: 6 }), big = 0, ok = true;
    for (var i = 0; i < 60; i++) { noteOn(e, 30 + i, 1); for (var k = 0; k < 20; k++) { ok = ok && finite(e.run(0.005)[0]); big = Math.max(big, Math.abs(e.st.zv1), Math.abs(e.st.zv2), Math.abs(e.st.zv3)); } }
    var lo = { rasp: 0, press: 0, speed: 0, stroke: 800, tone: 0, head: 0, vol: -36 };
    Object.keys(lo).forEach(function (k) { e.set(k, lo[k]); });
    for (i = 0; i < 4; i++) { noteOn(e, 40 + 20 * i, 0.1); ok = ok && finite(e.run(0.3)[0]); }
    var dflt = { rasp: 0.25, press: 0.55, speed: 0.6, stroke: 300, tone: 0.6, head: 0.5, vol: -6 };
    Object.keys(dflt).forEach(function (k) { e.set(k, dflt[k]); });
    e.set("hold", 0); e.run(1); noteOn(e, 72, 0.8);
    var x = e.run(0.3)[0], ct = cents(pitch(x, mtof(72), 0.11, 0.15), mtof(72));
    check(ok && big < 4 && finite(x) && Math.abs(ct) < 10, "max then min dials on one engine: finite, mode velocities peak " + big.toFixed(2) +
          " (< 4, the guard), then a default note at " + ct.toFixed(1) + " ct");
})();

// 3c. grip lowers the pitch (Mestrinel 2009; Galante's "x"), bounded: in tune from Pressure 0 to the default, full grip a little flat
(function () {
    var c = [0, 0.55, 1].map(function (pr) { return cents(pitch(play({ press: pr, scoop: 0 }, 72, 0.8, 0.3), mtof(72), 0.06, 0.1), mtof(72)); });
    check(Math.abs(c[0] - c[1]) < 10 && c[2] - c[1] < -15 && c[2] - c[1] > -70,
          "Pressure 0 / 55 / 100 %: " + c.map(function (v) { return v.toFixed(0); }).join(" / ") + " ct (grip flattens, by 15..70 ct at full)");
})();

// 3d. a slow rub under a hard grip loses its periodic motion (raucous / period-2, as at the end of a bowed note: Inacio 2008); the
// same slow rub at the default grip stays periodic. MPE pressure holds the rub slow and steady after the stroke
(function () {
    function r1(press, prs) {
        var e = engine({ press: press, scoop: 0 }); noteOn(e, 72, 0.8); e.set("pr", prs);
        var x = e.run(1)[0], a = Math.round(0.5 * SR), n = Math.round(0.3 * SR), T = SR / mtof(72), b = -2;
        for (var l = Math.floor(T * 0.6); l < T * 1.3; l++) {
            var s = 0, e0 = 0, e1 = 0;
            for (var i = 0; i < n; i++) { s += x[a + i] * x[a + i + l]; e0 += x[a + i] * x[a + i]; e1 += x[a + i + l] * x[a + i + l]; }
            b = Math.max(b, s / Math.sqrt(e0 * e1 + 1e-30));
        }
        return b;
    }
    var hard = [0.06, 0.1].map(function (p) { return r1(1, p); }), soft = [0.06, 0.1].map(function (p) { return r1(0.55, p); });
    check(Math.min.apply(null, hard) < 0.9 && Math.min.apply(null, soft) > 0.95, "slow rub, periodicity at full grip " +
          hard.map(function (v) { return v.toFixed(2); }).join(", ") + " (need one < 0.9), at the default grip " + soft.map(function (v) { return v.toFixed(2); }).join(", ") + " (> 0.95)");
})();

// 4. Thumb: the wheel raises the pitch by Thumb semitones
[12, 5].forEach(function (th) {
    var e = engine({ scoop: 0, thumb: th, pull: 0 }); noteOn(e, 64, 0.8); e.set("mw", 1);
    var x = e.run(0.3)[0], ct = cents(pitch(x, mtof(64 + th), 0.1, 0.14), mtof(64 + th));   // mid-stroke, before the end sag
    check(Math.abs(ct) <= 15, "Thumb " + th + " st at wheel 127: " + ct.toFixed(1) + " ct from target");
});

// 5. Pull: with Alt on, notes alternate push and pull; the pull is Pull semitones higher. Alt off: every note is a push
(function () {
    var e = engine({ pull: 3, scoop: 0, glide: 20, alt: 0 }), f0 = mtof(67), p = [];
    for (var i = 0; i < 3; i++) { noteOn(e, 67, 0.8); p.push(cents(pitch(e.run(0.3)[0], f0, 0.08, 0.14), f0)); e.set("hold", 0); }
    check(p.every(function (c) { return Math.abs(c) < 15; }), "Alt off: three notes at " + p.map(function (c) { return c.toFixed(0); }).join(", ") + " ct (all pushes)");
})();
(function () {   // Auto: quick notes (150 ms apart, within one 300 ms Stroke) alternate; after a pause the next is a push again
    var e = engine({ pull: 3, scoop: 0, glide: 5, alt: 1 }), f0 = mtof(67), p = [];
    [0.15, 0.15, 0.15, 0.6, 0.15].forEach(function (gap) {
        noteOn(e, 67, 0.8); var x = e.run(gap)[0]; e.set("hold", 0);
        p.push(Math.round(cents(pitch(x, f0, 0.06, 0.1), f0) / 100));
    });
    check(p.join(",") === "0,3,0,3,0", "Alt Auto: 16ths then a pause: " + p.join(", ") + " st (need 0, 3, 0, 3, then 0 after the pause)");
})();
(function () {
    var e = engine({ pull: 3, scoop: 0, glide: 20, alt: 2 }), f0 = mtof(67);
    noteOn(e, 67, 0.8); var x = e.run(0.3)[0]; e.set("hold", 0);
    noteOn(e, 67, 0.8); var y = e.run(0.3)[0]; e.set("hold", 0);
    noteOn(e, 67, 0.8); var z = e.run(0.3)[0];
    var a = cents(pitch(x, f0, 0.08, 0.14), f0), b = cents(pitch(y, f0, 0.08, 0.14), f0), c = cents(pitch(z, f0, 0.08, 0.14), f0);
    check(Math.abs(a) < 15 && Math.abs(b - 300) < 15 && Math.abs(c) < 15,
          "Pull 3 st: push " + a.toFixed(0) + " ct, pull " + b.toFixed(0) + " ct, push " + c.toFixed(0) + " ct");
})();

// 6. Scoop: the note starts Scoop below and rides the stroke into its pitch (Glide does not apply)
(function () {
    var x = play({ scoop: -5, glide: 100, pull: 0 }, 72, 0.8, 0.3), f0 = mtof(72);
    var a = cents(pitch(x, f0, 0.02, 0.05), f0), b = cents(pitch(x, f0, 0.11, 0.15), f0);   // the scoop has arrived (0.105 s), the end sag not begun
    check(a < -150 && Math.abs(b) < 10, "Scoop -5 st, Glide 100 ms: " + a.toFixed(0) + " ct at the start, " + b.toFixed(1) + " ct after");
})();

// 7. note-off: silent (< -60 dB) within 3 x Decay
[150, 600, 2000].forEach(function (dec) {
    var e = engine({ decay: dec, vol: 6 }); noteOn(e, 72, 1);
    e.run(0.4); e.set("hold", 0);
    var x = e.run(Math.min(3 * dec / 1000 + 0.1, 6.5))[0], t3 = Math.round(3 * dec / 1000 * SR);
    var tail = peak(x.subarray(t3));
    check(tail < 0.001, "Decay " + dec + " ms: after 3 x Decay the tail peaks at " + db(tail).toFixed(1) + " dBFS (need < -60)");
});

// 8. legato: a second note while held is a new stroke that glides over from where the pitch is (no scoop)
(function () {
    var e = engine({ scoop: -5, glide: 60, pull: 0 }); noteOn(e, 60, 0.8);
    e.run(0.3); noteOn(e, 67, 0.8, true);
    var x = e.run(0.2)[0], ph = e.st.phs;
    // after the cloth's catch (the stroke's first 15 ms bite); a scooped start reads about -500 ct here, the glide from 60 about -220
    var a = cents(pitch(x, mtof(67), 0.015, 0.03), mtof(67)), b = cents(pitch(x, mtof(67), 0.08, 0.12), mtof(67));   // glide settled, before the sag
    check(Math.abs(b) < 10 && a < -100 && a > -400 && ph > 0.5 && rmsW(x, 0.08, 0.12) > 0.01,
          "legato 60 -> 67: starts " + a.toFixed(0) + " ct (glides from 60, not scooped from 62), arrives at " + b.toFixed(1) + " ct, new stroke (phase " + ph.toFixed(2) + ")");
})();

// 9. back-to-back notes (note-off and note-on in one block: only the counter shows): the second note speaks
(function () {
    var e = engine({ pull: 0, scoop: 0 }); noteOn(e, 60, 0.8);
    e.run(0.3); e.set("hold", 0); noteOn(e, 64, 0.8);   // hold goes 0 -> 1 between blocks, tr changed
    var x = e.run(0.15)[0];   // measured mid-stroke: at a stroke's end the head rings at its own resonance
    check(rmsW(x, 0.02, 0.06) > 0.01 && Math.abs(cents(pitch(x, mtof(64), 0.02, 0.06), mtof(64))) < 10, "back-to-back notes: the second one speaks and is in tune");
})();

// 10. cuica_midi.js with a fake outlet, fed raw MIDI bytes: last-note priority, legato flag, counter, wheel, bend, MPE
(function () {
    var out = [];
    var src = fs.readFileSync(path.join(__dirname, "../m4l/cuica_midi.js"), "utf8");
    var m = new Function("outlet", src + "; return { msg_int: msg_int, mpe: mpe, pbrange: pbrange };")(function () { out.push([].slice.call(arguments).slice(1)); });
    function send() { [].slice.call(arguments).forEach(m.msg_int); }
    function last(name) { for (var i = out.length - 1; i >= 0; i--) if (out[i][0] === name) return out[i][1]; return undefined; }
    send(0x90, 60, 100);
    var ok = last("nt") === 60 && last("lg") === 0 && last("hold") === 1, tr1 = last("tr");
    send(64, 90);                                     // running status
    ok = ok && last("nt") === 64 && last("lg") === 1 && last("tr") !== tr1;
    send(0x80, 64, 0);
    ok = ok && last("nt") === 60 && last("hold") === 1;
    send(0x90, 60, 0);
    ok = ok && last("hold") === 0;
    send(0xB0, 1, 127, 0xE0, 127, 127);
    ok = ok && last("mw") === 1 && last("bend") === 2;
    check(ok, "cuica_midi.js: last-note priority, legato flag, new counter per note-on, release, wheel, bend");
    out = [];
    send(0x93, 62, 100, 0xD3, 64, 0xB3, 74, 127, 0xE3, 0, 80, 0xD5, 10, 0xB5, 74, 0);   // MPE note on channel 4; channel 6 is ignored (channel 1, the global one, would count)
    ok = Math.abs(last("pr") - 64 / 127) < 1e-6 && last("sl") === 1 && Math.abs(last("pbn") - 48 * (80 * 128 - 8192) / 8191) < 1e-6;
    send(0x83, 62, 0);
    check(ok && last("pr") === 0 && last("hold") === 0, "cuica_midi.js MPE: pressure, slide and bend from the note's channel only; pressure clears on release");
    m.pbrange(12); out = [];
    send(0x93, 62, 100, 0xE3, 127, 127);
    ok = Math.abs(last("pbn") - 12) < 1e-6;
    m.mpe(0); ok = ok && last("pr") === 0 && last("sl") === 0 && last("pbn") === 0;
    out = []; send(0xD3, 100, 0xB3, 74, 100, 0xE3, 0, 0);
    check(ok && last("pr") === undefined && last("sl") === undefined && last("pbn") === undefined,
          "cuica_midi.js MPE page: Bend range 12 st; MPE off resets and then ignores pressure, slide and per-note bend");
})();

// 11. one stroke per note: a held note goes quiet once its stroke is done
(function () {
    var x = play({ rasp: 0 }, 72, 0.8, 1.0);
    check(rmsW(x, 0.05, 0.15) > 0.01 && rmsW(x, 0.6, 1.0) < 0.001,
          "held 1 s: stroke " + db(rmsW(x, 0.05, 0.15)).toFixed(1) + " dBFS, then " + db(rmsW(x, 0.6, 1.0)).toFixed(1) + " dBFS (need < -60)");
})();

// 12. MPE pressure rubs on while held, and stops when the note ends; slide is the thumb; per-note bend bends
(function () {
    var e = engine({ rasp: 0, scoop: 0, pull: 0 }); noteOn(e, 64, 0.8); e.set("pr", 0.7);
    var x = e.run(0.8)[0]; e.set("hold", 0);
    var y = e.run(0.6)[0];
    check(rmsW(x, 0.6, 0.8) > 0.01 && rmsW(y, 0.5, 0.6) < 0.001,
          "pressure 0.7: still rubbing at 0.7 s (" + db(rmsW(x, 0.6, 0.8)).toFixed(1) + " dBFS), quiet after release (" + db(rmsW(y, 0.5, 0.6)).toFixed(1) + ")");
    e = engine({ rasp: 0, scoop: 0, pull: 0, thumb: 12 }); noteOn(e, 64, 0.8); e.set("pr", 0.7); e.set("sl", 1); e.set("pbn", -2);
    x = e.run(0.5)[0];
    var ct = cents(pitch(x, mtof(74), 0.4, 0.45), mtof(74));
    check(Math.abs(ct) < 15, "slide 1 (Thumb 12) and per-note bend -2 st: " + ct.toFixed(1) + " ct from 64 + 12 - 2");
    e = engine({ rasp: 0, scoop: 0, pull: 0, pram: 0 }); noteOn(e, 64, 0.8); e.set("pr", 1);
    x = e.run(0.8)[0];
    check(rmsW(x, 0.6, 0.8) < 0.001, "MPE Pressure 0: pressure does not rub on (" + db(rmsW(x, 0.6, 0.8)).toFixed(1) + " dBFS at 0.7 s)");
    e = engine({ rasp: 0, scoop: 0, pull: 0, sld: 2 }); noteOn(e, 64, 0.8); e.set("pr", 0.7); e.set("sl", 1);
    x = e.run(0.5)[0];
    ct = cents(pitch(x, mtof(64), 0.4, 0.45), mtof(64));
    check(Math.abs(ct) < 15, "MPE Slide = Head: slide 1 leaves the pitch alone (" + ct.toFixed(1) + " ct from 64)");
    var g = [0, 1].map(function (sl) { var e2 = engine({ rasp: 0, scoop: 0, pull: 0, sld: 4 }); noteOn(e2, 64, 0.8); e2.set("sl", sl); return cents(pitch(e2.run(0.3)[0], mtof(64), 0.06, 0.1), mtof(64)); });
    check(g[1] - g[0] < -15, "MPE Slide = Grip: slide 1 grips harder and flattens (" + g[0].toFixed(0) + " -> " + g[1].toFixed(0) + " ct)");
})();

console.log(fails ? fails + " FAILED" : "all passed");
process.exit(fails ? 1 : 0);
