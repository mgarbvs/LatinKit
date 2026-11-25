# Cuica head: pitch vs amplitude/tension, and playing practice
[V]=read in downloaded primary PDF; [S]=search-snippet/secondary; [I]=my inference (not in a source).
PDFs: scratchpad/papers/head/{vt29,nime81,avanzini_taslp10,avanzini_jasa12,MarognaAvanziniBank_tension_modulation}.pdf

## 0. Headline: NO source gives cents-vs-amplitude for a cuica, or any measured cents for a tom/timpani
Searched; found none. Your numbers (50-200 c sag, 20-60 c post-rub) have no citation here; keep them as tuned-by-ear values.

## 1. Tension modulation (a)
- Mechanism [V, Avanzini&Marogna TASLP 2010 sec. "tension modulation"]: membrane area grows with displacement, so tension rises above rest T0; "proportional to total membrane area, the signal oscillates twice as fast as the fundamental" (TNL has a 2f component plus a slowly decaying part). Only qualitative: glides last "a few tenths of seconds" and "resemble closely those observed in real membranes" (cites their ref [43], not read). No cents given.
- Marogna/Avanzini/Bank DAFx 2010 [V]: TNL = Eh/(4*pi*R^4*(1-nu^2)) * sum_nm mu_nm^2 A_nm^2/||K_nm||^2 (eq 8). Its non-oscillating part is the quasistatic tension Tqs(t) = same prefactor * sum(... * e^(-2t/tau_nm)) (eq 9): decays at TWICE the amplitude decay rate, i.e. Tqs is proportional to energy (A^2). "A proportional shift (continuous decrease) in the modal frequencies" results.
- Avanzini/Marogna/Bank JASA 2012 [V]: "short-time average of the tension variation ... approximately proportional to the system energy." Examples: membrane T0 = 1500 N/m, impact 5 m/s (DAFx fig 1b): TNL peaks near ~250-300 N/m on the plotted axis (read off graph axis, rough) [I]. JASA names tom-tom glides "at medium-high dynamic ranges".
- Formula for frequency [I, standard result, not found verbatim in the fetched text]: f(t) = f0*sqrt(1 + Tqs(t)/T0) ~ f0*(1 + Tqs/(2*T0)), Tqs = k*A(t)^2 (k from eq 9), so cents = 1200*log2(f/f0) ~ 1731*Tqs/(2T0)... e.g. Tqs/T0 = 0.1 gives ~84 c; 0.2 gives ~160 c. Peak case above (~250/1500 -> ~0.17) would be ~140 c [I]. Glide is therefore DOWN-going in time as amplitude decays, shape ~ exp(-2t/tau), proportional to A^2 (not A). This matches your "sag 50-200 c as rub dies" in sign and size.
- Tolonen/Valimaki/Karjalainen (IEEE TSAP 8(3):300-310, 2000) [S only]: confirmed existence; abstract says f0 variation and mode coupling are the perceptually main effects. Could not read the formula (core.ac.uk link returned HTML). Kantele paper (Pakarinen et al) says frequency approaches the linear value asymptotically as vibration decays [S].
- Friction caveat [I]: a cuica head is driven continuously, not struck; Tqs tracks the driven amplitude^2. Rub dying -> Tqs falls -> pitch sags exactly as an exponential in A^2. The after-rub "rings 20-60 c lower" would be the residual: free ring has smaller A, hence less tension rise than the driven state, AND the stick no longer loads it as a friction/stick-slip partner [I].

## 2. Static point load and added mass (a, topic 2)
- No paper found analysing a central rod/thumb load on a membrane. Treat as [I]:
- Static central deflection w0 adds membrane stretch: tension rise ~ (E h/(1-nu^2))*(w0/R)^2 * const (same nonlinear-plate theory as above); pressing the thumb near the centre both raises tension and shortens the effective vibrating annulus (thumb pins an inner region), both raise pitch. Practitioner sources agree: closer to centre = higher [S: pt-BR snippet "Quanto mais perto do centro ... mais agudo"; BYU: "tighter one holds the rod, the higher the pitch"].
- Added mass: Rayleigh effective mass of the (0,1) mode at centre = M*J1(2.405)^2 = 0.2695*M [I, computed]. Point mass m at centre: f/f0 ~ 1/sqrt(1 + m/(0.2695 M)). Vienna sim values (sec 3): sigma = 1260 kg/m3 * 0.3 mm = 0.378 kg/m2, R = 75 mm -> M = 6.7 g [I, computed]. Rod+binding of 1-2 g gives m/(0.27M) = 0.55-1.1 -> f down 20-30% (~400-600 c) vs bare head [I, upper bound; rod is a lever, mass partly inside]. So "rod lowers frequency" is large, and a rod bound off-centre (1.4 mm in the paper) splits/asymmetrises modes.

