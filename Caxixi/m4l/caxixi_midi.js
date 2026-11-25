// caxixi_midi.js -- notes to the Caxixi engine: every note-on is one stroke. Stroke menu: 0 Open (a shake), 1 Hand (the bottom struck on the palm),
// 2 FX (a shaken phrase: Length ms of strokes, Rate a second, the preview's swell in and fade out, +-20 % timing and ~3 dB level scatter; a note-off
// does not cut it, a new note restarts it). The engine's own Type is set from the same menu (the patch wires it), so this only needs to know FX.
// in: list <pitch> <velocity> (notein, packed) | strokemode <0..2> | length <ms> | rate <Hz>
// out 0 (engine): vl <0..1>, tr <count>   (tr last: gen~ sees only the last Param value per block, so a gate edge could be lost;
//                 a counter that changes is never lost. Two notes inside one audio block make one stroke: the second one.)
// out 1 (display): hit <note> <velocity 0..1> <stroke 0..2>
// (the Math.random calls are the whole of the scatter: tests/test_engine.js seeds them)
inlets = 1;
outlets = 2;
var count = 0, mode = 0, lenMs = 1000, rateHz = 9.3, vel = 0.8, note = 60, left = 0, idx = 0;
var task = new Task(tick, this);
// the FX phrase's level in dB re its steady level: a ramp in over the first bursts, the last two bursts falling away (measured on the 8 previews)
var RAMP = [-8.5, -3, -1.5], TAIL = [-1.5, -9];

function fire(v, kind) {
    count = (count + 1) % 65536;
    outlet(0, "vl", Math.max(0.01, Math.min(1, v)));
    outlet(0, "tr", count);
    outlet(1, "hit", note, v, kind);
}

function tick() {
    if (left <= 0) return;
    var db = -6 * Math.random() + (idx < RAMP.length ? RAMP[idx] : 0) + (left <= TAIL.length ? TAIL[TAIL.length - left] : 0);
    fire(vel * Math.pow(10, db / 20), 2);
    left--; idx++;
    if (left > 0) task.schedule(1000 / rateHz * (0.8 + 0.4 * Math.random()));
}

function strokemode(m) { mode = Math.max(0, Math.min(2, Math.round(Number(m)))); }
function length(ms) { lenMs = Math.max(300, Number(ms)); }
function rate(hz) { rateHz = Math.max(1, Number(hz)); }

function list(p, v) {
    if (v <= 0) return;
    note = p;
    vel = v / 127;
    task.cancel();
    if (mode < 2) { left = 0; fire(vel, mode); return; }
    left = Math.max(1, Math.round(lenMs / 1000 * rateHz));
    idx = 0;
    tick();
}
