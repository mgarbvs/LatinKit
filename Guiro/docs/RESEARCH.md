# Reco-reco research (2026-11-03)

The Type menu's second entry was a judgement (no recording, nothing fitted). This is the search for a reference and what the new Reco-reco is built on.

## Which reco-reco does the samba bateria use?

- Two forms. **Traditional**: a notched cylinder of bamboo or wood, scraped with a wooden stick (woody, close to the güiro). **Modern**: a metal box or cylinder with 2-4 tensioned steel springs, scraped with a metal rod; much louder, bright and ringing, "dry, crisp, dirty, penetrating" in sellers' words (Kalango, Reverb, Bell Perc listings; Wikipedia: "a metallic cylinder with springs attached ... sounds much louder", played with a metal stick). Some metal models have a hole in the box that a hand can cover to change the timbre.
- Role in the bateria: a time-keeper of the subdivision with caixa, chocalho, frigideira and tamborim (ANPPOM 2014 paper on bateria instrumentation, anppom.org.br, 3028-9933-1-PB.pdf).
- **No source found says which material the bateria uses.** The Wikipedia page does not mention the bateria. The choice made here is a judgement: a bateria is hundreds of players outdoors, and only the loud metal spring instrument survives that, so the **metal-spring reco-reco is modelled**. The bamboo reco-reco is the Güiro Type's neighbour (a notched wooden scraper, woodier and lower than the springs); the Güiro Type fitted to the Latin Percussion recordings is the closest thing here, and no separate bamboo Type was built.

## References searched

| source | what | licence | used |
|---|---|---|---|
| Freesound 219634, "recoreco-texture.wav" by andrescompovigo (https://freesound.org/people/andrescompovigo/sounds/219634/), preview mp3 https://cdn.freesound.org/previews/219/219634_2235140-hq.mp3 | 15 s of continuous reco-reco playing (mono, 44.1 kHz preview, 192 kbps): scrapes back to back at 6-16 a second, two runs with a 2 s pause, rod stops and accents; broadband to 20 kHz with ringing lines at 1.3-4.7 kHz | **CC0** (page links creativecommons.org/publicdomain/zero/1.0/) | **fit target** (spectrum, ring-out) |
| Freesound 51358 "latareco.WAV" by la.terror | 0.17 s, centroid 3.4 kHz: a single hit, not a scraper (a "lata" tin) | CC0 | no |
| Freesound 496967 / 496968 "guiro metal", "guiro metal 2" by PhonosUPF | stereo files with the channels in antiphase (a mono sum is silent); one channel: centroid 0.7-0.9 kHz, a slow swelling rub (2.2 s / 23 s), no ridge train: not a scraper | CC0 | no |
| Freesound 164344 "120729_pagode_brasil_minas.wav" by reinsamba | 144 s pagode ensemble recording; a reco-reco is not separable in it | CC BY 4.0 | no |
| Freesound searches: reco reco, recoreco, reco-reco, raspador, caracaxa, querequexe, metal guiro, spring scraper, samba reco, batucada reco, brazilian scraper; Freesound packs "Samba" by CamTarn (chocalho, no reco-reco) | nothing else named a reco-reco | | |
| Wikimedia Commons, searches "reco-reco", "reco reco", "recoreco" in File: | photographs only (Reco-reco metal.JPG, Reco-reco de sapo.jpg ...), no audio | | no |
| Ableton Latin Percussion pack | no reco-reco (checked in the Guiro build too) | | no |

Audio is in `ref_wav/` (gitignored); `tests/reco_refs.sh` re-fetches and cuts it. The download is untrusted data: own directory (`ref_wav/reco_dl`), numpy-only analysis.

## What the recording shows

(`tests/reco_refs.py`, analysis in the scratchpad of the build session, numbers reproduced by `tests/fit_reco.js`.)

- **Strokes**: onsets 35-110 ms apart (mostly 55-80 ms) in the runs: one rod pass is 55-110 ms, the same as the Güiro's Up (80 ms) and Down (115 ms) strokes; the runs of 0.4-2 s are what the Long stroke is.
- **Impacts**: not resolvable. Inside a pass the spectrogram is broadband noise, so the coil crossings are fused (a 3 mm coil pitch at 1-2 m/s would be 300-700 a second). The impact rate of the engine (trm 3.0 x 130 /s = 390 /s at Ridge 100 %) is chosen from that estimate, not measured.
- **Spectrum**: centroid ~10 kHz (the Güiro's is 5 kHz); strong energy from 8 to 20 kHz; about 30 spectral lines between 0.6 and 5 kHz, strongest at 1465 Hz (+22 dB over the local floor), then 1277/1312, 1559, 1863, 2150, 2461, 3475, 4664 Hz: the springs' modes (a sheet of closely spaced lines, not three).
- **Ring-out** after the last pass of a run (two examples): the 1.2-3.8 kHz lines ring on for 0.3-1 s (about -7 dB 150-250 ms after the peak), the 6-16 kHz band is 20 dB down in ~100 ms and 24 dB under its start by 200 ms.

## Limits (judgement, not measured)

- One amateur recording through a 192 kbps mp3 preview, unknown microphone and room; one instrument. Stroke names and lengths are the Güiro's; whether a pass is up or down, and which clips are accents, is not known.
- Top (one tap) has no recording of a lone tap: its reference is the ring-out after a run.
- A real reco-reco has many lines; the engine has three tonal modes plus noise resonances.
