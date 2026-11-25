// ganza_measure.js — the one place that measures a ganza stroke (used on the Ableton reference one-shots by fit_refs.js and on
// our engine by test_engine.js, so both sides are measured by the same code), plus helpers to run the generated gen~ code.
//
// A "stroke" is one mono clip. Metrics (all re the clip itself, so absolute level never matters):
//   rise   ms from the onset (first 5 ms RMS above -26 dB of the peak) to the peak of the 10 ms RMS envelope
//   t20    ms from that peak until the 10 ms envelope is 20 dB down (Infinity: the clip ends first, e.g. a looped roll)
//   t30    same for 30 dB; t40 / t50 the tail
//   bands  dB re the total, first 100 ms after the onset: 0-0.5 0.5-1 1-2 2-4 4-6 6-8 8-12 12-16 16-24 kHz
//   cent   spectral centroid over the same 100 ms, Hz
//   cvE    grain fluctuation while the envelope is within 10 dB of its peak: std of (1 ms RMS / 8 ms RMS)
//   cvL    the same between -10 and -25 dB (the tail, where the collisions get sparse)
var fs = require("fs");
var path = require("path");
var cp = require("child_process");
var shim = require("./gen_shim.js");
var SR = shim.SR;

var BANDS = [0, 500, 1000, 2000, 4000, 6000, 8000, 12000, 16000, 24000];
var THIRDS = []; for (var _k = 0; _k <= 16; _k++) THIRDS.push(500 * Math.pow(2, _k / 3));   // 500 Hz .. 20 kHz in 1/3 octaves (the fit's resolution)

function fft(re, im) { // in place radix-2
    var n = re.length, i, j = 0, k, m, t;
    for (i = 1; i < n; i++) {
        var bit = n >> 1;
        for (; j & bit; bit >>= 1) j ^= bit;
        j ^= bit;
        if (i < j) { t = re[i]; re[i] = re[j]; re[j] = t; t = im[i]; im[i] = im[j]; im[j] = t; }
    }
    for (var len = 2; len <= n; len <<= 1) {
        var ang = -2 * Math.PI / len, wr = Math.cos(ang), wi = Math.sin(ang);
        for (i = 0; i < n; i += len) {
            var cr = 1, ci = 0;
            for (k = 0; k < len / 2; k++) {
                var a = i + k, b = i + k + len / 2;
                var xr = re[b] * cr - im[b] * ci, xi = re[b] * ci + im[b] * cr;
                re[b] = re[a] - xr; im[b] = im[a] - xi; re[a] += xr; im[a] += xi;
                m = cr * wr - ci * wi; ci = cr * wi + ci * wr; cr = m;
            }
        }
    }
}

function movRms(x, w) { // centred moving RMS, w samples
    var n = x.length, out = new Float64Array(n), cs = new Float64Array(n + 1), i;
    for (i = 0; i < n; i++) cs[i + 1] = cs[i] + x[i] * x[i];
    var h = w >> 1;
    for (i = 0; i < n; i++) {
        var a = Math.max(0, i - h), b = Math.min(n, i - h + w);
        out[i] = Math.sqrt(Math.max(0, cs[b] - cs[a]) / Math.max(1, b - a));
    }
    return out;
}

function std(v) { var m = 0, s = 0, i; for (i = 0; i < v.length; i++) m += v[i]; m /= v.length; for (i = 0; i < v.length; i++) s += (v[i] - m) * (v[i] - m); return Math.sqrt(s / v.length); }

