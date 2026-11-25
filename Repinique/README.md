# Repinique

A modal samba repinique (the small high-tuned metal-shell lead drum, played with one stick and one hand) for Max for Live: one drum per instance, six strokes in a **Stroke** menu, one gen~. Forked from Surdo (same panel layout, engine structure and fit pipeline; Bongo's Flam, Timbales' fixed-Hz shell modes and noise-band highs) and fitted to four CC0 Freesound recordings by BeppeB (`docs/RESEARCH.md`).

## Playing
`m4l/Repinique.amxd` (180 x 169): any MIDI note plays it, velocity is strength, the mod wheel (CC1) presses the head. The **Stroke** menu is automatable and may change between hits (the new stroke's hand or stick damps the ring already on the head). Mono output, note-offs ignored.

| Index | Stroke | What it is | Evidence |
|---|---|---|---|
| 0 | Open | stick in the middle of the head: 356 Hz tone, a little tick | fitted (8 takes) |
| 1 | Rimshot | stick on head and rim together: the crack, strong 1.1-2.1 kHz shell modes | fitted (8 takes) |
| 2 | Rim | stick on the rim / tension rod only: short, metallic | fitted (8 takes) |
| 3 | Hand | open hand on the head: Open's tone, slower attack | fitted (8 takes) |
| 4 | Mute | hand pressed on the head: a short dull thud | **judgement**, derived from Hand |
| 5 | Flam | two Opens 42 ms apart, the second 0.45 x | **judgement** (Bongo's numbers) |

| Parameter | Range | Default | Notes |
|---|---|---|---|
| Stroke | 0..5 | 0 | as above |
| Tune | -12..12 st | 0 | the head's tones (open tone 356 Hz at 0); the shell's tones above 700 Hz stay at their Hz |
| Decay | 30..300 % | 100 | ring time |
| Skin | 0..100 % | 50 | +-6 dB/oct tilt of the overtones |
| Touch | 0..100 % | 50 | contact hardness: brighter, more tick |
| Press | 0..12 st | 5 | mod wheel range |
| Vary | 0..100 % | 100 | per-hit jitter of each sinusoid's level (about 1.5 dB at 100 %) |
| Volume | -36..6 dB | -9 | |

No Drum menu, no glide (the recordings' head tone is flat), no hand slap proper (not in the files). Panel: the drum in orange line art with the stick or hand where the stroke is played, Stroke menu, boxes Skin / Touch / Press / Vary, dials Tune / Decay / Volume, hover text everywhere. Screenshot (Live): `docs/panel_live_idle.png`.

## Build and verify
```
./build.sh                                  # generate -> GenExpr grammar -> validate -> Node tests (36 + 40) -> m4l/Repinique.amxd
FRESH=1 python3 tests/fit.py fit 16 && python3 tests/calibrate.py   # re-fit to the takes (~3 min; after changing HZ / BANDS / PHASE_SPREAD in the engine)
python3 tests/compare.py all                # docs/compare/<stroke>.png: three takes vs ours (waveform, envelope, spectrograms)
python3 tests/fit.py report                 # per stroke: recording / ours
python3 tests/fit.py ab                     # docs/strokes_ab.wav (recording, then ours; gitignored)
python3 tests/t60.py f1 f2 ...              # per-mode T60 of the takes
python3 scripts/gen_compile.py --cold m4l/Repinique.maxpat                       # real Max, cold first compile of the gen~
uv run --directory $MAXTEST_DIR python $PWD/tests/test_voice_max.py [--demo]   # standalone Max (29 checks; --demo writes docs/demo.wav)
uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check_voice.py "$PWD/m4l/Repinique.amxd"   # inside Live (16 checks; adds "LT" tracks, delete them afterwards)
```
Max and Live are shared: wrap Max/Live commands in the session's `withlock.py`. The takes are downloaded on first use into `ref_wav/` (gitignored).

## Status (2026-11-03)
Node 36 + 40 (`tests/test_voice.js`, `tests/test_strokes.py`: our strokes against the takes), standalone Max cold 29/29 (+ `gen_compile --cold` clean), Live 16/16 (clean console; LT tracks deleted). **Unheard**: nobody has listened to `docs/demo.wav` (10.7 s, a samba call and response invented for this device) or `docs/strokes_ab.wav`; the fit is numeric and by plots. Nothing committed.

Recording / ours (vel 0.8, Vary off, median of 3 hits), `tests/fit.py report`; the recording column is the mean of 8 takes:

| stroke | band profile rms | rise ms | t20 ms | t40 ms | centroid Hz | crack dB |
|---|---|---|---|---|---|---|
| Open | 0.6 (24 bands) | 1.5 / 2.3 | 65 / 65 | 210 / 223 | 452 / 531 | -16.6 / -14.1 |
| Rimshot | 2.9 (25) | 1.8 / **3.4** | 91 / 93 | 285 / 241 | 1428 / 1527 | -6.3 / -5.2 |
| Rim | 3.2 (26) | 1.2 / 1.6 | 26 / 33 | 150 / 158 | 1691 / 1730 | -5.9 / -3.6 |
| Hand | 1.4 (26) | 3.9 / **7.7** | 78 / 68 | 208 / 222 | 541 / 657 | -15.4 / -13.0 |

## Known gaps
- **Mute and Flam are judgement.** No hand slap or mute in the recordings (all 8 Hand takes are open hand, t40 about 205 ms).
- The recordings' room / shell tail (-50 to -65 dB from 0.3 to 1.2 s) is not modelled; ours falls to -90 dB by 0.6 s.
- Hand attack is 2x too slow and the Rimshot's 1.9x (the metric is a 3 ms envelope; `PHASE_SPREAD` 0.35 trades the Open's rise against these); the Open's centroid is 17 % high.
- The 8 takes of a stroke differ a lot (Rimshot's strongest mode is 1117, 353 or 567 Hz by take; Rim's centroid 0.7-2.3 kHz): ours is the average profile, `Vary` is a guess at the spread (1.5 dB), not fitted to it.
- Strokes' levels against each other, and the Mute and Flam levels, are guesses (`PEAK_DB`); the takes' peaks are unknowable. "Rod" is read as the rim / tension rod from the file name and spectrum.
- Takes come from lossy hq mp3 previews, not the flac originals. One drum, one tuning; Tune's +-12 st range and the claim that the shell stays put when retuning are not checked against another drum.
- The stroke-change damping (`kp`, G, tau) of the Rim, Rimshot and Mute is judgement (G, tau for Open / Hand / Rim / Rimshot from decay fits only). If two strokes arrive in one audio block only one plays.
- Panel seen in standalone Max only; the snapshot helper cannot start the Stroke menu on another value.
