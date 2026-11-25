# Bongo

A modal bongo for Max for Live: one drum per instance (**Macho**, the small high drum, or **Hembra**, the large low one), seven hand strokes, one gen~. Forked from Conga Voice / Timbales (same panel, same engine structure) and fitted to the Latin Percussion pack's bongo takes: mode ratios, decays, tick and attack were measured from those recordings (`docs/SPEC.md`), not copied from the conga.

## Playing
`m4l/Bongo.amxd` (180 x 169, the Conga Voice / Timbales layout): any MIDI note plays it, velocity is strength, the mod wheel (CC1) presses the head. A **Drum** menu (Macho, Hembra) and a **Stroke** menu (Open, Open 3F, Slap, Heel, Tip, Rim, Flam) choose what it plays; both are automatable and may be changed between hits (the new stroke's hand damps the ring already on the head). Several instances in a Drum Rack make a pair of bongos (one pad per drum x stroke). Mono output; note-offs are ignored.

| Parameter | Range | Default | Notes |
|---|---|---|---|
| Drum | 0 Macho, 1 Hembra | 0 | open tone 365 / 325 Hz at Tune 0 (the middle of the two recorded kits) |
| Stroke | 0 Open, 1 Open 3F, 2 Slap, 3 Heel, 4 Tip, 5 Rim, 6 Flam | 0 | Open 3F = three fingers: softer, broader contact. Flam = two Open hits 42 ms apart, the second 0.45 x as loud |
| Tune | -12..12 st | 0 | the head; the 125 Hz body does not move |
| Decay | 30..300 % | 100 | head ring time (T60 about 0.3-0.4 s) |
| Skin | 0..100 % | 50 | +-6 dB/oct tilt of the overtones |
| Shell | 0..100 % | 50 | level of the 125 Hz body tone (matters on heel and tip) |
| Touch | 0..100 % | 50 | contact hardness: brighter, louder, more tick |
| Press | 0..12 st | 5 | mod wheel range |
| Vary | 0..100 % | 100 | hit-to-hit variation: each head tone's level nudged at random (about 1.5 dB at 100 %; the noise bands and tick differ every hit anyway); 0 repeats the same sinusoids |
| Volume | -36..6 dB | -9 | |

Panel: the pair of bongos in orange line art (the chosen drum bright), the hand where the stroke is played, its name, a flash on every hit; Drum / Stroke menus; boxes Skin, Shell, Touch, Press, Vary; dials Tune, Decay, Volume. Hover text on everything. Screenshot (Live): `docs/panel_live_idle.png`.

## Build and verify
```
./build.sh                                  # generate -> GenExpr grammar -> validate -> Node tests (53 + 101) -> m4l/Bongo.amxd
FRESH=1 python3 tests/fit.py fit 16 && python3 tests/calibrate.py   # re-fit the tables to the recordings (~8 min; after changing HEAD / BODY / BANDS in the engine)
python3 tests/compare.py all                # docs/compare/<stroke>.png: recordings vs ours (waveform, envelope, spectrogram), both drums
python3 tests/fit.py report                 # per drum and stroke: recording / ours (rise, t20, t40, centroid, crack, blip, tone start)
python3 tests/fit.py ab                     # docs/strokes_ab.wav + the cue list below (recording A, then ours; gitignored)
python3 scripts/gen_compile.py --cold m4l/Bongo.maxpat                         # real Max, cold first compile of the gen~
uv run --directory $MAXTEST_DIR python $PWD/tests/test_voice_max.py [--demo]   # standalone Max (37 checks; --demo writes docs/demo.wav)
uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check_voice.py "$PWD/m4l/Bongo.amxd"   # inside Live (27 checks; adds "LT" tracks, delete them afterwards)
```
Max and Live are shared: wrap the Max/Live commands in the session's `withlock.py`. References are read from the LP pack and Core Library (`tests/refs.py`); converted copies go to `ref_wav/` and the A/B wav to `docs/`, both gitignored: never commit Ableton audio.

## Status (2026-10-31)
Node 53 + 101, standalone Max cold 37/37 (+ `gen_compile --cold` clean), Live 27/27 (clean console). **Unheard**: nobody has listened to `docs/demo.wav` or `docs/strokes_ab.wav`; the fit is numeric and by plots (`docs/compare/`).

Recording / ours (median of hits, vel 0.8, Vary off), from `tests/fit.py report`:

| drum stroke | band profile rms | rise ms | t20 ms | t40 ms | centroid Hz | crack dB |
|---|---|---|---|---|---|---|
| Macho open | 0.0 | 0.88 / 0.83 | 31 / 30 | 123 / 120 | 864 / 858 | -18.6 / -18.9 |
| Macho open3 | 0.2 | 1.85 / 0.85 | 30 / 30 | 110 / 122 | 822 / 825 | -19.4 / -19.6 |
| Macho slap | 2.3 | 2.22 / 2.54 | 29 / 30 | 126 / 132 | 961 / **1220** | -10.2 / -8.8 |
| Macho heel | 0.6 | 1.59 / 1.15 | 31 / 28 | 120 / 113 | 790 / 826 | -19.3 / -20.8 |
| Macho tip | 1.2 | 2.28 / **0.96** | 17 / 22 | 94 / **134** | 572 / 589 | -16.6 / -17.0 |
| Macho rim | 1.0 | 1.20 / 0.81 | 13 / 21 | 121 / 124 | 855 / 892 | -12.1 / -12.4 |
| Hembra open | 1.7 | 1.33 / **0.27** | 59 / 59 | 168 / 162 | 383 / 378 | -29.5 / -28.8 |
| Hembra open3 | 1.3 | 1.84 / 2.71 | 43 / 42 | 168 / 164 | 346 / 348 | -32.2 / -33.1 |
| Hembra slap | 1.6 | 1.33 / 2.33 | 37 / 47 | 138 / 163 | 472 / 463 | -18.8 / -19.4 |
| Hembra heel | 1.1 | 1.66 / 1.58 | 25 / 19 | 101 / 97 | 354 / 357 | -29.4 / -29.9 |
| Hembra tip | 0.4 | 2.79 / 2.58 | 26 / 14 | 99 / 94 | 339 / 338 | -29.1 / -29.8 |
| Hembra rim | 1.0 | 1.29 / **0.25** | 14 / 20 | 128 / 120 | 543 / 559 | -15.7 / -15.8 |

Spectral flatness 2.5-9 kHz (5-40 ms): ours -3.1..-5.2 dB against the takes' -2.6..-7.0 (noise, not lines; `tests/test_strokes.py`).

## Honest differences and unverified
- **Attack.** Recordings: a ~1 ms noisy tick (RMS 0.2-0.4 of the peak, mostly 0.8-3 kHz) then the tone builds; ours now has a tick at the hit, a tone envelope after it and a fixed phase spread, so the first 15 ms look like the recordings (`docs/compare/`), where Conga's were a 0.25 ms sine start. The 10 % -> -3 dB rise matches on 8 of 12 strokes; still too fast on Hembra open (0.27 vs 1.33), Hembra rim (0.25 vs 1.29), Macho tip (0.96 vs 2.28) and Macho open 3F (0.85 vs 1.85); the metric is jumpy (mode beating moves the 8 ms peak), so also look at the plots.
- Macho slap is 27 % too bright (centroid 1220 vs 961 Hz), Macho tip rings longer (t40 134 vs 94 ms), Hembra tip t20 14 vs 26. The slap's recordings start with the crack 4-6 ms after their 5 % onset, ours at once (their tick "blip" is not fitted for the slap; its crack share is).
- The recordings' tails (-60..-50 dB, 100-300 ms) decay slower than ours (a floor of room and very slow modes: ours reach -80 dB by 350 ms).
- The 125 Hz body is capped at 6 dB under the strongest head mode (`BODY_CAP`): uncapped, the fit made it a ringing 125 Hz swing on slap and heel that the recordings do not have; the recordings' low band (< 170 Hz) is a broadband finger thump, not a tone. So Macho's Shell control is weak (its body is 18 dB under the head on tip), Hembra's is audible. The profile errors above exclude that band.
- The two kits differ (Hembra B is 15 % above A, with different mode ratios 2.09 vs 2.23); the table is a compromise, so neither take is matched exactly in pitch.
- Loudness between strokes is a judgement (the previews are peak-normalised). Flam is two Open hits (the recorded 1F / 3F flams merged). Stroke-change damping (`kp`, `G`, `tau`) was fitted from isolated hits, not from a stroke over a ringing head.
- If two strokes arrive in one audio block only one plays (the counter changes once; the flam's second hit is dropped if a new note lands the same sample).
- Panel seen in standalone Max only, not screenshotted in Live.

## Demo and A/B
- `docs/demo.wav` (rendered in Max, two instances): the martillo of the LP clip "Son Bongo-192bpm", read from its onsets (steady 8ths, 156 ms; the soft taps -> Macho tips, 850 Hz-rich accents -> Macho opens, 350 Hz accents -> Hembra opens, crackly accents -> slaps), 4 bars, then a short fill of slaps and rims with a flam into the last downbeat. Our reading of the clip, not a transcription from a method book.
- `docs/strokes_ab.wav` (36.8 s, gitignored): per drum and stroke the recording (take A) then ours (tuned to take A, vel 0.8). Cue list:

```
  0.00 s  Macho open: recording (take A)
  0.85 s  Macho open: ours
  2.75 s  Macho open3: recording (take A)
  3.47 s  Macho open3: ours
  5.37 s  Macho slap: recording (take A)
  6.13 s  Macho slap: ours
  8.03 s  Macho heel: recording (take A)
  8.65 s  Macho heel: ours
 10.55 s  Macho tip: recording (take A)
 11.16 s  Macho tip: ours
 13.06 s  Macho rim: recording (take A)
 13.78 s  Macho rim: ours
 15.68 s  Macho flam: recording (take A)
 16.44 s  Macho flam: ours
 18.34 s  Hembra open: recording (take A)
 19.21 s  Hembra open: ours
 21.11 s  Hembra open3: recording (take A)
 21.90 s  Hembra open3: ours
 23.80 s  Hembra slap: recording (take A)
 24.53 s  Hembra slap: ours
 26.43 s  Hembra heel: recording (take A)
 27.03 s  Hembra heel: ours
 28.93 s  Hembra tip: recording (take A)
 29.51 s  Hembra tip: ours
 31.41 s  Hembra rim: recording (take A)
 32.11 s  Hembra rim: ours
 34.01 s  Hembra flam: recording (take A)
 34.93 s  Hembra flam: ours
```