// power spectrum (as band powers) of x[a..a+len)
function bandPower(x, a, len) {
    var n = 1; while (n < len) n <<= 1;
    n = Math.max(n, 8192);
    var re = new Float64Array(n), im = new Float64Array(n), i;
    for (i = 0; i < len && a + i < x.length; i++) re[i] = x[a + i];
    var mean = 0; for (i = 0; i < len; i++) mean += re[i]; mean /= len;
    for (i = 0; i < len; i++) re[i] -= mean; // no DC
    fft(re, im);
    var bp = new Float64Array(BANDS.length - 1), th = new Float64Array(THIRDS.length - 1), cen = 0, tot = 0;
    for (i = 1; i < n / 2; i++) {
        var f = i * SR / n, p = re[i] * re[i] + im[i] * im[i];
        tot += p; cen += p * f;
        for (var b = 0; b < bp.length; b++) if (f >= BANDS[b] && f < BANDS[b + 1]) bp[b] += p;
        if (f >= THIRDS[0] && f < THIRDS[THIRDS.length - 1]) th[Math.min(th.length - 1, Math.floor(3 * Math.log2(f / 500)))] += p;
    }
    return { bp: bp, th: th, tot: tot, cen: cen };
}

// x: Float64Array (mono, SR). Returns the metrics above; `parts` lets a caller average the spectra of several strokes (see average()).
function measure(x) {
    var e10 = movRms(x, Math.round(0.010 * SR)), e5 = movRms(x, Math.round(0.005 * SR)), e1 = movRms(x, Math.round(0.001 * SR)),
        e8 = movRms(x, Math.round(0.008 * SR)), n = x.length, i, pk = 0, pi = 0;
    for (i = 0; i < n; i++) if (e10[i] > pk) { pk = e10[i]; pi = i; }
    var on = 0;
    for (i = 0; i < n; i++) if (e5[i] > pk * Math.pow(10, -26 / 20)) { on = i; break; }
    var res = { rise: (pi - on) / SR * 1000, t20: Infinity, t30: Infinity, t40: Infinity, t50: Infinity, peak: pk };
    var i20 = n, i30 = n, i10 = n, i25 = n, i50 = n;
    for (i = pi; i < n; i++) {
        if (i10 === n && e10[i] < pk * Math.pow(10, -10 / 20)) i10 = i;
        if (i20 === n && e10[i] < pk * 0.1) { i20 = i; res.t20 = (i - pi) / SR * 1000; }
        if (i25 === n && e10[i] < pk * Math.pow(10, -25 / 20)) i25 = i;
        if (i30 === n && e10[i] < pk * Math.pow(10, -30 / 20)) { i30 = i; res.t30 = (i - pi) / SR * 1000; }
        if (res.t40 === Infinity && e10[i] < pk * Math.pow(10, -40 / 20)) res.t40 = (i - pi) / SR * 1000;
        if (i50 === n && e10[i] < pk * Math.pow(10, -50 / 20)) { i50 = i; res.t50 = (i - pi) / SR * 1000; break; }
    }
    var win = Math.round(0.1 * SR), sp = bandPower(x, on, win);
    res.bands = Array.prototype.map.call(sp.bp, function (v) { return 10 * Math.log10(v / sp.tot + 1e-12); });
    res.cent = sp.cen / sp.tot;
    res.third = Array.prototype.map.call(sp.th, function (v) { return 10 * Math.log10(v / sp.tot + 1e-12); });
    res.spec = { bp: sp.bp, th: sp.th, tot: sp.tot, cen: sp.cen };
    function cv(a, b) {
        var q = [];
        for (var k = a; k < b && k < n; k += 8) if (e8[k] > 1e-9) q.push(e1[k] / e8[k]);
        return q.length > 20 ? std(q) : NaN;
    }
    res.cvE = cv(Math.max(0, pi - Math.round(0.005 * SR)), i10);
    res.cvL = cv(i10, Math.min(i25, n - Math.round(0.01 * SR)));
    return res;
}

