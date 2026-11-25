# Latin percussion section: what to build (research, 2026-10-29)

Goal: a fully synthesized Latin percussion section as Max for Live instruments.
Already have: **Cuica/** (friction-drum physical model) and Ableton's Drum Synths
(DS Clang, DS Clap, DS Cymbal, DS FM, DS HH, DS Kick, DS Snare, DS Tom).

Web research by a Sonnet subagent; claims are linked to sources. Where a claim is
forum-grade or unverified it says so. **The CR-78 section is superseded by the
primary source:** the Roland service notes (June 1979), which give factory frequencies and decays per voice.

---

## 1. Roland CR-78 (1978)

**Voices.** 14, per [Polynominal](https://www.polynominal.com/roland-cr78/) and
[Roland's history](https://articles.roland.com/cr-78-the-whole-story/); Roland
Cloud's version lists 15 because it adds a clap:
- Kit voices: bass drum, snare, rimshot, hi-hat, cymbal.
- Metallic Beat, a layer that adds to the hat and cymbal.
- Latin voices: maracas, claves, cowbell, high and low bongo, and a single low conga.
- Tambourine and guiro, which have their own "Add Voice" sliders.

**Circuits, from the web (forum-grade).** Sources: [electro-music "Cloning the CR78 with MIDI"](https://electro-music.org/forum/post-419915.html)
and the [Modwiggler thread](https://www.modwiggler.com/forum/viewtopic.php?t=234188).
- Tambourine: noise into an LC resonant filter. One poster quotes "4.38 kHz @ 33 nF // 40 mH"; a builder measured a peak near 4.7 kHz.
- Clave and rimshot: large inductors ("3R" parts), so a pulse pings an LC tank.
- Guiro: a multivibrator that is gated, not one-shot. One control line stops it and a second changes its rate. It has a decay pot.
- Metallic Beat: three square waves into an inductor band-pass around 5.6 kHz.
- Maracas: claimed to be an envelope variant of the hat/cymbal circuit (unconfirmed). [Cherry Audio's CR-78](https://docs.cherryaudio.com/cherry-audio/instruments/cr-78/voice-edit) mentions a "tonal element".
- The service notes confirm or correct all of this.

## 2. Other classic machines

**TR-808.** Per the [service manual](https://www.manualslib.com/manual/1294765/Roland-Tr-808.html?page=6):
- Toms and congas: one bridged-T oscillator design at three tunings. A [blog post](https://baratatronix.squarespace.com/blog/808-tom-synthesis) adds that congas differ mainly in tuning and a little filtered noise.
- Claves and rimshot: one shared bridged-T ping with no noise, per [Sound on Sound, "Synthesizing Cowbells & Claves"](https://www.soundonsound.com/techniques/synthesizing-cowbells-claves).
- Cowbell: two Schmitt-trigger square oscillators, each with its own VCA, mixed and band-passed. The often-quoted 587/845 Hz (ratio 1.44) and the BP near 2.64 kHz come from a CR-8000 reference. The CR-78 uses 800/555 Hz, the same ratio.
- Maracas: gated white noise, filtered.

**TR-727.** A sampled PCM machine, not analog ([Muzines](https://www.muzines.co.uk/articles/its-latin-for-rhythm/12458),
[manual](https://www.manualslib.com/manual/1198633/Roland-Tr-727.html?page=10)).
Its 15 voices are the best checklist of a "Latin machine":
- Bongo hi/lo
- Conga mute/open/low
- Timbale hi/lo
- Agogo hi/lo
- Cabasa, maracas
- Whistle short/long
- Quijada
- Star chime

**Korg KR-55 / Mini Pops (unverified).** The KR-55 has about 10–12 analog voices,
including conga, claves and cowbell ([Cherry Audio KR-55C](https://docs.cherryaudio.com/cherry-audio/instruments/kr-55c/getting-started),
[Synthtopia](https://www.synthtopia.com/content/2013/07/02/the-korg-rhythm-55-rhythm-box/)).
A seller lists the Mini Pops with high and low conga and claves. No source confirmed bongo, guiro or maracas on either.

## 3. What a Latin section contains

Sources: [Groove Monkee Afro-Cuban guide](https://groovemonkee.com/blogs/blog/afro-cuban-percussion-style-guide),
[Paraiso bateria guide](https://paraisosamba.co.uk/about/bateria_instruments.php),
[Wikipedia: Batucada](https://en.wikipedia.org/wiki/Batucada).

**Afro-Cuban / salsa**
- Essential: congas (quinto, conga, tumba), bongos, timbales with cáscara, clave, campana/cowbell.
- Core colour: güiro, maracas.
- Nice to have: shekere (bembé 6/8).

**Brazilian / samba**
- Essential: surdo (up to 3 tunings), caixa, tamborim, repinique, pandeiro, agogô.
- Core colour: ganzá/chocalho, reco-reco (the güiro equivalent), cuíca (built), apito (whistle).

**Extras:** triangle, vibraslap/quijada, tambourine, cabasa, star chimes, whistle.

## 4. What the Ableton DS devices already cover

From the [Live 12 manual](https://www.ableton.com/en/live-manual/12/max-for-live-devices):

| Coverage | Instruments |
|---|---|
| Covered | **DS Clang** is made for cowbell and clave (Tone A/B, a Clave switch with repeats) and does agogo-like bells. **DS Kick** works as a surdo. **DS Tom** (impulse into resonant band-passes with a pitch bend) gives a plain conga or bongo open tone. **DS Snare** works as a caixa. |
| Weak | Timbales (shell ring, rim), triangle, tamborim. |
| Missing | Conga articulations (open, slap, mute, heel-toe); scrapers (güiro, reco-reco, quijada); shakers (maraca, cabasa, shekere, ganzá); tambourine and pandeiro; cáscara and the timbale rimshot; vibraslap; whistle. |

## 5. Synthesis approaches for the hard ones

**PhISEM** (Cook, "Physically Informed Sonic Modeling (PhISM): Synthesis of
Percussive Sounds", *Computer Music Journal* 21(3), 1997; ICMC 1996 preliminary). Check the
exact title against the CMJ table of contents ([Cook's publications](https://www.cs.princeton.edu/~prc/Pubs8-04.txt)).
- Models shakers as stochastic grain collisions whose energy decays exponentially, driving resonant filters.
- Covers maraca, sekere, cabasa, tambourine, sleighbells and guiro: [STK Shakers.h](https://ccrma.stanford.edu/workshops/dsp2008/prc/NotYet/Week2Labs/PRCBookCode/GaitLab/Shakers.h).
- Csound ports to check against: [cabasa](https://csound.com/manual/opcodes/cabasa/), [tambourine](https://csound.com/manual/opcodes/tambourine/), [sekere](https://csound.com/manual/sekere.html).
- The same paper's PhISAM puts parametric control on modal models.

**Modal synthesis** (a parallel bank of decaying resonators) is the standard approach for cowbell, agogo and timbale shells.
- Reference book: Cook, *Real Sound Synthesis for Interactive Applications* (2002).
- Membrane modes follow Bessel-function ratios.
- A [Chalmers thesis](https://odr.chalmers.se/items/afae68a3-f8d8-40ad-a139-b52b34450dd6) compares FDTD, delay-line, modal and mass-spring drums; mass-spring gave the best accuracy for the cost.
- SteelPan/ in this repo is a working modal instrument to reuse.

**Conga articulations.**
- Prior art: the Korg Wavedrum "Bonga" algorithm has open, slap and mute strokes with slap level and decay ([manual](https://www.manualslib.com/manual/691435/Korg-Wavedrum.html?page=22)).
- No dedicated conga-slap or heel-toe paper was found.
- A suggestion, not a published method: a modal bank plus a noise burst, with a damped high mode for the slap.

**Scrapers** (güiro, reco-reco, quijada). A suggestion, not a cited method: a PhISEM-style event train whose rate follows scrape speed, each event ringing a resonator. The CR-78 does this with a gated multivibrator into an LC tank.

---

## Recommended build list

**A. CR-78 / 808-style analog voices** (cheap; DS covers them only partly)
1. Bongo/conga as pinged resonators (bridged-T style).
2. Clave/woodblock as an LC ping. DS Clang overlaps, so this is low priority alone.
3. Tambourine: noise into a tuned LC resonator around 4–5 kHz.
4. Guiro: a gated multivibrator into a resonator.

→ **Decision (2026-10-29): build the full 14-voice CR-78 as one kit device first** (`CR78/`), then split it into separate DS-style devices later.

**B. Physical / gestural models** (the real gaps)
5. **Conga** (quinto/conga/tumba): a modal membrane with open/slap/mute/heel-toe strokes. This is the biggest gap and extends the Cuica work.
6. **PhISEM shaker family:** maraca, cabasa, shekere, ganzá and pandeiro jingles in one engine.
7. **Scraper:** güiro, reco-reco and quijada, with gesture rate.
8. **Timbales** with cáscara: modal shell, rimshot, shell strokes.
9. Pandeiro/tambourine as a head plus a PhISEM jingle layer; this could merge into 6.
10. Surdo/repinique/tamborim for samba only. DS Kick and DS Tom roughly cover surdo and repinique.

**Unverified:** Korg KR-55/Mini Pops voice lists; any published conga-slap model.
