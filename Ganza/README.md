# Ganza

Max for Live instrument: a **ganzá** (the samba metal tube of beads or shot) and a **chocalho** (a frame of platinelas), from Perry Cook's PhISEM stochastic particle model, forked from
`../Shaker/` (Direction, Back, Roll, the panel) and `../Caxixi/` (the two-slope energy store, the fit and test setup). Each Type has a forward and a back stroke fitted to Creative-Commons recordings
(`docs/RESEARCH.md`: URLs, licences, what is judgement). One gen~, eleven real `live.*` parameters. Spec and model: `docs/SPEC.md`. Part of the Latin percussion section (Shaker family).

## Playing

- Every note is one stroke; velocity is its energy. The **Stroke** menu picks the stroke (index-stable, for Drum Rack pads):
  **0 Key** (even MIDI notes, C3 = 60, D3 ... are forward strokes, odd notes back), **1 Alternate** (every new note flips: forward, back, forward ...), **2 Forward**, **3 Back**, **4 Accent**
  (a forward stroke played harder: +4 dB and a harder click where the beads hit the end cap).
- **Forward** is the louder, brighter stroke with a hard front (the beads hitting the end cap: a short wide-band click). **Back** is rounder: quieter (ganzá -5.3 dB, chocalho -8.7 dB re forward, as in the recordings), slower to build, a little longer, no click;
  darker on the ganzá, brighter on the chocalho.
- **Roll**: 0 = off. Above 0 a held note keeps shaking back and forth that many times a second (a samba 16th feel is 7-9 a second) until you let go; the note's own stroke follows Stroke, the rest alternate (Forward / Back stay put; only the first stroke of an Accent roll is an accent).
- **Type**: Ganzá (bright, a faint ringing of the tube wall at 4.5 and 9 kHz, an end-cap click) or Chocalho (the platinelas: slower, ringing plates, no click). The chocalho is a Type, not a separate device, because real single forward and back strokes exist for it (CC0) and it plays the same gesture
  (reasoning in `docs/RESEARCH.md`).
- Not tuned: the key never changes pitch; Tone does. Two notes inside one audio block (~1.3 ms) make one stroke (the second one).

## Panel (functional, DS-style like Shaker / Caxixi; seen in Max: `docs/screens/`)

Display: a line drawing of the current Type (the ganzá tube with its beads sliding to the end the stroke goes to and a cap-impact mark; the chocalho frame of platinela rows) that flashes (harder on accents) and jerks with every stroke, the last note's name,
the **Type** menu as the big orange word, orange-outlined **Back / Roll / Stroke** (menu) and **Pan / Level**, dials **Beads, Damping, Shake, Rattle, Tone**.

| control | range (default) | what it does |
|---|---|---|
| Type | Ganzá / Chocalho (Ganzá) | the fitted instrument |
| Back | 0-200 % (100) | back-stroke level; 100 % is the recording's (ganzá -5.3 dB, chocalho -8.7 dB) |
| Roll | 0-16 Hz (0 = off) | hold-to-shake rate |
| Stroke | Key / Alternate / Forward / Back / Accent (Key) | where each stroke's direction comes from |
| Beads | 25-400 % (100), exponent dial | collision rate: texture, not level |
| Damping | 25-400 % (100), exponent dial | energy decay: the tail (the first 20 dB are set by the build-up) |
| Shake | 25-400 % (100), exponent dial | build-up time |
| Rattle | 0-100 % (50) | grain length x 0.25..4 |
| Tone | -12..+12 st (0) | moves the high-pass and the resonances |
| Pan | -100..100 (0) | constant power |
| Level | -36..+6 dB (-6) | |

Beads / Damping / Shake / Rattle / Tone / Back are trims on the fit (100 % / 50 % / 0 st / 100 % are the fit). The exponent dials are stored linear in travel in Live (`live_check.py` reads them back through the LOM); nothing here writes presets, so no `stored()` conversion is involved.
**For a kit (LatinKit):** Stroke menu indices Forward = 2, Back = 3, Accent = 4 (Key 0, Alternate 1); Type Ganzá = 0, Chocalho = 1.

## Engine

`scripts/ganza_engine.py` -> gen~ (read its docstring): Shaker's PhISEM (stroke energy, random collisions driving a noise level, a 4th-order high-pass and three band-pass resonances) plus Caxixi's slow energy store, and what makes a ganzá a ganzá:
forward / back (level `bk`, build `bks`, decay `bkd`, tone `bkt` per Type, all measured), the **end-cap click** (`clk`, `cdec`; forward strokes only, x2.5 on an accent), two narrow **ring modes** (`rings`: the tube wall / the platinelas, not moved by Tone), and an **accent** (x1.6).
The fitted constants come from Nelder-Mead on the Node shim (`tests/fit_types.js`); click, rings, back constants and the accent are set from measurements by hand (see SPEC).

## Fit and tests