// mean of several strokes' metrics (spectra pooled as power, so band levels are of the mean spectrum)
function average(list) {
    var out = { n: list.length }, keys = ["rise", "t20", "t30", "t40", "t50", "cent", "cvE", "cvL"];
    keys.forEach(function (k) {
        var v = list.map(function (m) { return m[k]; }).filter(function (q) { return isFinite(q); });
        out[k] = v.length ? v.reduce(function (a, b) { return a + b; }, 0) / v.length : (list.some(function (m) { return m[k] === Infinity; }) ? Infinity : NaN);
    });
    var nb = BANDS.length - 1, bp = new Float64Array(nb), tot = 0, i;
    list.forEach(function (m) { var t = m.spec.tot; tot += 1; for (i = 0; i < nb; i++) bp[i] += m.spec.bp[i] / t; });
    out.bands = Array.prototype.map.call(bp, function (v) { return 10 * Math.log10(v / tot + 1e-12); });
    var th = new Float64Array(THIRDS.length - 1);
    list.forEach(function (m) { for (i = 0; i < th.length; i++) th[i] += m.spec.th[i] / m.spec.tot; });
    out.third = Array.prototype.map.call(th, function (v) { return 10 * Math.log10(v / tot + 1e-12); });
    out.spec = { bp: bp, th: th, tot: tot, cen: 0 };   // pooled: powers are per unit total, so tot is the count
    return out;
}

function readWav(file) { // 16-bit PCM mono/stereo (afconvert output) -> mono Float64Array
    var b = fs.readFileSync(file), p = 12, ch = 1, bits = 16, data = null, len = 0;
    while (p + 8 <= b.length) {
        var id = b.toString("ascii", p, p + 4), sz = b.readUInt32LE(p + 4);
        if (id === "fmt ") { ch = b.readUInt16LE(p + 10); bits = b.readUInt16LE(p + 22); }
        if (id === "data") { data = p + 8; len = Math.min(sz, b.length - data); break; }
        p += 8 + sz + (sz & 1);
    }
    if (bits !== 16) throw new Error(file + ": expected 16-bit");
    var n = Math.floor(len / (2 * ch)), x = new Float64Array(n);
    for (var i = 0; i < n; i++) { var s = 0; for (var c = 0; c < ch; c++) s += b.readInt16LE(data + 2 * (i * ch + c)); x[i] = s / ch / 32768; }
    return x;
}

function writeWav(file, chans, peak) { // chans: [L] or [L, R] Float64Arrays; normalised to `peak` if given
    var nc = chans.length, n = chans[0].length, b = Buffer.alloc(44 + n * 2 * nc), g = 1, i, c;
    if (peak) { var m = 0; chans.forEach(function (x) { for (i = 0; i < n; i++) m = Math.max(m, Math.abs(x[i])); }); g = m > 0 ? peak / m : 1; }
    b.write("RIFF", 0); b.writeUInt32LE(36 + n * 2 * nc, 4); b.write("WAVEfmt ", 8); b.writeUInt32LE(16, 16); b.writeUInt16LE(1, 20); b.writeUInt16LE(nc, 22);
    b.writeUInt32LE(SR, 24); b.writeUInt32LE(SR * 2 * nc, 28); b.writeUInt16LE(2 * nc, 32); b.writeUInt16LE(16, 34); b.write("data", 36); b.writeUInt32LE(n * 2 * nc, 40);
    for (i = 0; i < n; i++) for (c = 0; c < nc; c++) b.writeInt16LE(Math.max(-32768, Math.min(32767, Math.round(chans[c][i] * g * 32767))), 44 + 2 * (i * nc + c));
    fs.writeFileSync(file, b);
}

// ── running the generated engine ─────────────────────────────────────────────────────────────────────────────────────────────────
var CODE = null;
function code() {
    if (!CODE) CODE = cp.execFileSync("python3", [path.join(__dirname, "../scripts/ganza_engine.py"), "--code"], { encoding: "utf8" });
    return CODE;
}

// new engine with params set; type: 0..4
function engine(params) {
    var e = new shim.Engine(code());
    Object.keys(params || {}).forEach(function (k) { e.set(k, params[k]); });
    return e;
}

