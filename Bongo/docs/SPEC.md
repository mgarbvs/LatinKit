# Bongo: spec and state

A modal bongo (one drum per instance, Macho or Hembra) for Max for Live, forked from Conga Voice / Timbales and fitted to the Latin Percussion pack's bongo takes. Usage: `../README.md`.

## What the recordings show (tests/refs.py, 32 LP previews: {A,B} x {H,L} x 8 strokes, plus 8 Core Library one-shots)
- Two takes (kits) A and B. Their tunings differ: B is 3.1 % above A on the Macho, 14.7 % above on the Hembra (cross-correlation of the log spectra; `refs.TAKE_SCALE`). Engine F1 (Tune 0) is the geometric middle: Macho 365 Hz, Hembra 325 Hz. Measuring windows scale with the take.
- **Mode ratios were measured** from the pooled A+B open/open3/flam spectra (frequency axis divided by each take's tuning), not copied from the conga:
  - Macho: a cluster below the fundamental (0.78, 0.91), 1.00 (doublets 344-372 Hz beat), 1.21, 1.35, 1.55, 1.74, 2.05, **2.29** (the strongest peak, ~850 Hz), 3.43, 3.65, 4.97 (~1.8 kHz). The axisymmetric ones 1, 2.29, 3.4-3.6, 4.9 stand out (a head struck near its centre).
  - Hembra: 0.75, 0.88, 1.00, 1.12, 1.21, 1.32, 1.54, 1.63, **2.15**, 2.96, 3.25, 3.9; dense and mushy below 1.7x, nothing above ~1.3 kHz but noise.
  - Both drums: a fixed ~125 Hz body tone (not moving with the drum; loudest on the tip), and above ~2 kHz noise (spectral flatness -3..-6 dB).
  - T60 of every head mode from the band-envelope slopes: 0.25-0.4 s (a bongo rings about a third of a second). Early decay is much faster than the tail: the envelope falls 20 dB in 13-31 ms (Macho) / 26-59 ms (Hembra), 40 dB in 80-170 ms.
- **Stroke list** (docs/compare/ shows each): Open (= LP "Open 1F"), Open 3F, Slap, Heel, Tip, Rim, Flam.
  - **Open 3F is kept as its own stroke**: against 1F it is a softer, broader contact: rise 1.4-2.3 ms vs 0.8-1.3 (Macho), centroid 3-9 % lower, 1 dB less crack; spectra otherwise alike. Subtle, but consistent in 3 of 4 take pairs.
  - **Flam** is not a table stroke: two Open hits, the second 0.45 x as loud, 42 ms later (the four 1F/3F takes' gaps: 60, 40, 45, 40, 42, 40, 47, 30 ms; the first hit is the louder one in every take). The 1F and 3F flams are merged (same gap and ratio).
  - No separate "muted" stroke: the recordings have none (the heel and tip are the damped ones).
- **Attack** (round-3 method): the recordings start with a small noisy tick (RMS 0.2-0.4 of the first-10-ms peak, mostly 0.8-3 kHz, ~1 ms) and the tone builds after it; 10 % -> -3 dB rise of the 0.5 ms envelope is 0.8-3 ms. Conga's attack was an instant sine start (0.25 ms). Here: the tick starts at the hit with its own level per drum and stroke (fitted to the recordings' blip ratio), the head's sine modes are multiplied by `1 - exp(-t/ta)` (ta per drum and stroke, fitted to when the below-1.5 kHz envelope reaches half its peak), the modes start with a fixed phase spread (a pure sine start gave a coherent first crest of 1.0 against 0.6 for later cycles that no recording has). Honest result: see the README's numbers; the 10 % -> -3 dB figure itself is jumpy because mode beating moves the 8 ms peak.
- **Flatness above 2.5 kHz**: ours are decaying band-passed noise bands (2.0, 2.8, 4.0, 5.8, 8.5 kHz) plus the tick, as in Timbales round 3; tests/test_strokes.py checks flatness >= the takes' minimum - 3 dB.

## Model (scripts/bongo_engine.py)
Per hit: 12 head resonators at the measured ratios of f1 (Tune, mod-wheel Press), one 125 Hz body resonator (Shell level, fixed in Hz), 5 noise bands. Contact pulse -> two one-pole low-passes (`fc`, Touch, velocity) -> modes with per-drum, per-stroke gains W; a band-passed noise tick (`nl nf nq nt`); hand damping: at the hit the ring on the head is multiplied by `kp`, and every head and body mode's decay rate is multiplied by `1 + (G - 1) c(t)` with c falling from 1 with time constant `tau`. Skin tilts the mode gains (+-6 dB/oct), Vary jitters each sinusoid's gain by up to 1.5 dB std at every hit. Tables `scripts/bongo_tables.json` come from `tests/fit.py` (band profile of the first 40 ms matched per mode band; blip ratio -> `nl`; tone start -> `ta`; grid search of one `G` and `tau` per drum and stroke on t20, t40 and the ring-window band levels) and `tests/calibrate.py` (peak per stroke).

## Traps hit (beyond the ones in the brief)
- A per-band G fitted only to the ring window (60-360 ms) leaves the early decay (t20) at 50-80 ms against 13-31 ms in the recordings; the early decay needs its own constraint (grid search on t20/t40).
- `fit.py` measured the tick's "blip" with the 5 % onset of our own render: when the tick is under 5 % the onset is the tone and the blip reads the tone, so the fit drove the tick to nothing. Our renders are measured from the known hit time.
- Fixing the 10 % -> -3 dB rise by iterating a delay or a contact-pulse bandwidth does not converge (a low-pass in front of sine modes only shifts them; rise stayed 0.25-0.4 ms); what changes the attack is a tick that precedes the tone plus a tone envelope.
- The 125 Hz body with a 150 ms ring dominated the early window of the rim; its T60 is now 60 ms.
- Heel / tip stroke-change tests must sit within the ring (a bongo is silent at -100 dB after 300 ms; a test at 550-900 ms compared float noise).
