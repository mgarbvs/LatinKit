# Guiro

Max for Live instrument: a scraper (a **güiro** fitted to Latin Percussion recordings, and the samba **reco-reco**, a metal box with tensioned steel springs, fitted to one Freesound recording). A stick crossing evenly spaced ridges is a train
of impacts at a rate set by the stick's speed; every impact ticks (a bright click) and rings the gourd (a low body). One gen~, ten real `live.*` parameters.
Spec, research and the model: `docs/SPEC.md`. Part of the Latin percussion section (`../LATIN_PERCUSSION_RESEARCH.md`, section 5 "Scrapers", item 7).

## Playing

- Every note is one **stroke**, velocity is its energy. The four strokes are the ones in the Latin Percussion pack's `Guiro {A-D} {Up, Down, Long, Top}`:
  **Up** (a short, fast scrape, ~80 ms), **Down** (a longer, slower one, ~115 ms, loud late), **Long** (a full scrape, the **Length** control, 450 ms) and **Top** (a single tap).
- **Stroke** menu: **Key** (default): pitch mod 4, so C3 Up, C#3 Down, D3 Long, D#3 Top, E3 Up again ...; **Up / Down / Long / Top**: always that stroke (a Drum Rack pad sends one fixed note:
  one pad or chain per stroke); **Alternate**: Up, Down, Up ... on every new note. The classic cell is **Long, short, short** (the pack's Guajira / Son clips): Long, Up, Down.
- **Roll**: 0 = off. Above 0, a held note keeps scraping that many strokes a second until you let go (Up and Down alternate in Key / Alternate; Long, Top and the fixed entries repeat).
- A new note restarts the stick (one hand, one gourd); the ring of the last stroke carries on. Not tuned: Tone changes the pitch of the instrument, not the key. Two notes inside one audio block (~1.3 ms) make one stroke.

## Panel (functional, DS-style like Shaker / Cuica; seen in Live: `docs/screens/panel_live_idle.png`)

Display: a line drawing of the Type (a gourd with cut ridges; a metal box with three springs) and a stick that scrapes across the ridges with every note (Up left to right, Down right to left, Long slowly, Top a tap), lighting the
ridges it crosses; the last note's name; the **Type** menu as the big orange word; orange-outlined **Length / Roll / Stroke** (menu) and **Pan / Level**; dials **Speed, Ridge, Tone, Vary**.

| control | range (default) | what it does |
|---|---|---|
| Type | 0 Güiro / 1 Reco (the samba reco-reco; the menu is 58 px wide). The instrument menu: it was already in the device, so no new parameter; presets saved on Güiro are unchanged (default 0) | the instrument |
| Length | 100-1500 ms (450) | the Long stroke's length (the previews: 480-600 ms; the fourth take 155) |
| Roll | 0-12 Hz (0) | hold-to-scrape |
| Stroke | Key / Up / Down / Long / Top / Alternate (Key) | which stroke a note plays |
| Speed | 25-400 % (100) | the hand: 200 % crosses the same ridges in half the time (twice the ticks a second, a stroke half as long) |
| Ridge | 25-400 % (100) | the instrument: more ridges in the same time (more ticks a second; the stroke keeps its length) |
| Tone | -12..+12 st (0) | moves the click's filters and the body modes: a smaller or bigger instrument |
| Vary | 0-100 % (50) | the hand's unevenness: ridge-to-ridge timing (up to +-17 %) and level |
| Pan | -100..100 (0) | constant power |
| Level | -36..+6 dB (-6) | |

Speed / Ridge are loudness-neutral (within ~4 dB at the extremes). Speed and Ridge are trims on the fitted instrument: 100 % is the fit.

## What the references showed (details: `docs/SPEC.md`; plots in `docs/refplots/`, `docs/compare/`, both gitignored)

- **Takes A-D are four different instruments or hands**, not four takes of one: centroids 2.8-11 kHz, the ridge ticks separate in A and blurred into noise in C. A stroke's reference is therefore a **range over takes**.
- **Impact rates** (impacts a second, from a detector validated against the engine's own impact times; octave-ambiguous on the blurred takes): Up 115-236, Down 70-139, Long 40-147 (A 40, B 147, C 138, D 91);
  the groove clips: Long 140-150/s, 70-125 ms shorts of 9-22 impacts. **Not a sweep**: the rate over a stroke is flat within noise for Up and Long; only Down slows down (thirds 140 / 129 / 86 /s). The level does fall at the end (the last
  third's impacts -3..-17 dB re the first) and Down builds for 55-65 ms.
- **Durations** (onset to last -20 dB): Up 65-104 ms (7-19 impacts), Down 110-129 ms (8-19), Long 480-600 ms (25-78; D: 155 ms), Top 16-58 ms. In the groove clips the Long scrape follows the tempo (270-630 ms).
- **Body**: weak (-18..-40 dB under 1 kHz) but tonal and take-specific: ~300 Hz (A 293/312, B 274, C 377/395 Hz) with weaker modes near 650-800 Hz and 1.75-2.2 kHz; the click is broadband, rising from 1.5 kHz to a hump at 3-12 kHz.
- **What Top is**: one impact and a two-slope broadband decay (-12 dB at 5-10 ms, -20 at 20-30, -30 at 50-100), no scrape: the stick tapping the instrument. Brighter than the scrapes (centroid 7.4-11 kHz).
- **Up vs Down**: Down is ~1.5x longer and ~0.7x the ridge rate, builds slowly and slows down, and the previews end it with a late stray tick (A 111 ms, B 124 ms; not modelled); the spectra are alike.
- **Reco-reco reference**: one Freesound recording (CC0), see "Reco-reco" below and `docs/RESEARCH.md`. **No measured güiro data** (ridge count, stroke length) was found on the web; sources and STK's guiro are in `docs/SPEC.md`.

## Engine

`scripts/guiro_engine.py` -> gen~ (read its docstring): a phase accumulator fires one impact per ridge at `130/s x Ridge x Speed x the stroke's rate factor` for the stroke's length (the first with the note, jittered by Vary);
each impact kicks (a) a fast level times noise through a 4th-order high-pass and three band-pass resonances (the tick), (b) two slow noise levels (the broadband tail), (c) three tonal body modes rung by an impulse.
The Type constants are fitted (`tests/fit_types.js`, Nelder-Mead on the Node shim, to takes A+B: separate ridges, a ~300 Hz body; the tests use the A-D range); the per-stroke constants (length, rate factor, curve, attack, taper, body weight) are measured and hand-set.

## Fit and tests

Ours (Güiro, velocity 1, mean of 24, `node tests/fit_refs.js`) against the reference range over the takes (ms, /s, Hz, dB):

| stroke | length | impact rate | last third re first | centroid | grain fluctuation | rise | t20 (Top) / tail (scrapes, -20 to -35 dB) |
|---|---|---|---|---|---|---|---|
| Up | 84 (65-104) | 177 (115-236) | -11.2 (-17.5..-7.6) | 5066 (4935-10170) | 0.5 (0.1-0.6) | 19 (16-39) | tail 64 (63-76) |
| Down | 113 (110-129) | 131 (70-139) | -5.4 (-17.1..+4.1) | 5312 (5347-10113) | 0.6 (0.2-0.7) | 42 (56-67) | tail 41 (62-69) |
| Long | 451 (155-602) | 121 (40-147) | -3.2 (-6.3..+4.2) | 5245 (2762-10353) | 0.6 (0.1-0.7) | (noise) | tail 40 (23-74) |
| Top | 21 (16-58) | - | - | 8320 (7368-11215) | 0.3 (0.2-0.5) | 0 | t20 21.5 (17.5-55), t30 41 (50-101) |

## Reco-reco

The samba bateria's reco-reco: the modern **metal box with 2-4 tensioned steel springs scraped by a metal rod** is modelled (bright, ringing spring lines, a raspy scrape); the **traditional bamboo / wood notched reco-reco** (woodier, close to the Güiro) is not a Type of its own. Which one a bateria uses is not stated by any source found; the metal one is chosen because it is the loud one (`docs/RESEARCH.md`).
Menu: **Type = 1 (Reco)**; the Stroke menu is shared (Key 0, Up 1, Down 2, Long 3, Top 4, Alternate 5; all four strokes make sense: a pass of the rod up or down, a run, and a tap of the rod on the box). Pass lengths are the Güiro's (80 / 115 ms; the recording's passes are 55-110 ms apart).
Reference: Freesound 219634 "recoreco-texture.wav" (CC0): 15 s of continuous playing, cut into 125 stroke clips (`tests/reco_refs.sh`). Fit (`node tests/fit_reco.js --write`, ~4 min): the engine's Reco Type constants (high-pass, three noise resonances, three spring modes at ~1.6 / 2.7 / 3.3 kHz, tails) to the pooled 1/3-octave spectrum (**2.4 dB rms**, 71 clips of 55-200 ms against Up + Down + Long), the Top tap to the ring-out after a run (t10 / t20 / t30 **50 / 178 / 463 ms against 57 / 160 / 379**; 1.2-3.8 kHz lines 10 dB down at 150-250 ms against 7, 6-16 kHz 24 against 24), and the spring-line prominence (the three strongest lines **20 dB over the floor against the recording's 17**).
The impact rate (trm 3.0 = 390 /s at Ridge 100 %) is an estimate: the recording's impacts are fused into noise. Not heard; judge `docs/reco_ab.wav` (gitignored; cues printed by `node tests/reco_ab.js`: recording excerpts at 0.00 / 1.54 / 2.96 / 4.81 / 6.41 s, ours from 8.51 s: Up, Down 9.41, Long 10.31, Top 11.61, a 10-a-second run 12.51, Long then Top 14.71) and the second half of `docs/demo.wav`.

- `./build.sh` (generate, GenExpr grammar check, validate, Node tests `tests/test_engine.js`, build `m4l/Guiro.amxd`, `--type iiii`): green, **123 Node checks**: stability at the extremes, exact silence, the gesture against the engine's own impact times
  (rate, length, Speed / Ridge / Length / Vary, Top = one impact), every stroke against the range over the takes (length, rate, centroid, level fall, tail, grain fluctuation, octave bands within 6 dB of the range, calibrated level), every control, both Types, the Reco-reco against the Freesound clips (`tests/refs_reco.json`), the Güiro's fingerprint, the note map and Roll
  (`guiro_midi.js` with a fake Task), the maxpat's codebox equal to the engine's code.
- **Max** (standalone, cold: `scripts/gen_compile.py --cold` compiled OK; `tests/test_max_render.py`): **54/54** (the Reco-reco's levels, centroids, bands and ring included; stroke levels within 3 dB of the calibration, Top within 5 dB: a single burst scatters -1.7..-4.5 dB between runs; lengths, rates, centroids and bands against the ranges; note map; Roll; every parameter; both Types at the extremes; one run had `Level 0 dB: x2.37 (want 1.7..2.35)` once, a single-burst Top scatter that passed on the rerun). **Live** (`scripts/live_check.py`): **15/15** (2026-11-03, Güiro and Reco-reco both sound through Live, console clean), the LT test tracks deleted afterwards.
- Panel screenshot (Live): `docs/screens/panel_live_idle.png`.
- `node tests/render_demo.js` -> `docs/demo.wav` (14 s, 150 BPM, a son montuno long-short-short cell on the Güiro for four bars, then the same cell on the Reco-reco, a rolled fill to finish; Node-rendered).
- `node tests/fit_refs.js --ab` -> `docs/strokes_ab.wav` (gitignored): each reference take of a stroke, then ours, peak-normalised, 0.4 s apart. Cues (s): **Up** A 0.00, B 0.66, C 1.51, D 2.40, **ours 3.30**; **Down** A 4.20, B 4.94, C 5.78, **ours 6.75**;
  **Long** A 7.65, B 9.15, C 10.30, D 11.59, **ours 12.53**; **Top** A 13.83, B 14.46, C 15.14, D 16.00, **ours 16.72**.
- `node tests/render_strokes.js && python3 tests/compare.py` -> `docs/compare/<stroke>.png` (waveform, 1 ms RMS, spectrogram: every take, three draws of ours, the Reco-reco). The numbers hid real problems here three times (a tonal body ring posing as a long tail, a Top that was too dull, a missing
  broadband tail); each was fixed from the plots.
- Reco-reco refit: `tests/reco_refs.sh` (fetch + cut the reference), `node tests/fit_reco.js --write` (~4 min), then calibrate as below.
- Refit: `node tests/fit_types.js --write` (~9 min), then `node tests/calibrate.js --write` twice (until the peaks print 0.2500), `node tests/fit_refs.js --write` (refs.json), `./build.sh`. The refs (`ref_wav/`) are Ableton's audio: gitignored; `tests/decode_refs.sh` makes them.

## Honest differences and unverified

- **Never heard.** The fit matches impact rates, lengths, spectra and tails of recordings; that is not the same as sounding right.
- **Reco-reco is fitted to one amateur recording** (mp3 preview, unknown mic and room, one instrument), not to labelled strokes: the stroke names and pass lengths are the Güiro's, Top (a lone tap) has no recording (its reference is the ring-out after a run), the impact rate is estimated, and the recording's 30-odd spring lines are three modes plus noise here. The recording's rumble below 500 Hz (handling noise, -25 dB under 250 Hz) is not modelled. The bamboo reco-reco is not modelled. Presets that saved Type = Reco before 2026-11-03 change sound (the old Reco was an unfitted judgement); Güiro presets are bit-for-bit unchanged (checked against the previous engine: 8 strokes, 384000 samples, max difference 0; fingerprint test in `tests/test_engine.js`).
- **Takes differ a lot**: the fit targets A+B (separate ridges, a 300 Hz body); C (dense, 10 kHz centroid) is reached with Tone +4..+12 st and Ridge up, not by default; D's 1.75 kHz mode and short Long stroke are not modelled.
- Gaps against the references: Top's t30 (41 ms against 50-101) and tail (31 against 58-62): the engine's tap decays a little faster than the previews'; Down's rise (42 against 56-67 ms) and t20 (69 against 35-52); Long's low-level tail is a little longer than A's;
  Down's late stray tick is not modelled; the engine's body at 300 Hz is an average over takes (A has far more of it than B-D). The ridge rate of the blurred takes (B at 236/s, C) is octave-ambiguous: the detector counts what it can see.
- Up vs Down are named after the pack, not known to be physical up / down.
- Velocity changes level only (the previews are peak-normalised, so no velocity layers could be measured). The level of the strokes against each other is *not* from the references (they are normalised): every stroke is calibrated to the same loudness.
- Speed also scales the stroke's length (a modelling choice, same distance faster); Roll is a js Task chain, its timing the scheduler's. CPU is unmeasured (filter coefficients are computed per sample).
- The Node shim and Max agree (Max results are within a few percent of Node's on length, rate, centroid).
