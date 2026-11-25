// gen_shim.js — runs the generated gen~ codebox in Node (from WavetableBench, plus Delay and two inputs):
// Param/History/Data/Buffer/Delay become slots in a state object, GenExpr functions become JS
// functions, and the body runs inside `with (st)`. Buffers are Float64Arrays the test fills.
var assert = require("assert");
var fs = require("fs");

var SR = 48000;

function loadCode(maxpatPath) {
    var maxpat = JSON.parse(fs.readFileSync(maxpatPath, "utf8"));
    return maxpat.patcher.boxes.filter(function (b) { return /^gen~/.test(b.box.text || ""); })[0]
        .box.patcher.boxes.filter(function (b) { return b.box.maxclass === "codebox"; })[0].box.code;
}

function Delay(n) { // gen~ Delay: read(t) before write(x) returns x from t samples ago (linear interp)
    this.b = new Float64Array(n);
    this.w = 0;
}
Delay.prototype.write = function (x) { this.b[this.w] = x; this.w = (this.w + 1) % this.b.length; };
Delay.prototype.read = function (t) {
    var n = this.b.length, i = Math.floor(t), fr = t - i;
    var a = this.b[((this.w - i) % n + n) % n], b = this.b[((this.w - i - 1) % n + n) % n];
    return a + (b - a) * fr;
};

function Engine(code) {
    var seed = 1; // seeded noise: every run renders the same, so tests never flake
    var st = this.st = {
        samplerate: SR, twopi: 2 * Math.PI, pi: Math.PI, out1: 0, out2: 0, out3: 0, in1: 0, in2: 0,
        fixdenorm: function (x) { return x; },
        mtof: function (m) { return 440 * Math.pow(2, (m - 69) / 12); },
        clamp: function (x, a, b) { return Math.min(b, Math.max(a, x)); },
        wrap: function (x, a, b) { var r = b - a; return x - r * Math.floor((x - a) / r); },
        fract: function (x) { return x - Math.floor(x); },
        noise: function () {   // mulberry32: well mixed (a Lehmer 16807 generator's lattice made high-passed noise peak 2x Max's)
            seed = (seed + 0x6D2B79F5) | 0; var t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
            t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t; return ((t ^ (t >>> 14)) >>> 0) / 2147483647.5 - 1; },
        dbtoa: function (d) { return Math.pow(10, d / 20); },
        exp2: function (x) { return Math.pow(2, x); },
        peek: function (buf, idx, ch, interp) { // boundmode ignore: 0 outside the buffer
            if (interp === "linear") {
                var i0 = Math.floor(idx), fr = idx - i0;
                var a = i0 >= 0 && i0 < buf.length ? buf[i0] : 0, b = i0 + 1 >= 0 && i0 + 1 < buf.length ? buf[i0 + 1] : 0;
                return a + (b - a) * fr;
            }
            var i = Math.floor(idx);
            return i >= 0 && i < buf.length ? buf[i] : 0;
        },
        poke: function (buf, v, idx) { var i = Math.floor(idx); if (i >= 0 && i < buf.length) buf[i] = v; },
        floor: Math.floor, round: Math.round, sign: Math.sign, log2: Math.log2,
        min: Math.min, max: Math.max, sin: Math.sin, cos: Math.cos, tan: Math.tan, exp: Math.exp, tanh: Math.tanh,
        sqrt: Math.sqrt, abs: Math.abs, pow: Math.pow, atan: Math.atan
    };
    code = code.replace(/\/\/.*$/gm, ""); // comments first: a trailing "." would glue lines together
    var body = [];
    code.split("\n").forEach(function (ln) {
        var m = ln.match(/^(Param|History|Data|Buffer|Delay) (\w+)\(([^)]*)\);$/);
        if (!m) return body.push(ln);
        st[m[2]] = m[1] === "Data" ? new Float64Array(+m[3]) : m[1] === "Buffer" ? new Float64Array(4096)
            : m[1] === "Delay" ? new Delay(+m[3]) : +m[3];
    });
    var js = body.join("\n")
        .replace(/\b(\w+)="(\w+)"/g, '"$2"')                           // interp="linear" -> "linear"
        .replace(/^(\w+)\(([\w, ]*)\)\s*\{/gm, "function $1($2) {");  // GenExpr function definitions
    (js.match(/\b[a-zA-Z_]\w*\b/g) || []).forEach(function (id) {
        if (!(id in st) && ["function", "return", "for", "if", "else", "linear"].indexOf(id) < 0) st[id] = 0;
    });
    // Speed: every identifier becomes a local of one closure (a `with (st)` block ran ~10x slower); st keeps getters/setters for the
    // numeric ones so tests can still read and write st.name. Function definitions are hoisted out of the per-sample body.
    var funcs = js.match(/^function [\s\S]*?^\}/gm) || [];
    funcs.forEach(function (f) { js = js.replace(f, ""); });
    funcs.forEach(function (f) { delete st[f.match(/^function (\w+)/)[1]]; });
    var ids = Object.keys(st), nums = ids.filter(function (k) { return typeof st[k] === "number"; });
    var src = ids.map(function (k) { return "var " + k + " = S[" + JSON.stringify(k) + "];"; }).join("\n") + "\n" + funcs.join("\n") +
        "\nvar A = {" + nums.map(function (k) { return JSON.stringify(k) + ": [function () { return " + k + "; }, function (v) { " + k + " = v; }]"; }).join(",") +
        "};\nreturn [function () {" + js + "}, A];";
    var made = new Function("S", src)(Object.assign({}, st));
    nums.forEach(function (k) { Object.defineProperty(st, k, { get: made[1][k][0], set: made[1][k][1], enumerable: true }); });
    var tick = made[0];
    this.tick = function () { tick(); };
}
Engine.prototype.set = function (name, v) { assert(name in this.st, "no gen param " + name); this.st[name] = v; };
Engine.prototype.run = function (sec) {
    var n = Math.round(sec * SR), L = new Float64Array(n), R = new Float64Array(n);
    var M = new Float64Array(n);
    for (var i = 0; i < n; i++) { this.tick(this.st); L[i] = this.st.out1; R[i] = this.st.out2; M[i] = this.st.out3; }
    return [L, R, M];
};

function pitchOf(x) { // autocorrelation peak with parabolic refinement -> MIDI pitch
    var best = 0, bestLag = 0, c = [];
    for (var lag = 20; lag < 1200; lag++) {
        var s = 0;
        for (var i = 0; i < 8000; i++) s += x[i] * x[i + lag];
        c[lag] = s;
    }
    for (lag = 21; lag < 1199; lag++) if (c[lag] > best && c[lag] > c[lag - 1] && c[lag] >= c[lag + 1]) { best = c[lag]; bestLag = lag; }
    for (lag = 21; lag < bestLag; lag++) if (c[lag] > 0.9 * best && c[lag] > c[lag - 1] && c[lag] >= c[lag + 1]) { bestLag = lag; break; }
    var a = c[bestLag - 1], b = c[bestLag], d = c[bestLag + 1];
    var p = bestLag + 0.5 * (a - d) / (a - 2 * b + d);
    return 69 + 12 * Math.log2(SR / p / 440);
}
function rms(x, a, b) { a = Math.round(a); b = Math.round(b); var s = 0; for (var i = a; i < b; i++) s += x[i] * x[i]; return Math.sqrt(s / (b - a)); }

module.exports = { SR: SR, loadCode: loadCode, Engine: Engine, pitchOf: pitchOf, rms: rms };
