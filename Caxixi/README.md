# Caxixi

Max for Live instrument: a **caxixi** (a woven basket rattle with a hard bottom, seeds inside) from Perry Cook's PhISEM stochastic particle model, forked from `../Shaker/` the way `../Guiro/` was,
with three strokes fitted to the Latin Percussion pack's `Caxixi {1..8} {Open, Hand, FX}` previews. One gen~, ten real `live.*` parameters.
Spec, research and the model: `docs/SPEC.md`. Part of the Latin percussion section (`../LATIN_PERCUSSION_RESEARCH.md`, Shaker family).

## Playing

- Every note is one stroke, velocity is its energy. **Stroke** menu (the key does not pick the stroke; a Drum Rack needs one pad or chain per stroke):
  **Open** (one shake: a broadband swell and a two-slope fall, ~0.25 s), **Hand** (the hard bottom struck on the palm: an abrupt front, a quicker first fall, a broad 2.5-3.2 kHz hump) and
  **FX** (a shaken phrase: **Length** ms of Open-like bursts **Rate** a second, swelling in over about four bursts and fading over the last two).
- FX is a phrase, not a hold: a note-off does not cut it, a new note restarts it. Two notes inside one audio block (~1.3 ms) make one stroke.
- No forward / back (Direction) stroke: Shaker's idea was tested on the FX bursts and the previews do not alternate (see below).

## Panel (functional, DS-style like Shaker / Guiro; seen in Live: `docs/screens/panel_live_idle.png`)

Display: a line drawing of the caxixi (basket and bottom) that flashes and jerks with every stroke, the last note's name, the **Stroke** menu as the big orange word, orange-outlined **Length / Rate** (FX) and **Pan / Level**, dials **Beads, Damping, Shake, Rattle, Tone**.

| control | range (default) | what it does |
|---|---|---|
| Stroke | Open / Hand / FX (Open) | which stroke a note plays |
| Length | 300-2000 ms (1000) | FX phrase length |
| Rate | 4-16 Hz (9.3) | FX bursts a second (the previews: 106-121 ms apart, 9.3 a second) |
| Beads | 25-400 % (100), exponent dial | collision rate: texture, not level |
| Damping | 25-400 % (100), exponent dial | energy decay (also the slow tail) |
| Shake | 25-400 % (100), exponent dial | build-up time |
| Rattle | 0-100 % (50) | grain length x 0.25..4 |
| Tone | -12..+12 st (0) | moves the high-pass and the resonances |
| Pan | -100..100 (0) | constant power |
| Level | -36..+6 dB (-6) | |

Beads / Damping / Shake / Rattle / Tone are trims on the fit (100 % / 50 % / 0 st are the fit). The exponent dials are stored linear in travel in Live (`live_check.py` reads them back through the LOM);
nothing here writes presets, so no `stored()` conversion is involved.

## What the references showed (details: `docs/SPEC.md`; plots in `docs/compare/`, gitignored)

- **Open = one shake**: a broadband burst that swells for 10-89 ms, then falls 20 dB in 58-91 ms, 30 dB in 97-136, 50 dB in 185-241 (two slopes: the tail is slower than the first 20 dB);
  nothing under 500 Hz, a broad maximum at 8-12 kHz (centroid 7.0-11.1 kHz), grain fluctuation 0.15-0.29, no tonal mode that two takes share.
- **Hand = the bottom struck on the palm**: the same noise with an abrupt front (20 dB in 1-3 ms in 6 of 8 takes), a quicker first fall (t20 38-52 ms) and a **broad 2.5-3.2 kHz hump** (+5..+8 dB over Open; Q 1.5-2, not a pitched ring).
  That hump is the only "hard bottom" signature in the recordings; **no separate resonant click was found**.
- **FX = a phrase**: 7-16 bursts, 106-121 ms apart in 7 of 8 takes (sd 8-28 ms), swelling in over ~4 bursts and fading over the last two; each burst is a smaller Open.
- **No alternation** between neighbouring FX bursts (level -4.3..+1.4 dB, mixed signs): no Direction / Back.
- **The 8 takes are 8 instruments (or hands), in two groups**: 2, 3, 4, 7 fuller (Hand centroid 6.7-7.5 kHz), 1, 5, 6, 8 thinner and brighter (10.1-11.1 kHz). The fit targets the fuller four; the tests use the range over all 8.
- Groove clips (`Afro Cuban Caxixi-120bpm`, `Latin Jazz Caxixi-149bpm`): sparse strokes, quarter-note mains and quieter ones between (43 onsets in 8 s). `docs/demo.wav` plays the Afro Cuban clip's rhythm with ours.
- **Nothing about the caxixi itself was looked up on the web**; what is known is what the 24 previews and two clips show.

## Engine

