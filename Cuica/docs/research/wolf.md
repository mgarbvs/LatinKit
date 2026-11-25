# Friction oscillator + single strong resonance: research notes

Tags: [P] = read in primary text (local PDF), [S] = secondary/search summary, not verified against the paper, [INF] = my inference.

## 1. Wolf note: string + one strong body mode (the closest analogue to rod + head)

- [P] Gourc, Vergez, Mattei, Missoum, CFA 2018 "Modele minimal de la note du loup" (cfa2018.pdf, abstract only is 1 page): minimal cello model, string + body dynamics, periodic solutions by continuation + shooting. When the Helmholtz-motion frequency is close to the body resonance there is a **secondary Hopf (Neimark-Sacker) bifurcation** producing **stable quasi-periodic solutions** that can explain the wolf. So the wolf is a torus (two incommensurate frequencies, amplitude beating), not period-doubling. Journal version: JSV 516 (2022) 116463, doi 10.1016/j.jsv.2021.116463 (not accessed).
- [S] Same JSV 2022 abstract (experts.arizona.edu): string with mass-spring boundary (body) + Coulomb friction; eigen-analysis shows **frequency veering near 1:1 string/body resonance** (modes hybridise); warbling = loss of stability of periodic solutions; linked to the minimum bow force.
- [S] Inacio, Antunes, Wright, JSV 310 (2008) 260-286: modal string, body coupled at bridge via impulse response/modal data; reproduces cello wolf. Reported (via Gemini summary, likely from the Southampton thesis P2509; not verified): beat frequency falls from ~7 Hz to ~5 Hz when bow force rises by ~4/3 (bow velocity fixed 0.02 m/s); more force can suppress the beating; at **low bow force a low-amplitude higher-order regime dominated by the second modal frequency** appears. I could not read the paper; treat numbers as unverified.
- [S] Raman 1918: wolf = alternation between Helmholtz motion (1 slip/cycle) and double-slipping (2 slips/cycle), when bow force is too low against the strong body resonance. Loading the bridge lowered wolf pitch 176 -> 160 Hz (17 g), -> 137 Hz (40.4 g). (Gemini-sourced; Akay confirms the "double slip" -> wolf link [P], see below.)
- [S] Schelleng 1963: linear coupled-oscillator view; body resonance is split into two peaks, beat = peak spacing, typically 3-10 Hz (example 174/182 Hz = 8 Hz beat). Woodhouse 1993 (Acustica 78, Parts I/II): wolf = note where body admittance raises the **minimum bow force** above what the player applies; Mansour (Cambridge repo 1810/263508) predicts max-wolfiness pitch is shifted away from the body resonance. Not read.
- [S] Cello MBR D3-G3 (147-196 Hz); wolf strongest at ~F3 174.6 Hz; heavier string = stronger wolf.

[INF] Mapping to cuica: a stiff-ish rod/cloth oscillator driven at f0 near the head mode f_r gives (a) beating/quasi-periodic amplitude cycles (your "alternating-amplitude"), (b) at low force a switch to a higher-order regime (2f0 dominant: octave flip up, or equivalently double-slip), (c) f0 pulled toward f_r (veering). Your 450 -> 235 Hz flip is ~2:1 (period doubling in pitch terms), i.e. the double-slip branch run in reverse; not a Neimark-Sacker beat. Both exist in the wolf literature, which suggests an oscillator that can latch into 1 or 2 slips per head cycle with hysteresis in force.

## 2. Onofrei, Willemsen, Serafin, DAFx 2021 [P] (onofrei.pdf, 8 pp)

- Model: 2D membrane FDTD (circular mask from 0.3 x 0.3 m grid, h=0.0167 m, rho 1400, H 0.007, c 15-150 m/s, sigma0 0-6 /s, sigma1 0-0.0026 m^2/s) rigidly connected to a **1D tube** (L 0.4 m, A 0.0707 m^2, gamma set to 30 m/s, NOT 343, tuned by ear; open end radiating BC alpha1=0.008, alpha2=4.348). Output = tube open-end displacement. fS 44.1 kHz.
- Friction: single-state elasto-plastic (Dupont). muC 0.3, muS 0.8, fN 0-20 W, vB 0-0.2 m/s, vS 0.1, s0 1e5 N/m, s1 = sqrt(s0)*0.001, s2 = 4, s3 noise 0-0.04 fN, zba = 0.7 FC/s0. Implicit solve: 3-variable Newton (v, z, fc), tol 1e-7, max 99 iterations.
- Results actually shown: MATLAB check at fN=12 N, vB=0.1 m/s: Helmholtz-like (triangular) membrane motion at bow point, stick-slip in relative velocity, hysteresis loop in f_B vs v (700 pts, Fig 5). Tube-end waveform "more complex" from membrane-tube feedback.
- Real-time: JUCE C++, Sensel Morph (position -> bow point, pressure -> fN and vB linearly coupled). Different bow positions/force "excite different modes" (Fig 6: mode 2 and mode 3 resonances). Grid is kept coarser than the stability limit for real-time; no cost numbers (no CPU %, no timing) given. Future work: optimise C++.
- Evaluation: Zoom demo to 17 students, qualitative only ("bowed inharmonic resonator", theremin, contact-miced cymbal).
- **What it does NOT contain**: no pitch-vs-force/velocity study, no octave flips, no subharmonics, no comparison to a measured cuica or any recording, no regime map. Stick is modelled as an infinite bow (constant vB), not a finite stick. So it gives parameter values and an elasto-plastic recipe, nothing on regime behaviour. Thesis (onofrei_thesis.pdf, AAU student project, same model) has no regime/octave analysis either (grep for octave/subharmonic/period-doubling: no hits).

