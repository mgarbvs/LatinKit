# LatinKit

Synthesized Latin percussion for Ableton Live: Max for Live instruments whose sounds are synthesized in Max (gen~) with modal, physical and particle models. Nothing is played back from samples. Many of the models were fitted to recordings of real instruments, so the timbres follow the originals.

## Instruments

| Folder | Instrument | Devices |
|---|---|---|
| `Agogo/` | Agogo bell, High and Low, Open and Mute strokes | `Agogo.amxd` |
| `Bongo/` | Bongo, Macho or Hembra, seven hand strokes | `Bongo.amxd` |
| `Caxixi/` | Woven-basket rattle (PhISEM particle model) | `Caxixi.amxd` |
| `Conga/` | Tumba, conga and quinto, six hand strokes each | `Conga.amxd`, `Conga Voice.amxd` (one drum, for Drum Rack pads) |
| `CR78/` | The Roland CR-78 voice board, modelled from its 1979 service notes | `CR78.amxd`, plus one device per voice |
| `Cuica/` | Friction drum, with MPE pressure | `Cuica.amxd` |
| `Ganza/` | Samba ganzá and chocalho | `Ganza.amxd` |
| `Guiro/` | Güiro and samba reco-reco | `Guiro.amxd` |
| `Pandeiro/` | Pandeiro and tamborim | `Pandeiro.amxd`, `PandeiroMusical.amxd` (the MIDI key sets the pitch) |
| `Repinique/` | Samba repinique | `Repinique.amxd` |
| `Shaker/` | Maraca, cabasa, shekere, ganzá/chocalho and egg shaker (PhISEM) | `Shaker.amxd` |
| `Surdo/` | Samba surdo, Open, Mute, Rim and Finger strokes | `Surdo.amxd`, `SurdoMusical.amxd` |
| `Timbales/` | Timbale built around the cáscara | `Timbales.amxd` |

Each folder's README has the note map, the controls and the notes on how the model was fitted.

## Panels and sounds

Each device as it looks in Live's device view. Each ▶ link plays its demo (MP3) in your browser; GitHub can't play audio inside a README.

<table>
<tr>
<td align="center"><img src="images/agogo.png" width="230" alt="Agogo panel in Live"><br>Agogo · <a href="https://raw.githubusercontent.com/mgarbvs/LatinKit/main/sounds/agogo.mp3">▶ listen</a></td>
<td align="center"><img src="images/bongo.png" width="230" alt="Bongo panel in Live"><br>Bongo · <a href="https://raw.githubusercontent.com/mgarbvs/LatinKit/main/sounds/bongo.mp3">▶ listen</a></td>
</tr>
<tr>
<td align="center"><img src="images/caxixi.png" width="230" alt="Caxixi panel in Live"><br>Caxixi · <a href="https://raw.githubusercontent.com/mgarbvs/LatinKit/main/sounds/caxixi.mp3">▶ listen</a></td>
<td align="center"><img src="images/conga.png" width="365" alt="Conga panel in Live"><br>Conga · <a href="https://raw.githubusercontent.com/mgarbvs/LatinKit/main/sounds/conga.mp3">▶ listen</a></td>
</tr>
<tr>
<td align="center"><img src="images/cuica.png" width="275" alt="Cuica panel in Live"><br>Cuica · <a href="https://raw.githubusercontent.com/mgarbvs/LatinKit/main/sounds/cuica.mp3">▶ listen</a></td>
<td align="center"><img src="images/ganza.png" width="230" alt="Ganzá panel in Live"><br>Ganzá · <a href="https://raw.githubusercontent.com/mgarbvs/LatinKit/main/sounds/ganza.mp3">▶ listen</a></td>
</tr>
<tr>
<td align="center"><img src="images/guiro.png" width="230" alt="Güiro panel in Live"><br>Güiro · <a href="https://raw.githubusercontent.com/mgarbvs/LatinKit/main/sounds/guiro.mp3">▶ listen</a></td>
<td align="center"><img src="images/pandeiro.png" width="230" alt="Pandeiro panel in Live"><br>Pandeiro · <a href="https://raw.githubusercontent.com/mgarbvs/LatinKit/main/sounds/pandeiro.mp3">▶ listen</a></td>
</tr>
<tr>
<td align="center"><img src="images/repinique.png" width="230" alt="Repinique panel in Live"><br>Repinique · <a href="https://raw.githubusercontent.com/mgarbvs/LatinKit/main/sounds/repinique.mp3">▶ listen</a></td>
<td align="center"><img src="images/shaker.png" width="230" alt="Shaker panel in Live"><br>Shaker · <a href="https://raw.githubusercontent.com/mgarbvs/LatinKit/main/sounds/shaker.mp3">▶ listen</a></td>
</tr>
<tr>
<td align="center"><img src="images/surdo.png" width="230" alt="Surdo panel in Live"><br>Surdo · <a href="https://raw.githubusercontent.com/mgarbvs/LatinKit/main/sounds/surdo.mp3">▶ listen</a></td>
<td align="center"><img src="images/timbales.png" width="230" alt="Timbales panel in Live"><br>Timbales · <a href="https://raw.githubusercontent.com/mgarbvs/LatinKit/main/sounds/timbales.mp3">▶ listen</a></td>
</tr>
</table>

The CR78's four pages · <a href="https://raw.githubusercontent.com/mgarbvs/LatinKit/main/sounds/cr78.mp3">▶ listen</a>

<p><img src="images/cr78-drums.png" alt="CR78 Drums page in Live"><br>Drums</p>
<p><img src="images/cr78-latin.png" alt="CR78 Latin page in Live"><br>Latin</p>
<p><img src="images/cr78-noise.png" alt="CR78 Noise page in Live"><br>Noise</p>
<p><img src="images/cr78-perc.png" alt="CR78 Perc page in Live"><br>Perc</p>

## Install

Built and tested in Ableton Live 12 with Max for Live.

1. Copy an instrument's `m4l/` folder anywhere in your User Library. Keep the `.js` files next to the `.amxd`: the device loads them from its own folder.
2. Drag the `.amxd` onto a MIDI track.

To install everything at once, `python3 make_kit.py` copies every device into your User Library and writes a `Latin Kit` Drum Rack preset with the pads mapped from C1 (default `~/Music/Ableton/User Library`; `--dest` for another).

## Building from source

Each device is generated: `scripts/build_maxpat.py` writes `m4l/<Name>.maxpat`, and `build.sh` checks it, runs the tests and packs the `.amxd`. Packing uses a helper (`MaxForLiveTools/build_amxd.py`) that isn't in this repository, which is why the built `.amxd` files are included. The tests that run in standalone Max use maxtest-mcp (set `MAXTEST_DIR` to its folder), and the scripts that fit the models to recordings read Ableton's Latin Percussion pack (set `LP_PACK`).

## License

MIT; see `LICENSE`.
