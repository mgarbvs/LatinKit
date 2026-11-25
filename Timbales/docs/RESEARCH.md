# Timbales research, round 1 (2026-10-29)

Tags: **[read]** read in the source this round; **[2nd]** a search-result summary or secondary report of a source we did not open; **[meas]** measured by us on the reference recordings; **[inf]** our own inference or arithmetic; **[unverified]** retailer or forum claim, no primary source. No PDFs are stored in the repo.

## Verdict
- **No published modal measurement of a timbale (head or shell) turned up.** Searches (timbale shell modes, cylindrical shell struck by a stick, Rossing, JASA, ASA, thin metal shell ring) found general drum-shell work only. Every number for the model's modes comes from the recordings below; the literature gives structure, not numbers.
- Instrument facts (sizes, strokes, how cáscara is used) are well documented in educational sources; tuning pitches are not.

## 1. The instrument
- **What it is** ([Wikipedia: Timbales](https://en.wikipedia.org/wiki/Timbales), [read]): shallow single-headed drums with metal shells, open at the base, usually metal (wooden shells exist), mounted on a stand and played standing, struck with wooden sticks on the heads and shells (bare hands sometimes). Heads were calfskin, now mostly plastic on a steel rim. Shallower than tom-toms and tuned higher for their size. Descended from the Cuban *pailas* (metal pans) that replaced imported timpani in the danzón orchestras, about 1900; Tito Puente is "the king of the timbales". The article cites Orovio 1981, Wacker 2003, Quintana & Silverman 1998 (*Changuito: A Master's Approach to Timbales*), Peñalosa 2010 (*The Clave Matrix*); we did not open them.
- **Sizes**: Wikipedia gives an average 13 in (33 cm) *macho* (the high drum) and 14 in (35 cm) *hembra* (the low drum) [read]. A retailer page says LP made 12/13, 13/14 and 14/15 in sets, 13/14 was LP's first and 14/15 is now the most preferred [2nd, [MasterClass guide](https://www.masterclass.com/articles/guide-to-timbales) and LP / retailer listings]. LP's Tito Puente 14/15 model: solid brass, bronze or stainless shells, 6.5 in deep [2nd, [LP](https://lpmusic.com/products/timbales/lp/tito-puente-14-and-15-timbales)]. Smaller timbalitos are 6 to 10 in [2nd].
- **Shell material**: brass, bronze, steel, stainless. A drum-shell patent says metal and composite shells carry vibration fast and give a bright, sharp beat, while wood decays longer and sounds gentle [2nd, [US6380468](https://patents.google.com/patent/US6380468)].
- **Tuning**: no source gave pitches or intervals (Wikipedia: "tuned much higher than tom-toms", nothing more [read]). **[meas]** on the Latin Percussion (LP) pack previews, three takes A B C per drum: High drum head fundamental 199 / 195 / 217 Hz, Low 131 / 111 / 113 Hz. The High/Low interval is a fifth (A) to an octave (C) depending on the take. So there is no single "right" tuning: the model's Tune (-12..+12 st) covers it, defaults High 200 Hz, Low 120 Hz.

## 2. Strokes
Names and meanings from Wikipedia and the MasterClass guide ([2nd] for the latter), the rest [inf].

| Stroke | What it is | In the model |
|---|---|---|
| Open (tono abierto) | stick on the head, bounced off, near the centre or off-centre; the head rings | head modes strongly, a little shell |
| Rimshot | stick hits the head edge and the rim at once ("striking the rim and head edge together"); the loudest, a crack on top of the head's tone | head and shell strongly, a bright noise tick |
| Cáscara (shell) | stick on the shell, near the top edge, usually with the head undamped | shell modes + a bright metallic splash; the head barely touched |
| Paila | stick on the middle of the shell; a lower, duller metal knock | shell only, its own mode weighting |
| Rim click | stick laid across the head and the rim (side stick / cross-stick), the head damped by the stick | short, head partly damped |
| Muted (apagado) | stick pressed into the head as it strikes (also a hand on the head), a dead thud | head damped hard |
| Abanico | not a stroke: a **roll with rimshot accents** that introduces a section after a stop, in two forms by clave direction (3-2 / 2-3) [2nd, [Abanico](https://en.wikipedia.org/wiki/Abanico), [cruiseshipdrummer](https://cruiseshipdrummer.com/?p=3217)]. Played with the rimshot stroke at high speed; no separate voice needed. |
| Press roll / flam / roll | LP previews exist ("Pressroll", "Flam", "Roll"); these are patterns of the same strokes | not modelled |

"Paila" is also the name of the instrument; as a stroke name it is used here for the shell's middle (LP calls the take "Stick", which is ambiguous, see section 4).

## 3. How cáscara is played
- The shells and the pattern played on them are the *cáscara* (also *palito*); the timbalero keeps time on it "during the rest of a song, outside solos and transitions" ([Wikipedia: Timbales](https://en.wikipedia.org/wiki/Timbales), [read]).
- Section use: in a typical mambo arrangement the timbales play a cáscara variation in the verses and the **mambo bell** (cowbell) in the chorus or montuno ([Groove Monkee style guide](https://groovemonkee.com/blogs/blog/afro-cuban-percussion-style-guide), [Soundbrenner](https://www.soundbrenner.com/blogs/articles/cascara), [2nd]). Cowbells were added in the 1940s mambo era; the bell patterns derive from the rumba / guaguancó cáscara, written in 3-2 clave ([Wikipedia], [read]). Changuito (1970s) played timbale and bongo bell parts simultaneously.
- Clave alignment: the pattern follows the clave's direction (3-2 or 2-3) and players start on whichever half the chord progression begins [2nd].
- The exact two-bar cáscara a particular player uses varies; we found no single authoritative transcription (the pages found were tool documentation or lesson summaries). The demo's cáscara (`docs/demo.wav`) is **our reading**: a hit on every clave note (accents), ghost notes on the gaps. It is not a transcription.
- Son clave 3-2 on an 8th grid over two bars (16 steps): hits at steps 0, 3, 6, 10, 12 (standard; [Wikipedia: Clave], not re-read this round).

## 4. Acoustics
- **Head**: a single-headed drum with an open bottom. A circular membrane's ideal modes are the Bessel ratios 1, 1.59, 2.14, 2.30, 2.65, 2.92 [inf, standard maths], but air loading pulls the axisymmetric modes toward a harmonic series for kettledrums (Rossing summaries, [2nd]); that does not necessarily transfer to an open-bottomed shell. **[meas]** on the High drum (all three LP takes and the Core Library "High Open Hard", which is the same recording as LP take A) the open stroke rings at f1 (T60 about 0.5 s), then **1.94 f1** (T60 about 1 s, matrix-pencil fit), with weaker early components near 2.15, 3.15, 4.15, 5.15, 6.0 and 7.0 f1 (spectral peaks of the first 30 ms). That is near-harmonic, not Bessel. The Low drum has f1 (T60 1-2 s) and 2 f1; its higher partials sit at the same absolute frequencies as the High drum's (below), so they are probably not head modes.
- **Shell**: a thin cylinder (about 1 mm brass or steel, 14 in across, 6.5 in deep, assumed [unverified]). The free ring modes of an infinitely long thin cylinder are f_n = h c / (2 pi a^2 sqrt 12) * n(n^2-1)/sqrt(n^2+1) (Rayleigh's inextensional modes, standard shell theory [inf]); with h = 1 mm, a = 0.178 m, c = 5.3 km/s (steel) that is about 21, 58, 112, 181, 266 Hz for n = 2..6, 481 Hz for n = 8, 758 Hz for n = 10, 1100 Hz for n = 12, and keeps rising roughly as n^2: **dense, inharmonic, spread over the whole audible range**, before the finite length, the rolled hoops, the head's rim and the stand change them. Real shell edges are reinforced (composite-shell study, [2nd, [CEU repository](https://repositorioinstitucional.ceu.es/handle/10637/13286)]: shells thinner than about 2 mm need edge reinforcement, and shell resonances feed back into the head), and a snare-shell forum thread lists a 1 mm typical thickness and head/wire/shell as three sound sources [2nd]. None of this is timbale data; **no published timbale shell mode list was found**.
  **[meas]** The averaged cáscara, paila (LP "Stick") and rim recordings show the same stable energy peaks on both drums: about 432, 577, 612, 720, 816, 920, 1090, 1155, 1633, 2593 Hz and a broadband splash 3-11 kHz (centroid of the cáscara: 6.1 kHz). Spectral peaks 816 and 1633 Hz in the Stick takes are a near-octave pair with T60 0.1-0.5 s. Matrix-pencil fits give dense, short-lived clusters (T60 0.1-1.3 s, 10-20 components within 400-1700 Hz): consistent with the dense-mode picture, not with a few clean partials. The model uses 16 fixed-frequency shell modes at those peaks and above (`SHELL` in `scripts/timbales_engine.py`).
- **Shell does not retune with the head**: the same absolute shell peaks appear on the High and Low drums in all three takes **[meas]**, so Tune moves only the head modes (and the mod wheel presses only the head).
- **Stroke physics** [inf]: the stick's contact lasts about 1 ms (hard) to a few ms; a stick on a shell excites the shell directly and the head only through the air and the rim (hence "cáscara barely touches the head ring"); a rimshot drives rim, head and shell together (every mode strong, widest spectrum); a muted stroke leaves the stick on the head, damping the head's modes (contact damping, see Stroke model in SPEC.md). No source gave contact times in ms for any timbale stroke.
- **Glide**: tension-modulation pitch glide exists for membranes in general ([Marogna, Avanzini & Bank, DAFx-10](https://people.ece.cornell.edu/land/courses/ece5760/LABS/s2016/MarognaAvanziniBank_tension_modulation.pdf), [read via the Conga round]); no timbale glide measurement exists. Not modelled.

## 5. Reference audio (what was measured)
The LP previews are plain ogg (128 kbps) of the pack's encrypted samples; the Core Library one-shots are plain AIFF/WAV. **All are peak-normalised (Core: peaks 0 dBFS, up to +2 dB), so loudness between strokes cannot be recovered**: levels in the model are a judgement (`PEAK_DB`).

| Our stroke | Recordings (LP pack previews) | Notes |
|---|---|---|
| Open | `Timbales {A,B,C} {H,L} Open` (6) | also Core `Timbales High/Low Open Hard` = LP take A |
| Rimshot | `Timbales {A,B,C} {H,L} Rim` (6) | |
| Cáscara | `Timb {A,B,C} {H,L} Cascara` (6) | single strokes with a short noise-like attack |
| Paila | `Timb {A,B,C} H Stick`, `Timbales {A,B,C} L Stick` (6) | the label "Stick" is ambiguous; shell-only spectrum (no head tone) was the reason for calling it a shell stroke |
| Rim click | Core `Timbale Stick Slap` (1, 0.23 s) | the only one; no ring window, so its decay is assumed |
| Muted | `Timbales {A,B,C} {H,L} Mute` (6) | 0.4-0.9 s long |

Others found, converted, measured, **not fitted**: LP `Flam`, `Roll`, `Pressroll` (patterns); Core `Timbale 505` (an 808-ish synth), `Timbales Pete`, `Timbale Skin 1-3` (a higher-tuned drum: first peaks 686/1128, 382, 386 Hz), `Timbale Rim Thumb`, `Timbale Chop Processed`. LP "Instrument Kits" Timbales A/B/C and the Latin Percussion loops with "Timbales" in the name exist as previews; not used.

Measured band profiles, T60s, attack, t20/t40, centroid and crack for every stroke and drum: `python3 tests/fit.py targets` (and the ref-vs-ours table in SPEC.md). Headline **[meas]**: attack (10 % to peak) 1.8-11 ms (open Low 11 ms, cáscara 1.8-2.4 ms); t20 (5 ms RMS) open 134-195 ms, rimshot 182-299, cáscara 60 (!), paila 52-59, rim click 37, muted 33-38; spectral centroid open 236-455 Hz, rimshot 850-1070, paila 1.0-1.7 kHz, rim click 2.8 kHz, cáscara 6.1-6.2 kHz; share of energy above 1.5 kHz in the first 40 ms: open -13..-17 dB, cáscara -0.3 dB (nearly all of it).

## 6. What is not known
- Any physical measurement of a timbale head or shell (mode table, T60, coupling): none found. The shell's mode frequencies are spectral peaks of three takes per drum, not a modal analysis.
- Stroke loudness: the previews are normalised.
- Stick contact times, the true spread of tunings, which stroke LP's "Stick" take is.
- Whether "Skin"/"Chop"/"Pete" Core one-shots are the same drums.

# Round 2 (2026-10-30): analogues, contact times, maker data
Still **no timbale-specific modal measurement** (English, Spanish, Portuguese; JASA/ASA, ISMA, DAFx, Forum Acusticum, theses; darbuka/tabla). What turned up:

## Stick contact time (fixes the "attack too sharp" fault)
- **Wagner 2006**, KTH MSc "Analysis of Drumbeats" ([pdf](https://www.speech.kth.se/publications/masterprojects/2006/AndreasWagner.pdf), [read]): hickory stick (53 g) on a 14x5 metal-shell snare with Ambassador head: contact **3-6 ms** (centre 5-7.5, near rim 3-4.5); shorter when louder or tighter; peak force 3 N (p) to >100 N (f); a second contact ~3.75 ms later from the head's reflection.
- **Dahl & Altenmüller 2008**, Forum Acusticum ([pdf](http://www.sofiadahl.net/pdf/DahlAltenmuller-ForumAcusticum08.pdf), [read]): rototom (single head, open shell, the closest analogue): contact **5.1-5.7 ms**, 50-90 N; 5-8 ms is typical mf at the centre of a tom/snare.
- [inf] our 0.5-2 ms rise is too short; a 3-6 ms contact (shorter for rimshot and rim/shell strokes) matches the recordings' 2-11 ms to peak. No stick-on-metal measurement found.

## Shell damping (the "cáscara too short" fault)
- **Fystrom & Rossing 1990**, JASA 87 S138 (abstract only): free snare-shell decay rate rises fast with frequency; in the assembled drum decay depends mostly on the support (slowest on elastic cords). No numbers.
- Material loss factors (snippets, sources disagree): brass ~1e-4, steel ~1e-3. [inf] T60 ≈ 2.2/(η f): η 1e-3 at 1 kHz → ~2 s, so the metal itself allows far longer rings than our 140 ms; real loss is joints, beads, the head/rim and the stand.
- **Lambourg, Chaigne & Matignon 2001** (plates, [HAL](https://hal.archives-ouvertes.fr/hal-01374311/file/Lambourg_16163.pdf), [read]): metal decay factors above 4 kHz ~100x those below 1 kHz → low shell modes long, high ones short.
- **Rossing 1992**, "Acoustics of Drums", Physics Today 45(3) ([pdf](https://aip.brightspotcdn.com/PTO.v45.i3.40_1.online.pdf), [read]): toms/congas = "single membrane open to the air on both sides" (the timbale's class); free-shell modes are cylindrical (m axial, n circumferential nodes); interferograms only, no frequency table.

## Head analogues
- **Skrodzka et al. 2006**, Archives of Acoustics 31(3) ([pdf](https://acoustics.ippt.pan.pl/index.php/aa/article/download/674/592/1079), [read]): 36 cm head on a steel snare: (0,1) 224 Hz ζ 5.1 %, (1,1) 322 Hz 1.4 %, (2,1) 457 2.2 %, (0,2) 566 2.3 %, (3,1) 734 3.3 %; ratios 1, 1.44, 2.04, 2.53, 3.28. Shell "very important" to the sound (two-headed, snares on).
- **Sørensen 2009**, Illinois Phys 498 ([pdf](https://courses.physics.illinois.edu/phys406/sp2017/Student_Projects/Spring09/Knud_Sorensen/K_Sorensen_Phys498POM_Spring09_Final_Report.pdf), [read]): doumbek (single head, open bottom): ratios 1, 1.40, 1.81, 2.51, 2.70, 3.07 (ideal 1.59, 2.29, 2.90, 2.63, 3.49).

## Maker / player data
- Shells: Meinl Marathon "1 mm steel with two circumferential flanged beads" [2nd, MusicRadar snippet]; LP Tito Puente "ribbed, both edges turned in", 5 mm steel rim [2nd, unverified]; LP Prestige brass/bronze/stainless 6.5 in, "rib placement" [read]; Toca Pro hammered/dimpled steel, 5 lugs [read]; Gon Bops Vilató aluminium 4 in deep [read]; Pearl uses inward beads [2nd]. No maker publishes gauge or shell mass.
- Brightness order brass < bronze < steel < stainless; newer LP shells thinner, more overtones [forum, [mycongaplace](https://www.mycongaplace.com/forum/eng/viewtopic.php?f=3&t=3680), read]. Nobody tapes the shell; damping goes on the head edge [2nd].
- Tuning ([congachops](https://www.congachops.com/blog-articles/how-to-tune-the-timbales), read): hembra B2-B3 (123-247 Hz), macho F3-C5 (175-523 Hz), interval a 4th to an octave; Changuito lower ("Thunder" shells), Quiñones/Allende higher. Our defaults (120 / 200 Hz) sit at the low end.
- Sticks: 1/2 in (12.7 mm) untapered hickory, 13-17 in (LP655/656, Vic Firth TMB1/TMB2) [2nd].

## Promising but unreachable
- **Zhao 1990, NIU MSc thesis** (advisor Rossing), modal maps of a Ludwig metal snare shell alone and in the drum: [huskiecommons](https://huskiecommons.lib.niu.edu/allgraduate-thesesdissertations/974/) (Cloudflare blocks scripts; open in a browser).
- **Rossing, Bork, Zhao & Fystrom 1992**, "Acoustics of snare drums", JASA 92:84, doi 10.1121/1.404080 (paywall): shell mode tables.
- **Rossing, *Science of Percussion Instruments*** (2000) and **Fletcher & Rossing ch. 18**: tom-tom ratio/decay tables (books).
- **MDPI Acoustics 5(3):47** (drumhead damping from sound, FDTD) and **8(2):34** (percussion FEM review): 403 to scripts, open access in a browser.
- Bayan (metal-shell tabla) laser-vibrometer study, Univ. der Bundeswehr München: connection refused.
- MusicRadar Meinl Marathon review (would confirm 1 mm), pearldrum.com timbales, Drumchat "timbales questions" thread: walled or 403.

## Round 2b: PDFs the user retrieved (Sandisk/Cuica)
- **Rossing, Bork, Zhao & Fystrom 1992, "Acoustics of snare drums", JASA 92:84-94** [read]. The shell measured is **Remo composite**, not metal. Table II gives the free shell's (m,0) ring modes, with their decay rates; T60 = 60 / rate [inf]:

  | mode | free shell Hz | dB/s | T60 s | in the complete drum Hz |
  |---|---|---|---|---|
  | (2,0) | 80 | 55 | 1.09 | 221 |
  | (3,0) | 225 | 114 | 0.53 | 421 |
  | (4,0) | 425 | 175 | 0.34 | 874 |
  | (5,0) | 670 | 195 | 0.31 | 1064 |
  | (6,0) | 950 | 250 | 0.24 | 1271 |
  | (7,0) | 1260 | 300 | 0.20 | 1408 |
  | (8,0) | 1595 | 330 | 0.18 | 1670 (?) |

  The rim and hardware stiffen the shell, which raises its modes 1.1 to 2.8 times in the complete drum. The (m,1) modes are 355, 611 and 835 Hz. The authors say composite-shell decay is "very large", and that metal or wood shells "no doubt" decay substantially more slowly, but they did not measure them. Table III gives the head's modal decays: 22-49 dB/s on elastic cords (T60 1.2-2.7 s). On a stand, the (0,1) mode doubles to 70 dB/s and the (0,2) mode rises to 65 dB/s, because those two modes move the shell vertically. **The stand damps the drum.**
  - [inf] For the model: our `SHELL` ring times (0.1-0.45 s) are at or below this lossy composite shell's (0.53 s at 225 Hz, 0.18 s at 1.6 kHz), so a metal timbale shell should ring *longer*. That supports lengthening the low shell modes against the 540-960 ms cáscara tails. It also confirms that decay climbs with frequency, roughly linearly: rate ≈ 55 + 0.18·f dB/s on this shell [inf, fit by eye].
  - Head T60 1.2-2.7 s on cords and about half that for the stand-coupled modes. The Rimshot / Low Open decays being "too fast" is plausible on this evidence (our t20 105-117 ms).
- **Rossing 2001, "Acoustics of percussion instruments: recent progress", Acoust. Sci. & Tech. 22(3)** [skimmed]: a survey (kettledrum, Indian, Japanese and African drums, bars, steelpans). Nothing on timbales or metal shells.
- **Bayan/Tabla laser-vibrometer study (UniBw München 2003, German)** [skimmed]: the bayan shell is brass, but only the heads were measured, so it has no shell data. It cites Fleischer 1992, "Zur Rolle des Kessels bei Pauken" (UniBw research report 01/92), on the kettle's role in timpani. That is not retrieved.
- The *Science of Percussion Instruments* file is only a JASA book review (one page), not the book. The Physics Today 2014/2017 items and McIntyre 1983 are not drum-specific.

## Round 2c: Rossing, *Science of Percussion Instruments* (World Scientific 2000), ch. 4 [read, OCR of a scan]
- **§4.7 "Bongos and Timbales"** contains the only timbale text in the Rossing literature, and it is descriptive only. Modern timbales have metal shells 30-35 cm (12-14 in) across, open at the bottom or with a hand-sized sound hole. The heads are "tightly tensioned" and played with light wooden sticks. Head, rim and outside shell are all struck. **It gives no frequencies and no decays.** Bongos sit about a fourth apart.
- **Table 4.1, a single-head tom tom, 30 cm (≈ a 12 in timbale), no dot**: modes (0,1) 147 Hz, (1,1) 2.16, (2,1) 3.14, (0,2) 3.58, (3,1) 4.02, (1,2) 4.65, (4,1) 4.78 × f1. Rossing calls these "quite inharmonic". Centre dots pull them slightly toward harmonic.
  - [inf] **This re-reads our round-1 head measurement.** The High drum's weak early partials at 2.15, 3.15, 4.15 f1 line up with this tom's (1,1) 2.16, (2,1) 3.14 and (3,1) 4.02. So they are plausibly ordinary membrane modes of a single head over an open shell, not a "near-harmonic" series. The strong 1.94 f1 partial has no counterpart in the tom table and is still unexplained; it may be a split (1,1) or a head-shell coupled mode. Worth checking against `HEAD` ratios in the engine.
- **§4.8 Rototom** (single head, no shell), 10 in: (1,1) 310, (0,2) 370, (3,1) 561 Hz, with a (0,1)-dominated spectrum. Rossing notes no acoustic study of rototoms had been published.
- **§4.6 Conga**: fundamentals 131-262 Hz. Peaks near 80 and 240 Hz are (0,1)-type head motion coupled to the body's first two pipe modes, 420 Hz is (1,1) and 620 Hz is probably (2,1). There are no decays. The timbale's shell is too short for pipe modes in this range [inf].
- **§4.2 Pitch glide**: frequency rises with amplitude, so pitch falls during the decay. There is a measured curve for a 33 cm tom head (Rose, NIU MSc); it is a figure only, with no numbers in the text.
- **§4.4 Snare** repeats the 1992 JASA paper (round 2b), adding "Drums with heavy metal shells generally sound different from drums with less massive shells", and that a stand lowers some mode frequencies and damps them.

## Round 2d: what the recordings say about decay and attack (applied to the model 2026-10-30) [meas]
- **The cáscara tail is the drum ringing, not the room.** From 0.15 s on, the cáscara previews are tonal: spectral flatness 0.001-0.02 against 0.3-0.4 in the first 40 ms, centroid 400-900 Hz. The peaks are at 200-1300 Hz: shell modes, plus the head ringing in sympathy (e.g. 390 Hz ≈ 1.94 f1 on High A, 264 Hz ≈ 2 f1 on Low A). Per-band T60 (40 ms frames, 60 ms on, fitted until 8 dB above the take's own floor) below 1.7 kHz is 0.8-1.2 s on High and 1.6-2 s on Low. The model had 0.1-0.45 s; it now uses 1.0 / 1.8 s (`SHELL`, `SHELL_DRUM`). That is consistent with Rossing et al. 1992: a metal shell should ring longer than their lossy composite one (0.5 s at 225 Hz).
- **Above about 2.5 kHz the previews' late tail is broadband** at about -42 dB re the early total. It "rings" 1-2.8 s even at 8.7 kHz, which metal does not, so it is room, reverb or encoder noise. Not modelled, and it is why the cáscara's t40 (40 dB below the peak) still reads short.
- **Head ring times** from the open strokes: High 0.48 (f1), 0.87 (1.94 f1), 0.95, 0.71 s; Low 1.4, 3.1, 2.8, 1.9 s, i.e. Low ≈ 3 × High (`T60_DRUM` was 2). The High drum's 830-1400 Hz bands read the shell's ring, so the head's upper modes taper by hand.
- **Some previews are trimmed or noisy.** Paila ("Stick") and Mute files are 0.4-0.9 s long and faded (a uniform 0.33 s "T60" in every band is the fade). The A takes sit on a -39 dB floor. Ring targets below -42 dB are still real for Muted and Paila (-45..-60), so the fit's floor is now -50.
- **Attack.** The old "attack" (10 % to the highest bump of a 1 ms RMS envelope) read 2-11 ms in the recordings and 0.5 ms in ours. Both actually reach within 1-3 dB of the peak in the first millisecond, and the later highest bump is mode beating. The real difference is the rise from 10 % to within 3 dB of the peak (causal 0.5 ms RMS, now `rise` in `tests/measure.py`): recordings 0.9-3.0 ms (cáscara 0.9-1.1, rim click 2.7, Low open 3.0), ours 0.1-0.35 ms. That is close to the published 3-6 ms stick contact (Wagner 2006, Dahl 2008), shortened by tight heads and metal.
- **A longer contact was tried and not kept** (code: `engine_contact_attempt.py` in the session scratchpad, not in the repo).
  - (1) Lowering the contact low-pass (fc 100-250 Hz): its long two-pole tail drives the head's low modes while it lasts and leaves a weaker free ring, so t20 collapsed to 9-46 ms.
  - (2) A raised-cosine contact 2-5 ms long, roughened by 1 kHz high-passed noise, with the tick shaped to the contact: rise improved to 0.3-1.4 ms. But the fit only sees band energies over 40 ms, not timing, so it moved the high end into the short tick: a burst about 20 dB above the body, and t20 collapsed to 2-44 ms.
  - Doing this properly needs the rise (or the 0-10 ms envelope) in the fit's objective, and the tick limited to what the modes cannot carry.

## Round 3 (2026-10-30): comparing the plots, not the band energies [meas]
- `tests/compare.py <stroke> [High|Low]` plots each recording against ours: first 15 ms, 5 ms RMS, spectrogram (`docs/compare/`, gitignored). The fit's 40 ms band energies had hidden two faults the plots show at once.
- **Spectral flatness (`measure.flatness`, 2.5-9 kHz).** The recordings are -2.7..-7.4 dB at 5-40 ms and stay there to 100 ms (a noise periodogram is about -2.5): the splash is noise, not modes. Ours with sinusoids there: -13..-25 dB. Fix: shell modes above 2.5 kHz as decaying band-passed noise (`NOISE_FROM`, `NOISE_Q`); now -2.5..-5.
- **Decay of the splash** (regression over 8-90 ms of the band energy in 2.6-3.4, 3.4-4.5, 4.5-6.5, 6.5-8.7 and 8.7-11 kHz): T60-equivalent 0.2-0.3 s in every band on every stroke (rim click 0.13-0.16 above 3.4 kHz), flat with frequency, not climbing as the shell table assumed; ours was within the same range.
- **Rim click:** the recording's envelope ramps up for about 8 ms and its first 30 ms decay is rounder than ours (energy spread over 0-30 ms against ours front-loaded in the first 8). The band-energy fit cannot see timing in the first 40 ms.
- **Traps:** (1) `G` fitted on the noise bands from the ring window (room noise) ran to the clamps 0.4 and 10 and collapsed t20; noise bands keep G = 1. (2) The rim click's ring window does not exist (0.23 s file): its `G` is a hand seed, damping the head too.
- **Rise by smoothing:** two 0.3 ms one-poles on the noise bands' excitation give the cascara's 10 % to -3 dB rise 0.96 / 0.98 ms (recordings 0.89 / 1.06). Median over 10 hits: noise makes a single hit's rise vary by about 2x.
- **Per-hit spread of the takes** (std across A/B/C of each mode's early band level, modes above -30 dB): median 3.6 dB head, 3.3 dB shell sinusoid modes (80th percentile 6-6.5): the cascara's head modes 8.2 (n=5). They differ in tuning and hand position as well, so Vary's 1.5 dB is a judgement. The cascara's own sinusoid bands sit at -27..-36 dB re the total (the rest is noise bands and tick), so Vary hardly changes it.