Ours (velocity 1, `node tests/fit_refs.js`) against the reference strokes (ms, Hz; ranges in brackets over the 7 forward strokes; the ganzá's are cut from a loop, so only rise and t20 are measurable):

| stroke | rise | t20 | t30 | t40 | t50 | centroid |
|---|---|---|---|---|---|---|
| Ganzá forward | 25 (16-52) | 51 (25-56) | 83 | 184 | 352 | 10269 (10341-11342) |
| Ganzá back | 32 (24-57) | 73 (54-111) | 124 | 256 | 430 | 9798 (9877-10365) |
| Chocalho forward | 37 (25-52) | 76 (52-98) | 121 (98-125) | 196 (145-366) | 360 (257-478) | 8589 (8275-9392) |
| Chocalho back | 48 (33-95) | 114 (79-117) | 171 (130-194) | 281 (192-400) | 437 (301-471) | 8986 (9062-9809) |

1/3-octave spectrum, rms difference to the reference mean: Ganzá 1.1 dB (forward and back), Chocalho 0.8 / 1.5 dB. The ganzá's 16th pattern (alternating, 118 ms): peak-to-trough 20.7 dB (the loop 20.8), loud vs soft 6.8 dB (5.3), centroids 10.3 / 9.8 kHz (10.95 / 10.3).

- `./build.sh` (generate, GenExpr grammar check, validate, Node tests `tests/test_engine.js`, build `m4l/Ganza.amxd`, `--type iiii`): green, **113 Node checks** (stability, silence, both Types x forward / back against the recordings, the 16th pattern, accent, click, ring modes, every control, the note map and Stroke menu, the maxpat's codebox equal to the engine's code).
- **Max** (standalone, cold: `scripts/gen_compile.py --cold` compiled OK; `tests/test_max_render.py`): **36/36** (levels within 3 dB of the calibration, bands, centroid and t20 against the recordings, Stroke Back / Accent levels, Key / Alternate, Roll, back-to-back notes, every parameter, extremes). **Live** (`scripts/live_check.py`): **10/10** (11 parameters and defaults through the LOM, both Types sound, back / Forward / Accent levels, Roll, Max console clean). The "LT DUT" test track was deleted afterwards.
- `node tests/fit_refs.js --ab` -> `docs/strokes_ab.wav` (62.7 s, gitignored): every reference stroke then ours (cues printed by the script; Ganzá forward 1-7 from 0.00 s, back 1-7 from 8.93 s, Chocalho forward from 18.16 s, back from 38.07 s, then the ganzá loop at 58.02 s with ours at 60.37 s).
- `node tests/render_demo.js` -> `docs/demo.wav` (18 s: ganzá 16ths at 112 BPM with accents, a chocalho joining, a roll; Node-rendered).
- `node tests/render_strokes.js && python3 tests/compare.py` -> `docs/compare/<Type>_<dir>.png` (waveform, 1 ms RMS, spectrogram: every reference stroke, three draws of ours; gitignored).
- Refit: `node tests/fit_types.js Ganza Chocalho --write` (~6-10 min each), then set the click / ring gains if the spectrum moved, `node tests/calibrate.js --write` until it prints the same CAL twice, `node tests/fit_refs.js --write` (refs.json), `./build.sh`.
  The references (`ref_wav/`) are CC-licensed downloads, gitignored; `tests/segment_refs.py` cuts the ganzá loop.

## Honest differences and unverified

- **Never heard.** The fit matches rises, tails, spectra and the 16th pattern's depth; that is not the same as sounding right.
- **One ganzá recording** (a loop, titled "de arroz": rice; metal not confirmed). Its strokes are truncated by their neighbours, so single-stroke tails are not measured; the slow store (0.3, 150 ms) was set to reproduce the pattern's peak-to-trough depth, not fitted.
- **Click, ring gains, accent** are judgement (see `docs/RESEARCH.md`): the recordings show the forward stroke's harder front and faint 4.46 / 9 kHz lines, but no isolated cap hit. The accent is +4 dB because the loop's loudest stroke is 4 dB over its neighbours.
- Damping barely moves the first 20 dB (t20 51 ms at 100 %, 48 at 25 %, 90 at 400 %): the stroke's build-up (Shake) limits it; it works on the tail (t50 150 / 354 / 883 ms).
- `bk` (x0.62 ganzá, x0.466 chocalho) is not the recordings' amplitude ratio (0.54 / 0.37): a back stroke's slower build lowers its 10 ms RMS peak by ~2 dB, so `bk` was raised until the measured peak ratio matches (-5.3 / -8.7 dB).
- A back stroke's build / decay / tone offsets (`bks`, `bkd`, `bkt`) come from the recordings' averages (7 + 7 strokes each); the spread between strokes is large (rise 24-57 ms).
- The tube is a 2-mode ring plus the broad resonances, not a modal model of a cylinder; Tone does not move the rings.
- Roll is a js Task chain (Max's scheduler timing); CPU is unmeasured. LatinKit: no pad was added (`../` untouched).
