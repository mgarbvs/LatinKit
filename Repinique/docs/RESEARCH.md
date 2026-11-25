# Repinique: references and research

## Searched
- Ableton Latin Percussion pack: no repinique (surdo, tamborim, pandeiro etc. only).
- Wikimedia Commons: no repinique audio found (only an unrelated 1932 samba recording). Session Drums snare/tom previews were not used (not needed once the next source turned up).
- Freesound (web search; the API is keyed, the sound pages expose preview URLs): user **BeppeB** has four single-instrument repinique recordings, all licensed **CC0 1.0** (`creativecommons.org/publicdomain/zero/1.0/`, read from each sound page).

## The references used (tests/refs.py downloads them into the gitignored `ref_wav/`)
| Stroke here | Freesound file | URL | Licence | Hits in the file |
|---|---|---|---|---|
| Open | `repinique-head.flac` | https://freesound.org/people/BeppeB/sounds/329750/ | CC0 | 8 (stick on the head) |
| Rimshot | `repinique-rimshot.flac` | https://freesound.org/people/BeppeB/sounds/329749/ | CC0 | 13 (the first 8 used) |
| Rim | `repinique-rod.flac` | https://freesound.org/people/BeppeB/sounds/329748/ | CC0 | 11 (the first 8 used) |
| Hand | `repinique-hand.flac` | https://freesound.org/people/BeppeB/sounds/329751/ | CC0 | 10 (the first 8 used) |

Fetched as the sound page's `hq` preview mp3 (`https://cdn.freesound.org/previews/329/<id>_3097509-hq.mp3`: 44.1 kHz mono, 18-32 s); the originals are flac, the mp3 is lossy (highs above about 16 kHz cut, fine for this fit). Each file is cut at its onsets into takes (`rp_<stroke>_<k>.wav`, 30 ms before the onset to just before the next one, 1.4-3.4 s). Levels are not known (hit peaks within a file span 0.4-1.0), so strokes' loudness against each other is a judgement.
Only the file names label the strokes. "rod" is read as the stick on the tension rod / hoop: its spectrum is metal ringing (323, 938 Hz and lines at 2.6-4 kHz, t20 about 26 ms). The recordist, the drum's size and its tuning are not stated; the head tone is 356 Hz.

## What the takes show (docs/SPEC.md has the numbers)
- One mode set shared by all four strokes at the same absolute Hz: 250, 286, 323, 356 (the head's open tone), 389, 440, 510, 576, 634, 678 below 700 Hz and 733, 800, 850, 940, 1117, 1211, 1363, 1437, 1616, 1720, 1855, 2096, 2340, 2520 above. Strokes pick different members: Open/Hand 356 (then 286, 576, 1117), Rimshot 1117 / 1363 / 573 / 865 / 2096, Rim 323 / 937 / 386 / 2.6-4 kHz.
- The head tone does not glide (351 Hz in the first 40 ms is the filter's start-up, 356-357 Hz from 0.1 s, 8 of 8 Open takes).
- T60 per mode, band-pass envelope slope (`tests/t60.py`): 0.2-0.7 s, median about 0.4 s; the broadband envelope falls 40 dB in about 0.2 s (Open/Hand) to 0.28 s (Rimshot), the Rim in 0.15 s.
- Takes of one stroke differ much: the Rimshot's strongest mode is 1117, 353 or 567 Hz depending on the take, the Rim's centroid is 0.7-2.3 kHz. The fit averages the band profiles of the 8 takes; `Vary` stands for the spread.
- Highs above 2.5 kHz: noise-like in the Open, Hand and Rimshot, partly tonal in the Rim.

## Judgement (no recording)
- **Mute** (the hand pressed on the head): the Hand's mode gains with the shell and highs 12 dB down, decay 5x faster, most of the ring killed at the hit. Levels of all strokes against each other.
- **Flam**: two Open hits 42 ms apart, the second 0.45 x (Bongo's numbers; not in these recordings).
- A hand slap proper (fingers cracking on the head) is not in the files; the Hand takes are an open hand, rise 2-7 ms.
- Shell modes at fixed Hz (not following Tune) is the Timbales finding applied here; the takes are all at one tuning, so it is not checked on this drum.
- Not read: the acoustics literature on the repinique (none found); metal-shell drums in Rossing's book are the usual analogue (see Timbales/docs/RESEARCH.md).
