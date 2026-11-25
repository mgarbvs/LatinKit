// node tests/test_push.js — pure helpers of m4l/pandeiro_push.js (push_kit.js is stubbed out)
"use strict";
const assert = require("assert");
global.include = () => {};
const p = require("../m4l/pandeiro_push.js");
assert.ok(Math.abs(p.ringEnv(0, 100) - 1) < 1e-9);
assert.ok(p.ringEnv(0.5, 200) > p.ringEnv(0.5, 100));   // more Decay rings longer
assert.ok(Math.abs(p.ringCycles(12, 0) / p.ringCycles(0, 0) - 2) < 1e-9);   // an octave up = twice the cycles
assert.ok(p.jingleKeep(300) > p.jingleKeep(100) && p.jingleKeep(100) > p.jingleKeep(30) && p.jingleKeep(30) > 0);   // more Decay, slower fade
assert.ok(p.jingleOpen(0, 3, 1, 1, 0) > 0 && p.jingleOpen(0, 3, 1, 0, 0) === 0);   // Jingles 0 = bare head
assert.strictEqual(p.jingleOpen(0, 3, 1, 1, 1), 0);                                  // a tamborim has none
assert.deepStrictEqual(p.EFF.map(r => r.length), [8, 8]);
const src = require("fs").readFileSync(__dirname + "/../scripts/build_voice.py", "utf8");
const at = p.PK_BANKS.map(b => src.indexOf('("' + b + '", ['));
assert.ok(at.every(i => i >= 0) && at.every((i, k) => !k || at[k - 1] < i), "PK_BANKS must match PUSH_BANKS");
console.log("push view: all pass");
