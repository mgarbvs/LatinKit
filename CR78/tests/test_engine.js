// test_engine.js — runs the generated gen~ code (m4l/CR78.maxpat) in Node and checks it against the service-notes table.
// Prints only failures and a pass count; exit 1 on any failure. Set CR_VERBOSE=1 to also print every measured number.
var M = require("./cr_measure.js");
var SR = M.SR;
var pass = 0, fails = [], verbose = !!process.env.CR_VERBOSE;

function check(cond, msg) {
    if (cond) pass++; else fails.push(msg);
}
function note(msg) { if (verbose) console.log("  " + msg); }
function cents(f, ref) { return 1200 * Math.log2(f / ref); }
function db(x) { return 20 * Math.log10(x); }
function sig(slot, params, sec) { // one hit at t = 10 ms, returns the mono signal from the hit on
    return M.render(params || {}, [{ t: 0.01, hit: M.SLOTS[slot] }], 0.01 + sec).m.subarray(Math.round(0.01 * SR));
}

// ── 1. frequency: ringing oscillators and LC tanks (zero crossings), within 5 cents of the table
var RING = { bd: [62.5, 0.12], rs: [1480, 0.006], cl: [2630, 0.022], hb: [600, 0.05], lb: [400, 0.05], lc: [208, 0.18] };
Object.keys(RING).forEach(function (v) {
    var r = M.zeroCrossFreq(sig(v, {}, 0.3), RING[v][1]);
    note(v + " " + r.f.toFixed(3) + " Hz (" + cents(r.f, RING[v][0]).toFixed(2) + " ct, " + r.n + " crossings)");
    check(Math.abs(cents(r.f, RING[v][0])) < 5, v + " frequency " + r.f.toFixed(2) + " Hz, want " + RING[v][0] + " (" + cents(r.f, RING[v][0]).toFixed(1) + " ct)");
});
// snare tone, cowbell tones, metallic beat lines (spectral peaks)
var sp = M.spectrum(sig("sd", {}, 0.2), 0, Math.round(0.1 * SR)).near(340, 0.1);
check(Math.abs(cents(sp.f, 340)) < 5, "snare tone " + sp.f.toFixed(2) + " Hz, want 340");
note("sd " + sp.f.toFixed(2));
var cbs = M.spectrum(sig("cb", {}, 0.3), 0, Math.round(0.2 * SR));
[800, 555].forEach(function (f) {
    var p = cbs.near(f, 0.06);
    note("cb " + p.f.toFixed(2));
    check(Math.abs(cents(p.f, f)) < 5, "cowbell tone " + p.f.toFixed(2) + " Hz, want " + f);
});
var mbs = M.spectrum(sig("mb", {}, 0.3), 0, Math.round(0.2 * SR));
var top3 = mbs.top(3, 3000, 8000, 100).sort();
[4080, 5620, 6170].forEach(function (f, i) {
    note("mb " + (top3[i] || 0).toFixed(2));
    check(top3[i] !== undefined && Math.abs(cents(top3[i], f)) < 5, "metallic beat line " + (top3[i] || 0).toFixed(1) + " Hz, want " + f);
});
var t4 = mbs.top(4, 3000, 8000, 100), magAt = function (f) { return mbs.mag[Math.round(f * (1 << 18) / SR)]; };
check(t4.length < 4 || magAt(t4[3]) < 0.1 * magAt(t4[0]), "metallic beat has exactly three strong lines in 3-8 kHz");

// ── 2. decay to 1/10 amplitude from the first peak, within +-15 %
// [slot, table ms, RMS window s, hits, gap s]
// noise voices: 16 hits, window ~1/30 of the decay (the narrow hat / Tb tanks make a slowly wandering envelope)
[["bd", 100, 0.016, 1, 0.5], ["sd", 60, 0.00294, 16, 0.4], ["rs", 5, 0.0007, 1, 0.3], ["hh", 60, 0.002, 16, 0.4], ["cy", 350, 0.01, 16, 1.4],
    ["ma", 20, 0.001, 16, 0.3], ["cl", 18, 0.0004, 1, 0.3], ["hb", 40, 0.0017, 1, 0.3], ["lb", 40, 0.0025, 1, 0.3], ["lc", 150, 0.0048, 1, 0.8],
    ["cb", 60, 0.004, 1, 0.5], ["tb", 220, 0.007, 16, 1.2], ["mb", 50, 0.0018, 1, 0.5]].forEach(function (d) {
    var t = M.decayTo10(d[0], {}, d[2], d[3], d[4]) * 1000;
    note(d[0] + " decay " + t.toFixed(1) + " ms (table " + d[1] + ")");
    check(Math.abs(t / d[1] - 1) < 0.15, d[0] + " decay to 1/10: " + t.toFixed(1) + " ms, want " + d[1] + " +-15 %");
});

