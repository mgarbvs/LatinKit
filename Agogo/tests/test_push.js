// node tests/test_push.js — pure helpers of m4l/agogo_push.js (push_kit.js is stubbed out)
"use strict";
const assert = require("assert");
global.include = () => {};
const p = require("../m4l/agogo_push.js");
assert.ok(Math.abs(p.ringEnv(0, 100, 0, false) - 1) < 1e-9);
assert.ok(p.ringEnv(0.5, 200, 0, false) > p.ringEnv(0.5, 100, 0, false));   // more Decay rings longer
assert.ok(p.ringEnv(0.5, 100, 0, false) > p.ringEnv(0.5, 100, 1, false));   // the high bell rings longer than the low
assert.ok(p.ringEnv(0.2, 100, 0, true) < p.ringEnv(0.2, 100, 0, false));    // a muted bell dies faster
assert.ok(Math.abs(p.ringCycles(12, 0) / p.ringCycles(0, 0) - 2) < 1e-9);   // an octave up = twice the cycles
const q = p.BELLS[0].p[11];                                                   // a high mode
assert.ok(p.modeDb(q, false, 100, 50, 10000) > p.modeDb(q, false, 0, 50, 10000));   // Tone up lifts the highs
assert.ok(p.modeDb(q, false, 50, 100, 10000) > p.modeDb(q, false, 50, 0, 10000));   // Touch up lets more through
const src = require("fs").readFileSync(__dirname + "/../scripts/build_voice.py", "utf8");
const at = p.PK_BANKS.map(b => src.indexOf('("' + b + '", ['));
assert.ok(at.every(i => i >= 0) && at.every((v, i) => !i || at[i - 1] < v), "PK_BANKS must match PUSH_BANKS");
console.log("push view: all pass");
