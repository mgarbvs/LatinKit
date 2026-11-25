# Conga

A physically-modelled conga for Max for Live: three drums (quinto, conga, tumba), six real hand strokes each, one gen~. Each drum is a bank of 14 damped modes (head overtones fitted to recordings, plus a low body), a stroke is a contact pulse plus a short noise tick, and the hand damps the head the way it does on the drum. Part of the synthesized Latin percussion section (`../LATIN_PERCUSSION_RESEARCH.md` item 5). Research: `docs/RESEARCH.md`; model, state, to-do: `docs/SPEC.md`.

## Note map (Live naming: C3 = 60)
Three octaves, the same layout in each, white keys only. Velocity = strength (louder, brighter, shorter contact). Note-offs are ignored: a stroke is as long as the drum rings.

| Drum | open (abierto) C | slap (seco) D | mute (tapado) E | bass F | heel G | toe A |
|---|---|---|---|---|---|---|
| Tumba, C1 octave | 36 | 38 | 40 | 41 | 43 | 45 |
| Conga, C2 octave | 48 | 50 | 52 | 53 | 55 | 57 |
| Quinto, C3 octave | 60 | 62 | 64 | 65 | 67 | 69 |

Mod wheel (CC1) presses the head: up to Press semitones on all three drums.

## Panel (288 x 169 pt, DS style, all real live.* parameters)
The drawing shows tumba | conga | quinto (keyboard order) and flashes the drum hit with the stroke's name. Under it the three Tune boxes (semitones; 0 = the open tone: quinto 366 Hz, conga 266 Hz, tumba 219 Hz). Dials: Decay (30-300 % of natural ring), Skin (brightness, +-6 dB/oct), Slap (crack and brightness of the slap), Shell (body: heel/bass thump), Touch (velocity -> contact time), Press (wheel range), Spread (quinto right, tumba left), Level.

## Conga Voice (one drum, for Drum Rack pads)
`m4l/Conga Voice.amxd` is one drum of this device as its own instrument (180 x 169, the Shaker layout): any MIDI note plays it, velocity is strength, the mod wheel presses the head. A **Drum** menu (Quinto, Conga, Tumba) and a **Stroke** menu (Open, Slap, Mute, Bass, Heel, Toe) choose what it plays; both are automatable and may be changed between hits (the new stroke's hand damps the ring already on the head). The gen~ (`scripts/conga_voice.py`) is the same model with one bank of 14 resonators and run-time table selection; it renders the same samples as Conga's drum + stroke at Spread 0 (`tests/test_voice.js`, 1e-16). Display: the drum in line art (sized by Drum), the stroke's name, a flash on each hit; Skin, Slap, Shell, Touch and Press as orange boxes; dials Tune, Decay, Volume. Mono out (no Spread).

| Parameter | Range | Default | Notes |
|---|---|---|---|
| Drum | 0 Quinto, 1 Conga, 2 Tumba | 1 | open tone 366 / 266 / 219 Hz at Tune 0 |
| Stroke | 0 Open, 1 Slap, 2 Mute, 3 Bass, 4 Heel, 5 Toe | 0 | |
| Tune | -12..12 st | 0 | 0 = the drum's open tone |
| Decay | 30..300 % | 100 | |
| Skin / Slap / Shell / Touch | 0..100 % | 50 | |
| Press | 0..12 st | 5 | mod wheel range |
| Volume | -36..6 dB | -9 | |

`./build.sh` builds both devices (`scripts/build_voice.py`, `conga_voice_midi.js` generated, `conga_voice_view.js` by hand). Tests: `node tests/test_voice.js`; Max `uv run --directory $MAXTEST_DIR python $PWD/tests/test_voice_max.py`; Live `uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check_voice.py "$PWD/m4l/Conga Voice.amxd"`.

## Build and verify
```
./build.sh                                         # generate -> grammar check -> validate -> Node tests (engine 47, stroke fits 63) -> .amxd
python3 tests/fit.py fit 10 && python3 tests/calibrate.py   # re-fit the tables to the recordings (after changing MODES)
python3 tests/fit.py report                        # per stroke: ref vs ours (band profile, t20/t40, centroid, crack, attack)
python3 tests/fit.py ab                            # docs/strokes_ab.wav (ref stroke, then ours; gitignored)
uv run --directory $MAXTEST_DIR python $PWD/tests/test_max_render.py [--demo]   # standalone Max, cold start (37 checks; --demo writes docs/demo.wav)
uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check.py $PWD/m4l/Conga.amxd         # inside Live (adds an "LT DUT" track; delete it afterwards)
```
References are read from Ableton's Core Library and the Latin Percussion pack previews (folder in `LP_PACK`; `tests/refs.py`; converted copies go to `ref_wav/`, gitignored: never commit Ableton audio).

## Status (2026-10-29)
Node 47/47 + 63/63, standalone Max cold 37/37, Live 25/25 (clean console, notes in tune through Live MIDI). `docs/demo.wav`: a two-bar tumbao x2 then the same with a quinto/tumba fill, all drums and strokes, rendered in Max.

## Honest differences and unverified
- **Unheard.** Fits are numeric (band profiles within 1-4 dB rms of the recordings per stroke, t-40 and centroid inside the three takes' range except as listed in `docs/SPEC.md`); nobody has listened.
- Attack is sharper than the recordings (0.5-0.9 ms vs 2.5-8 ms to peak), slap t-20 is slower (55 vs 27 ms), heel is a little bright.
- Loudness between strokes is a judgement (the recordings are peak-normalised); the bass stroke has no recording (modelled on the heel, shifted low); slap is fitted to the mean of the slap-open and slap-mute takes.
- No amplitude-dependent pitch glide; the shell resonance moves with the head instead of staying put.
- If two strokes of one drum arrive in one audio block, only the higher stroke (by the table order) plays.
- Panel screenshot (Live): `docs/panel_live_idle.png`.
