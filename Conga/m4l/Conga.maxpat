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
			288.0,
			169.0
		],
		"openinpresentation": 1,
		"devicewidth": 288.0,
		"default_fontname": "Ableton Sans Medium",
		"default_fontsize": 9.0,
		"gridsize": [
			8.0,
			8.0
		],
		"description": "Conga: three drums (quinto, conga, tumba) with open, slap, mute, bass, heel and toe strokes, as a modal membrane model.",
		"boxes": [
			{
				"box": {
					"id": "pre_level",
					"maxclass": "newobj",
					"text": "prepend level",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						1130,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "level",
					"varname": "level",
					"parameter_enable": 1,
					"annotation_name": "Level",
					"annotation": "Output level.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Level",
							"parameter_shortname": "Level",
							"parameter_type": 0,
							"parameter_mmin": -36.0,
							"parameter_mmax": 6.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								-9
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
						252.0,
						116.0,
						36.0,
						50.0
					],
					"patching_rect": [
						1960,
						340,
						36,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_spread",
					"maxclass": "newobj",
					"text": "prepend spread",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						1070,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "spread",
					"varname": "spread",
					"parameter_enable": 1,
					"annotation_name": "Spread",
					"annotation": "Stereo spread of the three drums: quinto right, conga centre, tumba left.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Spread",
							"parameter_shortname": "Spread",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								40
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.0f %"
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
						216.0,
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
					"id": "pre_press",
					"maxclass": "newobj",
					"text": "prepend press",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						1010,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "press",
					"varname": "press",
					"parameter_enable": 1,
					"annotation_name": "Press",
					"annotation": "The mod wheel presses the head (elbow or palm on it): this many semitones up at full wheel, on all three drums.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Press",
							"parameter_shortname": "Press",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								5
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
					"presentation": 1,
					"presentation_rect": [
						180.0,
						116.0,
						36.0,
						50.0
					],
					"patching_rect": [
						1600,
						340,
						36,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_touch",
					"maxclass": "newobj",
					"text": "prepend touch",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						950,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "touch",
					"varname": "touch",
					"parameter_enable": 1,
					"annotation_name": "Touch",
					"annotation": "How much velocity changes the tone: harder hits are shorter in contact (brighter) as well as louder.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Touch",
							"parameter_shortname": "Touch",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								50
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.0f %"
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
						2140,
						260,
						36,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_shell",
					"maxclass": "newobj",
					"text": "prepend shell",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						890,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "shell",
					"varname": "shell",
					"parameter_enable": 1,
					"annotation_name": "Shell",
					"annotation": "The body of the drum: how much the low modes (air in the shell, the heel and bass thump) speak.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Shell",
							"parameter_shortname": "Shell",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								50
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.0f %"
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
						1960,
						260,
						36,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_slap",
					"maxclass": "newobj",
					"text": "prepend slap",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						830,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "slap",
					"varname": "slap",
					"parameter_enable": 1,
					"annotation_name": "Slap",
					"annotation": "Character of the slap: the crack of the fingers on the rim (noise) and how far up the overtones are driven.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Slap",
							"parameter_shortname": "Slap",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								50
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.0f %"
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
						1780,
						260,
						36,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_skin",
					"maxclass": "newobj",
					"text": "prepend skin",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						770,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "skin",
					"varname": "skin",
					"parameter_enable": 1,
					"annotation_name": "Skin",
					"annotation": "Brightness of the head: tilts the strength of the overtones against the fundamental. 50 % is the recording.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Skin",
							"parameter_shortname": "Skin",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								50
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.0f %"
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
						1600,
						260,
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
						20,
						710,
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
					"annotation": "How long the heads ring, in percent of the natural time (the open tone's T60 is about half a second).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Decay",
							"parameter_shortname": "Decay",
							"parameter_type": 0,
							"parameter_mmin": 30.0,
							"parameter_mmax": 300.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								100
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.0f %"
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
						2140,
						180,
						36,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_tuneQ",
					"maxclass": "newobj",
					"text": "prepend tuneQ",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						650,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_tuneQ",
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
						208.0,
						80.0,
						64.0,
						20.0
					],
					"patching_rect": [
						1960,
						180,
						64,
						20
					]
				}
			},
			{
				"box": {
					"id": "tuneQ",
					"varname": "tuneQ",
					"parameter_enable": 1,
					"annotation_name": "Quinto Tune",
					"annotation": "Quinto (the high drum) tuning in semitones. 0 is F#4 (366 Hz): the open tone.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Quinto Tune",
							"parameter_shortname": "Quinto Tune",
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
					"fontsize": 12.0,
					"presentation": 1,
					"presentation_rect": [
						208.0,
						80.0,
						64.0,
						20.0
					],
					"patching_rect": [
						1870,
						180,
						64,
						20
					]
				}
			},
			{
				"box": {
					"id": "hdr_tuneQ",
					"maxclass": "comment",
					"text": "Quinto",
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
						204.0,
						64.0,
						72.0,
						14.0
					],
					"patching_rect": [
						1780,
						180,
						72,
						14
					]
				}
			},
			{
				"box": {
					"id": "pre_tuneC",
					"maxclass": "newobj",
					"text": "prepend tuneC",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						530,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_tuneC",
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
						80.0,
						64.0,
						20.0
					],
					"patching_rect": [
						1600,
						180,
						64,
						20
					]
				}
			},
			{
				"box": {
					"id": "tuneC",
					"varname": "tuneC",
					"parameter_enable": 1,
					"annotation_name": "Conga Tune",
					"annotation": "Conga (the middle drum) tuning in semitones. 0 is C4 (266 Hz): the open tone.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Conga Tune",
							"parameter_shortname": "Conga Tune",
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
					"fontsize": 12.0,
					"presentation": 1,
					"presentation_rect": [
						112.0,
						80.0,
						64.0,
						20.0
					],
					"patching_rect": [
						2230,
						100,
						64,
						20
					]
				}
			},
			{
				"box": {
					"id": "hdr_tuneC",
					"maxclass": "comment",
					"text": "Conga",
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
						64.0,
						72.0,
						14.0
					],
					"patching_rect": [
						2140,
						100,
						72,
						14
					]
				}
			},
			{
				"box": {
					"id": "pre_tuneT",
					"maxclass": "newobj",
					"text": "prepend tuneT",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						410,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_tuneT",
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
						16.0,
						80.0,
						64.0,
						20.0
					],
					"patching_rect": [
						1960,
						100,
						64,
						20
					]
				}
			},
			{
				"box": {
					"id": "tuneT",
					"varname": "tuneT",
					"parameter_enable": 1,
					"annotation_name": "Tumba Tune",
					"annotation": "Tumba (the low drum) tuning in semitones. 0 is A3 (219 Hz): the open tone.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Tumba Tune",
							"parameter_shortname": "Tumba Tune",
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
					"fontsize": 12.0,
					"presentation": 1,
					"presentation_rect": [
						16.0,
						80.0,
						64.0,
						20.0
					],
					"patching_rect": [
						1870,
						100,
						64,
						20
					]
				}
			},
			{
				"box": {
					"id": "hdr_tuneT",
					"maxclass": "comment",
					"text": "Tumba",
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
						64.0,
						72.0,
						14.0
					],
					"patching_rect": [
						1780,
						100,
						72,
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
						290,
						77,
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
					"filename": "conga_view.js",
					"border": 0,
					"parameter_enable": 0,
					"annotation_name": "Congas",
					"annotation": "The three drums: each flashes when it is hit, with the name of the stroke.",
					"presentation": 1,
					"presentation_rect": [
						8.0,
						8.0,
						272.0,
						52.0
					],
					"patching_rect": [
						1600,
						100,
						272,
						52
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
					"text": "js conga_midi.js",
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
									"code": "Param tuneQ(0);\nParam tuneC(0);\nParam tuneT(0);\nParam decay(100);\nParam skin(50);\nParam slap(50);\nParam shell(50);\nParam touch(50);\nParam press(5);\nParam spread(40);\nParam level(-9);\nParam tr0(0);\nParam tr1(0);\nParam tr2(0);\nParam tr3(0);\nParam tr4(0);\nParam tr5(0);\nParam tr6(0);\nParam tr7(0);\nParam tr8(0);\nParam tr9(0);\nParam tr10(0);\nParam tr11(0);\nParam tr12(0);\nParam tr13(0);\nParam tr14(0);\nParam tr15(0);\nParam tr16(0);\nParam tr17(0);\nParam vl0(1);\nParam vl1(1);\nParam vl2(1);\nParam vl3(1);\nParam vl4(1);\nParam vl5(1);\nParam vl6(1);\nParam vl7(1);\nParam vl8(1);\nParam vl9(1);\nParam vl10(1);\nParam vl11(1);\nParam vl12(1);\nParam vl13(1);\nParam vl14(1);\nParam vl15(1);\nParam vl16(1);\nParam vl17(1);\nParam mw(0);\nHistory cnt(0);\nHistory pf(1);\nHistory pt0(0);\nHistory pt1(0);\nHistory pt2(0);\nHistory pt3(0);\nHistory pt4(0);\nHistory pt5(0);\nHistory qC(0);\nHistory qCk(0.99);\nHistory qE1(0);\nHistory qE2(0);\nHistory qK(0.5);\nHistory qNe(0);\nHistory qNr(0.99);\nHistory qI1(0);\nHistory qI2(0);\nHistory qNa1(0);\nHistory qNa2(0);\nHistory qNa3(0);\nHistory qNk(1);\nHistory qAm(0);\nHistory qX0(0);\nHistory qY0(0);\nHistory qW0(0);\nHistory qG0(1);\nHistory qCc0(1);\nHistory qSn0(0);\nHistory qR0(0.999);\nHistory qX1(0);\nHistory qY1(0);\nHistory qW1(0);\nHistory qG1(1);\nHistory qCc1(1);\nHistory qSn1(0);\nHistory qR1(0.999);\nHistory qX2(0);\nHistory qY2(0);\nHistory qW2(0);\nHistory qG2(1);\nHistory qCc2(1);\nHistory qSn2(0);\nHistory qR2(0.999);\nHistory qX3(0);\nHistory qY3(0);\nHistory qW3(0);\nHistory qG3(1);\nHistory qCc3(1);\nHistory qSn3(0);\nHistory qR3(0.999);\nHistory qX4(0);\nHistory qY4(0);\nHistory qW4(0);\nHistory qG4(1);\nHistory qCc4(1);\nHistory qSn4(0);\nHistory qR4(0.999);\nHistory qX5(0);\nHistory qY5(0);\nHistory qW5(0);\nHistory qG5(1);\nHistory qCc5(1);\nHistory qSn5(0);\nHistory qR5(0.999);\nHistory qX6(0);\nHistory qY6(0);\nHistory qW6(0);\nHistory qG6(1);\nHistory qCc6(1);\nHistory qSn6(0);\nHistory qR6(0.999);\nHistory qX7(0);\nHistory qY7(0);\nHistory qW7(0);\nHistory qG7(1);\nHistory qCc7(1);\nHistory qSn7(0);\nHistory qR7(0.999);\nHistory qX8(0);\nHistory qY8(0);\nHistory qW8(0);\nHistory qG8(1);\nHistory qCc8(1);\nHistory qSn8(0);\nHistory qR8(0.999);\nHistory qX9(0);\nHistory qY9(0);\nHistory qW9(0);\nHistory qG9(1);\nHistory qCc9(1);\nHistory qSn9(0);\nHistory qR9(0.999);\nHistory qX10(0);\nHistory qY10(0);\nHistory qW10(0);\nHistory qG10(1);\nHistory qCc10(1);\nHistory qSn10(0);\nHistory qR10(0.999);\nHistory qX11(0);\nHistory qY11(0);\nHistory qW11(0);\nHistory qG11(1);\nHistory qCc11(1);\nHistory qSn11(0);\nHistory qR11(0.999);\nHistory qX12(0);\nHistory qY12(0);\nHistory qW12(0);\nHistory qG12(1);\nHistory qCc12(1);\nHistory qSn12(0);\nHistory qR12(0.999);\nHistory qX13(0);\nHistory qY13(0);\nHistory qW13(0);\nHistory qG13(1);\nHistory qCc13(1);\nHistory qSn13(0);\nHistory qR13(0.999);\nHistory pt6(0);\nHistory pt7(0);\nHistory pt8(0);\nHistory pt9(0);\nHistory pt10(0);\nHistory pt11(0);\nHistory cC(0);\nHistory cCk(0.99);\nHistory cE1(0);\nHistory cE2(0);\nHistory cK(0.5);\nHistory cNe(0);\nHistory cNr(0.99);\nHistory cI1(0);\nHistory cI2(0);\nHistory cNa1(0);\nHistory cNa2(0);\nHistory cNa3(0);\nHistory cNk(1);\nHistory cAm(0);\nHistory cX0(0);\nHistory cY0(0);\nHistory cW0(0);\nHistory cG0(1);\nHistory cCc0(1);\nHistory cSn0(0);\nHistory cR0(0.999);\nHistory cX1(0);\nHistory cY1(0);\nHistory cW1(0);\nHistory cG1(1);\nHistory cCc1(1);\nHistory cSn1(0);\nHistory cR1(0.999);\nHistory cX2(0);\nHistory cY2(0);\nHistory cW2(0);\nHistory cG2(1);\nHistory cCc2(1);\nHistory cSn2(0);\nHistory cR2(0.999);\nHistory cX3(0);\nHistory cY3(0);\nHistory cW3(0);\nHistory cG3(1);\nHistory cCc3(1);\nHistory cSn3(0);\nHistory cR3(0.999);\nHistory cX4(0);\nHistory cY4(0);\nHistory cW4(0);\nHistory cG4(1);\nHistory cCc4(1);\nHistory cSn4(0);\nHistory cR4(0.999);\nHistory cX5(0);\nHistory cY5(0);\nHistory cW5(0);\nHistory cG5(1);\nHistory cCc5(1);\nHistory cSn5(0);\nHistory cR5(0.999);\nHistory cX6(0);\nHistory cY6(0);\nHistory cW6(0);\nHistory cG6(1);\nHistory cCc6(1);\nHistory cSn6(0);\nHistory cR6(0.999);\nHistory cX7(0);\nHistory cY7(0);\nHistory cW7(0);\nHistory cG7(1);\nHistory cCc7(1);\nHistory cSn7(0);\nHistory cR7(0.999);\nHistory cX8(0);\nHistory cY8(0);\nHistory cW8(0);\nHistory cG8(1);\nHistory cCc8(1);\nHistory cSn8(0);\nHistory cR8(0.999);\nHistory cX9(0);\nHistory cY9(0);\nHistory cW9(0);\nHistory cG9(1);\nHistory cCc9(1);\nHistory cSn9(0);\nHistory cR9(0.999);\nHistory cX10(0);\nHistory cY10(0);\nHistory cW10(0);\nHistory cG10(1);\nHistory cCc10(1);\nHistory cSn10(0);\nHistory cR10(0.999);\nHistory cX11(0);\nHistory cY11(0);\nHistory cW11(0);\nHistory cG11(1);\nHistory cCc11(1);\nHistory cSn11(0);\nHistory cR11(0.999);\nHistory cX12(0);\nHistory cY12(0);\nHistory cW12(0);\nHistory cG12(1);\nHistory cCc12(1);\nHistory cSn12(0);\nHistory cR12(0.999);\nHistory cX13(0);\nHistory cY13(0);\nHistory cW13(0);\nHistory cG13(1);\nHistory cCc13(1);\nHistory cSn13(0);\nHistory cR13(0.999);\nHistory pt12(0);\nHistory pt13(0);\nHistory pt14(0);\nHistory pt15(0);\nHistory pt16(0);\nHistory pt17(0);\nHistory tC(0);\nHistory tCk(0.99);\nHistory tE1(0);\nHistory tE2(0);\nHistory tK(0.5);\nHistory tNe(0);\nHistory tNr(0.99);\nHistory tI1(0);\nHistory tI2(0);\nHistory tNa1(0);\nHistory tNa2(0);\nHistory tNa3(0);\nHistory tNk(1);\nHistory tAm(0);\nHistory tX0(0);\nHistory tY0(0);\nHistory tW0(0);\nHistory tG0(1);\nHistory tCc0(1);\nHistory tSn0(0);\nHistory tR0(0.999);\nHistory tX1(0);\nHistory tY1(0);\nHistory tW1(0);\nHistory tG1(1);\nHistory tCc1(1);\nHistory tSn1(0);\nHistory tR1(0.999);\nHistory tX2(0);\nHistory tY2(0);\nHistory tW2(0);\nHistory tG2(1);\nHistory tCc2(1);\nHistory tSn2(0);\nHistory tR2(0.999);\nHistory tX3(0);\nHistory tY3(0);\nHistory tW3(0);\nHistory tG3(1);\nHistory tCc3(1);\nHistory tSn3(0);\nHistory tR3(0.999);\nHistory tX4(0);\nHistory tY4(0);\nHistory tW4(0);\nHistory tG4(1);\nHistory tCc4(1);\nHistory tSn4(0);\nHistory tR4(0.999);\nHistory tX5(0);\nHistory tY5(0);\nHistory tW5(0);\nHistory tG5(1);\nHistory tCc5(1);\nHistory tSn5(0);\nHistory tR5(0.999);\nHistory tX6(0);\nHistory tY6(0);\nHistory tW6(0);\nHistory tG6(1);\nHistory tCc6(1);\nHistory tSn6(0);\nHistory tR6(0.999);\nHistory tX7(0);\nHistory tY7(0);\nHistory tW7(0);\nHistory tG7(1);\nHistory tCc7(1);\nHistory tSn7(0);\nHistory tR7(0.999);\nHistory tX8(0);\nHistory tY8(0);\nHistory tW8(0);\nHistory tG8(1);\nHistory tCc8(1);\nHistory tSn8(0);\nHistory tR8(0.999);\nHistory tX9(0);\nHistory tY9(0);\nHistory tW9(0);\nHistory tG9(1);\nHistory tCc9(1);\nHistory tSn9(0);\nHistory tR9(0.999);\nHistory tX10(0);\nHistory tY10(0);\nHistory tW10(0);\nHistory tG10(1);\nHistory tCc10(1);\nHistory tSn10(0);\nHistory tR10(0.999);\nHistory tX11(0);\nHistory tY11(0);\nHistory tW11(0);\nHistory tG11(1);\nHistory tCc11(1);\nHistory tSn11(0);\nHistory tR11(0.999);\nHistory tX12(0);\nHistory tY12(0);\nHistory tW12(0);\nHistory tG12(1);\nHistory tCc12(1);\nHistory tSn12(0);\nHistory tR12(0.999);\nHistory tX13(0);\nHistory tY13(0);\nHistory tW13(0);\nHistory tG13(1);\nHistory tCc13(1);\nHistory tSn13(0);\nHistory tR13(0.999);\n\ndecayS = decay * 0.01;\nskinT = (skin - 50) * 0.02 * 6 / 6.0206;                      // +-6 dB per octave of mode ratio at the ends\nshellG = shell * 0.02;\nslapG = slap * 0.02;\ntouchG = touch * 0.01 * 1.0;\nspr = spread * 0.01;\npfT = exp2(mw * press / 12);\nmasterG = dbtoa(level);\nqSk0 = exp(skinT * -1.203973) * shellG;\nqSk1 = exp(skinT * -0.653926) * shellG;\nqSk2 = exp(skinT * -0.223144);\nqSk3 = exp(skinT * 0.000000);\nqSk4 = exp(skinT * 0.157004);\nqSk5 = exp(skinT * 0.451076);\nqSk6 = exp(skinT * 0.570980);\nqSk7 = exp(skinT * 0.722706);\nqSk8 = exp(skinT * 0.832909);\nqSk9 = exp(skinT * 0.974560);\nqSk10 = exp(skinT * 1.163151);\nqSk11 = exp(skinT * 1.360977);\nqSk12 = exp(skinT * 1.568616);\nqSk13 = exp(skinT * 1.824549);\nqF1 = 366.0 * exp2(tuneQ / 12);\nqPl = 0.6 * spr; qGl = cos((qPl + 1) * pi * 0.25); qGr = sin((qPl + 1) * pi * 0.25);\ncSk0 = exp(skinT * -1.203973) * shellG;\ncSk1 = exp(skinT * -0.653926) * shellG;\ncSk2 = exp(skinT * -0.223144);\ncSk3 = exp(skinT * 0.000000);\ncSk4 = exp(skinT * 0.157004);\ncSk5 = exp(skinT * 0.451076);\ncSk6 = exp(skinT * 0.570980);\ncSk7 = exp(skinT * 0.722706);\ncSk8 = exp(skinT * 0.832909);\ncSk9 = exp(skinT * 0.974560);\ncSk10 = exp(skinT * 1.163151);\ncSk11 = exp(skinT * 1.360977);\ncSk12 = exp(skinT * 1.568616);\ncSk13 = exp(skinT * 1.824549);\ncF1 = 266.0 * exp2(tuneC / 12);\ncPl = 0.0 * spr; cGl = cos((cPl + 1) * pi * 0.25); cGr = sin((cPl + 1) * pi * 0.25);\ntSk0 = exp(skinT * -1.203973) * shellG;\ntSk1 = exp(skinT * -0.653926) * shellG;\ntSk2 = exp(skinT * -0.223144);\ntSk3 = exp(skinT * 0.000000);\ntSk4 = exp(skinT * 0.157004);\ntSk5 = exp(skinT * 0.451076);\ntSk6 = exp(skinT * 0.570980);\ntSk7 = exp(skinT * 0.722706);\ntSk8 = exp(skinT * 0.832909);\ntSk9 = exp(skinT * 0.974560);\ntSk10 = exp(skinT * 1.163151);\ntSk11 = exp(skinT * 1.360977);\ntSk12 = exp(skinT * 1.568616);\ntSk13 = exp(skinT * 1.824549);\ntF1 = 219.0 * exp2(tuneT / 12);\ntPl = -0.6 * spr; tGl = cos((tPl + 1) * pi * 0.25); tGr = sin((tPl + 1) * pi * 0.25);\ncnt = cnt + 1; ctl = cnt >= 16; cnt = cnt - ctl * 16;\nif (ctl) { pf = pf + 0.2 * (pfT - pf); }\nnz = noise();\nqh0 = tr0 != pt0; pt0 = tr0;\nqh1 = tr1 != pt1; pt1 = tr1;\nqh2 = tr2 != pt2; pt2 = tr2;\nqh3 = tr3 != pt3; pt3 = tr3;\nqh4 = tr4 != pt4; pt4 = tr4;\nqh5 = tr5 != pt5; pt5 = tr5;\nqhs = qh0 + qh1 + qh2 + qh3 + qh4 + qh5;\nqdm = max(max(max(max(max(qh0 * 1, qh1 * 2), qh2 * 3), qh3 * 4), qh4 * 5), qh5 * 6);                                      // the highest stroke wins if two land in one block\nqds = qdm - 1;\nqdv = (qdm == 1) * vl0 + (qdm == 2) * vl1 + (qdm == 3) * vl2 + (qdm == 4) * vl3 + (qdm == 5) * vl4 + (qdm == 6) * vl5;\nqIm = 0;\nif (qhs > 0.5) {\nqs0 = abs(qds - 0) < 0.5;\nqs1 = abs(qds - 1) < 0.5;\nqs2 = abs(qds - 2) < 0.5;\nqs3 = abs(qds - 3) < 0.5;\nqs4 = abs(qds - 4) < 0.5;\nqs5 = abs(qds - 5) < 0.5;\nqvg = pow(qdv, 1.4) * 1.000000;\nqAm = qvg * ((abs(qds - 0) < 0.5) * 0.412600 + (abs(qds - 1) < 0.5) * 0.111000 + (abs(qds - 2) < 0.5) * 0.469900 + (abs(qds - 3) < 0.5) * 0.168400 + (abs(qds - 4) < 0.5) * 0.515800 + (abs(qds - 5) < 0.5) * 0.249200);\nqIm = qAm;\nqfc = ((abs(qds - 0) < 0.5) * 3000.000000 + (abs(qds - 1) < 0.5) * 6000.000000 + (abs(qds - 2) < 0.5) * 1500.000000 + (abs(qds - 3) < 0.5) * 250.000000 + (abs(qds - 4) < 0.5) * 500.000000 + (abs(qds - 5) < 0.5) * 2000.000000) * exp2((touchG * (qdv - 0.6) * 2) + qs1 * (slapG - 1));\nqK = 1 - exp(-twopi * min(qfc, 18000) / samplerate);\nqC = 1;\nqCk = exp(-16 / (((abs(qds - 0) < 0.5) * 1.000000 + (abs(qds - 1) < 0.5) * 0.050000 + (abs(qds - 2) < 0.5) * 0.300000 + (abs(qds - 3) < 0.5) * 0.200000 + (abs(qds - 4) < 0.5) * 0.150000 + (abs(qds - 5) < 0.5) * 0.100000) * samplerate));\nqNe = qAm * 1.33 * ((abs(qds - 0) < 0.5) * 1.396100 + (abs(qds - 1) < 0.5) * 6.791300 + (abs(qds - 2) < 0.5) * 0.758200 + (abs(qds - 3) < 0.5) * 5.809700 + (abs(qds - 4) < 0.5) * 0.668000 + (abs(qds - 5) < 0.5) * 0.650200) * (1 + qs1 * (slapG * 2 - 2));\nqNr = exp(-1 / (((abs(qds - 0) < 0.5) * 0.003000 + (abs(qds - 1) < 0.5) * 0.006000 + (abs(qds - 2) < 0.5) * 0.003000 + (abs(qds - 3) < 0.5) * 0.003000 + (abs(qds - 4) < 0.5) * 0.003000 + (abs(qds - 5) < 0.5) * 0.003000) * samplerate));\nqNg = tan(pi * ((abs(qds - 0) < 0.5) * 2930.000000 + (abs(qds - 1) < 0.5) * 3700.000000 + (abs(qds - 2) < 0.5) * 3750.000000 + (abs(qds - 3) < 0.5) * 3980.000000 + (abs(qds - 4) < 0.5) * 3980.000000 + (abs(qds - 5) < 0.5) * 3330.000000) / samplerate); qNk = 1 / ((abs(qds - 0) < 0.5) * 0.350000 + (abs(qds - 1) < 0.5) * 0.350000 + (abs(qds - 2) < 0.5) * 0.350000 + (abs(qds - 3) < 0.5) * 0.350000 + (abs(qds - 4) < 0.5) * 0.350000 + (abs(qds - 5) < 0.5) * 0.350000);\nqNa1 = 1 / (1 + qNg * (qNg + qNk)); qNa2 = qNg * qNa1; qNa3 = qNg * qNa2;\nqW0 = ((abs(qds - 0) < 0.5) * 0.052481 + (abs(qds - 1) < 0.5) * 0.272270 + (abs(qds - 2) < 0.5) * 0.031261 + (abs(qds - 3) < 0.5) * 0.609537 + (abs(qds - 4) < 0.5) * 0.030200 + (abs(qds - 5) < 0.5) * 0.032734) * qSk0; qG0 = (abs(qds - 0) < 0.5) * 1.000000 + (abs(qds - 1) < 0.5) * 0.250000 + (abs(qds - 2) < 0.5) * 0.320000 + (abs(qds - 3) < 0.5) * 0.370000 + (abs(qds - 4) < 0.5) * 0.300000 + (abs(qds - 5) < 0.5) * 0.250000;\nqW1 = ((abs(qds - 0) < 0.5) * 0.056234 + (abs(qds - 1) < 0.5) * 0.638263 + (abs(qds - 2) < 0.5) * 0.072444 + (abs(qds - 3) < 0.5) * 1.000000 + (abs(qds - 4) < 0.5) * 0.043652 + (abs(qds - 5) < 0.5) * 0.063826) * qSk1; qG1 = (abs(qds - 0) < 0.5) * 0.310000 + (abs(qds - 1) < 0.5) * 0.250000 + (abs(qds - 2) < 0.5) * 0.310000 + (abs(qds - 3) < 0.5) * 0.330000 + (abs(qds - 4) < 0.5) * 0.260000 + (abs(qds - 5) < 0.5) * 0.250000;\nqW2 = ((abs(qds - 0) < 0.5) * 0.113501 + (abs(qds - 1) < 0.5) * 0.568853 + (abs(qds - 2) < 0.5) * 0.091201 + (abs(qds - 3) < 0.5) * 0.451856 + (abs(qds - 4) < 0.5) * 0.037154 + (abs(qds - 5) < 0.5) * 0.117490) * qSk2; qG2 = (abs(qds - 0) < 0.5) * 0.460000 + (abs(qds - 1) < 0.5) * 0.680000 + (abs(qds - 2) < 0.5) * 1.050000 + (abs(qds - 3) < 0.5) * 0.930000 + (abs(qds - 4) < 0.5) * 0.940000 + (abs(qds - 5) < 0.5) * 0.950000;\nqW3 = ((abs(qds - 0) < 0.5) * 1.000000 + (abs(qds - 1) < 0.5) * 0.562341 + (abs(qds - 2) < 0.5) * 0.092257 + (abs(qds - 3) < 0.5) * 0.213796 + (abs(qds - 4) < 0.5) * 0.048978 + (abs(qds - 5) < 0.5) * 0.251189) * qSk3; qG3 = (abs(qds - 0) < 0.5) * 0.990000 + (abs(qds - 1) < 0.5) * 3.760000 + (abs(qds - 2) < 0.5) * 2.750000 + (abs(qds - 3) < 0.5) * 2.740000 + (abs(qds - 4) < 0.5) * 3.160000 + (abs(qds - 5) < 0.5) * 4.710000;\nqW4 = ((abs(qds - 0) < 0.5) * 0.208930 + (abs(qds - 1) < 0.5) * 0.630957 + (abs(qds - 2) < 0.5) * 0.050119 + (abs(qds - 3) < 0.5) * 0.367282 + (abs(qds - 4) < 0.5) * 0.060256 + (abs(qds - 5) < 0.5) * 0.113501) * qSk4; qG4 = (abs(qds - 0) < 0.5) * 0.950000 + (abs(qds - 1) < 0.5) * 1.310000 + (abs(qds - 2) < 0.5) * 1.220000 + (abs(qds - 3) < 0.5) * 1.400000 + (abs(qds - 4) < 0.5) * 1.450000 + (abs(qds - 5) < 0.5) * 1.760000;\nqW5 = ((abs(qds - 0) < 0.5) * 0.116145 + (abs(qds - 1) < 0.5) * 0.668344 + (abs(qds - 2) < 0.5) * 0.030200 + (abs(qds - 3) < 0.5) * 0.266073 + (abs(qds - 4) < 0.5) * 0.035075 + (abs(qds - 5) < 0.5) * 0.077625) * qSk5; qG5 = (abs(qds - 0) < 0.5) * 0.600000 + (abs(qds - 1) < 0.5) * 1.260000 + (abs(qds - 2) < 0.5) * 1.290000 + (abs(qds - 3) < 0.5) * 1.510000 + (abs(qds - 4) < 0.5) * 1.560000 + (abs(qds - 5) < 0.5) * 1.860000;\nqW6 = ((abs(qds - 0) < 0.5) * 0.073282 + (abs(qds - 1) < 0.5) * 0.518800 + (abs(qds - 2) < 0.5) * 0.013964 + (abs(qds - 3) < 0.5) * 0.130317 + (abs(qds - 4) < 0.5) * 0.008610 + (abs(qds - 5) < 0.5) * 0.027861) * qSk6; qG6 = (abs(qds - 0) < 0.5) * 0.360000 + (abs(qds - 1) < 0.5) * 0.250000 + (abs(qds - 2) < 0.5) * 0.700000 + (abs(qds - 3) < 0.5) * 2.000000 + (abs(qds - 4) < 0.5) * 0.550000 + (abs(qds - 5) < 0.5) * 0.760000;\nqW7 = ((abs(qds - 0) < 0.5) * 0.042658 + (abs(qds - 1) < 0.5) * 0.518800 + (abs(qds - 2) < 0.5) * 0.010000 + (abs(qds - 3) < 0.5) * 0.319890 + (abs(qds - 4) < 0.5) * 0.016788 + (abs(qds - 5) < 0.5) * 0.019275) * qSk7; qG7 = (abs(qds - 0) < 0.5) * 1.000000 + (abs(qds - 1) < 0.5) * 0.250000 + (abs(qds - 2) < 0.5) * 0.500000 + (abs(qds - 3) < 0.5) * 2.000000 + (abs(qds - 4) < 0.5) * 0.620000 + (abs(qds - 5) < 0.5) * 0.450000;\nqW8 = ((abs(qds - 0) < 0.5) * 0.056885 + (abs(qds - 1) < 0.5) * 0.922571 + (abs(qds - 2) < 0.5) * 0.010715 + (abs(qds - 3) < 0.5) * 0.384592 + (abs(qds - 4) < 0.5) * 0.015668 + (abs(qds - 5) < 0.5) * 0.030903) * qSk8; qG8 = (abs(qds - 0) < 0.5) * 0.370000 + (abs(qds - 1) < 0.5) * 0.250000 + (abs(qds - 2) < 0.5) * 0.370000 + (abs(qds - 3) < 0.5) * 2.000000 + (abs(qds - 4) < 0.5) * 0.380000 + (abs(qds - 5) < 0.5) * 0.510000;\nqW9 = ((abs(qds - 0) < 0.5) * 0.079433 + (abs(qds - 1) < 0.5) * 1.000000 + (abs(qds - 2) < 0.5) * 0.012445 + (abs(qds - 3) < 0.5) * 0.785236 + (abs(qds - 4) < 0.5) * 0.020893 + (abs(qds - 5) < 0.5) * 0.024547) * qSk9; qG9 = (abs(qds - 0) < 0.5) * 1.000000 + (abs(qds - 1) < 0.5) * 0.250000 + (abs(qds - 2) < 0.5) * 0.280000 + (abs(qds - 3) < 0.5) * 2.000000 + (abs(qds - 4) < 0.5) * 0.260000 + (abs(qds - 5) < 0.5) * 0.250000;\nqW10 = ((abs(qds - 0) < 0.5) * 0.073282 + (abs(qds - 1) < 0.5) * 0.831764 + (abs(qds - 2) < 0.5) * 0.008222 + (abs(qds - 3) < 0.5) * 0.794328 + (abs(qds - 4) < 0.5) * 0.018408 + (abs(qds - 5) < 0.5) * 0.017989) * qSk10; qG10 = (abs(qds - 0) < 0.5) * 1.000000 + (abs(qds - 1) < 0.5) * 0.250000 + (abs(qds - 2) < 0.5) * 0.250000 + (abs(qds - 3) < 0.5) * 2.000000 + (abs(qds - 4) < 0.5) * 0.250000 + (abs(qds - 5) < 0.5) * 0.250000;\nqW11 = ((abs(qds - 0) < 0.5) * 0.063096 + (abs(qds - 1) < 0.5) * 0.562341 + (abs(qds - 2) < 0.5) * 0.724436 + (abs(qds - 3) < 0.5) * 0.732825 + (abs(qds - 4) < 0.5) * 0.380189 + (abs(qds - 5) < 0.5) * 0.421697) * qSk11; qG11 = (abs(qds - 0) < 0.5) * 1.000000 + (abs(qds - 1) < 0.5) * 0.250000 + (abs(qds - 2) < 0.5) * 6.000000 + (abs(qds - 3) < 0.5) * 2.000000 + (abs(qds - 4) < 0.5) * 3.000000 + (abs(qds - 5) < 0.5) * 4.000000;\nqW12 = ((abs(qds - 0) < 0.5) * 0.096605 + (abs(qds - 1) < 0.5) * 0.506991 + (abs(qds - 2) < 0.5) * 1.000000 + (abs(qds - 3) < 0.5) * 0.421697 + (abs(qds - 4) < 0.5) * 0.822243 + (abs(qds - 5) < 0.5) * 0.660693) * qSk12; qG12 = (abs(qds - 0) < 0.5) * 1.000000 + (abs(qds - 1) < 0.5) * 0.250000 + (abs(qds - 2) < 0.5) * 6.000000 + (abs(qds - 3) < 0.5) * 2.000000 + (abs(qds - 4) < 0.5) * 3.000000 + (abs(qds - 5) < 0.5) * 4.000000;\nqW13 = ((abs(qds - 0) < 0.5) * 0.101158 + (abs(qds - 1) < 0.5) * 0.512861 + (abs(qds - 2) < 0.5) * 0.512861 + (abs(qds - 3) < 0.5) * 0.060256 + (abs(qds - 4) < 0.5) * 1.000000 + (abs(qds - 5) < 0.5) * 1.000000) * qSk13; qG13 = (abs(qds - 0) < 0.5) * 1.000000 + (abs(qds - 1) < 0.5) * 0.250000 + (abs(qds - 2) < 0.5) * 6.000000 + (abs(qds - 3) < 0.5) * 2.000000 + (abs(qds - 4) < 0.5) * 3.000000 + (abs(qds - 5) < 0.5) * 4.000000;\nqkp = (abs(qds - 0) < 0.5) * 0.850000 + (abs(qds - 1) < 0.5) * 0.500000 + (abs(qds - 2) < 0.5) * 0.150000 + (abs(qds - 3) < 0.5) * 0.400000 + (abs(qds - 4) < 0.5) * 0.400000 + (abs(qds - 5) < 0.5) * 0.600000;\nqX0 = qX0 * qkp; qY0 = qY0 * qkp;\nqX1 = qX1 * qkp; qY1 = qY1 * qkp;\nqX2 = qX2 * qkp; qY2 = qY2 * qkp;\nqX3 = qX3 * qkp; qY3 = qY3 * qkp;\nqX4 = qX4 * qkp; qY4 = qY4 * qkp;\nqX5 = qX5 * qkp; qY5 = qY5 * qkp;\nqX6 = qX6 * qkp; qY6 = qY6 * qkp;\nqX7 = qX7 * qkp; qY7 = qY7 * qkp;\nqX8 = qX8 * qkp; qY8 = qY8 * qkp;\nqX9 = qX9 * qkp; qY9 = qY9 * qkp;\nqX10 = qX10 * qkp; qY10 = qY10 * qkp;\nqX11 = qX11 * qkp; qY11 = qY11 * qkp;\nqX12 = qX12 * qkp; qY12 = qY12 * qkp;\nqX13 = qX13 * qkp; qY13 = qY13 * qkp;\n}\nqE1 = qE1 + qK * (qIm - qE1); qE2 = qE2 + qK * (qE1 - qE2);\nif (ctl) {\nqC = qC * qCk;\nqw = twopi * qF1 * pf * 0.3 / samplerate; qCc0 = cos(qw); qSn0 = sin(qw); qR0 = exp(-46.051702 * (1 + (qG0 - 1) * qC) / (decayS * 1.0 * samplerate));\nqw = twopi * qF1 * pf * 0.52 / samplerate; qCc1 = cos(qw); qSn1 = sin(qw); qR1 = exp(-57.564627 * (1 + (qG1 - 1) * qC) / (decayS * 1.0 * samplerate));\nqw = twopi * qF1 * pf * 0.8 / samplerate; qCc2 = cos(qw); qSn2 = sin(qw); qR2 = exp(-27.631021 * (1 + (qG2 - 1) * qC) / (decayS * 1.0 * samplerate));\nqw = twopi * qF1 * pf * 1.0 / samplerate; qCc3 = cos(qw); qSn3 = sin(qw); qR3 = exp(-12.559555 * (1 + (qG3 - 1) * qC) / (decayS * 1.0 * samplerate));\nqw = twopi * qF1 * pf * 1.17 / samplerate; qCc4 = cos(qw); qSn4 = sin(qw); qR4 = exp(-23.025851 * (1 + (qG4 - 1) * qC) / (decayS * 1.0 * samplerate));\nqw = twopi * qF1 * pf * 1.57 / samplerate; qCc5 = cos(qw); qSn5 = sin(qw); qR5 = exp(-19.736444 * (1 + (qG5 - 1) * qC) / (decayS * 1.0 * samplerate));\nqw = twopi * qF1 * pf * 1.77 / samplerate; qCc6 = cos(qw); qSn6 = sin(qw); qR6 = exp(-27.631021 * (1 + (qG6 - 1) * qC) / (decayS * 1.0 * samplerate));\nqw = twopi * qF1 * pf * 2.06 / samplerate; qCc7 = cos(qw); qSn7 = sin(qw); qR7 = exp(-31.398888 * (1 + (qG7 - 1) * qC) / (decayS * 1.0 * samplerate));\nqw = twopi * qF1 * pf * 2.3 / samplerate; qCc8 = cos(qw); qSn8 = sin(qw); qR8 = exp(-38.376418 * (1 + (qG8 - 1) * qC) / (decayS * 1.0 * samplerate));\nqw = twopi * qF1 * pf * 2.65 / samplerate; qCc9 = cos(qw); qSn9 = sin(qw); qR9 = exp(-49.341109 * (1 + (qG9 - 1) * qC) / (decayS * 1.0 * samplerate));\nqw = twopi * qF1 * pf * 3.2 / samplerate; qCc10 = cos(qw); qSn10 = sin(qw); qR10 = exp(-69.077553 * (1 + (qG10 - 1) * qC) / (decayS * 1.0 * samplerate));\nqw = twopi * qF1 * pf * 3.9 / samplerate; qCc11 = cos(qw); qSn11 = sin(qw); qR11 = exp(-86.346941 * (1 + (qG11 - 1) * qC) / (decayS * 1.0 * samplerate));\nqw = twopi * qF1 * pf * 4.8 / samplerate; qCc12 = cos(qw); qSn12 = sin(qw); qR12 = exp(-115.129255 * (1 + (qG12 - 1) * qC) / (decayS * 1.0 * samplerate));\nqw = twopi * qF1 * pf * 6.2 / samplerate; qCc13 = cos(qw); qSn13 = sin(qw); qR13 = exp(-172.693882 * (1 + (qG13 - 1) * qC) / (decayS * 1.0 * samplerate));\n}\nqXn = qR0 * (qCc0 * qX0 - qSn0 * qY0) + qW0 * qE2; qY0 = qR0 * (qSn0 * qX0 + qCc0 * qY0); qX0 = qXn;\nqXn = qR1 * (qCc1 * qX1 - qSn1 * qY1) + qW1 * qE2; qY1 = qR1 * (qSn1 * qX1 + qCc1 * qY1); qX1 = qXn;\nqXn = qR2 * (qCc2 * qX2 - qSn2 * qY2) + qW2 * qE2; qY2 = qR2 * (qSn2 * qX2 + qCc2 * qY2); qX2 = qXn;\nqXn = qR3 * (qCc3 * qX3 - qSn3 * qY3) + qW3 * qE2; qY3 = qR3 * (qSn3 * qX3 + qCc3 * qY3); qX3 = qXn;\nqXn = qR4 * (qCc4 * qX4 - qSn4 * qY4) + qW4 * qE2; qY4 = qR4 * (qSn4 * qX4 + qCc4 * qY4); qX4 = qXn;\nqXn = qR5 * (qCc5 * qX5 - qSn5 * qY5) + qW5 * qE2; qY5 = qR5 * (qSn5 * qX5 + qCc5 * qY5); qX5 = qXn;\nqXn = qR6 * (qCc6 * qX6 - qSn6 * qY6) + qW6 * qE2; qY6 = qR6 * (qSn6 * qX6 + qCc6 * qY6); qX6 = qXn;\nqXn = qR7 * (qCc7 * qX7 - qSn7 * qY7) + qW7 * qE2; qY7 = qR7 * (qSn7 * qX7 + qCc7 * qY7); qX7 = qXn;\nqXn = qR8 * (qCc8 * qX8 - qSn8 * qY8) + qW8 * qE2; qY8 = qR8 * (qSn8 * qX8 + qCc8 * qY8); qX8 = qXn;\nqXn = qR9 * (qCc9 * qX9 - qSn9 * qY9) + qW9 * qE2; qY9 = qR9 * (qSn9 * qX9 + qCc9 * qY9); qX9 = qXn;\nqXn = qR10 * (qCc10 * qX10 - qSn10 * qY10) + qW10 * qE2; qY10 = qR10 * (qSn10 * qX10 + qCc10 * qY10); qX10 = qXn;\nqXn = qR11 * (qCc11 * qX11 - qSn11 * qY11) + qW11 * qE2; qY11 = qR11 * (qSn11 * qX11 + qCc11 * qY11); qX11 = qXn;\nqXn = qR12 * (qCc12 * qX12 - qSn12 * qY12) + qW12 * qE2; qY12 = qR12 * (qSn12 * qX12 + qCc12 * qY12); qX12 = qXn;\nqXn = qR13 * (qCc13 * qX13 - qSn13 * qY13) + qW13 * qE2; qY13 = qR13 * (qSn13 * qX13 + qCc13 * qY13); qX13 = qXn;\nqSm = qY0 + qY1 + qY2 + qY3 + qY4 + qY5 + qY6 + qY7 + qY8 + qY9 + qY10 + qY11 + qY12 + qY13;\nqNx = nz * qNe; qNe = qNe * qNr;\nqNv3 = qNx - qI2; qNb = qNa1 * qI1 + qNa2 * qNv3; qNl = qI2 + qNa2 * qI1 + qNa3 * qNv3; qI1 = 2 * qNb - qI1; qI2 = 2 * qNl - qI2;\nqOut = qSm + qNk * qNb;\nch0 = tr6 != pt6; pt6 = tr6;\nch1 = tr7 != pt7; pt7 = tr7;\nch2 = tr8 != pt8; pt8 = tr8;\nch3 = tr9 != pt9; pt9 = tr9;\nch4 = tr10 != pt10; pt10 = tr10;\nch5 = tr11 != pt11; pt11 = tr11;\nchs = ch0 + ch1 + ch2 + ch3 + ch4 + ch5;\ncdm = max(max(max(max(max(ch0 * 1, ch1 * 2), ch2 * 3), ch3 * 4), ch4 * 5), ch5 * 6);                                      // the highest stroke wins if two land in one block\ncds = cdm - 1;\ncdv = (cdm == 1) * vl6 + (cdm == 2) * vl7 + (cdm == 3) * vl8 + (cdm == 4) * vl9 + (cdm == 5) * vl10 + (cdm == 6) * vl11;\ncIm = 0;\nif (chs > 0.5) {\ncs0 = abs(cds - 0) < 0.5;\ncs1 = abs(cds - 1) < 0.5;\ncs2 = abs(cds - 2) < 0.5;\ncs3 = abs(cds - 3) < 0.5;\ncs4 = abs(cds - 4) < 0.5;\ncs5 = abs(cds - 5) < 0.5;\ncvg = pow(cdv, 1.4) * 1.000000;\ncAm = cvg * ((abs(cds - 0) < 0.5) * 0.451300 + (abs(cds - 1) < 0.5) * 0.110100 + (abs(cds - 2) < 0.5) * 0.398900 + (abs(cds - 3) < 0.5) * 0.183000 + (abs(cds - 4) < 0.5) * 0.429900 + (abs(cds - 5) < 0.5) * 0.199300);\ncIm = cAm;\ncfc = ((abs(cds - 0) < 0.5) * 3000.000000 + (abs(cds - 1) < 0.5) * 6000.000000 + (abs(cds - 2) < 0.5) * 1500.000000 + (abs(cds - 3) < 0.5) * 250.000000 + (abs(cds - 4) < 0.5) * 500.000000 + (abs(cds - 5) < 0.5) * 2000.000000) * exp2((touchG * (cdv - 0.6) * 2) + cs1 * (slapG - 1));\ncK = 1 - exp(-twopi * min(cfc, 18000) / samplerate);\ncC = 1;\ncCk = exp(-16 / (((abs(cds - 0) < 0.5) * 1.000000 + (abs(cds - 1) < 0.5) * 0.050000 + (abs(cds - 2) < 0.5) * 0.300000 + (abs(cds - 3) < 0.5) * 0.200000 + (abs(cds - 4) < 0.5) * 0.150000 + (abs(cds - 5) < 0.5) * 0.100000) * samplerate));\ncNe = cAm * 1.22 * ((abs(cds - 0) < 0.5) * 1.396100 + (abs(cds - 1) < 0.5) * 6.791300 + (abs(cds - 2) < 0.5) * 0.758200 + (abs(cds - 3) < 0.5) * 5.809700 + (abs(cds - 4) < 0.5) * 0.668000 + (abs(cds - 5) < 0.5) * 0.650200) * (1 + cs1 * (slapG * 2 - 2));\ncNr = exp(-1 / (((abs(cds - 0) < 0.5) * 0.003000 + (abs(cds - 1) < 0.5) * 0.006000 + (abs(cds - 2) < 0.5) * 0.003000 + (abs(cds - 3) < 0.5) * 0.003000 + (abs(cds - 4) < 0.5) * 0.003000 + (abs(cds - 5) < 0.5) * 0.003000) * samplerate));\ncNg = tan(pi * ((abs(cds - 0) < 0.5) * 2930.000000 + (abs(cds - 1) < 0.5) * 3700.000000 + (abs(cds - 2) < 0.5) * 3750.000000 + (abs(cds - 3) < 0.5) * 3980.000000 + (abs(cds - 4) < 0.5) * 3980.000000 + (abs(cds - 5) < 0.5) * 3330.000000) / samplerate); cNk = 1 / ((abs(cds - 0) < 0.5) * 0.350000 + (abs(cds - 1) < 0.5) * 0.350000 + (abs(cds - 2) < 0.5) * 0.350000 + (abs(cds - 3) < 0.5) * 0.350000 + (abs(cds - 4) < 0.5) * 0.350000 + (abs(cds - 5) < 0.5) * 0.350000);\ncNa1 = 1 / (1 + cNg * (cNg + cNk)); cNa2 = cNg * cNa1; cNa3 = cNg * cNa2;\ncW0 = ((abs(cds - 0) < 0.5) * 0.052481 + (abs(cds - 1) < 0.5) * 0.272270 + (abs(cds - 2) < 0.5) * 0.031261 + (abs(cds - 3) < 0.5) * 0.609537 + (abs(cds - 4) < 0.5) * 0.030200 + (abs(cds - 5) < 0.5) * 0.032734) * cSk0; cG0 = (abs(cds - 0) < 0.5) * 1.000000 + (abs(cds - 1) < 0.5) * 0.250000 + (abs(cds - 2) < 0.5) * 0.320000 + (abs(cds - 3) < 0.5) * 0.370000 + (abs(cds - 4) < 0.5) * 0.300000 + (abs(cds - 5) < 0.5) * 0.250000;\ncW1 = ((abs(cds - 0) < 0.5) * 0.056234 + (abs(cds - 1) < 0.5) * 0.638263 + (abs(cds - 2) < 0.5) * 0.072444 + (abs(cds - 3) < 0.5) * 1.000000 + (abs(cds - 4) < 0.5) * 0.043652 + (abs(cds - 5) < 0.5) * 0.063826) * cSk1; cG1 = (abs(cds - 0) < 0.5) * 0.310000 + (abs(cds - 1) < 0.5) * 0.250000 + (abs(cds - 2) < 0.5) * 0.310000 + (abs(cds - 3) < 0.5) * 0.330000 + (abs(cds - 4) < 0.5) * 0.260000 + (abs(cds - 5) < 0.5) * 0.250000;\ncW2 = ((abs(cds - 0) < 0.5) * 0.113501 + (abs(cds - 1) < 0.5) * 0.568853 + (abs(cds - 2) < 0.5) * 0.091201 + (abs(cds - 3) < 0.5) * 0.451856 + (abs(cds - 4) < 0.5) * 0.037154 + (abs(cds - 5) < 0.5) * 0.117490) * cSk2; cG2 = (abs(cds - 0) < 0.5) * 0.460000 + (abs(cds - 1) < 0.5) * 0.680000 + (abs(cds - 2) < 0.5) * 1.050000 + (abs(cds - 3) < 0.5) * 0.930000 + (abs(cds - 4) < 0.5) * 0.940000 + (abs(cds - 5) < 0.5) * 0.950000;\ncW3 = ((abs(cds - 0) < 0.5) * 1.000000 + (abs(cds - 1) < 0.5) * 0.562341 + (abs(cds - 2) < 0.5) * 0.092257 + (abs(cds - 3) < 0.5) * 0.213796 + (abs(cds - 4) < 0.5) * 0.048978 + (abs(cds - 5) < 0.5) * 0.251189) * cSk3; cG3 = (abs(cds - 0) < 0.5) * 0.990000 + (abs(cds - 1) < 0.5) * 3.760000 + (abs(cds - 2) < 0.5) * 2.750000 + (abs(cds - 3) < 0.5) * 2.740000 + (abs(cds - 4) < 0.5) * 3.160000 + (abs(cds - 5) < 0.5) * 4.710000;\ncW4 = ((abs(cds - 0) < 0.5) * 0.208930 + (abs(cds - 1) < 0.5) * 0.630957 + (abs(cds - 2) < 0.5) * 0.050119 + (abs(cds - 3) < 0.5) * 0.367282 + (abs(cds - 4) < 0.5) * 0.060256 + (abs(cds - 5) < 0.5) * 0.113501) * cSk4; cG4 = (abs(cds - 0) < 0.5) * 0.950000 + (abs(cds - 1) < 0.5) * 1.310000 + (abs(cds - 2) < 0.5) * 1.220000 + (abs(cds - 3) < 0.5) * 1.400000 + (abs(cds - 4) < 0.5) * 1.450000 + (abs(cds - 5) < 0.5) * 1.760000;\ncW5 = ((abs(cds - 0) < 0.5) * 0.116145 + (abs(cds - 1) < 0.5) * 0.668344 + (abs(cds - 2) < 0.5) * 0.030200 + (abs(cds - 3) < 0.5) * 0.266073 + (abs(cds - 4) < 0.5) * 0.035075 + (abs(cds - 5) < 0.5) * 0.077625) * cSk5; cG5 = (abs(cds - 0) < 0.5) * 0.600000 + (abs(cds - 1) < 0.5) * 1.260000 + (abs(cds - 2) < 0.5) * 1.290000 + (abs(cds - 3) < 0.5) * 1.510000 + (abs(cds - 4) < 0.5) * 1.560000 + (abs(cds - 5) < 0.5) * 1.860000;\ncW6 = ((abs(cds - 0) < 0.5) * 0.073282 + (abs(cds - 1) < 0.5) * 0.518800 + (abs(cds - 2) < 0.5) * 0.013964 + (abs(cds - 3) < 0.5) * 0.130317 + (abs(cds - 4) < 0.5) * 0.008610 + (abs(cds - 5) < 0.5) * 0.027861) * cSk6; cG6 = (abs(cds - 0) < 0.5) * 0.360000 + (abs(cds - 1) < 0.5) * 0.250000 + (abs(cds - 2) < 0.5) * 0.700000 + (abs(cds - 3) < 0.5) * 2.000000 + (abs(cds - 4) < 0.5) * 0.550000 + (abs(cds - 5) < 0.5) * 0.760000;\ncW7 = ((abs(cds - 0) < 0.5) * 0.042658 + (abs(cds - 1) < 0.5) * 0.518800 + (abs(cds - 2) < 0.5) * 0.010000 + (abs(cds - 3) < 0.5) * 0.319890 + (abs(cds - 4) < 0.5) * 0.016788 + (abs(cds - 5) < 0.5) * 0.019275) * cSk7; cG7 = (abs(cds - 0) < 0.5) * 1.000000 + (abs(cds - 1) < 0.5) * 0.250000 + (abs(cds - 2) < 0.5) * 0.500000 + (abs(cds - 3) < 0.5) * 2.000000 + (abs(cds - 4) < 0.5) * 0.620000 + (abs(cds - 5) < 0.5) * 0.450000;\ncW8 = ((abs(cds - 0) < 0.5) * 0.056885 + (abs(cds - 1) < 0.5) * 0.922571 + (abs(cds - 2) < 0.5) * 0.010715 + (abs(cds - 3) < 0.5) * 0.384592 + (abs(cds - 4) < 0.5) * 0.015668 + (abs(cds - 5) < 0.5) * 0.030903) * cSk8; cG8 = (abs(cds - 0) < 0.5) * 0.370000 + (abs(cds - 1) < 0.5) * 0.250000 + (abs(cds - 2) < 0.5) * 0.370000 + (abs(cds - 3) < 0.5) * 2.000000 + (abs(cds - 4) < 0.5) * 0.380000 + (abs(cds - 5) < 0.5) * 0.510000;\ncW9 = ((abs(cds - 0) < 0.5) * 0.079433 + (abs(cds - 1) < 0.5) * 1.000000 + (abs(cds - 2) < 0.5) * 0.012445 + (abs(cds - 3) < 0.5) * 0.785236 + (abs(cds - 4) < 0.5) * 0.020893 + (abs(cds - 5) < 0.5) * 0.024547) * cSk9; cG9 = (abs(cds - 0) < 0.5) * 1.000000 + (abs(cds - 1) < 0.5) * 0.250000 + (abs(cds - 2) < 0.5) * 0.280000 + (abs(cds - 3) < 0.5) * 2.000000 + (abs(cds - 4) < 0.5) * 0.260000 + (abs(cds - 5) < 0.5) * 0.250000;\ncW10 = ((abs(cds - 0) < 0.5) * 0.073282 + (abs(cds - 1) < 0.5) * 0.831764 + (abs(cds - 2) < 0.5) * 0.008222 + (abs(cds - 3) < 0.5) * 0.794328 + (abs(cds - 4) < 0.5) * 0.018408 + (abs(cds - 5) < 0.5) * 0.017989) * cSk10; cG10 = (abs(cds - 0) < 0.5) * 1.000000 + (abs(cds - 1) < 0.5) * 0.250000 + (abs(cds - 2) < 0.5) * 0.250000 + (abs(cds - 3) < 0.5) * 2.000000 + (abs(cds - 4) < 0.5) * 0.250000 + (abs(cds - 5) < 0.5) * 0.250000;\ncW11 = ((abs(cds - 0) < 0.5) * 0.063096 + (abs(cds - 1) < 0.5) * 0.562341 + (abs(cds - 2) < 0.5) * 0.724436 + (abs(cds - 3) < 0.5) * 0.732825 + (abs(cds - 4) < 0.5) * 0.380189 + (abs(cds - 5) < 0.5) * 0.421697) * cSk11; cG11 = (abs(cds - 0) < 0.5) * 1.000000 + (abs(cds - 1) < 0.5) * 0.250000 + (abs(cds - 2) < 0.5) * 6.000000 + (abs(cds - 3) < 0.5) * 2.000000 + (abs(cds - 4) < 0.5) * 3.000000 + (abs(cds - 5) < 0.5) * 4.000000;\ncW12 = ((abs(cds - 0) < 0.5) * 0.096605 + (abs(cds - 1) < 0.5) * 0.506991 + (abs(cds - 2) < 0.5) * 1.000000 + (abs(cds - 3) < 0.5) * 0.421697 + (abs(cds - 4) < 0.5) * 0.822243 + (abs(cds - 5) < 0.5) * 0.660693) * cSk12; cG12 = (abs(cds - 0) < 0.5) * 1.000000 + (abs(cds - 1) < 0.5) * 0.250000 + (abs(cds - 2) < 0.5) * 6.000000 + (abs(cds - 3) < 0.5) * 2.000000 + (abs(cds - 4) < 0.5) * 3.000000 + (abs(cds - 5) < 0.5) * 4.000000;\ncW13 = ((abs(cds - 0) < 0.5) * 0.101158 + (abs(cds - 1) < 0.5) * 0.512861 + (abs(cds - 2) < 0.5) * 0.512861 + (abs(cds - 3) < 0.5) * 0.060256 + (abs(cds - 4) < 0.5) * 1.000000 + (abs(cds - 5) < 0.5) * 1.000000) * cSk13; cG13 = (abs(cds - 0) < 0.5) * 1.000000 + (abs(cds - 1) < 0.5) * 0.250000 + (abs(cds - 2) < 0.5) * 6.000000 + (abs(cds - 3) < 0.5) * 2.000000 + (abs(cds - 4) < 0.5) * 3.000000 + (abs(cds - 5) < 0.5) * 4.000000;\nckp = (abs(cds - 0) < 0.5) * 0.850000 + (abs(cds - 1) < 0.5) * 0.500000 + (abs(cds - 2) < 0.5) * 0.150000 + (abs(cds - 3) < 0.5) * 0.400000 + (abs(cds - 4) < 0.5) * 0.400000 + (abs(cds - 5) < 0.5) * 0.600000;\ncX0 = cX0 * ckp; cY0 = cY0 * ckp;\ncX1 = cX1 * ckp; cY1 = cY1 * ckp;\ncX2 = cX2 * ckp; cY2 = cY2 * ckp;\ncX3 = cX3 * ckp; cY3 = cY3 * ckp;\ncX4 = cX4 * ckp; cY4 = cY4 * ckp;\ncX5 = cX5 * ckp; cY5 = cY5 * ckp;\ncX6 = cX6 * ckp; cY6 = cY6 * ckp;\ncX7 = cX7 * ckp; cY7 = cY7 * ckp;\ncX8 = cX8 * ckp; cY8 = cY8 * ckp;\ncX9 = cX9 * ckp; cY9 = cY9 * ckp;\ncX10 = cX10 * ckp; cY10 = cY10 * ckp;\ncX11 = cX11 * ckp; cY11 = cY11 * ckp;\ncX12 = cX12 * ckp; cY12 = cY12 * ckp;\ncX13 = cX13 * ckp; cY13 = cY13 * ckp;\n}\ncE1 = cE1 + cK * (cIm - cE1); cE2 = cE2 + cK * (cE1 - cE2);\nif (ctl) {\ncC = cC * cCk;\ncw = twopi * cF1 * pf * 0.3 / samplerate; cCc0 = cos(cw); cSn0 = sin(cw); cR0 = exp(-46.051702 * (1 + (cG0 - 1) * cC) / (decayS * 1.0 * samplerate));\ncw = twopi * cF1 * pf * 0.52 / samplerate; cCc1 = cos(cw); cSn1 = sin(cw); cR1 = exp(-57.564627 * (1 + (cG1 - 1) * cC) / (decayS * 1.0 * samplerate));\ncw = twopi * cF1 * pf * 0.8 / samplerate; cCc2 = cos(cw); cSn2 = sin(cw); cR2 = exp(-27.631021 * (1 + (cG2 - 1) * cC) / (decayS * 1.0 * samplerate));\ncw = twopi * cF1 * pf * 1.0 / samplerate; cCc3 = cos(cw); cSn3 = sin(cw); cR3 = exp(-12.559555 * (1 + (cG3 - 1) * cC) / (decayS * 1.0 * samplerate));\ncw = twopi * cF1 * pf * 1.17 / samplerate; cCc4 = cos(cw); cSn4 = sin(cw); cR4 = exp(-23.025851 * (1 + (cG4 - 1) * cC) / (decayS * 1.0 * samplerate));\ncw = twopi * cF1 * pf * 1.57 / samplerate; cCc5 = cos(cw); cSn5 = sin(cw); cR5 = exp(-19.736444 * (1 + (cG5 - 1) * cC) / (decayS * 1.0 * samplerate));\ncw = twopi * cF1 * pf * 1.77 / samplerate; cCc6 = cos(cw); cSn6 = sin(cw); cR6 = exp(-27.631021 * (1 + (cG6 - 1) * cC) / (decayS * 1.0 * samplerate));\ncw = twopi * cF1 * pf * 2.06 / samplerate; cCc7 = cos(cw); cSn7 = sin(cw); cR7 = exp(-31.398888 * (1 + (cG7 - 1) * cC) / (decayS * 1.0 * samplerate));\ncw = twopi * cF1 * pf * 2.3 / samplerate; cCc8 = cos(cw); cSn8 = sin(cw); cR8 = exp(-38.376418 * (1 + (cG8 - 1) * cC) / (decayS * 1.0 * samplerate));\ncw = twopi * cF1 * pf * 2.65 / samplerate; cCc9 = cos(cw); cSn9 = sin(cw); cR9 = exp(-49.341109 * (1 + (cG9 - 1) * cC) / (decayS * 1.0 * samplerate));\ncw = twopi * cF1 * pf * 3.2 / samplerate; cCc10 = cos(cw); cSn10 = sin(cw); cR10 = exp(-69.077553 * (1 + (cG10 - 1) * cC) / (decayS * 1.0 * samplerate));\ncw = twopi * cF1 * pf * 3.9 / samplerate; cCc11 = cos(cw); cSn11 = sin(cw); cR11 = exp(-86.346941 * (1 + (cG11 - 1) * cC) / (decayS * 1.0 * samplerate));\ncw = twopi * cF1 * pf * 4.8 / samplerate; cCc12 = cos(cw); cSn12 = sin(cw); cR12 = exp(-115.129255 * (1 + (cG12 - 1) * cC) / (decayS * 1.0 * samplerate));\ncw = twopi * cF1 * pf * 6.2 / samplerate; cCc13 = cos(cw); cSn13 = sin(cw); cR13 = exp(-172.693882 * (1 + (cG13 - 1) * cC) / (decayS * 1.0 * samplerate));\n}\ncXn = cR0 * (cCc0 * cX0 - cSn0 * cY0) + cW0 * cE2; cY0 = cR0 * (cSn0 * cX0 + cCc0 * cY0); cX0 = cXn;\ncXn = cR1 * (cCc1 * cX1 - cSn1 * cY1) + cW1 * cE2; cY1 = cR1 * (cSn1 * cX1 + cCc1 * cY1); cX1 = cXn;\ncXn = cR2 * (cCc2 * cX2 - cSn2 * cY2) + cW2 * cE2; cY2 = cR2 * (cSn2 * cX2 + cCc2 * cY2); cX2 = cXn;\ncXn = cR3 * (cCc3 * cX3 - cSn3 * cY3) + cW3 * cE2; cY3 = cR3 * (cSn3 * cX3 + cCc3 * cY3); cX3 = cXn;\ncXn = cR4 * (cCc4 * cX4 - cSn4 * cY4) + cW4 * cE2; cY4 = cR4 * (cSn4 * cX4 + cCc4 * cY4); cX4 = cXn;\ncXn = cR5 * (cCc5 * cX5 - cSn5 * cY5) + cW5 * cE2; cY5 = cR5 * (cSn5 * cX5 + cCc5 * cY5); cX5 = cXn;\ncXn = cR6 * (cCc6 * cX6 - cSn6 * cY6) + cW6 * cE2; cY6 = cR6 * (cSn6 * cX6 + cCc6 * cY6); cX6 = cXn;\ncXn = cR7 * (cCc7 * cX7 - cSn7 * cY7) + cW7 * cE2; cY7 = cR7 * (cSn7 * cX7 + cCc7 * cY7); cX7 = cXn;\ncXn = cR8 * (cCc8 * cX8 - cSn8 * cY8) + cW8 * cE2; cY8 = cR8 * (cSn8 * cX8 + cCc8 * cY8); cX8 = cXn;\ncXn = cR9 * (cCc9 * cX9 - cSn9 * cY9) + cW9 * cE2; cY9 = cR9 * (cSn9 * cX9 + cCc9 * cY9); cX9 = cXn;\ncXn = cR10 * (cCc10 * cX10 - cSn10 * cY10) + cW10 * cE2; cY10 = cR10 * (cSn10 * cX10 + cCc10 * cY10); cX10 = cXn;\ncXn = cR11 * (cCc11 * cX11 - cSn11 * cY11) + cW11 * cE2; cY11 = cR11 * (cSn11 * cX11 + cCc11 * cY11); cX11 = cXn;\ncXn = cR12 * (cCc12 * cX12 - cSn12 * cY12) + cW12 * cE2; cY12 = cR12 * (cSn12 * cX12 + cCc12 * cY12); cX12 = cXn;\ncXn = cR13 * (cCc13 * cX13 - cSn13 * cY13) + cW13 * cE2; cY13 = cR13 * (cSn13 * cX13 + cCc13 * cY13); cX13 = cXn;\ncSm = cY0 + cY1 + cY2 + cY3 + cY4 + cY5 + cY6 + cY7 + cY8 + cY9 + cY10 + cY11 + cY12 + cY13;\ncNx = nz * cNe; cNe = cNe * cNr;\ncNv3 = cNx - cI2; cNb = cNa1 * cI1 + cNa2 * cNv3; cNl = cI2 + cNa2 * cI1 + cNa3 * cNv3; cI1 = 2 * cNb - cI1; cI2 = 2 * cNl - cI2;\ncOut = cSm + cNk * cNb;\nth0 = tr12 != pt12; pt12 = tr12;\nth1 = tr13 != pt13; pt13 = tr13;\nth2 = tr14 != pt14; pt14 = tr14;\nth3 = tr15 != pt15; pt15 = tr15;\nth4 = tr16 != pt16; pt16 = tr16;\nth5 = tr17 != pt17; pt17 = tr17;\nths = th0 + th1 + th2 + th3 + th4 + th5;\ntdm = max(max(max(max(max(th0 * 1, th1 * 2), th2 * 3), th3 * 4), th4 * 5), th5 * 6);                                      // the highest stroke wins if two land in one block\ntds = tdm - 1;\ntdv = (tdm == 1) * vl12 + (tdm == 2) * vl13 + (tdm == 3) * vl14 + (tdm == 4) * vl15 + (tdm == 5) * vl16 + (tdm == 6) * vl17;\ntIm = 0;\nif (ths > 0.5) {\nts0 = abs(tds - 0) < 0.5;\nts1 = abs(tds - 1) < 0.5;\nts2 = abs(tds - 2) < 0.5;\nts3 = abs(tds - 3) < 0.5;\nts4 = abs(tds - 4) < 0.5;\nts5 = abs(tds - 5) < 0.5;\ntvg = pow(tdv, 1.4) * 1.000000;\ntAm = tvg * ((abs(tds - 0) < 0.5) * 0.555200 + (abs(tds - 1) < 0.5) * 0.146200 + (abs(tds - 2) < 0.5) * 0.415300 + (abs(tds - 3) < 0.5) * 0.283700 + (abs(tds - 4) < 0.5) * 0.492000 + (abs(tds - 5) < 0.5) * 0.203200);\ntIm = tAm;\ntfc = ((abs(tds - 0) < 0.5) * 3000.000000 + (abs(tds - 1) < 0.5) * 6000.000000 + (abs(tds - 2) < 0.5) * 1500.000000 + (abs(tds - 3) < 0.5) * 250.000000 + (abs(tds - 4) < 0.5) * 500.000000 + (abs(tds - 5) < 0.5) * 2000.000000) * exp2((touchG * (tdv - 0.6) * 2) + ts1 * (slapG - 1));\ntK = 1 - exp(-twopi * min(tfc, 18000) / samplerate);\ntC = 1;\ntCk = exp(-16 / (((abs(tds - 0) < 0.5) * 1.000000 + (abs(tds - 1) < 0.5) * 0.050000 + (abs(tds - 2) < 0.5) * 0.300000 + (abs(tds - 3) < 0.5) * 0.200000 + (abs(tds - 4) < 0.5) * 0.150000 + (abs(tds - 5) < 0.5) * 0.100000) * samplerate));\ntNe = tAm * 0.62 * ((abs(tds - 0) < 0.5) * 1.396100 + (abs(tds - 1) < 0.5) * 6.791300 + (abs(tds - 2) < 0.5) * 0.758200 + (abs(tds - 3) < 0.5) * 5.809700 + (abs(tds - 4) < 0.5) * 0.668000 + (abs(tds - 5) < 0.5) * 0.650200) * (1 + ts1 * (slapG * 2 - 2));\ntNr = exp(-1 / (((abs(tds - 0) < 0.5) * 0.003000 + (abs(tds - 1) < 0.5) * 0.006000 + (abs(tds - 2) < 0.5) * 0.003000 + (abs(tds - 3) < 0.5) * 0.003000 + (abs(tds - 4) < 0.5) * 0.003000 + (abs(tds - 5) < 0.5) * 0.003000) * samplerate));\ntNg = tan(pi * ((abs(tds - 0) < 0.5) * 2930.000000 + (abs(tds - 1) < 0.5) * 3700.000000 + (abs(tds - 2) < 0.5) * 3750.000000 + (abs(tds - 3) < 0.5) * 3980.000000 + (abs(tds - 4) < 0.5) * 3980.000000 + (abs(tds - 5) < 0.5) * 3330.000000) / samplerate); tNk = 1 / ((abs(tds - 0) < 0.5) * 0.350000 + (abs(tds - 1) < 0.5) * 0.350000 + (abs(tds - 2) < 0.5) * 0.350000 + (abs(tds - 3) < 0.5) * 0.350000 + (abs(tds - 4) < 0.5) * 0.350000 + (abs(tds - 5) < 0.5) * 0.350000);\ntNa1 = 1 / (1 + tNg * (tNg + tNk)); tNa2 = tNg * tNa1; tNa3 = tNg * tNa2;\ntW0 = ((abs(tds - 0) < 0.5) * 0.052481 + (abs(tds - 1) < 0.5) * 0.272270 + (abs(tds - 2) < 0.5) * 0.031261 + (abs(tds - 3) < 0.5) * 0.609537 + (abs(tds - 4) < 0.5) * 0.030200 + (abs(tds - 5) < 0.5) * 0.032734) * tSk0; tG0 = (abs(tds - 0) < 0.5) * 1.000000 + (abs(tds - 1) < 0.5) * 0.250000 + (abs(tds - 2) < 0.5) * 0.320000 + (abs(tds - 3) < 0.5) * 0.370000 + (abs(tds - 4) < 0.5) * 0.300000 + (abs(tds - 5) < 0.5) * 0.250000;\ntW1 = ((abs(tds - 0) < 0.5) * 0.056234 + (abs(tds - 1) < 0.5) * 0.638263 + (abs(tds - 2) < 0.5) * 0.072444 + (abs(tds - 3) < 0.5) * 1.000000 + (abs(tds - 4) < 0.5) * 0.043652 + (abs(tds - 5) < 0.5) * 0.063826) * tSk1; tG1 = (abs(tds - 0) < 0.5) * 0.310000 + (abs(tds - 1) < 0.5) * 0.250000 + (abs(tds - 2) < 0.5) * 0.310000 + (abs(tds - 3) < 0.5) * 0.330000 + (abs(tds - 4) < 0.5) * 0.260000 + (abs(tds - 5) < 0.5) * 0.250000;\ntW2 = ((abs(tds - 0) < 0.5) * 0.113501 + (abs(tds - 1) < 0.5) * 0.568853 + (abs(tds - 2) < 0.5) * 0.091201 + (abs(tds - 3) < 0.5) * 0.451856 + (abs(tds - 4) < 0.5) * 0.037154 + (abs(tds - 5) < 0.5) * 0.117490) * tSk2; tG2 = (abs(tds - 0) < 0.5) * 0.460000 + (abs(tds - 1) < 0.5) * 0.680000 + (abs(tds - 2) < 0.5) * 1.050000 + (abs(tds - 3) < 0.5) * 0.930000 + (abs(tds - 4) < 0.5) * 0.940000 + (abs(tds - 5) < 0.5) * 0.950000;\ntW3 = ((abs(tds - 0) < 0.5) * 1.000000 + (abs(tds - 1) < 0.5) * 0.562341 + (abs(tds - 2) < 0.5) * 0.092257 + (abs(tds - 3) < 0.5) * 0.213796 + (abs(tds - 4) < 0.5) * 0.048978 + (abs(tds - 5) < 0.5) * 0.251189) * tSk3; tG3 = (abs(tds - 0) < 0.5) * 0.990000 + (abs(tds - 1) < 0.5) * 3.760000 + (abs(tds - 2) < 0.5) * 2.750000 + (abs(tds - 3) < 0.5) * 2.740000 + (abs(tds - 4) < 0.5) * 3.160000 + (abs(tds - 5) < 0.5) * 4.710000;\ntW4 = ((abs(tds - 0) < 0.5) * 0.208930 + (abs(tds - 1) < 0.5) * 0.630957 + (abs(tds - 2) < 0.5) * 0.050119 + (abs(tds - 3) < 0.5) * 0.367282 + (abs(tds - 4) < 0.5) * 0.060256 + (abs(tds - 5) < 0.5) * 0.113501) * tSk4; tG4 = (abs(tds - 0) < 0.5) * 0.950000 + (abs(tds - 1) < 0.5) * 1.310000 + (abs(tds - 2) < 0.5) * 1.220000 + (abs(tds - 3) < 0.5) * 1.400000 + (abs(tds - 4) < 0.5) * 1.450000 + (abs(tds - 5) < 0.5) * 1.760000;\ntW5 = ((abs(tds - 0) < 0.5) * 0.116145 + (abs(tds - 1) < 0.5) * 0.668344 + (abs(tds - 2) < 0.5) * 0.030200 + (abs(tds - 3) < 0.5) * 0.266073 + (abs(tds - 4) < 0.5) * 0.035075 + (abs(tds - 5) < 0.5) * 0.077625) * tSk5; tG5 = (abs(tds - 0) < 0.5) * 0.600000 + (abs(tds - 1) < 0.5) * 1.260000 + (abs(tds - 2) < 0.5) * 1.290000 + (abs(tds - 3) < 0.5) * 1.510000 + (abs(tds - 4) < 0.5) * 1.560000 + (abs(tds - 5) < 0.5) * 1.860000;\ntW6 = ((abs(tds - 0) < 0.5) * 0.073282 + (abs(tds - 1) < 0.5) * 0.518800 + (abs(tds - 2) < 0.5) * 0.013964 + (abs(tds - 3) < 0.5) * 0.130317 + (abs(tds - 4) < 0.5) * 0.008610 + (abs(tds - 5) < 0.5) * 0.027861) * tSk6; tG6 = (abs(tds - 0) < 0.5) * 0.360000 + (abs(tds - 1) < 0.5) * 0.250000 + (abs(tds - 2) < 0.5) * 0.700000 + (abs(tds - 3) < 0.5) * 2.000000 + (abs(tds - 4) < 0.5) * 0.550000 + (abs(tds - 5) < 0.5) * 0.760000;\ntW7 = ((abs(tds - 0) < 0.5) * 0.042658 + (abs(tds - 1) < 0.5) * 0.518800 + (abs(tds - 2) < 0.5) * 0.010000 + (abs(tds - 3) < 0.5) * 0.319890 + (abs(tds - 4) < 0.5) * 0.016788 + (abs(tds - 5) < 0.5) * 0.019275) * tSk7; tG7 = (abs(tds - 0) < 0.5) * 1.000000 + (abs(tds - 1) < 0.5) * 0.250000 + (abs(tds - 2) < 0.5) * 0.500000 + (abs(tds - 3) < 0.5) * 2.000000 + (abs(tds - 4) < 0.5) * 0.620000 + (abs(tds - 5) < 0.5) * 0.450000;\ntW8 = ((abs(tds - 0) < 0.5) * 0.056885 + (abs(tds - 1) < 0.5) * 0.922571 + (abs(tds - 2) < 0.5) * 0.010715 + (abs(tds - 3) < 0.5) * 0.384592 + (abs(tds - 4) < 0.5) * 0.015668 + (abs(tds - 5) < 0.5) * 0.030903) * tSk8; tG8 = (abs(tds - 0) < 0.5) * 0.370000 + (abs(tds - 1) < 0.5) * 0.250000 + (abs(tds - 2) < 0.5) * 0.370000 + (abs(tds - 3) < 0.5) * 2.000000 + (abs(tds - 4) < 0.5) * 0.380000 + (abs(tds - 5) < 0.5) * 0.510000;\ntW9 = ((abs(tds - 0) < 0.5) * 0.079433 + (abs(tds - 1) < 0.5) * 1.000000 + (abs(tds - 2) < 0.5) * 0.012445 + (abs(tds - 3) < 0.5) * 0.785236 + (abs(tds - 4) < 0.5) * 0.020893 + (abs(tds - 5) < 0.5) * 0.024547) * tSk9; tG9 = (abs(tds - 0) < 0.5) * 1.000000 + (abs(tds - 1) < 0.5) * 0.250000 + (abs(tds - 2) < 0.5) * 0.280000 + (abs(tds - 3) < 0.5) * 2.000000 + (abs(tds - 4) < 0.5) * 0.260000 + (abs(tds - 5) < 0.5) * 0.250000;\ntW10 = ((abs(tds - 0) < 0.5) * 0.073282 + (abs(tds - 1) < 0.5) * 0.831764 + (abs(tds - 2) < 0.5) * 0.008222 + (abs(tds - 3) < 0.5) * 0.794328 + (abs(tds - 4) < 0.5) * 0.018408 + (abs(tds - 5) < 0.5) * 0.017989) * tSk10; tG10 = (abs(tds - 0) < 0.5) * 1.000000 + (abs(tds - 1) < 0.5) * 0.250000 + (abs(tds - 2) < 0.5) * 0.250000 + (abs(tds - 3) < 0.5) * 2.000000 + (abs(tds - 4) < 0.5) * 0.250000 + (abs(tds - 5) < 0.5) * 0.250000;\ntW11 = ((abs(tds - 0) < 0.5) * 0.063096 + (abs(tds - 1) < 0.5) * 0.562341 + (abs(tds - 2) < 0.5) * 0.724436 + (abs(tds - 3) < 0.5) * 0.732825 + (abs(tds - 4) < 0.5) * 0.380189 + (abs(tds - 5) < 0.5) * 0.421697) * tSk11; tG11 = (abs(tds - 0) < 0.5) * 1.000000 + (abs(tds - 1) < 0.5) * 0.250000 + (abs(tds - 2) < 0.5) * 6.000000 + (abs(tds - 3) < 0.5) * 2.000000 + (abs(tds - 4) < 0.5) * 3.000000 + (abs(tds - 5) < 0.5) * 4.000000;\ntW12 = ((abs(tds - 0) < 0.5) * 0.096605 + (abs(tds - 1) < 0.5) * 0.506991 + (abs(tds - 2) < 0.5) * 1.000000 + (abs(tds - 3) < 0.5) * 0.421697 + (abs(tds - 4) < 0.5) * 0.822243 + (abs(tds - 5) < 0.5) * 0.660693) * tSk12; tG12 = (abs(tds - 0) < 0.5) * 1.000000 + (abs(tds - 1) < 0.5) * 0.250000 + (abs(tds - 2) < 0.5) * 6.000000 + (abs(tds - 3) < 0.5) * 2.000000 + (abs(tds - 4) < 0.5) * 3.000000 + (abs(tds - 5) < 0.5) * 4.000000;\ntW13 = ((abs(tds - 0) < 0.5) * 0.101158 + (abs(tds - 1) < 0.5) * 0.512861 + (abs(tds - 2) < 0.5) * 0.512861 + (abs(tds - 3) < 0.5) * 0.060256 + (abs(tds - 4) < 0.5) * 1.000000 + (abs(tds - 5) < 0.5) * 1.000000) * tSk13; tG13 = (abs(tds - 0) < 0.5) * 1.000000 + (abs(tds - 1) < 0.5) * 0.250000 + (abs(tds - 2) < 0.5) * 6.000000 + (abs(tds - 3) < 0.5) * 2.000000 + (abs(tds - 4) < 0.5) * 3.000000 + (abs(tds - 5) < 0.5) * 4.000000;\ntkp = (abs(tds - 0) < 0.5) * 0.850000 + (abs(tds - 1) < 0.5) * 0.500000 + (abs(tds - 2) < 0.5) * 0.150000 + (abs(tds - 3) < 0.5) * 0.400000 + (abs(tds - 4) < 0.5) * 0.400000 + (abs(tds - 5) < 0.5) * 0.600000;\ntX0 = tX0 * tkp; tY0 = tY0 * tkp;\ntX1 = tX1 * tkp; tY1 = tY1 * tkp;\ntX2 = tX2 * tkp; tY2 = tY2 * tkp;\ntX3 = tX3 * tkp; tY3 = tY3 * tkp;\ntX4 = tX4 * tkp; tY4 = tY4 * tkp;\ntX5 = tX5 * tkp; tY5 = tY5 * tkp;\ntX6 = tX6 * tkp; tY6 = tY6 * tkp;\ntX7 = tX7 * tkp; tY7 = tY7 * tkp;\ntX8 = tX8 * tkp; tY8 = tY8 * tkp;\ntX9 = tX9 * tkp; tY9 = tY9 * tkp;\ntX10 = tX10 * tkp; tY10 = tY10 * tkp;\ntX11 = tX11 * tkp; tY11 = tY11 * tkp;\ntX12 = tX12 * tkp; tY12 = tY12 * tkp;\ntX13 = tX13 * tkp; tY13 = tY13 * tkp;\n}\ntE1 = tE1 + tK * (tIm - tE1); tE2 = tE2 + tK * (tE1 - tE2);\nif (ctl) {\ntC = tC * tCk;\ntw = twopi * tF1 * pf * 0.3 / samplerate; tCc0 = cos(tw); tSn0 = sin(tw); tR0 = exp(-46.051702 * (1 + (tG0 - 1) * tC) / (decayS * 1.0 * samplerate));\ntw = twopi * tF1 * pf * 0.52 / samplerate; tCc1 = cos(tw); tSn1 = sin(tw); tR1 = exp(-57.564627 * (1 + (tG1 - 1) * tC) / (decayS * 1.0 * samplerate));\ntw = twopi * tF1 * pf * 0.8 / samplerate; tCc2 = cos(tw); tSn2 = sin(tw); tR2 = exp(-27.631021 * (1 + (tG2 - 1) * tC) / (decayS * 1.0 * samplerate));\ntw = twopi * tF1 * pf * 1.0 / samplerate; tCc3 = cos(tw); tSn3 = sin(tw); tR3 = exp(-12.559555 * (1 + (tG3 - 1) * tC) / (decayS * 1.0 * samplerate));\ntw = twopi * tF1 * pf * 1.17 / samplerate; tCc4 = cos(tw); tSn4 = sin(tw); tR4 = exp(-23.025851 * (1 + (tG4 - 1) * tC) / (decayS * 1.0 * samplerate));\ntw = twopi * tF1 * pf * 1.57 / samplerate; tCc5 = cos(tw); tSn5 = sin(tw); tR5 = exp(-19.736444 * (1 + (tG5 - 1) * tC) / (decayS * 1.0 * samplerate));\ntw = twopi * tF1 * pf * 1.77 / samplerate; tCc6 = cos(tw); tSn6 = sin(tw); tR6 = exp(-27.631021 * (1 + (tG6 - 1) * tC) / (decayS * 1.0 * samplerate));\ntw = twopi * tF1 * pf * 2.06 / samplerate; tCc7 = cos(tw); tSn7 = sin(tw); tR7 = exp(-31.398888 * (1 + (tG7 - 1) * tC) / (decayS * 1.0 * samplerate));\ntw = twopi * tF1 * pf * 2.3 / samplerate; tCc8 = cos(tw); tSn8 = sin(tw); tR8 = exp(-38.376418 * (1 + (tG8 - 1) * tC) / (decayS * 1.0 * samplerate));\ntw = twopi * tF1 * pf * 2.65 / samplerate; tCc9 = cos(tw); tSn9 = sin(tw); tR9 = exp(-49.341109 * (1 + (tG9 - 1) * tC) / (decayS * 1.0 * samplerate));\ntw = twopi * tF1 * pf * 3.2 / samplerate; tCc10 = cos(tw); tSn10 = sin(tw); tR10 = exp(-69.077553 * (1 + (tG10 - 1) * tC) / (decayS * 1.0 * samplerate));\ntw = twopi * tF1 * pf * 3.9 / samplerate; tCc11 = cos(tw); tSn11 = sin(tw); tR11 = exp(-86.346941 * (1 + (tG11 - 1) * tC) / (decayS * 1.0 * samplerate));\ntw = twopi * tF1 * pf * 4.8 / samplerate; tCc12 = cos(tw); tSn12 = sin(tw); tR12 = exp(-115.129255 * (1 + (tG12 - 1) * tC) / (decayS * 1.0 * samplerate));\ntw = twopi * tF1 * pf * 6.2 / samplerate; tCc13 = cos(tw); tSn13 = sin(tw); tR13 = exp(-172.693882 * (1 + (tG13 - 1) * tC) / (decayS * 1.0 * samplerate));\n}\ntXn = tR0 * (tCc0 * tX0 - tSn0 * tY0) + tW0 * tE2; tY0 = tR0 * (tSn0 * tX0 + tCc0 * tY0); tX0 = tXn;\ntXn = tR1 * (tCc1 * tX1 - tSn1 * tY1) + tW1 * tE2; tY1 = tR1 * (tSn1 * tX1 + tCc1 * tY1); tX1 = tXn;\ntXn = tR2 * (tCc2 * tX2 - tSn2 * tY2) + tW2 * tE2; tY2 = tR2 * (tSn2 * tX2 + tCc2 * tY2); tX2 = tXn;\ntXn = tR3 * (tCc3 * tX3 - tSn3 * tY3) + tW3 * tE2; tY3 = tR3 * (tSn3 * tX3 + tCc3 * tY3); tX3 = tXn;\ntXn = tR4 * (tCc4 * tX4 - tSn4 * tY4) + tW4 * tE2; tY4 = tR4 * (tSn4 * tX4 + tCc4 * tY4); tX4 = tXn;\ntXn = tR5 * (tCc5 * tX5 - tSn5 * tY5) + tW5 * tE2; tY5 = tR5 * (tSn5 * tX5 + tCc5 * tY5); tX5 = tXn;\ntXn = tR6 * (tCc6 * tX6 - tSn6 * tY6) + tW6 * tE2; tY6 = tR6 * (tSn6 * tX6 + tCc6 * tY6); tX6 = tXn;\ntXn = tR7 * (tCc7 * tX7 - tSn7 * tY7) + tW7 * tE2; tY7 = tR7 * (tSn7 * tX7 + tCc7 * tY7); tX7 = tXn;\ntXn = tR8 * (tCc8 * tX8 - tSn8 * tY8) + tW8 * tE2; tY8 = tR8 * (tSn8 * tX8 + tCc8 * tY8); tX8 = tXn;\ntXn = tR9 * (tCc9 * tX9 - tSn9 * tY9) + tW9 * tE2; tY9 = tR9 * (tSn9 * tX9 + tCc9 * tY9); tX9 = tXn;\ntXn = tR10 * (tCc10 * tX10 - tSn10 * tY10) + tW10 * tE2; tY10 = tR10 * (tSn10 * tX10 + tCc10 * tY10); tX10 = tXn;\ntXn = tR11 * (tCc11 * tX11 - tSn11 * tY11) + tW11 * tE2; tY11 = tR11 * (tSn11 * tX11 + tCc11 * tY11); tX11 = tXn;\ntXn = tR12 * (tCc12 * tX12 - tSn12 * tY12) + tW12 * tE2; tY12 = tR12 * (tSn12 * tX12 + tCc12 * tY12); tX12 = tXn;\ntXn = tR13 * (tCc13 * tX13 - tSn13 * tY13) + tW13 * tE2; tY13 = tR13 * (tSn13 * tX13 + tCc13 * tY13); tX13 = tXn;\ntSm = tY0 + tY1 + tY2 + tY3 + tY4 + tY5 + tY6 + tY7 + tY8 + tY9 + tY10 + tY11 + tY12 + tY13;\ntNx = nz * tNe; tNe = tNe * tNr;\ntNv3 = tNx - tI2; tNb = tNa1 * tI1 + tNa2 * tNv3; tNl = tI2 + tNa2 * tI1 + tNa3 * tNv3; tI1 = 2 * tNb - tI1; tI2 = 2 * tNl - tI2;\ntOut = tSm + tNk * tNb;\nmixl = (qOut * qGl + cOut * cGl + tOut * tGl) * masterG; mixr = (qOut * qGr + cOut * cGr + tOut * tGr) * masterG;\naxl = abs(mixl); out1 = sign(mixl) * (min(axl, 0.8) + 0.2 * tanh(max(axl - 0.8, 0) * 5)) + 0 * in1;\naxr = abs(mixr); out2 = sign(mixr) * (min(axr, 0.8) + 0.2 * tanh(max(axr - 0.8, 0) * 5)) + 0 * in2;\n",
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
						280.0,
						108.0
					],
					"patching_rect": [
						1690,
						20,
						280,
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
						"tuneT",
						0
					],
					"destination": [
						"pre_tuneT",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_tuneT",
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
						"tuneT",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"tuneC",
						0
					],
					"destination": [
						"pre_tuneC",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_tuneC",
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
						"tuneC",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"tuneQ",
						0
					],
					"destination": [
						"pre_tuneQ",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_tuneQ",
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
						"tuneQ",
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
						"skin",
						0
					],
					"destination": [
						"pre_skin",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_skin",
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
						"skin",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"slap",
						0
					],
					"destination": [
						"pre_slap",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_slap",
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
						"slap",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"shell",
						0
					],
					"destination": [
						"pre_shell",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_shell",
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
						"shell",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"touch",
						0
					],
					"destination": [
						"pre_touch",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_touch",
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
						"touch",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"press",
						0
					],
					"destination": [
						"pre_press",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_press",
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
						"press",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"spread",
						0
					],
					"destination": [
						"pre_spread",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_spread",
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
						"spread",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"level",
						0
					],
					"destination": [
						"pre_level",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_level",
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
						"level",
						0
					]
				}
			}
		],
		"dependency_cache": [],
		"autosave": 0,
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