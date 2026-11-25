# Caxixi: Max for Live instrument spec

Part of the synthesized Latin percussion section (`../LATIN_PERCUSSION_RESEARCH.md`, Shaker family). A caxixi is a small woven basket rattle
(seeds inside) with a hard bottom (gourd or leather); one is shaken in the hand holding the berimbau's stick, or struck on the palm. Forked from
`../Shaker/` (the PhISEM engine, panel, tests, build) the way `../Guiro/` was: three strokes fitted to the Latin Percussion pack's
`Drum Hits/Shaker/Caxixi {1..8} {Open, Hand, FX}` previews. Nothing about the caxixi itself was looked up on the web (no measured data was found or searched for);
what we know is what the 24 previews and two groove clips show.

## What the references are (2026-11-01; `tests/analyze_refs.py`, `tests/compare.py`, ffmpeg-decoded to `ref_wav/`, never committed)

Eight takes (`1..8`) of three strokes, plain ogg, peak-normalised, 0.36-0.55 s (Open, Hand) and 1.3-2.0 s (FX; takes 1, 6, 7 are cut at 2.0 s).

- **Open = one shake.** A broadband noise burst that builds for 10-90 ms (a slow swell, often preceded by a -35..-50 dB hand movement), then falls 20 dB in 58-91 ms,
  30 dB in 97-136, 40 in 142-196, 50 in 185-241 ms (two slopes: the tail is slower than the first 20 dB). Spectrum: nothing under 500 Hz, a slow rise from 1 kHz, a broad maximum at 8-12 kHz
  (centroid 7.0-11.1 kHz). Grain fluctuation (std of 1 ms RMS / 8 ms RMS) 0.15-0.29. No tonal mode that two takes share (a Welch peak search over 8 takes finds different
  frequencies in every take).
- **Hand = the hard bottom struck on the palm.** Same noise, but the front is abrupt (20 dB in 1-3 ms in 6 of 8 takes, after a quiet pre-motion) and the first 20 dB fall faster
  (38-52 ms, against 58-91 for Open) while t30 is the same as Open's (80-112 against 97-136): a quick knock, then Open's tail. It has a **broad 2.5-3.2 kHz hump**
  (1/3-octave levels -12/-13 dB against Open's -19/-20, +5..+8 dB; a Q of 1.5-2, not a pitched ring), present in the first 4 ms and still there 100-200 ms later (-10 dB).
  This is the only "hard bottom" signature the recordings carry.
- **FX = a shaken phrase**, not one stroke: 7-16 bursts a phrase, **106-121 ms apart in 7 of 8 takes (9.3 a second)**, the interval's sd 8-28 ms (take 7 is slower and smeared: the detector
  finds 7 bursts at 211 ms). The phrase swells in over about four bursts (mean level re the loudest burst: -11, -5.7, -4, -3, -1.5 dB) and fades out over the last two (-4.5, -11.5 dB; from
  the 9-burst takes 2-5, 7, 8). Each burst is a smaller Open-like stroke; the troughs between bursts are 6-24 dB down (mean 14).
- **No forward / back alternation.** Shaker's Direction idea was tested on the FX bursts: the level of every second burst against its neighbours' mean is -4.3..+1.4 dB (mean -0.4) and the
  1.5-4 kHz / 9-16 kHz ratio -3.1..+1.9 dB (mean -0.5), signs mixed over the eight takes: no consistent alternating stroke. Direction and Back were therefore **not** carried over.
- **The 8 takes are 8 instruments (or hands), in two groups.** How mid-heavy a take is (1.5-4.5 kHz over 8-14 kHz) correlates across the strokes (r = 0.90 Open-Hand, 0.76 Open-FX,
  0.88 Hand-FX). Takes 2, 3, 4, 7 are the fuller ones (Hand centroid 6.7-7.5 kHz), takes 1, 5, 6, 8 the thinner, brighter ones (10.1-11.1 kHz); Open's centroids are 7.0-9.8 kHz against 10.2-11.1 kHz.
- **The hard-bottom click as a separate component was not found.** In the first 4 ms of an Open stroke 0.6-1 kHz is 4-6 dB higher than in the next 30 ms (not modelled); single wide-band events
  sit in the tails (Open takes 2, 3: 15-20 dB above the tail floor at 100-350 ms: a seed landing late), which the engine's sparse late collisions resemble. A resonant tick of the bottom, as the brief expected,
  is not in these recordings: Hand's hump is broad, Open has none.
