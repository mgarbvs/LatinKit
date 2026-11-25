# Friction models for the cuica rod (research, 2026-10-28)

Tags: [P] = read in a primary source I downloaded (copies in scratchpad/papers/friction/). [I] = my inference. [X] = my own quick numerical experiment (scratchpad/code/hyp.py, sweep.py, two.py), exploratory only.

## 1. Elasto-plastic (Dupont) model as used by Avanzini/Serafin/Rocchesso

Equations [P: Avanzini-Serafin-Rocchesso DAFx-02 Eqs 2,5-8; Serafin-Avanzini-Rocchesso SMAC03 Eqs 3-6]:
- z' = v * (1 - alpha(z,v) * z / zss(v))
- f = s0*z + s1*z' + s2*v   (+ external noise term, see SDT)
- zss(v) = sgn(v) * (fc + (fs - fc)*exp(-(v/vs)^2)) / s0, with fc = mu_d*FN, fs = mu_s*FN
- alpha = 0 if sgn(v) != sgn(z) or |z| < zba; alpha = 1 if |z| > |zss|; between: 0.5*(1 + sin(pi*(z - 0.5*(zss+zba))/(zss - zba)))
- zba = c*fc/s0 with c < 1 (must have zba < min zss = fc/s0). [P: DAFx-02 Eq 14]
- LuGre is alpha = 1. It drifts under arbitrarily small loads; elasto-plastic removes this via the purely elastic zone |z| < zba. [P: DAFx-02 s2.1]

Parameter values in the literature:
- Bowed string: mu_s 0.4-0.5, mu_d 0.2 (violin, Askenfelt, cited in DAFx-02); sigma0 = 6000, sigma1 = 0 (SMAC03 cello, 44.1k-class waveguide). [P]
- Willemsen/Bilbao/Serafin DAFx-19 Table 1: mu_C 0.3, mu_S 0.8, FN 10 N, vB 0.1 m/s, vS 0.1 m/s, s0 1e4 N/m, s1 = 0.001*sqrt(s0), s2 0.4 kg/s, noise s3 = 0.02*FN, zba = 0.7*fC/s0, fs 44.1 kHz. [P]
- Matusiak et al. 2025 (fit to measured cello): s0 1e5 N/m, s1 0.5 kg/s, vS 0.228 m/s, mu_C 0.507, mu_S 1.02. [P]
- SDT defaults (read in SDTInteractors.c, GitHub master): vs 0.1, kStatic 0.8, kDynamic 0.2, breakAway kba 0.1 (zba = kba*fc/s0), stiffness 1000, dissipation 10, viscosity 10, noisiness 0.5; ks, kd, kba clipped to [0,1]. [P] The numeric ranges in SDT docs I could not get. The Gemini summary gave vague ranges, so I ignored it.

SDT specifics that matter to you [P, SDTInteractors.c]:
- Explicit: it computes alpha and dz from the current v and old z, forms f, then does z += dz*Ts. There is no Newton and no implicit coupling. Stability comes from a post-hoc energy clamp: if the force would add energy to the two resonators, the force is bisected (max 50 iterations, tolerance 0.001).
- Noise term: s3 * whiteNoise * sqrt(|v|*FN), added into f. This is the scrape/grit mechanism, and it scales with speed and force.
- Willemsen 2019 uses the same noise idea (cites Serafin 2004).

Discretisation (DAFx-02 s3, SMAC03 s3.1) [P]:
- Resonator modes: bilinear transform. z: trapezoid rule. The friction loop is delay-free, so a K-method is used: v(n) = v~ + k1*y, z(n) = z~ + k2*y, where y = z' and k2 = Ts/2.
- Solve y = f_NL(v~ + k1*y, z~ + k2*y) by scalar Newton-Raphson, starting from y(n-1). "Fewer than seven" iterations (DAFx-02), "seven" (SMAC03). Willemsen reports 3-4 iterations, tolerance 1e-7, cap 50, and never hit the cap.
- The earlier one-sample-delay version (Rocchesso-era) was reported to give inaccuracy and instability. [P: SMAC03 s1]

