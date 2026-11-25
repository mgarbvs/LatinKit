// fit_reco.js [--write] — fits the Reco-reco Type (scripts/guiro_engine.py TYPES.Recoreco) to the Freesound reco-reco texture (ref_wav/RR_*.wav, tests/reco_refs.sh; CC0).
// Same machinery as fit_types.js (Nelder-Mead on the engine in the Node shim, GUIRO_FIT=1 makes the Type constants Params), different targets, because the reference is
// 15 s of continuous playing, not labelled strokes:
//   spectrum  the pooled 1/3-octave levels of the first 100 ms of every 55-200 ms clip (a stroke reversal to the next: the Up / Down pool) against ours, Up + Down + Long pooled
//   ring      the ring-outs after a run (clips 69 and 125, 600 ms): ours is the Top tap. t10 / t20 / t30 of the 10 ms envelope above 1 kHz, and the late tilt: the 1.2-3.8 kHz
//             (the spring lines) and 6-16 kHz levels 150-250 ms after the peak, re the first 30 ms
// The per-stroke constants (length, rate factor, taper) and the impact rate (trm) are not fitted: the texture's impacts are fused into noise (see docs/RESEARCH.md).
process.env.GUIRO_FIT = "1";
var M = require("./guiro_measure.js"), cp = require("child_process"), fs = require("fs"), path = require("path");
var PY = path.join(__dirname, "../scripts/guiro_engine.py"), SR = M.SR;
var write = process.argv.indexOf("--write") >= 0;
var tab = JSON.parse(cp.execFileSync("python3", ["-c", "import sys,json;sys.path.insert(0,'" + path.dirname(PY) + "');import guiro_engine as E;print(json.dumps(E.flat('Recoreco')))"], { encoding: "utf8" }));
var dir = path.join(__dirname, "../ref_wav");
var clips = fs.readdirSync(dir).filter(function (f) { return /^RR_\d+_\d+\.wav$/.test(f); }).map(function (f) { return { name: f, ms: +f.match(/_(\d+)\.wav/)[1], x: M.readWav(path.join(dir, f)) }; });
function peak(x) { var m = 0; for (var i = 0; i < x.length; i++) m = Math.max(m, Math.abs(x[i])); return m; }
var shorts = clips.filter(function (c) { return c.ms >= 55 && c.ms <= 200 && peak(c.x) >= 0.12; });
var refSpec = M.average(shorts.map(function (c) { return M.measure(c.x); }));
// ring metrics of a mono signal: envelope times and the late tilt
function bandDb(x, a, n, lo, hi) {
    var N = 2048, re = new Float64Array(N), im = new Float64Array(N), i;
    for (i = 0; i < N && i < n && a + i < x.length; i++) re[i] = x[a + i] * (0.5 - 0.5 * Math.cos(2 * Math.PI * i / (Math.min(n, N) - 1)));
    M.fft(re, im);
    var s = 0; for (i = 1; i < N / 2; i++) { var f = i * SR / N; if (f >= lo && f < hi) s += re[i] * re[i] + im[i] * im[i]; }
    return 10 * Math.log10(s + 1e-20);
}
function ring(x) {
    var m = M.measure(x), pk = 0, pi = 0, e = M.movRms(x, Math.round(0.010 * SR));
    for (var i = 0; i < x.length; i++) if (e[i] > pk) { pk = e[i]; pi = i; }
    var a0 = pi, a1 = pi + Math.round(0.15 * SR), W = Math.round(0.03 * SR), W2 = Math.round(0.1 * SR);
    return { t10: m.t10, t20: m.t20, t30: m.t30,
        low: bandDb(x, a1, W2, 1200, 3800) - bandDb(x, a0, W, 1200, 3800), high: bandDb(x, a1, W2, 6000, 16000) - bandDb(x, a0, W, 6000, 16000) };
}
// line prominence: mean over 8192-point frames (hop 4096, above 0.5 % of the peak) of the power spectrum, dB over its 61-bin running mean; the mean of the 3 highest peaks (500-8000 Hz)
function prom(x) {
    var N = 8192, acc = new Float64Array(N / 2 + 1), n = 0, mx = peak(x), a, i;
    for (a = 0; a + N <= x.length; a += N / 2) {
        var re = new Float64Array(N), im = new Float64Array(N), e = 0;
        for (i = 0; i < N; i++) { re[i] = x[a + i] * (0.5 - 0.5 * Math.cos(2 * Math.PI * i / (N - 1))); e += x[a + i] * x[a + i]; }
        if (Math.sqrt(e / N) < 0.005 * mx) continue;
        M.fft(re, im); for (i = 0; i <= N / 2; i++) acc[i] += re[i] * re[i] + im[i] * im[i]; n++;
    }
    if (!n) return 0;
    var pp = Array.prototype.map.call(acc, function (v) { return 10 * Math.log10(v / n + 1e-20); }), fl = [], k, pk = [];
    for (i = 0; i < pp.length; i++) { var s = 0, c = 0; for (k = Math.max(0, i - 30); k <= Math.min(pp.length - 1, i + 30); k++) { s += pp[k]; c++; } fl.push(s / c); }
    for (i = 5; i < pp.length - 5; i++) {
        var f = i * SR / N, ismax = true; for (k = i - 4; k <= i + 4; k++) if (pp[k] > pp[i]) ismax = false;
        if (ismax && f > 500 && f < 8000) pk.push(pp[i] - fl[i]);
    }
    pk.sort(function (u, v) { return v - u; });
    return (pk[0] + pk[1] + pk[2]) / 3;
}
var rings = clips.filter(function (c) { return c.ms === 600; }).map(function (c) { return ring(c.x); });
var refRing = {}; ["t10", "t20", "t30", "low", "high"].forEach(function (k) { refRing[k] = rings.reduce(function (s, r) { return s + r[k]; }, 0) / rings.length; });
var texX = M.readWav(path.join(dir, "reco_texture.wav")), refProm = prom(texX);
if (write) fs.writeFileSync(path.join(__dirname, "refs_reco.json"), JSON.stringify({ shortClips: shorts.length, third: refSpec.third.map(function (v) { return +v.toFixed(1); }), cent: +refSpec.cent.toFixed(0),
    bands: refSpec.bands.map(function (v) { return +v.toFixed(1); }), ring: refRing, prom: +refProm.toFixed(1), ringClips: rings.length }, null, 1));
