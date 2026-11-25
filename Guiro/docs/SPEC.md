# Guiro: Max for Live instrument spec

Part of the synthesized Latin percussion section (`../LATIN_PERCUSSION_RESEARCH.md` section 5 "Scrapers", build-list item 7): a güiro and a
samba reco-reco as one event-train engine with a Type menu. The research note calls the scraper "a suggestion, not a cited method: a PhISEM-style
event train whose rate follows scrape speed, each event ringing a resonator"; this device is that suggestion, fitted to recordings.

## Research (2026-10-31)

**Physics, as far as it is cited.** A stick drawn over evenly spaced ridges makes one impact per ridge: the impact rate is stroke speed divided
by ridge spacing, and each impact rings the body. The only source that says so in as many words is a web page on "stochastic percussion
mechanics" (vectree.io; no measurements, unknown reliability); Agarwal et al., "Object-based synthesis of scraping and rolling sounds based on
non-linear physical constraints" (DAFx 2021, arXiv 2112.08984) is the nearest peer-reviewed model (source-filter, a contact force with
non-linearities), and was not read beyond its abstract. **No measured güiro data was found** (ridge count, stroke length, notch spacing): searches
for acoustic studies returned only descriptive pages (notch spacing and depth change the tone; longer güiros are lower). The numbers below are
all measured from the Latin Percussion previews in this repo's environment.

**STK `Shakers.cpp` (read 2026-10-31, github.com/thestk/stk).** Type 19 is a güiro: 128 "parts", sound decay 0.95 per sample, two resonances
(2500 Hz and 4000 Hz, radius 0.97, equal gains), a high-pass equaliser (1, 0, -1). It is a *ratchet*: the energy ramps linearly down by
`ratchetDelta + 0.002 E` per sample and, when it passes zero, resets to 1 and decrements `ratchetCount`; every note-on adds a tooth (and a
MIDI "breath" control change sets the speed from how many teeth the controller moved). During each tooth, random events add `E^2` to the sound
level, which multiplies noise and rings the two resonators. So STK's guiro is also an event train at a controllable rate with a saw-tooth
envelope per ridge; its constants are not fitted to anything. This device keeps the idea (a rate-driven train, each event ringing resonators)
but makes the rate an explicit, measured gesture instead of a ratchet counter, and fits the resonances to recordings.

**The CR-78 güiro** (`../CR78/`) is the analog cousin (a gated multivibrator into an LC tank); not used here.

## What the previews show (`tests/refs.js`, `tests/guiro_measure.js`, `docs/refplots/`)

Latin Percussion previews `Guiro {A,B,C,D} {Up,Down,Top,Long}` (one take each; D has no Down, plus a `D Reverse Up`), peak-normalised, decoded to 48 kHz mono.
Takes A-D are four different instruments or hands, not four takes of one: centroids run 2.8-11 kHz, and the ridge ticks are separate in A and
smeared into noise in C. So a stroke's reference is a **range over the takes**, and the engine's Ridge dial spans it.

| stroke | what it is | length (onset to last -20 dB) | impacts | impact rate (detected) |
|---|---|---|---|---|
| Up | a short scrape | 65-105 ms | 7-19 | 115-235 /s |
| Down | a longer scrape, slower, ends with a late stray tick | 110-130 ms | 8-19 | 70-140 /s |
| Long | a full scrape | 480-600 ms (D: 155) | 25-78 | 40-145 /s (A is the coarse one) |
| Top | **a single tap**: one sharp impact, then a noise-like broadband decay (-20 dB at 18-55 ms, -30 dB at 50-100 ms), no new impacts | 16-58 ms | 1 | - |

- **The ridge rate is not a sweep.** The rate in the first / middle / last third of a stroke is flat within the (noisy) measurement for Up and
  Long; only Down slows down (mean thirds 140 / 129 / 86 /s). The hypothesis in the research note that "the rate rises and falls over the
  stroke as the hand accelerates" is not visible in these previews. The level does fall at the end (the last third's impacts are 3-17 dB under the first third
  in Up and Down, 2-6 dB in Long) and Down builds for 55-65 ms (the loudest 10 ms is late).