var counter = 0;
// events: [{t: seconds, vel: 0..1, dir: 0|1}] -> {l, r} for `sec` seconds
function render(params, events, sec, seed) {
    var e = engine(params), n = Math.round(sec * SR), L = new Float64Array(n), R = new Float64Array(n), k = 0;
    events = events.slice().sort(function (a, b) { return a.t - b.t; });
    for (var i = 0; i < n; i++) {
        while (k < events.length && events[k].t * SR <= i) {
            e.st.vl = events[k].vel; e.st.dir = events[k].dir || 0; e.st.acc = events[k].acc || 0; e.st.tr = ++counter % 65536; k++;
        }
        e.tick();
        L[i] = e.st.out1; R[i] = e.st.out2;
    }
    return { l: L, r: R };
}

// n strokes (forward, spaced `gap` s apart) rendered one engine each so the measurements are independent; returns the averaged metrics
function strokes(params, n, vel, dir, sec, acc) {
    var list = [];
    for (var k = 0; k < n; k++) {
        var e = engine(params); // fresh engine, but different noise: burn some noise draws
        for (var j = 0; j < k * 7919 + 13; j++) e.st.noise();
        e.st.vl = vel; e.st.dir = dir || 0; e.st.acc = acc || 0; e.st.tr = 1;
        var m = Math.round((sec || 0.6) * SR), x = new Float64Array(m);
        for (var i = 0; i < m; i++) { e.tick(); x[i] = e.st.out1; }
        list.push(measure(x));
    }
    return average(list);
}


// a 16th-note pattern (strokes ~100-130 ms apart, each carrying its neighbours' tails): the peaks of the 10 ms RMS (one per stroke, >= 60 ms apart and within
// 22 dB of the loudest), and the troughs between them. Returns {peaks (dB re the loudest), depth (mean peak-to-trough dB), alt (mean dB of the even strokes
// minus the odd ones), cent (centroid of the even strokes' first 40 ms, Hz) / centOdd, n}.
function pattern(x) {
    var e = movRms(x, Math.round(0.010 * SR)), n = x.length, mx = 0, i, pk = [], gap = Math.round(0.06 * SR);
    for (i = 0; i < n; i++) mx = Math.max(mx, e[i]);
    for (i = gap; i < n - gap; i++) {
        if (e[i] < mx * Math.pow(10, -22 / 20)) continue;
        var ok = true; for (var k = -gap; k <= gap; k++) if (e[i + k] > e[i]) { ok = false; break; }
        if (ok) pk.push(i);
    }
    var db = pk.map(function (p) { return 20 * Math.log10(e[p] / mx); }), dep = [];
    for (i = 1; i < pk.length; i++) {
        var lo = Infinity; for (var q = pk[i - 1]; q <= pk[i]; q++) lo = Math.min(lo, e[q]);
        dep.push(20 * Math.log10(Math.min(e[pk[i - 1]], e[pk[i]]) / lo));
    }
    function m(a) { return a.length ? a.reduce(function (s, v) { return s + v; }, 0) / a.length : NaN; }
    var ev = db.filter(function (_, j) { return j % 2 === 0; }), od = db.filter(function (_, j) { return j % 2 === 1; });
    // which parity is the louder one is a convention of where the first peak falls: report |alt| and the centroid difference loud minus soft
    var loudPar = m(ev) >= m(od) ? 0 : 1, cl = [], cs = [];
    pk.forEach(function (p, j) { var c = bandPower(x, Math.max(0, p - Math.round(0.02 * SR)), Math.round(0.04 * SR)); (j % 2 === loudPar ? cl : cs).push(c.cen / c.tot); });
    return { peaks: db, depth: m(dep), alt: Math.abs(m(ev) - m(od)), centLoud: m(cl), centSoft: m(cs), n: pk.length };
}

module.exports = { pattern: pattern,  SR: SR, BANDS: BANDS, THIRDS: THIRDS, fft: fft, measure: measure, average: average, readWav: readWav, writeWav: writeWav, code: code, engine: engine,
    render: render, strokes: strokes, movRms: movRms };
