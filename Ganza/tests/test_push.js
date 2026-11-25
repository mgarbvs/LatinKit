// node tests/test_push.js — pure helpers of m4l/ganza_push.js (push_kit.js is stubbed out)
"use strict";
const assert = require("assert");
global.include = () => {};
const p = require("../m4l/ganza_push.js");
const e = p.envShape(20, 5, 0, 1, 120);
assert.ok(Math.abs(Math.max(...e) - 1) < 1e-9 && e[0] === 0);                       // peak 1, starts silent
assert.ok(p.envShape(60, 5, 0, 1, 120)[100] > e[100]);                                // more Damping, more left at the tail
assert.ok(p.envShape(20, 40, 0, 1, 120).indexOf(1) > e.indexOf(1));                   // more Shake, a later peak
assert.ok(e.every(v => v >= 0 && v <= 1 + 1e-9) && p.envShape(20, 20, 0.2, 150, 120).every(v => isFinite(v)));
assert.ok(p.hash(3, 1) >= 0 && p.hash(3, 1) < 1 && p.hash(3, 1) === p.hash(3, 1));
assert.strictEqual(p.SYS.length, 2);
const src = require("fs").readFileSync(__dirname + "/../scripts/build_maxpat.py", "utf8");
const at = p.PK_BANKS.map(b => src.indexOf('("' + b + '", ['));
assert.ok(at.every(i => i >= 0) && at[0] < at[1], "PK_BANKS must match PUSH_BANKS");
console.log("push view: all pass");