Stability [P unless marked]:
- Explicit schemes have no guarantee. Willemsen 2019 states that for his scheme there is "no means of ensuring numerical stability". He only borrows the LuGre passivity condition.
- Passivity needs s1 bounded: s1 <= 4*s0*zss(v)/|v| (Matusiak 2025 Eq 11, from Willemsen 2021). Dupont's original can have negative bristle dissipation and then violates passivity (their Fig 4: s0 500, s1 3 kg/s, FN 0.25 N). Their refined model has a unique root of G(v) in tests, and the original does not, even with oversampling. Matusiak says the implicit scheme can have a singular Jacobian, which can force "heavy oversampling" when force varies.
- [I] For explicit z-update, a rough limit is Ts*|v|*s0/f_ss < 2 (forward Euler on a linear ODE). With s0 = 1e4, fc = 3 N, v = 1 m/s that gives about 0.07, which is fine. It is not a proven bound.

Sounds produced: bowed cello string with hysteresis loop and Helmholtz motion (DAFx-02, SMAC03) [P]. "Squeaking doors and chalks" are asserted as possible with parameter changes (DAFx-02 s5.2) [P]. Neither paper gives numbers for door or creak. The 2005 TSAP paper (rubbing, braking, squeaky doors per its abstract, via search) I could not access.

## 2. Simpler alternatives

Static curves (all depend on slip velocity only) [P: Serafin-Smith-Woodhouse WASPAA 1999]:
- Exponential: mu = 0.4*exp(-dv/0.01) + 0.45*exp(-dv/0.1) + 0.35
- Hyperbolic: mu = mu_d + (mu_s - mu_d)*v0/(v0 + dv), mu_d 0.3, mu_s 0.8
- STK/Faust bow table is a reflection-coefficient table, not a force curve: r = min(1, (|slope*(dv + offset)| + 0.75)^-4). STK sets slope 3 initially and slope = 5 - 4*pressure. [P: BowTable.h, Bowed.cpp, faust physmodels.lib]
- Thermal ("plastic"): mu = A*ky(T)/N, with T from a linear filter of sliding velocity. It gives hysteresis. [P: WASPAA 1999]

Evidence on your three behaviours:
- (a) Noisy prolonged attacks. Bowed-string work links these to transients, not to the friction curve alone. Galluzzo's transients can begin with raucous episodes, with long uninterrupted sticking after the first slip. [P: Galluzzo thesis Fig 4.9] Guettler's wedge in the bow force vs acceleration plane sets whether a "perfect attack" occurs, and it is sensitive to mu_s/mu_d. [P: Lampis 2024] Friction curves reproduce this only through string dynamics. [I] For a single rod mode, an accelerating rub with a noise term (SDT s3) is the cheap route.
- (b) Raucous aperiodic motion at high force. In a string it means "Helmholtz corner prevented from passing the bow by excessive bow force", an elongated irregular sawtooth. [P: Galluzzo thesis p77; Lampis 2024] Static curves reproduce the raucous region of the Schelleng diagram (all three curves in WASPAA 1999, Figs 4-7). [P] [X] With one mode and the hyperbolic curve I got only periodic stick-slip (period CV below 0.005 across 18 force/speed pairs). With two modes (300, 470 Hz) the same law gave period CV 0.10-0.16 at vb 0.02, FN 3-10, i.e. irregular motion. So aperiodicity needs at least two modes or a noise/hysteresis term.
- (c) Period doubling. Subharmonics and the double-slip ("surface sound") are documented bowed-string regimes [P: Bader & Mores arXiv 1804.05695; Galluzzo "multiple flyback"]. I found no primary source giving period doubling for a single-mode friction oscillator (search for Popp-Stelter returned only second-hand reports). [X] 2 modes, vb 0.1, FN 10: odd/even cycle-length gap 24%, which is consistent with period-2. This is one run with a crude zero-crossing metric.
- Hysteresis helps. Plastic-thermal beat velocity-only curves on playability (larger Helmholtz region, Schelleng diagram) and the paper suggests a simplified hysteretic model as future work. [P: WASPAA 1999 s5] [I] A one-pole "temperature" state lowering mu after slip would be that cheap hysteresis. It is not tested here.
- Static curves have been assessed against machine-bowed data and miss details. Galluzzo/Woodhouse/Mansour: trends predicted, some details not captured by any model. [search summary; Galluzzo thesis read only in part]

McIntyre-Schumacher-Woodhouse 1983 (JASA 74:1325) is the cited origin of the graphical solution (load line intersecting the friction curve, with sticking when the required force is below mu_s*FN). [P: cited in DAFx-02 refs; I could not read it]

## 3. Friction against 1-3 modes

