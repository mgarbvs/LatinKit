// guiro_measure.js — the one place that measures a scraper stroke (used on the Latin Percussion güiro previews by refs.js and on our engine by
// test_engine.js / fit_types.js, so both sides are measured by the same code), plus helpers to run the generated gen~ code.
//
// Metrics (all re the clip itself, so absolute level never matters):
//   rise   ms from the onset (first 5 ms RMS above -26 dB of the peak) to the peak of the 10 ms RMS envelope
//   t10 t20 t30  ms from that peak until the 10 ms envelope is 10 / 20 / 30 dB down
//   len    ms from the onset until the 5 ms envelope was last within 20 dB of the peak (scrape plus ring)
//   tail   ms from `len` until the 5 ms envelope is 35 dB under the peak
//   n, span, rate  impacts found by detect() (above 3 kHz, 0.4 ms RMS, a 6 dB rise in 1 ms, >= 2.5 ms apart, within 24 dB of the loudest),
//                  ms from the first to the last, and impacts per second over that span; r1 r2 r3 the rate in each third of the span
//   lv3    mean dB of the impacts in the last third minus the first third
//   bands  dB re the total, first 100 ms after the onset: 0-0.25 0.25-0.5 0.5-1 1-2 2-4 4-6 6-8 8-12 12-16 16-24 kHz;  cent the spectral centroid (Hz)
//   cvE    grain fluctuation while the envelope is within 10 dB of its peak: std of (1 ms RMS / 8 ms RMS)
var fs = require("fs");
var path = require("path");
var cp = require("child_process");
var shim = require("./gen_shim.js");
var SR = shim.SR;

var BANDS = [0, 250, 500, 1000, 2000, 4000, 6000, 8000, 12000, 16000, 24000];
var THIRDS = []; for (var _k = 0; _k <= 22; _k++) THIRDS.push(125 * Math.pow(2, _k / 3));   // 125 Hz .. 20 kHz in 1/3 octaves (the fit's resolution)

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
        if (f >= THIRDS[0] && f < THIRDS[THIRDS.length - 1]) th[Math.min(th.length - 1, Math.floor(3 * Math.log2(f / 125)))] += p;
    }
    return { bp: bp, th: th, tot: tot, cen: cen };
}


