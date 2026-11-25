// midi_sim.js — caxixi_midi.js in a vm with a fake outlet and a fake Task on a virtual clock (and seeded Math.random): what the patch would send.
//   var J = S.load(seed); J.c.strokemode(2); J.play(60, 100) -> [{t: seconds, vel: 0..1, kind}]  (a phrase runs to its end)
var fs = require("fs"), path = require("path"), vm = require("vm");
function rng(seed) { var a = seed >>> 0; return function () { a = (a + 0x6D2B79F5) >>> 0; var t = a; t = Math.imul(t ^ t >>> 15, t | 1); t ^= t + Math.imul(t ^ t >>> 7, t | 61); return ((t ^ t >>> 14) >>> 0) / 4294967296; }; }
function load(seed) {
    var out = [], tasks = [], clock = 0, M2 = Object.create(Math); M2.random = rng(seed || 1);
    var ctx = {
        outlet: function (n) { out.push([n].concat([].slice.call(arguments, 1))); },
        Task: function (fn) { var t = { fn: fn, at: null, cancel: function () { t.at = null; }, schedule: function (ms) { t.at = clock + ms; } }; tasks.push(t); return t; },
        Math: M2, Number: Number
    };
    vm.createContext(ctx);
    vm.runInContext(fs.readFileSync(path.join(__dirname, "../m4l/caxixi_midi.js"), "utf8"), ctx);
    var J = { c: ctx, out: out, task: tasks[0] };
    // run the scheduled ticks until none is left; events: the strokes (vl, tr pairs) with the clock at which they went out
    J.play = function (p, v) {
        var ev = [], start = out.length, k;
        clock = 0; ctx.list(p, v);
        for (var guard = 0; guard < 500; guard++) {
            for (k = start; k < out.length; k++) if (out[k][1] === "hit") ev.push({ t: clock / 1000, vel: out[k][3], kind: out[k][4] });
            start = out.length;
            if (J.task.at === null) break;
            clock = J.task.at; J.task.at = null; J.task.fn();
        }
        return ev;
    };
    J.clock = function () { return clock; };
    return J;
}
module.exports = { load: load, rng: rng };