## 3. Rubbed glasses, bowls, friction drums

- [P] Akay 2002 sec. II.A (akay.pdf): wine glass rubbed with violin bow "usually, but not always, shows dominance by only one of the natural frequencies"; first or second mode depending on how bow is applied; a fingertip nodal point makes the third mode lock. Cantilever beam/plate bowed: first, second or third natural frequency "and its harmonics"; rarely more than one at once; "mostly lock into a particular mode and oscillate in a rather stable manner".
- [S] Yokoi & Nakai (Osaka Sangyo Univ., 2022) wet finger on wine glass: sound caused by negative slope of mu vs sliding velocity. Patitsas (Laurentian): glass tone dominant ~700 Hz + harmonics with water-wetted finger, none with oil. Not read in full (Patitsas PDF download blocked).
- [S] Wheeler, "An acoustic study of the Brazilian cuica", JASA 112 (2002) 2266 (abstract only via search): folk cuica, waveform/spectra/envelope; rod rubbing gives "primitive saw-toothed excitation" like a bowed violin string; shell contributes little. Pitch controlled by pressing the membrane. No octave-flip data in the abstract; **full paper not obtained and worth getting for your cuica** (note: the abstract says shell contributes little, i.e. the "head resonance" is the membrane+rod system itself).
- Nothing found: measured subharmonics/squeal-onset data for singing bowls, waterphone, lion's roar, rubbed balloons, or "Tromba marina" bowed-membrane models. Searches returned only descriptive pages.

## 4. Akay 2002 JASA 111, 1525 [P]

- "Mode lock-in": coupled system responds at one of its natural frequencies and harmonics; **which mode is selected depends on normal load, sliding velocity, and contact geometry** (p.1526).
- Normal load does more than set friction force: within certain regimes of |Ff/FN|, **modes coalesce and go unstable (flutter instability)**, one mechanism of lock-in; a friction coefficient that **decreases with velocity** also gives instabilities and lock-in (p.1531-32). Mode splitting by normal force in beams/disks.
- Where the bow impedance is much lower/higher than the structure's, response follows the weaker component; comparable impedances give a response different from either (p.1526) [INF: rod+cloth vs head impedance ratio is a control parameter for how much the head "captures" f0].
- Violin: **double slip occurs when bow force falls below the minimum playable force; it splits the fundamental and produces the wolf tone** (p.1533). Single-DOF stick-slip coupling Gamma = (F0/k)/(V0/w0): bigger Gamma = longer sticking = longer period (so f0 depends on force/velocity for a lumped oscillator, but not for a string). Brake squeal bands (aircraft): walk 5-20 Hz, chatter 50-100, squeal 100-1000 Hz (context only).

## 5. Velut et al. 2016 refs
Not examined (no time; paper already in hand).

## Takeaways for the model
1. Minimum-force logic: below a force threshold that rises near f_r, the oscillator cannot hold 1-slip motion and goes to 2-slip (f0/2 or 2f0 depending on what the head supports) [Raman, Woodhouse, Akay]. Gives octave flips with hysteresis.
2. Near f_r, two coupled frequencies -> beating at roughly 3-10 Hz, shrinking with more force [S, Schelleng/Inacio].
3. Low-force/higher-order regime where 2nd modal frequency dominates [S, Inacio] = your H2-H4 grunts, [INF].
4. Quasi-periodic (torus) branch is real, from Neimark-Sacker at f0 ~ f_r [P, Gourc CFA abstract].