// ── 3. guiro pulse rates (+-2 %), note length = stroke length, 1 s cap, minimum stroke
[["guH", 125, "gt12"], ["guL", 77, "gt13"]].forEach(function (g) {
    var ev = [{ t: 0.05, hit: M.SLOTS[g[0]], set: { [g[2]]: 1 } }, { t: 0.65, set: { [g[2]]: 0 } }];
    var x = M.render({}, ev, 1.0).m;
    var r = M.pulseRate(x, Math.round(0.06 * SR), Math.round(0.64 * SR));
    note(g[0] + " " + r.rate.toFixed(3) + " Hz, " + r.n + " pulses");
    check(Math.abs(r.rate / g[1] - 1) < 0.02, g[0] + " pulse rate " + r.rate.toFixed(2) + " Hz, want " + g[1]);
    var late = M.peakOf(x, Math.round(0.72 * SR), x.length);
    check(late < 1e-3, g[0] + " stops when the note ends (still " + late.toFixed(4) + " at 70 ms after)");
    var r2 = M.pulseRate(M.render({ guRate: 12 }, [{ t: 0.05, hit: M.SLOTS[g[0]], set: { [g[2]]: 1 } }, { t: 0.65, set: { [g[2]]: 0 } }], 1.0).m,
        Math.round(0.06 * SR), Math.round(0.64 * SR), 0.0015);
    check(Math.abs(r2.rate / (2 * g[1]) - 1) < 0.02, g[0] + " Rate +12 st doubles the pulse rate (" + r2.rate.toFixed(1) + " Hz)");
});
(function () {
    var x = M.render({}, [{ t: 0.05, hit: M.SLOTS.guH, set: { gt12: 1 } }], 2.5).m;
    var last = 0;
    for (var i = 0; i < x.length; i++) if (Math.abs(x[i]) > 0.02) last = i;
    check(last / SR < 1.12 && last / SR > 1.0, "a held guiro note stops after 1 s (last sound at " + (last / SR - 0.05).toFixed(3) + " s into the stroke)");
    var y = M.render({}, [{ t: 0.05, hit: M.SLOTS.guH }], 0.5).m;   // a note shorter than any block: still a stroke
    var n = M.pulseRate(y, Math.round(0.05 * SR), Math.round(0.4 * SR)).n;
    check(n >= 2, "a guiro hit with no gate still runs the minimum stroke (" + n + " pulses)");
})();

// ── 4. levels: peak at defaults against the table amplitude, within 2 dB (the ratios between voices follow)
var VPP = { bd: 0.4, sd: 0.4, rs: 0.8, hh: 0.4, cy: 0.4, ma: 0.4, cl: 0.15, hb: 0.15, lb: 0.15, lc: 0.3, cb: 0.2, tb: 0.25, guH: 0.3, guL: 0.3, mb: 0.35 };
Object.keys(VPP).forEach(function (v) {
    var noisy = ["sd", "hh", "cy", "ma", "tb", "guH", "guL"].indexOf(v) >= 0;
    var pk = M.peakLevel(v, {}, noisy ? 16 : 2, noisy ? 0.6 : 0.5, v.slice(0, 2) === "gu" ? 0.3 : 0);
    note(v + " peak " + pk.toFixed(4) + " (" + db(pk / VPP[v]).toFixed(2) + " dB vs " + VPP[v] + ")");
    check(Math.abs(db(pk / VPP[v])) < 2, v + " level " + pk.toFixed(3) + " is " + db(pk / VPP[v]).toFixed(1) + " dB from " + VPP[v] + " Vpp");
});

