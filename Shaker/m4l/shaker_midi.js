// shaker_midi.js -- notes to the Shaker engine: every note-on is one stroke. Direction menu: 0 Key (the note's parity: even = forward, odd = back),
// 1 Alternate (each new stroke flips: forward, back, ...), 2 Forward, 3 Back. Roll > 0 keeps a held note shaking, that many strokes per second,
// alternating direction (Key and Alternate; Forward and Back stay put).
// in: list <pitch> <velocity> (notein, packed) | roll <Hz> (the Roll box; 0 = off) | direction <0..3>
// out 0 (engine): vl <0..1>, dir <0|1>, tr <count>   (tr last: gen~ sees only the last Param value per block, so a gate edge could be lost;
//                 a counter that changes is never lost. Two notes inside one audio block make one stroke: the second one.)
// out 1 (display): hit <note> <velocity 0..1> <dir>
inlets = 1;
outlets = 2;
var count = 0, held = [], rollHz = 0, mode = 0, dir = 1, vel = 0.8, note = 60;
var task = new Task(tick, this);

function stroke(d) {
    dir = d;
    count = (count + 1) % 65536;
    outlet(0, "vl", Math.max(0.01, Math.min(1, vel)));
    outlet(0, "dir", d);
    outlet(0, "tr", count);
    outlet(1, "hit", note, vel, d);
}

function tick() {
    if (!held.length || rollHz <= 0) return;
    stroke(mode > 1 ? mode - 2 : 1 - dir);
    task.schedule(1000 / rollHz);   // schedule, not repeat(): when repeat's first call happens is not documented
}

function arm() {
    task.cancel();
    if (held.length && rollHz > 0) task.schedule(1000 / rollHz);
}

function direction(m) { mode = Math.max(0, Math.min(3, Math.round(Number(m)))); }

function roll(hz) {
    rollHz = Math.max(0, Number(hz));
    arm();
}

function list(p, v) {
    var i = held.indexOf(p);
    if (i >= 0) held.splice(i, 1);
    if (v > 0) {
        held.push(p);
        note = p;
        vel = v / 127;
        stroke(mode === 0 ? p % 2 : mode > 1 ? mode - 2 : 1 - dir);
    } else if (held.length) note = held[held.length - 1];
    arm();
}
