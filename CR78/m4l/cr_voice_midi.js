// cr_voice_midi.js -- notes to a CR78 single-voice device: any note plays the voice, its velocity is the accent.
// args: the engine slots the device plays (see cr_engine.py SLOTS): one, or two that `pick` chooses between (bongo 8 9 = high, low; guiro 12 13 = short, long).
// in: list <pitch> <velocity> (notein, packed) | pick <0|1>
// out 0 (engine): vl<slot> <0..1> then tr<slot> <count> (the engine plays a slot whenever its counter changes: a counter, not a gate, so a note-off and
//                 the next note-on in one audio block can't swallow the hit); the guiro's slots also get gt<slot> 1 / 0 while a note is held
// out 1 (display): hit <note> <velocity 0..1>
inlets = 1;
outlets = 2;
var SLOTS = [];
for (var i = 1; i < jsarguments.length; i++) SLOTS.push(Number(jsarguments[i]));
var GUIRO = SLOTS[0] === 12;
var cur = 0, count = 0, held = [];

function pick(i) { cur = Math.max(0, Math.min(SLOTS.length - 1, Math.round(i))); }

function list(p, v) {
    var k = held.indexOf(p);
    if (k >= 0) held.splice(k, 1);
    if (v > 0) {
        held.push(p);
        var s = SLOTS[cur];
        count = (count + 1) % 65536;
        if (GUIRO) outlet(0, "gt" + s, 1);
        outlet(0, "vl" + s, Math.max(0.01, Math.min(1, v / 127)));
        outlet(0, "tr" + s, count);
        outlet(1, "hit", p, v / 127);
    } else if (GUIRO && !held.length) {
        for (var j = 0; j < SLOTS.length; j++) outlet(0, "gt" + SLOTS[j], 0);   // the last held note is up: the stroke ends
    }
}
