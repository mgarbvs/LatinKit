// guiro_midi.js -- notes to the Guiro engine: every note-on is one stroke. Stroke menu: 0 Key (the note picks the stroke: pitch mod 4 = Up, Down,
// Long, Top: C3 Up, C#3 Down, D3 Long, D#3 Top, E3 Up again ...), 1 Up, 2 Down, 3 Long, 4 Top (always that stroke: for a Drum Rack pad, which sends one
// fixed note), 5 Alternate (Up, Down, Up ... on every new note). Roll > 0 keeps a held note scraping, that many strokes per second: Up / Down strokes
// alternate (Key and Alternate), Long and Top and the fixed menu entries repeat the same stroke.
// in: list <pitch> <velocity> (notein, packed) | roll <Hz> (the Roll box; 0 = off) | strokemode <0..5>
// out 0 (engine): stk <0..3>, vl <0..1>, tr <count>   (tr last: gen~ sees only the last Param value per block, so a gate edge could be lost;
//                 a counter that changes is never lost. Two notes inside one audio block make one stroke: the second one.)
// out 1 (display): hit <note> <velocity 0..1> <stroke 0..3>
inlets = 1;
outlets = 2;
var count = 0, held = [], rollHz = 0, mode = 0, last = 1, vel = 0.8, note = 60, kind = 0;   // last: the last Up / Down stroke (0 Up, 1 Down)
var task = new Task(tick, this);

function stroke(k) {
    kind = k;
    if (k < 2) last = k;
    count = (count + 1) % 65536;
    outlet(0, "stk", k);
    outlet(0, "vl", Math.max(0.01, Math.min(1, vel)));
    outlet(0, "tr", count);
    outlet(1, "hit", note, vel, k);
}

function tick() {
    if (!held.length || rollHz <= 0) return;
    stroke(kind < 2 && (mode === 0 || mode === 5) ? 1 - last : kind);
    task.schedule(1000 / rollHz);   // schedule, not repeat(): when repeat's first call happens is not documented
}

function arm() {
    task.cancel();
    if (held.length && rollHz > 0) task.schedule(1000 / rollHz);
}

function strokemode(m) { mode = Math.max(0, Math.min(5, Math.round(Number(m)))); }

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
        stroke(mode === 0 ? p % 4 : mode === 5 ? 1 - last : mode - 1);
    } else if (held.length) note = held[held.length - 1];
    arm();
}
