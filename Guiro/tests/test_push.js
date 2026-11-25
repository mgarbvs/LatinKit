// node tests/test_push.js — pure helpers of m4l/guiro_push.js (push_kit.js is stubbed out)
"use strict";
const assert = require("assert");
global.include = () => {};
const p = require("../m4l/guiro_push.js");
assert.strictEqual(p.ridgeCount(0, 100), 12);
assert.ok(p.ridgeCount(0, 400) > p.ridgeCount(0, 100) && p.ridgeCount(1, 25) >= 3 && p.ridgeCount(1, 400) <= 40);
assert.strictEqual(p.strokeMs(2, 450, 100), 450);
assert.strictEqual(p.strokeMs(2, 450, 200), 225);   // twice the Speed, half the stroke
assert.ok(p.strokeMs(0, 450, 100) < p.strokeMs(1, 450, 100));
const src = require("fs").readFileSync(__dirname + "/../scripts/build_maxpat.py", "utf8");
const at = p.PK_BANKS.map(b => src.indexOf('("' + b + '", ['));
assert.ok(at.every(i => i >= 0) && at[0] < at[1], "PK_BANKS must match PUSH_BANKS");
console.log("push view: all pass");
