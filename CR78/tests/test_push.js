// node tests/test_push.js — pure helpers of m4l/cr_voice_push.js (push_kit.js is stubbed out) and its banks against build_voices.py
"use strict";
const assert = require("assert");
global.include = () => {};
global.jsarguments = ["cr_voice_push.js"];
const p = require("../m4l/cr_voice_push.js");
const near = (a, b) => Math.abs(a - b) < 1e-9;
assert.ok(near(p.expEnv(0, 100, 1), 1) && near(p.expEnv(100, 100, 1), 0.1));   // 1/10 amplitude at the table time
assert.ok(p.expEnv(50, 100, 2) > p.expEnv(50, 100, 1));                          // more Decay rings longer
assert.ok(near(p.linEnv(50, 50, 1), 0.1) && p.linEnv(60, 50, 1) === 0);         // the metal ramp: 1/10 at td, then gone
assert.ok(near(p.accGain(0, 0.2), 1) && near(p.accGain(100, 100 / 127), 1));      // Accent 0: flat; 100: velocity 100 = unity
assert.ok(near(p.driveCurve(1, 50), 1) && near(p.driveCurve(0, 50), 0));
assert.ok(p.driveCurve(0.3, 100) > p.driveCurve(0.3, 0));                         // Drive bends the curve up
assert.ok(near(p.bp(1000, 1000, 5), 1) && p.bp(2000, 1000, 5) < 0.5);
assert.ok(p.ringQ(1000, 100, 2) > p.ringQ(1000, 100, 1));
const banks = JSON.parse(require("child_process").execFileSync("python3", [__dirname + "/../scripts/build_voices.py", "--push-banks"]));
assert.deepStrictEqual(Object.keys(banks).sort(), Object.keys(p.SPEC).sort());
for (const v of Object.keys(banks)) assert.deepStrictEqual(p.bankFor(v), banks[v], v + ": bank differs from build_voices.py push_bank()");
assert.deepStrictEqual(p.PK_BANKS, ["Voice"]);
console.log("push view: all pass");