// ── 5. controls and behaviour
check((M.code().match(/noise\(\)/g) || []).length === 1, "exactly one noise() call: every noise voice shares the one source");
(function () {
    var x = M.render({}, [], 0.5).m;
    check(M.peakOf(x) < 1e-9, "silent when idle (" + M.peakOf(x) + ")");
    var f = M.zeroCrossFreq(sig("bd", { bdTune: 12 }, 0.2), 0.06).f;
    check(Math.abs(cents(f, 125)) < 5, "Tune +12 st doubles the bass drum: " + f.toFixed(2) + " Hz");
    var t = M.decayTo10("bd", { bdDec: 1 }, 0.016, 1, 0.8) * 1000;
    check(Math.abs(t / 200 - 1) < 0.15, "Decay +1 oct doubles the bass drum decay: " + t.toFixed(0) + " ms");
    var a = M.peakOf(sig("bd", {}, 0.1)), hi = M.peakOf(M.render({}, [{ t: 0.01, hit: 0, vel: 127 }], 0.1).m), lo = M.peakOf(M.render({}, [{ t: 0.01, hit: 0, vel: 50 }], 0.1).m);
    check(Math.abs(hi / a - 1.162) < 0.02 && Math.abs(lo / a - 0.7) < 0.02, "Accent 60 %: velocity 127 -> x" + (hi / a).toFixed(3) + " (1.162), 50 -> x" + (lo / a).toFixed(3) + " (0.700)");
    var a0 = M.peakOf(M.render({ accent: 0 }, [{ t: 0.01, hit: 0, vel: 30 }], 0.1).m);
    check(Math.abs(a0 / a - 1) < 0.01, "Accent 0: every velocity plays at the same level");
    var pn = M.render({ bdPan: -100 }, [{ t: 0.01, hit: 0 }], 0.2);
    check(M.peakOf(pn.r) < 1e-9 && Math.abs(M.peakOf(pn.l) - 0.4) < 0.005, "Pan -100 is left only, at full level (" + M.peakOf(pn.l).toFixed(3) + ")");
    check(M.peakOf(M.render({ master: 0 }, [{ t: 0.01, hit: 0 }], 0.2).m) === 0, "Master 0 is silent");
    var d = M.render({ drive: 100 }, [{ t: 0.01, hit: 0 }], 0.3).m, c = M.render({}, [{ t: 0.01, hit: 0 }], 0.3).m;
    var sp1 = M.spectrum(d, 0, Math.round(0.2 * SR)), sp0 = M.spectrum(c, 0, Math.round(0.2 * SR));
    check(sp1.near(187.5, 0.02).mag / sp1.near(62.5, 0.02).mag > 20 * sp0.near(187.5, 0.02).mag / sp0.near(62.5, 0.02).mag, "Drive 100 % adds odd harmonics to the bass drum");
    // tambourine shake: a second kick 70 ms later
    var rms = function (x, a, b) { var s = 0; for (var i = Math.round(a * SR); i < Math.round(b * SR); i++) s += x[i] * x[i]; return Math.sqrt(s / ((b - a) * SR)); };
    var tbHits = [0, 1, 2, 3, 4, 5, 6, 7].map(function (k) { return { t: 0.01 + k * 0.7, hit: 6 }; });
    var w0 = M.render({}, tbHits, 5.7).m, w1 = M.render({ tbShake: 1 }, tbHits, 5.7).m, r0 = 0, r1 = 0;
    for (var k = 0; k < 8; k++) {
        r0 += rms(w0, 0.1 + k * 0.7, 0.13 + k * 0.7);
        r1 += rms(w1, 0.1 + k * 0.7, 0.13 + k * 0.7);
    }
    check(r1 > 1.4 * r0, "Tambourine Shake re-kicks the envelope after 70 ms (" + (r1 / r0).toFixed(2) + "x)");
    // metallic beat on hats: hi-hat note gains the 4080 Hz line
    var h0 = M.spectrum(M.render({}, [{ t: 0.01, hit: 3 }], 0.3).m, 0, Math.round(0.2 * SR)).near(4080, 0.01).mag;
    var h1 = M.spectrum(M.render({ mbHats: 1 }, [{ t: 0.01, hit: 3 }], 0.3).m, 0, Math.round(0.2 * SR)).near(4080, 0.01).mag;
    check(h1 > 3 * h0, "Metallic Beat On Hats adds its lines to the hi-hat (" + (h1 / h0).toFixed(1) + "x at 4080 Hz)");
    // hat, cymbal and maracas sum (no choke): a maracas hit during the cymbal tail adds to it
    var cy = M.render({}, [{ t: 0.01, hit: 5 }], 0.5).m, both = M.render({}, [{ t: 0.01, hit: 5 }, { t: 0.1, hit: 11 }], 0.5).m;
    check(rms(both, 0.1, 0.12) > 1.1 * rms(cy, 0.1, 0.12), "maracas during the cymbal adds to it (no choke)");
    check(rms(both, 0.3, 0.5) > 0.9 * rms(cy, 0.3, 0.5), "the cymbal tail survives a later maracas hit");
})();

