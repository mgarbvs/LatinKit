# Bowed-string physics for cuica stroke behaviour

Local PDFs in `.../scratchpad/papers/bowed/`. Tags: [R]=read in full text, [S]=search-snippet only, [I]=my inference.

## 1. Schelleng bow-force limits (Schelleng 1973, JASA 53)
Original not accessed; formulas below are quoted from Schoonderwaldt/Guettler/Askenfelt ISMA 2007 [R] (schelleng_retro.pdf), eqs 1-5, and Guettler 2002 eq 1 [R].
- Fmax = 2 Z0 vB / ((mu_s - mu_d) beta)
- Fmin = Z0^2 vB / (2 R (mu_s - mu_d) beta^2)
- Z0 = string wave impedance, R = termination damping, beta = bow-bridge distance / length. Log-log slopes are -1 (Fmax) and -2 (Fmin).
- [I] Dividing the two gives Fmax/Fmin = 4 R beta / Z0, so the playable window narrows as damping R falls or beta shrinks.
- Hyperbolic friction curve mu = mu_d' + K/(z - z0), z = vB/beta, gives modified limits Fmax = 2 Z0 (vB + beta z0) / ((mu_s - mu_d') beta) (eq 5), and the same factor in Fmin (eq 4). Both therefore stay finite as vB -> 0 (the beta*z0 term), as seen in Raman's experiments.
- Measured (bowing machine, steel D/E strings on monochord, vB = 5, 10, 15, 20 cm/s, beta 1/30-1/6, F 49-3000 mN) [R]:
  - Fmax rose in proportion to vB (the fitted constant c_upper is approximately linear in vB), with a marked deviation at 5 cm/s.
  - Fmin was independent of vB, which contradicts Schelleng's eq 1.
  - Slopes of the Fmax line become shallower than -1 at low vB, matching eq 5.
  - E string vs D string at 10 cm/s: Fmax 19% lower, Fmin 64% lower.
- Below Fmin: multiple slipping, or constant slipping (no sticking at all) at very low force: "faint sound of the bow slipping" [R, Lampis 2024].
- Above Fmax: mostly raucous motion (aperiodic; slips randomly spread in time, with stick phases longer than the nominal period), plus some anomalous low frequency (ALF) and S-motion [R, Schoonderwaldt 2007].
- Mechanism above Fmax: the Helmholtz corner is reflected at the bow instead of triggering release. It goes round again while static friction keeps building, and release is delayed by whole extra round trips [R, Guettler thesis 2002, "Triggering delay"].
- Slow bow end of a stroke, in the Schelleng picture: at fixed force, Fmax falls roughly linearly with vB. Fmax then crosses the player's force, and the motion leaves the Helmholtz wedge by the raucous/ALF side. [I]
- Pitch flattening [S plus R]. McIntyre & Woodhouse (1979) found that the delay in the corner at release outweighs the advance at recapture. The net round-trip delay lowers the frequency (Galluzzo thesis 2004, section 1.1 [R]; the original paper was not read). Easiest to demonstrate at moderate beta and low vB, and "pitch wavering" is what violinists hear. I found no cents figures in anything I could read. Your 50-200 cent sag cannot be calibrated from this literature.
- Torsional-trigger numbers do give discrete drops (see section 4).

## 2. Guettler 2002 (Acta Acustica 88, 970-985) [R, guettler2002.pdf]
- During attacks the operative parameters are bow force F and bow acceleration a, not speed.
- "Perfect attack" means Helmholtz triggering with less than 5 ms before it starts. 44% of 1694 violin attacks were perfect.
- Guettler & Askenfelt (ref [9] in the paper): a neutral onset on open G (196 Hz) was unacceptable if multiple slips lasted more than 90 ms (18 periods) or prolonged periods lasted more than 50 ms (10 periods).
- Lampis, Mayer & Chatziioannou, Acta Acustica 8, 44 (2024) [R, mdw1.pdf]: transients of 50-90 ms are "generally perceived as musically acceptable". They use their own summary of earlier psychoacoustics, not their own data.
- Guettler diagram: F on one axis, a on the other. The perfect-attack region is a triangular wedge, bounded by:
  - an upper limit on a: the string must stay stuck until the first nominal period ends. In your terms the bow is accelerating too fast and double slips happen.
  - a lower limit on a: the return waves from the nut must pass the bow.
  - The F-vs-a relation is roughly proportional.
  - Lampis 2024 eq 1 and 2 give the closed forms: a > b(1-b) F [(3-4b) mu_s - mu_d] / ...; condition B: a > b(1-b) F [3 mu_s - mu_d - 2 sqrt(2 mu_s^2 - mu_s mu_d)] / (T Z).
  - The measured wedge matches the theory qualitatively but not the limits quantitatively.
- Off the wedge (Fig 7): on the high-a side, multiple slips occur quickly; on the low-a side, initial periods are prolonged and irregular releases follow for several periods. This is the "prolonged / raucous" attack.
- Required acceleration is proportional to string fundamental (eq 8b, in the loss-free model), so low pitches have longer transients.
- Robot-arm measurements covered a up to 3.15 m/s^2 [R, Lampis]. Simulations used a = 0.5-9 m/s^2 with T = 5.0 ms (200 Hz).
- Regularity must be preserved after the attack: limiting static friction may drop only about 0.3% per period for the first 7 periods, then about 0.9% per period for the next 8 (Guettler 2002, section 8).
- Mapping [I]: your 10-30 ms scrape at 110-500 Hz is only about 2-6 periods. That is inside the "perfect or acceptable" window (under 50-90 ms) in duration, so it is a deliberate noisy onset rather than a failed Helmholtz attack.
  - Make it longer and rougher for low pitches (period-count scaling).
  - A single-mode head has no multi-round-trip Helmholtz structure, so Guettler's formulas do not transfer literally; only the qualitative F/a trade-off does.

