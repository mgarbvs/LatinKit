// render_demo.js — renders docs/demo.wav: an 8-bar CR-78-ish Latin pattern (clave, rimshot, bongos, conga, cowbell, maracas, guiro,
// tambourine, hat, bass drum, cymbal) through the generated gen~ code in Node, 16-bit 48 kHz stereo. Not a transcription of a factory pattern.
var M = require("./cr_measure.js");
var fs = require("fs");
var path = require("path");
var SR = M.SR, BPM = 104, STEP = 60 / BPM / 4, BAR = 16 * STEP, BARS = 8;
var S = M.SLOTS, ev = [];

// [voice, steps (16ths in a bar), velocity or [velocities], first bar (0-based), length in steps for guiro]
var parts = [
    ["cl", [0, 3, 6, 10, 12], 100, 0],                       // 3-2 son clave
    ["ma", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], [95, 55, 70, 55], 0],
    ["rs", [4, 12], 85, 1],                                  // cross-stick on 2 and 4
    ["lb", [0, 4, 8, 12], 90, 1], ["hb", [2, 5, 6, 10, 13, 14], [80, 100, 70], 1],   // bongo martillo
    ["bd", [0, 6, 8, 14], [110, 90, 100, 85], 2],            // bossa kick
    ["hh", [0, 2, 4, 6, 8, 10, 12, 14], [90, 60], 2],
    ["lc", [4, 7, 8, 12, 15], [100, 70, 90, 100, 75], 2],    // tumbao
    ["cb", [0, 4, 6, 8, 12, 14], [100, 70], 3],
    ["tb", [4, 12, 15], [100, 85, 60], 4],
    ["guH", [0, 8], 100, 4, 2], ["guL", [4, 12], 100, 4, 3],
    ["mb", [14], 80, 5]
];
parts.forEach(function (p) {
    for (var bar = p[3]; bar < BARS; bar++) {
        p[1].forEach(function (st, i) {
            var v = Array.isArray(p[2]) ? p[2][i % p[2].length] : p[2], t = 0.1 + bar * BAR + st * STEP;
            ev.push({ t: t, hit: S[p[0]], vel: v });
            if (p[4]) {   // guiro: the note length is the stroke
                var g = p[0] === "guH" ? "gt12" : "gt13", set = {}, off = {};
                set[g] = 1; off[g] = 0;
                ev.push({ t: t, set: set }, { t: t + p[4] * STEP * 0.95, set: off });
            }
        });
    }
});
ev.push({ t: 0.1 + 4 * BAR, hit: S.cy, vel: 110 });         // cymbal at the top of bar 5
ev.push({ t: 0.1 + 7 * BAR + 14 * STEP, hit: S.sd, vel: 110 }, { t: 0.1 + 7 * BAR + 15 * STEP, hit: S.sd, vel: 90 });   // a snare fill at the end
var pans = { bdPan: 0, hhPan: -25, cyPan: 20, maPan: 35, cbPan: -20, hbPan: -30, lbPan: -35, lcPan: 25, clPan: 15, tbPan: 30, guPan: -15, rsPan: 10, sdPan: 0, mbPan: 10 };
var params = Object.assign({ tbShake: 1, hatTone: 0 }, pans);
var out = M.render(params, ev, 0.1 + BARS * BAR + 1.5), n = out.l.length, peak = Math.max(M.peakOf(out.l), M.peakOf(out.r)), g = 0.9 / peak;
var buf = Buffer.alloc(44 + n * 4);
buf.write("RIFF", 0); buf.writeUInt32LE(36 + n * 4, 4); buf.write("WAVEfmt ", 8); buf.writeUInt32LE(16, 16); buf.writeUInt16LE(1, 20); buf.writeUInt16LE(2, 22);
buf.writeUInt32LE(SR, 24); buf.writeUInt32LE(SR * 4, 28); buf.writeUInt16LE(4, 32); buf.writeUInt16LE(16, 34); buf.write("data", 36); buf.writeUInt32LE(n * 4, 40);
for (var i = 0; i < n; i++) { buf.writeInt16LE(Math.round(out.l[i] * g * 32767), 44 + i * 4); buf.writeInt16LE(Math.round(out.r[i] * g * 32767), 46 + i * 4); }
var file = path.join(__dirname, "../docs/demo.wav");
fs.writeFileSync(file, buf);
console.log(file + ": " + (n / SR).toFixed(1) + " s, " + BPM + " BPM, normalised x" + g.toFixed(2) + " to -0.9 peak");
