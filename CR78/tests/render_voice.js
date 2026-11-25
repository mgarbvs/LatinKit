// render_voice.js <slot> <gate-param|-> <seconds> <out.wav> [param=value ...] — one hit through the generated engine, mono 16-bit, for A/B against references.
var M = require("./cr_measure.js"), fs = require("fs");
var a = process.argv.slice(2), slot = a[0], gate = a[1], sec = +a[2], out = a[3], params = {};
a.slice(4).forEach(function (kv) { var p = kv.split("="); params[p[0]] = +p[1]; });
var ev = [{ t: 0.01, hit: M.SLOTS[slot], vel: 100 }];
if (gate !== "-") { var on = {}, off = {}; on[gate] = 1; off[gate] = 0; ev.push({ t: 0.01, set: on }, { t: 0.01 + sec, set: off }); }
var x = M.render(params, ev, sec + 0.3).l, n = x.length, b = Buffer.alloc(44 + 2 * n);
b.write("RIFF", 0); b.writeUInt32LE(36 + 2 * n, 4); b.write("WAVEfmt ", 8); b.writeUInt32LE(16, 16); b.writeUInt16LE(1, 20); b.writeUInt16LE(1, 22);
b.writeUInt32LE(M.SR, 24); b.writeUInt32LE(2 * M.SR, 28); b.writeUInt16LE(2, 32); b.writeUInt16LE(16, 34); b.write("data", 36); b.writeUInt32LE(2 * n, 40);
var pk = M.peakOf(x) || 1; for (var i = 0; i < n; i++) b.writeInt16LE(Math.round(32767 * 0.9 * x[i] / pk), 44 + 2 * i);
fs.writeFileSync(out, b);