## 3. Friction laws (Woodhouse & Galluzzo 2004 not accessed)
Their own paper could not be found. The following is from Galluzzo's PhD thesis (Cambridge 2004) [R, galluzzo_thesis.pdf, ch 1] and the Lampis paper.
- "Friction curve" model: mu depends only on relative speed. The shape is from Lazarus and Smith & Woodhouse (steady rosin sliding): a static plateau, then a falling curve with a steeper slope at low speed. Schelleng's hyperbolic form is the simple version.
- Measured dynamic loci in the f-v plane contradict a single curve (Smith & Woodhouse 2000; Woodhouse et al.): there is hysteresis.
- Smith & Woodhouse thermal model [R via thesis; S via search snippet for transition-temperature data]:
  - Rosin is near its glass transition at room temperature. Search snippet only: calorimetry gives about 50 C.
  - Slip heats it at a rate F*v, which lowers shear strength. After sticking starts the rosin is still hot, so the friction coefficient at stick onset is low.
  - The "thermal viscous" model was discarded; the "thermal plastic" model matched observations best.
- Measured mu_s depends strongly on force: about 1.4 average (Lampis), against 0.66 (Galluzzo). (mu_s - mu_d) rises from 0.6 at low force to 1.0 at high force [R, Lampis 4.1].
- Wet or damp friction, cloth, water: I found nothing in any accessible source.
- Mapping [I]: damp cloth on bamboo has no rosin glass transition, so thermal hysteresis is probably small. Friction may be closer to a velocity-weakening Coulomb or Stribeck curve (my assumption, not sourced).
  - It would be rate-and-state with a moisture-dependent adhesion time constant.
  - The curve flattens at low speed; Galluzzo found that flatter curves reduce hysteresis.

## 4. Raucous, subharmonic and ALF regimes
- Triggering-delay ALF (Guettler thesis, section on ALF [R]):
  - Torsional trigger lengthens the period to T0 (1 + zeta). zeta = c_transverse / c_torsional is about 0.2 for violin G strings, so the pitch falls a minor third (about 316 cents: 1/1.2 [I arithmetic]).
  - Transverse triggering at extra loops gives frequencies that depend on beta.
  - These are stable, periodic patterns, not noise. Bow force above Fmax or too slow a bow.
- Excess pressure or a too-slow bow: "the sound will turn out either creaky or raucous" and the waveforms become quite irregular (Guettler, knutsacoustics.com/videos-sounds.html) [R by fetch, a paraphrased summary].
  - With rising pressure there are about four distinct pitches; the third is near one octave down.
- Subharmonics (Kawano et al., arXiv 2502.11902, 2025) [R]:
  - Bow pressure up and bow speed down gives half-frequency stick-slip (one release every two cycles) at an octave below f0.
  - Seen on high-speed imaging; reproduced by finite-element simulation (steel string, 196.9 Hz, bow 10% from the bridge).
  - Alternating cycle character (first and second cycles differ) is the signature.
- Raucous motion classification (Schoonderwaldt 2007 [R]): slip-to-slip intervals randomly distributed, including above T0.
- Mapping to the end of a stroke [I]:
  1. As vB falls at roughly constant force, you move from inside the wedge to above Fmax (Fmax ~ vB).
  2. First you get flattening (small pitch sag).
  3. Then delayed triggers: intervals mix T0 with about 1.2 T0 or 2 T0, so +-40% cycle scatter is plausible.
  4. Alternating pulse heights then mean a period-2 pattern (Kawano).
  5. The last cycles are random, then stick, then silence.
  - Suggested model knob: a trigger-delay probability that rises as vB / Fmax_ratio falls, choosing the next interval from {T0, T0(1+zeta), 2 T0} with jitter. Not sourced as a model.

## Sources I could NOT access
- Schelleng 1973, JASA 53, 26-41: no open PDF found. Formulas via secondary quotes.
- Woodhouse & Galluzzo 2004, Acta Acustica 90, 579-589: no open PDF found by search.
- McIntyre, Schumacher & Woodhouse 1983 (JASA 74): not found.
- McIntyre & Woodhouse 1979 flattening paper: no direct PDF; read only the Galluzzo thesis summary.
- core.ac.uk/download/81513019.pdf (Mansour), /151178418.pdf (Galluzzo-Woodhouse-Mansour friction laws), /42337723.pdf (Woodhouse violin review): Cloudflare "Just a moment" challenge, HTML returned.
- ioa.org.uk PDFs (Smith & Woodhouse rosin; McIntyre-Woodhouse menagerie): HTML returned, not PDF.
- Smith & Woodhouse 2000, J. Mech. Phys. Solids: paywalled; only search snippets.
- acta-acustica.edpsciences.org/.../aacus240063 HTML: 403. Read the same paper via pub.mdw.ac.at PDF instead.
- escholarship.mcgill.ca/downloads/q811kn41m: returned HTML.
- mcp__gemini-research: 503 UNAVAILABLE, so no cross-check from it.
