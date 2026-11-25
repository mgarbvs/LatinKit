// fit_types.js [Type ...] [--write] — fits a Type's constants (scripts/ganza_engine.py TYPES) to its reference one-shots (tests/refs.js)
// with Nelder-Mead on the engine run in the Node shim (GANZA_FIT=1: the type constants become Params). Two stages, spectrum (the high-pass
// and three resonances: 1/3-octave levels) then time (rate, sp, sdec, sys, shk: rise, t20, t30, grain fluctuation), then both together.
// Prints the table; --write patches TYPES in the engine. Deterministic (the same noise every evaluation), a few minutes per type.
process.env.GANZA_FIT = "1";
var M = require("./ganza_measure.js"), R = require("./refs.js"), cp = require("child_process"), fs = require("fs"), path = require("path");
var PY = path.join(__dirname, "../scripts/ganza_engine.py"), NAMES = ["Ganza", "Chocalho"];
var tab = JSON.parse(cp.execFileSync("python3", ["-c", "import sys,json;sys.path.insert(0,'" + path.dirname(PY) +
    "');import ganza_engine as E;print(json.dumps({n:E.flat(None,n) for n in E.NAMES}))"], { encoding: "utf8" }));
var args = process.argv.slice(2), write = args.indexOf("--write") >= 0, names = args.filter(function (a) { return a[0] !== "-"; });
var ref = R.measured();
if (!names.length) names = Object.keys(tab);

// variable: [param, lo, hi, log?]
var V = {
    hp: [300, 11000, 1], hq: [0.4, 3, 1], f0: [400, 10000, 1], q0: [0.4, 3, 1], g0: [0, 4, 0], f1: [400, 10000, 1], q1: [0.4, 3, 1], g1: [0, 4, 0],
    f2: [150, 10000, 1], q2: [0.4, 3, 1], g2: [0, 4, 0], gs: [0, 0.4, 0], ss: [40, 500, 1], rate: [30, 40000, 1], sp: [0, 1, 0], sdec: [0.1, 6, 1], sys: [8, 400, 1], shk: [1, 25, 1]
};
var SPEC = ["hp", "hq", "f0", "q0", "g0", "f1", "q1", "g1", "f2", "q2", "g2"], TIME = ["rate", "sp", "sdec", "sys", "shk", "gs", "ss"], TIMET = ["rate", "sp", "sdec", "sys", "shk"];   // TIMET: truncated refs fix gs / ss
function enc(k, v) { var d = V[k]; return d[2] ? Math.log(v) : v; }
function dec(k, x) { var d = V[k], v = d[2] ? Math.exp(x) : x; return Math.min(d[1], Math.max(d[0], v)); }
var FLOOR = -45;

