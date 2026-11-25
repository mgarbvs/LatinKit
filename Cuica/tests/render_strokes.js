// node tests/render_strokes.js <out.wav> <note> [param=value ...] -- 0.1 s of silence, then two strokes 0.4 s apart through the
// Node shim (mono 16-bit WAV), for tests/stroke_shape.py. STROKES=n repeats the pair (every stroke differs, as on a real cuica).
var fs = require("fs"), path = require("path"), S = require("./gen_shim.js");
var e = new S.Engine(S.loadCode(path.join(__dirname, "../m4l/Cuica.maxpat"))), a = process.argv, n = +a[3], c = 0, out = new Array(S.SR / 10).fill(0);
a.slice(4).forEach(function (kv) { var p = kv.split("="); e.set(p[0], +p[1]); });
function stroke(sec) {
    e.set("nt", n); e.set("vl", 0.8); e.set("lg", 0); e.set("hold", 1); e.set("tr", ++c);
    out = out.concat(Array.from(e.run(0.25)[0])); e.set("hold", 0); out = out.concat(Array.from(e.run(sec)[0]));
}
for (var k = 0; k < (+process.env.STROKES || 2); k += 2) { stroke(0.15); stroke(0.5); }
var b = Buffer.alloc(44 + out.length * 2);
b.write("RIFF", 0); b.writeUInt32LE(36 + out.length * 2, 4); b.write("WAVEfmt ", 8); b.writeUInt32LE(16, 16); b.writeUInt16LE(1, 20);
b.writeUInt16LE(1, 22); b.writeUInt32LE(S.SR, 24); b.writeUInt32LE(S.SR * 2, 28); b.writeUInt16LE(2, 32); b.writeUInt16LE(16, 34);
b.write("data", 36); b.writeUInt32LE(out.length * 2, 40);
out.forEach(function (v, i) { b.writeInt16LE(Math.max(-32767, Math.min(32767, Math.round(v * 32767))), 44 + 2 * i); });
fs.writeFileSync(a[2], b);
