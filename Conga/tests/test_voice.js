// node tests/test_voice.js -- Conga Voice (m4l/Conga Voice.maxpat) in the Node shim against the full device (m4l/Conga.maxpat): every drum x stroke
// must render the same samples (Spread 0), plus stroke changes over a ringing drum, the controls and conga_voice_midi.js.
var fs = require("fs"), path = require("path"), S = require("./gen_shim.js"), SR = S.SR;
var FULL = S.loadCode(path.join(__dirname, "../m4l/Conga.maxpat")), VOICE = S.loadCode(path.join(__dirname, "../m4l/Conga Voice.maxpat"));
var fails = 0, count = 0;
function check(ok, what) { console.log((ok ? "ok   " : "FAIL ") + what); if (!ok) fails++; }
var DB = function (x) { return 20 * Math.log10(x + 1e-12); };
var F1 = [366, 266, 219];
// full-device parameter -> voice parameter, for one drum
function fullParams(p, d) { var q = { spread: 0 }; Object.keys(p).forEach(function (k) { q[k === "tune" ? ["tuneQ", "tuneC", "tuneT"][d] : k === "volume" ? "level" : k] = p[k]; }); return q; }
function mk(code, params) { var e = new S.Engine(code); Object.keys(params || {}).forEach(function (k) { e.set(k, params[k]); }); return e; }
// a script: [[t seconds, drum, stroke, velocity]], rendered by the full device (each hit on its slot) and by the voice (menus set, counter bumped)
function render(script, sec, params, mw) {
    var d0 = script[0][1], full = mk(FULL, fullParams(params, d0)), voice = mk(VOICE, params);
    if (mw !== undefined) { full.set("mw", mw); voice.set("mw", mw); }
    var n = Math.round(sec * SR), L = new Float64Array(n), V = new Float64Array(n), V2 = new Float64Array(n), i = 0;
    script.forEach(function (h) {
        var upto = Math.round(h[0] * SR);
        for (; i < upto; i++) { full.tick(); voice.tick(); L[i] = full.st.out1; V[i] = voice.st.out1; V2[i] = voice.st.out2; }
        var slot = h[1] * 6 + h[2];
        full.set("vl" + slot, h[3]); full.set("tr" + slot, ++count);
        voice.set("drum", h[1]); voice.set("stroke", h[2]); voice.set("vel", h[3]); voice.set("trg", count);
    });
    for (; i < n; i++) { full.tick(); voice.tick(); L[i] = full.st.out1; V[i] = voice.st.out1; V2[i] = voice.st.out2; }
    return { full: L, voice: V, voice2: V2 };
}
function maxDiff(a, b) { var m = 0; for (var i = 0; i < a.length; i++) m = Math.max(m, Math.abs(a[i] - b[i])); return m; }
function peak(x) { var p = 0; for (var i = 0; i < x.length; i++) p = Math.max(p, Math.abs(x[i])); return p; }
function finite(x) { for (var i = 0; i < x.length; i++) if (!isFinite(x[i])) return false; return true; }

// 1. every drum x stroke, default controls and velocities 1 / 0.4: the voice is the full device
var NAMES = ["Quinto", "Conga", "Tumba"], STROKES = ["open", "slap", "mute", "bass", "heel", "toe"];
for (var d = 0; d < 3; d++) for (var s = 0; s < 6; s++) [1, 0.4].forEach(function (v) {
    var r = render([[0, d, s, v]], 0.8, {}), diff = maxDiff(r.full, r.voice), pk = peak(r.voice);
    check(diff < 1e-9 * Math.max(1, pk) && pk > 0.01 && finite(r.voice), NAMES[d] + " " + STROKES[s] + " vel " + v + ": max |voice - full| " + diff.toExponential(1) + ", peak " + DB(pk).toFixed(1) + " dBFS");
});

// 2. the same with every control moved (and the wheel), per drum
(function () {
    var p = { tune: 3.5, decay: 160, skin: 80, slap: 85, shell: 20, touch: 90, press: 9, volume: -3 };
    for (var d = 0; d < 3; d++) {
        var r = render([[0, d, 1, 0.9], [0.3, d, 4, 0.6]], 0.8, p, 0.7);
        check(maxDiff(r.full, r.voice) < 1e-9 && peak(r.voice) > 0.01, NAMES[d] + " slap then heel, all controls moved, wheel 0.7: max diff " + maxDiff(r.full, r.voice).toExponential(1));
    }
})();

// 3. changing Stroke over a ringing drum: open, then 150 ms later every other stroke on the same drum, as the full device does it (the hand damps the ring)
var chg = 0;
for (d = 0; d < 3; d++) for (s = 1; s < 6; s++) {
    var r = render([[0, d, 0, 0.9], [0.15, d, s, 0.7]], 0.7, {});
    if (maxDiff(r.full, r.voice) > 1e-9) check(false, NAMES[d] + " open -> " + STROKES[s] + ": diverges from the full device by " + maxDiff(r.full, r.voice).toExponential(1));
    else chg++;
}
check(chg === 15, "open -> any other stroke 150 ms later, on every drum: " + chg + " of 15 identical to the full device");
(function () {
    var r = render([[0, 2, 0, 0.9], [0.3, 2, 2, 0.5]], 1.0, {});
    check(maxDiff(r.full, r.voice) < 1e-9, "tumba open then mute at 300 ms: identical to the full device (" + maxDiff(r.full, r.voice).toExponential(1) + ")");
    var free = render([[0, 2, 0, 0.9]], 1.0, {}).voice, e = 0, f = 0;
    for (var i = Math.round(0.45 * SR); i < Math.round(0.7 * SR); i++) { e += r.voice[i] * r.voice[i]; f += free[i] * free[i]; }
    check(DB(Math.sqrt(e / f)) < -10, "the mute takes the ring down: 150..400 ms later " + DB(Math.sqrt(e / f)).toFixed(1) + " dB under the free ring (need < -10)");
})();

