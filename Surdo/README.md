# Surdo

A modal surdo (samba bass drum) for Max for Live: one drum per instance, four strokes (**Open**, **Mute**, **Rim**, **Finger**), one gen~. Forked from Bongo (same panel, same engine structure, same fit pipeline) and fitted to the Latin Percussion pack's surdo takes: the 86 Hz open tone and its pitch glide, the mode set, the ring and the damping were measured from those recordings (`docs/SPEC.md`).

## Playing
`m4l/Surdo.amxd` (180 x 169, the Bongo / Conga Voice layout): any MIDI note plays it, velocity is strength, the mod wheel (CC1) presses the head. A **Stroke** menu (Open, Mute, Rim, Finger) chooses what it plays; it is automatable and may be changed between hits (the new stroke's hand damps the ring already on the head). Mono output; note-offs are ignored. One drum per instance: the larger and smaller surdos (1a / 2a / 3a) are **Tune**, not a menu (the clips contain one drum only; the sizes themselves are not measured).

| Parameter | Range | Default | Notes |
|---|---|---|---|
| Stroke | 0 Open, 1 Mute, 2 Rim, 3 Finger | 0 | Open: mallet in the middle, the 86 Hz boom; Mute: the other hand on the head, a thud; Rim: stick on the rim, a crack over a 73 Hz tone; Finger: a tap, a soft click and a sub thump |
| Tune | -12..12 st | 0 | the head (open tone 86.0 Hz at 0) |
| Decay | 30..300 % | 100 | head ring time (the Open's 86 Hz falls 40 dB in about 0.7 s) |
| Skin | 0..100 % | 50 | +-6 dB/oct tilt of the overtones |
| Touch | 0..100 % | 50 | contact hardness: brighter, more tick |
| Press | 0..12 st | 5 | mod wheel range |
| Vary | 0..100 % | 100 | hit-to-hit variation: each head tone's level nudged at random (about 1.5 dB at 100 %); 0 repeats the same sinusoids |
| Volume | -36..6 dB | -9 | |

There is no Drum menu, no Flam and no Shell (Bongo's 125 Hz body): the recordings have one drum, and no fixed-Hz body tone. The Open's pitch **glide** is not a control: the tone starts sharp and falls to 86 Hz in about a quarter of a second, more for harder hits (read as in the recording, f 40-100 ms against f 200-290 ms: 38 ct at velocity 0.9, the recording's 37 ct; 6 ct at velocity 0.3).

Panel: the surdo in orange line art, the mallet or hand where the stroke is played, its name, a flash on every hit; Stroke menu; boxes Skin, Touch, Press, Vary; dials Tune, Decay, Volume. Hover text on everything. Screenshot (Live): `docs/panel_live_idle.png`.

## Surdo Musical
`m4l/SurdoMusical.amxd` ("Surdo Musical"): the same drum and panel, but **the MIDI key is the pitch**. The Open's settled fundamental is `mtof(note) x 2^(Tune/12)` (note 41 = F2, 87.3 Hz at Tune 0; the plain Surdo is fixed at 86.0 Hz whatever the key). Every head mode, the Open's strike glide and the mod-wheel Press move with it exactly as they do with Tune; the noise bands and contact filter stay at fixed Hz (as they do with Tune), and head modes that would pass 0.45 x samplerate are muted. **Tune** keeps its +-12 st range and adds to the key in semitones (key 41 + 7 st = key 48). Still mono, a new note is a new hit (the ring left on the head is retuned to the new key and damped by the stroke), velocity, CC1, Stroke and the other parameters work as in Surdo, note-offs are ignored. Pitch is exact from the lowest keys tried (16, 20.6 Hz) up to key 108 (4.2 kHz); musically it is a bass instrument, keys 28-72 (41-523 Hz) are where the head still reads as a drum (not judged by ear). The default key before any note is 41. Same engine (`surdo_engine.code(musical=True)`) and generator (`build_voice.py --musical`); `m4l/Surdo.amxd` is unchanged byte for byte. `docs/musical_demo.wav` (13.5 s): a samba-feel bass line in D dorian (muted root on beat 1, open root or fifth on beat 2, pick-ups), then a scale run up and down.

## Build and verify
```
./build.sh                                  # generate -> GenExpr grammar -> validate -> Node tests (30 + 41) -> m4l/Surdo.amxd; then the same for m4l/SurdoMusical.amxd (Node tests/test_musical.js, 11)
FRESH=1 python3 tests/fit.py fit 16 && python3 tests/calibrate.py   # re-fit the tables to the recordings (~12 min; after changing HEAD / BANDS in the engine). Not while another fit.py runs in this folder (shared _t.fit.genexpr)
python3 tests/compare.py all                # docs/compare/<stroke>.png: recording vs ours (waveform, envelope, spectrograms)
python3 tests/fit.py report                 # per stroke: recording / ours (rise, t20, t40, centroid, crack, blip, tone start, HF level, glide)
python3 tests/fit.py ab                     # docs/strokes_ab.wav + the cue list below (recording, then ours; gitignored)
python3 tests/clips.py stats                # what the seven Live clips add (docs/SPEC.md); clips.py score <clip> prints a clip's hits for the demo
python3 scripts/gen_compile.py --cold m4l/Surdo.maxpat                         # real Max, cold first compile of the gen~
uv run --directory $MAXTEST_DIR python $PWD/tests/test_voice_max.py [--demo]   # standalone Max (26 checks; --demo writes docs/demo.wav)
uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check_voice.py "$PWD/m4l/Surdo.amxd"   # inside Live (15 checks; adds "LT" tracks, delete them afterwards)
python3 scripts/gen_compile.py --cold m4l/SurdoMusical.maxpat                  # Surdo Musical: cold gen~ compile
uv run --directory $MAXTEST_DIR python $PWD/tests/test_musical_max.py [--demo]   # Surdo Musical in standalone Max (14 checks; --demo writes docs/musical_demo.wav)
uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check_musical.py "$PWD/m4l/SurdoMusical.amxd"   # Surdo Musical inside Live (11 checks)
```
Max and Live are shared: wrap the Max/Live commands in the session's `withlock.py`. References are read from the LP pack (`tests/refs.py`); converted copies go to `ref_wav/` and the A/B wav to `docs/`, both gitignored: never commit Ableton audio.

## Status (2026-11-01)
Node 30 + 41 (the second is `tests/test_strokes.py`: our strokes against the recordings), standalone Max cold 26/26 (+ `gen_compile --cold` clean), Live 15/15 (clean console; the LT tracks were deleted afterwards). **Unheard**: nobody has listened to `docs/demo.wav` or `docs/strokes_ab.wav`; the fit is numeric and by plots (`docs/compare/`). Not checked in Live: the panel (Max only).

Recording / ours (vel 0.8, Vary off, median of 3 hits 2 s apart), from `tests/fit.py report`:

| stroke | band profile rms | rise ms | t20 ms | t40 ms | centroid Hz | crack dB | HF 2.5-9 kHz dB re total |
|---|---|---|---|---|---|---|---|
| Open | 0.5 (8 bands) | 3.9 / **6.2** | 426 / 374 | 715 / 700 | 93 / 98 | -42.1 / **-34.2** | -47 / **-37** |
| Mute | 0.4 (19) | 3.7 / 1.5 | 23 / 28 | 116 / 143 | 125 / 165 | -34.4 / **-25.1** | -42 / **-28** |
| Rim | 0.8 (20) | 2.7 / 2.0 | 75 / **131** | 290 / **424** | 1886 / 1660 | -2.9 / -4.1 | -7 / -7 |
| Finger | 0.2 (17) | 8.7 / **25.4** | 18 / **34** | 103 / **190** | 67 / 58 | -34.5 / -33.0 | -37 / -35 |

Open glide f(40-100 ms) / f(200-290 ms): 1.95 % / 1.94 %. Spectral flatness 2.5-9 kHz (noise, not lines): recordings Mute -5.6, Rim -5.0, Finger -2.8 dB; the Open reads -14.8 (a tonal skirt) but holds -47 dB there, so the test is waived for it; ours are noise bands.

## Measured, in short (details in `docs/SPEC.md`)
- Open: 88.2 Hz at the hit, 86.0 Hz from 250 ms (-43 ct, tau about 0.1 s); no beating (envelope ripple 0.23 dB rms); a decay that **accelerates** (T60 2.6 s early, 0.8-0.9 s late: -8 / -12 / -18 / -30 dB at 0.1 / 0.3 / 0.4 / 0.6 s) which the fit reproduces with a decay-rate factor G = 0.25 that relaxes over 0.4 s; overtones 159 and 259 Hz at -28 dB, nothing above 1 kHz worth modelling.
- The strokes ring different members of one mode set (Rim and Mute 73 Hz, Finger 100-106 Hz, the Mute's thud 123-146 Hz, a Finger thump of 26-46 Hz); 17 head modes at ratios 0.30 .. 5.86 of 86 Hz and 7 noise bands from 800 Hz.
- The clips (Samba 1 / 2, Baion B, Candombe B, Murga B, Rhumba Funk B, Afoxe) replay the one-shots (61 Open onsets, 29 Mute, 16 Finger replays, no Rim) at gains 0.80 / 0.46 / 0.37 of the previews' peaks: no second drum, no extra stroke.

## Honest differences and unverified
- **Finger**: the recording is a ~25 Hz thump (peak at 12 ms, half its energy under 32 Hz) then 100 Hz; ours rises in 25 ms (the 26-46 Hz modes start with a spread of phases) and decays at t20 34 / t40 190 ms against 18 / 103. The sub-26 Hz part is not modelled. A one-G-per-stroke decay cannot be both a 20 ms thump and a 100 Hz ring.
- **Mute**: highs too bright, crack -25 against -34 dB (HF 2.5-9 kHz -28 against -42 dB re total): the fit matches the highs' energy over 120 ms, ours is front-loaded and ends up lower than the recording at 100-200 ms (their highs decay at about 0.2 s T60; letting the noise bands share the stroke's G made the tail right and the click too loud, noise bands at a G of 1 gave t40 306 ms, rise 15 ms and crack -28 dB; the best of the fits is kept). Centroid 165 against 125 Hz.
- **Open**: rise 6.2 against 3.9 ms (the metric is a 3 ms envelope: a half-cycle of an 86 Hz tone), a faint tick (blip 0.10 against 0.05) and highs 10 dB above the recording's (both under -34 dB re total). The recording's -50 dB room floor after 0.85 s is not modelled (ours falls to -80 dB), and its 86 Hz tone has an HF stripe pattern per cycle (a nonlinearity) that ours barely shows.
- **Rim** decays too slowly in the first 130 ms (t20 131 against 75 ms) and has no dense 0.8-1.4 kHz line forest, only noise bands.
- The glide's level dependence is weakly measured (clip replays: 17 ct at 0.35-0.6 of the one-shot's level, 36 ct above 0.6; the model is velocity^2, about 15 ct at the mid bin). Its shape differs from the recording's: the model starts 4.1 % sharp at the hit at velocity 0.8 (6.4 % at 1.0) and decays with tau 0.1 s; the recording sits at 2.1-2.5 % for the first 60 ms then falls. The windowed figure matches; the first 30 ms are about 1 % (17 ct) too sharp. The Rim, Mute and Finger have no glide table (no clean line to measure).
- A 35 Hz line sits in every take at -50..-70 dB from 0.1 to 0.4 s (room or shell); not modelled. Strokes' levels against each other: Open / Mute / Finger from the clips (0 / -4.7 / -6.7 dB at replay), the Rim a judgement (-4 dBFS). Stroke-change damping (`kp`) is a judgement (the clips are samples that do not damp each other); G / tau come from the isolated one-shots.
- A soft hit does not restart a stroke's own damping (c moves towards 1 by the velocity); at velocity 0.8 (fit) and 1.0 (calibration) the fitted G / tau differ by a few percent for that reason.
- If two strokes arrive in one audio block only one plays (the counter changes once). A quiet Mute over a ringing Open takes the ring down by 30 dB (Node, Vary 0) / 26 dB (Live) over 0.2-0.4 s later; the tests need 10.
- Tune past +-12 st is not offered; the size-up (down a fourth) / size-down offsets are a suggestion, not a measurement. Panel seen in standalone Max only, not screenshotted in Live. `pkill -f "tests/fit.py fit"` kills every agent's fit run: use a pid.

## Demo and A/B
- `docs/demo.wav` (11.0 s, rendered in standalone Max, one instance): the pattern of the LP clip "Samba 1 Surdo-120bpm" read from the one-shot replays in it (`tests/clips.py score clip_Samba_1`: mutes on the beat, opens and finger taps, gain -> velocity), 4 bars at 120 bpm, then an open on the downbeat and a rim click. Our reading of the clip, not a transcription from a method book.
- `docs/strokes_ab.wav` (15.8 s, gitignored): per stroke the recording then ours (vel 0.8, Vary on). Cue list:

```
  0.00 s  open: recording
  1.75 s  open: ours
  3.95 s  mute: recording
  5.70 s  mute: ours
  7.90 s  rim: recording
  9.65 s  rim: ours
 11.85 s  finger: recording
 13.60 s  finger: ours
```