## 3. Vienna Talk 2015 (Statsenko, Chatziioannou, Kausel) [V, read fully]
- Instrument: Meinl cuica, 15 cm diameter, goat skin ~0.3 mm thick; aluminium tube with ribs. Bamboo stick bound to centre; drive: stick sinusoidally excited, low amplitude "to avoid excessive nonlinearities" (not real playing).
- ESPI + single-point LDV, 200-2000 Hz sweep, 532 nm, 11 fps. FEM (COMSOL): clamped pretensioned membrane R = 75 mm, pre-tension 4470 N/m, E = 50 MPa, density 1260 kg/m3, nu = 0.3, 5 mm drive patch shifted 1.4 mm from centre.
- Measured shapes (Hz): 220, 260, 750, 820 (sim 883), 872 (highly asymmetric), 942, 1360 (0,2), 1752 (sim 1755, (4,1)), 1971 (sim 1975, (2,2)).
- Findings: "adequate agreement" with FEM; stick not exactly central + skin inhomogeneity + slight stick tilt -> asymmetric operating shapes that "become highly asymmetric with increasing excitation force"; real tension "cannot be easily modeled", varies randomly; altering tension in one direction did not reproduce the asymmetry. Future work (transient/nonlinear high-speed ESPI) - I found NO follow-up paper by these authors on the cuica 2016-2026 (search negative).
- NOT given: damping, Q, pitch-vs-amplitude, playing frequencies. Sanity check [I]: sim T0 and sigma imply c = sqrt(4470/0.378) = 109 m/s, f01 = 2.405*c/(2*pi*0.075) = 555 Hz; this conflicts with a 220 Hz lowest observed shape, so the quoted tension is probably a fitted number, or 220 Hz is a stick/lever mode. Do not use 4470 N/m as a real tension.

## 4. Playing practice (b)
Sources actually read: NIME 2026 Hypercuica (Trovato et al.) [V]; BYU percussion page [S via fetch]; assorted pt-BR blog snippets [S]. Galante and Bicolor theses: read separately, see practice.md.
- Hypercuica sec. 2 [V]: stick is INSIDE the body; wet cloth (experienced players prefer grosgrain ribbon) rubbed along it; other hand tensions membrane; melodic lines "spanning an octave or more". BYU [S]: "as much as two octaves". Galante: puita was the older name; Bicolor: a "range of traditional patterns within samba".
- Sec. 4 [V]: "classic cuica technique in which the final note is prolonged" (so a long held/decaying last note is idiomatic; reverb used to enhance it); "cyclical gestures" underlie samba carioca patterns (delay used to reinforce). Rotation of the instrument restricts finger pitch control. Takto test instrument: 8 cm x 30 cm stainless, open body.
- Grip [S, BYU]: rod held with thumb, index, middle fingers + damp cloth; rhythm from sliding the gripping hand along the rod, pushing and pulling; tighter grip on the rod = higher pitch (so grip is a second pitch control). Pressure on head: lighter = lower, firmer = higher (pt-BR snippet).
- Turiba blog [S, poetic]: outer-finger squeeze "commands the variations"; "leva-e-traz" back-and-forth; onomatopoeia "tu-tum-tu tum-tu-tu", "fuk-fuk".
- UNVERIFIED (Gemini summary, no primary source): puxada = pull toward player / empurrada = push away; named teachers Fofo, Robson Batata, Andre Siqueira, Oscar Bolao method. Treat as leads only.
- NOT FOUND anywhere: stroke length in cm/seconds; thumb timing (before/with/after the rub); the 3-5 semitone squeak glide; typical interval sets; rhythm notation of samba cuica patterns; tuning reference; wet-cloth wetness amounts. Your brief's 3-5 st glide and "pitch sag" claims are unsupported by anything I could read.

## 5. Suggestions for the model [I]
1. Use f = f0*sqrt(1 + kappa*E(t)) with E the squared head amplitude (smoothed); fit kappa so full-rub = 100-150 c above ring-down value. This reproduces the sag with no extra state.
2. Make the rod added-mass lowering part of f0 (fixed offset), not of the glide.
3. Thumb pressure acts as a tension add-on (raises f0) plus shortening; keep it as the control.

## Sources I could NOT access
- Tolonen/Valimaki/Karjalainen 2000: https://core.ac.uk/download/80700836.pdf (returned HTML wrapper, not a PDF); IEEE original paywalled.
- Galante, "Da cupopia da cuica..." USP 2015 (not located by URL; only Gemini summary, which says it is historical, not pedagogical).
- Bicolor master's thesis: search found only the book "Cuicas Imortais" (Morula 2024), not the thesis.
- cuiqueiros.blogspot.com: no search hit, not fetched.
- Fletcher & Rossing timpani chapter, Avanzini TASLP ref [43] (real-membrane glide measurement): book/paper not obtained.
- https://musicabrasilis.org.br/instruments/cuica: redirect, not fetched.
- cuicaexpandida.wordpress.com: not fetched.