console.log("line prominence of the recording (top 3): " + refProm.toFixed(1) + " dB\nrefs: " + shorts.length + " short clips; ring-outs " + rings.length + ": " + JSON.stringify(refRing, function (k, v) { return typeof v === "number" ? +v.toFixed(1) : v; }));

var V = {
    hp: [300, 8000, 1], hq: [0.4, 3, 1], f0: [3000, 14000, 1], q0: [0.4, 30, 1], g0: [0, 4, 0], f1: [3000, 14000, 1], q1: [0.4, 30, 1], g1: [0, 4, 0],
    f2: [1000, 7000, 1], q2: [0.4, 30, 1], g2: [0, 4, 0], sdec: [0.1, 6, 1], rtau: [5, 200, 1], ringS: [0, 1, 0], ringT: [0, 4, 0], rtau2: [15, 400, 1], ringL: [0, 0.3, 0], kT: [0.7, 2, 1], bs: [0, 3, 0], bT: [0, 3, 0],
    bf0: [1300, 1700, 1], bt0: [20, 400, 1], bg0: [0, 3, 0], bf1: [2200, 2700, 1], bt1: [20, 400, 1], bg1: [0, 3, 0], bf2: [3200, 3800, 1], bt2: [20, 400, 1], bg2: [0, 3, 0]
};
var SPEC = ["hp", "hq", "f0", "q0", "g0", "f1", "q1", "g1", "f2", "q2", "g2", "bf0", "bg0", "bf1", "bg1", "bf2", "bg2", "bs", "bT", "kT"], TIME = ["sdec", "rtau", "rtau2", "ringS", "ringT", "ringL", "bt0", "bt1", "bt2"];
function enc(k, v) { var d = V[k]; return d[2] ? Math.log(Math.max(v, 1e-3)) : v; }
function dec(k, x) { var d = V[k], v = d[2] ? Math.exp(x) : x; return Math.min(d[1], Math.max(d[0], v)); }
var FLOOR = -45, NS = 3;
function lr(a, b) { return Math.log(Math.max(1, a) / Math.max(1, b)); }
function topRing(p, seed) {
    var e = M.engine(p); for (var j = 0; j < seed * 7919 + 13; j++) e.st.noise();
    e.st.vl = 1; e.st.stk = 3; e.st.tr = 1; var n = Math.round(0.6 * SR), x = new Float64Array(n);
    for (var i = 0; i < n; i++) { e.tick(); x[i] = e.st.out1; }
    return ring(x);
}
function cost(vals, which) {
    var p = { type: 0, vol: 0, pan: -1 }, lists = [];
    Object.keys(vals).forEach(function (k) { p["c_" + k] = vals[k]; });
    var s = 0, st = 0, r;
    if (which !== "time") {
        [0, 1, 2].forEach(function (i) { lists = lists.concat(M.strokes(p, NS, 1, i, i === 2 ? 0.9 : 0.5).each); });
        var pool = M.average(lists);
        for (var i = 0; i < pool.third.length; i++) { var d = Math.max(FLOOR, pool.third[i]) - Math.max(FLOOR, refSpec.third[i]); s += d * d; }
        s /= pool.third.length;
    }
    if (which !== "spec") {
        var rs = []; for (var q = 0; q < NS; q++) rs.push(topRing(p, q));
        r = {}; ["t10", "t20", "t30", "low", "high"].forEach(function (k) { r[k] = rs.reduce(function (a, b) { return a + b[k]; }, 0) / rs.length; });
        ["t10", "t20", "t30"].forEach(function (k) { st += Math.pow(lr(r[k], refRing[k]) / 0.3, 2); });
        st += Math.pow((r.low - refRing.low) / 4, 2) + Math.pow((r.high - refRing.high) / 4, 2);
        var le = M.engine(p); le.st.vl = 1; le.st.stk = 2; le.st.tr = 1; var lx = new Float64Array(Math.round(0.9 * SR));
        for (var li = 0; li < lx.length; li++) { le.tick(); lx[li] = le.st.out1; }
        r.prom = prom(lx); st += Math.pow(Math.max(0, refProm - r.prom) / 3, 2);
    }
    return { total: which === "spec" ? s / 4 : which === "time" ? st : s / 4 + st, spec: Math.sqrt(s), time: st, ring: r };
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
    var res = nelder(function (x) { var v = Object.assign({}, cur); keys.forEach(function (k, i) { v[k] = dec(k, x[i]); }); return cost(v, which).total; },
        keys.map(function (k) { return enc(k, cur[k]); }), keys.map(function (k) { return V[k][2] ? 0.3 : 0.15; }), iters);
    keys.forEach(function (k, i) { cur[k] = dec(k, res.x[i]); });
    return res.f;
}
var cur = Object.assign({}, tab), t0 = Date.now(), trm = cur.trm;
var c0 = cost(cur, "all");
console.log("start: spec " + c0.spec.toFixed(1) + " dB rms, time cost " + c0.time.toFixed(1) + " ring " + JSON.stringify(c0.ring, function (k, v) { return typeof v === "number" ? +v.toFixed(1) : v; }));
var IT = +(process.env.FIT_IT || 1);
stage(cur, TIME, "time", 100 * IT);
stage(cur, SPEC, "spec", 300 * IT);
stage(cur, TIME.concat(SPEC), "all", 250 * IT);
var c = cost(cur, "all");
console.log("Recoreco: spec " + c.spec.toFixed(1) + " dB rms, time cost " + c.time.toFixed(1) + " ring " + JSON.stringify(c.ring, function (k, v) { return typeof v === "number" ? +v.toFixed(1) : v; }) + " (" + ((Date.now() - t0) / 1000).toFixed(0) + " s)");
console.log(JSON.stringify(cur, function (k, v) { return typeof v === "number" ? +v.toPrecision(4) : v; }));
if (write) {
    var s = fs.readFileSync(PY, "utf8"), r = function (x) { return +x.toPrecision(4); };
    var line = '    "Recoreco": dict(trm=' + trm + ", sdec=" + r(cur.sdec) + ", rtau=" + r(cur.rtau) + ", rtau2=" + r(cur.rtau2) + ", ringS=" + r(cur.ringS) + ", ringT=" + r(cur.ringT) + ", ringL=" + r(cur.ringL) + ", hp=" + r(cur.hp) + ", hq=" + r(cur.hq) + ", kT=" + r(cur.kT) +
        ", res=[" + [0, 1, 2].map(function (k) { return "(" + r(cur["f" + k]) + ", " + r(cur["q" + k]) + ", " + r(cur["g" + k]) + ")"; }).join(", ") +
        "],\n                     body=[" + [0, 1, 2].map(function (k) { return "(" + r(cur["bf" + k]) + ", " + r(cur["bt" + k]) + ", " + r(cur["bg" + k]) + ")"; }).join(", ") + "], bs=" + r(cur.bs) + ", bT=" + r(cur.bT) + "),";
    var n0 = s.length; s = s.replace(/^    "Recoreco": dict\([\s\S]*?bT=[\d.]+\),$/m, line);
    if (s.length === n0 && s.indexOf(line) < 0) throw new Error("TYPES.Recoreco regex did not match");
    fs.writeFileSync(PY, s);
    console.log("TYPES.Recoreco patched in " + PY);
}
