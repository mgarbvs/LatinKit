// test_voices.js — the 13 single-voice devices (m4l/CR78 <Name>.maxpat) against the full CR78 engine: for the same params and hits each device's
// output equals the full engine's mono sum (centre pan, Level at its default) sample for sample; the gen~ holds only its own voice; Volume;
// the note script (cr_voice_midi.js) and the display (cr_voice_view.js) run. Prints failures and a pass count; exit 1 on any failure.
var M = require("./cr_measure.js");
var shim = require("./gen_shim.js");
var fs = require("fs"), path = require("path"), cp = require("child_process");
var SR = M.SR, pass = 0, fails = [], verbose = !!process.env.CR_VERBOSE;
function check(cond, msg) { if (cond) pass++; else fails.push(msg); }

var DEV = JSON.parse(cp.execSync("python3 -c \"import sys,json;sys.path.insert(0,'" + __dirname + "/../scripts');import build_voices as V,cr_engine as E;" +
    "print(json.dumps([[d[0],d[1],d[2],d[4],[n for c in d[3] for n in c['names'] if n!='vol'],[[c['label'],c['names']] for c in d[3]]] for d in V.DEVICES]))\"", { encoding: "utf8" }));
var META = JSON.parse(cp.execSync("python3 -c \"import sys,json;sys.path.insert(0,'" + __dirname + "/../scripts');import cr_engine as E;" +
    "print(json.dumps({p[0]:[p[3],p[4],p[5]] for p in E.PARAMS}))\"", { encoding: "utf8" }));
var PREFIXES = ["bd", "rs", "sd", "hh", "cy", "ma", "mb", "tb", "cb", "hb", "lb", "lc", "gu", "cl"];
var SLOT = { 0: "bd", 1: "rs", 2: "sd", 3: "hh", 4: "mb", 5: "cy", 6: "tb", 7: "cb", 8: "hb", 9: "lb", 10: "lc", 11: "ma", 12: "gu", 13: "gu", 14: "cl" };
// the full engine pans at centre (x 0.7071) before its limiter, a device has no pan: only a hit above 1.13 differs, by the limiter's knee
function lim(x) { var a = Math.abs(x); return Math.sign(x) * (Math.min(a, 0.8) + 0.2 * Math.tanh(Math.max(a - 0.8, 0) * 5)); }
function lastDiff(a, b) { var d = 0; for (var i = 0; i < a.length; i++) d = Math.max(d, Math.abs(lim(a[i]) - b[i])); return d; }

DEV.forEach(function (d) {
    var name = d[0], voice = d[1], prefixes = d[2], slots = d[3], names = d[4];
    var code = shim.loadCode(path.join(__dirname, "../m4l/CR78 " + name + ".maxpat"));
    // 1. same sound as the full engine: defaults, then two spreads of every control, for each of the device's slots, hits of 100 and 127
    var variants = [{}, {}, {}];
    names.forEach(function (n) { var m = META[n]; variants[1][n] = m[0] + 0.3 * (m[1] - m[0]); variants[2][n] = m[0] + 0.85 * (m[1] - m[0]); });
    slots.forEach(function (s) {
        var gate = s === 12 || s === 13 ? "gt" + s : null;
        variants.forEach(function (p, vi) {
            var ev = [{ t: 0.01, hit: s, vel: 100 }, { t: 0.4, hit: s, vel: vi === 0 ? 60 : 110 }];
            if (gate) ev.push({ t: 0.01, set: { [gate]: 1 } }, { t: 0.25, set: { [gate]: 0 } }, { t: 0.4, set: { [gate]: 1 } }, { t: 0.5, set: { [gate]: 0 } });
            var full = M.render(p, ev, 0.9), dev = M.render(p, ev, 0.9, code);
            var diff = lastDiff(full.m, dev.l), pk = M.peakOf(full.m);
            if (verbose) console.log("  " + name + " slot " + s + " variant " + vi + ": peak " + pk.toFixed(4) + ", max diff " + diff.toExponential(2));
            check(pk > 0.01 && diff < 1e-9, name + " slot " + s + " variant " + vi + ": equals the full engine (peak " + pk.toFixed(4) + ", max diff " + diff.toExponential(2) + ")");
            check(dev.l.every(function (v, i) { return v === dev.r[i]; }), name + ": both outputs carry the same signal");
        });
    });
    // 2. the gen~ holds only this voice: its Params are its own, no other voice's output, no pan / master / layer, one noise()
    var params = (code.match(/^Param (\w+)/gm) || []).map(function (l) { return l.slice(6); });
    var own = names.concat(["vol"], slots.map(function (s) { return "tr" + s; }), slots.map(function (s) { return "vl" + s; }), slots[0] === 12 ? ["gt12", "gt13"] : []);
    check(params.slice().sort().join() === own.slice().sort().join(), name + ": Params are exactly its own (" + params.join(" ") + ")");
    var foreign = PREFIXES.filter(function (p) { return prefixes.indexOf(p) < 0 && new RegExp("\\b" + p + "_out\\b").test(code); });
    check(!foreign.length && !/\b(master|\w+Pan|\w+Lvl|mbHit|mbHats)\b/.test(code), name + ": no other voice, Pan, Level, Master or On Hats in the code" + (foreign.length ? " (" + foreign + ")" : ""));
    check((code.match(/noise\(\)/g) || []).length <= 1, name + ": at most one noise()");
    // 3. Volume: 0 dB = the table level; -6 dB halves it; the minimum is quiet and the maximum finite
    var s0 = slots[0], ev = [{ t: 0.01, hit: s0, vel: 100 }], gt = s0 === 12 ? [{ t: 0.01, set: { gt12: 1, gt13: 1 } }, { t: 0.15, set: { gt12: 0, gt13: 0 } }] : [];
    var a = M.peakOf(M.render({}, ev.concat(gt), 0.5, code).l), b = M.peakOf(M.render({ vol: -6.0206 }, ev.concat(gt), 0.5, code).l);
    check(Math.abs(b / a - 0.5) < 0.01, name + ": Volume -6 dB halves the level (x" + (b / a).toFixed(3) + ")");
    var hi = M.render({ vol: 6 }, ev.concat(gt), 0.5, code).l;
    check(M.peakOf(hi) <= 1.0001 && hi.every(isFinite), name + ": Volume +6 dB stays finite and within +-1");
    check(M.peakOf(M.render({}, [], 0.3, code).l) < 1e-9, name + ": silent when idle");
});

