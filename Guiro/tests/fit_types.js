// fit_types.js [--write] — fits the Güiro Type's constants (scripts/guiro_engine.py TYPES.Guiro) to the Latin Percussion previews (tests/refs.js)
// with Nelder-Mead on the engine run in the Node shim (GUIRO_FIT=1: the Type constants become Params). Two stages, spectrum (high-pass and three
// resonances: pooled 1/3-octave levels over every stroke) then time (click length, ring: stroke length, tail, the Top tap's decay, grain
// fluctuation), then both together. The per-stroke constants (length, rate, curve, taper) are measured, not fitted. --write patches TYPES.
// Reco-reco has no reference: it is a hand-made variant (see the engine) and is not fitted.
process.env.GUIRO_FIT = "1";
var M = require("./guiro_measure.js"), R = require("./refs.js"), cp = require("child_process"), fs = require("fs"), path = require("path");
var PY = path.join(__dirname, "../scripts/guiro_engine.py");
var tab = JSON.parse(cp.execFileSync("python3", ["-c", "import sys,json;sys.path.insert(0,'" + path.dirname(PY) +
    "');import guiro_engine as E;print(json.dumps(E.flat('Guiro')))"], { encoding: "utf8" }));
var write = process.argv.indexOf("--write") >= 0;
var ref = R.measured();
var KINDS = ["Up", "Down", "Long", "Top"], NS = [4, 4, 4, 4], SEC = [0.5, 0.5, 0.9, 0.5];
var FIT_TAKES = ["A", "B"];   // takes A-D are different instruments (centroids 3-11 kHz): the fit targets A+B (a ~300 Hz body, separate ridges); the tests use the A-D range
var fitRef = {};
KINDS.forEach(function (k) { fitRef[k] = M.average(ref[k].files.filter(function (f) { return FIT_TAKES.indexOf(f.name[0]) >= 0; }).map(function (f) { return f.m; })); });
var allRef = M.average([].concat.apply([], KINDS.map(function (k) { return ref[k].files.filter(function (f) { return FIT_TAKES.indexOf(f.name[0]) >= 0; }).map(function (f) { return f.m; }); })));

// variable: [lo, hi, log?]
var V = {
    hp: [100, 11000, 1], hq: [0.4, 3, 1], f0: [400, 10000, 1], q0: [0.4, 30, 1], g0: [0, 4, 0], f1: [400, 10000, 1], q1: [0.4, 30, 1], g1: [0, 4, 0],
    f2: [150, 10000, 1], q2: [0.4, 30, 1], g2: [0, 4, 0], sdec: [0.1, 6, 1], rtau: [5, 200, 1], ringS: [0, 1, 0], ringT: [0, 4, 0], rtau2: [15, 150, 1], ringL: [0, 0.3, 0], kT: [1, 3, 1], bs: [0, 1.5, 0], bT: [0, 3, 0],
    bf0: [200, 450, 1], bt0: [15, 100, 1], bg0: [0, 3, 0], bf1: [500, 1200, 1], bt1: [10, 60, 1], bg1: [0, 3, 0], bf2: [1500, 3000, 1], bt2: [5, 40, 1], bg2: [0, 3, 0]
};
var SPEC = ["hp", "hq", "f0", "q0", "g0", "f1", "q1", "g1", "f2", "q2", "g2", "bf0", "bg0", "bf1", "bg1", "bf2", "bg2", "bs", "bT", "kT"], TIME = ["sdec", "rtau", "rtau2", "ringS", "ringT", "ringL", "bt0", "bt1", "bt2"];
function enc(k, v) { var d = V[k]; return d[2] ? Math.log(Math.max(v, 1e-3)) : v; }
function dec(k, x) { var d = V[k], v = d[2] ? Math.exp(x) : x; return Math.min(d[1], Math.max(d[0], v)); }
var FLOOR = -45;
function lr(a, b) { return Math.log(Math.max(1, a) / Math.max(1, b)); }

function cost(vals, which) {
    var p = { type: 0, vol: 0, pan: -1 }, c = 0, lists = [], m = {};
    Object.keys(vals).forEach(function (k) { p["c_" + k] = vals[k]; });
    KINDS.forEach(function (k, i) { m[k] = M.strokes(p, NS[i], 1, i, SEC[i]); lists = lists.concat(m[k].each); });
    var pool = M.average(lists), s = 0;
    for (var i = 0; i < pool.third.length; i++) { var d = Math.max(FLOOR, pool.third[i]) - Math.max(FLOOR, allRef.third[i]); s += d * d; }
    s /= pool.third.length;
    // each stroke's own spectrum too (the tap is much brighter than the scrapes): the pooled one counts half, the four strokes' own half
    var sk = 0;
    KINDS.forEach(function (k) { var a = m[k].third, b = fitRef[k].third, q = 0; for (var i = 0; i < a.length; i++) { var d = Math.max(FLOOR, a[i]) - Math.max(FLOOR, b[i]); q += d * d; } sk += q / a.length / 4; });
    s = 0.5 * s + 0.5 * sk;
    var st = 0;
    KINDS.forEach(function (k) {
        var t = fitRef[k], q = m[k];
        st += Math.pow(lr(q.len, t.len) / 0.3, 2);
        if (k === "Top") ["t10", "t20", "t30"].forEach(function (key) { st += Math.pow(lr(q[key], t[key]) / 0.3, 2); });
        else st += Math.pow(lr(q.tail, t.tail) / 0.4, 2);
        st += Math.pow((q.cvE - t.cvE) / 0.1, 2);
    });
    return { total: (which === "spec" ? s / 4 : which === "time" ? st : s / 4 + st), spec: Math.sqrt(s), time: st, m: m };
}

