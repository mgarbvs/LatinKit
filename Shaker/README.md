# Shaker

Max for Live instrument: a shaker family (maraca, cabasa, shekere, ganza/chocalho, egg shaker) built on Perry Cook's PhISEM stochastic
particle model (the STK `Shakers` idea), with each Type fitted to recordings. One gen~, ten real `live.*` parameters.
Spec, research and the model: `docs/SPEC.md`. Part of the Latin percussion section (`../LATIN_PERCUSSION_RESEARCH.md`, item 6).

## Playing

- Every note is one **stroke**; velocity is its energy. The **Direction** menu picks the direction: **Key** (default): even MIDI notes (C3 = 60, D3, E3 ...) are forward
  strokes, odd notes (C#3 = 61, F3 ...) back strokes; **Alternate**: every new note flips, forward, back, forward ... (for a Drum Rack pad, which sends one fixed note); **Forward** / **Back**: always that way. Back strokes are `Back` % as loud and build up a little slower, so alternating
  C3 / C#3 plays a 16th-note shake pattern (forward on the beat, back between).
- **Roll**: 0 = off. Above 0, a held note keeps shaking back and forth that many times a second until you let go (the first stroke follows Direction, the rest alternate; Forward / Back
  stay put).
- Not tuned: the key never changes pitch; Tone does. Two notes inside one audio block (~1.3 ms) make one stroke (the second one).

## Panel (functional, DS-style like Cuica; seen in Live: docs/screens/panel_live_idle.png)

Display: a line drawing of the current Type that flashes and jerks along the stroke's direction with every note, the last note's name, the
**Type** menu as the big orange word, orange-outlined **Back / Roll / Direction** (menu) and **Pan / Level**. Dial strip: **Beads, Damping, Shake, Rattle, Tone**.

| control | range (default) | what it does |
|---|---|---|
| Type | Maraca / Cabasa / Shekere / Ganza / Egg | the fitted instrument |
| Beads | 25-400 % (100) | collision rate: separate clicks to smooth hiss; the loudness stays the same |
| Damping | 25-400 % (100) | how long the shaking energy lasts (PhISEM's system decay) |
| Shake | 25-400 % (100) | stroke build-up time: a flick to a slow sweep |
| Rattle | 0-100 % (50) | bead damping: how long each collision rings (grains x0.25..x4) |
| Tone | -12..+12 st (0) | moves the filter and resonances: a smaller or bigger vessel |
| Back | 0-100 % (70) | back-stroke level |
| Roll | 0-16 Hz (0) | hold-to-shake rate |
| Direction | Key / Alternate / Forward / Back (Key) | where each stroke's direction comes from |
| Pan | -100..100 (0) | constant power |
| Level | -36..+6 dB (-6) | |

The five trims (Beads ... Tone) are relative to the Type's fit, so 100 % / 50 % / 0 st always sound like the recording-fitted instrument.

## Engine

`scripts/shaker_engine.py` -> gen~ (read its docstring): a stroke is an impulse through two one-poles into the system energy (exponential decay);
beads collide at random with a probability that follows the energy; each collision adds to a fast-decaying sound level that multiplies noise;
a 4th-order high-pass and three band-passes shape it. The per-type constants (rate, energy dependence, grain length, decay, build-up, high-pass,
3 x f/Q/gain) are fitted, not hand-set: `tests/fit_types.js`.

## Fitted to recordings

Live 12's Core Library one-shots (`.../Core Library/Samples/One Shots/Drums/Shaker/`, plain AIFF/WAV; converted into a scratch dir by `tests/refs.js`,
never committed; `docs/types_ab.wav` is gitignored). Measured by the same code on both sides (`tests/shaker_measure.js`):
rise (onset to the 10 ms RMS peak), t20/t30 (peak to -20/-30 dB), spectral centroid, octave and third-octave band levels, and grain fluctuation
(std of 1 ms RMS / 8 ms RMS: how dense the collisions are, early and in the tail).

Ours (Type at its defaults, velocity 1, forward stroke, mean of 24) against the reference range per Type (ms, Hz; cvE / cvL are the grain
fluctuation early and in the tail; "3rd" is the rms difference between the 1/3-octave spectra, dB, of the pooled references):

| Type | rise | t20 | t30 | centroid | cvE | cvL | 3rd |
|---|---|---|---|---|---|---|---|
| Maraca | 18 (12-27) | 46 (37-47) | 67 (72-78) | 6727 (6834-6843) | 0.23 (0.22-0.23) | 0.24 (0.23-0.27) | 2.1 |
| Cabasa | 17 (21-25) | 40 (27-53) | 56 (36-73) | 10147 (8211-12552) | 0.15 (0.13-0.16) | 0.16 (0.11-0.22) | 0.9 |
| Shekere | 68 (137) | 124 (78) | 173 (171) | 8764 (7905) | 0.32 (0.32) | 0.37 (0.43) | 1.5 |
| Ganza | 27 (23) | 59 (67) | 80 (80) | 9345 (9879) | 0.15 (0.15) | 0.15 (0.17) | 1.9 |
| Egg | 13 (19) | 34 (21) | 50 (78) | 11809 (12673) | 0.22 (0.26) | 0.21 (0.14) | 2.8 |

Octave bands (0.5 / 1 / 2 / 4 / 6 / 8 / 12 / 16 / 24 kHz, dB re the stroke's total) of the pooled references and ours are printed by
`node tests/fit_refs.js`; every band the references have above -30 dB is within 6 dB, and below that ours sits at or under the references'
recording noise floor (ours is cleaner: -69 dB under 500 Hz for the maraca, against -36). The Node tests hold the engine to these ranges
(`tests/refs.json`, with the margins in `tests/test_engine.js`)

`node tests/fit_refs.js` prints this table; `--write` refreshes `tests/refs.json` (numbers only), `--ab` writes `docs/types_ab.wav` (reference then ours).

## Build, test, verify

    ./build.sh                      # generate, GenExpr grammar check, validate, Node tests (tests/test_engine.js), build m4l/Shaker.amxd (--type iiii)
    node tests/render_demo.js       # docs/demo.wav: maraca 16ths alternating forward/back, cabasa, shekere accents, ganza, egg, a roll (Node-rendered)
    node tests/fit_refs.js --ab     # docs/types_ab.wav (gitignored)
    node tests/calibrate.js --write # per-type level trim after any engine change (run until it prints peak 0.2500)
    node tests/fit_types.js Maraca --write   # refit a Type to its references (~6 min; several at once in parallel is fine)

Needs Max / Live (run 2026-10-29: Max 49/49, gen_compile --cold OK, Live 10/10):

    uv run --directory $MAXTEST_DIR python $PWD/tests/test_max_render.py           # standalone Max, cold start
    uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check.py $PWD/m4l/Shaker.amxd     # inside Live
    scripts/gen_compile.py --cold m4l/Shaker.maxpat                                               # the first-compile trap, on demand

## Honest differences and unverified

- **Never heard.** The fit makes spectrum, build-up, decay and grain density match single one-shots (1-3 per Type); that is not the same as
  sounding right, and a one-shot carries its own recording chain (the maraca references have a sharp step at ~3 kHz, the "Shaker Acoustic /
  Long" ones a brick wall near 15 kHz). Ours is cleaner than the references under 1 kHz.
- **Type assignments are judgement.** The library has no labelled shekere, ganza or egg: Shekere = a seed-pod shaker (+ a looped shaker roll for
  the spectrum), Ganza = the generic "Shaker Short / Long", Egg = "Shaker Egg". The shekere has no gourd thump. Its build-up (68 ms) is a
  compromise between the fit (40) and the reference (137). The egg decays 20 dB in 34 ms against 21 ms and then falls faster than the
  reference's tail.
- **Forward / back strokes are assumptions**: Back 70 % and a 25 % slower build. No recording tells forward from back; velocity changes level
  only (the Hard / Soft maraca references differ by under 1 dB per band).
- **Model differences from STK**: enveloped noise instead of impulses into the resonators, a collision rate that follows the energy, a 4th-order
  high-pass plus three parallel band-passes, decays in ms (not per sample). Cook's paper itself was not read (only the abstract-level description
  and STK's source).
- **Max and Live pass** (cold Max 49/49, gen_compile --cold, Live 10/10), so the first-compile rules held. The panel was seen in standalone Max only
  (the Damping dial label is truncated to "Dampi..."; a short name would change the LOM name, so it stays). CPU is unmeasured (coefficients are computed per sample).
- Two notes inside one audio block make one stroke. Roll is a js Task chain, so its timing is the scheduler's.
