{
	"patcher": {
		"fileversion": 1,
		"appversion": {
			"major": 9,
			"minor": 0,
			"revision": 0,
			"architecture": "x64",
			"modernui": 1
		},
		"classnamespace": "box",
		"rect": [
			60.0,
			60.0,
			1900.0,
			1300.0
		],
		"openrect": [
			0.0,
			0.0,
			180.0,
			169.0
		],
		"openinpresentation": 1,
		"devicewidth": 180.0,
		"default_fontname": "Ableton Sans Medium",
		"default_fontsize": 9.0,
		"gridsize": [
			8.0,
			8.0
		],
		"description": "Ganza: a samba ganza (metal tube of beads) and a chocalho (platinelas) with forward / back / accent strokes, from Perry Cook's PhISEM stochastic particle model, fitted to recordings.",
		"boxes": [
			{
				"box": {
					"id": "pre_tone",
					"maxclass": "newobj",
					"text": "prepend tone",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						230,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "tone",
					"varname": "tone",
					"parameter_enable": 1,
					"annotation_name": "Tone",
					"annotation": "Tone: moves the ganza's resonances and the high-pass up or down, in semitones: a bigger or smaller vessel.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Tone",
							"parameter_shortname": "Tone",
							"parameter_type": 0,
							"parameter_mmin": -12.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.1f st"
						}
					},
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 8.0,
					"presentation": 1,
					"presentation_rect": [
						144.0,
						116.0,
						36.0,
						50.0
					],
					"patching_rect": [
						2140,
						420,
						36,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_rattle",
					"maxclass": "newobj",
					"text": "prepend rattle",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						170,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "sc_rattle",
					"maxclass": "newobj",
					"text": "* 0.01",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						140,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "rattle",
					"varname": "rattle",
					"parameter_enable": 1,
					"annotation_name": "Rattle",
					"annotation": "Rattle: the beads' own damping. Low: dull, each collision a tiny tick. High: each collision rings a little (grains four times longer, like hard beads on a hard shell).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Rattle",
							"parameter_shortname": "Rattle",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								50
							],
							"parameter_unitstyle": 5
						}
					},
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 8.0,
					"presentation": 1,
					"presentation_rect": [
						108.0,
						116.0,
						36.0,
						50.0
					],
					"patching_rect": [
						1870,
						420,
						36,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_shake",
					"maxclass": "newobj",
					"text": "prepend shake",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						80,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "sc_shake",
					"maxclass": "newobj",
					"text": "* 0.01",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						50,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "shake",
					"varname": "shake",
					"parameter_enable": 1,
					"annotation_name": "Shake",
					"annotation": "Shake: the length of the stroke: how long the beads take to build up. Short is a flick, long is a slow sweep of the hand.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Shake",
							"parameter_shortname": "Shake",
							"parameter_type": 0,
							"parameter_mmin": 25.0,
							"parameter_mmax": 400.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								100
							],
							"parameter_unitstyle": 5,
							"parameter_exponent": 2.32
						}
					},
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 8.0,
					"presentation": 1,
					"presentation_rect": [
						72.0,
						116.0,
						36.0,
						50.0
					],
					"patching_rect": [
						1600,
						420,
						36,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_damping",
					"maxclass": "newobj",
					"text": "prepend damp",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						1190,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "sc_damping",
					"maxclass": "newobj",
					"text": "* 0.01",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						1160,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "damping",
					"varname": "damping",
					"parameter_enable": 1,
					"annotation_name": "Damping",
					"annotation": "Damping: how long the shaking energy lasts (PhISEM's system decay). 100 % is the fitted decay; 25 % is a short snap, 400 % a long swish.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Damping",
							"parameter_shortname": "Damping",
							"parameter_type": 0,
							"parameter_mmin": 25.0,
							"parameter_mmax": 400.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								100
							],
							"parameter_unitstyle": 5,
							"parameter_exponent": 2.32
						}
					},
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 8.0,
					"presentation": 1,
					"presentation_rect": [
						36.0,
						116.0,
						36.0,
						50.0
					],
					"patching_rect": [
						2050,
						340,
						36,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_beads",
					"maxclass": "newobj",
					"text": "prepend beads",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						1100,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "sc_beads",
					"maxclass": "newobj",
					"text": "* 0.01",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						1070,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "beads",
					"varname": "beads",
					"parameter_enable": 1,
					"annotation_name": "Beads",
					"annotation": "Beads: how many particles. More beads collide more often: from separate clicks to a smooth hiss. The loudness stays the same. 100 % is the fitted instrument.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Beads",
							"parameter_shortname": "Beads",
							"parameter_type": 0,
							"parameter_mmin": 25.0,
							"parameter_mmax": 400.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								100
							],
							"parameter_unitstyle": 5,
							"parameter_exponent": 2.32
						}
					},
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 8.0,
					"presentation": 1,
					"presentation_rect": [
						0.0,
						116.0,
						36.0,
						50.0
					],
					"patching_rect": [
						1780,
						340,
						36,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_volume",
					"maxclass": "newobj",
					"text": "prepend vol",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						1010,
						77,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_volume",
					"maxclass": "panel",
					"numinlets": 1,
					"numoutlets": 0,
					"mode": 0,
					"border": 1,
					"rounded": 2,
					"bgfillcolor": [
						0,
						0,
						0,
						0
					],
					"bordercolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"saved_attribute_attributes": {
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						116.0,
						82.0,
						44.0,
						12.0
					],
					"patching_rect": [
						1600,
						340,
						44,
						12
					]
				}
			},
			{
				"box": {
					"id": "volume",
					"varname": "volume",
					"parameter_enable": 1,
					"annotation_name": "Level",
					"annotation": "Output level.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Level",
							"parameter_shortname": "Level",
							"parameter_type": 0,
							"parameter_mmin": -36.0,
							"parameter_mmax": 6.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								-6
							],
							"parameter_unitstyle": 4
						}
					},
					"maxclass": "live.numbox",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"appearance": 4,
					"lcdcolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"bordercolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"lcdbgcolor": [
						0,
						0,
						0,
						0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						116.0,
						82.0,
						44.0,
						12.0
					],
					"patching_rect": [
						2230,
						260,
						44,
						12
					]
				}
			},
			{
				"box": {
					"id": "pre_pan",
					"maxclass": "newobj",
					"text": "prepend pan",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						920,
						77,
						22
					]
				}
			},
			{
				"box": {
					"id": "sc_pan",
					"maxclass": "newobj",
					"text": "* 0.01",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						890,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_pan",
					"maxclass": "panel",
					"numinlets": 1,
					"numoutlets": 0,
					"mode": 0,
					"border": 1,
					"rounded": 2,
					"bgfillcolor": [
						0,
						0,
						0,
						0
					],
					"bordercolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"saved_attribute_attributes": {
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						116.0,
						69.0,
						44.0,
						12.0
					],
					"patching_rect": [
						1960,
						260,
						44,
						12
					]
				}
			},
			{
				"box": {
					"id": "pan",
					"varname": "pan",
					"parameter_enable": 1,
					"annotation_name": "Pan",
					"annotation": "Position in the stereo field.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Pan",
							"parameter_shortname": "Pan",
							"parameter_type": 0,
							"parameter_mmin": -100.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+d"
						}
					},
					"maxclass": "live.numbox",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"appearance": 4,
					"lcdcolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"bordercolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"lcdbgcolor": [
						0,
						0,
						0,
						0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						116.0,
						69.0,
						44.0,
						12.0
					],
					"patching_rect": [
						1870,
						260,
						44,
						12
					]
				}
			},
			{
				"box": {
					"id": "pre_direction",
					"maxclass": "newobj",
					"text": "prepend direction",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						800,
						119,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_direction",
					"maxclass": "panel",
					"numinlets": 1,
					"numoutlets": 0,
					"mode": 0,
					"border": 1,
					"rounded": 2,
					"bgfillcolor": [
						0,
						0,
						0,
						0
					],
					"bordercolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"saved_attribute_attributes": {
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						66.0,
						96.0,
						56.0,
						12.0
					],
					"patching_rect": [
						1690,
						260,
						56,
						12
					]
				}
			},
			{
				"box": {
					"id": "direction",
					"varname": "direction",
					"parameter_enable": 1,
					"annotation_name": "Stroke",
					"annotation": "Stroke: which way each stroke goes. Key: by the note, even notes (C3) forward and odd notes (C#3) back. Alternate: every new note flips, forward, back, forward ... (a Roll keeps alternating). Forward / Back: every stroke the same way, for a Drum Rack pad that sends one fixed note. Accent: a forward stroke played harder: louder, with a harder click at the end cap (a Roll's later strokes are plain).",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Stroke",
							"parameter_shortname": "Stroke",
							"parameter_type": 2,
							"parameter_enum": [
								"Key",
								"Alternate",
								"Forward",
								"Back",
								"Accent"
							],
							"parameter_mmax": 4,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							]
						}
					},
					"maxclass": "live.menu",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"",
						"",
						"float"
					],
					"appearance": 1,
					"lcdcolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"lcdbgcolor": [
						0,
						0,
						0,
						0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						66.0,
						94.0,
						56.0,
						12.0
					],
					"patching_rect": [
						1600,
						260,
						56,
						12
					]
				}
			},
			{
				"box": {
					"id": "pre_roll",
					"maxclass": "newobj",
					"text": "prepend roll",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						710,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_roll",
					"maxclass": "panel",
					"numinlets": 1,
					"numoutlets": 0,
					"mode": 0,
					"border": 1,
					"rounded": 2,
					"bgfillcolor": [
						0,
						0,
						0,
						0
					],
					"bordercolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"saved_attribute_attributes": {
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						82.0,
						44.0,
						12.0
					],
					"patching_rect": [
						2140,
						180,
						44,
						12
					]
				}
			},
			{
				"box": {
					"id": "roll",
					"varname": "roll",
					"parameter_enable": 1,
					"annotation_name": "Roll",
					"annotation": "Roll: 0 is off (one stroke per note). Above 0, a held note keeps shaking back and forth, this many strokes per second (a samba ganz\u00e1 plays 16ths: 8 a second at 120 BPM), until you let go.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Roll",
							"parameter_shortname": "Roll",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 16.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.1f Hz"
						}
					},
					"maxclass": "live.numbox",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"appearance": 4,
					"lcdcolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"bordercolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"lcdbgcolor": [
						0,
						0,
						0,
						0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						68.0,
						82.0,
						44.0,
						12.0
					],
					"patching_rect": [
						2050,
						180,
						44,
						12
					]
				}
			},
			{
				"box": {
					"id": "pre_back",
					"maxclass": "newobj",
					"text": "prepend back",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						620,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "sc_back",
					"maxclass": "newobj",
					"text": "* 0.01",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						590,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_back",
					"maxclass": "panel",
					"numinlets": 1,
					"numoutlets": 0,
					"mode": 0,
					"border": 1,
					"rounded": 2,
					"bgfillcolor": [
						0,
						0,
						0,
						0
					],
					"bordercolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"saved_attribute_attributes": {
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						69.0,
						44.0,
						12.0
					],
					"patching_rect": [
						1780,
						180,
						44,
						12
					]
				}
			},
			{
				"box": {
					"id": "back",
					"varname": "back",
					"parameter_enable": 1,
					"annotation_name": "Back",
					"annotation": "Back: how loud the back stroke is, 100 % being the recording (the ganz\u00e1's back stroke is about 5 dB under the forward one, the chocalho's about 9). A back stroke is also rounder: slower to build, a little longer, a little darker (brighter on the chocalho), and has no end-cap click.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Back",
							"parameter_shortname": "Back",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 200.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								100
							],
							"parameter_unitstyle": 5
						}
					},
					"maxclass": "live.numbox",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"appearance": 4,
					"lcdcolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"bordercolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"lcdbgcolor": [
						0,
						0,
						0,
						0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						68.0,
						69.0,
						44.0,
						12.0
					],
					"patching_rect": [
						1690,
						180,
						44,
						12
					]
				}
			},
			{
				"box": {
					"id": "pre_type_view",
					"maxclass": "newobj",
					"text": "prepend type",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						500,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "pre_type",
					"maxclass": "newobj",
					"text": "prepend type",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						470,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "type",
					"varname": "type",
					"parameter_enable": 1,
					"annotation_name": "Type",
					"annotation": "Type: which instrument. Ganz\u00e1: a metal tube of beads (bright, a faint ringing of the tube wall, a hard click where the beads hit the end cap on a forward stroke). Chocalho: a frame of platinelas (jingles): slower, a little darker on the forward stroke, with ringing plates. Each is fitted to recordings.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Type",
							"parameter_shortname": "Type",
							"parameter_type": 2,
							"parameter_enum": [
								"Ganz\u00e1",
								"Chocalho"
							],
							"parameter_mmax": 1,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							]
						}
					},
					"maxclass": "live.menu",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"",
						"",
						"float"
					],
					"appearance": 1,
					"lcdcolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"lcdbgcolor": [
						0,
						0,
						0,
						0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 11.0,
					"presentation": 1,
					"presentation_rect": [
						8.0,
						75.0,
						58.0,
						24.0
					],
					"patching_rect": [
						2140,
						100,
						58,
						24
					]
				}
			},
			{
				"box": {
					"id": "hdr_Out",
					"maxclass": "comment",
					"text": "Out",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.5,
					"textjustification": 1,
					"textcolor": [
						0.6824,
						0.6863,
						0.7137,
						1
					],
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_display_scale_text"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						114.0,
						55.0,
						48.0,
						14.0
					],
					"patching_rect": [
						2050,
						100,
						48,
						14
					]
				}
			},
			{
				"box": {
					"id": "hdr_Stroke",
					"maxclass": "comment",
					"text": "Stroke",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.5,
					"textjustification": 1,
					"textcolor": [
						0.6824,
						0.6863,
						0.7137,
						1
					],
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_display_scale_text"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						66.0,
						55.0,
						48.0,
						14.0
					],
					"patching_rect": [
						1960,
						100,
						48,
						14
					]
				}
			},
			{
				"box": {
					"id": "hdr_Type",
					"maxclass": "comment",
					"text": "Type",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.5,
					"textjustification": 1,
					"textcolor": [
						0.6824,
						0.6863,
						0.7137,
						1
					],
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_display_scale_text"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						6.0,
						55.0,
						62.0,
						14.0
					],
					"patching_rect": [
						1870,
						100,
						62,
						14
					]
				}
			},
			{
				"box": {
					"id": "msg_colors",
					"maxclass": "message",
					"text": "everything",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						300,
						570,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "colors",
					"maxclass": "newobj",
					"text": "live.colors",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						20,
						320,
						77,
						22
					]
				}
			},
			{
				"box": {
					"id": "pk_state",
					"maxclass": "newobj",
					"text": "prepend view_state",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1680.0,
						110.0,
						170,
						22
					]
				}
			},
			{
				"box": {
					"id": "pk_obj",
					"maxclass": "newobj",
					"text": "live.object",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1860.0,
						80.0,
						170,
						22
					]
				}
			},
			{
				"box": {
					"id": "pk_obs",
					"maxclass": "newobj",
					"text": "live.observer",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						1680.0,
						80.0,
						170,
						22
					]
				}
			},
			{
				"box": {
					"id": "pk_push",
					"maxclass": "newobj",
					"text": "live.push",
					"numinlets": 1,
					"numoutlets": 0,
					"outlettype": [],
					"patching_rect": [
						1500.0,
						130.0,
						170,
						22
					]
				}
			},
			{
				"box": {
					"id": "pk_js",
					"maxclass": "newobj",
					"text": "js ganza_push.js",
					"numinlets": 1,
					"numoutlets": 4,
					"outlettype": [
						"",
						"",
						"",
						""
					],
					"patching_rect": [
						1500.0,
						40.0,
						170,
						22
					]
				}
			},
			{
				"box": {
					"id": "view",
					"varname": "view",
					"maxclass": "jsui",
					"numinlets": 1,
					"numoutlets": 0,
					"filename": "ganza_view.js",
					"border": 0,
					"parameter_enable": 0,
					"annotation_name": "Ganza",
					"annotation": "The ganza: the last note, and a flash and a jerk with every stroke.",
					"presentation": 1,
					"presentation_rect": [
						8.0,
						8.0,
						164.0,
						48.0
					],
					"patching_rect": [
						1690,
						100,
						164,
						48
					]
				}
			},
			{
				"box": {
					"id": "note_pack",
					"maxclass": "newobj",
					"text": "pack 0 0",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						260,
						56,
						22
					]
				}
			},
			{
				"box": {
					"id": "notein",
					"maxclass": "newobj",
					"text": "notein",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"int",
						"int",
						"int"
					],
					"patching_rect": [
						20,
						230,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "midi",
					"maxclass": "newobj",
					"text": "js ganza_midi.js",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						20,
						200,
						112,
						22
					]
				}
			},
			{
				"box": {
					"id": "plugout",
					"maxclass": "newobj",
					"text": "plugout~",
					"numinlets": 2,
					"numoutlets": 0,
					"outlettype": [],
					"patching_rect": [
						20,
						170,
						56,
						22
					]
				}
			},
			{
				"box": {
					"id": "engine",
					"maxclass": "newobj",
					"text": "gen~",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"signal",
						"signal"
					],
					"patching_rect": [
						20,
						140,
						40,
						22
					],
					"patcher": {
						"fileversion": 1,
						"appversion": {
							"major": 9,
							"minor": 0,
							"revision": 0,
							"architecture": "x64",
							"modernui": 1
						},
						"classnamespace": "dsp.gen",
						"rect": [
							100.0,
							100.0,
							900.0,
							900.0
						],
						"boxes": [
							{
								"box": {
									"id": "code",
									"maxclass": "codebox",
									"code": "// Ganza engine. GENERATED by scripts/ganza_engine.py: do not edit.\nParam type(0.0);\nParam beads(1.0);\nParam damp(1.0);\nParam shake(1.0);\nParam tone(0.0);\nParam rattle(0.5);\nParam back(1.0);\nParam vol(-6.0);\nParam pan(0.0);\nParam tr(0.0);\nParam vl(0.0);\nParam dir(0.0);\nParam acc(0.0);\nHistory ltr(0);\nHistory y1(0);\nHistory y2(0);\nHistory en(0);\nHistory ens(0);\nHistory snd(0);\nHistory ck(0);\nHistory dirs(0);\nHistory accs(0);\nHistory hx1(0);\nHistory hx2(0);\nHistory hz1(0);\nHistory hz2(0);\nHistory jx1(0);\nHistory jx2(0);\nHistory jz1(0);\nHistory jz2(0);\nHistory r0x1(0);\nHistory r0x2(0);\nHistory r0z1(0);\nHistory r0z2(0);\nHistory r1x1(0);\nHistory r1x2(0);\nHistory r1z1(0);\nHistory r1z2(0);\nHistory r2x1(0);\nHistory r2x2(0);\nHistory r2z1(0);\nHistory r2z2(0);\nHistory m0x1(0);\nHistory m0x2(0);\nHistory m0z1(0);\nHistory m0z2(0);\nHistory m1x1(0);\nHistory m1x2(0);\nHistory m1z1(0);\nHistory m1z2(0);\nt0 = abs(type - 0) < 0.5;\nt1 = abs(type - 1) < 0.5;\n\nnewn = tr != ltr;\nltr = tr;\nisb = dir > 0.5;\ndirs = newn * isb + (1 - newn) * dirs;\naccs = newn * (acc > 0.5) + (1 - newn) * accs;\namp = vl * newn * (isb * back * (t0 * 0.62 + t1 * 0.466) + (1 - isb)) * (1 + (acc > 0.5) * 0.6);\nmsr = samplerate * 0.001;\nts = (t0 * 9.885 + t1 * 24.68) * damp * (1 + (t0 * 0.7 + t1 * 0.38) * dirs) * msr;\nash = (t0 * 12.83 + t1 * 14.91) * shake * (1 + (t0 * 0.25 + t1 * 0.42) * dirs) * msr;\ndE = exp(-1 / ts);\nca = 1 - exp(-1 / ash);\ny1 = y1 + ca * (amp * (1 + 2.7 * ash / ts) - y1);\ny2 = y2 + ca * (y1 - y2);\nen = fixdenorm(en * dE + y2);\nen = en * (en > 0.000000001);\n// the slow tail: a second, slower energy store fed by the same stroke (gs: its share of the peak energy, ss: its decay in ms)\ndS = exp(-1 / ((t0 * 150.0 + t1 * 156.2) * damp * msr));\nens = fixdenorm(ens * dS + (t0 * 0.3 + t1 * 0.1845) * y2 * ts / ((t0 * 150.0 + t1 * 156.2) * damp * msr));\nens = ens * (ens > 0.000001);\net = en + ens;\n\n// collisions: the beads strike at random, more often the more energy there is\nrt = (t0 * 16560.0 + t1 * 2294.0) * beads;\nsp = (t0 * 0.57 + t1 * 0.3831);\npe = et * (et < 1) + (et >= 1);\np = rt / samplerate * (1 - sp + sp * pe);\nhit = abs(noise()) < p;\ngl = (t0 * 1.339 + t1 * 3.501) * pow(4, (rattle - 0.5) * 2);\nsd = exp(-1 / (gl * msr));\ngx = rt * gl * 0.001;\ngr = (t0 * 0.8097 + t1 * 0.29) / sqrt(0.36 * gx * gx + 0.2067 * gx);\nsnd = fixdenorm(snd * sd + hit * et * gr * (0.2 + 0.8 * abs(noise())));\nsnd = snd * (snd > 0.000000001);\n// the end-cap impact: a forward stroke's beads hit the cap (a back stroke's do not): a click of vel x clk, harder on an accent\nck = fixdenorm(ck * exp(-1 / ((t0 * 1.5 + t1 * 1.5) * msr)) + newn * (1 - isb) * vl * (t0 * 1.5 + t1 * 0.0) * (t0 * 0.8097 + t1 * 0.29) * (1 + (acc > 0.5) * 1.5));\nck = ck * (ck > 0.000000001);\nraw = (snd + ck) * noise();\n\n// the 4th-order high-pass, then three band-pass resonances (RBJ, constant 0 dB peak), shifted together by Tone (a back stroke's bkt more)\nks = pow(2, (tone + dirs * (t0 * -1.2 + t1 * 1.3)) / 12);\nfmx = 0.42 * samplerate;\nfh = (t0 * 315.8 + t1 * 849.6) * ks;\nfh = fh / pow(1 + pow(fh / fmx, 4), 0.25);\nwh = twopi * fh / samplerate;\nalh = sin(wh) / (2 * (t0 * 0.4129 + t1 * 0.4));\niah = 1 / (1 + alh);\nchh = cos(wh);\nhb = (1 + chh) * 0.5 * iah;\nh1 = hb * (raw - 2 * hx1 + hx2) + 2 * chh * iah * hz1 - (1 - alh) * iah * hz2;\nhx2 = hx1;\nhx1 = raw;\nhz2 = fixdenorm(hz1);\nhz1 = fixdenorm(h1);\ninp = hb * (h1 - 2 * jx1 + jx2) + 2 * chh * iah * jz1 - (1 - alh) * iah * jz2;\njx2 = jx1;\njx1 = h1;\njz2 = fixdenorm(jz1);\njz1 = fixdenorm(inp);\nac0 = 0;\nfr0 = (t0 * 10000.0 + t1 * 5381.0) * ks;\nfr0 = fr0 / pow(1 + pow(fr0 / fmx, 4), 0.25);\nw0 = twopi * fr0 / samplerate;\nal0 = sin(w0) / (2 * (t0 * 1.767 + t1 * 3.0));\nia0 = 1 / (1 + al0);\nb0 = al0 * ia0;\nc10 = -2 * cos(w0) * ia0;\nc20 = (1 - al0) * ia0;\nyy0 = b0 * (inp - r0x2) - c10 * r0z1 - c20 * r0z2;\nr0x2 = r0x1;\nr0x1 = inp;\nr0z2 = fixdenorm(r0z1);\nr0z1 = fixdenorm(yy0);\nac0 = ac0 + yy0 * (t0 * 0.02217 + t1 * 2.272);\nfr1 = (t0 * 10000.0 + t1 * 10000.0) * ks;\nfr1 = fr1 / pow(1 + pow(fr1 / fmx, 4), 0.25);\nw1 = twopi * fr1 / samplerate;\nal1 = sin(w1) / (2 * (t0 * 1.678 + t1 * 0.407));\nia1 = 1 / (1 + al1);\nb1 = al1 * ia1;\nc11 = -2 * cos(w1) * ia1;\nc21 = (1 - al1) * ia1;\nyy1 = b1 * (inp - r1x2) - c11 * r1z1 - c21 * r1z2;\nr1x2 = r1x1;\nr1x1 = inp;\nr1z2 = fixdenorm(r1z1);\nr1z1 = fixdenorm(yy1);\nac0 = ac0 + yy1 * (t0 * 0.9914 + t1 * 0.6238);\nfr2 = (t0 * 1918.0 + t1 * 9361.0) * ks;\nfr2 = fr2 / pow(1 + pow(fr2 / fmx, 4), 0.25);\nw2 = twopi * fr2 / samplerate;\nal2 = sin(w2) / (2 * (t0 * 0.7916 + t1 * 3.0));\nia2 = 1 / (1 + al2);\nb2 = al2 * ia2;\nc12 = -2 * cos(w2) * ia2;\nc22 = (1 - al2) * ia2;\nyy2 = b2 * (inp - r2x2) - c12 * r2z1 - c22 * r2z2;\nr2x2 = r2x1;\nr2x1 = inp;\nr2z2 = fixdenorm(r2z1);\nr2z1 = fixdenorm(yy2);\nac0 = ac0 + yy2 * (t0 * 0.08463 + t1 * 1.703);\nmw0 = twopi * (t0 * 4460.0 + t1 * 4230.0) / samplerate;\nmal0 = sin(mw0) / (2 * (t0 * 40.0 + t1 * 40.0));\nmia0 = 1 / (1 + mal0);\nmb0 = mal0 * mia0;\nmc10 = -2 * cos(mw0) * mia0;\nmc20 = (1 - mal0) * mia0;\nmy0 = mb0 * (inp - m0x2) - mc10 * m0z1 - mc20 * m0z2;\nm0x2 = m0x1;\nm0x1 = inp;\nm0z2 = fixdenorm(m0z1);\nm0z1 = fixdenorm(my0);\nac0 = ac0 + my0 * (t0 * 0.35 + t1 * 2.8);\nmw1 = twopi * (t0 * 8960.0 + t1 * 5860.0) / samplerate;\nmal1 = sin(mw1) / (2 * (t0 * 40.0 + t1 * 40.0));\nmia1 = 1 / (1 + mal1);\nmb1 = mal1 * mia1;\nmc11 = -2 * cos(mw1) * mia1;\nmc21 = (1 - mal1) * mia1;\nmy1 = mb1 * (inp - m1x2) - mc11 * m1z1 - mc21 * m1z2;\nm1x2 = m1x1;\nm1x1 = inp;\nm1z2 = fixdenorm(m1z1);\nm1z1 = fixdenorm(my1);\nac0 = ac0 + my1 * (t0 * 0.5 + t1 * 2.2);\n\nac0 = ac0 * dbtoa(vol);\npa = (pan + 1) * 0.25 * pi;\nout1 = clamp(ac0 * cos(pa), -1, 1);\nout2 = clamp(ac0 * sin(pa), -1, 1);\n",
									"fontface": 0,
									"fontname": "<Monospaced>",
									"fontsize": 11.0,
									"numinlets": 1,
									"numoutlets": 2,
									"outlettype": [
										"",
										""
									],
									"patching_rect": [
										20.0,
										60.0,
										850.0,
										800.0
									]
								}
							},
							{
								"box": {
									"id": "in1",
									"maxclass": "newobj",
									"text": "in 1",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										20.0,
										20.0,
										40.0,
										22.0
									]
								}
							},
							{
								"box": {
									"id": "out1",
									"maxclass": "newobj",
									"text": "out 1",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										90.0,
										870.0,
										40.0,
										22.0
									]
								}
							},
							{
								"box": {
									"id": "out2",
									"maxclass": "newobj",
									"text": "out 2",
									"numinlets": 1,
									"numoutlets": 0,
									"patching_rect": [
										160.0,
										870.0,
										40.0,
										22.0
									]
								}
							}
						],
						"lines": [
							{
								"patchline": {
									"source": [
										"in1",
										0
									],
									"destination": [
										"code",
										0
									]
								}
							},
							{
								"patchline": {
									"source": [
										"code",
										0
									],
									"destination": [
										"out1",
										0
									]
								}
							},
							{
								"patchline": {
									"source": [
										"code",
										1
									],
									"destination": [
										"out2",
										0
									]
								}
							}
						]
					}
				}
			},
			{
				"box": {
					"id": "load",
					"maxclass": "newobj",
					"text": "t b",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						110,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "thisdev",
					"maxclass": "newobj",
					"text": "live.thisdevice",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"bang",
						"int",
						"int"
					],
					"patching_rect": [
						20,
						80,
						105,
						22
					]
				}
			},
			{
				"box": {
					"id": "lcd",
					"maxclass": "panel",
					"numinlets": 1,
					"numoutlets": 0,
					"mode": 0,
					"border": 0,
					"rounded": 8,
					"bgfillcolor": [
						0.1098,
						0.1216,
						0.1569,
						1
					],
					"saved_attribute_attributes": {
						"bgfillcolor": {
							"expression": "themecolor.live_lcd_bg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						4.0,
						4.0,
						172.0,
						108.0
					],
					"patching_rect": [
						1690,
						20,
						172,
						108
					]
				}
			}
		],
		"lines": [
			{
				"patchline": {
					"source": [
						"thisdev",
						0
					],
					"destination": [
						"load",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"engine",
						0
					],
					"destination": [
						"plugout",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"engine",
						1
					],
					"destination": [
						"plugout",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"midi",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"notein",
						0
					],
					"destination": [
						"note_pack",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"notein",
						1
					],
					"destination": [
						"note_pack",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"note_pack",
						0
					],
					"destination": [
						"midi",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"midi",
						1
					],
					"destination": [
						"view",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pk_js",
						0
					],
					"destination": [
						"pk_push",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pk_js",
						1
					],
					"destination": [
						"pk_obs",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pk_js",
						2
					],
					"destination": [
						"pk_obs",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pk_js",
						1
					],
					"destination": [
						"pk_obj",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pk_js",
						3
					],
					"destination": [
						"pk_obj",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pk_obs",
						0
					],
					"destination": [
						"pk_state",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pk_state",
						0
					],
					"destination": [
						"pk_js",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"thisdev",
						0
					],
					"destination": [
						"pk_js",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"midi",
						1
					],
					"destination": [
						"pk_js",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"load",
						0
					],
					"destination": [
						"msg_colors",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_colors",
						0
					],
					"destination": [
						"colors",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"colors",
						0
					],
					"destination": [
						"view",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"colors",
						1
					],
					"destination": [
						"msg_colors",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"type",
						0
					],
					"destination": [
						"pre_type",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_type",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"type",
						0
					],
					"destination": [
						"pre_type_view",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_type_view",
						0
					],
					"destination": [
						"view",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"load",
						0
					],
					"destination": [
						"type",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"back",
						0
					],
					"destination": [
						"sc_back",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sc_back",
						0
					],
					"destination": [
						"pre_back",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_back",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"load",
						0
					],
					"destination": [
						"back",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"roll",
						0
					],
					"destination": [
						"pre_roll",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_roll",
						0
					],
					"destination": [
						"midi",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"load",
						0
					],
					"destination": [
						"roll",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"direction",
						0
					],
					"destination": [
						"pre_direction",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_direction",
						0
					],
					"destination": [
						"midi",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"load",
						0
					],
					"destination": [
						"direction",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pan",
						0
					],
					"destination": [
						"sc_pan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sc_pan",
						0
					],
					"destination": [
						"pre_pan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_pan",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"load",
						0
					],
					"destination": [
						"pan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"volume",
						0
					],
					"destination": [
						"pre_volume",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_volume",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"load",
						0
					],
					"destination": [
						"volume",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"beads",
						0
					],
					"destination": [
						"sc_beads",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sc_beads",
						0
					],
					"destination": [
						"pre_beads",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_beads",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"load",
						0
					],
					"destination": [
						"beads",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"damping",
						0
					],
					"destination": [
						"sc_damping",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sc_damping",
						0
					],
					"destination": [
						"pre_damping",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_damping",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"load",
						0
					],
					"destination": [
						"damping",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"shake",
						0
					],
					"destination": [
						"sc_shake",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sc_shake",
						0
					],
					"destination": [
						"pre_shake",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_shake",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"load",
						0
					],
					"destination": [
						"shake",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rattle",
						0
					],
					"destination": [
						"sc_rattle",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sc_rattle",
						0
					],
					"destination": [
						"pre_rattle",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_rattle",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"load",
						0
					],
					"destination": [
						"rattle",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"tone",
						0
					],
					"destination": [
						"pre_tone",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_tone",
						0
					],
					"destination": [
						"engine",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"load",
						0
					],
					"destination": [
						"tone",
						0
					]
				}
			}
		],
		"dependency_cache": [],
		"autosave": 0,
		"parameters": {
			"type": [
				"Type",
				"Type",
				0
			],
			"back": [
				"Back",
				"Back",
				0
			],
			"roll": [
				"Roll",
				"Roll",
				0
			],
			"direction": [
				"Stroke",
				"Stroke",
				0
			],
			"pan": [
				"Pan",
				"Pan",
				0
			],
			"volume": [
				"Level",
				"Level",
				0
			],
			"beads": [
				"Beads",
				"Beads",
				0
			],
			"damping": [
				"Damping",
				"Damping",
				0
			],
			"shake": [
				"Shake",
				"Shake",
				0
			],
			"rattle": [
				"Rattle",
				"Rattle",
				0
			],
			"tone": [
				"Tone",
				"Tone",
				0
			],
			"parameterbanks": {
				"0": {
					"index": 0,
					"name": "Shake",
					"buttons": [
						"-",
						"-",
						"-",
						"-",
						"-",
						"-",
						"-",
						"-"
					],
					"parameters": [
						"Type",
						"Stroke",
						"Back",
						"Beads",
						"Damping",
						"Shake",
						"Rattle",
						"Tone"
					]
				},
				"1": {
					"index": 1,
					"name": "Out",
					"buttons": [
						"-",
						"-",
						"-",
						"-",
						"-",
						"-",
						"-",
						"-"
					],
					"parameters": [
						"Roll",
						"Level",
						"Pan",
						"-",
						"-",
						"-",
						"-",
						"-"
					]
				}
			},
			"inherited_shortname": 1
		},
		"project": {
			"version": 1,
			"creationdate": 3871731238,
			"modificationdate": 3871731238,
			"viewrect": [
				0.0,
				0.0,
				300.0,
				500.0
			],
			"autoorganize": 1,
			"hideprojectwindow": 1,
			"showdependencies": 1,
			"autolocalize": 0,
			"contents": {
				"patchers": {}
			},
			"layout": {},
			"searchpath": {},
			"detailsvisible": 0,
			"amxdtype": 1768515945,
			"readonly": 0,
			"devpathtype": 0,
			"devpath": ".",
			"sortmode": 0,
			"viewmode": 0,
			"includepackages": 0
		}
	}
}