# Cuica — Max for Live instrument spec

## The instrument (research, 2026-10-28)
- Brazilian friction drum used in samba batucada; African origin (relatives: putipù in Italy, zambomba in Spain, rommelpot in the Netherlands).
- A thin bamboo rod is tied to the CENTRE of the head, inside the shell. The player rubs the rod with a damp cloth/sponge
  held between thumb and forefinger (push and pull strokes). The other hand's finger/thumb presses the head outside, near the centre:
  more pressure / nearer the centre = higher pitch. That gives the characteristic "laughing / crying" glides (oo-AH, squeaks, grunts).
- Acoustics (Paul A. Wheeler, "An acoustic study of the Brazilian cuica", JASA 112:2266, 2002; abstract only): rubbing gives a crude SAWTOOTH stick-slip excitation, like a bowed
  violin string; the rod drives the membrane centre, the membrane colours and radiates the sound; the BODY CONTRIBUTES LITTLE.
- Driven at the centre, only axisymmetric membrane modes (0,n) are excited: ideal ratios 1, 2.296, 3.598, 4.903 (air loading pulls them
  toward more harmonic ratios). Onofrei/Willemsen/Serafin (DAFx 2021) model a friction drum as a bowed membrane + tube with
  elasto-plastic friction (FDTD) — too heavy for us.
- Round 2 (2026-10-28): heads are 6-10 in (15-25 cm); the playable range from head pressure is up to ~2 octaves
  (BYU percussion page), so Thumb max 24 st fits; rhythm is articulated by push vs pull along the rod; a tighter grip on the
  rod also raises pitch (not modelled). No source gives pitch vs head size.
- Range: no source quantified; assume a fundamental of roughly 250 Hz–1.5 kHz for 6–10 in cuicas (UNVERIFIED, from listening memory).

## Round 3 (2026-10-28): fitted to real cuica recordings
User: "sounds too similar to a violin". The Latin Percussion pack's samples are Ableton-encrypted; its browser previews (.ogg) are not.
tests/analyze.py on them: high strokes (~470-500 Hz) are nearly sinusoidal (H2, H3 at -15..-30 dB, H4+ below -40); low strokes
(~117 Hz) are a harmonic grunt with H2-H4 strongest and nothing above ~1 kHz; strokes are ~150-200 ms bursts. Ours had H3/H6 ABOVE
the fundamental (the bowed sawtooth straight out). Fix: the output is the head's first mode, a resonant low-pass at max(f, Head Hz),
and the bowed waveguide is replaced by a stick-slip wave (it also started strokes on random harmonics). The model below is the
original plan; cuica_engine.py's docstring is current.