function nelder(f, x0, step, iters) {
    var n = x0.length, S = [x0.slice()], i, j;
    for (i = 0; i < n; i++) { var x = x0.slice(); x[i] += step[i]; S.push(x); }
    var F = S.map(f);
    for (var it = 0; it < iters; it++) {
        var idx = F.map(function (_, k) { return k; }).sort(function (a, b) { return F[a] - F[b]; });
        S = idx.map(function (k) { return S[k]; }); F = idx.map(function (k) { return F[k]; });
        var c = new Array(n).fill(0);
        for (i = 0; i < n; i++) for (j = 0; j < n; j++) c[j] += S[i][j] / n;
        function pt(a) { return c.map(function (v, k) { return v + a * (S[n][k] - v); }); }
        var xr = pt(-1), fr = f(xr);
        if (fr < F[0]) { var xe = pt(-2), fe = f(xe); if (fe < fr) { S[n] = xe; F[n] = fe; } else { S[n] = xr; F[n] = fr; } }
        else if (fr < F[n - 1]) { S[n] = xr; F[n] = fr; }
        else {
            var xc = fr < F[n] ? pt(-0.5) : pt(0.5), fc = f(xc);
            if (fc < Math.min(fr, F[n])) { S[n] = xc; F[n] = fc; }
            else for (i = 1; i <= n; i++) { S[i] = S[i].map(function (v, k) { return S[0][k] + 0.5 * (v - S[0][k]); }); F[i] = f(S[i]); }
        }
    }
    var b = 0; for (i = 1; i < F.length; i++) if (F[i] < F[b]) b = i;
    return { x: S[b], f: F[b] };
}

function stage(cur, keys, which, iters) {
    var res = nelder(function (x) {
        var v = Object.assign({}, cur);
        keys.forEach(function (k, i) { v[k] = dec(k, x[i]); });
        return cost(v, which).total;
    }, keys.map(function (k) { return enc(k, cur[k]); }), keys.map(function (k) { return V[k][2] ? 0.3 : 0.15; }), iters);
    keys.forEach(function (k, i) { cur[k] = dec(k, res.x[i]); });
    return res.f;
}

var cur = Object.assign({}, tab), t0 = Date.now();
delete cur.trm;
var c0 = cost(cur, "all");
console.log("start: spec " + c0.spec.toFixed(1) + " dB rms, time cost " + c0.time.toFixed(1));
for (var round = 0; round < 1; round++) {
    stage(cur, TIME, "time", 120);
    stage(cur, SPEC, "spec", 350);
}
stage(cur, TIME.concat(SPEC), "all", 300);
var c = cost(cur, "all");
console.log("Guiro: spec " + c.spec.toFixed(1) + " dB rms, time cost " + c.time.toFixed(1) + " (" + ((Date.now() - t0) / 1000).toFixed(0) + " s)");
console.log(JSON.stringify(cur, function (k, v) { return typeof v === "number" ? +v.toPrecision(4) : v; }));
if (write) {
    var s = fs.readFileSync(PY, "utf8"), r = function (x) { return +x.toPrecision(4); };
    var line = '    "Guiro": dict(trm=1.0, sdec=' + r(cur.sdec) + ", rtau=" + r(cur.rtau) + ", rtau2=" + r(cur.rtau2) + ", ringS=" + r(cur.ringS) + ", ringT=" + r(cur.ringT) + ", ringL=" + r(cur.ringL) + ", hp=" + r(cur.hp) + ", hq=" + r(cur.hq) + ", kT=" + r(cur.kT) +
        ", res=[" + [0, 1, 2].map(function (k) { return "(" + r(cur["f" + k]) + ", " + r(cur["q" + k]) + ", " + r(cur["g" + k]) + ")"; }).join(", ") +
        "],\n                  body=[" + [0, 1, 2].map(function (k) { return "(" + r(cur["bf" + k]) + ", " + r(cur["bt" + k]) + ", " + r(cur["bg" + k]) + ")"; }).join(", ") + "], bs=" + r(cur.bs) + ", bT=" + r(cur.bT) + "),";
    s = s.replace(/^    "Guiro": dict\([\s\S]*?bT=[\d.]+\),$/m, line);
    fs.writeFileSync(PY, s);
    console.log("TYPES.Guiro patched in " + PY);
}
