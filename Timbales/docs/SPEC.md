# Timbales: spec and state (2026-10-30)

One timbal (High or Low), six strokes, one gen~. Research in `RESEARCH.md`; usage in `../README.md`. Structure copied from `../../Conga` (Conga Voice).

## Model (scripts/timbales_engine.py)
- **Head**: 8 damped resonators (pinged 2-pole rotations, control rate 16 samples) at 1.00, 1.94, 2.15, 3.15, 4.15, 5.15, 6.0, 7.0 x f1 (High 200 Hz, Low 120 Hz at Tune 0), open-stroke T60 0.5 / 0.9 / 0.9 / 0.7 ... 0.4 s (High; Low x3), from per-band decays of the open recordings (round 2). Tune and the mod wheel (Press) move them.
- **Shell**: 16 modes at fixed Hz; the top 5 (2593 .. 8700) are **noise bands** (white noise through a Q 2 state-variable band-pass, amplitude decaying at the mode's T60; same windows, `W` and Shell/Ring controls as the sinusoids, excitation = the stick's contact gain at that frequency (two poles at `fc`) times the force pulse smoothed by two 0.3 ms one-poles = the rise), the lower 11 are resonators at fixed Hz (432, 577, 650, 720, 816, 920, 1090, 1155, 1330, 1633, 2100, 2593, 3400, 4500, 6535, 8700), T60 1.0 s up to 1.3 kHz (the cáscara tail's), then 0.9 ... 0.1 s at 8.7 kHz (decay climbing with frequency, Rossing et al. 1992; above 2 kHz a guess); Low x1.8. They do not retune. Shell level (Shell) and ring time (Ring) are controls.
- **Stroke** = a force pulse (an impulse through two one-pole low-passes, cutoff `fc` per stroke, scaled by Stick and velocity) into every mode with gains `W[drum][stroke][mode]`, plus a band-passed noise burst (`nl nf nq nt`: the stick's tick).
- **Damping**: at the hit the ring already on the head is multiplied by `kph` and the shell's by `kps` (open 0.85/0.9, rimshot 0.8/0.7, **cascara 0.97/0.5**, paila 0.95/0.4, rim click 0.3/0.7, **muted 0.03/0.8**); and for `tau` seconds (open 0.05, rimshot 0.06, cascara 0.03, paila 0.15, rim click 0.5, muted 0.5: the long ring times need the stick's damping to last) every mode's decay rate is multiplied by `G[drum][stroke][mode]` (fresh fits start at 1, except the rim click, which `fit.py` leaves at its seed 3 x the drum's ring factor, head and shell: its stick lies across the head and rests on the rim, and its one 0.23 s recording has no ring window to fit that from; set by t20. The noise bands' `G` stays 1: the recordings' ring window there is room noise). Stroke is read at the hit, so changing it over a ringing drum behaves physically: Muted kills the head, Cascara and Paila leave it ringing (Node and Max tests).
- Hits arrive as a counter `trg` with velocity `vel` (timbales_midi.js); Drum and Stroke are read when the hit lands (first-compile trap: no Params-only ternary/min/max/clamp at top level: everything stroke-derived is inside the hit block, multiplied by `vh`).
- State: no hidden state beyond the resonators; all controls are real live.* parameters. Output is mono, soft-limited above 0.8.

