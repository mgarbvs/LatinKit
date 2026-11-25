// cr_measure.js — shared helpers for test_engine.js and calibrate.js: render hits through the generated gen~ code in Node and
// measure frequency, decay-to-1/10, level and the guiro's pulse rate.
var shim = require("./gen_shim.js");
var fs = require("fs");
var path = require("path");
var cp = require("child_process");
var SR = shim.SR;

var SLOTS = { bd: 0, rs: 1, sd: 2, hh: 3, mb: 4, cy: 5, tb: 6, cb: 7, hb: 8, lb: 9, lc: 10, ma: 11, guH: 12, guL: 13, cl: 14 };
var CODE = null;

function code() {
    if (!CODE) {
        var maxpat = path.join(__dirname, "../m4l/CR78.maxpat");
        CODE = process.env.CR_PY ? cp.execSync("python3 " + path.join(__dirname, "../scripts/cr_engine.py"), { encoding: "utf8" })
            : shim.loadCode(maxpat);
    }
    return CODE;
}

function engine(params, src) {
    var e = new shim.Engine(src || code());
    Object.keys(params || {}).forEach(function (k) { e.set(k, params[k]); });
    return e;
}

// events: [{t: seconds, hit: slot, vel: 0..127}, {t, set: {name: value}}]; returns {l, r, m} (m = mono at centre pan)
function render(params, events, sec, src) {   // src: another gen~ code (a single-voice device), default the full CR78's
    var e = engine(params, src), st = e.st, n = Math.round(sec * SR);
    var ev = events.map(function (x) { return Object.assign({ at: Math.round(x.t * SR) }, x); }).sort(function (a, b) { return a.at - b.at; });
    var L = new Float64Array(n), R = new Float64Array(n), M = new Float64Array(n), k = 0;
    for (var i = 0; i < n; i++) {
        while (k < ev.length && ev[k].at <= i) {
            var x = ev[k++];
            if (x.hit !== undefined) {
                st["tr" + x.hit] = (st["tr" + x.hit] + 1) % 65536;
                st["vl" + x.hit] = Math.max(0.01, (x.vel === undefined ? 100 : x.vel) / 127);
            }
            if (x.set) Object.keys(x.set).forEach(function (p) { e.set(p, x.set[p]); });
        }
        e.tick(st);
        L[i] = st.out1; R[i] = st.out2; M[i] = st.out1 * Math.SQRT2;
    }
    return { l: L, r: R, m: M };
}

function peakOf(x, a, b) { var p = 0; for (var i = a || 0; i < (b || x.length); i++) p = Math.max(p, Math.abs(x[i])); return p; }

// frequency of a damped sine from its zero crossings (exact for e^-t sin(wt)): regression of crossing time on index
function zeroCrossFreq(x, maxSec) {
    var ts = [], pk = peakOf(x, 0, Math.round(maxSec * SR));
    for (var i = 1; i < maxSec * SR; i++) {
        if (x[i - 1] <= 0 && x[i] > 0 || x[i - 1] >= 0 && x[i] < 0) {
            ts.push((i - 1 + x[i - 1] / (x[i - 1] - x[i])) / SR);
        }
    }
    ts = ts.slice(1); // the first one is the onset
    var n = ts.length, sx = 0, sy = 0, sxy = 0, sxx = 0;
    ts.forEach(function (t, j) { sx += j; sy += t; sxy += j * t; sxx += j * j; });
    var slope = (n * sxy - sx * sy) / (n * sxx - sx * sx);
    return { f: 0.5 / slope, n: n, pk: pk };
}

// magnitude spectrum with parabolic peak interpolation; returns a function f -> {f, mag} of the local maximum nearest f within +-frac
function spectrum(x, a, b) {
    var N = 1 << 18, re = new Float64Array(N), im = new Float64Array(N), len = b - a;
    for (var i = 0; i < len; i++) re[i] = x[a + i] * (0.5 - 0.5 * Math.cos(2 * Math.PI * i / (len - 1)));
    fft(re, im);
    var mag = new Float64Array(N / 2);
    for (i = 0; i < N / 2; i++) mag[i] = Math.hypot(re[i], im[i]);
    return {
        mag: mag,
        near: function (f, frac) {
            var lo = Math.floor(f * (1 - frac) * N / SR), hi = Math.ceil(f * (1 + frac) * N / SR), k = lo;
            for (var j = lo; j <= hi; j++) if (mag[j] > mag[k]) k = j;
            var A = Math.log(mag[k - 1] + 1e-30), B = Math.log(mag[k] + 1e-30), C = Math.log(mag[k + 1] + 1e-30);
            return { f: (k + 0.5 * (A - C) / (A - 2 * B + C)) * SR / N, mag: mag[k] };
        },
        // the n strongest local maxima between f0 and f1 (at least minSep Hz apart), strongest first
        top: function (n, f0, f1, minSep) {
            var c = [];
            for (var j = Math.ceil(f0 * N / SR); j < f1 * N / SR; j++) if (mag[j] > mag[j - 1] && mag[j] >= mag[j + 1]) c.push(j);
            c.sort(function (p, q) { return mag[q] - mag[p]; });
            var out = [];
            c.forEach(function (j) {
                if (out.length < n && out.every(function (o) { return Math.abs(o - j) * SR / N > minSep; })) out.push(j);
            });
            return out.map(function (j) { return j * SR / N; });
        }
    };
}
function fft(re, im) { // in-place radix-2
    var n = re.length, i, j = 0, k;
    for (i = 1; i < n; i++) {
        var bit = n >> 1;
        for (; j & bit; bit >>= 1) j ^= bit;
        j ^= bit;
        if (i < j) { var t = re[i]; re[i] = re[j]; re[j] = t; t = im[i]; im[i] = im[j]; im[j] = t; }
    }
    for (var len = 2; len <= n; len <<= 1) {
        var ang = -2 * Math.PI / len, wr = Math.cos(ang), wi = Math.sin(ang);
        for (i = 0; i < n; i += len) {
            var cr = 1, ci = 0;
            for (k = 0; k < len / 2; k++) {
                var ur = re[i + k], ui = im[i + k];
                var vr = re[i + k + len / 2] * cr - im[i + k + len / 2] * ci, vi = re[i + k + len / 2] * ci + im[i + k + len / 2] * cr;
                re[i + k] = ur + vr; im[i + k] = ui + vi; re[i + k + len / 2] = ur - vr; im[i + k + len / 2] = ui - vi;
                var nr = cr * wr - ci * wi; ci = cr * wi + ci * wr; cr = nr;
            }
        }
    }
}

