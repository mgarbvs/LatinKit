// node tests/render_strokes.js <out.wav> <hits> <seconds> [param=value ...] -- renders hits through the Node shim: mono 32-bit float WAV, NOT normalised.
// <hits> = "drum:stroke:vel@t,..." (t in seconds). BONGO_CODE=<file.genexpr> renders that code instead of m4l/Bongo.maxpat.
var fs = require("fs"), path = require("path"), S = require("./gen_shim.js");
var a = process.argv.slice(2), out = a[0], hits = a[1].split(",").map(function (h) { var m = h.match(/^(\d+):(\d+):([\d.]+)@([\d.]+)$/); return { d: +m[1], s: +m[2], vel: +m[3], t: +m[4] }; });
var sec = +a[2], params = a.slice(3);
var e = new S.Engine(S.loadCode(process.env.BONGO_CODE || path.join(__dirname, "../m4l/Bongo.maxpat")));
params.forEach(function (kv) { var p = kv.split("="); e.set(p[0], +p[1]); });
var n = Math.round(sec * S.SR), x = new Float32Array(n), cnt = 0, k = 0, peak = 0;
hits.sort(function (p, q) { return p.t - q.t; });
for (var i = 0; i < n; i++) {
    while (k < hits.length && hits[k].t * S.SR <= i) { e.set("drum", hits[k].d); e.set("stroke", hits[k].s); e.set("vel", hits[k].vel); e.set("trg", ++cnt); k++; }
    e.tick(); x[i] = e.st.out1; peak = Math.max(peak, Math.abs(e.st.out1));
}
var b = Buffer.alloc(44 + n * 4);
b.write("RIFF", 0); b.writeUInt32LE(36 + n * 4, 4); b.write("WAVEfmt ", 8); b.writeUInt32LE(16, 16); b.writeUInt16LE(3, 20); b.writeUInt16LE(1, 22);
b.writeUInt32LE(S.SR, 24); b.writeUInt32LE(S.SR * 4, 28); b.writeUInt16LE(4, 32); b.writeUInt16LE(32, 34); b.write("data", 36); b.writeUInt32LE(n * 4, 40);
for (i = 0; i < n; i++) b.writeFloatLE(x[i], 44 + 4 * i);
fs.writeFileSync(out, b);
console.log(JSON.stringify({ peak: peak }));