`scripts/caxixi_engine.py` -> gen~ (read its docstring): Shaker's PhISEM (a stroke's energy, random collisions that drive a noise level, three band-pass resonances after a 4th-order high-pass) without Back / Direction, three constant sets
(Open, Hand, FX = Open's) and **one addition, a second slower energy store** (`gs`, `ss`) that gives the two-slope tails the previews show (with one exponential the fits were 30-40 % short at -40 and -50 dB).
The constants are fitted by Nelder-Mead on the Node shim (`tests/fit_types.js`, resonance Q capped at 3); the FX phrase is `m4l/caxixi_midi.js`.

## Fit and tests

Ours (velocity 1, `node tests/fit_refs.js`) against the pooled takes (ms, Hz); the previews' ranges over the 8 takes in brackets:

| stroke | rise | t20 | t30 | t40 | t50 | centroid | grain fluct. (early / late) |
|---|---|---|---|---|---|---|---|
| Open | 36 (11-89) | 77 (58-91) | 114 (97-136) | 155 (142-196) | 227 (185-241) | 9029 (7018-11087) | 0.19 / 0.21 (0.15-0.29 / 0.13-0.28) |
| Hand | 18 (11-56) | 58 (38-52) | 93 (80-112) | 139 (134-190) | 227 (174-266) | 6746 (6651-11144) | 0.19 / 0.19 (0.12-0.28 / 0.14-0.20) |
| FX | 8 bursts, interval 111 ms sd 18 (106-211, sd 8-40) | | | | | 8819 (5891-11093) | ripple 15.4 dB (6-24) |

1/3-octave spectrum, rms difference of ours to the fitted takes: Open 1.5 dB (2.1 to all 8), Hand 1.5 dB (2.4 to all 8), FX 1.4 dB (1.9 to the fitted takes).

- `./build.sh` (generate, GenExpr grammar check, validate, Node tests `tests/test_engine.js`, build `m4l/Caxixi.amxd`, `--type iiii`): green, **88 Node checks** (stability at the extremes, exact silence, each stroke against the
  ranges over the takes and the fitted pool, the FX phrase with `caxixi_midi.js` and a fake Task, every control, the maxpat's codebox equal to the engine's code).
- **Max** (standalone, cold: `scripts/gen_compile.py --cold` compiled OK; `tests/test_max_render.py`): **38/38** (levels within 3 dB of the calibration, bands, centroids and t20 against the ranges, FX burst interval, Length and Rate reaching the js, note-off not cutting a phrase,
  restart, back-to-back notes, every parameter, all strokes at the extremes). The harness now and then returns an unreadable or short render when Max is busy: `play()` renders again (up to 3 times).
  The Rate 12 Hz check's period detector was changed from the highest autocorrelation peak to the first strong one (the scatter smeared the fundamental: it picked 3 periods, 255 ms).
- **Live** (`scripts/live_check.py`): **9/9** (10 parameters and defaults through the LOM, all three strokes sound, FX keeps shaking after a 50 ms note and ends by itself, Max console clean). No "LT" tracks remain in the set.
- Panel screenshot (Live): `docs/screens/panel_live_idle.png`.
- `node tests/render_demo.js` -> `docs/demo.wav` (12.7 s: 43 onsets of the Afro Cuban clip's rhythm, Hand on 20 of them, then two FX phrases; Node-rendered). `--ab` also writes `docs/ab_clip.wav` (the clip, ours at 8.60 s; gitignored).
- `node tests/fit_refs.js --ab` -> `docs/strokes_ab.wav` (42 s, gitignored): per stroke each reference take 1-8, then two draws of ours, peak-normalised. Cues (s):
  **Open** 1 0.00, 2 0.87, 3 1.80, 4 2.71, 5 3.47, 6 4.32, 7 5.07, 8 6.00, **ours 6.95, 8.05**;
  **Hand** 1 9.95, 2 10.90, 3 11.70, 4 12.51, 5 13.35, 6 14.22, 7 15.08, 8 15.89, **ours 16.84, 17.94**;
  **FX** 1 19.84, 2 22.24, 3 23.97, 4 25.93, 5 27.75, 6 29.53, 7 31.93, 8 34.32, **ours 36.54, 38.94**.
- `node tests/render_strokes.js && python3 tests/compare.py` -> `docs/compare/<stroke>.png` (waveform, 1 ms RMS, spectrogram: every take, three draws of ours). The tail ending early was found from these plots, not the numbers.
- Refit: `node tests/fit_types.js Open Hand --write` (~6 min each), then `node tests/calibrate.js --write` twice (until the peaks print 0.2500), `node tests/fit_refs.js --write` (refs.json), `./build.sh`.
  `CAXIXI_FIT_TAKES=1,5,6,8` refits to the thinner takes (not done). The refs (`ref_wav/`) are Ableton's audio: gitignored; `tests/decode_refs.sh` makes them.

## Honest differences and unverified

- **Never heard.** The fit matches rises, tails, spectra and burst rates of recordings; that is not the same as sounding right.
- **The thinner instruments (takes 1, 5, 6, 8) are not covered**: Tone does not reach them (Tone +12 st gives centroid x1.39 in Max; the thin takes are at 10-11 kHz against our 9 kHz for Open).
- Hand's t20 is 58 ms against the previews' 38-52 (the first 20 dB fall a little slow; the tail follows the previews). Open's t40 is 155 against 142-196 (inside, at the low end).
- Not modelled: the 4-6 dB extra at 0.6-1 kHz in the first 4 ms, the hand pre-motion before the front, FX's slow take 7 (211 ms interval), single late seed events beyond the engine's sparse collisions.
- **FX's constants are Open's**: the phrase's timing, swell and scatter are measured, but each burst is not separately fitted. FX phrases cut at 2.0 s in takes 1, 6, 7 of the previews.
- Velocity changes level only (the previews are peak-normalised). Strokes are calibrated to one loudness; their level against each other is not from the references.
- FX is a js Task chain, its timing the scheduler's. CPU is unmeasured. The Node shim and Max agree to a few percent on centroid and t20.
- LatinKit: no pad was added (`../make_kit.py` untouched).
