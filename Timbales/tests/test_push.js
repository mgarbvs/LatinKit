// node tests/test_push.js — pure helpers of m4l/timbales_push.js (push_kit.js is stubbed out)
"use strict";
const assert = require("assert");
global.include = () => {};
const p = require("../m4l/timbales_push.js");
assert.ok(Math.abs(p.env(0, 100, 4.5) - 1) < 1e-9);
assert.ok(p.env(0.5, 200, 6) > p.env(0.5, 100, 6));   // more Ring / Decay lasts longer
assert.ok(Math.abs(p.ringCycles(12, 0) / p.ringCycles(0, 0) - 2) < 1e-9);   // an octave up = twice the cycles
assert.ok(p.ringCycles(0, 0) > p.ringCycles(0, 1));   // the high drum is the higher
assert.ok(p.clickWidth(100) < p.clickWidth(0));   // harder stick = sharper click
assert.ok(p.contact(2, 0, 0, 10, 10).shell && p.contact(3, 0, 0, 10, 10).y > p.contact(2, 0, 0, 10, 10).y);   // paila lower than cascara
assert.ok(!p.contact(0, 0, 0, 10, 10).shell);
assert.strictEqual(p.AT.length, 6);
const src = require("fs").readFileSync(__dirname + "/../scripts/build_voice.py", "utf8");
const at = p.PK_BANKS.map(b => src.indexOf('("' + b + '", ['));
assert.ok(at.every(i => i >= 0) && at[0] < at[1], "PK_BANKS must match PUSH_BANKS");
console.log("push view: all pass");