Delay-free coupling, noniterative for a static law [I, derived; verified by [X]]:
- Free relative velocity D0 = vb - sum_i v~_i. Each mode responds v_i = v~_i + (Ts/m_i)*f. Let h = sum_i Ts/m_i. Then D = D0 - h*f.
- Stick if |D0|/h <= mu_s*FN, then f = D0/h.
- Hyperbolic slip: (f - a)(B - h*f) = c with a = mu_d*FN, B = v0 + |D0|, c = FN*(mu_s - mu_d)*v0. Smaller root: f = [(B + a*h) - sqrt((B - a*h)^2 - 4*h*c)]/(2h). If the discriminant is negative, stick. Sign follows D0.
- One sqrt, one divide per sample, no iteration. Multiple roots exist where h*|F'(D)| > 1, so oversampling (h proportional to Ts) restores uniqueness. For the Stribeck exponential or the elasto-plastic state this closed form is gone and Newton is needed.
- [X] At 48 kHz, m = 0.01 kg, f0 = 300 Hz, Q = 40, this was stable (no NaN) for vb 0.01-0.2 m/s and FN 0.05-30 N. Behaviours seen: decay (no oscillation) for high vb and low FN; stick-slip whose frequency falls with force (about 297, 213, 108, 36, 12 Hz at vb 0.01 as FN goes 0.1, 1, 3, 10, 30); output peak rises with FN. The unit scale is arbitrary, so treat only the trends as findings.

Sample rate and CPU [P]:
- Bowed-string physical models for playability studies ran at 200 kHz. [P: WASPAA 1999, Bader&Mores] The elasto-plastic real-time ones run at 44.1 kHz. [P: Willemsen]
- Willemsen 2019: one FDTD stiff string plus 2x2 Newton friction (3-4 iterations) measured 5.95 % CPU (44.1 kHz, graphics off); 4 strings 17.9 %. Hardware details not captured.
- [I] A friction law plus 1-3 two-pole modes is far lighter than that string. Per-sample cost is about 2-3 exp/sqrt for the exact elasto-plastic Newton, or one sqrt for the closed-form hyperbolic case.
- Matusiak 2025: used 1024x oversampling only as a convergence reference. Their audio-rate scheme is stable for fs 44.1 kHz in tests. [P]

## 4. Reference implementations

- SDT (C core, Max and Pd externals): https://github.com/SkAT-VG/SDT, src/SDT/SDTInteractors.c (friction at lines 416-450). Explicit; read it.
- Sounding Object pd package "friction_2modalb" (Newton, K-method): described in DAFx-02 s4; source from soundobject.org (I did not download).
- Faust: physmodels.lib bowTable / violinBowTable (reflection table only, no elasto-plastic). https://github.com/grame-cncm/faustlibraries/blob/master/physmodels.lib
- STK BowTable.h, Bowed.cpp: https://github.com/thestk/stk
- Willemsen's C++/JUCE elasto-plastic string is described in DAFx-19; video link in paper ref [23].
- Max/gen~ and SuperCollider friction: none found.

## Recommendation (inference)
For gen~: two-or-three modes + closed-form hyperbolic/Stribeck stick-slip + SDT-style noise term sqrt(|v|*FN)*white. That gives scrape (noise term, onset), pitch drop with force (relaxation), and irregular regimes with >=2 modes. Add elasto-plastic only if you need presliding or hysteresis. Then use K-method Newton, 3-4 iterations, and cap s1 by the passivity bound above.

## Sources I could NOT access
- Avanzini, Serafin, Rocchesso 2005 IEEE TSAP (doi 10.1109/TSA.2005.852984): typeset.io mirror returned HTML, not the PDF. Used the DAFx-02 and SMAC03 predecessors instead.
- Dupont et al. 2002 IEEE TAC: mcgill.ca URL and researchgate returned HTML/404.
- McIntyre-Schumacher-Woodhouse 1983 JASA, 1981 Acustica: ioa.org.uk PDF links 404.
- Woodhouse 2003 Acta Acustica thermal model: no PDF found.
- Serafin 2004 Stanford thesis: ccrma.stanford.edu/~serafin/thesis/thesis.pdf 404.
- Jos Smith PASP bow junction page (ccrma.stanford.edu/~jos/pasp/Bowed_Strings.html): fetch returned navigation only.
- Matusiak 2025 text: read via the Frontiers PDF; Eq 34 (refined passivity condition) not checked.
- core.ac.uk downloads (151178418, 81513019, 83938783), Willemsen listing at dafx.de: blocked, returned HTML.
- Muller & Lauterborn 1996; Popp & Stelter 1990: no accessible copy.
- SDT documentation pages with numeric ranges.