Round 3b: the full Samples/Combined/*.aif are encrypted too, but Live decodes them: loaded into Simpler on the LiveTest
track and rendered (docs/compare/ref_*.wav, local only, Ableton's audio, gitignored). Each file holds two strokes of ~250 ms.
High: H2 ~ H3 at -21..-28 dB (a symmetric soft limit on the head, DRV, gives H3). Low: f0 115-123 Hz sits 7-12 dB UNDER
H2-H4 (2-pole 200 Hz high-pass: a small drum barely radiates its lowest notes), a dip at H6, < 0.5 % energy above 1 kHz.

Round 4 (2026-10-28): user found long notes played a "phrase" (auto back-and-forth strokes). Now one stroke per note, push/pull
alternating per note; MPE pressure rubs on while held, slide = thumb, per-note bend. Stroke default 180 -> 300 ms (a one-shot of
225 ms, like the samples' ~250 ms strokes).

Round 5 (2026-10-28): "not all the way there yet, could be more realistic". The steady timbre already matched; what was missing is how
a stroke MOVES. tests/stroke_shape.py measures it per stroke on the pack's samples (docs/compare/ref_*) and Freesound previews
(docs/compare/web/, SOURCES.md; 21727 = a sambista's squeaks, the best one):
- pitch rides the rub: squeaks climb 240-510 ct over the whole ~120 ms stroke and land on the same top note (375 Hz +-15 ct) every
  time, the start varying +-1.5 st; plain strokes climb 0-90 ct and sag 12-237 ct as the rub eases.
- onset: 10-30 ms unpitched scrape, -6 dB re the peak in 10-30 ms (fast rhythm playing: the scrape is the loudest part).
- stroke end: the stick-slip breaks up, cycle lengths scatter 3-6.5 ms around a 4.4 ms half-period with uneven alternate pulses
  (YIN aperiodicity 0.28-0.53 on low strokes); one take flips an octave down mid-stroke.
- after the rub: the head rings on 21-33 dB under the peak, T60 0.2-0.75 s, 20-60 ct lower.
- push vs pull: within 20 ct in every recording -> real pulls are not higher, but Alt did nothing at Pull 0, so the default is +2 st (set 0 for realism).
Literature has no numbers for any of this (Hypercuica, NIME 2026: "raspy and guttural"; Vienna Talk 2015: one head's resonances
220, 820, 942, 1360, 1752, 1971 Hz, asymmetric modes; Wheeler 2002 is an abstract only).
Engine: scoop (default -4 st, +-25 % per stroke) rides the stroke (smoothstep, arrives at 60 %); pitch sags SAG * sqrt(weakness) under
a third of the rub; 35 ms attack ramp + an 8 ms cloth-noise burst through the head; creak = cycle jitter (capped at +-50 %: beyond
100 % the rod's phase ran backwards and never wrapped, stuck until reload) and alternate-cycle amplitude where the rub is weak, scaled
by Rasp; a resonator at the sounding pitch rings Decay (default 400 ms) after the 40 ms drive release. tests/test_strokes.py
checks the measured ranges.

Round 6 (2026-10-29): a friction model replaces the hand-made stick-slip. The scripted rod wave, its creak jitter, alternate-cycle
amplitude, onset burst and SAG term are gone. In their place: a hyperbolic friction law (mu 0.8 -> 0.3, v0 0.1) solved in closed form
each sample (docs/research/friction.md section 3) against 3 head modes (1, 3.5, 6.2 x the note; Q 80/30/30). Inputs: rub velocity
(stroke envelope x Speed x velocity, as before) and normal force = grip x the stroke's speed. Output chain unchanged (head SVFs, 200 Hz
HPF, DRV, ring, Volume), driven by the rod's velocity.
- What now emerges (Node, tests/stroke_shape.py, 6 strokes averaged; real ranges in brackets):
  - grip lowers pitch: Pressure 0 / 55 / 100 % = +3 / +9 / -25 ct at MIDI 72 mid-stroke; -33..-58 ct at full grip late in the
    stroke (real: Mestrinel's "more pressure = lower"; models give 10 ct to a semitone). Max: +10 -> -25 ct.
  - sag as the rub eases: MIDI 70 -94, MIDI 46 -115 ct (Scoop 0; real -12..-237). No SAG term.
  - end creak: MIDI 46 0.22 with the scoop, 0.26 without (real 0.28-0.53); MIDI 70 0.01 (real 0.01-0.38).
  - a slow rub under a hard grip turns raucous: periodicity 0.79/0.88 at full grip vs 0.98/1.00 at the default (MPE pressure 0.06/0.1).
    True period-2 appears only in corners (MIDI 50, Rasp 0, pressure 0.06). Octave flips are not robust.
  - onsets: scrape MIDI 46 37 ms, MIDI 70 30 ms (real 10-30); rise 30 / 20 ms (real 10-30); squeak climb 254 / 310 ct (real 240-510).
- Not emerging: wolf-like beating. Two runs (head modes alone; plus a split partner at 1.02-1.04 x mode 1) showed no 3-8 Hz amplitude
  modulation (depth < 0.1). A wolf needs a second resonance near the note, which the head model does not have. No beat test.
- Still set by hand: the scoop (unchanged); the hand's bite (3x extra force fading over 30 ms at a stroke's start, so low notes speak
  in ~20 ms: Guettler's attack needs extra force); the grip letting go over the last 6 % of the rub (or the cloth clamps the head
  dead and nothing rings); mode-1 tuning: +49 ct x grip up to the default grip (cancels the default flattening), and a sampling
  correction (stick/slip on sample boundaries runs high notes sharp: +14 ct at 2 kHz, 48 kHz; halves per 2x oversampling, so a
  1-multiply correction instead of oversampling); the head ring tuned to the rod's measured period.
- Rasp = wildness: mode 2-3 mobility 0.1 + 1.6 x Rasp re mode 1, plus the SDT noise term 20 x Rasp x noise x sqrt(|v| x force).
- Pressure: grip 0.135 + 0.9 x Pressure^2. MPE Slide gains a Grip destination (5th item). MPE pressure keeps its job.
- Tried and dropped: the friction force as the output source (richer: H2 -22 dB on a high stroke; but its period-2 and stick spikes
  broke every stroke measure); grip following the rub envelope (slow onsets); higher mode-1 Q (released MPE notes rang on).
- Timbre gap (not new): high strokes are purer than the pack's (H2 -57 dB at MIDI 70 Scoop 0; round 5 -48; real -21..-28).
- Tests: test_strokes.py averages 6 strokes (the model varies per stroke like the real thing); legato test windows moved past the
  stroke's catch and before the sag. New: grip flattens (bounded), a hard-gripped slow rub loses periodicity while the default grip
  does not, Slide = Grip, and a max-then-min guard on one engine. The two behaviour tests fail on the round-5 engine.
- Margins are thin: MIDI 46 rise 30 ms (limit 30), creak 0.22 (limit 0.2), scrape 37 ms (limit 40), back-to-back pitch ~+10 ct (limit 10). Live reads
  +3..+7 ct at MIDI 60-84 (Max -2..0).
- CPU: unmeasured in Max (maxtest has no CPU readout). The Node shim does ~1.45x round 5's per-sample work (3 sin + 1 sqrt added).
- Checked: Node all pass, standalone Max 17/17, Live 6/6. Unheard.

## Where we are (2026-10-29, after round 6, commit c994cea)
- Engine: friction law vs 3 head modes; grip lowers pitch; sag, creak and raucous slow-rub motion emerge. 13 dials, MPE page
  (Slide: Off/Thumb/Head/Tone/Grip), DS-Kick-style panel.
- Verified: Node engine + stroke-shape tests, standalone Max 17/17, Live 6/6, A/B renders in docs/compare/, docs/demo.wav.
- Not done: nobody has listened to rounds 5 or 6. Panel not re-screenshotted since round 4 (no layout change since).

## What's left
1. Listen: docs/demo.wav and ours_* vs ref_* / web/fs_21727. Everything below depends on what the ear says.
2. High-stroke timbre: too pure (H2 -57 dB at MIDI 70, real -21..-28; round 5 -48). Options: a small share of the friction force in the
   output (FMIX 0.5 gave H2 -47 and was never run through the tests), or an asymmetric term in the head's soft limit.
3. Low-stroke H6 dip (real -68..-76 dB, ours ~-16) is still missing, as in round 5.
4. Thin margins at MIDI 46 (rise 30/30 ms, creak 0.22/0.2, scrape 37/40) and back-to-back pitch (~+10/10 ct): any retune can tip them.
5. Live pitch reads +3..+7 ct vs Max -2..0 (probably sample rate via the DSC correction): check at 44.1 and 48 kHz.
6. Octave flips are rare (period-2 only in corners) and wolf beating does not emerge; if wanted, needs a second resonance near the note
   (rod or cavity), which no source documents for the cuica.
7. Still hand-set: scoop, the 30 ms grip bite, grip release at the rub's end, COMP/DSC tuning. Thumb-gesture data could make the scoop
   emergent too.
8. CPU in Max unmeasured (Node shim ~1.45x round 5). Measure in Live's CPU meter or add a readout to maxtest.
9. Real recordings (light vs firm grip, slow vs fast rub, thumb sweep, push/pull, a phrase) would replace the guesses in 2, 4, 6, 7: the
   grip-flattening size, creak statistics, whether slow rubs flip octaves.

## Model (deliberately simple; superseded in part, see Round 3)
Monophonic (one drum, one hand), legato, in one gen~:
1. **Rod/head stick-slip**: STK-style bowed waveguide. Loop delay = 1/f (fractional, smooth glides), friction junction with the
   STK bow table `refl = clamp(pow(abs(dv*slope + 0.001) + 0.75, -4), 0.01, 0.98)`, where slope comes from Pressure. Rub velocity
   from the stroke envelope × Speed. Loss filter in the loop (one-pole, Tone).
2. **Membrane colour**: 3 resonators at f × {2.296, 3.598, 4.903} (Head knob = mix + Q), excited by the waveguide output, summed with it.
3. **Cloth rasp**: band-passed noise × |rub velocity| × Rasp (the wet scrape).
4. DC block, soft clip, Volume.

Control flow:
- Note-on: target pitch = note (+ bend + thumb). Velocity → rub force/speed. Pitch glides from target+Scoop to target over Glide ms
  (legato note while held: glide from current pitch, no new attack).
- While a note is held the player keeps rubbing: back-and-forth strokes at Stroke ms each. Pull strokes (every other)
  are Pull semitones higher and a bit louder. Each stroke = raised-cosine rub-velocity envelope.
- Note-off: rub stops, head rings out with Decay.
- Mod wheel = Thumb pressure: 0..Thumb semitones up. Pitch bend ±2 st.

## Parameters (live.dial, top-level, annotated)
| name | range | default | unit |
|---|---|---|---|
| Tune | -24..24 | 0 | st (transposes notes) |
| Pressure | 0..100 | 55 | % (bow force → squeaky vs grunty) |
| Speed | 0..100 | 60 | % (rub speed → loudness/brightness) |
| Stroke | 40..800 | 180 | ms (exp) |
| Pull | -7..7 | 2 | st |
| Scoop | -12..12 | -5 | st |
| Glide | 0..500 | 60 | ms (exp) |
| Thumb | 0..24 | 12 | st (mod-wheel depth) |
| Head | 0..100 | 50 | % |
| Rasp | 0..100 | 25 | % |
| Tone | 0..100 | 60 | % |
| Decay | 10..2000 | 150 | ms (exp) |
| Volume | -36..6 | -6 | dB |

## Tests that must pass
- Node shim: pitch within 10 cents of the note at defaults (steady part of a held note, Scoop settled), for MIDI 60, 72, 84.
- Self-oscillation starts within 40 ms for velocity 100; output finite and < 0 dBFS for all extreme dial settings.
- Thumb at 127 raises pitch by Thumb st (±15 ct); Pull alternates pitch between strokes.
- Note-off: silent (< -60 dB) within 3×Decay.
- Real Max (maxtest-mcp): cold first compile clean, makes sound, pitch check at MIDI 72.
