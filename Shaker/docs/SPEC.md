# Shaker: Max for Live instrument spec

Part of the synthesized Latin percussion section (`../LATIN_PERCUSSION_RESEARCH.md`, build-list item 6): maraca, cabasa, shekere,
ganza/chocalho and egg shaker from Perry Cook's PhISEM model, in one gen~ with a Type menu.

## Research (2026-10-29)

**PhISEM** (Perry R. Cook, "Physically Informed Sonic Modeling (PhISM): Synthesis of Percussive Sounds", *Computer Music Journal*
21(3), 1997; "Physically Informed Stochastic Event Modeling" is the technique's name inside it): a shaker is a pile of particles in a
vessel. The system energy decays exponentially; each particle collision is a random event whose probability goes with the number of
particles; each collision adds to a sound level that itself decays fast; that level excites one to three resonances (the vessel, the
particles' own ring). The whole synthesizer is four numbers (particles, system decay, sound decay, gain) and a few resonances per instrument.

**STK `Shakers.cpp` (read 2026-10-29, github.com/thestk/stk).** Per sample: `shakeEnergy *= systemDecay`; with probability
`nObjects / 1024` a collision: `sndLevel += shakeEnergy`, the resonators are pinged with `sndLevel`; `sndLevel *= soundDecay`;
resonators are 2-pole (`a1 = -2 r cos(w)`, `a2 = r^2`) times a gain `log(nObjects) * baseGain / nObjects`; a short FIR then high-passes or
low-passes the sum. Its constants (decays are per sample, tuned for 22.05 kHz):

| instrument | sound decay | system decay | objects | resonance (Hz, radius) |
|---|---|---|---|---|
| maraca | 0.95 | 0.999 | 25 | 3200, 0.96 |
| cabasa | 0.96 | 0.997 | 512 | 3000, 0.7 |
| sekere (shekere) | 0.96 | 0.999 | 64 | 5500, 0.6 |
| tambourine | 0.95 | 0.9985 | 32 | 2300 / 5600 / 8100, 0.96 / 0.99 / 0.99 |

(STK also has sleighbells, bamboo, sandpaper, coke can, etc.; STK has no ganza and no egg. Csound's `cabasa`, `sekere` and `tambourine`
opcodes are ports of the same code; not read.)

The STK values were the seed of the fit, not the result: the one-shots in Live's Core Library are brighter and wider than a single 3.2 kHz
resonance (maraca: flat from 3 to 13 kHz).

**What a real shake sounds like (from the Core Library one-shots, `tests/fit_refs.js`).** Strokes build for 12-27 ms (a maraca) to 137 ms
(a seed-pod shaker), then decay 20 dB in 20-90 ms. They are noise-like (the 1 ms RMS fluctuates by 0.11-0.43 of the 8 ms RMS: dense
grains, sparse in the tails) and carry no energy under 1-2 kHz. Cabasa/ganza/egg are brighter (centroid 8-13 kHz) than the maraca (6.8 kHz).

## The model (`scripts/shaker_engine.py`, a docstring there is the current description)

Per sample, in one gen~:
1. **Stroke energy.** A note is a stroke: an impulse of area `vel` through two one-poles (a gamma(2) bump of `shk` ms) feeds the system
   energy `E`, which decays by `sys` ms (exponential). Strokes add (it is linear), so overlapping strokes just work. The impulse is scaled so
   `E` peaks at `vel` for any Shake / Damping.
2. **Collisions.** Probability per sample `rate x Beads x (1 - sp + sp E)` (STK: `sp = 0`, constant). Each adds `E x (0.2..1)` to the sound
   level; the level decays by `sdec` ms (x `4^(+-1)` from Rattle) and multiplies noise. Grain amplitude is scaled by
   `1 / sqrt(rate x Beads x grain length + 1)` so Beads and Rattle change the texture, not the level.
3. **Filter.** A 4th-order high-pass (two identical 2-pole sections) and three parallel band-passes (f, Q, gain), all moved by Tone.
4. Level, constant-power Pan, a clamp at +-1.

**Differences from STK, on purpose:** the resonators are fed enveloped noise (the sound level times a noise sample), not impulses (STK uses
that form itself for its ratchet/guiro types); the rate follows the energy (`sp`); the filter is a 4th-order high-pass plus parallel
band-passes instead of 1-2 resonators plus a FIR; decays are in milliseconds, so they do not change with the sample rate.

## Types and the references

Each Type is fitted (`tests/fit_types.js`, Nelder-Mead on the Node shim) to Live Core Library one-shots in
`Samples/One Shots/Drums/Shaker/`, converted to scratch 48 kHz mono (never committed). The assignments are a judgement; the library has no
shekere, ganza or egg labelled as such.

| Type | fitted to | assumption |
|---|---|---|
| Maraca | Shake Maracas Hard, Soft | |
| Cabasa | Cabasa LD, Cabasa Short Mid, Shake Cabasa Short | |
| Shekere | Shaker SeedPodBangle (stroke), Shaker Acoustic (a looped roll: spectrum only) | a seed-pod shaker is the nearest relative of a gourd in a bead net; no gourd resonance is in the references |
| Ganza | Shaker Short (stroke), Shaker Long (a looped roll: spectrum only) | a metal tube of pellets is bright; the library's generic "Shaker" one-shots are the closest |
| Egg | Shaker Egg | |

**Fit method.** `tests/shaker_measure.js` measures a stroke the same way on a reference clip and on the engine: rise (onset, the first 5 ms RMS
above -26 dB of the peak, to the peak of the 10 ms RMS), t20 / t30 (peak to -20 / -30 dB), band levels over the first 100 ms, centroid, and the
grain fluctuation (std of 1 ms RMS / 8 ms RMS, early within 10 dB of the peak, late from -10 to -25 dB). `tests/fit_types.js` runs Nelder-Mead
on the generated code in the Node shim (the type constants become Params under `SHAKER_FIT=1`; 6 strokes per evaluation, the same noise every
time) in two alternating stages, spectrum (1/3-octave levels, floor -45 dB) then time (rise, t20, t30, grain fluctuation), then jointly.

Result: ours (Type at its defaults, velocity 1, forward stroke, mean of 24) against the reference range per Type (ms, Hz; cvE / cvL are the grain
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

## Controls (10 real live.* parameters)

| name | range | default | what |
|---|---|---|---|
| Type | Maraca / Cabasa / Shekere / Ganza / Egg | Maraca | which fitted instrument |
| Beads | 25-400 % (log) | 100 | collision rate; texture only, not level |
| Damping | 25-400 % (log) | 100 | system decay time |
| Shake | 25-400 % (log) | 100 | stroke build-up time |
| Rattle | 0-100 % | 50 | bead damping: grain length x 0.25..4 |
| Tone | -12..+12 st | 0 | moves the filters |
| Back | 0-100 % | 70 | back-stroke level (and it builds 25 % slower) |
| Roll | 0-16 Hz | 0 (off) | a held note keeps shaking at this rate |
| Direction | Key / Alternate / Forward / Back | Key | stroke direction: note parity / flip every note / always forward / always back |
| Pan | -100..100 | 0 | constant power |
| Level | -36..+6 dB | -6 | |

Beads / Damping / Shake / Rattle / Tone are trims on the Type's fitted values (100 % / 50 % / 0 st are the fit), so the Type menu changes
the instrument without moving the dials.

**Note map:** every key plays; with Direction = Key the key's parity is the stroke's direction: even MIDI numbers (C3 = 60, D3, E3 ...) are forward strokes, odd
(C#3 = 61 ...) back strokes. Alternate flips on every new note (forward first; a Roll keeps alternating); Forward / Back fix it (Roll too). Velocity is the stroke's energy. A held note with Roll > 0 keeps alternating forward/back (Key, Alternate). Two notes inside
one audio block (about 1.3 ms) make one stroke (the second).

## Where we are

- 2026-10-29: **built** (`m4l/Shaker.amxd`, generated by `scripts/build_maxpat.py` + `scripts/shaker_engine.py`): five Types fitted to
  recordings, 10 parameters, DS-style panel with a per-Type line drawing, hold-to-roll in `m4l/shaker_midi.js`.
  - Node `tests/test_engine.js`: 102 checks pass (stability at the extremes, silence, five Types against `tests/refs.json`, levels, direction,
    overlap, every control, the MIDI js with a fake Task, the maxpat's codebox equals the engine's code). `./build.sh` is green.
  - `docs/demo.wav` (Node-rendered, 20 s) and `docs/types_ab.wav` (reference then ours, gitignored) written.
  - **Max and Live (2026-10-29, after the coordinator's report):** standalone Max `tests/test_max_render.py` 49/49 (cold), `scripts/gen_compile.py --cold`
    compiled OK, Live `scripts/live_check.py` 10/10, console clean; panel screenshot `docs/screens/panel_live_idle.png`. Nobody has listened.
- The 13 Max failures first reported were not the engine: `tests/test_max_render.py` took the spectra of the L/R *magnitude* (rectified: strong low-frequency
  energy, centroids collapsed), and Max matches the Node shim (Maraca centroid 6728 Hz in Max, 6727 in Node). The real bug the Beads checks found was in the engine: grain
  amplitude was normalised for incoherent power (1/sqrt(x)), but overlapping grains add as amplitudes, so Beads 400 % was +5 dB and 25 % -4 dB; fixed (see model).
- Two bugs found on the way, both from trusting the shim and the first fit: the stroke-energy normalisation was off by `sys` (hundreds), so the
  first fits ran on a clipped output (the clamp at +-1 put a -35 dB floor under the whole spectrum and pinned `sp`, `sys` at their bounds);
  fit mode now has no clamp. Refits after the fix gave the table above.

## What's left
1. **Listen** to `docs/demo.wav` and `docs/types_ab.wav`; the fit matches spectrum and envelope, not feel.
2. Live's own screenshot of the panel (live_snap.py caught the wrong view); the Max one is in `docs/screens/`.
3. Shekere: the reference (a seed-pod shaker) builds for 137 ms; ours 68 (a compromise, see the engine). Egg: ours decays 20 dB in 34 ms
   against 21 and then falls faster than the reference's long tail (t30 50 against 78). No gourd resonance on the shekere.
4. Back strokes: Back 70 % and a 25 % slower build are assumptions; record or find a real forward/back pair.
5. Roll in real Max: a js `Task.schedule` chain; check its timing at 16 Hz, and what Live does with a long held note.
6. CPU: filter coefficients and soft limits are recomputed every sample (about 30 transcendentals per sample); measure, then move them to
   control rate (every 32 samples, like Cuica) if it matters.
7. More Types from the same engine (tambourine jingles: STK has the numbers; sleigh bells; a pandeiro head), or velocity-dependent brightness
   (the Hard / Soft maraca references differ by under 1 dB in every band, so none was added).
