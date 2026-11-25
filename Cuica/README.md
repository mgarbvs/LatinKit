# Cuica

Max for Live instrument: a Brazilian friction drum. Spec: `docs/SPEC.md`. Research (sources, what is and is not known): `docs/RESEARCH.md`.

- One stroke per note, like a drum: the rub swells and fades over 3/4 of Stroke however long the key is held. Alt decides which
  notes are pulls (Pull st higher, 0 by default since real pushes and pulls sound alike; a little louder), like the hand going back and forth on the rod: Auto (default) alternates
  quick notes (within one Stroke of the last) and starts again on a push after a pause; On alternates every note; Off never. Monophonic, last-note priority; an overlapping note glides over instead of scooping.
- Mod wheel = thumb pressing the head, pitch bend +-2 st.
- MPE (the patcher's is_mpe is set, so Live sends per-note channels): pressure (or channel/poly aftertouch) keeps rubbing for as
  long as it is held, harder = faster; slide (CC74) is the thumb; per-note bend +-48 st. Channel 1 (MPE's global channel) pressure
  and slide count too. The MPE button in the display's corner flips it to the MPE page: MPE on/off, per-note Bend range (48 st),
  Pressure (how strongly pressure rubs on, 100 %), Slide (Off / Thumb / Head / Tone / Grip). In Live the harness can only send expression on channel 1, so per-note bend is tested in standalone Max only.
- Each stroke moves like a real one (measured, docs/SPEC.md rounds 5-6): a scrape before the pitch locks, Scoop riding the stroke into the note (the squeak), a sag and a creak as the rub dies, then the head ringing on for Decay. Since round 6 the sag, creak and grip's pitch come out of a friction model, not a script.
- Pressure is the cloth's grip: as on a real cuica, a harder grip lowers the note (in tune up to the default, ~50 ct flat at full) and makes slow rubs creak and break up. Rasp is how wild the rub gets.
- Engine (`scripts/cuica_engine.py` -> gen~): the cloth's friction on the rod (a hyperbolic friction law solved in closed form against 3 head modes) through the head's first mode (a resonant low-pass at max(note, Head Hz), fitted to the Latin Percussion pack's cuica samples with tests/analyze.py), 3 quiet inharmonic membrane resonators; strokes of
  Stroke ms alternate push and pull (Pull semitones higher).
- Panel: 13 live.dials (Tune, Pressure, Speed, Stroke, Pull, Scoop, Glide, Thumb, Head, Rasp, Tone, Decay, Volume).

Build and test:

    ./build.sh      # generate, GenExpr grammar check, validate, Node tests, build m4l/Cuica.amxd (--type iiii)
    uv run --directory $MAXTEST_DIR python $PWD/tests/test_max_render.py [--demo]   # real standalone Max; --demo writes docs/demo.wav

Stroke shape vs real cuicas: `python3 tests/test_strokes.py` (in build.sh); `tests/stroke_shape.py <wav>` measures any recording.

Checked in Live (scripts/live_check.py). A/B against the pack's cuica previews: docs/compare/ (ours_* = this engine; ref_* = the pack's Samples/Combined cuicas rendered through Live, local only and gitignored since they are Ableton's audio).
