# Cuica research, round 2 (2026-10-28)

What the literature says about the parts of a cuica stroke that docs/SPEC.md round 5 tuned by hand from recordings.
Detail, page numbers and quotes are in docs/research/: bowed.md, wolf.md, head.md, friction.md and practice.md.
Each claim there is tagged as read in the source, taken from a secondary summary, or our own inference.
The downloaded PDFs stay out of the repo, because they are copyrighted.

## Verdict
- **Nobody has measured a playing cuica.** The only cuica acoustics papers are:
  - Wheeler 2002, a JASA abstract only. It is cited as Wright & Campbell in earlier rounds; that was wrong, the author is Paul A. Wheeler.
  - Statsenko et al. 2015: mode shapes of a stationary, sine-driven head, with no damping data and no playing data.
  - Onofrei et al. 2021: a bowed-membrane model with no regime study and no comparison to a real cuica.
- **So our recordings (tests/stroke_shape.py) stay the ground truth for the numbers.**
- **What research adds is mechanism:**
  - why each behaviour happens;
  - which player control drives it;
  - one finding that changes the model: the grip on the cloth moves the pitch.

## Findings by behaviour

| Behaviour | What the research says | Strength | Our model now |
|---|---|---|---|
| **Cloth grip moves pitch** | More cloth pressure on the rod gives a LOWER pitch (Mestrinel 2009). Players change notes by easing the grip, marked "x" in Galante's transcriptions (Galante 2015, p. 90). Before the 1930s, notes came from the rubbing hand alone, with no head pressing. Physics: a heavier normal force flattens bowed strings (McIntyre & Woodhouse, read via Galluzzo's thesis). A lumped friction oscillator's frequency also falls with force (Akay 2002; our one-mode simulation in friction.md). | Practice: several independent sources. Physics: qualitative only. | Pressure only changes sharpness and jitter, never pitch. **This is the gap.** |
| **End-of-stroke creak** | At constant force, a slowing rub drops the bow-force upper limit (proportional to velocity; measured by Schoonderwaldt et al. 2007) below the force applied. The motion then turns raucous: random slips and delayed triggers of about 1.2 to 2 periods, then period-2 (Kawano 2025, half-frequency stick-slip at high force and low speed). | Mechanism: strong, for strings. It transfers to one head mode only qualitatively. | Jitter and alternate-cycle amplitude scaled by rub weakness. Same shape, hand-made. |
| **Noisy onset (scrape)** | Attack quality depends on how fast the rub builds up versus force (Guettler 2002: under 5 ms counts as a "perfect" attack). 50-90 ms is the acceptability limit (Guettler & Askenfelt). Low notes need longer. Cheap model route: a friction noise term σ3·noise·sqrt(\|v\|·FN), as in the Sound Design Toolkit (SDT). | Strings: strong. Cuica: none. | A fixed 8 ms burst plus a 35 ms ramp, the same at every pitch. |
| **Octave flips, grunts below the head resonance** | Wolf-note physics. Near a strong resonance, one-slip motion is lost below a minimum force that rises there. The result is double-slip (an octave) or quasi-periodic beating at 3-10 Hz (Raman; Schelleng 1963; Woodhouse 1993; Gourc/Vergez 2018/2022). Which mode locks in depends on normal force, rub speed and contact geometry (Akay 2002). Galm 1977: players "rub to produce various partials". | Strings: strong. Cuica: inference. | Not modelled: no octave flips, no regime choice. |
| **Pitch sag and the ring pitch** | Tension modulation: pitch rises with the square of amplitude, f ≈ f0·sqrt(1 + Tqs/T0), with Tqs proportional to energy (Avanzini & Marogna 2010; Marogna/Avanzini/Bank 2010). As the rub fades, the pitch glides down along the energy decay. That is about 80-160 cents for Tqs/T0 of 0.1-0.2 (our arithmetic). No measured cents for any drum. | Mechanism: strong. Size: none. | Sag tied to rub weakness rather than to energy. The size matches by fit. |
| **Push vs pull** | "Try to get the same sound in both directions" (Sabanovich 2012). For loudness, use a longer and faster stroke, not more pressure. Faster tempo means shorter strokes. | Pedagogy | Pull 0 by default (round 5). Volume follows speed and velocity. Matches. |
| **Head pressing** | Harder and nearer the centre bead gives a higher pitch. Large cuicas: 3 fixed pitch levels from finger combinations (ring finger; index + ring; all three). Small cuicas: the thumb. "Low at the fingertip, high at the fingernail." | Pedagogy (Sabanovich 2012, Lima 1988) | One continuous Thumb control (mod wheel). |
| **Range and register** | More than 1 octave (Galm), about 2 (Uribe), about 3 (Reed & Leach); none measured. Played as a two-note low/high instrument with glissando. The solo role dates from about 1940. Carioca tuning is very high; 1930s cuicas sounded much lower. The rod's mass lowers the head about 20-30% (our estimate from Statsenko's numbers). | Descriptive | Thumb 12 st, Tune ±24. |
| **Patterns** | 1940s solo cells alternate low and high. Badu 1941 inverts the low/high of the candomblé "cabula" pattern. A constant cell on beats 1-2 with variations on 3-4 (Galante pp. 91-93). The notation itself is images in the PDF. | Historical | Not modelled. MIDI drives patterns. |

## A real-time friction model, if we replace the hand-made one (friction.md)
- **Elasto-plastic friction (Dupont; Avanzini/Serafin/Rocchesso):**
  - State equation: z' = v(1 − α z/zss); force f = σ0 z + σ1 z' + σ2 v.
  - Solved by Newton iteration, 3-7 iterations per sample at 44.1 kHz.
  - Reference implementation: SDT's `SDTInteractors.c`, which is explicit and uses an energy clamp.
- **A cheaper route that needs no iteration:** a closed-form stick/slip solve of the hyperbolic friction law against 1-3 two-pole modes, one sqrt per sample (derived and simulated in friction.md):
  - With one mode it gives clean stick-slip whose pitch falls with force.
  - With two modes it gives irregular and period-2 motion. That is one exploratory run, not a source.
- **No gen~ or SuperCollider friction implementation exists to copy.**

## Gaps no source fills
- The size of every effect on a real cuica: the sag in cents, how the scrape length depends on pitch, creak statistics, and the thumb pitch per amount of pressure. Only recordings can give these.
- How the thumb moves within a stroke (before, during or after the rub), and stroke lengths in ms. Pedagogy describes them only in words.
- Damp-cloth friction curves. All friction data found is rosin on string.

## Could not access
Full lists with URLs and reasons are at the end of each file in docs/research/. The ones that matter most:
- **Wheeler 2002, "An acoustic study of the Brazilian cuica"**, JASA 112:2266. Only the abstract exists online, and it may be all there is.
- Inácio 2008 and McIntyre, Schumacher & Woodhouse 1983: the user supplied both later (notes at the end of research/wolf.md).
- **Schelleng 1973; McIntyre, Schumacher & Woodhouse 1983; Woodhouse & Galluzzo 2004:** no open copies. Their formulas came via later papers that we did read.
- **Avanzini, Serafin & Rocchesso 2005** (IEEE TSAP): paywalled. Their 2002 and 2003 papers were read instead.
- **Tolonen, Välimäki & Karjalainen 2000** (tension modulation): paywalled.
- **Serafin's 2004 thesis:** 404.
- **Galante's music transcriptions:** images in the PDF, not readable as notes.