// 4. changing Drum between hits: both drums sound at their own pitch afterwards (no stale tables), finite
(function () {
    var e = mk(VOICE, {});
    e.set("drum", 0); e.set("stroke", 0); e.set("vel", 0.8); e.set("trg", ++count); var a = e.run(0.4)[0];
    e.set("drum", 2); e.set("trg", ++count); var b = e.run(0.6)[0];
    check(finite(a) && finite(b) && peak(b) > 0.01, "quinto open then tumba open: finite and sounding");
    function zc(x, t0, t1) { var n = 0; for (var i = Math.round(t0 * SR) + 1; i < Math.round(t1 * SR); i++) if (x[i - 1] < 0 && x[i] >= 0) n++; return n / (t1 - t0); }
    var f2 = mk(VOICE, {}); f2.set("drum", 2); f2.set("vel", 0.8); f2.set("trg", ++count);
    var t = f2.run(0.6)[0];
    check(Math.abs(DB(rmsOf(b, 0.15, 0.55)) - DB(rmsOf(t, 0.15, 0.55))) < 6, "tumba after a quinto rings about as loud as a fresh tumba (the old ring is gone)");
})();
function rmsOf(x, t0, t1) { return S.rms(x, t0 * SR, t1 * SR); }

// 5. both output channels equal; Volume -36..6 stays finite and under full scale with everything extreme
(function () {
    var r = render([[0, 1, 1, 1]], 0.4, {});
    check(maxDiff(r.voice, r.voice2) === 0, "L == R (mono)");
    var worst = 0, bad = 0;
    [0, 1].forEach(function (a) {
        var p = { tune: a ? 12 : -12, decay: a ? 300 : 30, skin: a ? 100 : 0, slap: a ? 100 : 0, shell: a ? 100 : 0, touch: a ? 100 : 0, press: 12, volume: 6 };
        for (var d = 0; d < 3; d++) {
            var e = mk(VOICE, p); e.set("mw", 1);
            for (var k = 0; k < 6; k++) { e.set("drum", d); e.set("stroke", k); e.set("vel", 1); e.set("trg", ++count); var o = e.run(0.12); if (!finite(o[0])) bad++; worst = Math.max(worst, peak(o[0]), peak(o[1])); }
        }
    });
    check(!bad && worst <= 1.0001, "extreme controls, six strokes back to back on every drum: finite, peak " + worst.toFixed(3));
})();

// 6. open tone at the drum's tuning at Tune 0
(function () {
    function zcHz(x, t0, t1) { var n = 0, a = 0, b = 0; for (var i = Math.round(t0 * SR) + 1; i < Math.round(t1 * SR); i++) if (x[i - 1] < 0 && x[i] >= 0) { if (!n) a = i; b = i; n++; } return (n - 1) * SR / (b - a); }
    for (var d = 0; d < 3; d++) {
        var e = mk(VOICE, { drum: d, stroke: 0, vel: 0.8 }); e.set("trg", ++count);
        var x = e.run(0.7)[0], f = zcHz(x, 0.25, 0.6);
        check(Math.abs(1200 * Math.log2(f / F1[d])) < 40, NAMES[d] + " open at Tune 0: ~" + f.toFixed(1) + " Hz (zero crossings), want " + F1[d]);
    }
})();

// 7. conga_voice_midi.js: any note, velocity, running status, wheel, note-offs ignored
(function () {
    var src = fs.readFileSync(path.join(__dirname, "../m4l/conga_voice_midi.js"), "utf8"), out = [];
    var m = new Function("outlet", src + "\nreturn { msg_int: msg_int };")(function () { out.push([].slice.call(arguments)); });
    function send() { [].slice.call(arguments).forEach(function (b) { m.msg_int(b); }); }
    send(0x90, 61, 127);
    check(out.length === 3 && out[0][1] === "vel" && out[0][2] === 1 && out[1][1] === "trg" && out[1][2] === 1 && out[2][0] === 1 && out[2][1] === "hit",
          "note 61 -> vel 1, trg 1, display hit: " + JSON.stringify(out));
    out.length = 0; send(0x80, 61, 0);
    check(out.length === 0, "note-off is ignored");
    out.length = 0; send(0x91, 20, 64, 99, 100);
    check(out.filter(function (o) { return o[1] === "trg"; }).map(function (o) { return o[2]; }).join() === "2,3", "running status: notes 20 and 99 -> trg 2, 3");
    out.length = 0; send(0xB0, 1, 127);
    check(out.length === 1 && out[0][1] === "mw" && out[0][2] === 1, "CC1 127 -> mw 1");
    out.length = 0; send(0x90, 60, 0);
    check(out.length === 0, "note-on velocity 0 is a note-off");
})();

console.log(fails ? fails + " FAILED" : "all passed");
process.exit(fails ? 1 : 0);
