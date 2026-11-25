# Timbales

A physically-informed timbales for Max for Live, centred on the **cáscara** (sticks on the metal shell): one timbal (High or Low) with six stick strokes, one gen~. The head is a bank of damped modes, the thin metal shell a separate bank of 16 fixed-frequency, high-Q modes, and a stroke is a stick-contact pulse plus a short noise tick into both with per-stroke, per-drum tables fitted to the Latin Percussion pack previews and Live's Core Library one-shots. Item 8 of `../LATIN_PERCUSSION_RESEARCH.md`. Research: `docs/RESEARCH.md`; model, state, to-do: `docs/SPEC.md`.

## Playing
`m4l/Timbales.amxd` (180 x 169, Shaker / Conga Voice layout) is one drum as its own instrument: any MIDI note plays it, velocity is strength, the mod wheel (CC1) presses the head. A **Drum** menu (High, Low) and a **Stroke** menu (Open, Rimshot, Cascara, Paila, Rim click, Muted) choose what it plays; both are automatable and may be changed between hits: the new stroke damps the ring already there (a Muted stroke kills the head, a Cascara or Paila barely touches it). Several instances in a Drum Rack give a kit (one pad per drum x stroke). Mono output; note-offs are ignored (a stroke is as long as the drum rings).

| Parameter | Range | Default | Notes |
|---|---|---|---|
| Drum | 0 High, 1 Low | 0 | open tone 200 / 120 Hz at Tune 0 |
| Stroke | 0 Open, 1 Rimshot, 2 Cascara, 3 Paila, 4 Rim click, 5 Muted | 2 | |
| Tune | -12..12 st | 0 | the head only; the shell does not retune |
| Decay | 30..300 % | 100 | head ring time |
| Shell | 0..100 % | 50 | level of the metal-shell modes |
| Ring | 30..300 % | 100 | shell ring time |
| Stick | 0..100 % | 50 | contact hardness: brighter, louder, more tick |
| Press | 0..12 st | 5 | mod wheel range, head only |
| Vary | 0..100 % | 100 | hit-to-hit variation: each head and low-shell tone's level is nudged at random at every hit (about 1.5 dB at 100 %); 0 repeats the same hit |
| Volume | -36..6 dB | -9 | |

Panel: the drum in orange line art with a stick that touches it where the stroke is played and flashes on each hit, the stroke's name, the two menus, orange boxes Shell / Ring / Stick / Press / Vary, dials Tune / Decay / Volume. Hover text on everything.

## Build and verify
```
./build.sh                          # generate -> GenExpr grammar check -> validate -> Node tests (47 + 67) -> m4l/Timbales.amxd
FRESH=1 python3 tests/fit.py fit 24 && python3 tests/calibrate.py   # re-fit the tables to the recordings (after changing HEAD / SHELL in the engine)
python3 tests/compare.py cascara High   # docs/compare/*.png: recordings vs ours (waveform, envelope, spectrogram)
python3 tests/fit.py report         # per drum and stroke: ref vs ours      python3 tests/fit.py ab   # docs/strokes_ab.wav (ref, then ours; gitignored)
python3 scripts/gen_compile.py --cold m4l/Timbales.maxpat                 # real Max, cold first compile of the gen~
uv run --directory $MAXTEST_DIR python $PWD/tests/test_voice_max.py [--demo]   # standalone Max (35 checks; --demo writes docs/demo.wav)
uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check_voice.py "$PWD/m4l/Timbales.amxd"   # inside Live (20 checks; adds an "LT DUT" track, delete it afterwards)
```
Max and Live are shared: wrap the Max/Live commands in the session's `withlock.py`. References are read from the LP pack and Core Library (`tests/refs.py`); converted copies go to `ref_wav/`, gitignored: never commit Ableton audio.

## Status (2026-10-30)
Round 3 (compared against the recordings, `docs/RESEARCH.md`): the shell above 2.5 kHz was a stack of sinusoids (spectral flatness -13..-25 dB) where every recording is noise-like (-3..-6 dB); those five modes are now decaying band-passed noise, so every stroke's splash is noise and every hit differs; the head and the lower shell modes get a random level nudge per hit too (**Vary**, 1.5 dB at 100 %: a judgement, 40 % of the 3-4 dB the A/B/C takes differ by, which also differ in tuning). Almost all of a cascara is noise bands and tick, so its hit-to-hit variation is the noise, not Vary. The cascara's rise (10 % to -3 dB) now matches (0.96 / 0.98 ms vs 0.89 / 1.06). Node 47 + 67, standalone Max cold 35/35 (+ gen_compile --cold clean). Live not re-run since round 2 (it adds a track to the open set). `docs/demo.wav` is from round 2 (before the noise bands); `docs/strokes_ab.wav` (reference then ours, gitignored) is current. Panel screenshot (Live): `docs/panel_live_idle.png`.

## Honest differences and unverified
- **Unheard.** Fits are numeric (early band profile within 0.3-1.9 dB rms of the recordings, centroid within 8 % and crack within 1 dB for every stroke); nobody has listened.
- Attack: the cascara's rise matches; the other strokes' is still 0.2-0.35 ms against 0.9-3 ms (open, rimshot, paila, muted: the head's modes and the tick start at once; rim click 0.3-1.0 vs 2.7). A longer contact for the sinusoids was tried in round 2 and dropped (RESEARCH.md round 2d).
- Cascara: the shell's ring matches the recordings band by band below 1.7 kHz (T60 about 1 s High, 1.8 s Low); t40 is 171 / 488 ms vs 540 / 958 because the previews carry a broadband tail above 2.5 kHz at about -42 dB that rings 1-2.8 s even at 8.7 kHz (room or reverb, not metal), not chased. Rimshot and Low open t20 127-177 vs 182-299 ms.
- The noise bands' decay is the shared shell T60 (per-band decay of the recordings over 8-90 ms is 0.2-0.3 s in every band, ours agrees); their `G` (contact damping) is not fitted, the recordings' ring window there is room noise. The rim click's `G` (3, times the drum's ring factor) is hand-set by t20 from its one 0.23 s recording.
- Loudness between strokes is a judgement (the previews are normalised); the rim click is fitted to one recording. Paila = LP's "Stick" take, a guess.
- Tied to what the recordings show: the shell's 11 sinusoid frequencies are spectral peaks, not a modal analysis; head ratios are measured on the High drum only; no pitch glide; Vary jitters levels only (not tuning or contact); one stroke per audio block (a second note in the same ~1.3 ms block replaces the first).
- Contact damping (`kph`, `kps`, `tau`) and contact bandwidth (`fc`) are set by hand per stroke, not fitted; everything else in the tables is. Head and shell T60s are hand-set from per-band decays of the recordings.