- **Groove clips** (`Clips/Afro Cuban Caxixi-120bpm`, `Latin Jazz Caxixi-149bpm`): sparse strokes (quarter-note main strokes at about -1..-3 dB, quieter ones between, 43 onsets in 8 s). Used for `docs/demo.wav` and `docs/ab_clip.wav`.

## The model (`scripts/caxixi_engine.py`: its docstring is the description)

Shaker's PhISEM (see `../Shaker/docs/SPEC.md`) without Back / Direction, three constant sets (Open, Hand, FX), and **one addition: a second, slower energy store** (`gs`, `ss`: its share of the
peak energy and its decay in ms, scaled by Damping) fed by the same stroke. The previews' tails are two-slope; with one exponential the fits came out 30-40 % short at -40 and -50 dB
(Open t40 139 against 142-196 ms, t50 171 against 185-241), and the compare plots showed the tail ending early. With the store the fits land inside the ranges (Open 155 / 227 ms).
Fitted by Nelder-Mead on the Node shim (`tests/fit_types.js`): rate, sp, sdec, sys, shk, gs, ss, the high-pass and three resonances; the time cost now has t40 and t50. Resonance Q is capped at 3 (the first Hand fit
used Q 8 at 6.4 kHz and drew a tonal line in the spectrogram that the previews do not have).

| stroke | fitted to | note |
|---|---|---|
| Open | takes 2, 3, 4, 7 | the fuller instruments; tests hold it to the range over all 8 |
| Hand | takes 2, 3, 4, 7 | its 2.9 kHz resonance (Q 2, gain 0.77) is the bottom |
| FX | Open's constants | each burst is an Open stroke, the phrase is `caxixi_midi.js` |

`CAXIXI_FIT_TAKES=1,5,6,8 node tests/fit_types.js Open Hand --write` refits to the thinner takes (not done; see "What's left").

## The phrase (`m4l/caxixi_midi.js`)

FX plays `round(Length x Rate / 1000)` bursts (default 1000 ms, 9.3 a second: 9): burst `i` at the previous burst's time plus `1000 / Rate x (0.8 + 0.4 r)` ms, `r` uniform 0..1 (sd 12 % of the interval, the previews'
7-24 %); each burst's velocity is the note's x `10^(dB/20)`, dB = `-6 r'` (a ~3 dB scatter, the previews' ~2.7 dB sd) + a ramp `[-8.5, -3, -1.5]` over the first three bursts + `[-1.5, -9]` over the last two. A note-off does not cut the phrase,
a new note restarts it (one Task). `Math.random` is the only randomness; the tests seed it.

## Controls (10 real live.* parameters)

| name | range | default | what |
|---|---|---|---|
| Stroke | Open / Hand / FX | Open | which stroke a note plays |
| Length | 300-2000 ms | 1000 | FX phrase length |
| Rate | 4-16 Hz | 9.3 | FX bursts a second |
| Beads | 25-400 % (exponent dial) | 100 | collision rate; texture, not level |
| Damping | 25-400 % (exponent dial) | 100 | energy decay (also the slow tail) |
| Shake | 25-400 % (exponent dial) | 100 | build-up time |
| Rattle | 0-100 % | 50 | grain length x 0.25..4 |
| Tone | -12..+12 st | 0 | moves the high-pass and resonances |
| Pan | -100..100 | 0 | constant power |
| Level | -36..+6 dB | -6 | |

Every key plays (the key is not the stroke: pick the stroke with the menu; a Drum Rack needs one chain per stroke). Velocity is the stroke's energy. Beads / Damping / Shake / Rattle / Tone are
trims on the fit (100 % / 50 % / 0 st are the fit). The exponent dials (exponent 2.32) are stored linear in travel in Live: nothing here writes presets (no `stored()` conversion was needed); `live_check.py`
verifies the defaults through the LOM.

## Where we are

- 2026-11-01: built. Node 88 checks, Max 38/38 (cold), Live 9/9 (README). Nothing was listened to.

## What's left

1. **Listen** to `docs/strokes_ab.wav` (cues in README), `docs/ab_clip.wav` and `docs/demo.wav`.
2. **The thinner instruments (takes 1, 5, 6, 8)** are not covered: Tone does not reach them (see README). Offer a second set (a menu entry or a morph dial) if they matter.
3. Not modelled: the 4-6 dB extra at 0.6-1 kHz in the first 4 ms, the hand pre-motion before the front, FX's slow take 7, the late single seed events (only the engine's sparse late collisions).
4. Hand's t20 is 58 ms against the fitted takes' 41-52 (the tail follows the previews, the first 20 dB are a little slow).
5. LatinKit: no pad was added (`../make_kit.py` untouched).