## Could NOT access
- Inacio/Antunes/Wright JSV 2008 full text (sciencedirect paywall; eprints.soton.ac.uk/65914/1/P2509.pdf and eprints.soton.ac.uk/377847 returned bot-block HTML; core.ac.uk/download/81513019.pdf and core.ac.uk/works/223106 403/HTML).
- IOA copy of Inacio et al. "On the violin family string-body dynamical coupling" (ioa.org.uk/system/files/proceedings/o_inacio_...pdf) returned HTML, not PDF.
- Gourc et al. JSV 2022 full text (Elsevier; HAL/arXiv copy not found).
- Woodhouse 1993 Acustica Parts I/II, Schelleng 1963, Raman 1918, Mansour minimum-bow-force (repository.cam.ac.uk/handle/1810/263508, PDF link not extracted).
- Wheeler JASA 2002 cuica (ui.adsabs.harvard.edu 405; paywalled).
- Patitsas "Singing sands and squeal sounds" (zone.biblio.laurentian.ca: returned HTML block page).
- DAFx archive copy (vbn.aau.dk Cloudflare challenge); worked via dafx2020.mdw.ac.at/proceedings/papers/DAFx20in21_paper_32.pdf.

## Added later: user-supplied full texts (2026-10-28) [P]
- **Inácio 2008 PhD thesis**, "A Modal Method for the Simulation of Nonlinear Dynamical Systems with Application to Bowed Musical Instruments" (ISVR, University of Southampton; eprints P2509). It is the full version of the JSV 2008 wolf-note paper.
  - Method: a modal structure with friction at the contact point. The friction is either Coulomb or a regularized near-zero-velocity "pseudo-adherence" law. It is applied to strings, bowed bars and Tibetan bowls (ch. 2-5).
  - Regime map for a violin G string, simulated over FN 0.1-10 N and bow speed 0.01-1 m/s. The regimes found are decaying, Helmholtz, higher-order (several slips per period), raucous (chaotic) and anomalous low frequency.
  - Trend: at high force, low speed gives raucous motion, and raising the speed brings back periodic motion. At low force, raising the speed gives a decaying regime (sec 3.3.3.4). This supports the "slowing rub turns raucous" reading of our end-of-stroke creak.
  - Flattening: the fundamental falls with normal force, down to 99.5 % of nominal (about 9 cents) in this model. Schumacher 1994 reports 1-3 % (17-52 cents). Below a force threshold, flattening is negligible, and the threshold rises with bow speed (sec 3.3.3.5).
  - Cello wolf note, simulated: the main body resonance is about 196 Hz. Faster bowing raises the beat rate and more force lowers it, and the wolf also depends on the bowing history (hysteresis).
  - Cello wolf, measured on the instrument (Figs 3.49-3.50). At FN about 1 N with rising bow speed, the beat went 4.3 -> 6.8 -> 7.3 -> 8.0 Hz. With rising force it went 5.8 -> 4.1 -> 3.6 Hz. Past a speed limit the wolf turns into a higher-order regime; more force gives Helmholtz motion, then raucous. Six regimes in all, including the wolf (sec 3.3.4.2, 3.4.2).
  - Bowed vibraphone bar (sec 4.3): the closest analogue to rod + head, a friction drive on a structure dominated by its first mode.
    - Motion is dominated by mode 1, and much of each cycle is spent sliding (unlike strings).
    - A harmonic of the stick-slip is audibly boosted when it lands near a higher bar mode: H4 near a mode at 3.95 x f1, or H3 near 2.75 x f1.
    - Three regimes: "musical" (mode 1); "decaying" (low force, high speed: always sliding); "support" (high force, low speed: a low-frequency rocking of the whole bar on its mounts).
    - Inharmonic modes shrink the musical region and lengthen the onset transient, because the modes struggle to lock into one period.
- **McIntyre, Schumacher & Woodhouse 1983**, "On the oscillations of musical instruments", JASA 74(5) 1325-1345.
  - One time-domain model covers clarinet, violin and flute: a linear reflection function plus one nonlinear characteristic. They show it is cheap to simulate.
  - Bowed string: hysteresis in the friction characteristic F(q) causes pitch flattening. The flattening grows with bow force and with the width of the reflection function. Their demonstration flattens by nearly a semitone.
  - Section D covers subharmonics (period 2, then period 4 and so on) and starting transients.
- [INF] For the cuica:
  - The rod + head is a bowed bar, not a string: one dominant mode, lots of sliding, and harmonics that light up near higher head modes. That fits the head colour we already have.
  - Grip-lowers-pitch matches the force-dependent flattening, about 10 cents to a semitone depending on the friction model.
  - Octave flips and beating match the wolf/higher-order regimes. Their beat rates (about 3.6-8 Hz) move with speed (up) and force (down).
