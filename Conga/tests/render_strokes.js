// node tests/render_strokes.js <out.wav> <hits> <seconds> [param=value ...] -- renders hits through the Node shim: mono 16-bit float-scaled WAV (left+right mean).
// <hits> = "slot:vel@t,slot:vel@t" (slot = drum*6 + stroke, t in seconds). CONGA_CODE=<file.genexpr> renders that code instead of m4l/Conga.maxpat.
// --raw writes 32-bit float instead of normalising nothing: output is NOT normalised (fit.py compares shapes; levels are asserted in test_engine.js).
var fs = require("fs"), path = require("path"), S = require("./gen_shim.js");
var a = process.argv.slice(2), out = a[0], hits = a[1].split(",").map(function (h) { var m = h.match(/^(\d+):([\d.]+)@([\d.]+)$/); return { slot: +m[1], vel: +m[2], t: +m[3] }; });
var sec = +a[2], params = a.slice(3);
var e = new S.Engine(S.loadCode(process.env.CONGA_CODE || path.join(__dirname, "../m4l/Conga.maxpat")));
params.forEach(function (kv) { var p = kv.split("="); e.set(p[0], +p[1]); });
var n = Math.round(sec * S.SR), x = new Float32Array(n), cnt = {}, k = 0, peak = 0;
hits.sort(function (p, q) { return p.t - q.t; });
for (var i = 0; i < n; i++) {
    while (k < hits.length && hits[k].t * S.SR <= i) { cnt[hits[k].slot] = (cnt[hits[k].slot] || 0) + 1; e.set("vl" + hits[k].slot, hits[k].vel); e.set("tr" + hits[k].slot, cnt[hits[k].slot]); k++; }
    e.tick(); x[i] = 0.5 * (e.st.out1 + e.st.out2); peak = Math.max(peak, Math.abs(e.st.out1), Math.abs(e.st.out2));
}
var b = Buffer.alloc(44 + n * 4);
b.write("RIFF", 0); b.writeUInt32LE(36 + n * 4, 4); b.write("WAVEfmt ", 8); b.writeUInt32LE(16, 16); b.writeUInt16LE(3, 20); b.writeUInt16LE(1, 22);
b.writeUInt32LE(S.SR, 24); b.writeUInt32LE(S.SR * 4, 28); b.writeUInt16LE(4, 32); b.writeUInt16LE(32, 34); b.write("data", 36); b.writeUInt32LE(n * 4, 40);
for (i = 0; i < n; i++) b.writeFloatLE(x[i], 44 + 4 * i);
fs.writeFileSync(out, b);
console.log(JSON.stringify({ peak: peak }));
