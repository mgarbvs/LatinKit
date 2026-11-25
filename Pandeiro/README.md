# Pandeiro

Two Max for Live devices from one engine: **`m4l/Pandeiro.amxd`**, the kit version (any note plays the same hit; for Drum Rack pads), and **`m4l/PandeiroMusical.amxd`** (Live shows "PandeiroMusical"; description "Pandeiro Musical"), where the MIDI key sets the head's pitch. See "Pandeiro Musical" below.

A pandeiro and a tamborim for Max for Live, for the Latin kit: one instrument per instance, chosen by an **Instrument** menu (**Pandeiro**: frame-drum head with jingles, the platinelas; **Tamborim**: small tight head played with a stick, no jingles), six strokes plus two for the tamborim in one fixed **Stroke** menu, one gen~. The head is Bongo's modal head, forked and refitted to the Latin Percussion pack's pandeiro and tamborim takes; the jingles are Shaker's PhISEM engine (copied), fitted to the pandeiro's Shake and Roll. Mode ratios, decays, jingle constants and levels were measured from the recordings (`docs/SPEC.md`).

## Playing
`m4l/Pandeiro.amxd` (180 x 169, the Bongo / Shaker layout): any MIDI note plays it, velocity is strength, the mod wheel (CC1) presses the head. Instrument and Stroke are menus on the panel; the hand or stick, the stroke's name and a flash show what was played.

| Parameter | Range | Default | Notes |
|---|---|---|---|
| Instrument | 0 Pandeiro, 1 Tamborim | 0 | head tone 250 / 450 Hz at Tune 0 |
| Stroke | 0 Thumb, 1 Finger, 2 Slap, 3 Rim, 4 Shake, 5 Roll, 6 Open, 7 Mute | 0 | one fixed list, see below |
| Tune | -12..12 st | 0 | the head; the 125 Hz body does not move |
| Decay | 30..300 % | 100 | head ring time (T60 0.2-0.3 s pandeiro, 0.25-0.55 s tamborim) |
| Skin | 0..100 % | 50 | +-6 dB/oct tilt of the overtones |
| Shell | 0..100 % | 50 | level of the 125 Hz body tone |
| Touch | 0..100 % | 50 | contact hardness: brighter, louder, more tick |
| Press | 0..12 st | 5 | mod wheel range |
| Vary | 0..100 % | 100 | hit-to-hit variation of the head tones' levels (about 2 dB at 100 %); the noise, tick and jingle grains differ every hit anyway |
| Jingles | 0..100 % | 100 | the platinelas' level, on every pandeiro stroke. The tamborim has none: the control does nothing there (its jingle reach is 0, `JG` in the engine), so "0 on the tamborim" is by construction, not by the control's value |
| Volume | -36..6 dB | -9 | |

**Strokes.** Pandeiro: Thumb, Finger, Slap, Rim, Shake (the jingles alone), Roll (about 18 finger taps a second for 1.1 s, jingles rattling). Tamborim: Open, Mute, Finger. The Stroke menu is **one fixed list of eight** rather than a list that changes with the Instrument: Live stores a menu parameter by its index, so a list that changed length under Instrument would point a saved preset at a different or missing stroke; with one list a preset round-trips exactly (by design; a saved Live preset was not tried). A stroke the instrument lacks plays the nearest it has, and the panel shows the one actually played: Pandeiro Open -> Thumb, Mute -> Finger; Tamborim Thumb / Slap / Rim -> Open, Shake / Roll -> Finger (the Roll repeats it). Any stroke change over a ringing head damps it as the recordings do (Mute most).

Panel: the instrument in orange line art, the hand or stick, the stroke's name, a flash on every hit; Instrument / Stroke menus; boxes Skin, Shell, Touch, Press, Vary, Jingles; dials Tune, Decay, Volume. **Not looked at** (see Status).