// ── 6. stability: every parameter at its extremes, every voice, finite and inside +-1
(function () {
    var meta = JSON.parse(require("child_process").execSync("python3 -c \"import sys,json;sys.path.insert(0,'" + __dirname + "/../scripts');import cr_engine as E;print(json.dumps([[p[0],p[3],p[4]] for p in E.PARAMS]))\"", { encoding: "utf8" }));
    [1, 2].forEach(function (which) {
        var params = {};
        meta.forEach(function (m) { params[m[0]] = m[which]; });
        params.drive = 100;
        var ev = [], gates = {};
        for (var s = 0; s < 15; s++) ev.push({ t: 0.01 + s * 0.05, hit: s, vel: 127 });
        ev.push({ t: 0.01, set: { gt12: 1, gt13: 1 } }, { t: 0.5, set: { gt12: 0, gt13: 0 } });
        var x = M.render(params, ev, 1.5);
        var ok = true;
        for (var i = 0; i < x.l.length; i++) if (!(Math.abs(x.l[i]) <= 1.0001 && Math.abs(x.r[i]) <= 1.0001)) { ok = false; break; }
        check(ok, "all parameters at " + (which === 1 ? "minimum" : "maximum") + ": finite and within +-1");
    });
})();

// ── 7. the generated Max js: note map, guiro gate, page view
(function () {
    var fs = require("fs"), path = require("path");
    var out = [], tasks = [];
    var mid = new Function("outlet", "Task", fs.readFileSync(path.join(__dirname, "../m4l/cr_midi.js"), "utf8") + "; return {list: list, trig: trig};")(
        function () { out.push([].slice.call(arguments).slice(1).join(" ")); },
        function (fn, obj, arg) { this.cancel = function () {}; this.schedule = function (ms) { tasks.push([ms, fn, arg]); }; });
    var NOTES = [36, 37, 38, 42, 44, 49, 54, 56, 60, 61, 64, 70, 73, 74, 75];
    NOTES.forEach(function (n, s) {
        out.length = 0;
        mid.list(n, 100);
        check(out.indexOf("tr" + s + " 1") >= 0 && out.indexOf("vl" + s + " " + (100 / 127)) >= 0, "note " + n + " fires slot " + s + " (" + out.join(", ") + ")");
    });
    out.length = 0; mid.list(61, 0); mid.list(41, 100);
    check(out.length === 0, "note-offs and unmapped notes do nothing");
    out.length = 0; mid.list(73, 90); mid.list(73, 0);
    check(out.indexOf("gt12 1") >= 0 && out.indexOf("gt12 0") >= 0 && out.indexOf("gt13 1") < 0, "guiro note-on opens its gate and note-off closes it");
    out.length = 0; mid.trig(13, 100);
    check(out.indexOf("gt13 1") >= 0 && tasks.length === 1 && tasks[0][0] === 300, "a guiro TRIG button holds the stroke for 0.3 s");
    var view = JSON.parse(fs.readFileSync(path.join(__dirname, "../m4l/cr_view.js"), "utf8").split("var VIEW = ")[1].split(";\n")[0]);
    var hidden = {}, patcher = { getnamed: function (n) { return { set hidden(v) { hidden[n] = v; } }; } };
    var anything = new Function("patcher", "var messagename;" + fs.readFileSync(path.join(__dirname, "../m4l/cr_view.js"), "utf8") + "; return function (m, v) { messagename = m; anything.call({patcher: patcher}, v); };")(patcher);
    anything("pg", 2);
    check(hidden.bdTune === true && hidden.hhDec === false && hidden.mbHats === false, "page 2 shows the noise voices and hides the drums");
    anything("pg", 0);
    check(hidden.bdTune === false && hidden.hhDec === true, "page 0 shows the drums again");
    check(Object.keys(view).length > 60, "the view map covers the voice controls (" + Object.keys(view).length + ")");
})();

if (fails.length) { console.log(fails.map(function (f) { return "FAIL " + f; }).join("\n")); }
console.log(pass + " passed" + (fails.length ? ", " + fails.length + " FAILED" : ""));
process.exit(fails.length ? 1 : 0);
