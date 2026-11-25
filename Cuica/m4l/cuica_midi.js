// cuica_midi.js -- MIDI to the Cuica engine: monophonic, last-note priority, one stroke per note, mod wheel (thumb), pitch bend, MPE.
// in: raw MIDI bytes from midiin (running status aware)
// out 1 (display): hit <note> <velocity 0..1>
// in (from the MPE page): mpe <0|1> (off: pressure, slide and per-note bend are ignored and reset), pbrange <semitones>
// out 0 (engine): vl <0..1>, nt <note>, lg <0|1>, hold <0|1>, tr <count>; mw <0..1>, bend <semitones>; pr <0..1>, sl <0..1>, pbn <semitones>
// Every note-on is a new stroke (tr changes: gen~ sees only the last Param value per block, so a gate edge could be lost).
// A note-on while another is held is legato (lg 1): the pitch glides from where it is instead of scooping.
// Releasing the top note while others are held returns to the one pressed last (nt only: no new stroke).
// MPE: pressure (channel or poly aftertouch), slide (CC74) and pitch bend on the sounding note's channel are per-note
// expression (pr, sl, pbn, +-pbrange st on member channels 2..16, 48 by default). Channel 1 is MPE's global channel: its pressure and slide count too
// (one voice), and its bend is the ordinary +-2 st wheel. The device sets the patcher's is_mpe, so Live sends per-note channels.
inlets = 1;
outlets = 2;
var BEND_RANGE = 2, MPE_BEND_RANGE = 48;
var stack = [], count = 0, chan = 0, status = 0, data = [], mpeOn = 1;

function noteOn(p, vel, ch) {
    var i = stack.indexOf(p);
    if (i >= 0) stack.splice(i, 1);
    var legato = stack.length > 0;
    stack.push(p);
    chan = ch;
    outlet(0, "pr", 0);   // a new finger: its expression starts fresh
    outlet(0, "pbn", 0);
    outlet(0, "vl", Math.max(0.01, Math.min(1, vel / 127)));
    outlet(0, "nt", p);
    outlet(0, "lg", legato ? 1 : 0);
    outlet(0, "hold", 1);
    count = (count + 1) % 65536;
    outlet(0, "tr", count);
    outlet(1, "hit", p, vel / 127);
}

function mpe(v) {
    mpeOn = v ? 1 : 0;
    if (!mpeOn) { outlet(0, "pr", 0); outlet(0, "sl", 0); outlet(0, "pbn", 0); }
}

function pbrange(v) { MPE_BEND_RANGE = Math.max(1, Math.min(96, v)); }

function noteOff(p) {
    var i = stack.indexOf(p);
    if (i < 0) return;
    stack.splice(i, 1);
    if (stack.length) outlet(0, "nt", stack[stack.length - 1]);
    else { outlet(0, "hold", 0); outlet(0, "pr", 0); }
}

function cc(num, val, ch) {
    if (num === 1) outlet(0, "mw", val / 127);
    else if (num === 74 && mpeOn && (ch === chan || ch === 0)) outlet(0, "sl", val / 127);
    else if (num === 123 || num === 120) { stack = []; outlet(0, "hold", 0); outlet(0, "pr", 0); }
}

function bend(lo, hi, ch) {
    var b = Math.max(-1, ((hi << 7 | lo) - 8192) / 8191);
    if (ch === 0) outlet(0, "bend", b * BEND_RANGE);
    else if (ch === chan && mpeOn) outlet(0, "pbn", b * MPE_BEND_RANGE);
}

function msg_int(b) {
    if (b >= 0xF8) return;                 // realtime
    if (b >= 0x80) { status = b < 0xF0 ? b : 0; data = []; return; }
    if (!status) return;
    data.push(b);
    var hi = status & 0xF0, ch = status & 0x0F;
    var need = hi === 0xC0 || hi === 0xD0 ? 1 : 2;
    if (data.length < need) return;
    var d0 = data[0], d1 = data[1];
    data = [];
    if (hi === 0x90 && d1 > 0) noteOn(d0, d1, ch);
    else if (hi === 0x80 || hi === 0x90) noteOff(d0);
    else if (hi === 0xB0) cc(d0, d1, ch);
    else if (hi === 0xD0 && mpeOn && (ch === chan || ch === 0) && stack.length) outlet(0, "pr", d0 / 127);
    else if (hi === 0xA0 && mpeOn && d0 === stack[stack.length - 1]) outlet(0, "pr", d1 / 127);
    else if (hi === 0xE0) bend(d0, d1, ch);
}
