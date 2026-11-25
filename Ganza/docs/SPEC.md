# Ganza: Max for Live instrument spec

Part of the synthesized Latin percussion section (`../LATIN_PERCUSSION_RESEARCH.md`, Shaker family). A **ganzá** is the samba metal tube of beads or shot, played in continuous back-and-forth 16ths with accents;
a **chocalho** is a frame of platinelas (jingles) played the same way. Forked from `../Shaker/` (Direction menu, Back, Roll, panel) and `../Caxixi/` (the two-slope energy store, take-based fit and tests);
Shaker's own "Ganza" Type (fitted to generic Shaker one-shots) was only the seed of the ganzá constants. Research, sources, licences: `docs/RESEARCH.md`.

## The references (2026-11-03; `tests/analyze_refs.py`, `tests/segment_refs.py`, `tests/fit_refs.js`; `ref_wav/`, gitignored)

- **Ganzá**: one CC0 recording, "Ganzá de arroz" (a loop of 15 strokes, 118 ms apart = 16ths at ~127 BPM). Even strokes (the louder) = forward, odd = back. Cut trough to trough into 14 strokes (`arroz_s01..14`).
  Forward vs back: level -5.3 dB (mean over 7 + 7), centroid 10.9 vs 10.2 kHz, rise 29 vs 36 ms, t20 45 vs 84 ms, a harder front on forward strokes (crest 1.24 vs 0.92). Peak to trough between strokes 20.8 dB (a shelf of the neighbours' tails).
  Faint narrow lines at 4.46 and 9.0 kHz (+3..5 dB), also in a CC BY metal shaker (4.47 / ~9 kHz) and a second CC0 ganzá (4.7 / 8.9 kHz). Because every stroke carries its neighbours' tails, t30+ cannot be measured (`trunc`).
- **Chocalho**: CC0 "Samba Chocalho de Platinela" Forward 1-7 and Back 1-7, single strokes with full tails. Back: -8.7 dB, rise x1.4, t20 x1.4, centroid +8 % (brighter). Platinela lines at 4.2 / 5.9 / 10.1 / 11.4 kHz. Forward crest 0.44 (no hard front).
- **Nothing** in the Ableton Latin Percussion pack is a ganzá; no recording shows an isolated end-cap hit; `docs/RESEARCH.md` lists what is judgement.

## The model (`scripts/ganza_engine.py`: its docstring is the description)

Shaker's PhISEM: a stroke adds energy (an impulse through two one-poles, then exponential decay `sys`), beads collide at random with a probability that follows the energy, each collision adds to a fast-decaying sound level that multiplies noise,
a 4th-order high-pass and three band-pass resonances shape it, all moved by Tone. Plus Caxixi's second, slower energy store (`gs`, `ss`), and for the ganzá:

- **Direction** (`dir` from the js): a back stroke is `back` x `bk` as loud, builds (1 + `bks`) x slower, decays (1 + `bkd`) x slower and is `bkt` semitones off in Tone, per Type, from the recordings (Ganzá bk 0.62 (a measured peak ratio of -5.3 dB), bks 0.25, bkd 0.7, bkt -1.2;
  Chocalho 0.466 (-8.7 dB), 0.42, 0.38, +1.3). `back` is the user's Back dial relative to that (1 = the recording).
- **End-cap click** (Ganzá `clk` 1.5, `cdec` 1.5 ms): on a forward stroke (not back) a short burst of noise of amplitude vel x clk is added to the sound level, before the filters, so it also rings the shell. The click is a judgement calibrated to the forward crest (1.12-1.3 vs the recordings' 1.24); Chocalho has `clk` 0.
- **Ring modes** (`rings`, two per Type): narrow band-passes (Q 40) fed by the same high-passed noise, not moved by Tone; Ganzá 4460 Hz (gain 0.35) and 8960 Hz (0.5), Chocalho 4230 (2.8) and 5860 (2.2); gains set so each line stands +3..5 dB over its neighbours in a long pattern (`tests/test_engine.js` holds them to 1.5..9 dB).
- **Accent** (`acc`): the stroke x1.6 (+4 dB) with a click x2.5 (a forward stroke, so no back accents).

Fitted by Nelder-Mead on the Node shim (`tests/fit_types.js`): rate, sp, sdec, sys, shk, the high-pass and three resonances (the ganzá keeps `gs` 0.3, `ss` 150, set so a 118 ms pattern's peak-to-trough depth matches the loop's 20.8 dB; the chocalho also fits `gs`, `ss`).
Forward spectrum error 1.1 dB (Ganzá), 0.8 dB (Chocalho).

## The js (`m4l/ganza_midi.js`)

Every note-on is one stroke: out 0 `vl`, `dir`, `acc`, `tr` (the counter last: gen~ sees only the last Param value per block, so a gate edge could be lost); out 1 the display's `hit note vel dir acc`.
Stroke menu (the `direction` message): **0 Key** (note parity), **1 Alternate**, **2 Forward**, **3 Back**, **4 Accent**. Roll: a Task chain at 1000 / Roll ms while a note is held; its strokes alternate (Forward / Back fixed); only a note's own stroke can be an accent.

## Controls (11 real live.* parameters)

| name | range | default | what |
|---|---|---|---|
| Type | Ganzá / Chocalho | Ganzá | which fitted instrument |
| Back | 0-200 % | 100 | back-stroke level re the fit |
| Roll | 0-16 Hz | 0 | hold-to-shake rate |
| Stroke | Key / Alternate / Forward / Back / Accent | Key | stroke direction source / accent |
| Beads | 25-400 % (exponent dial 2.32) | 100 | collision rate: texture, not level |
| Damping | 25-400 % (exponent dial) | 100 | energy decay (the tail) |
| Shake | 25-400 % (exponent dial) | 100 | build-up time |
| Rattle | 0-100 % | 50 | grain length x 0.25..4 |
| Tone | -12..+12 st | 0 | moves the high-pass and resonances |
| Pan | -100..100 | 0 | constant power |
| Level | -36..+6 dB | -6 | |

The exponent dials are stored linear in travel in Live; nothing here writes presets, `live_check.py` verifies the defaults through the LOM. **Kit pads (LatinKit):** Stroke Forward = 2, Back = 3, Accent = 4; Type Ganzá = 0, Chocalho = 1.

## Where we are

- 2026-11-03: built. Node 113 checks (`./build.sh` green). Max standalone (cold, `gen_compile.py --cold` OK) `tests/test_max_render.py` 36/36; Live `scripts/live_check.py` 10/10, console clean; no LT tracks left.
- Panel screenshot (Live): `docs/screens/panel_live_idle.png`.
- Nothing was listened to. `docs/strokes_ab.wav` (reference then ours) and `docs/demo.wav` exist.

## What's left

1. **Listen** to `docs/strokes_ab.wav` (cues in the README) and `docs/demo.wav`.
2. Only one ganzá recording: a second, clearly metal ganzá (and an isolated end-cap hit) would settle the click, the ring gains and the accent.
3. Damping does not shorten the first 20 dB (build-up limits it); only the tail.
4. Menu word "Chocalho" is truncated on the panel; widen the Type menu or shorten the word.
5. LatinKit: no pad was added (`../make_kit.py` untouched).
