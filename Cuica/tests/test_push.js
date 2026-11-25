// node tests/test_push.js — pure helpers of m4l/cuica_push.js (push_kit.js is stubbed out)
"use strict";
const assert = require("assert");
global.include = () => {};
const p = require("../m4l/cuica_push.js");
assert.strictEqual(p.scoopLeft(0), 1);                                      // a stroke starts a full scoop away
assert.strictEqual(p.scoopLeft(0.6), 0);                                    // and arrives at 60 % of it
assert.strictEqual(p.flatCents(55), 0);                                     // the default Pressure is in tune
assert.ok(p.flatCents(100) > p.flatCents(70) && p.flatCents(70) > 0);       // harder grip, flatter
assert.ok(Math.abs(p.thumbRise(1, 12, 60) - 12) < 1e-6);                    // the wheel's rise settles
assert.ok(p.thumbRise(0.05, 12, 500) < p.thumbRise(0.05, 12, 60));          // slower Glide, slower rise
assert.ok(p.headDb(250 * 4, 1) > p.headDb(250, 1) && p.headDb(1000, 1) > 25);   // Head 100 %: peak at 1 kHz
assert.ok(p.toneDb(5000, 0.5, 1) > p.toneDb(5000, 0.5, 0));                 // Tone up lets the highs through
const src = require("fs").readFileSync(__dirname + "/../scripts/build_maxpat.py", "utf8");
const at = p.PK_BANKS.map(b => src.indexOf('("' + b + '", ['));
assert.ok(at.every(i => i >= 0) && at.every((v, i) => !i || at[i - 1] < v), "PK_BANKS must match PUSH_BANKS");
console.log("push view: all pass");
