# Repinique: spec and state

A modal samba repinique (one drum per instance) for Max for Live, forked from Surdo and fitted to four CC0 Freesound recordings (`RESEARCH.md`: sources, licences, what is judgement). Usage and status: `../README.md`.

## What the recordings show (tests/refs.py, 8 takes per stroke)
- **Modes**: one set of fixed absolute frequencies shared by all strokes (pooled 0-0.3 s spectra, 8 Hz smoothing): 250, 286, 323, 356, 389, 440, 510, 576, 634, 678 | 733, 800, 850, 940, 1117, 1211, 1363, 1437, 1616, 1720, 1855, 2096, 2340 Hz. Open / Hand: 356 Hz at 0 dB, 286 (-9), 576 (-6..-10), 1117 (-7..-12). Rimshot: 1117 (0), 573 (-4), 865 (-7), 1363 (-6), 2096 (-10), 359 (-8). Rim: 319 (0), 365 (-6), 937 (-9), 507 (-13), lines at 2.6-4 kHz (-14..-20).
- **No glide**: the 356 Hz tone is 356-357 Hz from 0.1 s in all takes (351 Hz in the first 40 ms is the measuring filter, equal in every take).
- **T60** (`tests/t60.py`, +-2 % band-pass Hilbert envelope, slope to -30 dB, median of the takes where the mode stands 25 dB over the floor): 0.2-0.7 s per mode (`HZ` in the engine); broadband t40: Open / Hand about 210 ms, Rimshot 285 ms, Rim 150 ms.
- **Strokes**: Open (356 Hz, centroid 452 Hz, rise 1.5 ms, a tick of 0.39 of the peak); Rimshot (centroid 1.4 kHz, 36 % of the energy under 1 kHz, 54 % at 1-2.5 kHz, strong shell modes, crack -6 dB); Rim (centroid 1.7 kHz, t20 26 ms, 17 % at 2.5-6 kHz); Hand (like the Open, slower rise 3.9 ms, centroid 541 Hz).
- **Highs above 2.5 kHz** are noise-like (spectral flatness Open -6.2, Hand -6.5 dB, Rimshot -10.5) except the Rim (-14, partly tonal); ours are decaying band-passed noise for all.
- **Takes of one stroke vary a lot** (see README "Known gaps").

## Model (scripts/repinique_engine.py)
Surdo's engine (a bank of pinged 2-pole resonators + band-passed noise, a contact pulse through two one-pole low-passes, per-stroke gains W, kp / G / tau hand damping, Vary jitter, soft-hit damping rule), with:
- **23 sinusoid modes** (`HZ`: 10 head modes below `SHELL_FROM` = 700 Hz at ratios of f1 = 356.5 Hz, which follow Tune, the mod wheel (Press) and nothing else; 13 shell modes at fixed Hz that do not) + **6 noise bands** (2.6, 3.3, 4.2, 5.4, 7.0, 9.5 kHz, `BANDS`). 29 modes, one gen~.
- 5 sounding strokes (Open, Rimshot, Rim, Hand, Mute) and **Flam** as menu index 5 (Bongo's scheme: a Flam starts as an Open and schedules a second Open `FLAM_GAP` = 42 ms later at `FLAM_REL` = 0.45 x; a new stroke in between cancels it).
- No glide (removed: `gl` / `GLIDE_TAU`), no musical variant. `PHASE_SPREAD` 0.35 (Surdo's 1.0 made the Open rise in 7.6 ms against 1.5; 0 gave 0.5 ms; 0.35 a refit gives 2.3 ms).
- **Fit** (`tests/fit.py`): per stroke the mean band profile of the 8 takes (early 0.12 s, ring 0.2-0.7 s), tick from the median of the takes, `G` / `tau` by grid search on t20 / t40 / crack, `ta` from the tone start. `derive_mute()` builds the Mute from the Hand (W of shell modes and noise bands -12 dB, G 5, tau 0.15 s, kp 0.1). `tests/calibrate.py` sets A to `PEAK_DB` (Open -4, Rimshot -2, Rim -5, Hand -6, Mute -11 dBFS at velocity 1: judgement).

## Tests
- `tests/test_voice.js` (36, Node shim): every stroke finite, audible, L == R; Tune moves head modes (-700 ct) but not the shell's 1117 Hz; no glide (< 25 ct); flam; stroke changes over a ringing drum (Mute -10 dB); Decay / Press / velocity / Volume / Touch / Skin; extremes with 6 strokes; `repinique_midi.js`.
- `tests/test_strokes.py` (40): the codebox equals `repinique_engine.code()`; per fitted stroke t20, t40, tick, rise, centroid, crack, flatness, HF level and band profile within margins of the 8 takes; Vary adds about 1.5 dB.
- `tests/test_voice_max.py` (29, standalone Max cold): parameters, each stroke's peak (4.5 dB) and energy (2.5 dB) against the Node shim, Tune / shell / no glide, stroke change, same-tick menu + note, flam, Vary, controls, extremes.
- `scripts/live_check_voice.py` (16): parameters, ranges, every stroke through Live's parameter API (menu 250 ms ahead; the per-window peak_dbfs of that sweep is offset by the harness's timing and reads 5-20 dB under the static render, the centroid per hit confirms the right stroke), Tune, stroke change, wheel.

## Traps
- Python with `-I` loses the user site (numpy): run with plain `python3` from a folder holding only our scripts when reading the untrusted takes.
- A fresh fit seeds W from the takes' band profile; `PHASE_SPREAD` changes the rise and so needs a fresh fit and calibrate.
- Max's peak of the Rim is its noise tick: Node-to-Max peak tolerance 4.5 dB (the energy stays within 1 dB).
