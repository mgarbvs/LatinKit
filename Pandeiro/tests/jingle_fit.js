// jingle_fit.js [--write] -- fits the jingle layer's constants (scripts/pandeiro_jingle.json: the PhISEM engine of Shaker, one set for the platinelas) to the Latin Percussion
// "Pandeiro A Shake" and "Pandeiro A Roll" previews with Nelder-Mead on the jingle-only code in the Node shim (pandeiro_engine.py --jingle-fit-code: the same statements as
// the full engine, the constants Params). Two stages as Shaker/tests/fit_types.js: spectrum (the high-pass and three resonances: 1/3-octave levels 4-16 kHz of the Shake and the
// Roll pooled; below 4 kHz the recordings are head and room, which this layer does not model) then time (rate, sp, sdec, sys, shk: the Shake's rise, t20, t30 and grain
// fluctuation), then both. The jingle tambourine clips (Tmbourin Hit / Shake, out of scope) are measured the same way for a cross-check. Deterministic, a few minutes.
var M = require("./jingle_measure.js"), cp = require("child_process"), fs = require("fs"), os = require("os"), path = require("path");
var ROOT = path.join(__dirname, "..");
var DIR = path.join(os.tmpdir(), "pandeiro_ref");
fs.mkdirSync(DIR, { recursive: true });
function ref(name) {
    var out = path.join(DIR, name + ".wav");
    cp.execFileSync("ffmpeg", ["-loglevel", "error", "-y", "-i", path.join(ROOT, "ref_wav", name + ".wav"), "-ac", "1", "-ar", "48000", "-c:a", "pcm_s16le", out]);
    var x = M.readWav(out), pk = 0, i;
    for (i = 0; i < x.length; i++) pk = Math.max(pk, Math.abs(x[i]));
    for (i = 0; i < x.length; i++) x[i] /= pk;
    return x;
}
var jPath = path.join(ROOT, "scripts/pandeiro_jingle.json");
var cur0 = JSON.parse(cp.execFileSync("python3", ["-c", "import sys,json;sys.path.insert(0,'" + path.join(ROOT, "scripts") + "');import pandeiro_engine as E;print(json.dumps(E.load_jingle()))"], { encoding: "utf8" }));
// Tried and dropped: starting the three resonances at the ringing bands tests/jingle_probe.py finds (7.1, 11.2, 14.4 kHz) and holding them within +-12 %: spectrum 1.1 dB rms (free: 0.2),
// the third resonance at its bounds (Q 30, gain 4: a tone). The recordings' jingle band is a broad hump (flat noise grains), not three lines.
var K0 = 9, K1 = 15;      // 1/3-octave indices of M.THIRDS: 4 kHz .. the one below 16 kHz (the previews are low-passed at 16-17 kHz: not the instrument)
var shake = M.measure(ref("lp_Pandeiro_A_Shake")), roll = M.measure(ref("lp_Pandeiro_A_Roll")), pooled = M.average([shake, roll]);
function levels(th) {    // 1/3-octave power K0..K1-1 normalised to sum 1 -> dB
    var s = 0, i, v = [];
    for (i = K0; i < K1; i++) s += th[i];
    for (i = K0; i < K1; i++) v.push(10 * Math.log10(th[i] / s + 1e-12));
    return v;
}
var tgt = levels(pooled.spec.th), FLOOR = -35;
var V = {   // [lo, hi, log?]
    hp: [2500, 11000, 1], hq: [0.4, 3, 1], f0: [4000, 15000, 1], q0: [0.5, 30, 1], g0: [0, 4, 0], f1: [4000, 15000, 1], q1: [0.5, 30, 1], g1: [0, 4, 0],
    f2: [4000, 15000, 1], q2: [0.5, 30, 1], g2: [0, 4, 0], rate: [100, 40000, 1], sp: [0, 1, 0], sdec: [0.1, 8, 1], sys: [8, 400, 1], shk: [1, 60, 1]
};
var SPEC = ["hp", "hq", "f0", "q0", "g0", "f1", "q1", "g1", "f2", "q2", "g2"], TIME = ["rate", "sp", "sdec", "sys", "shk"];
function enc(k, v) { return V[k][2] ? Math.log(v) : v; }
function dec(k, x) { var d = V[k], v = d[2] ? Math.exp(x) : x; return Math.min(d[1], Math.max(d[0], v)); }
function cost(vals, which) {
    var p = {}, m, s = 0, i;
    Object.keys(vals).forEach(function (k) { p["c_" + k] = vals[k]; });
    m = M.strokes(p, 5, 1, 0, 0.6);
    var ml = levels(m.spec.th);
    for (i = 0; i < ml.length; i++) { var d = Math.max(FLOOR, ml[i]) - Math.max(FLOOR, tgt[i]); s += d * d; }
    s /= ml.length;
    var t = shake, st = 0;
    function lr(a, b) { return Math.log(Math.max(1, a) / Math.max(1, b)) / 0.2; }
    st += isFinite(m.t20) ? Math.pow(lr(m.t20, t.t20), 2) : 25;
    st += isFinite(m.t30) ? Math.pow(lr(m.t30, t.t30), 2) : 25;
    st += Math.pow((m.rise - t.rise) / Math.max(4, 0.25 * t.rise), 2);
    st += isFinite(m.cvE) ? Math.pow((m.cvE - t.cvE) / 0.04, 2) : 25;
    if (isFinite(m.cvL) && isFinite(t.cvL)) st += Math.pow((m.cvL - t.cvL) / 0.06, 2);
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
        var pt = function (a) { return c.map(function (v, k) { return v + a * (S[n][k] - v); }); };
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
var cur = Object.assign({}, cur0), t0 = Date.now(), c0 = cost(cur, "all");
console.log("start: spec " + c0.spec.toFixed(1) + " dB rms (4-16 kHz thirds), time cost " + c0.time.toFixed(1) + "  (targets: shake rise " + shake.rise.toFixed(1) + " t20 " + shake.t20.toFixed(0) +
    " t30 " + shake.t30.toFixed(0) + " ms, cvE " + shake.cvE.toFixed(2) + " cvL " + shake.cvL.toFixed(2) + ")");
for (var round = 0; round < 2; round++) { stage(cur, TIME, "time", 160); stage(cur, SPEC, "spec", 400); }
stage(cur, TIME.concat(SPEC), "all", 300);
var c = cost(cur, "all"), m = c.m;
console.log("fit: spec " + c.spec.toFixed(1) + " dB rms, time cost " + c.time.toFixed(1) + " (" + ((Date.now() - t0) / 1000).toFixed(0) + " s): rise " + m.rise.toFixed(1) + " t20 " + m.t20.toFixed(0) +
    " t30 " + m.t30.toFixed(0) + " cvE " + m.cvE.toFixed(2) + " cvL " + m.cvL.toFixed(2));
var out = {};
Object.keys(cur).forEach(function (k) { out[k] = +cur[k].toPrecision(4); });
console.log(JSON.stringify(out));
console.log("1/3-octave levels 4-16 kHz (dB, sum 1): ref " + tgt.map(function (v) { return v.toFixed(0); }).join(" ") + " | ours " + levels(m.spec.th).map(function (v) { return v.toFixed(0); }).join(" "));
if (process.argv.indexOf("--write") >= 0) { fs.writeFileSync(jPath, JSON.stringify(out, null, 1)); console.log("wrote " + jPath); }