function cost(name, vals, which) {
    var tg = ref[name], p = { type: NAMES.indexOf(name), vol: 0, pan: -1 }, m, c = 0;
    Object.keys(vals).forEach(function (k) { if (V[k]) p["c_" + k] = vals[k]; });
    var long = !tg.trunc;
    m = M.strokes(p, 6, 1, 0, long ? 0.9 : 0.5);
    var s = 0;
    for (var i = 0; i < m.third.length; i++) {
        var d = Math.max(FLOOR, m.third[i]) - Math.max(FLOOR, tg.all.third[i]);
        s += d * d;
    }
    s /= m.third.length;
    var t = tg.stroke, st = 0;
    function lr(a, b) { return Math.log(Math.max(1, a) / Math.max(1, b)) / 0.2; }
    if (isFinite(m.t20) && isFinite(t.t20)) st += Math.pow(lr(m.t20, t.t20), 2);
    else st += isFinite(m.t20) === isFinite(t.t20) ? 0 : 25;
    if (!tg.trunc) {   // a truncated reference (the ganza loop's strokes carry their neighbours) has no t30 / t40 / t50
        if (isFinite(m.t30) && isFinite(t.t30)) st += Math.pow(lr(m.t30, t.t30), 2);
        if (isFinite(m.t40) && isFinite(t.t40)) st += Math.pow(lr(m.t40, t.t40), 2); else st += 25;
        if (isFinite(m.t50) && isFinite(t.t50)) st += Math.pow(lr(m.t50, t.t50), 2); else st += 25;
    }
    st += Math.pow((m.rise - t.rise) / Math.max(6, 0.25 * t.rise), 2);
    if (isFinite(m.cvE)) st += Math.pow((m.cvE - t.cvE) / 0.04, 2); else st += 25;
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

function stage(name, cur, keys, which, iters) {
    var res = nelder(function (x) {
        var v = Object.assign({}, cur);
        keys.forEach(function (k, i) { v[k] = dec(k, x[i]); });
        return cost(name, v, which).total;
    }, keys.map(function (k) { return enc(k, cur[k]); }), keys.map(function (k) { return V[k][2] ? 0.3 : 0.15; }), iters);
    keys.forEach(function (k, i) { cur[k] = dec(k, res.x[i]); });
    return res.f;
}

var out = {};
names.forEach(function (name) {
    var cur = Object.assign({}, tab[name]), t0 = Date.now();
    var c0 = cost(name, cur, "all");
    console.log("== " + name + ": start spec " + c0.spec.toFixed(1) + " dB rms, time cost " + c0.time.toFixed(1));
    for (var round = 0; round < 2; round++) {
        stage(name, cur, ref[name].trunc ? TIMET : TIME, "time", 220);
        stage(name, cur, SPEC, "spec", 500);
    }
    stage(name, cur, (ref[name].trunc ? TIMET : TIME).concat(SPEC), "all", 400);
    var c = cost(name, cur, "all");
    console.log(name + ": spec " + c.spec.toFixed(1) + " dB rms, time cost " + c.time.toFixed(1) + " (" + ((Date.now() - t0) / 1000).toFixed(0) + " s)");
    console.log(JSON.stringify(cur, function (k, v) { return typeof v === "number" ? +v.toPrecision(4) : v; }));
    out[name] = cur;
});
if (write) {
    var lock = PY + ".lock";   // parallel fits take turns patching the engine
    for (var tries = 0; ; tries++) { try { fs.mkdirSync(lock); break; } catch (e) { if (tries > 600) throw e; cp.execSync("sleep 0.2"); } }
    var s = fs.readFileSync(PY, "utf8");
    names.forEach(function (name) {
        var c = out[name], r = function (x) { return +x.toPrecision(4); };
        var d = JSON.parse(cp.execFileSync("python3", ["-c", "import sys,json;sys.path.insert(0,'" + path.dirname(PY) + "');import ganza_engine as E;print(json.dumps(E.TYPES['" + name + "']))"], { encoding: "utf8" }));
        var line = '    "' + name + '": dict(rate=' + r(c.rate) + ", sp=" + r(c.sp) + ", sdec=" + r(c.sdec) + ", sys=" + r(c.sys) + ", shk=" + r(c.shk) + ", gs=" + r(c.gs) + ", ss=" + r(c.ss) +
            ", hp=" + r(c.hp) + ", hq=" + r(c.hq) + ", res=[" + [0, 1, 2].map(function (k) { return "(" + r(c["f" + k]) + ", " + r(c["q" + k]) + ", " + r(c["g" + k]) + ")"; }).join(", ") + "], " +
            "clk=" + d.clk + ", cdec=" + d.cdec + ", rings=" + JSON.stringify(d.rings).replace(/\[/g, "(").replace(/\]/g, ")").replace(/^\(/, "[").replace(/\)$/, "]") + ", bk=" + d.bk + ", bks=" + d.bks + ", bkd=" + d.bkd + ", bkt=" + d.bkt + "),";
        s = s.replace(new RegExp('^    "' + name + '": dict\\([\\s\\S]*?\\),\\n(?=    "|\\})', "m"), function () { return line + "\n"; });
    });
    fs.writeFileSync(PY, s);
    fs.rmdirSync(lock);
    console.log("TYPES patched in " + PY);
}
