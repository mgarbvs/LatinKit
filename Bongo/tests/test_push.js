// node tests/test_push.js — pure helpers of m4l/bongo_push.js (push_kit.js is stubbed out)
"use strict";
const assert = require("assert");
global.include = () => {};
const p = require("../m4l/bongo_push.js");
assert.ok(Math.abs(p.ringEnv(0, 100) - 1) < 1e-9);
assert.ok(p.ringEnv(0.5, 200) > p.ringEnv(0.5, 100));   // more Decay rings longer
assert.ok(Math.abs(p.ringCycles(12, 1) / p.ringCycles(0, 1) - 2) < 1e-9);   // an octave up = twice the cycles
assert.ok(p.partial(100, 3) > p.partial(0, 3));   // more Skin = brighter overtones
assert.ok(p.partial(50, 0) > p.partial(50, 4));
assert.strictEqual(p.SPOT.length, 7);
const src = require("fs").readFileSync(__dirname + "/../scripts/build_voice.py", "utf8");
const at = p.PK_BANKS.map(b => src.indexOf('("' + b + '", ['));
assert.ok(at.every(i => i >= 0) && at[0] < at[1], "PK_BANKS must match PUSH_BANKS");
console.log("push view: all pass");