// 4th-order Butterworth high-pass as two RBJ biquads
function hp4(x, fc) {
    var y = Float64Array.from(x);
    [0.5412, 1.3066].forEach(function (Q) {
        var w = 2 * Math.PI * fc / SR, al = Math.sin(w) / (2 * Q), c = Math.cos(w), a0 = 1 + al;
        var b0 = (1 + c) / 2 / a0, b1 = -(1 + c) / a0, a1 = -2 * c / a0, a2 = (1 - al) / a0, x1 = 0, x2 = 0, y1 = 0, y2 = 0;
        for (var i = 0; i < y.length; i++) { var v = y[i], o = b0 * v + b1 * x1 + b0 * x2 - a1 * y1 - a2 * y2; x2 = x1; x1 = v; y2 = y1; y1 = o; y[i] = o; }
    });
    return y;
}
// the ridge impacts: indices of the onsets, and the 0.4 ms level in dB
function detect(x) {
    var e = movRms(hp4(x, 3000), Math.round(0.0004 * SR)), n = x.length, d = new Float64Array(n), mx = -1e9, i;
    for (i = 0; i < n; i++) { d[i] = 20 * Math.log10(e[i] + 1e-6); if (d[i] > mx) mx = d[i]; }
    var k = Math.round(0.001 * SR), sep = Math.round(0.0025 * SR), o = new Float64Array(n), pk = [];
    for (i = k; i < n; i++) o[i] = Math.max(0, d[i] - d[i - k]);
    for (i = 1; i < n - 1; i++) if (o[i] >= 6 && o[i] >= o[i - 1] && o[i] > o[i + 1] && d[i] > mx - 24) {
        if (pk.length && i - pk[pk.length - 1] < sep) { if (o[i] > o[pk[pk.length - 1]]) pk[pk.length - 1] = i; } else pk.push(i);
    }
    return { p: pk, d: d };
}
// x: Float64Array (mono, SR). Returns the metrics above; `parts` lets a caller average the spectra of several strokes (see average()).
function measure(x) {
    var xh = hp4(x, 1000);   // the envelope metrics look above 1 kHz: a tonal body ring at 300 Hz must not pass for a long tail
    var e10 = movRms(xh, Math.round(0.010 * SR)), e5 = movRms(xh, Math.round(0.005 * SR)), e1 = movRms(xh, Math.round(0.001 * SR)),
        e8 = movRms(xh, Math.round(0.008 * SR)), n = x.length, i, pk = 0, pi = 0;
    for (i = 0; i < n; i++) if (e10[i] > pk) { pk = e10[i]; pi = i; }
    var on = 0;
    for (i = 0; i < n; i++) if (e5[i] > pk * Math.pow(10, -26 / 20)) { on = i; break; }
    var res = { rise: (pi - on) / SR * 1000, t10: Infinity, t20: Infinity, t30: Infinity, peak: pk };
    var i20 = n, i30 = n, i10 = n, i25 = n;
    for (i = pi; i < n; i++) {
        if (i10 === n && e10[i] < pk * Math.pow(10, -10 / 20)) { i10 = i; res.t10 = (i - pi) / SR * 1000; }
        if (i20 === n && e10[i] < pk * 0.1) { i20 = i; res.t20 = (i - pi) / SR * 1000; }
        if (i25 === n && e10[i] < pk * Math.pow(10, -25 / 20)) i25 = i;
        if (i30 === n && e10[i] < pk * Math.pow(10, -30 / 20)) { i30 = i; res.t30 = (i - pi) / SR * 1000; break; }
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
    var last = on; for (i = on; i < n; i++) if (e5[i] > pk * 0.1) last = i;
    res.len = (last - on) / SR * 1000;
    var tl = n; for (i = last; i < n; i++) if (e5[i] < pk * Math.pow(10, -35 / 20)) { tl = i; break; }
    res.tail = (tl - last) / SR * 1000;
    var D = detect(x), p = D.p;
    res.n = p.length;
    res.span = p.length > 1 ? (p[p.length - 1] - p[0]) / SR * 1000 : 0;
    res.rate = res.span > 0 ? (p.length - 1) / res.span * 1000 : NaN;
    res.r1 = res.r2 = res.r3 = NaN; res.lv3 = NaN;
    if (p.length >= 6) {
        var t0 = p[0], T = p[p.length - 1] - p[0], cnt = [0, 0, 0], lv = [[], [], []];
        p.forEach(function (q) { var th = Math.min(2, Math.floor(3 * (q - t0) / (T + 1))); cnt[th]++; lv[th].push(D.d[q]); });
        res.r1 = cnt[0] / (T / 3 / SR); res.r2 = cnt[1] / (T / 3 / SR); res.r3 = cnt[2] / (T / 3 / SR);
        var m = function (a) { return a.length ? a.reduce(function (s, v) { return s + v; }, 0) / a.length : NaN; };
        res.lv3 = m(lv[2]) - m(lv[0]);
    }
    return res;
}

// mean of several strokes' metrics (spectra pooled as power, so band levels are of the mean spectrum)
function average(list) {
    var out = { n: list.length }, keys = ["rise", "t10", "t20", "t30", "cent", "cvE", "cvL", "len", "tail", "n", "span", "rate", "r1", "r2", "r3", "lv3"];
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
    if (!CODE) CODE = cp.execFileSync("python3", [path.join(__dirname, "../scripts/guiro_engine.py"), "--code"], { encoding: "utf8" });
    return CODE;
}

// new engine with params set; type: 0..4
function engine(params) {
    var e = new shim.Engine(code());
    Object.keys(params || {}).forEach(function (k) { e.set(k, params[k]); });
    return e;
}

var counter = 0;
// events: [{t: seconds, vel: 0..1, stk: 0..3, len: ms (Long)}] -> {l, r} for `sec` seconds
function render(params, events, sec, seed) {
    var e = engine(params), n = Math.round(sec * SR), L = new Float64Array(n), R = new Float64Array(n), k = 0;
    events = events.slice().sort(function (a, b) { return a.t - b.t; });
    for (var i = 0; i < n; i++) {
        while (k < events.length && events[k].t * SR <= i) {
            e.st.vl = events[k].vel; e.st.stk = events[k].stk || 0; if (events[k].len) e.st.len = events[k].len; e.st.tr = ++counter % 65536; k++;
        }
        e.tick();
        L[i] = e.st.out1; R[i] = e.st.out2;
    }
    return { l: L, r: R };
}

// n strokes of kind `stk` rendered one engine each so the measurements are independent; returns the averaged metrics
function strokes(params, n, vel, stk, sec) {
    var list = [];
    for (var k = 0; k < n; k++) {
        var e = engine(params); // fresh engine, but different noise: burn some noise draws
        for (var j = 0; j < k * 7919 + 13; j++) e.st.noise();
        e.st.vl = vel; e.st.stk = stk || 0; e.st.tr = 1;
        var m = Math.round((sec || 0.6) * SR), x = new Float64Array(m);
        for (var i = 0; i < m; i++) { e.tick(); x[i] = e.st.out1; }
        list.push(measure(x));
    }
    var out = average(list); out.each = list; return out;
}

module.exports = { SR: SR, BANDS: BANDS, THIRDS: THIRDS, fft: fft, measure: measure, average: average, readWav: readWav, writeWav: writeWav, code: code, engine: engine,
    render: render, strokes: strokes, movRms: movRms, detect: detect };