## Pandeiro Musical
`m4l/PandeiroMusical.amxd`: the same panel, parameters, strokes, velocity, CC1, voice behaviour and sound as the kit device **as it was before the kit's tail re-fit** (see "Kit re-fit" in `docs/SPEC.md`), except that the MIDI key sets the head's pitch. The settled head fundamental is **mtof(key) x 2^(Tune/12)** (key and Tune add in semitones; the mod wheel's Press adds on top), and all head modes keep their ratios to it (the Tune path, `vF1`). The 125 Hz body, the noise bands and the **jingles do not follow the key** (metal platinelas do not retune). Both instruments sit on the same fundamental at the same key (their modes and noise differ). Note-offs are ignored as in the kit; one resonator bank, so a new key retunes whatever is still ringing from the last hit (as moving Tune does).

Its sound is frozen: it reads copies of the fit and calibration data taken before the kit was re-fitted (`scripts/pandeiro_tables_musical.json`, `scripts/pandeiro_jingle_musical.json`) and the engine's pre-re-fit code paths (`code(musical=True)`), and `tests/test_musical.js` checks the generated gen~ code against a frozen sha256, so changing the kit cannot move it. At the key whose pitch equals the kit's (key 59.2131 = 250 Hz Pandeiro, 69.3891 = 450 Hz Tamborim; a non-integer key, set directly in the engine) its renders equal the pre-re-fit kit's sample for sample (Pandeiro max difference 5.7e-14 = -250 dB re peak; Tamborim 0.0; all 8 strokes of each, Vary 100). No integer key reproduces the kit exactly: key 59 is 21 ct under the Pandeiro's 250 Hz, key 69 is 39 ct under the Tamborim's 450 Hz (key 59 with Tune +0.21 st, key 69 with Tune +0.39 st match). Note: that identity needs Instrument set before the hit; when Instrument and the hit change in the same audio tick the kit's control block lags up to 16 samples, the Musical device's pitch does not.

**Key range.** All 128 keys, both instruments, all eight strokes, Tune +12, wheel full: finite, under full scale, audible (Node). The head's fundamental sits on mtof(key) within 1 ct from key 48 (131 Hz) to 108 (4.2 kHz) and measurably so on the Max / Live key tests (key 48..84, within 5 ct); keys 36-47 sound at pitch but the 125 Hz body and the higher modes crowd the fundamental, so it cannot be isolated by ear or by the test; below key 36 (65 Hz) the head is sub-bass. The useful range is therefore about keys 36-108. At the top, a head mode above 0.45 x the sample rate is left out (gated at the hit and its resonator killed, it would fold back as an alias): at 48 kHz the Pandeiro loses its top partial (5.8 x) from key 107 and the Tamborim its top (3.24 x) from key 116, then more modes towards key 127 (only modes up to about 1.7 x the fundamental survive there); lower keys at 44.1 kHz. Tune +12, Press and the wheel raise the effective key by the same amount.

## Build and verify
```
./build.sh                                  # generate -> GenExpr grammar -> validate -> Node tests (72 + 93) -> m4l/Pandeiro.amxd
FRESH=1 python3 tests/fit.py fit 16 && python3 tests/calibrate.py && python3 tests/fit.py roll --write && python3 tests/fit.py jg   # re-fit the tables (~8 min; after changing HEAD / BANDS in the engine)
node tests/jingle_fit.js [--write]          # the jingle constants (scripts/pandeiro_jingle.json) from the Shake + Roll previews (~4 min)
python3 tests/compare.py all                # docs/compare/<row>.png + roll.png: recordings vs ours (waveform, envelope, spectrogram)
python3 tests/fit.py report                 # per row: recording / ours (rise, t20, t40, centroid, crack, blip, tone start, jingle share)
python3 tests/fit.py ab                     # docs/strokes_ab.wav + the cue list below (recording A, then ours; gitignored)
python3 scripts/gen_compile.py --cold m4l/Pandeiro.maxpat                         # real Max, cold first compile of the gen~
uv run --directory $MAXTEST_DIR python $PWD/tests/test_voice_max.py [--demo]   # standalone Max (49 checks; --demo writes docs/demo.wav)
uv run --directory $MAXTEST_DIR python $PWD/tests/cpu_max.py                    # gen~ CPU in Max, next to Bongo's
uv run --directory ../../LiveTestMCP python $PWD/scripts/live_check_voice.py "$PWD/m4l/Pandeiro.amxd"   # inside Live (34 checks; adds "LT" tracks, deleted afterwards)
```
Max and Live are shared: wrap the Max/Live commands in the session's `withlock.py`. References are read from the LP pack (`tests/refs.py`); converted copies go to `ref_wav/` (gitignored: never commit Ableton audio). The test helpers, fit loop and panel are Bongo's, forked.

## Status (2026-11-01)
Node 72 + 93, standalone Max cold 49/49 (+ `gen_compile --cold` clean), Live 34/34 (clean console, LT tracks deleted), gen~ CPU in standalone Max about 0.9 % of one core (DSP off 1.8 %, on 2.7 %; Bongo 1.0 % beside it). **Unheard**: nobody has listened to `docs/demo.wav` or `docs/strokes_ab.wav`; the fit is numeric and by plots. **Panel not looked at** in Max or Live (the generated layout is Bongo's; no screenshot taken). Not committed.

Recording / ours (median of hits, vel 0.8, Vary off, jingles on), from `tests/fit.py report`:

| row | band profile rms dB | rise ms | t20 ms | t40 ms | centroid Hz | crack dB | jingle share dB |
|---|---|---|---|---|---|---|---|
| Pandeiro Thumb | 2.1 | 1.59 / 1.79 | 70 / 84 | 216 / 241 | 3287 / 3308 | -4.9 / -5.0 | -4.4 / -4.5 |
| Pandeiro Finger | 1.4 | 2.95 / 3.73 | 75 / 83 | 174 / 242 | 3636 / 4049 | -4.6 / -4.3 | -3.5 / -3.6 |
| Pandeiro Slap | 2.4 | 1.54 / **3.71** | 61 / **106** | 163 / **298** | 3123 / 3557 | -5.3 / -4.8 | -4.2 / -4.2 |
| Pandeiro Rim | 3.3 | 4.99 / **1.77** | 94 / 69 | 323 / **193** | 1662 / 1870 | -8.1 / -7.3 | -7.1 / -7.1 |
| Pandeiro Shake | 3.4 | 1.66 / 1.67 | 64 / 71 | 200 / 175 | 9478 / 9308 | -0.2 / -0.2 | -0.2 / -0.4 |
| Tamborim Open | 2.3 | 2.30 / 4.29 | 104 / 89 | 291 / 237 | 1011 / 1165 | -9.2 / -7.3 | -18.2 / -16.9 |
| Tamborim Mute | 2.3 | 1.76 / 0.90 | 31 / 35 | 135 / **207** | 1086 / 1270 | -9.1 / -8.9 | -15.7 / -15.8 |
| Tamborim Finger | 2.9 | 0.99 / 1.56 | 23 / 23 | 111 / **163** | 978 / 1176 | -9.6 / -7.3 | -21.1 / -19.9 |

Jingle layer vs the Shake/Roll previews (`tests/jingle_fit.js`): 1/3-octave 4-16 kHz 0.3 dB rms; Shake rise 24 ms (recording 28), t20 63 (62), t30 99 (107), grain fluctuation cvE 0.17 (0.18). Roll: tap rate 18.3 Hz (18.2), length 1.20 s (1.14), 150-900 Hz / 1-4 kHz / 7-15 kHz at -25.5 / -35.7 / -5.8 dB re peak against the recording's -28.3 / -25.8 / -9.2.

## Honest differences and unverified
- **Slap and the tails.** Our slap rings longer (t40 298 vs 163 ms): the slap's jingle tail is the known gap (the fit matches the jingle share of the first 40 ms and their build-up, not their long decay). The tamborim Mute / Finger t40 are about 50 % over the recordings' (207 vs 135, 163 vs 111) with t20 right: the tail is too long. The Pandeiro Rim is the reverse: rise 1.8 against 5.0 ms, t40 193 vs 323.
- **Attack.** The tick's "blip" (the tick before the tone) is 2.2 x the recording's on the Pandeiro Finger (0.17 vs 0.08) and 2.7 x on the Rim (0.26 vs 0.10): the tick's noise level does not move it, it is the head / jingle onset. The Tamborim Open's rise is 4.3 vs 2.3 ms.
- **Pandeiro Shake: tone 0.23 vs 2.21.** The recording's first 40 ms is the jingles alone; the tone-start metric disagrees (not investigated: the recording has no head tone to speak of, ours may). Band profile 3.4 dB rms (the worst row).
- **Roll.** One recording (pandeiro). Its envelope falls slowly through 1.0-1.5 s; ours holds level and ends at 1.1 s, then falls in about 0.2 s. The Tamborim Roll has no recording at all: it is the Tamborim Finger at 18.2 taps/s, tap level 0.6 x the velocity, a judgement.
- **Jingles are one noise-grain model for the platinelas**, not their separate resonances: the recordings' jingle band is a hump of noise, not lines (flatness -5.6..-6.5 dB, 6-14 kHz). The ringing-band test finds 7.1, 11.2 and 14.2-14.8 kHz as slowest-decaying bands; a "three ringing lines" start was tried and dropped (SPEC).
- **One take of the pandeiro**, two of the tamborim (the same pitch). Levels between strokes are a judgement (the previews are peak-normalised).
- The 125 Hz body is capped under the strongest head mode as in Bongo; Shell is weak on the pandeiro.
- If two strokes arrive in one audio block only one plays (the counter changes once).
- Jingle-tambourine previews ("Tmbourin Hit / Shake") were used only as a grain-density cross-check (138-160 /s against the pandeiro's 250-315 /s); they are out of scope.

## Demo and A/B
- `docs/demo.wav` (12.0 s, rendered in Max, two instances: Pandeiro and Tamborim, mixed): one bar of the LP clip "Samba 2 Tambourim Pandeiro-120bpm" read from its onsets (the same 16-slot pattern in all 4 bars; pandeiro: low onsets Thumb, crackly ones Slap, jingle-only ones Finger / Shake; tamborim: strong onsets Open, ones with a jingle tail Mute), 4 bars, then a short roll-and-shake fill into a last downbeat (`tests/test_voice_max.py`). Our reading of the clip, not a transcription. Not committed with any Ableton audio.
- `docs/strokes_ab.wav` (27.4 s, gitignored): per row (and the Roll) the recording (Pandeiro A / Tamborim A) then ours (vel 0.8, Vary on). Cue list:

```
  0.00 s  Pandeiro Thumb: recording (take A)
  1.01 s  Pandeiro Thumb: ours
  2.91 s  Pandeiro Finger: recording (take A)
  3.88 s  Pandeiro Finger: ours
  5.78 s  Pandeiro Slap: recording (take A)
  6.71 s  Pandeiro Slap: ours
  8.61 s  Pandeiro Rim: recording (take A)
 10.06 s  Pandeiro Rim: ours
 11.96 s  Pandeiro Shake: recording (take A)
 12.74 s  Pandeiro Shake: ours
 14.64 s  Pandeiro Roll: recording (take A)
 16.66 s  Pandeiro Roll: ours
 19.16 s  Tamborim Open: recording (take A)
 20.23 s  Tamborim Open: ours
 22.13 s  Tamborim Mute: recording (take A)
 22.90 s  Tamborim Mute: ours
 24.80 s  Tamborim Finger: recording (take A)
 25.48 s  Tamborim Finger: ours
```
