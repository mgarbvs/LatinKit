# Conga: spec and state (2026-10-29)

A physically-modelled conga for Max for Live: quinto, conga (segundo) and tumba, six strokes each, one gen~. Research in `RESEARCH.md`; usage in `../README.md`.

## Model (scripts/conga_engine.py)
- Per drum, 14 damped resonators (pinged 2-pole rotations, control rate 16 samples): two body modes (0.30, 0.52 x f1) and the head's modes at 0.80, 1.00, 1.17, 1.57, 1.77, 2.06, 2.30, 2.65, 3.2, 3.9, 4.8, 6.2 x f1, each with its own open-stroke T60 (`MODES`).
- A stroke = force pulse (impulse through two one-pole low-passes, cutoff `fc` per stroke; Touch/velocity opens it, Slap opens the slap's) into the modes with per-stroke gains `W[m]`, plus a band-passed noise burst (the contact tick / the slap's crack: `nl nf nq nt`, per-drum level `NOISE_DRUM`).
- The hand: at the hit the ring already on the head is multiplied by `kp` (mute 0.15 ... open 0.85), and every mode's decay rate is multiplied by `1 + (G[m] - 1) c(t)`, `c` falling from 1 with the stroke's release `tau`.
- Controls: per-drum Tune (st), Decay (% T60), Skin (+-6 dB/oct tilt of mode gains), Slap (crack level and brightness of the slap), Shell (level of the two body modes), Touch (velocity -> contact bandwidth), Press (mod wheel -> all drums up to 12 st, smoothed), Spread (pan), Level. 11 live parameters, no hidden state.
- Hits arrive as counters `tr0..17` / velocities `vl0..17` from `conga_midi.js` (slot = drum*6 + stroke). If two strokes of one drum land in one audio block the higher stroke index plays (the other is dropped).
- Tables (`scripts/conga_tables.json`: W, G, tau, fc, noise, A, kp) come from `tests/fit.py fit` (band profile of the first 40 ms and of 60-360 ms, matched per mode band to the recordings) and `tests/calibrate.py` (peak per stroke; targets `PEAK_DB`, a judgement). Regenerate both after changing `MODES`.

## Verification
`./build.sh` (Node: 47 engine checks, 63 stroke-fit checks); `tests/test_max_render.py` (standalone Max cold start: 37 checks); `scripts/live_check.py` (Live: 25 checks). See the README for commands.

## Where we are
- Built and tested in Node, standalone Max (cold compile first try) and Live 12 (2026-10-29). Panel is functional DS-style (jsui drawing of three drums that flash, orange Tune boxes, 8 dials); screenshot in Live: `panel_live_idle.png`.
- Unheard: nobody has listened to `docs/demo.wav` or `docs/strokes_ab.wav`; the fit is numeric.
- Known differences from the recordings: attack (10 % -> peak of the 1 ms envelope) is 0.5-0.9 ms vs 2.5-8 ms (their contact is softer and their tick comes first); slap t-20 is 55 ms vs 27 (we tail longer early); heel centroid and crack are up to 100 Hz / 5 dB high on quinto and conga; the bands above 3 x f1 are matched only in early energy (the recordings' ring there is room noise).
- Not modelled: pitch glide with amplitude (no measurement exists; literature cheap-model is in RESEARCH.md section 3), per-drum shell resonance fixed in Hz, slap-open vs slap-mute as separate strokes (the slap is fitted to the mean of both), bass stroke has no recording.

## What's left (ordered)
1. Listen (demo.wav, strokes_ab.wav) and correct by ear: slap tail, mute thud, heel level.
2. Separate "slap mute" stroke or a Slap-hold control; amplitude-dependent glide (Press-like, few tens of cents).
3. Look round for the panel; a Live screenshot.
4. Tumbao patterns as a MIDI clip; drum-rack friendly kit preset.