// 4. the note script: any note plays the slot; the bongo / guiro menu picks the slot; the guiro's gate follows the held notes
function midi(args) {
    var out = [];
    var f = new Function("outlet", "jsarguments", fs.readFileSync(path.join(__dirname, "../m4l/cr_voice_midi.js"), "utf8") + "; return {list: list, pick: pick};")(
        function () { out.push([].slice.call(arguments).join(" ")); }, ["cr_voice_midi.js"].concat(args));
    f.out = out;
    return f;
}
(function () {
    var m = midi([2]);
    m.list(48, 100); m.list(48, 0); m.list(91, 127);
    check(m.out.join("|") === "0 vl2 0.7874015748031497|0 tr2 1|1 hit 48 0.7874015748031497|0 vl2 1|0 tr2 2|1 hit 91 1", "any note plays the one slot (" + m.out.join("|") + ")");
    m = midi([8, 9]);
    m.list(60, 100); m.pick(1); m.list(60, 100); m.pick(7);
    check(m.out.filter(function (l) { return /^0 tr/.test(l); }).join() === "0 tr8 1,0 tr9 2", "the bongo menu picks high (slot 8) or low (slot 9)");
    check(!m.out.some(function (l) { return /gt/.test(l); }), "no gate outside the guiro");
    m = midi([12, 13]);
    m.list(60, 100); m.list(62, 100); m.list(60, 0);
    check(m.out.join().indexOf("0 gt12 0") < 0 && m.out.indexOf("0 gt12 1") === 0, "guiro: the gate opens on a note and stays open while another is held");
    m.list(62, 0);
    check(m.out.slice(-2).join() === "0 gt12 0,0 gt13 0", "guiro: the gate closes when the last note is up");
    m.pick(1); m.list(64, 100);
    check(m.out.indexOf("0 gt13 1") >= 0 && m.out.indexOf("0 tr13 3") >= 0, "guiro: Long plays slot 13");
})();

// 5. the display: every drawing paints (a stub mgraphics catches typos), both variants
(function () {
    var src = fs.readFileSync(path.join(__dirname, "../m4l/cr_voice_view.js"), "utf8");
    var calls = 0, mg = new Proxy({ text_measure: function () { return [20, 10]; } }, { get: function (t, k) { return k in t ? t[k] : function () { calls++; }; }, set: function () { return true; } });
    ["kick", "snare", "rim", "clave", "bongo", "conga", "hat", "cymbal", "maracas", "metal", "cowbell", "tamb", "guiro"].forEach(function (v) {
        var f = new Function("mgraphics", "jsarguments", "Task", "arrayfromargs", "box", "messagename",
            src + "; return {paint: paint, hit: hit, set: function (m, a) { messagename = m; anything.apply(null, a); }};")(
            mg, ["cr_voice_view.js", v], function () { this.repeat = this.cancel = function () {}; }, function (a) { return [].slice.call(a); }, { rect: [0, 0, 164, 48] });
        var n = calls;
        f.paint(); f.hit(60, 1); f.set("variant", [1]); f.paint();
        check(calls - n > 20, v + ": the drawing paints (" + (calls - n) + " calls)");
    });
})();

if (fails.length) console.log(fails.map(function (f) { return "FAIL " + f; }).join("\n"));
console.log(pass + " passed" + (fails.length ? ", " + fails.length + " FAILED" : ""));
process.exit(fails.length ? 1 : 0);
