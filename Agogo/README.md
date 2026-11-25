# Agogo

A modal agogo bell for Max for Live: one bell per instance (**High**, the small one, or **Low**, the large one), two strokes (Open, Mute), one gen~. Forked from Bongo (same pipeline and panel layout) and fitted to the Latin Percussion pack's kit-A agogo (`docs/SPEC.md`): every strong mode is a **doublet** (the bell is not axisymmetric: High 1469 / 1479 Hz, partner 11 dB down, 10 Hz beat), and the 5-11 kHz highs are **tonal lines**, not noise (only a ~1 ms stick tick is).

## Playing
`m4l/Agogo.amxd` (180 x 169, the Bongo / Conga Voice layout): any MIDI note plays it, velocity is strength. A **Bell** menu (High, Low) and a **Stroke** menu (Open, Mute) choose what it plays; both are automatable and may be changed between hits (a Mute hit also stops the ring already on the bell; an Open does not). Two instances in a Drum Rack make the pair. Mono output; note-offs and the mod wheel are ignored.

| Parameter | Range | Default | Notes |
|---|---|---|---|
| Bell | 0 High, 1 Low | 0 | open tone 1470 / 1003 Hz at Tune 0 (kit A of the pack) |
| Stroke | 0 Open, 1 Mute | 0 | Mute = the other hand holds the bell: a judgement, nothing in the recordings is muted (see below) |
| Tune | -12..12 st | 0 | all partials; +-12 st reaches the pack's other agogos (kit B High 1168, Low 906 Hz; kit E High 1357, Low 1009 Hz) |
| Decay | 30..300 % | 100 | ring time (T60 of the High's fundamental 1.4 s, the Low's 0.5 s) |
| Tone | 0..100 % | 50 | +-6 dB/oct tilt of the overtones against the fundamental |
| Touch | 0..100 % | 50 | stick hardness: brighter, louder, more tick |
| Vary | 0..100 % | 100 | hit-to-hit variation: each partial's level nudged at random (1.5 dB std at 100 %); 0 repeats the same sinusoids |
| Volume | -36..6 dB | -9 | |

Panel: the double bell in orange line art (the chosen bell bright), the stick where the stroke lands (Mute adds the holding hand), its name, a flash on every hit; Bell / Stroke menus; boxes Tone, Touch, Vary; dials Tune, Decay, Volume. Hover text on everything. Screenshot (Live): `docs/panel_live_idle.png`.

## Build and verify
```
./build.sh                                  # generate -> GenExpr grammar -> validate -> Node tests (32 + 26) -> m4l/Agogo.amxd
python3 tests/fit.py fit && python3 tests/calibrate.py   # re-fit to the recordings (seconds; modes from tests/extract.py), then the per-stroke levels
python3 tests/compare.py                    # docs/compare/{high,low}.png: recording vs ours Open vs ours Mute (waveform, envelope, spectrogram)
python3 tests/fit.py report                 # kit A recording / ours, and kits B, E measured only
python3 tests/fit.py targets                # the modal table extracted from each fitted recording
python3 tests/fit.py ab                     # docs/strokes_ab.wav + the cue list below (gitignored)
python3 scripts/gen_compile.py --cold m4l/Agogo.maxpat                         # real Max, cold first compile of the gen~
uv run --directory $MAXTEST_DIR python $PWD/tests/test_voice_max.py [--demo]   # standalone Max (26 checks; --demo writes docs/demo.wav)
uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check_voice.py "$PWD/m4l/Agogo.amxd"   # inside Live (19 checks; adds "LT" tracks, delete them afterwards)
```
Max and Live are shared: wrap the Max/Live commands in the session's `withlock.py`. References are read from the LP pack (`tests/refs.py`); converted copies go to `ref_wav/` and the A/B wav to `docs/`, both gitignored: never commit Ableton audio.

## Status (2026-11-01)
Node 32 + 26, `gen_compile --cold` clean, standalone Max 26/26, Live 19/19 (clean console; the "LT" tracks deleted afterwards). **Unheard**: nobody has listened to `docs/demo.wav` or `docs/strokes_ab.wav`; the fit is numeric and by plots (`docs/compare/`).

Recording A / ours (Open, vel 0.8, Vary off), from `tests/fit.py report`:

| bell | f0 Hz | doublet | T60 s (fundamental) | centroid 0-40 ms Hz | t20 / t40 ms | rise ms | blip | flatness 2.5-9 kHz dB |
|---|---|---|---|---|---|---|---|---|
| High | 1469.7 / 1469.2 | beat 10.1 / 10.3 Hz | 1.44 / 1.40 | 4900 / 4572 | 141 / 168, 551 / 575 | 1.09 / 1.15 | 0.14 / 0.21 | -14.2 / -13.6 |
| Low | 1003.6 / 1002.3 | tail peak 1016.9 / 1017.1 Hz (beat: recording below the 6 Hz floor, ours 14.6) | 0.45 / 0.48 | 1317 / 1442 | 99 / 150, 265 / 314 | 1.29 / 1.08 | 0.08 / 0.13 | -11.1 / -16.5 |

Kits B and E (recordings only, different instruments, not fitted nor averaged): f0 904 (B Low), 1006 (E Low), 1155 (B Mid), 1172 (B High), 1357 Hz (E High); T60 of the fundamental 0.28-0.41 s (B Mid 3.78 s: past the measure's window); beat 6-9 Hz (B Mid 33); centroid 936-1871 Hz; flatness -6.7..-8.4 dB (the kit-A bells are more tonal: -11..-14).

The Mute table is a judgement (no recording): the High's fundamental falls with T60 0.08 s, its 0.3-0.5 s ring is over 120 dB under the Open's.

## Strokes: what the clips showed
No hand-muted hit and no clack in the LP clips (Afoxe, Plena, Samba 1/2, Rhumba Funk) or the Core Library loops (Agogo Bells 90, Agogo Atabaques 112): the LP clips are MIDI renders of the same one-shots (every hit of a bell identical to 0.5 dB); the loops use different bells and cut a hit when the next comes; details in `docs/SPEC.md`. So **Mute is a labelled judgement** (kp 0.3, decay rate x12..24 relaxing over 1.5 s, duller strike) and there is **no Clack** stroke.

## Honest differences and unverified
- **Highs are 12 merged partials per bell**, where the recordings hold many more lines (denser than 60 Hz): matched in each partial's first-40-ms energy and fall time, not line by line. High's t20 168 vs 141 ms, Low's 150 vs 99 ms (its highs ring ~50 % too long), Low's centroid 1442 vs 1317 Hz, ours more tonal than the recording on the Low (-16.5 vs -11.1 dB flatness).
- **Low's doublet** is shown by the tail (the strongest peak 0.3-0.8 s in is 1017 Hz in both); the recording's 10-14 Hz ripple is below what a 0.4 s window can measure, ours beats at 14.6 Hz. The 1017 Hz partner's T60 is capped at 2 s (the pencil gave 3.8 s).
- The recordings' tails sit on a -70 dB room floor (1-2 s); ours decay to -90 dB. No room or sympathetic ringing of the other bell (~-45 dB).
- Loudness between the two bells and the strokes is a judgement (the previews are peak-normalised): Open peaks -4 dBFS at vel 1 / Volume 0 dB, Mute -8 (`E.PEAK_DB`).
- Kit A only: B and E have different pitches, ratios (B Mid's second mode 2513 Hz is its strongest peak, A has 2.33 x) and decays; the Tune dial moves the pitches, not the ratios.
- Max renders differ from the Node shim by up to 2.9 dB in peak (Low Mute) and 1.7 dB in energy (the tick noise and the Vary hash differ); the Vary spread read 3.36 dB in 8 Max hits against the nominal 1.5 dB (8 samples, tests accept 0.5-4).
- If two strokes arrive in one audio block only one plays (the counter changes once).
- CPU: 24 resonators + one tick filter. No CPU meter in the harness; in the Node shim the per-sample cost equals Bongo's (463 vs 465 ns, a JS-interpreter figure, not Max's). Not measured in Max.
- Panel seen in standalone Max only, not screenshotted in Live; the hand drawn for Mute is a few strokes.

## Demo and A/B
- `docs/demo.wav` (11.4 s, rendered in Max, two instances): the 16th-note figure of the LP clip "Afoxe Agogo-107bpm" (140 ms per 16th: High 0 4 7 9 12, Low 2 6 10 14; bars A B A A, then a High and a Low on the downbeat), read from the clip's onsets. The clip is a MIDI render, so velocities are ours (100 on the beat, 85 off it).
- `docs/strokes_ab.wav` (15.5 s, gitignored): per bell the recording (kit A), then ours Open, then ours Mute (there is no recording of a mute). Cue list:

```
  0.00 s  High open: recording (kit A)
  2.60 s  High open: ours
  5.20 s  High mute: ours (no recording of a mute exists)
  7.80 s  Low open: recording (kit A)
 10.34 s  Low open: ours
 12.94 s  Low mute: ours (no recording of a mute exists)
```
