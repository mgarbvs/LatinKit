# Conga research, round 1 (2026-10-29)

What the literature says about the parts of a conga model (modal head, stroke excitation, glide).
Tags: **[read]** = read in the source this round; **[2nd]** = a secondary or forum report of a source we could not open; **[inf]** = our own inference or arithmetic; **[unverified]** = a search summary or retailer claim with no primary source.
No PDFs are stored in the repo.

## Verdict
- **There is almost no open, measured conga acoustics.** Searches (Rossing, JASA, ASA abstracts, DAFx/NIME, laser-vibrometer and holography queries) found no mode table, no T60 and no stroke-contact measurement for a conga or bongo head.
  - The candidate papers named in the brief (Mastroianni, Kinkaid, Bork/Marshall/Fleischer, "Nonlinear tone production of the conga", Kenny/Chalmers) could not be found, so none is cited here. They may not exist as described.
  - The only conga paper found is a student journal study ([Harvey & Whiteley 2014](https://doaj.org/article/16110cdf41c247c4ae7d445440086044), abstract only): hitting nearer the rim makes higher modes dominate and raises the pitch. [2nd]
- **Rossing's *Science of Percussion Instruments* (2000) is the likely source of conga spectra, but it is out of print and we could not open it.** All we have are forum descriptions of its Fig. 4.11 (below).
- **So the reference WAVs in `ref_wav/` (Hi/Low/lp_Conga_*) stay the ground truth for numbers**, as the Cuica recordings did. Literature gives the structure: mode shapes, which mode a stroke excites, the glide mechanism.

## 1. Modes and ratios
- **Ideal circular membrane** (Bessel zeros, standard maths; our arithmetic [inf]), relative to (0,1):

| Mode | (0,1) | (1,1) | (2,1) | (3,1) | (0,2) | (1,2) |
|---|---|---|---|---|---|---|
| Ratio | 1 | 1.593 | 2.135 | 2.653 | 2.295 | 2.917 |

  A search hit lists (1,1)=1.594, (2,1)=2.136, (3,1)=2.653 [2nd], which agrees.
- **Air loading moves the modes toward a harmonic series, but the evidence is for timpani, not congas.**
  - Kettledrum: mass loading by the air raises the axisymmetric modes' ratios into a near-harmonic relation. Reported via a [Durham thesis](https://etheses.durham.ac.uk/id/eprint/5633/1/5633_3049.PDF) and Rossing's timpani work; the search summaries are all we have. [2nd]
  - Whether a conga head is near-harmonic when tuned well is **not established by any source we found**. A conga shell is open at the foot [inf, from drum construction], which differs from a timpani's closed bowl, so the timpani result may not transfer.
  - Indian tabla/mridangam are near-harmonic because of a loaded centre patch ([Ramakrishna & Sondhi 1954](https://repository.ias.ac.in/39763), abstract [2nd]). Congas have no such patch, so do not assume 1:2:3.
- **Which mode sets the pitch:**
  - Kettledrum: (1,1) is a dipole that radiates the note; (0,1) is a monopole that radiates strongly, decays fast and adds little to the pitch (Rossing summaries, [2nd]).
  - For congas, a forum report of Rossing Fig. 4.11 ([mycongaplace thread](https://mycongaplace.com/forum/eng/viewtopic.php?p=67165), [2nd], poster's description of a figure we have not seen) says:
    - Open tone: a single clear fundamental peak at about 240 Hz, far above the other peaks.
    - Open slap: the same peak at about 240 Hz, almost as loud.
    - Bass: fundamental 70 Hz, with a 280 Hz peak almost as loud (called sloppy technique).
  - The poster labels the 240 Hz peak "(0,1)". That conflicts with the dipole picture above. It may be a different drum or an error, so **do not rely on the label**.
- **Mode amplitude vs hit point** ([Avanzini & Marogna 2010, Fig. 6](https://avanzini.di.unimi.it/downloads/publications/avanzini_taslp10.pdf), [read], simulation): a hit near the centre feeds mostly the lowest modes; a hit near the rim excites higher modes, "even more noticeable in the 2-D circular membrane". Snare-head modal analysis agrees: (0,1) radiates strongly only for central excitation (Skrodzka et al., [Archives of Acoustics 2006](https://acoustics-old.ippt.pan.pl/index.php/aa/article/view/674), [2nd]).
- Shell: for snare/tom drums the shell adds very little to the spectrum (Huan, Zhao & Rossing, JASA 1989, [2nd]). That is not shown for congas; the Wavedrum author (section 5) nevertheless gives the Bonga a separate "shell" resonance.

## 2. Sizes and tuning
- **Head diameters** ([Wikipedia: Conga](https://en.wikipedia.org/wiki/Conga), citing Quintana/Changuito/Hidalgo 1997 [read via fetch]): quinto about 11 in (28 cm); conga 11.5-12 in (29-30 cm); tumba 12-12.5 in (30-32 cm). Retailer listings give the standard trio 11, 11.75, 12.5 in, shells 28 or 30 in tall ([Meinl listing](https://www.thomannmusic.com/meinl_12_1_2_diego_camacho_tumba.htm), [unverified] as to what "height" means).
- **Intervals** (Wikipedia, no inline citation): two drums a perfect fourth apart; three drums on a major chord (F, A, C) or its second inversion (G, C, E); some use a major second quinto-to-conga, then a fourth down to the tumba.
- **Absolute pitch: no sourced Hz values.**
  - A search summary gives "120-200 Hz" for fundamentals [unverified].
  - The Rossing-figure drum above was about 240 Hz [2nd].
  - Scaling by diameter (pitch falling with size) is physics, but sizes 11 to 12.5 in span only about 1.14, so tension, not size, sets most of the range [inf].
- **Overtones:** one player reports G, E and F above a C fundamental ([same forum](https://mycongaplace.com/forum/eng/viewtopic.php?p=67165), anecdotal [2nd]). Do not use as data.

## 3. Decay, glide, bending
- **T60 / -20 dB times: no source found.** Measure from the reference WAVs.
- **Pitch glide is real for membranes in general.**
  - Tension modulation: the head's tension rises with amplitude, so pitch falls as the sound decays.
  - Tom-toms show it "at medium-high dynamic ranges"; it "greatly contribute[s] to the characteristic timbre" ([Marogna, Avanzini & Bank, DAFx-10](https://people.ece.cornell.edu/land/courses/ece5760/LABS/s2016/MarognaAvanziniBank_tension_modulation.pdf), [read]).
  - The simulated glides last "a few tenths of seconds" ([Avanzini & Marogna 2010](https://avanzini.di.unimi.it/downloads/publications/avanzini_taslp10.pdf), [read]). That was a simulated stick hit (the DAFx paper uses 20 m/s, near the top of drum-set dynamics).
  - **No glide measurement for a conga was found.** Hand speeds are far below stick speeds, so a smaller glide is likely [inf]. The Cuica note's arithmetic (f = f0 sqrt(1+Tqs/T0), 80-160 cents for Tqs/T0 = 0.1-0.2) is the only size estimate and it is not conga data.
  - The glide in a real conga is also likely masked by finger contact on slap and muff strokes [inf].
- **Bending by pressing the head with the elbow or hand** is described in a conga reference (an [ipfs mirror of Wikipedia: Conga](https://bafybeiemxf5abjwjbikoz4mc3a3dla6ual3jsgpdr4cjr3oz3evfyavhwq.ipfs.4everland.io/wiki/Conga.html), [2nd]): "not a traditional stroke" but common in modern salsa and rumba. The direction (pressing raises pitch) is physical expectation [inf]; the Wavedrum's algorithms also raise pitch on pressure (section 5).

## 4. What distinguishes the strokes
Hand positions come from [Wikipedia: Conga](https://en.wikipedia.org/wiki/Conga) (citing Evans 1966 pp. 6-7, Quintana et al. 1997) [read]. **No source gave contact times in ms for any stroke.** The physical explanations in the right column are ours [inf], helped by blog posts with no data ([drukn](https://www.drukn.com/blog/bass-tone-slap-how-the-stroke-changes-the-sound/)).

| Stroke | Hand (sourced) | Likely physics [inf] |
|---|---|---|
| Open (abierto, tono) | Four fingers near the rim; "clear, resonant, higher-pitched" | Short impulse then release; head rings freely; (1,1), (2,1), (3,1) dominate. Best fit for the plain modal bank. |
| Slap (seco) | "Most difficult... loud clear popping sound"; fingers cupped near the rim | Hardest, briefest impulse: strongest high modes plus broadband noise; fingers may stay on briefly and damp the low modes. A flat hand-clap is broadband to about 10 kHz ([Fletcher 2013](https://www.acoustics.asn.au/journal/2013/2013_41_2_Fletcher_paper.pdf), [2nd]), so a noise burst is plausible. Rim position favours high modes. |
| Muff (tapado, ahogado) | Fingers held against the head, or cupped hand or heel | Contact continues, so every mode is damped hard. The result is short, with a pitched thud. |
| Bass (tono bajo) | Full, slightly cupped palm, somewhat off centre; "low muted sound" | Large soft contact near the centre. Low modes, with strong (0,1). Fast radiation and decay. |
| Heel-toe (manoteo) | Palm touch alternating with fingertip touch; used for "drum rolls" | Two alternating soft, damped touches (heel near centre, toe nearer the rim). A rhythm pattern, not a new voice. |

- **Contact time matters more than force.** Controlled drum-stick strokes had "significantly shorter" contact than normal ones ([Dahl, Acoustics '08](https://acoustics.org/pressroom/httpdocs/155th/dahl.htm), [2nd], sticks, one player).
- **A real hand-drum force dataset exists:** [Schloss et al., ICMC 2007](https://web.uvic.ca/~aschloss/publications/ICMC07_Hand%20Drumming%20Dataset.html) published 2D pressure-sensor data for hand-drumming techniques (zip not downloaded; drum and stroke list unknown). It could give contact durations and the footprint.

## 5. Korg Wavedrum "19 Bonga" [read]
Source: the Korg Wavedrum owner's manual (`WAVEDRUM_OM_E2.pdf`), p. 22. "Creates the sound of a barrel-shaped or tub-shaped drum, such as a bongo or conga... same playing techniques (open shots, slap shots, mutes, etc.)". Defaults Tune 73, Decay 43. All parameters are 0-100, defaults in brackets:

| Parameter | Description (manual) |
|---|---|
| Shell Size (16) | Pitch of the body resonance heard during the attack |
| Shell Damp (41) | Overtone components of that body resonance |
| Sub Harmonics (2) | Low-frequency range; higher gives a lighter, harder sound with less low end |
| Brightness (45) | Higher gives extended highs, more piercing |
| Drum Size (66) | Higher gives lower pitch and rougher sound (like a larger drum) |
| Slap Level (80) | Level of the "buzzing sound" added to slap shots |
| Slap Decay (1) | Decay time of the slap sound |
| Slap Color (21) | Tone colour of the slap; higher emphasises buzzing, sharper |

- **Takeaway:** Korg's conga is a head resonance plus a separate shell resonance, with a slap that is an extra short buzz layer (level, decay, colour). It has no stated mode table.
- **03 WoodDrum** (same manual) is also "conga-like": Wood Type, Shell Decay (76), Shell Pitch (95), Shell Level (62); open shots ring, slaps and mutes are possible.
- Several Wavedrum algorithms raise pitch with head pressure (e.g. Koto bends up; Jingle has Pressure Pitch). This is a synth feature, not conga evidence.
- Other algorithms ("27 Conga, 28 Bongo") are PCM-based and have Switching and PCM Balance controls on strike position.

## 6. Prior art for the model
- **Modal membrane:** [Avanzini & Marogna, IEEE TASLP 2010](https://avanzini.di.unimi.it/downloads/publications/avanzini_taslp10.pdf) [read]. A struck-membrane modal engine with a hit-point dependent excitation, tension modulation and coupled heads; resynthesised rototom sounds. [Marogna & Avanzini 2009](https://air.unimi.it/handle/2434/654153) is the earlier nonlinear-membrane paper [2nd].
- **Cheap glide:** [Marogna, Avanzini & Bank, DAFx-10](https://people.ece.cornell.edu/land/courses/ece5760/LABS/s2016/MarognaAvanziniBank_tension_modulation.pdf) [read]:
  - The quasistatic tension Tqs is proportional to the membrane energy (their Eq. 20), so no per-sample tension integral is needed.
  - Energy can be computed at a lower rate (they downsample by 32, about 0.73 ms at 44.1 kHz) and interpolated; the sound stays "perceptually similar".
  - Extended to strings and membranes in [Avanzini, Marogna & Bank, JASA 2012](https://air.unimi.it/retrieve/dfa8b99e-b482-748b-e053-3a05fe0a3a96/avanzini_jasa12.pdf) [2nd].
- **Strike-intensity glide analysis:** [Kirby & Sandler, JASA 150, 2021](https://qmro.qmul.ac.uk/xmlui/handle/123456789/98182) [2nd]: a tom struck at 67 intensities, with the modes' evolution modelled by a DCT. A reference for how glide depth scales with velocity.
- **Bilbao, *Numerical Sound Synthesis* (2009)** [2nd]: the Kirchhoff-Carrier and Berger tension-modulated models, with finite-difference and modal schemes ([ch. on nonlinear plates](https://ccrma.stanford.edu/~bilbao/booktop/node173.html)). Bilbao & Torin (SMAC 2013) on nonlinear drum modelling. Both are more than a modal Max device needs.
- **Cook, *Real Sound Synthesis* (2002):** cited as a "physically informed" modal percussion approach by the DAFx-10 paper [2nd]; we did not open the book. No Cook, Rocchesso or Bilbao conga or slap model was found.
- **Damped contact as input:** [Jones & Schloss, NIME 2007](https://nime.org/proc/jones2007): a waveguide mesh both excited and damped by a 2D force matrix [2nd]. That is the closest published idea to a muff stroke (damping as part of the stroke).
- **Slap-stroke synthesis: no paper found.**

## Implications for the model
1. **Mode bank:** start from the ideal ratios above: 1, 1.593, 2.135, 2.653 (and 2.295, 2.917). Then tune the ratios (a per-drum "stretch") so the bank matches `ref_wav/`. Do **not** assume harmonic spacing. Open pitch is mostly (1,1) and (2,1) with (3,1) above [inf]; keep (0,1) as a separate, fast-decaying low part used by bass.
2. **Per-stroke excitation weights from hit position:** centre (bass) feeds (0,1); mid (open) feeds (1,1)-(3,1); rim (slap) feeds high modes plus a noise burst. Taken from Avanzini Fig. 6 and the Wikipedia hand positions.
3. **Per-stroke damping:** open = natural T60 per mode; muff = fixed short extra damping on all modes, as a contact that stays; slap = high modes ring briefly, the low modes cut by the fingers; bass = short. Measure the T60s from the WAVs.
4. **Slap layer:** a very short noise burst through a high-passed filter, with level, decay and colour controls, in the style of the Wavedrum Slap Level/Decay/Color.
5. **Shell/body:** a small separate low resonance for the "thump", as in Korg's Shell Size/Damp and WoodDrum's Shell Pitch/Decay. Check with the WAVs that one is audible.
6. **Glide:** apply an energy-driven frequency factor sqrt(1 + k·E(t)) to all modes (Marogna et al.), computed at a low rate, with k a Strength control. Likely small for hand strokes; fit k by ear and by the WAVs. Keep an optional pressure/bend control that raises pitch [inf].
7. **Tuning presets:** quinto/conga/tumba as pitch offsets. Default intervals of a fourth between neighbours (Wikipedia); do not hard-code absolute Hz.
8. **Heel-toe:** implement as a sequencer or retrigger pattern of two softly-damped strokes, not a new model.

## Gaps
- No measured mode table (frequencies, mode shapes) for any conga or bongo head, and no check of whether it is near-harmonic when tuned.
- No T60 / -20 dB times for open, slap, muff or bass strokes.
- No glide depth or time for hand strokes on a conga.
- No contact duration, force or footprint for the strokes, except the unopened Schloss dataset.
- Rossing's Fig. 4.11 values (240 Hz, 70/280 Hz) are second-hand, and the mode labelling there is doubtful.
- No sourced absolute pitch range per drum (the 120-200 Hz figure is unverified).
- No slap-stroke synthesis literature; no direction-of-bend source for head pressing.
- Not opened: Rossing 2000, Bilbao 2009, Cook 2002, the JASA 2012 and 2021 papers beyond abstracts, and the Schloss dataset zip. Gemini-research summaries were used only for leads and were not cited as sources; two of its claims (a closed "enclosed cavity" conga, a 200:400:700 Hz partial set) have no support.

## 7. What the recordings show (measured, 2026-10-29; `tests/fit.py`, `tests/modal.py`, `tests/measure.py`)
References: Latin Percussion pack "Drum Hits" previews (quinto / conga / tumba, takes A B C, open / mute / slap open / slap mute / heel / tip; peak-normalised, 128 kbps ogg, so shapes only) and Ableton Core Library `Conga *.aif` one-shots (open / muted / slap / ring).
- **Open tones** (strongest peak 60-400 ms in): quinto 349-394 Hz, conga 255-267 Hz, tumba 217-241 Hz (take A: 366 / 266 / 219 Hz, about F#4 / C4 / A3, a fourth and a major third apart). T60 of that mode 0.4-0.7 s (matrix pencil, `tests/modal.py`); broadband -20 dB at 110-220 ms, -40 dB at 320-410 ms.
- **Overtones** fall at ratios to the open tone of about 1.17 (a strong neighbour, -7..-12 dB), 1.5-1.6, 1.75, 2.05-2.1, 2.3, 2.6-2.9 (e.g. "Medium" 371 / 578 / 784 Hz = 1 : 1.56 : 2.11; "Open Hard" 265 / 311 / 465 / 636). It is not a harmonic series and not the ideal-membrane set (1.59, 2.14, 2.65 re (0,1)); the engine's mode ratios are these measured clusters (`MODES` in `scripts/conga_engine.py`).
- **Low body**: the tumba "Low Ring" has a 71 Hz mode ~0.5 s long at the same level as its 207 Hz tone (3 x apart); the other drums show weaker 65-90 Hz bumps; heel and tip strokes carry most of their energy at 0.3-0.6 x the open tone. The engine's two body modes sit at 0.30 and 0.52 x f1 and scale with the head (a shell resonance that stays put when the head is retuned is not modelled; the recordings' bumps vary 64-90 Hz between drums and takes).
- **A contact tick precedes the tone** in every stroke: 2-4 ms of broadband noise, crack (energy above 1.5 kHz in the first 40 ms) -34 dB re total for open, -21 mute, -22 heel, -29 toe, -14 slap on the quinto, 7 dB less on the tumba.
- **Strokes** (energy over the first 40 ms re total, quinto/conga): open = one tone + 1.17, 1.57; mute = broad hump 0.5-1.2 x f1, t-40 ~120 ms; slap = broad, flat from f1 to 3 x f1 plus the crack, t-20 only 30 ms but a 200 ms tail; heel = 30-150 Hz thump plus 0.8-1 x f1; tip/toe = f1 +-, short; slap-mute is the slap with the 1-1.3 x f1 region dead and 700-900 Hz strongest.
- **Not found in the recordings**: a bass stroke (palm in the centre; "Tumba C Sub *" are synth sub layers), any pitch glide measurement (no tool to separate it from room), real loudness (previews are normalised).