## Fit (tests/fit.py, tests/calibrate.py)
Bands = the 24 modes' windows (geometric midpoints between neighbouring mode frequencies); head windows scale with each take's own f1, shell windows are absolute. For every drum and stroke: `W` += 0.7 x (target early dB - ours) per band (first 40 ms, dB re the stroke's total); `G` (sinusoid modes only) from the ring window (60-360 ms) minus the early window, only where the recording's ring is above a -50 dB floor (was -42: muted / paila rings sit at -45..-60) (else ours must not exceed it); `nf` from the energy centroid above 1.5 kHz of the first 40 ms, `nl` from the crack (share above 1.5 kHz); `A` (level) by `calibrate.py` to `PEAK_DB` (a judgement: the previews are normalised). `kph kps tau fc` and the mode frequencies are hand-set. 24 iterations from the defaults take ~15 s.

Result (ours / the mean of the takes; `python3 tests/fit.py report`; rise = 10 % to within 3 dB of the peak, causal 0.5 ms RMS):

| | profile rms | t20 ms | t40 ms | rise ms | centroid Hz | crack dB |
|---|---|---|---|---|---|---|
| High open | 1.3 | 116 / 134 | 325 / 375 | 0.29 / 1.45 | 438 / 455 | -13.3 / -13.2 |
| High rimshot | 1.9 | 127 / 182 | 434 / 601 | 0.27 / 1.79 | 948 / 1074 | -8.7 / -9.2 |
| High cascara | 0.9 | 54 / 60 | 171 / 540 | 0.96 / 0.89 | 6166 / 6142 | -0.1 / -0.3 |
| High paila | 1.5 | 73 / 52 | 168 / 356 | 0.19 / 1.56 | 1815 / 1664 | -3.2 / -3.7 |
| High rim click | 1.2 | 37 / 37 | 146 / 202 | 1.02 / 2.72 | 2997 / 2792 | -1.0 / -1.0 |
| High muted | 1.8 | 70 / 38 | 174 / 218 | 0.31 / 1.61 | 788 / 772 | -11.2 / -12.0 |
| Low open | 0.7 | 144 / 195 | 613 / 568 | 0.33 / 3.00 | 206 / 236 | -17.4 / -16.9 |
| Low rimshot | 1.4 | 177 / 299 | 1047 / 1858 | 0.25 / 0.91 | 937 / 852 | -7.9 / -8.8 |
| Low cascara | 0.7 | 98 / 62 | 488 / 958 | 0.98 / 1.06 | 6373 / 6244 | -0.2 / -0.3 |
| Low paila | 1.2 | 89 / 59 | 256 / 350 | 0.17 / 1.67 | 1102 / 995 | -5.1 / -5.9 |
| Low rim click | 0.8 | 46 / 37 | 168 / 202 | 0.33 / 2.72 | 2849 / 2792 | -1.2 / -1.0 |
| Low muted | 0.5 | 64 / 33 | 216 / 231 | 0.27 / 1.96 | 688 / 713 | -10.7 / -10.4 |

`tests/test_strokes.py` holds every row to: t20 within x0.4..2.5 of the three takes' range, centroid x0.65..1.5, crack +-4 dB, 2.5-9 kHz spectral flatness no lower than the takes' minus 3 dB (noise, not lines), early profile < 3.5 dB rms over bands above -30 dB (67 checks, plus "the maxpat's codebox equals the engine").

## Verification
Node (`./build.sh`): 47 (all 12 drum x stroke at two velocities, tuning, stroke-change damping, shell controls, extremes, midi js) + 67 (fit tolerances, flatness, Vary, codebox == engine). Max cold: `gen_compile.py --cold` clean; `tests/test_voice_max.py` 35 (every drum x stroke within 3.5 dB peak / 2.5 dB energy of the Node shim, tuning to 0.1 ct, mute/cascara/paila over a ringing drum, same-tick menu + note, back-to-back notes, Decay/Shell/Ring/Press/Volume, extremes). Live: `scripts/live_check_voice.py` 20/20 (round 2; not re-run in round 3).

## Where we are
- Built, tested, unheard. The panel was screenshotted in standalone Max only.
- Differences from the recordings are listed in the README (attack, cáscara tail, Low decays, rim click from one take).

## Round 3 (2026-10-30): compared against the recordings (`tests/compare.py`)
- Found: above 2.5 kHz every recording is noise-like (spectral flatness -3..-6 dB, 5-40 ms and 40-100 ms), ours were sinusoid lines (-13..-25 dB), on every stroke: it would sound pitched where the real shell splashes. The top 5 shell modes became decaying noise bands (flatness now -2.5..-5, within 1 dB of the takes).
- Same fit, same band windows; the fit now also leaves `G` alone on noise bands and on the rim click. Cascara rise via a 0.3 ms two-pole smoothing of the noise excitation (scan over 10 hits: 0.2 ms 0.75/0.88, 0.3 ms 0.96/1.05, 0.5 ms 1.44/1.36 against 0.89/1.06).
- **Vary** (round 3b): every sinusoid mode's gain x exp(uniform) at the hit, std `JITTER_DB` 1.5 dB x Vary/100 (hash of a noise sample and the trigger counter, inside the hit block). fit/calibrate/report render with jitter off (`write_code(..., jitter=0)`); Max equivalence tests set Vary 0 (Node and Max draw different jitter). The cascara is ~all noise bands + tick, so Vary does little there; open/rimshot/muted gain 1.4-2.3 dB of spread.
- Every hit is now different (the noise bands are random per hit); measured per-band decay of the splash (8-90 ms) is 0.2-0.3 s in all bands, ours agrees.

## What's left (ordered)
1. Listen (`docs/demo.wav`, `docs/strokes_ab.wav`) and correct by ear: cáscara brightness (the 3-11 kHz splash), paila, rimshot decay.
2. A real two-bar cáscara MIDI clip (transcribed from a method book, not our reading) and a Drum Rack preset (one pad per drum x stroke).
3. A bell/cowbell companion (the mambo-bell sections), the abanico roll as a Roll control.
4. Attack of the non-cascara strokes (rise 0.2-0.35 vs 0.9-3 ms): the head's modes and the tick start at once; the noise-band trick (smoothed excitation) fixed the cascara. Next: the same smoothing for the strokes whose rise the head's low modes set, and the rim click's 8 ms ramp; check the first 40 ms envelope per region (`docs/compare/`), which the 40 ms band energies the fit sees cannot.
4b. (done: Vary) Per-hit variation of tuning and contact is not modelled.
5. Measure a real timbale shell (impact hammer) to replace the spectral-peak shell frequencies; fit contact damping (`kph`, `tau`) from recordings with a ring present before the stroke.
6. Panel look round; a Live screenshot.
