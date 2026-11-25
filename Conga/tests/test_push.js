// node tests/test_push.js — pure helpers of m4l/conga_voice_push.js (push_kit.js is stubbed out)
"use strict";
const assert = require("assert");
global.include = () => {};
const p = require("../m4l/conga_voice_push.js");
assert.ok(Math.abs(p.ringEnv(0, 100, 1) - 1) < 1e-9);
assert.ok(p.ringEnv(0.5, 200, 1) > p.ringEnv(0.5, 100, 1));   // more Decay rings longer
assert.ok(p.ringEnv(0.5, 100, 2) > p.ringEnv(0.5, 100, 0));     // the tumba rings longer than the quinto
assert.ok(Math.abs(p.ringCycles(12, 1) / p.ringCycles(0, 1) - 2) < 1e-9);   // an octave up = twice the cycles
assert.strictEqual(p.SPOT.length, 6);
const src = require("fs").readFileSync(__dirname + "/../scripts/build_voice.py", "utf8");
const at = p.PK_BANKS.map(b => src.indexOf('("' + b + '", ['));
assert.ok(at.every(i => i >= 0) && at[0] < at[1], "PK_BANKS must match PUSH_BANKS");
console.log("push view: all pass");
