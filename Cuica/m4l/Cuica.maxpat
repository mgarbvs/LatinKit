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
			216.0,
			169.0
		],
		"openinpresentation": 1,
		"is_mpe": 1,
		"devicewidth": 216.0,
		"default_fontname": "Ableton Sans Medium",
		"default_fontsize": 9.0,
		"gridsize": [
			8.0,
			8.0
		],
		"description": "Cuica: a Brazilian friction drum (bowed rod and membrane) with strokes, pull, scoop and a thumb on the mod wheel.",
		"boxes": [
			{
				"box": {
					"id": "mw_pre",
					"maxclass": "newobj",
					"text": "prepend mwheel",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						1040,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "mw_route",
					"maxclass": "newobj",
					"text": "route mw",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						280,
						1010,
						56,
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
					"text": "js cuica_push.js",
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
					"id": "pre_volume",
					"maxclass": "newobj",
					"text": "prepend vol",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						980,
						77,
						22
					]
				}
			},
			{
				"box": {
					"id": "volume",
					"varname": "volume",
					"parameter_enable": 1,
					"annotation_name": "Volume",
					"annotation": "Output level.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Volume",
							"parameter_shortname": "Volume",
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
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"presentation": 1,
					"presentation_rect": [
						180.0,
						116.0,
						36.0,
						50.0
					],
					"patching_rect": [
						2230,
						660,
						36,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_decay",
					"maxclass": "newobj",
					"text": "prepend decay",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						920,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "decay",
					"varname": "decay",
					"parameter_enable": 1,
					"annotation_name": "Decay",
					"annotation": "How long the head rings on after the rub (time to fade by 60 dB).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Decay",
							"parameter_shortname": "Decay",
							"parameter_type": 0,
							"parameter_mmin": 10.0,
							"parameter_mmax": 2000.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								400
							],
							"parameter_unitstyle": 2,
							"parameter_exponent": 2.0
						}
					},
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"presentation": 1,
					"presentation_rect": [
						144.0,
						116.0,
						36.0,
						50.0
					],
					"patching_rect": [
						2050,
						660,
						36,
						50
					]
				}
			},
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
						860,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "sc_tone",
					"maxclass": "newobj",
					"text": "* 0.01",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						830,
						42,
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
					"annotation": "Brightness: how much of the rod's overtones get through the head.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Tone",
							"parameter_shortname": "Tone",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								60
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
					"presentation": 1,
					"presentation_rect": [
						108.0,
						116.0,
						36.0,
						50.0
					],
					"patching_rect": [
						1780,
						660,
						36,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_rasp",
					"maxclass": "newobj",
					"text": "prepend rasp",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						770,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "sc_rasp",
					"maxclass": "newobj",
					"text": "* 0.01",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						740,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "rasp",
					"varname": "rasp",
					"parameter_enable": 1,
					"annotation_name": "Rasp",
					"annotation": "The damp cloth on the rod: its scrape, and how wild the rub gets: more of the head joins in, so slow or hard-gripped strokes creak and break up sooner.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Rasp",
							"parameter_shortname": "Rasp",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								25
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
					"presentation": 1,
					"presentation_rect": [
						72.0,
						116.0,
						36.0,
						50.0
					],
					"patching_rect": [
						2230,
						580,
						36,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_head",
					"maxclass": "newobj",
					"text": "prepend head",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						680,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "sc_head",
					"maxclass": "newobj",
					"text": "* 0.01",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						650,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "head",
					"varname": "head",
					"parameter_enable": 1,
					"annotation_name": "Head",
					"annotation": "The head's tension: its own resonance, from 250 Hz to 1 kHz. Notes at or above it sing almost pure; notes below it grunt, their low overtones lifted by the head.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Head",
							"parameter_shortname": "Head",
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
					"presentation": 1,
					"presentation_rect": [
						36.0,
						116.0,
						36.0,
						50.0
					],
					"patching_rect": [
						1960,
						580,
						36,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_glide",
					"maxclass": "newobj",
					"text": "prepend glide",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						590,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "glide",
					"varname": "glide",
					"parameter_enable": 1,
					"annotation_name": "Glide",
					"annotation": "How long pitch changes take to settle: the mod wheel and legato notes.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Glide",
							"parameter_shortname": "Glide",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 500.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								60
							],
							"parameter_unitstyle": 2,
							"parameter_exponent": 2.0
						}
					},
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"presentation": 1,
					"presentation_rect": [
						0.0,
						116.0,
						36.0,
						50.0
					],
					"patching_rect": [
						1780,
						580,
						36,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_scoop",
					"maxclass": "newobj",
					"text": "prepend scoop",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						530,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_scoop",
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
						160.0,
						93.0,
						44.0,
						13.0
					],
					"patching_rect": [
						1600,
						580,
						44,
						13
					]
				}
			},
			{
				"box": {
					"id": "scoop",
					"varname": "scoop",
					"parameter_enable": 1,
					"annotation_name": "Scoop",
					"annotation": "Scoop: a new note starts this far from its pitch and rides the stroke into it, the cuica's squeak (a little different every stroke).",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Scoop",
							"parameter_shortname": "Scoop",
							"parameter_type": 0,
							"parameter_mmin": -12.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								-4
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%d st"
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
					"lcdbgcolor": [
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
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						160.0,
						93.0,
						44.0,
						13.0
					],
					"patching_rect": [
						2230,
						500,
						44,
						13
					]
				}
			},
			{
				"box": {
					"id": "pre_thumb",
					"maxclass": "newobj",
					"text": "prepend thumb",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						440,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_thumb",
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
						160.0,
						77.0,
						44.0,
						13.0
					],
					"patching_rect": [
						2050,
						500,
						44,
						13
					]
				}
			},
			{
				"box": {
					"id": "thumb",
					"varname": "thumb",
					"parameter_enable": 1,
					"annotation_name": "Thumb",
					"annotation": "Thumb: how far the mod wheel raises the pitch: pressing the head with the thumb gives the cuica its laugh and cry.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Thumb",
							"parameter_shortname": "Thumb",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 24.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								12
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%d st"
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
					"lcdbgcolor": [
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
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						160.0,
						77.0,
						44.0,
						13.0
					],
					"patching_rect": [
						1960,
						500,
						44,
						13
					]
				}
			},
			{
				"box": {
					"id": "pre_pull",
					"maxclass": "newobj",
					"text": "prepend pull",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						350,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_pull",
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
						112.0,
						93.0,
						17.0,
						13.0
					],
					"patching_rect": [
						1780,
						500,
						17,
						13
					]
				}
			},
			{
				"box": {
					"id": "pull",
					"varname": "pull",
					"parameter_enable": 1,
					"annotation_name": "Pull",
					"annotation": "Pull: how many semitones higher a pull is (it is also a little louder). Alt decides which notes are pulls.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Pull",
							"parameter_shortname": "Pull",
							"parameter_type": 0,
							"parameter_mmin": -7.0,
							"parameter_mmax": 7.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								2
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
					"lcdbgcolor": [
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
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						112.0,
						93.0,
						17.0,
						13.0
					],
					"patching_rect": [
						1690,
						500,
						17,
						13
					]
				}
			},
			{
				"box": {
					"id": "pre_stroke",
					"maxclass": "newobj",
					"text": "prepend stroke",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						260,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_stroke",
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
						112.0,
						77.0,
						44.0,
						13.0
					],
					"patching_rect": [
						2230,
						420,
						44,
						13
					]
				}
			},
			{
				"box": {
					"id": "stroke",
					"varname": "stroke",
					"parameter_enable": 1,
					"annotation_name": "Stroke",
					"annotation": "Stroke: length of one rub, push or pull. Every note is one stroke, however long it is held; with MPE, pressure keeps rubbing.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Stroke",
							"parameter_shortname": "Stroke",
							"parameter_type": 0,
							"parameter_mmin": 40.0,
							"parameter_mmax": 800.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								300
							],
							"parameter_unitstyle": 2,
							"parameter_exponent": 2.0
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
					"lcdbgcolor": [
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
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						112.0,
						77.0,
						44.0,
						13.0
					],
					"patching_rect": [
						2140,
						420,
						44,
						13
					]
				}
			},
			{
				"box": {
					"id": "pre_speed",
					"maxclass": "newobj",
					"text": "prepend speed",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						170,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "sc_speed",
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
					"id": "ol_speed",
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
						64.0,
						93.0,
						44.0,
						13.0
					],
					"patching_rect": [
						1870,
						420,
						44,
						13
					]
				}
			},
			{
				"box": {
					"id": "speed",
					"varname": "speed",
					"parameter_enable": 1,
					"annotation_name": "Speed",
					"annotation": "Speed: how fast the hand rubs: louder and brighter. MIDI velocity scales it too.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Speed",
							"parameter_shortname": "Speed",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								60
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
					"lcdbgcolor": [
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
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						64.0,
						93.0,
						44.0,
						13.0
					],
					"patching_rect": [
						1780,
						420,
						44,
						13
					]
				}
			},
			{
				"box": {
					"id": "pre_pressure",
					"maxclass": "newobj",
					"text": "prepend press",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						50,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "sc_pressure",
					"maxclass": "newobj",
					"text": "* 0.01",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						20,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_pressure",
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
						64.0,
						77.0,
						44.0,
						13.0
					],
					"patching_rect": [
						2230,
						340,
						44,
						13
					]
				}
			},
			{
				"box": {
					"id": "pressure",
					"varname": "pressure",
					"parameter_enable": 1,
					"annotation_name": "Pressure",
					"annotation": "Pressure: how hard the cloth grips the rod. As on a real cuica, gripping harder lowers the note (in tune up to the default, about 35 cents flatter at full) and makes a slow rub creak and break up.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Pressure",
							"parameter_shortname": "Pressure",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								55
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
					"lcdbgcolor": [
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
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						64.0,
						77.0,
						44.0,
						13.0
					],
					"patching_rect": [
						2140,
						340,
						44,
						13
					]
				}
			},
			{
				"box": {
					"id": "pre_tune",
					"maxclass": "newobj",
					"text": "prepend tune",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						1130,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "tune",
					"varname": "tune",
					"parameter_enable": 1,
					"annotation_name": "Tune",
					"annotation": "Transposes the notes, in semitones.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Tune",
							"parameter_shortname": "Tune",
							"parameter_type": 1,
							"parameter_mmin": -24.0,
							"parameter_mmax": 24.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0
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
					"lcdbgcolor": [
						0,
						0,
						0,
						0
					],
					"bordercolor": [
						0,
						0,
						0,
						0
					],
					"fontname": "Ableton Sans Medium",
					"fontsize": 20.0,
					"presentation": 1,
					"presentation_rect": [
						8.0,
						78.0,
						48.0,
						24.0
					],
					"patching_rect": [
						1960,
						340,
						48,
						24
					]
				}
			},
			{
				"box": {
					"id": "unit_tune",
					"maxclass": "comment",
					"text": "st",
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
						100.0,
						52.0,
						14.0
					],
					"patching_rect": [
						1870,
						340,
						52,
						14
					]
				}
			},
			{
				"box": {
					"id": "hdr_Thumb",
					"maxclass": "comment",
					"text": "Thumb",
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
						158.0,
						62.0,
						48.0,
						14.0
					],
					"patching_rect": [
						1780,
						340,
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
						110.0,
						62.0,
						48.0,
						14.0
					],
					"patching_rect": [
						1690,
						340,
						48,
						14
					]
				}
			},
			{
				"box": {
					"id": "hdr_Rub",
					"maxclass": "comment",
					"text": "Rub",
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
						62.0,
						62.0,
						48.0,
						14.0
					],
					"patching_rect": [
						1600,
						340,
						48,
						14
					]
				}
			},
			{
				"box": {
					"id": "hdr_Tune",
					"maxclass": "comment",
					"text": "Tune",
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
						62.0,
						52.0,
						14.0
					],
					"patching_rect": [
						2230,
						260,
						52,
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
						920,
						77,
						22
					]
				}
			},
			{
				"box": {
					"id": "page",
					"maxclass": "newobj",
					"text": "js cuica_page.js mpe_on lbl_mpe_on ol_mpe_bend mpe_bend lbl_mpe_bend ol_mpe_press mpe_press lbl_mpe_press ol_mpe_slide mpe_slide lbl_mpe_slide",
					"numinlets": 1,
					"numoutlets": 0,
					"outlettype": [],
					"patching_rect": [
						20,
						890,
						994,
						22
					]
				}
			},
			{
				"box": {
					"id": "pre_alt",
					"maxclass": "newobj",
					"text": "prepend alt",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						860,
						77,
						22
					]
				}
			},
			{
				"box": {
					"id": "alt",
					"varname": "alt",
					"maxclass": "live.menu",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"",
						"",
						"float"
					],
					"parameter_enable": 1,
					"appearance": 1,
					"lcdcolor": [
						0,
						0,
						0,
						0
					],
					"lcdbgcolor": [
						0,
						0,
						0,
						0
					],
					"inactivelcdcolor": [
						0,
						0,
						0,
						0
					],
					"annotation_name": "Alt",
					"annotation": "Alt: push and pull, like the hand going back and forth on the rod (the pull is Pull semitones higher, a little louder). Auto: quick notes (within one Stroke of the last) alternate, and after a pause the next note is a push again. On: every other note is a pull. Off: every note is a push, at its own pitch.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Alt",
							"parameter_shortname": "Alt",
							"parameter_type": 2,
							"parameter_enum": [
								"Off",
								"Auto",
								"On"
							],
							"parameter_mmax": 2,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								1
							]
						}
					},
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						131.0,
						93.0,
						25.0,
						13.0
					],
					"patching_rect": [
						1870,
						260,
						25,
						13
					]
				}
			},
			{
				"box": {
					"id": "altface",
					"varname": "altface",
					"maxclass": "jsui",
					"numinlets": 1,
					"numoutlets": 0,
					"filename": "cuica_alt.js",
					"border": 0,
					"parameter_enable": 0,
					"ignoreclick": 1,
					"presentation": 1,
					"presentation_rect": [
						131.0,
						93.0,
						25.0,
						13.0
					],
					"patching_rect": [
						1780,
						260,
						25,
						13
					]
				}
			},
			{
				"box": {
					"id": "pre_mpe_slide",
					"maxclass": "newobj",
					"text": "prepend sld",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						770,
						77,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_mpe_slide",
					"varname": "ol_mpe_slide",
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
						158.0,
						36.0,
						44.0,
						13.0
					],
					"patching_rect": [
						1600,
						260,
						44,
						13
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "mpe_slide",
					"varname": "mpe_slide",
					"maxclass": "live.menu",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"",
						"",
						"float"
					],
					"parameter_enable": 1,
					"appearance": 1,
					"lcdbgcolor": [
						0,
						0,
						0,
						0
					],
					"annotation_name": "MPE Slide",
					"annotation": "MPE Slide (CC74): what moving the finger along the key does: press the head with the thumb (pitch up by Thumb), tighten the Head, brighten the Tone, or grip the rod harder (lower and rougher, like Pressure).",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "MPE Slide",
							"parameter_shortname": "MPE Slide",
							"parameter_type": 2,
							"parameter_enum": [
								"Off",
								"Thumb",
								"Head",
								"Tone",
								"Grip"
							],
							"parameter_mmax": 4,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								1
							]
						}
					},
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"lcdcolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"presentation": 1,
					"presentation_rect": [
						158.0,
						36.0,
						44.0,
						13.0
					],
					"patching_rect": [
						2230,
						180,
						44,
						13
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "lbl_mpe_slide",
					"varname": "lbl_mpe_slide",
					"maxclass": "comment",
					"text": "Slide",
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
						156.0,
						20.0,
						48.0,
						14.0
					],
					"patching_rect": [
						2140,
						180,
						48,
						14
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_mpe_press",
					"maxclass": "newobj",
					"text": "prepend pram",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						650,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "sc_mpe_press",
					"maxclass": "newobj",
					"text": "* 0.01",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						620,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_mpe_press",
					"varname": "ol_mpe_press",
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
						110.0,
						36.0,
						44.0,
						13.0
					],
					"patching_rect": [
						1870,
						180,
						44,
						13
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "mpe_press",
					"varname": "mpe_press",
					"maxclass": "live.numbox",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"parameter_enable": 1,
					"appearance": 4,
					"lcdbgcolor": [
						0,
						0,
						0,
						0
					],
					"bordercolor": [
						0,
						0,
						0,
						0
					],
					"annotation_name": "MPE Pressure",
					"annotation": "MPE Pressure: how strongly finger pressure keeps the cloth rubbing. 0: every note is just its one stroke.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "MPE Pressure",
							"parameter_shortname": "MPE Pressure",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								100
							],
							"parameter_unitstyle": 5
						}
					},
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"lcdcolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"presentation": 1,
					"presentation_rect": [
						110.0,
						36.0,
						44.0,
						13.0
					],
					"patching_rect": [
						1780,
						180,
						44,
						13
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "lbl_mpe_press",
					"varname": "lbl_mpe_press",
					"maxclass": "comment",
					"text": "Pressure",
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
						108.0,
						20.0,
						48.0,
						14.0
					],
					"patching_rect": [
						1690,
						180,
						48,
						14
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_mpe_bend",
					"maxclass": "newobj",
					"text": "prepend pbrange",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						500,
						105,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_mpe_bend",
					"varname": "ol_mpe_bend",
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
						62.0,
						36.0,
						44.0,
						13.0
					],
					"patching_rect": [
						2230,
						100,
						44,
						13
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "mpe_bend",
					"varname": "mpe_bend",
					"maxclass": "live.numbox",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						"float"
					],
					"parameter_enable": 1,
					"appearance": 4,
					"lcdbgcolor": [
						0,
						0,
						0,
						0
					],
					"bordercolor": [
						0,
						0,
						0,
						0
					],
					"annotation_name": "MPE Bend",
					"annotation": "MPE Bend: the per-note pitch bend range, in semitones (48 is the MPE standard; match your controller).",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "MPE Bend",
							"parameter_shortname": "MPE Bend",
							"parameter_type": 0,
							"parameter_mmin": 1.0,
							"parameter_mmax": 96.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								48
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%d st"
						}
					},
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"lcdcolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"presentation": 1,
					"presentation_rect": [
						62.0,
						36.0,
						44.0,
						13.0
					],
					"patching_rect": [
						2140,
						100,
						44,
						13
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "lbl_mpe_bend",
					"varname": "lbl_mpe_bend",
					"maxclass": "comment",
					"text": "Bend",
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
						60.0,
						20.0,
						48.0,
						14.0
					],
					"patching_rect": [
						2050,
						100,
						48,
						14
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_mpe_on",
					"maxclass": "newobj",
					"text": "prepend mpe",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						380,
						77,
						22
					]
				}
			},
			{
				"box": {
					"id": "mpe_on",
					"varname": "mpe_on",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"parameter_enable": 1,
					"mode": 1,
					"text": "Off",
					"texton": "On",
					"rounded": 2,
					"annotation_name": "MPE",
					"annotation": "MPE: on, a note's own channel carries its pressure, slide and pitch bend (Live sends per-note channels to this device). Off: they are ignored.",
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"activetextcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bgoncolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"activebgoncolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"textoncolor": {
							"expression": "themecolor.live_lcd_bg"
						},
						"activetextoncolor": {
							"expression": "themecolor.live_lcd_bg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "MPE",
							"parameter_shortname": "MPE",
							"parameter_type": 2,
							"parameter_enum": [
								"Off",
								"On"
							],
							"parameter_mmax": 1,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								1
							]
						}
					},
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"textcolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"activetextcolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"bgoncolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"activebgoncolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"textoncolor": [
						0.1098,
						0.1216,
						0.1569,
						1
					],
					"activetextoncolor": [
						0.1098,
						0.1216,
						0.1569,
						1
					],
					"bordercolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"bgcolor": [
						0,
						0,
						0,
						0
					],
					"activebgcolor": [
						0,
						0,
						0,
						0
					],
					"presentation": 1,
					"presentation_rect": [
						14.0,
						36.0,
						44.0,
						13.0
					],
					"patching_rect": [
						1870,
						100,
						44,
						13
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "lbl_mpe_on",
					"varname": "lbl_mpe_on",
					"maxclass": "comment",
					"text": "MPE",
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
						12.0,
						20.0,
						48.0,
						14.0
					],
					"patching_rect": [
						1780,
						100,
						48,
						14
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "mpe_page",
					"varname": "mpe_page",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"parameter_enable": 1,
					"mode": 1,
					"text": "MPE",
					"texton": "MPE",
					"rounded": 2,
					"annotation_name": "MPE settings",
					"annotation": "Shows the MPE settings in the display (and back to the drum).",
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"activetextcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bgoncolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"activebgoncolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"textoncolor": {
							"expression": "themecolor.live_lcd_bg"
						},
						"activetextoncolor": {
							"expression": "themecolor.live_lcd_bg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "MPE Page",
							"parameter_shortname": "MPE Page",
							"parameter_type": 2,
							"parameter_enum": [
								"Drum",
								"MPE"
							],
							"parameter_mmax": 1,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_invisible": 1
						}
					},
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"textcolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"activetextcolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"bgoncolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"activebgoncolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"textoncolor": [
						0.1098,
						0.1216,
						0.1569,
						1
					],
					"activetextoncolor": [
						0.1098,
						0.1216,
						0.1569,
						1
					],
					"bordercolor": [
						1,
						0.6784,
						0.3373,
						1
					],
					"bgcolor": [
						0,
						0,
						0,
						0
					],
					"activebgcolor": [
						0,
						0,
						0,
						0
					],
					"presentation": 1,
					"presentation_rect": [
						178.0,
						11.0,
						27.0,
						11.0
					],
					"patching_rect": [
						1690,
						100,
						27,
						11
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
					"filename": "cuica_view.js",
					"border": 0,
					"parameter_enable": 0,
					"annotation_name": "Cuica",
					"annotation": "The cuica: the last note, and a flash with every note you play.",
					"presentation": 1,
					"presentation_rect": [
						8.0,
						8.0,
						200.0,
						48.0
					],
					"patching_rect": [
						1600,
						100,
						200,
						48
					]
				}
			},
			{
				"box": {
					"id": "midiin",
					"maxclass": "newobj",
					"text": "midiin",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
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
					"text": "js cuica_midi.js",
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
									"code": "// Cuica engine. GENERATED by scripts/cuica_engine.py: do not edit.\nParam tune(0.0);\nParam press(0.55);\nParam speed(0.6);\nParam stroke(300.0);\nParam pull(2.0);\nParam scoop(-4.0);\nParam glide(60.0);\nParam thumb(12.0);\nParam head(0.5);\nParam rasp(0.25);\nParam tone(0.6);\nParam decay(400.0);\nParam vol(-6.0);\nParam nt(60.0);\nParam vl(0.0);\nParam hold(0.0);\nParam lg(0.0);\nParam tr(0.0);\nParam mw(0.0);\nParam bend(0.0);\nParam pr(0.0);\nParam sl(0.0);\nParam pbn(0.0);\nParam pram(1.0);\nParam sld(1.0);\nParam alt(1.0);\nHistory ctl(0.0);\nHistory ltr(0.0);\nHistory pcur(60.0);\nHistory tg(60.0);\nHistory kg(0.01);\nHistory phs(1.0);\nHistory since(1000000.0);\nHistory pullf(1.0);\nHistory vlv(0.8);\nHistory cont(0.0);\nHistory kc(0.01);\nHistory kr(0.001);\nHistory dph(0.0001);\nHistory tlp(1.0);\nHistory ma1(0.0);\nHistory ma2(0.0);\nHistory ma3(0.0);\nHistory mb1(0.0);\nHistory mb2(0.0);\nHistory mb3(0.0);\nHistory mc1(0.0);\nHistory mc2(0.0);\nHistory md1(0.0);\nHistory md2(0.0);\nHistory scp(0.0);\nHistory katt(0.001);\nHistory kbt(0.001);\nHistory fql(440.0);\nHistory gc(0.0);\nHistory gq(0.0);\nHistory gg(0.0);\nHistory g1(0.0);\nHistory g2(0.0);\nHistory he1(0.0);\nHistory he2(0.0);\nHistory hg(0.01);\nHistory ha1(1.0);\nHistory ha2(0.0);\nHistory ha3(0.0);\nHistory dcx(0.0);\nHistory dcy(0.0);\nHistory newn(0.0);\nHistory hmix(0.4);\nHistory grp(0.55);\nHistory zx1(0.0);\nHistory zxp(0.0);\nHistory zn(0.0);\nHistory zr(1.0);\nHistory zv1(0.0);\nHistory zx2(0.0);\nHistory zv2(0.0);\nHistory zx3(0.0);\nHistory zv3(0.0);\nHistory rc0(0);\nHistory rq0(0);\nHistory rg0(0);\nHistory ra0(0);\nHistory rb0(0);\nHistory rc1(0);\nHistory rq1(0);\nHistory rg1(0);\nHistory ra1(0);\nHistory rb1(0);\nHistory rc2(0);\nHistory rq2(0);\nHistory rg2(0);\nHistory ra2(0);\nHistory rb2(0);\n\nctl = ctl + 1;\nctl = ctl * (ctl < 32);\nupd = ctl == 0;\nnewn = 0;\nif (tr != ltr) {\n    ltr = tr;\n    newn = 1;\n    vlv = vl;\n    phs = 0.25;\n    scp = (lg < 0.5) * scoop * (1 + 0.25 * noise());   // the squeak: this stroke's scoop, a little different every time\n    // Alt: 0 Off (every note a push), 1 Auto (a note within one Stroke of the last one alternates; after a pause, a push), 2 On\n    quick = since < stroke * 0.001 * samplerate;\n    pullf = ((alt > 1.5) + (abs(alt - 1) < 0.5) * quick > 0) * (1 - pullf);\n    since = 0;\n    if (lg < 0.5) {\n        pcur = clamp(nt + tune + bend + pbn + thumb * max(mw, sl * (abs(sld - 1) < 0.5)) + pull * pullf, 12, 112);\n    }\n}\nif (upd + newn) {\n    hd = min(head + sl * (abs(sld - 2) < 0.5), 1);   // MPE slide can raise the head's tension or the brightness\n    tn = min(tone + sl * (abs(sld - 3) < 0.5), 1);\n    tg = clamp(nt + tune + bend + pbn + thumb * max(mw, sl * (abs(sld - 1) < 0.5)) + pull * pullf, 12, 112);\n    kg = 1 - exp(-3 / (max(glide, 0.5) * 0.001 * samplerate));\n    kc = 1 - exp(-1 / (0.003 * samplerate));\n    dph = 1 / (max(stroke, 20) * 0.001 * samplerate);\n    kr = 1 - exp(-6.9078 / (0.04 * samplerate));   // the cloth leaves the rod: the drive is gone in 40 ms, the head rings on\n    katt = 1 / (0.035 * samplerate);\n    kbt = 1 / (0.03 * samplerate);\n    grp = min(press + sl * (abs(sld - 4) < 0.5), 1);   // MPE slide can grip harder\n    f0 = mtof(pcur);\n    hq = 4 + 36 * hd;\n    hmix = 0.15;\n    fm = min(max(f0, 250 * pow(4, hd)), samplerate * 0.4);\n    gm = tan(3.1415927 * fm / samplerate);\n    gtn = tan(3.1415927 * min(fm * (1.2 + 3 * tn), samplerate * 0.4) / samplerate);\n    ma1 = 1 / (1 + gm * (gm + 0.2));\n    ma2 = gm * ma1;\n    ma3 = gm * ma2;\n    hg = tan(3.1415927 * 200.0 / samplerate);\n    ha1 = 1 / (1 + hg * (hg + 1.4142));\n    ha2 = hg * ha1;\n    ha3 = hg * ha2;\n    mb1 = 1 / (1 + gtn * (gtn + 1.4142));\n    mb2 = gtn * mb1;\n    mb3 = gtn * mb2;\n    rdec = exp(-6.9078 / (max(decay, 5) * 0.001 * samplerate));\n    wg = twopi * min(fql, samplerate * 0.45) / samplerate;   // the head's free ring at the sounding pitch, Decay to -60 dB\n    gc = 2 * rdec * cos(wg);\n    gq = rdec * rdec;\n    gg = 2 * (1 - rdec) * sin(wg);\n    fk = f0 * 2.296;\n    ok = fk < samplerate * 0.45;\n    wk = twopi * min(fk, samplerate * 0.45) / samplerate;\n    rk = exp(-3.1415927 * fk / (hq * samplerate)) * pow(rdec, 1 - cont);\n    rc0 = 2 * rk * cos(wk);\n    rq0 = rk * rk;\n    rg0 = 2 * (1 - rk) * sin(wk) * ok;\n    fk = f0 * 3.598;\n    ok = fk < samplerate * 0.45;\n    wk = twopi * min(fk, samplerate * 0.45) / samplerate;\n    rk = exp(-3.1415927 * fk / (hq * samplerate)) * pow(rdec, 1 - cont);\n    rc1 = 2 * rk * cos(wk);\n    rq1 = rk * rk;\n    rg1 = 2 * (1 - rk) * sin(wk) * ok;\n    fk = f0 * 4.903;\n    ok = fk < samplerate * 0.45;\n    wk = twopi * min(fk, samplerate * 0.45) / samplerate;\n    rk = exp(-3.1415927 * fk / (hq * samplerate)) * pow(rdec, 1 - cont);\n    rc2 = 2 * rk * cos(wk);\n    rq2 = rk * rk;\n    rg2 = 2 * (1 - rk) * sin(wk) * ok;\n}\n\n// ---- strokes\nphs = min(phs + dph, 1);\nsince = min(since + 1, 1000000);\nprh = pr * pram * (hold > 0.5);\nenv0 = max(0.5 * (1 - cos(twopi * phs)), prh);\nenv = env0 * min(since * katt, 1);\nprg = clamp((phs - 0.25) * 2.8571, 0, 1);   // the scoop rides the stroke: arrives at 60 % of it, just past the hardest rub\nprg = prg * prg * (3 - 2 * prg);\nrub = (phs < 1) + (prh > 0.01) > 0;\nvnm = (0.08 + 0.55 * speed) * (0.4 + 0.6 * vlv) * (1 + 0.2 * pullf);   // this stroke's speed\nvb = env * vnm * cont;\ncont = cont + (rub - cont) * (kr + (kc - kr) * rub);\npcur = pcur + (tg - pcur) * kg;\n\n// ---- the rod: the cloth's friction (hyperbolic law) on the head's first 3 modes, stick or slip solved in closed form each sample.\n// Grip flattens the pitch; a slow rub under grip sticks longer: the sag, the creak, raucous or period-2 motion. None of it is scripted.\ngp = 0.135 + 0.9 * grp * grp;\nfq = mtof(pcur + scp * (1 - prg) + 0.49 * min(gp, 0.40725));\nth1 = twopi * fq / samplerate;\nth1 = min(th1 * (1 - 0.03 * th1), 1.5);   // stick and slip happen on sample boundaries, which sharpens high notes: tuned back\n// the normal force: the hand bites as a stroke starts (a clean attack needs extra force, Guettler 2002) and lets go as the rub stops\nfnr = gp * vnm * th1 * samplerate * 0.8 * cont * min(env0 * 16.6666666667, 1) * (1 + 3.0 * max(1 - since * kbt, 0));\nimb = 0.1 + 1.6 * rasp;\nthz = min(th1 * 1.0, 1.5);\nez = 2 * sin(thz * 0.5) * samplerate;\noz1 = th1 * 1.0 < 1.5;\nzt1 = zv1 - (ez / 80.0 * zv1 + ez * ez * zx1) / samplerate;\nthz = min(th1 * 3.5, 1.5);\nez = 2 * sin(thz * 0.5) * samplerate;\noz2 = th1 * 3.5 < 1.5;\nzt2 = zv2 - (ez / 30.0 * zv2 + ez * ez * zx2) / samplerate;\nthz = min(th1 * 6.2, 1.5);\nez = 2 * sin(thz * 0.5) * samplerate;\noz3 = th1 * 6.2 < 1.5;\nzt3 = zv3 - (ez / 30.0 * zv3 + ez * ez * zx3) / samplerate;\nim2 = imb * oz2;\nim3 = imb * 0.5 * oz3;\nhh = (1 + im2 + im3) / samplerate;\ndz = vb - zt1 - zt2 * oz2 - zt3 * oz3;   // the slip velocity if the cloth let go\nadz = abs(dz);\nfa = 0.3 * fnr;\nfbb = 0.1 + adz;\ndsc = (fbb - fa * hh) * (fbb - fa * hh) - 4 * hh * fnr * 0.05;\nsti = adz <= 0.8 * fnr * hh;\nff = sti * dz / hh + (1 - sti) * sign(dz) * ((fbb + fa * hh) - sqrt(max(dsc, 0))) / (2 * hh);\nff = ff + 20.0 * rasp * noise() * sqrt(abs(vb) * fnr);\nzv1 = clamp(zt1 + ff / samplerate, -4, 4);   // guards: no state can run away\nzv2 = clamp(zt2 + im2 * ff / samplerate, -4, 4);\nzv3 = clamp(zt3 + im3 * ff / samplerate, -4, 4);\nzx1 = clamp(zx1 + zv1 / samplerate, -1, 1);\nzx2 = clamp(zx2 + zv2 / samplerate, -1, 1);\nzx3 = clamp(zx3 + zv3 / samplerate, -1, 1);\nfil = zv1 + 0.3 * (zv2 * oz2 + zv3 * oz3);   // the higher modes have cancelling zones: they radiate less than they move\n// the head rings on at the pitch the rod actually made (grip and sag move it off fq): mode 1's upward zero crossings while rubbed\n// give the ratio to fq, so the ring still follows glides and the thumb at once\nzc = (zx1 > 0) * (zxp <= 0);\nzxp = zx1;\nzn = zn + 1;\nzq = samplerate / max(zn, 1) / fq;\nzr = zr + zc * (fnr > 0) * (zq > 0.67) * (zq < 1.2) * (zq - zr) * 0.5;   // near 1 only: the head rings at its own pitch, not a creak's\nzr = newn + (1 - newn) * zr;\nfql = fq * zr;\nzn = zn * (1 - zc);\n\n// ---- the head's first mode: two cascaded TPT state-variable low-passes at fm (the first resonant)\nv3 = fil - mc2;\nv1 = ma1 * mc1 + ma2 * v3;\nv2 = mc2 + ma2 * mc1 + ma3 * v3;\nmc1 = 2 * v1 - mc1;\nmc2 = 2 * v2 - mc2;\nw3 = v2 - md2;\nw1 = mb1 * md1 + mb2 * w3;\nw2 = md2 + mb2 * md1 + mb3 * w3;\nmd1 = 2 * w1 - md1;\nmd2 = 2 * w2 - md2;\n// a small drum barely radiates its lowest notes: a 2-pole high-pass at 200.0 Hz (a low stroke's fundamental sits ~9 dB under H2-H4)\nu3 = w2 - he2;\nu1 = ha1 * he1 + ha2 * u3;\nu2 = he2 + ha2 * he1 + ha3 * u3;\nhe1 = 2 * u1 - he1;\nhe2 = 2 * u2 - he2;\nmem = w2 - 1.4142 * u1 - u2;\n\n// ---- membrane resonators\nres = 0;\nry0 = rc0 * ra0 - rq0 * rb0 + rg0 * mem;\nrb0 = ra0;\nra0 = ry0;\nres = res + ry0;\nry1 = rc1 * ra1 - rq1 * rb1 + rg1 * mem;\nrb1 = ra1;\nra1 = ry1;\nres = res + ry1;\nry2 = rc2 * ra2 - rq2 * rb2 + rg2 * mem;\nrb2 = ra2;\nra2 = ry2;\nres = res + ry2;\n\nhm = tanh(mem * 2.0) / 2.0 * 4.5 / (1 + fq * 0.0005);\ngy = gc * g1 - gq * g2 + gg * hm;\ng2 = g1;\ng1 = gy;\nmx = hm + 0.2 * gy + hmix * res * 3;\ndcy = mx - dcx + 0.995 * dcy;\ndcx = mx;\ny = tanh(dcy * dbtoa(vol) * 0.6);\nout1 = y;\nout2 = y + 0 * in1;\n",
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
						208.0,
						108.0
					],
					"patching_rect": [
						1690,
						20,
						208,
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
						"midiin",
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
						"mpe_on",
						0
					],
					"destination": [
						"pre_mpe_on",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_mpe_on",
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
						"mpe_bend",
						0
					],
					"destination": [
						"pre_mpe_bend",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_mpe_bend",
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
						"mpe_bend",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"mpe_press",
						0
					],
					"destination": [
						"sc_mpe_press",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sc_mpe_press",
						0
					],
					"destination": [
						"pre_mpe_press",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_mpe_press",
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
						"mpe_press",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"mpe_slide",
						0
					],
					"destination": [
						"pre_mpe_slide",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_mpe_slide",
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
						"mpe_slide",
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
						"alt",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"alt",
						0
					],
					"destination": [
						"altface",
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
						"altface",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"alt",
						0
					],
					"destination": [
						"pre_alt",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_alt",
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
						"mpe_page",
						0
					],
					"destination": [
						"page",
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
						"tune",
						0
					],
					"destination": [
						"pre_tune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_tune",
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
						"tune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pressure",
						0
					],
					"destination": [
						"sc_pressure",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sc_pressure",
						0
					],
					"destination": [
						"pre_pressure",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_pressure",
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
						"pressure",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"speed",
						0
					],
					"destination": [
						"sc_speed",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sc_speed",
						0
					],
					"destination": [
						"pre_speed",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_speed",
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
						"speed",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"stroke",
						0
					],
					"destination": [
						"pre_stroke",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_stroke",
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
						"stroke",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pull",
						0
					],
					"destination": [
						"pre_pull",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_pull",
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
						"pull",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"thumb",
						0
					],
					"destination": [
						"pre_thumb",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_thumb",
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
						"thumb",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"scoop",
						0
					],
					"destination": [
						"pre_scoop",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_scoop",
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
						"scoop",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"glide",
						0
					],
					"destination": [
						"pre_glide",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_glide",
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
						"glide",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"head",
						0
					],
					"destination": [
						"sc_head",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sc_head",
						0
					],
					"destination": [
						"pre_head",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_head",
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
						"head",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rasp",
						0
					],
					"destination": [
						"sc_rasp",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sc_rasp",
						0
					],
					"destination": [
						"pre_rasp",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_rasp",
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
						"rasp",
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
						"sc_tone",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sc_tone",
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
			},
			{
				"patchline": {
					"source": [
						"decay",
						0
					],
					"destination": [
						"pre_decay",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_decay",
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
						"decay",
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
						"midi",
						0
					],
					"destination": [
						"mw_route",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"mw_route",
						0
					],
					"destination": [
						"mw_pre",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"mw_pre",
						0
					],
					"destination": [
						"pk_js",
						0
					]
				}
			}
		],
		"dependency_cache": [],
		"autosave": 0,
		"parameters": {
			"mpe_page": [
				"MPE Page",
				"MPE Page",
				0
			],
			"mpe_on": [
				"MPE",
				"MPE",
				0
			],
			"mpe_bend": [
				"MPE Bend",
				"MPE Bend",
				0
			],
			"mpe_press": [
				"MPE Pressure",
				"MPE Pressure",
				0
			],
			"mpe_slide": [
				"MPE Slide",
				"MPE Slide",
				0
			],
			"alt": [
				"Alt",
				"Alt",
				0
			],
			"tune": [
				"Tune",
				"Tune",
				0
			],
			"pressure": [
				"Pressure",
				"Pressure",
				0
			],
			"speed": [
				"Speed",
				"Speed",
				0
			],
			"stroke": [
				"Stroke",
				"Stroke",
				0
			],
			"pull": [
				"Pull",
				"Pull",
				0
			],
			"thumb": [
				"Thumb",
				"Thumb",
				0
			],
			"scoop": [
				"Scoop",
				"Scoop",
				0
			],
			"glide": [
				"Glide",
				"Glide",
				0
			],
			"head": [
				"Head",
				"Head",
				0
			],
			"rasp": [
				"Rasp",
				"Rasp",
				0
			],
			"tone": [
				"Tone",
				"Tone",
				0
			],
			"decay": [
				"Decay",
				"Decay",
				0
			],
			"volume": [
				"Volume",
				"Volume",
				0
			],
			"parameterbanks": {
				"0": {
					"index": 0,
					"name": "Rub",
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
						"Tune",
						"Pressure",
						"Speed",
						"Stroke",
						"Pull",
						"Scoop",
						"Thumb",
						"Glide"
					]
				},
				"1": {
					"index": 1,
					"name": "Head",
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
						"Head",
						"Rasp",
						"Tone",
						"Decay",
						"Volume",
						"Alt",
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