- **Groove clips** (Son Montuno 150 bpm, Cha-cha-cha 127, Guajira 85, Salsa 200): the Long scrape is ~0.7-1.3 beat long (270-630 ms; it follows the tempo),
  at ~140-150 impacts/s; the shorts are 70-125 ms with 9-22 impacts. The cell is **Long, short, short** (Guajira: Long on beat 1, shorts on 2 and 2.5 of a two-beat cell;
  Cha-cha-cha: Long on the beat, one short on the "and" of the second beat).
- **Body.** The previews have little low-frequency energy (-18 to -40 dB under 1 kHz re the total) but it is tonal and take-specific: a strong ~300 Hz
  mode (A 293/312 Hz, B 274 Hz, C 377/395 Hz) that persists after the click, with weaker modes near 650-800 Hz (A, B) and 1.75-2.2 kHz (C, D). Above that the click is
  broadband and bright (a rise from 1.5 kHz to a hump at 3-12 kHz, a low-pass at ~18 kHz from the previews' own codec).
- **What "Top" is.** One impact and a decaying broadband tail, without scrape: the stick tapped on the instrument (the ridged side, or the body). It
  decays in two slopes (about -12 dB by 5-10 ms, -20 dB by 20-30 ms, -30 dB by 50-100 ms).
- **Up vs Down** differ in length, rate and shape, not in spectrum: Down is ~1.5x longer, ~0.7x the ridge rate (70-140 vs 115-235 /s), builds slowly and
  slows down; Up is fast and fades at the end. (No recording tells which is physically "up": the mapping is the pack's names.)
- `D Reverse Up` is a reversed recording or a reversed-envelope sample (each impact swells and cuts off): left out of the fit.
- The Core Library's `Guiro Vintage Cut` (101 ms, low-mid heavy, 2-5 kHz) and `Guiro 110 bpm` loop were looked at but not fitted.

## The model (`scripts/guiro_engine.py`; its docstring is the current description)

Per sample, in one gen~:
1. **Gesture.** A note starts a stroke of the chosen kind. The impact rate is `130/s x Type x stroke factor x Ridge x Speed x (1 + curve (0.5 - u) 2)` for the stroke's length
   (u = position in the stroke); a phase accumulator fires one impact per ridge, the first with the note. Each interval is jittered by Vary (at most +-35 % x Vary).
2. **Impact.** Level = velocity x (attack, end taper) x a random factor from Vary. It kicks (a) a fast level (`sdec` ms) times noise, through a 4th-order high-pass and three
   band-pass resonances (the bright tick), (b) a Top tap only: a slow noise level (`rtau` ms; the broadband tail), (c) three tonal body modes rung by an impulse
   (frequency, decay, gain; the gourd), weaker in a scrape (the hand holds the gourd).
3. Tone shifts the filters and the body modes together; level, constant-power pan, a clamp at +-1.

## Types

- **Güiro**: fitted (`tests/fit_types.js`, Nelder-Mead on the Node shim) to takes **A and B** (a ~300 Hz body, separate ridges); tested against the A-D range. C is brighter (centroid
  10 kHz): Tone +4..+12 st reaches it.
- **Reco-reco** (menu index 1, shown "Reco"): the samba metal-spring reco-reco, **fitted to one Freesound recording** (2026-11-03; sources, licences, what the recording shows and what was not found: `RESEARCH.md`). The same engine: trm 3.0 (390 impacts/s at Ridge 100 %: an estimate, the impacts are fused), a 1.65 kHz high-pass, three noise resonances (7.9, 12.6 and 3.2 kHz, Q ~1.6), three tonal spring modes (1.6 kHz 128 ms, 2.7 kHz 328 ms, 3.3 kHz 76 ms decay constants), tails fitted to the ring-out after a run. Fit: `tests/fit_reco.js` (Nelder-Mead on the Node shim like `fit_types.js`; targets: pooled 1/3-octave spectrum of 71 clips, ring-out t10 / t20 / t30 and the 1.2-3.8 kHz / 6-16 kHz tilt, spring-line prominence); result 2.4 dB rms, ring 50 / 178 / 463 ms against 57 / 160 / 379, line prominence 20 against 17 dB. The bamboo reco-reco is not modelled. Before this fit the entry was an unfitted judgement (1.3x ridge rate, 6 / 9 kHz resonances); a preset saved on it changes sound.

## Strokes, Stroke menu and notes

Stroke menu: **Key** (default; pitch mod 4: C3 Up, C#3 Down, D3 Long, D#3 Top, E3 Up ...) / **Up** / **Down** / **Long** / **Top** (always that stroke: a Drum Rack pad sends one fixed note, so
use a chain per stroke or Alternate) / **Alternate** (Up, Down, Up ... on every new note). A long-short-short cell is Long, Up, Down. **Roll** (0-12 Hz): a held note keeps scraping
that many strokes a second (Up and Down alternate in Key and Alternate; the others repeat). Velocity is the stroke's energy.

## Controls (10 real live.* parameters)

| name | range | default | what |
|---|---|---|---|
| Type | Güiro / Reco-reco (index 0 / 1) | Güiro | the Reco-reco is menu index 1; a Type change never reorders |
| Length | 100-1500 ms | 450 | the Long stroke's length (the previews: 480-600 ms, D 155) |
| Roll | 0-12 Hz | 0 | hold-to-scrape |
| Stroke | Key / Up / Down / Long / Top / Alternate | Key | |
| Pan | -100..100 | 0 | constant power |
| Level | -36..+6 dB | -6 | |
| Speed | 25-400 % (log) | 100 | stick speed: the same ridges in less time (rate x, length / x) |
| Ridge | 25-400 % (log) | 100 | ridge density: more ridges in the same time (rate x, length the same) |
| Tone | -12..+12 st | 0 | moves the click's filters and the body |
| Vary | 0-100 % | 50 | ridge-to-ridge timing and level scatter |

Speed and Ridge both scale the impact rate (impacts/s = speed / spacing). Speed is the hand: a faster stick crosses the same ridges in less time (the stroke gets shorter,
the number of ticks stays). Ridge is the instrument: more ridges in the same time. Both are loudness-neutral.

## Where we are

- 2026-10-31: **built** (`m4l/Guiro.amxd`, generated by `scripts/build_maxpat.py` + `scripts/guiro_engine.py`): Güiro fitted to the previews, Reco-reco a judgement, ten parameters, DS-style panel
  with a drawing and a scraping stick, hold-to-scrape (Roll) in `m4l/guiro_midi.js`. Numbers, gaps and the test counts are in `README.md`.
- Method notes (what went wrong on the way, so the next scraper does not repeat it):
  - The first impact detector (a 6 dB rise in 1 ms, above 3 kHz) was validated against the engine's own impact times (`fire`): it finds them when ridges are separate and under-counts above ~150 /s. An envelope-autocorrelation
    rate was tried (within 6 % on the engine, but picks octaves on the refs: A_Long 80 against 40). Both are reported with that caveat; the tests check the engine's rate against its own impact times and the detector only against the range.
  - Band-energy and decay numbers hid three real problems that the compare plots showed (`docs/compare/*.png`): a tonal 300 Hz body ring that made the full-band decay look right while the broadband tail was missing
    (the envelope metrics now look above 1 kHz); a Top that was 3 kHz too dull (the tap now has its own resonance shift, `kT`); a body that was too strong in Down / Top (per-stroke body weights).
  - The first CAL run was on a clipped output (the engine clamps at +-1 and an uncalibrated stroke is far louder): calibrate at Level -40 dB. The Shaker note said the same about the fit; the fit runs unclamped.
  - A fit's `--write` regex that stops matching after the table gains a field fails silently (printed "patched", changed nothing): check the diff of TYPES after a fit.
  - `pgrep -f <name>` in a wait loop matches the loop's own command line and never ends.
- 2026-11-03: **Reco-reco fitted** (`docs/RESEARCH.md`, `tests/fit_reco.js`, `tests/reco_refs.sh`, `tests/reco_ab.js`); panel draws a metal box with three springs for Type 1. Node 123, Max 54/54, Live 15/15. Güiro untouched (bit-identical, golden fingerprint test). Gaps: one recording through an mp3 preview, impact rate estimated, three modes for ~30 spring lines, no bamboo form, unheard.
