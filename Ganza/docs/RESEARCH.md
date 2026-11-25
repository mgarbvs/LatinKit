# Ganza: research notes (2026-11-03)

What a ganzá is, what recordings exist under Creative-Commons licences, what was measured, what is judgement.

## The instruments

- **Ganzá** (samba): a metal (aluminium or steel) tube, 15-25 cm long, closed at both ends, filled with shot, beads or rice; one or two joined tubes. It is played in
  continuous back-and-forth strokes, one per 16th note, held in one or two hands; the forward stroke (towards the end of the tube the player's hand points to) is the
  accented one, the back stroke the lighter one. The beads slide to the end cap and hit it at every turnaround.
  (Retail and maker pages only: kalango.com, normans.co.uk, Wikipedia "Ganzá"; no measurements were found.)
- **Chocalho** (de platinela): a frame (aluminium, often three rows) of jingle pairs (platinelas), as on a tambourine, shaken in the same back-and-forth way in samba
  bateria. Rows of platinelas ring: the recordings below show narrow lines.

## Recordings used (all downloaded as previews, converted to mono 48 kHz in `ref_wav/`, gitignored)

| name in `ref_wav/` | what | source | licence | use |
|---|---|---|---|---|
| `ganza_arroz.wav` (2.0 s) + `arroz_s01..14.wav` | "Ganzá de arroz": a ganzá played in 16ths at ~127 BPM (118 ms a stroke), 15 strokes, accents | freesound.org/people/Ilson_Junior/sounds/609774/ (preview cdn.freesound.org/previews/609/609774_7096110-hq.mp3) | CC0 | **the ganzá fit**: even strokes = forward (7), odd = back (7), cut trough to trough by `tests/segment_refs.py`; the 16th pattern |
| `ganza_mattyharm.wav` (2.9 s) | "Ganza.wav": four single strokes, edited | freesound.org/people/mattyharm/sounds/444344/ | CC0 | cross-check only (centroid 11.3 kHz vs the loop's 10.6 kHz; slow 60-100 ms swells) |
| `choc_fwd1..7.wav`, `choc_back1..7.wav` | "Samba Chocalho de Platinela - Forward n / Back n": single strokes (0.9-1.5 s) | freesound.org/people/CamTarn/sounds/556070-556078, 556081 (Forward), 556066-556069, 556071-556073 (Back); preview cdn.freesound.org/previews/556/5560xx_77117-hq.mp3 | CC0 | **the chocalho fit**, forward and back |
| `choc_rhythm1/2.wav` | same author, 9.8 s / 6.8 s rhythms (556079, 556080) | | CC0 | looked at (pattern depth 13-16 dB, no fixed alternation); not fitted |
| `metal_alexarje.wav` (5.5 s) | "Metal shaker (SoundAction 252)" | freesound.org/people/alexarje/sounds/863230/ | CC BY 4.0 (Alexander Refsum Jensenius / SoundAction) | analysis only: persistent narrow lines near 4.47 kHz and ~9 kHz (the ganzá's tube-wall modes), 1.8 and 2.7 kHz; no audio reused |
| `choc_commons.wav` (15.8 s) | "Chocalho Sound.ogg", a chocalho rhythm | commons.wikimedia.org/wiki/File:Chocalho_Sound.ogg (user Samba-x) | CC BY-SA 3.0 | looked at (platinela lines at 5.7 and 13.3 kHz) |
| `ganza_jckovach.wav` (13 s) | "ganza_mixdown" | freesound.org/people/jckovach/sounds/806651/ | CC BY 4.0 | rejected: a processed mix (bass, centroid 350 Hz), no usable strokes |
| `kellenduat/494390` "quebraqueixo" | not a ganzá | | CC0 | not downloaded |

Nothing labelled ganzá exists in the Ableton Latin Percussion pack (checked by the brief); the Shaker 1-8 previews were not used (nothing there is clearly a metal tube).
Audio never enters the repo: `ref_wav/` and `docs/strokes_ab.wav` are gitignored. Downloads were treated as untrusted data (own empty dir, converted with ffmpeg, read with numpy / node only).

## What the recordings show (`tests/analyze_refs.py`, `tests/fit_refs.js`, `docs/compare/*.png`)

Ganzá loop (`ganza_arroz`, the only real ganzá recording with repeated strokes):
- 15 strokes, 118 ms apart (sd 16 ms), a **forward / back alternation in level**: the even strokes are louder (mean -4 dB re the loudest) than the odd ones (-9.4 dB): **back = -5.4 dB (x0.54)**, with some
  accent variation (the loudest stroke is 0 dB, 4 dB over its neighbours).
- Forward strokes are **brighter** (centroid 10.9 kHz, back 10.2 kHz: -1.2 semitones), **build faster** (rise 29 ms vs 36 ms) and **fall faster** (t20 45 ms vs 84 ms).
- Forward strokes have a **harder front** (the 1 ms RMS peaks 1.24 x the 10 ms RMS peak, back 0.92): the abrupt start of a loud stroke is the beads hitting the end cap; the soft strokes swell.
- Between strokes the level falls only 20.8 dB (peak to trough): a **shelf** of the previous strokes' tails, which is why the engine keeps Caxixi's second, slower energy store.
- Spectrum: nothing under 1 kHz, a slow rise to a broad maximum at 8-12 kHz (centroid 10.6 kHz); grain fluctuation 0.14-0.24 (dense).
- **Ring modes**: faint narrow lines at 4.46 kHz and 9.0 kHz (+3..5 dB over the continuum in the long-term average, also in `metal_alexarje`, 4.47 kHz and ~9 kHz, and in
  `ganza_mattyharm`, 4.7 and 8.9 kHz): the tube wall. Used at 4460 and 8960 Hz.

Chocalho (CamTarn, 7 + 7 single strokes):
- Forward: rise 24-52 ms, t20 52-98, t30 98-125, t40 145-366; centroid 8.2-9.5 kHz; the levels vary 14 dB between takes (not normalised).
- Back: **8.7 dB quieter on average** (x0.37), rise 33-95 ms (x1.4 slower), t20 79-117 (x1.4), centroid 9.0-10.0 kHz (**brighter**: +1.3 semitones).
- Narrow platinela lines (4.2, 5.9, 10.1, 11.4 kHz, in pairs 30-35 Hz apart in the rhythm clips): used as two ring modes (4230 and 5860 Hz).
- No hard front on a forward stroke (crest 0.44, back 0.66): no end-cap click for the chocalho.

## Decision: chocalho is a Type

Offered, because (1) there are real single forward and back strokes under CC0 (7 + 7), so the fit is measured rather than a judgement, (2) it plays the same back-and-forth samba gesture, so
Forward / Back / Accent / Roll / Back level all apply unchanged, (3) the engine needs only a second constant set. Its difference from the ganzá (slower, back stroke brighter and much quieter, no cap click, platinela rings instead of tube
modes) is in the recordings. Not offered: the Pandeiro's platinelas (that is `../Pandeiro/`).

## Judgement (not in any recording)

- The **accent** (x1.6 = +4 dB, end-cap click x2.5): the loop's loudest stroke is +4 dB over its neighbours; a ganzá player's accent beyond that is assumed.
- The **end-cap click** gain and decay (`clk`, `cdec` 1.5 ms): set from the crest of the loop's forward strokes (1.24); there is no isolated cap hit in any recording.
- **Whether `ganza_arroz` is a metal tube**: the title says rice ("de arroz"); plastic, wooden or metal was not stated. Its brightness (10.6 kHz) and the ring lines say metal; the loop is one instrument played by one person.
- A ganzá's single-stroke tail: the loop's strokes are truncated by their neighbours (t30+ unmeasurable: `trunc`); the slow store (`gs` 0.05, `ss` 150 ms) is set to the shelf level, not fitted.
- Roll's rate and alternation (a samba 16th feel is 7-9 strokes a second) and the Stroke menu's Key parity rule (reused from Shaker's request).