// decay to 1/10 amplitude, from the envelope's first peak: sliding RMS (window winSec) averaged over `hits` hits (mean square, so
// noise voices converge), spaced `gap` s. Returns seconds.
function decayTo10(slot, params, winSec, hits, gap) {
    var ev = [];
    for (var h = 0; h < hits; h++) ev.push({ t: 0.05 + h * gap, hit: SLOTS[slot] });
    var x = render(params, ev, 0.05 + hits * gap).m, W = Math.round(winSec * SR), hop = Math.max(1, Math.round(0.00015 * SR));
    var span = Math.round(gap * SR), env = [];
    var cum = new Float64Array(x.length + 1);
    for (var i = 0; i < x.length; i++) cum[i + 1] = cum[i] + x[i] * x[i];
    for (var s = 0; s + W < span; s += hop) {
        var ms = 0;
        for (h = 0; h < hits; h++) { var a = Math.round(0.05 * SR) + h * span + s; ms += (cum[a + W] - cum[a]) / W; }
        env.push(Math.sqrt(ms / hits));
    }
    var pk = 0, pi = 0;
    env.forEach(function (v, j) { if (v > pk) { pk = v; pi = j; } });
    for (j = pi; j < env.length; j++) if (env[j] <= 0.1 * pk) {
        var frac = (env[j - 1] - 0.1 * pk) / (env[j - 1] - env[j]);
        return (j - 1 + frac - pi) * hop / SR;
    }
    return Infinity;
}

// peak level of a hit (median over `hits` hits for noise voices), at the voice's default settings
function peakLevel(slot, params, hits, gap, gateSec) {
    var ev = [], pks = [];
    for (var h = 0; h < hits; h++) {
        ev.push({ t: 0.05 + h * gap, hit: SLOTS[slot] });
        if (gateSec) { ev.push({ t: 0.05 + h * gap, set: { gt12: 1, gt13: 1 } }); ev.push({ t: 0.05 + h * gap + gateSec, set: { gt12: 0, gt13: 0 } }); }
    }
    var x = render(params, ev, 0.05 + hits * gap).m;
    for (h = 0; h < hits; h++) pks.push(peakOf(x, Math.round((0.05 + h * gap) * SR), Math.round((0.05 + (h + 1) * gap) * SR)));
    pks.sort(function (p, q) { return p - q; });
    return pks[Math.floor(pks.length / 2)];
}

// guiro: pulse onsets (first threshold crossing after a quiet gap) -> pulses per second from a regression over all of them
function pulseRate(x, a, b, minGap) {
    // onsets of the 1 ms-smoothed |x| (the guiro's grains are noise, so raw samples dip below threshold inside a grain)
    var w = Math.round(0.001 * SR), env = new Float64Array(b), acc = 0;
    for (var j = a; j < b; j++) { acc += Math.abs(x[j]) - (j - w >= a ? Math.abs(x[j - w]) : 0); env[j] = acc / w; }
    var pk = peakOf(env, a, b), thr = 0.3 * pk, onsets = [], last = -1e9, ref = Math.round((minGap || 0.001) * SR);
    for (var i = a; i < b; i++) if (env[i] > thr && i - last > ref) { onsets.push(i / SR); last = i; } else if (env[i] > thr) last = i;
    // rate: the shortest lag (2-30 ms) whose envelope autocorrelation is within 85 % of the best one
    var mean = 0, ac = [], best = 0, lag = 0;
    for (var k = a; k < b; k++) mean += env[k] / (b - a);
    for (var L = Math.round(0.002 * SR); L <= Math.round(0.03 * SR); L++) {
        var c = 0; for (var q = a; q + L < b; q++) c += (env[q] - mean) * (env[q + L] - mean);
        ac[L] = c / (b - a - L); best = Math.max(best, ac[L]);
    }
    for (L = Math.round(0.002 * SR); !lag; L++) if (ac[L] >= 0.85 * best && ac[L] >= ac[L - 1] && ac[L] >= ac[L + 1]) lag = L;
    var y0 = ac[lag - 1], y1 = ac[lag], y2 = ac[lag + 1], fine = lag + 0.5 * (y0 - y2) / (y0 - 2 * y1 + y2);
    return { rate: SR / fine, n: onsets.length, onsets: onsets };
}

module.exports = { SR: SR, SLOTS: SLOTS, engine: engine, render: render, peakOf: peakOf, zeroCrossFreq: zeroCrossFreq, spectrum: spectrum,
    decayTo10: decayTo10, peakLevel: peakLevel, pulseRate: pulseRate, code: code };
