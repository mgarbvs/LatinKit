// node tests/test_push.js — pure helpers of m4l/repinique_push.js (push_kit.js is stubbed out)
"use strict";
const assert = require("assert");
global.include = () => {};
const p = require("../m4l/repinique_push.js");
assert.ok(Math.abs(p.ringEnv(0, 100, 1) - 1) < 1e-9);
assert.ok(p.ringEnv(0.5, 200, 1) > p.ringEnv(0.5, 100, 1));   // more Decay rings longer
assert.ok(p.ringEnv(0.5, 100, 1) > p.ringEnv(0.5, 100, p.RING[4]));   // a Mute rings shorter than an Open
assert.ok(Math.abs(p.ringCycles(12) / p.ringCycles(0) - 2) < 1e-9);   // an octave up = twice the cycles
assert.ok(p.skinAmp(4.4, 100) > p.skinAmp(4.4, 0));          // Skin brightens the overtones
assert.ok(Math.abs(p.skinAmp(1, 100) - p.skinAmp(1, 0)) < 1e-9);   // the tilt pivots on the open tone
assert.ok(p.pulse(0.5) > 0.99 && p.pulse(0) < 1e-9);
const src = require("fs").readFileSync(__dirname + "/../scripts/build_voice.py", "utf8");
const at = p.PK_BANKS.map(b => src.indexOf('("' + b + '", ['));
assert.ok(at.every(i => i >= 0) && at.every((i, k) => !k || at[k - 1] < i), "PK_BANKS must match PUSH_BANKS");
console.log("push view: all pass");
