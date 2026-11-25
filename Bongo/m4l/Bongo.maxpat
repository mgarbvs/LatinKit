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
		"description": "Bongo: one bongo drum (Macho or Hembra; open, open 3F, slap, heel, tip, rim or flam) as a modal head model fitted to recordings, for Drum Rack pads.",
		"boxes": [
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
					"text": "js bongo_push.js",
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
					"text": "prepend volume",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						1160,
						98,
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
						120.0,
						116.0,
						60.0,
						50.0
					],
					"patching_rect": [
						2050,
						340,
						60,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_vary",
					"maxclass": "newobj",
					"text": "prepend vary",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						1100,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_vary",
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
						96.0,
						52.0,
						13.0
					],
					"patching_rect": [
						1870,
						340,
						52,
						13
					]
				}
			},
			{
				"box": {
					"id": "vary",
					"varname": "vary",
					"parameter_enable": 1,
					"annotation_name": "Vary",
					"annotation": "How much every hit differs from the last: the loudness of each of the drum's tones is nudged at random at every hit (about 1.5 dB at 100 %), as no two real strokes are the same. 0 plays the same hit every time.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Vary",
							"parameter_shortname": "Vary",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								100
							],
							"parameter_unitstyle": 9,
							"parameter_units": "Vary %.0f"
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
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						64.0,
						96.0,
						52.0,
						13.0
					],
					"patching_rect": [
						1780,
						340,
						52,
						13
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
					"id": "ol_press",
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
						8.0,
						96.0,
						52.0,
						13.0
					],
					"patching_rect": [
						1600,
						340,
						52,
						13
					]
				}
			},
			{
				"box": {
					"id": "press",
					"varname": "press",
					"parameter_enable": 1,
					"annotation_name": "Press",
					"annotation": "The mod wheel presses the head (a finger or the heel of the hand leaning on it): this many semitones up at full wheel. The body does not move.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
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
							"parameter_units": "Press %.0f st"
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
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						8.0,
						96.0,
						52.0,
						13.0
					],
					"patching_rect": [
						2230,
						260,
						52,
						13
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
						920,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_touch",
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
						120.0,
						81.0,
						52.0,
						13.0
					],
					"patching_rect": [
						2050,
						260,
						52,
						13
					]
				}
			},
			{
				"box": {
					"id": "touch",
					"varname": "touch",
					"parameter_enable": 1,
					"annotation_name": "Touch",
					"annotation": "Hardness of the contact: harder is shorter and brighter and ticks more; velocity does the same.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
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
							"parameter_units": "Touch %.0f"
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
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						120.0,
						81.0,
						52.0,
						13.0
					],
					"patching_rect": [
						1960,
						260,
						52,
						13
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
						830,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_shell",
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
						81.0,
						52.0,
						13.0
					],
					"patching_rect": [
						1780,
						260,
						52,
						13
					]
				}
			},
			{
				"box": {
					"id": "shell",
					"varname": "shell",
					"parameter_enable": 1,
					"annotation_name": "Shell",
					"annotation": "The body of the drum: how much the low 125 Hz thump speaks (it matters most on the Heel and the Tip).",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
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
							"parameter_units": "Shell %.0f"
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
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						64.0,
						81.0,
						52.0,
						13.0
					],
					"patching_rect": [
						1690,
						260,
						52,
						13
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
						740,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_skin",
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
						8.0,
						81.0,
						52.0,
						13.0
					],
					"patching_rect": [
						2230,
						180,
						52,
						13
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
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
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
							"parameter_units": "Skin %.0f"
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
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						8.0,
						81.0,
						52.0,
						13.0
					],
					"patching_rect": [
						2140,
						180,
						52,
						13
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
						650,
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
					"annotation": "How long the head rings, in percent of the natural time (a bongo's T60 is about a third of a second).",
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
						60.0,
						116.0,
						60.0,
						50.0
					],
					"patching_rect": [
						1960,
						180,
						60,
						50
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
						590,
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
					"annotation": "Tuning of the head in semitones. 0 is the drum's open tone (Macho 365 Hz, Hembra 325 Hz). The 125 Hz body does not move.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Tune",
							"parameter_shortname": "Tune",
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
					"presentation": 1,
					"presentation_rect": [
						0.0,
						116.0,
						60.0,
						50.0
					],
					"patching_rect": [
						1780,
						180,
						60,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_stroke_view",
					"maxclass": "newobj",
					"text": "prepend stroke",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						530,
						98,
						22
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
						20,
						500,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "stroke",
					"varname": "stroke",
					"parameter_enable": 1,
					"annotation_name": "Stroke",
					"annotation": "Which hand stroke a note plays: Open (one finger on the head, the ringing tone), Open 3F (three fingers: a softer, broader contact), Slap (the crack), Heel (heel of the hand, short and dull), Tip (fingertip, a light tap), Rim (finger on the rim and head together) or Flam (two Open strokes in a row). Changing it between hits works: the new stroke damps the ring already on the head.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Stroke",
							"parameter_shortname": "Stroke",
							"parameter_type": 2,
							"parameter_enum": [
								"Open",
								"Open 3F",
								"Slap",
								"Heel",
								"Tip",
								"Rim",
								"Flam"
							],
							"parameter_mmax": 6,
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
						92.0,
						60.0,
						80.0,
						16.0
					],
					"patching_rect": [
						2230,
						100,
						80,
						16
					]
				}
			},
			{
				"box": {
					"id": "pre_drum_view",
					"maxclass": "newobj",
					"text": "prepend drum",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						440,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "pre_drum",
					"maxclass": "newobj",
					"text": "prepend drum",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						410,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "drum",
					"varname": "drum",
					"parameter_enable": 1,
					"annotation_name": "Drum",
					"annotation": "Which drum of the pair: Macho (the small, high one, open tone about 365 Hz) or Hembra (the large, low one, about 325 Hz). Any MIDI note plays it.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Drum",
							"parameter_shortname": "Drum",
							"parameter_type": 2,
							"parameter_enum": [
								"Macho",
								"Hembra"
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
						60.0,
						80.0,
						16.0
					],
					"patching_rect": [
						1960,
						100,
						80,
						16
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
					"textjustification": 0,
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
						90.0,
						49.0,
						60.0,
						14.0
					],
					"patching_rect": [
						1870,
						100,
						60,
						14
					]
				}
			},
			{
				"box": {
					"id": "hdr_Drum",
					"maxclass": "comment",
					"text": "Drum",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.5,
					"textjustification": 0,
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
						49.0,
						60.0,
						14.0
					],
					"patching_rect": [
						1780,
						100,
						60,
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
					"filename": "bongo_view.js",
					"border": 0,
					"parameter_enable": 0,
					"annotation_name": "Bongos",
					"annotation": "The pair of bongos (the selected drum in orange), the hand where the current stroke is played and its name: it flashes when a note hits.",
					"presentation": 1,
					"presentation_rect": [
						8.0,
						8.0,
						164.0,
						40.0
					],
					"patching_rect": [
						1600,
						100,
						164,
						40
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
					"text": "js bongo_midi.js",
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
									"code": "Param drum(0);\nParam stroke(0);\nParam tune(0);\nParam decay(100);\nParam skin(50);\nParam shell(50);\nParam touch(50);\nParam press(5);\nParam vary(100);\nParam volume(-9);\nParam trg(0);\nParam vel(1);\nParam mw(0);\nHistory cnt(0);\nHistory pf(1);\nHistory pt(0);\nHistory vC(0);\nHistory vCk(0.99);\nHistory vE1(0);\nHistory vE2(0);\nHistory vK(0.5);\nHistory vNe(0);\nHistory vNr(0.99);\nHistory vI1(0);\nHistory vI2(0);\nHistory vNa1(0);\nHistory vNa2(0);\nHistory vNa3(0);\nHistory vNk(1);\nHistory vAm(0);\nHistory vF1(365);\nHistory vTd(1);\nHistory vIt(0);\nHistory vP1(0);\nHistory vP2(0);\nHistory vFd(0);\nHistory vFv(0);\nHistory vAe(0);\nHistory vTa(0.9);\nHistory vX0(0);\nHistory vY0(0);\nHistory vW0(0);\nHistory vG0(1);\nHistory vCc0(1);\nHistory vSn0(0);\nHistory vR0(0.999);\nHistory vX1(0);\nHistory vY1(0);\nHistory vW1(0);\nHistory vG1(1);\nHistory vCc1(1);\nHistory vSn1(0);\nHistory vR1(0.999);\nHistory vX2(0);\nHistory vY2(0);\nHistory vW2(0);\nHistory vG2(1);\nHistory vCc2(1);\nHistory vSn2(0);\nHistory vR2(0.999);\nHistory vX3(0);\nHistory vY3(0);\nHistory vW3(0);\nHistory vG3(1);\nHistory vCc3(1);\nHistory vSn3(0);\nHistory vR3(0.999);\nHistory vX4(0);\nHistory vY4(0);\nHistory vW4(0);\nHistory vG4(1);\nHistory vCc4(1);\nHistory vSn4(0);\nHistory vR4(0.999);\nHistory vX5(0);\nHistory vY5(0);\nHistory vW5(0);\nHistory vG5(1);\nHistory vCc5(1);\nHistory vSn5(0);\nHistory vR5(0.999);\nHistory vX6(0);\nHistory vY6(0);\nHistory vW6(0);\nHistory vG6(1);\nHistory vCc6(1);\nHistory vSn6(0);\nHistory vR6(0.999);\nHistory vX7(0);\nHistory vY7(0);\nHistory vW7(0);\nHistory vG7(1);\nHistory vCc7(1);\nHistory vSn7(0);\nHistory vR7(0.999);\nHistory vX8(0);\nHistory vY8(0);\nHistory vW8(0);\nHistory vG8(1);\nHistory vCc8(1);\nHistory vSn8(0);\nHistory vR8(0.999);\nHistory vX9(0);\nHistory vY9(0);\nHistory vW9(0);\nHistory vG9(1);\nHistory vCc9(1);\nHistory vSn9(0);\nHistory vR9(0.999);\nHistory vX10(0);\nHistory vY10(0);\nHistory vW10(0);\nHistory vG10(1);\nHistory vCc10(1);\nHistory vSn10(0);\nHistory vR10(0.999);\nHistory vX11(0);\nHistory vY11(0);\nHistory vW11(0);\nHistory vG11(1);\nHistory vCc11(1);\nHistory vSn11(0);\nHistory vR11(0.999);\nHistory vX12(0);\nHistory vY12(0);\nHistory vW12(0);\nHistory vG12(1);\nHistory vCc12(1);\nHistory vSn12(0);\nHistory vR12(0.999);\nHistory vX13(0);\nHistory vY13(0);\nHistory vW13(0);\nHistory vG13(1);\nHistory vCc13(1);\nHistory vSn13(0);\nHistory vR13(0.999);\nHistory vBe13(0);\nHistory vBi113(0);\nHistory vBi213(0);\nHistory vBa113(0);\nHistory vBa213(0);\nHistory vBa313(0);\nHistory vBg13(0);\nHistory vX14(0);\nHistory vY14(0);\nHistory vW14(0);\nHistory vG14(1);\nHistory vCc14(1);\nHistory vSn14(0);\nHistory vR14(0.999);\nHistory vBe14(0);\nHistory vBi114(0);\nHistory vBi214(0);\nHistory vBa114(0);\nHistory vBa214(0);\nHistory vBa314(0);\nHistory vBg14(0);\nHistory vX15(0);\nHistory vY15(0);\nHistory vW15(0);\nHistory vG15(1);\nHistory vCc15(1);\nHistory vSn15(0);\nHistory vR15(0.999);\nHistory vBe15(0);\nHistory vBi115(0);\nHistory vBi215(0);\nHistory vBa115(0);\nHistory vBa215(0);\nHistory vBa315(0);\nHistory vBg15(0);\nHistory vX16(0);\nHistory vY16(0);\nHistory vW16(0);\nHistory vG16(1);\nHistory vCc16(1);\nHistory vSn16(0);\nHistory vR16(0.999);\nHistory vBe16(0);\nHistory vBi116(0);\nHistory vBi216(0);\nHistory vBa116(0);\nHistory vBa216(0);\nHistory vBa316(0);\nHistory vBg16(0);\nHistory vX17(0);\nHistory vY17(0);\nHistory vW17(0);\nHistory vG17(1);\nHistory vCc17(1);\nHistory vSn17(0);\nHistory vR17(0.999);\nHistory vBe17(0);\nHistory vBi117(0);\nHistory vBi217(0);\nHistory vBa117(0);\nHistory vBa217(0);\nHistory vBa317(0);\nHistory vBg17(0);\n\ndecayS = decay * 0.01;\nshellG = shell * 0.02;\nskinT = (skin - 50) * 0.02 * 6 / 6.0206;                      // +-6 dB per octave of mode ratio at the ends\ntouchT = (touch - 50) * 0.02;\npfT = exp2(mw * press / 12);\nmasterG = dbtoa(volume);\ncnt = cnt + 1; ctl = cnt >= 16; cnt = cnt - ctl * 16;\nif (ctl) { pf = pf + 0.2 * (pfT - pf); }\nnz = noise();\nvh1 = trg != pt; pt = trg;\nvh2 = 0;\nif (vFd > 0.5) { vFd = vFd - 1; vh2 = vFd < 0.5; }\nvh = max(vh1, vh2 * (1 - vh1));\nvIm = 0; vIt = 0;\nif (vh > 0.5) {\nvfl = vh1 * (abs(stroke - 6) < 0.5);                  // a Flam starts as an Open and schedules its second hit\nvds = vh1 * stroke * (1 - vfl);                       // History-derived: the stroke and velocity at the hit (the flam's second hit is an Open: 0)\nvdv = vh1 * vel + (1 - vh1) * vFv;\nvFd = vfl * 0.042 * samplerate + (1 - vh1) * vFd; vFv = vfl * vdv * 0.45 + (1 - vfl) * vFv;\nvk = drum * 6 + vds;\nvg = pow(vdv, 1.4);\nvJs = nz * 1000 + trg; vJv = vary * 0.01;\nvAm = vg * ((abs(vk - 0) < 0.5) * 0.405300 + (abs(vk - 1) < 0.5) * 0.413800 + (abs(vk - 2) < 0.5) * 3.448200 + (abs(vk - 3) < 0.5) * 0.962800 + (abs(vk - 4) < 0.5) * 1.630800 + (abs(vk - 5) < 0.5) * 0.444800 + (abs(vk - 6) < 0.5) * 0.965800 + (abs(vk - 7) < 0.5) * 2.577300 + (abs(vk - 8) < 0.5) * 0.850100 + (abs(vk - 9) < 0.5) * 1.177300 + (abs(vk - 10) < 0.5) * 0.747300 + (abs(vk - 11) < 0.5) * 0.729400);\nvIm = vAm; vIt = vAm;\nvAe = 1; vTa = exp(-1 / (((abs(vk - 0) < 0.5) * 0.000100 + (abs(vk - 1) < 0.5) * 0.000100 + (abs(vk - 2) < 0.5) * 0.001910 + (abs(vk - 3) < 0.5) * 0.004000 + (abs(vk - 4) < 0.5) * 0.001260 + (abs(vk - 5) < 0.5) * 0.000100 + (abs(vk - 6) < 0.5) * 0.000100 + (abs(vk - 7) < 0.5) * 0.002850 + (abs(vk - 8) < 0.5) * 0.001590 + (abs(vk - 9) < 0.5) * 0.000100 + (abs(vk - 10) < 0.5) * 0.002090 + (abs(vk - 11) < 0.5) * 0.002060) * samplerate));\nvfc = ((abs(vds - 0) < 0.5) * 3000.000000 + (abs(vds - 1) < 0.5) * 2500.000000 + (abs(vds - 2) < 0.5) * 6000.000000 + (abs(vds - 3) < 0.5) * 1500.000000 + (abs(vds - 4) < 0.5) * 2500.000000 + (abs(vds - 5) < 0.5) * 6000.000000) * exp2(touchT * 1.5 + (vdv - 0.6) * 0.8);\nvK = 1 - exp(-twopi * min(vfc, 18000) / samplerate);\nvC = 1;\nvCk = exp(-16 / (((abs(vk - 0) < 0.5) * 0.020000 + (abs(vk - 1) < 0.5) * 0.020000 + (abs(vk - 2) < 0.5) * 0.020000 + (abs(vk - 3) < 0.5) * 0.020000 + (abs(vk - 4) < 0.5) * 0.012000 + (abs(vk - 5) < 0.5) * 0.012000 + (abs(vk - 6) < 0.5) * 0.035000 + (abs(vk - 7) < 0.5) * 0.007000 + (abs(vk - 8) < 0.5) * 0.007000 + (abs(vk - 9) < 0.5) * 0.012000 + (abs(vk - 10) < 0.5) * 0.012000 + (abs(vk - 11) < 0.5) * 0.007000) * samplerate));\nvNe = vAm * ((abs(vk - 0) < 0.5) * 2.372000 + (abs(vk - 1) < 0.5) * 1.341600 + (abs(vk - 2) < 0.5) * 0.016600 + (abs(vk - 3) < 0.5) * 0.764900 + (abs(vk - 4) < 0.5) * 0.298800 + (abs(vk - 5) < 0.5) * 2.375500 + (abs(vk - 6) < 0.5) * 2.487200 + (abs(vk - 7) < 0.5) * 0.227100 + (abs(vk - 8) < 0.5) * 0.103400 + (abs(vk - 9) < 0.5) * 0.773900 + (abs(vk - 10) < 0.5) * 0.351200 + (abs(vk - 11) < 0.5) * 3.246900) * (1 + touchT);\nvNr = exp(-1 / (((abs(vds - 0) < 0.5) * 0.000800 + (abs(vds - 1) < 0.5) * 0.000800 + (abs(vds - 2) < 0.5) * 0.000800 + (abs(vds - 3) < 0.5) * 0.000800 + (abs(vds - 4) < 0.5) * 0.000800 + (abs(vds - 5) < 0.5) * 0.000800) * samplerate));\nvNg = tan(pi * ((abs(vds - 0) < 0.5) * 1100.000000 + (abs(vds - 1) < 0.5) * 1650.000000 + (abs(vds - 2) < 0.5) * 1890.000000 + (abs(vds - 3) < 0.5) * 1490.000000 + (abs(vds - 4) < 0.5) * 1960.000000 + (abs(vds - 5) < 0.5) * 1300.000000) / samplerate); vNk = 1 / ((abs(vds - 0) < 0.5) * 0.700000 + (abs(vds - 1) < 0.5) * 0.700000 + (abs(vds - 2) < 0.5) * 0.700000 + (abs(vds - 3) < 0.5) * 0.700000 + (abs(vds - 4) < 0.5) * 0.700000 + (abs(vds - 5) < 0.5) * 0.700000);\nvNa1 = 1 / (1 + vNg * (vNg + vNk)); vNa2 = vNg * vNa1; vNa3 = vNg * vNa2;\nvW0 = ((abs(vk - 0) < 0.5) * 0.020654 + (abs(vk - 1) < 0.5) * 0.048978 + (abs(vk - 2) < 0.5) * 0.017179 + (abs(vk - 3) < 0.5) * 0.102329 + (abs(vk - 4) < 0.5) * 0.226464 + (abs(vk - 5) < 0.5) * 0.211349 + (abs(vk - 6) < 0.5) * 0.001216 + (abs(vk - 7) < 0.5) * 0.031623 + (abs(vk - 8) < 0.5) * 0.001135 + (abs(vk - 9) < 0.5) * 0.088105 + (abs(vk - 10) < 0.5) * 0.248313 + (abs(vk - 11) < 0.5) * 0.093325) * exp(skinT * ((abs(drum - 0) < 0.5) * -0.248461 + (abs(drum - 1) < 0.5) * -0.287682)) * exp(0.299115 * vJv * (fract(sin(vJs + 0.0) * 43758.5453) * 2 - 1)); vG0 = (abs(vk - 0) < 0.5) * 6.500000 + (abs(vk - 1) < 0.5) * 6.500000 + (abs(vk - 2) < 0.5) * 6.500000 + (abs(vk - 3) < 0.5) * 9.000000 + (abs(vk - 4) < 0.5) * 13.000000 + (abs(vk - 5) < 0.5) * 9.000000 + (abs(vk - 6) < 0.5) * 2.000000 + (abs(vk - 7) < 0.5) * 13.000000 + (abs(vk - 8) < 0.5) * 13.000000 + (abs(vk - 9) < 0.5) * 9.000000 + (abs(vk - 10) < 0.5) * 13.000000 + (abs(vk - 11) < 0.5) * 13.000000;\nvW1 = ((abs(vk - 0) < 0.5) * 0.035892 + (abs(vk - 1) < 0.5) * 0.063826 + (abs(vk - 2) < 0.5) * 0.014454 + (abs(vk - 3) < 0.5) * 0.020893 + (abs(vk - 4) < 0.5) * 0.100000 + (abs(vk - 5) < 0.5) * 0.095499 + (abs(vk - 6) < 0.5) * 0.139637 + (abs(vk - 7) < 0.5) * 0.234423 + (abs(vk - 8) < 0.5) * 0.977237 + (abs(vk - 9) < 0.5) * 0.363078 + (abs(vk - 10) < 0.5) * 1.000000 + (abs(vk - 11) < 0.5) * 0.179887) * exp(skinT * ((abs(drum - 0) < 0.5) * -0.094311 + (abs(drum - 1) < 0.5) * -0.127833)) * exp(0.299115 * vJv * (fract(sin(vJs + 78.233) * 43758.5453) * 2 - 1)); vG1 = (abs(vk - 0) < 0.5) * 6.500000 + (abs(vk - 1) < 0.5) * 6.500000 + (abs(vk - 2) < 0.5) * 6.500000 + (abs(vk - 3) < 0.5) * 9.000000 + (abs(vk - 4) < 0.5) * 13.000000 + (abs(vk - 5) < 0.5) * 9.000000 + (abs(vk - 6) < 0.5) * 2.000000 + (abs(vk - 7) < 0.5) * 13.000000 + (abs(vk - 8) < 0.5) * 13.000000 + (abs(vk - 9) < 0.5) * 9.000000 + (abs(vk - 10) < 0.5) * 13.000000 + (abs(vk - 11) < 0.5) * 13.000000;\nvW2 = ((abs(vk - 0) < 0.5) * 0.116145 + (abs(vk - 1) < 0.5) * 0.204174 + (abs(vk - 2) < 0.5) * 0.060256 + (abs(vk - 3) < 0.5) * 0.229087 + (abs(vk - 4) < 0.5) * 0.218776 + (abs(vk - 5) < 0.5) * 0.457088 + (abs(vk - 6) < 0.5) * 0.346737 + (abs(vk - 7) < 0.5) * 0.457088 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 0.495450 + (abs(vk - 10) < 0.5) * 0.901571 + (abs(vk - 11) < 0.5) * 0.231739) * exp(skinT * ((abs(drum - 0) < 0.5) * 0.000000 + (abs(drum - 1) < 0.5) * 0.000000)) * exp(0.299115 * vJv * (fract(sin(vJs + 156.466) * 43758.5453) * 2 - 1)); vG2 = (abs(vk - 0) < 0.5) * 6.500000 + (abs(vk - 1) < 0.5) * 6.500000 + (abs(vk - 2) < 0.5) * 6.500000 + (abs(vk - 3) < 0.5) * 9.000000 + (abs(vk - 4) < 0.5) * 13.000000 + (abs(vk - 5) < 0.5) * 9.000000 + (abs(vk - 6) < 0.5) * 2.000000 + (abs(vk - 7) < 0.5) * 13.000000 + (abs(vk - 8) < 0.5) * 13.000000 + (abs(vk - 9) < 0.5) * 9.000000 + (abs(vk - 10) < 0.5) * 13.000000 + (abs(vk - 11) < 0.5) * 13.000000;\nvW3 = ((abs(vk - 0) < 0.5) * 0.034277 + (abs(vk - 1) < 0.5) * 0.035075 + (abs(vk - 2) < 0.5) * 0.014125 + (abs(vk - 3) < 0.5) * 0.071614 + (abs(vk - 4) < 0.5) * 0.048978 + (abs(vk - 5) < 0.5) * 0.186209 + (abs(vk - 6) < 0.5) * 0.108393 + (abs(vk - 7) < 0.5) * 0.113501 + (abs(vk - 8) < 0.5) * 0.017378 + (abs(vk - 9) < 0.5) * 0.221309 + (abs(vk - 10) < 0.5) * 0.079433 + (abs(vk - 11) < 0.5) * 0.112202) * exp(skinT * ((abs(drum - 0) < 0.5) * 0.190620 + (abs(drum - 1) < 0.5) * 0.113329)) * exp(0.299115 * vJv * (fract(sin(vJs + 234.699) * 43758.5453) * 2 - 1)); vG3 = (abs(vk - 0) < 0.5) * 6.500000 + (abs(vk - 1) < 0.5) * 6.500000 + (abs(vk - 2) < 0.5) * 6.500000 + (abs(vk - 3) < 0.5) * 9.000000 + (abs(vk - 4) < 0.5) * 13.000000 + (abs(vk - 5) < 0.5) * 9.000000 + (abs(vk - 6) < 0.5) * 2.000000 + (abs(vk - 7) < 0.5) * 13.000000 + (abs(vk - 8) < 0.5) * 13.000000 + (abs(vk - 9) < 0.5) * 9.000000 + (abs(vk - 10) < 0.5) * 13.000000 + (abs(vk - 11) < 0.5) * 13.000000;\nvW4 = ((abs(vk - 0) < 0.5) * 0.025119 + (abs(vk - 1) < 0.5) * 0.023442 + (abs(vk - 2) < 0.5) * 0.012162 + (abs(vk - 3) < 0.5) * 0.046238 + (abs(vk - 4) < 0.5) * 0.023174 + (abs(vk - 5) < 0.5) * 0.089125 + (abs(vk - 6) < 0.5) * 0.000316 + (abs(vk - 7) < 0.5) * 0.000320 + (abs(vk - 8) < 0.5) * 0.001202 + (abs(vk - 9) < 0.5) * 0.002541 + (abs(vk - 10) < 0.5) * 0.011614 + (abs(vk - 11) < 0.5) * 0.069984) * exp(skinT * ((abs(drum - 0) < 0.5) * 0.300105 + (abs(drum - 1) < 0.5) * 0.190620)) * exp(0.299115 * vJv * (fract(sin(vJs + 312.932) * 43758.5453) * 2 - 1)); vG4 = (abs(vk - 0) < 0.5) * 6.500000 + (abs(vk - 1) < 0.5) * 6.500000 + (abs(vk - 2) < 0.5) * 6.500000 + (abs(vk - 3) < 0.5) * 9.000000 + (abs(vk - 4) < 0.5) * 13.000000 + (abs(vk - 5) < 0.5) * 9.000000 + (abs(vk - 6) < 0.5) * 2.000000 + (abs(vk - 7) < 0.5) * 13.000000 + (abs(vk - 8) < 0.5) * 13.000000 + (abs(vk - 9) < 0.5) * 9.000000 + (abs(vk - 10) < 0.5) * 13.000000 + (abs(vk - 11) < 0.5) * 13.000000;\nvW5 = ((abs(vk - 0) < 0.5) * 0.022387 + (abs(vk - 1) < 0.5) * 0.012882 + (abs(vk - 2) < 0.5) * 0.014454 + (abs(vk - 3) < 0.5) * 0.038459 + (abs(vk - 4) < 0.5) * 0.014962 + (abs(vk - 5) < 0.5) * 0.077625 + (abs(vk - 6) < 0.5) * 0.036308 + (abs(vk - 7) < 0.5) * 0.032359 + (abs(vk - 8) < 0.5) * 0.216272 + (abs(vk - 9) < 0.5) * 0.087096 + (abs(vk - 10) < 0.5) * 0.053703 + (abs(vk - 11) < 0.5) * 0.105925) * exp(skinT * ((abs(drum - 0) < 0.5) * 0.438255 + (abs(drum - 1) < 0.5) * 0.277632)) * exp(0.299115 * vJv * (fract(sin(vJs + 391.165) * 43758.5453) * 2 - 1)); vG5 = (abs(vk - 0) < 0.5) * 6.500000 + (abs(vk - 1) < 0.5) * 6.500000 + (abs(vk - 2) < 0.5) * 6.500000 + (abs(vk - 3) < 0.5) * 9.000000 + (abs(vk - 4) < 0.5) * 13.000000 + (abs(vk - 5) < 0.5) * 9.000000 + (abs(vk - 6) < 0.5) * 2.000000 + (abs(vk - 7) < 0.5) * 13.000000 + (abs(vk - 8) < 0.5) * 13.000000 + (abs(vk - 9) < 0.5) * 9.000000 + (abs(vk - 10) < 0.5) * 13.000000 + (abs(vk - 11) < 0.5) * 13.000000;\nvW6 = ((abs(vk - 0) < 0.5) * 0.029512 + (abs(vk - 1) < 0.5) * 0.029174 + (abs(vk - 2) < 0.5) * 0.029174 + (abs(vk - 3) < 0.5) * 0.046238 + (abs(vk - 4) < 0.5) * 0.014791 + (abs(vk - 5) < 0.5) * 0.118850 + (abs(vk - 6) < 0.5) * 0.096605 + (abs(vk - 7) < 0.5) * 0.105925 + (abs(vk - 8) < 0.5) * 0.489779 + (abs(vk - 9) < 0.5) * 0.192752 + (abs(vk - 10) < 0.5) * 0.153109 + (abs(vk - 11) < 0.5) * 0.104713) * exp(skinT * ((abs(drum - 0) < 0.5) * 0.553885 + (abs(drum - 1) < 0.5) * 0.431782)) * exp(0.299115 * vJv * (fract(sin(vJs + 469.398) * 43758.5453) * 2 - 1)); vG6 = (abs(vk - 0) < 0.5) * 6.500000 + (abs(vk - 1) < 0.5) * 6.500000 + (abs(vk - 2) < 0.5) * 6.500000 + (abs(vk - 3) < 0.5) * 9.000000 + (abs(vk - 4) < 0.5) * 13.000000 + (abs(vk - 5) < 0.5) * 9.000000 + (abs(vk - 6) < 0.5) * 2.000000 + (abs(vk - 7) < 0.5) * 13.000000 + (abs(vk - 8) < 0.5) * 13.000000 + (abs(vk - 9) < 0.5) * 9.000000 + (abs(vk - 10) < 0.5) * 13.000000 + (abs(vk - 11) < 0.5) * 13.000000;\nvW7 = ((abs(vk - 0) < 0.5) * 0.037154 + (abs(vk - 1) < 0.5) * 0.038905 + (abs(vk - 2) < 0.5) * 0.068391 + (abs(vk - 3) < 0.5) * 0.019275 + (abs(vk - 4) < 0.5) * 0.026303 + (abs(vk - 5) < 0.5) * 0.073282 + (abs(vk - 6) < 0.5) * 0.045186 + (abs(vk - 7) < 0.5) * 0.036728 + (abs(vk - 8) < 0.5) * 0.141254 + (abs(vk - 9) < 0.5) * 0.051880 + (abs(vk - 10) < 0.5) * 0.039355 + (abs(vk - 11) < 0.5) * 0.078524) * exp(skinT * ((abs(drum - 0) < 0.5) * 0.717840 + (abs(drum - 1) < 0.5) * 0.488580)) * exp(0.299115 * vJv * (fract(sin(vJs + 547.6310000000001) * 43758.5453) * 2 - 1)); vG7 = (abs(vk - 0) < 0.5) * 6.500000 + (abs(vk - 1) < 0.5) * 6.500000 + (abs(vk - 2) < 0.5) * 6.500000 + (abs(vk - 3) < 0.5) * 9.000000 + (abs(vk - 4) < 0.5) * 13.000000 + (abs(vk - 5) < 0.5) * 9.000000 + (abs(vk - 6) < 0.5) * 2.000000 + (abs(vk - 7) < 0.5) * 13.000000 + (abs(vk - 8) < 0.5) * 13.000000 + (abs(vk - 9) < 0.5) * 9.000000 + (abs(vk - 10) < 0.5) * 13.000000 + (abs(vk - 11) < 0.5) * 13.000000;\nvW8 = ((abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 0.139637 + (abs(vk - 3) < 0.5) * 1.000000 + (abs(vk - 4) < 0.5) * 0.266073 + (abs(vk - 5) < 0.5) * 0.323594 + (abs(vk - 6) < 0.5) * 0.100000 + (abs(vk - 7) < 0.5) * 0.053703 + (abs(vk - 8) < 0.5) * 0.312608 + (abs(vk - 9) < 0.5) * 0.019275 + (abs(vk - 10) < 0.5) * 0.045186 + (abs(vk - 11) < 0.5) * 0.095499) * exp(skinT * ((abs(drum - 0) < 0.5) * 0.828552 + (abs(drum - 1) < 0.5) * 0.765468)) * exp(0.299115 * vJv * (fract(sin(vJs + 625.864) * 43758.5453) * 2 - 1)); vG8 = (abs(vk - 0) < 0.5) * 6.500000 + (abs(vk - 1) < 0.5) * 6.500000 + (abs(vk - 2) < 0.5) * 6.500000 + (abs(vk - 3) < 0.5) * 9.000000 + (abs(vk - 4) < 0.5) * 13.000000 + (abs(vk - 5) < 0.5) * 9.000000 + (abs(vk - 6) < 0.5) * 2.000000 + (abs(vk - 7) < 0.5) * 13.000000 + (abs(vk - 8) < 0.5) * 13.000000 + (abs(vk - 9) < 0.5) * 9.000000 + (abs(vk - 10) < 0.5) * 13.000000 + (abs(vk - 11) < 0.5) * 13.000000;\nvW9 = ((abs(vk - 0) < 0.5) * 0.389045 + (abs(vk - 1) < 0.5) * 0.263027 + (abs(vk - 2) < 0.5) * 0.088105 + (abs(vk - 3) < 0.5) * 0.668344 + (abs(vk - 4) < 0.5) * 0.142889 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 0.022646 + (abs(vk - 7) < 0.5) * 0.044157 + (abs(vk - 8) < 0.5) * 0.223872 + (abs(vk - 9) < 0.5) * 0.030549 + (abs(vk - 10) < 0.5) * 0.113501 + (abs(vk - 11) < 0.5) * 0.134896) * exp(skinT * ((abs(drum - 0) < 0.5) * 1.232560 + (abs(drum - 1) < 0.5) * 1.085189)) * exp(0.299115 * vJv * (fract(sin(vJs + 704.097) * 43758.5453) * 2 - 1)); vG9 = (abs(vk - 0) < 0.5) * 6.500000 + (abs(vk - 1) < 0.5) * 6.500000 + (abs(vk - 2) < 0.5) * 6.500000 + (abs(vk - 3) < 0.5) * 9.000000 + (abs(vk - 4) < 0.5) * 13.000000 + (abs(vk - 5) < 0.5) * 9.000000 + (abs(vk - 6) < 0.5) * 2.000000 + (abs(vk - 7) < 0.5) * 13.000000 + (abs(vk - 8) < 0.5) * 13.000000 + (abs(vk - 9) < 0.5) * 9.000000 + (abs(vk - 10) < 0.5) * 13.000000 + (abs(vk - 11) < 0.5) * 13.000000;\nvW10 = ((abs(vk - 0) < 0.5) * 0.071614 + (abs(vk - 1) < 0.5) * 0.164059 + (abs(vk - 2) < 0.5) * 0.033884 + (abs(vk - 3) < 0.5) * 0.100000 + (abs(vk - 4) < 0.5) * 0.033884 + (abs(vk - 5) < 0.5) * 0.257040 + (abs(vk - 6) < 0.5) * 0.021380 + (abs(vk - 7) < 0.5) * 0.026915 + (abs(vk - 8) < 0.5) * 0.201837 + (abs(vk - 9) < 0.5) * 0.089125 + (abs(vk - 10) < 0.5) * 0.201837 + (abs(vk - 11) < 0.5) * 0.024266) * exp(skinT * ((abs(drum - 0) < 0.5) * 1.294727 + (abs(drum - 1) < 0.5) * 1.178655)) * exp(0.299115 * vJv * (fract(sin(vJs + 782.33) * 43758.5453) * 2 - 1)); vG10 = (abs(vk - 0) < 0.5) * 6.500000 + (abs(vk - 1) < 0.5) * 6.500000 + (abs(vk - 2) < 0.5) * 6.500000 + (abs(vk - 3) < 0.5) * 9.000000 + (abs(vk - 4) < 0.5) * 13.000000 + (abs(vk - 5) < 0.5) * 9.000000 + (abs(vk - 6) < 0.5) * 2.000000 + (abs(vk - 7) < 0.5) * 13.000000 + (abs(vk - 8) < 0.5) * 13.000000 + (abs(vk - 9) < 0.5) * 9.000000 + (abs(vk - 10) < 0.5) * 13.000000 + (abs(vk - 11) < 0.5) * 13.000000;\nvW11 = ((abs(vk - 0) < 0.5) * 0.192752 + (abs(vk - 1) < 0.5) * 0.188365 + (abs(vk - 2) < 0.5) * 0.063826 + (abs(vk - 3) < 0.5) * 0.197242 + (abs(vk - 4) < 0.5) * 0.045186 + (abs(vk - 5) < 0.5) * 0.162181 + (abs(vk - 6) < 0.5) * 0.019724 + (abs(vk - 7) < 0.5) * 0.023442 + (abs(vk - 8) < 0.5) * 0.130317 + (abs(vk - 9) < 0.5) * 0.077625 + (abs(vk - 10) < 0.5) * 0.058884 + (abs(vk - 11) < 0.5) * 0.044157) * exp(skinT * ((abs(drum - 0) < 0.5) * 1.603420 + (abs(drum - 1) < 0.5) * 1.360977)) * exp(0.299115 * vJv * (fract(sin(vJs + 860.5630000000001) * 43758.5453) * 2 - 1)); vG11 = (abs(vk - 0) < 0.5) * 6.500000 + (abs(vk - 1) < 0.5) * 6.500000 + (abs(vk - 2) < 0.5) * 6.500000 + (abs(vk - 3) < 0.5) * 9.000000 + (abs(vk - 4) < 0.5) * 13.000000 + (abs(vk - 5) < 0.5) * 9.000000 + (abs(vk - 6) < 0.5) * 2.000000 + (abs(vk - 7) < 0.5) * 13.000000 + (abs(vk - 8) < 0.5) * 13.000000 + (abs(vk - 9) < 0.5) * 9.000000 + (abs(vk - 10) < 0.5) * 13.000000 + (abs(vk - 11) < 0.5) * 13.000000;\nvW12 = ((abs(vk - 0) < 0.5) * 0.342768 + (abs(vk - 1) < 0.5) * 0.501187 + (abs(vk - 2) < 0.5) * 0.069984 + (abs(vk - 3) < 0.5) * 0.501187 + (abs(vk - 4) < 0.5) * 0.133352 + (abs(vk - 5) < 0.5) * 0.501187 + (abs(vk - 6) < 0.5) * 0.063096 + (abs(vk - 7) < 0.5) * 0.229087 + (abs(vk - 8) < 0.5) * 0.501187 + (abs(vk - 9) < 0.5) * 0.248313 + (abs(vk - 10) < 0.5) * 0.501187 + (abs(vk - 11) < 0.5) * 0.116145) * shellG * exp(0.299115 * vJv * (fract(sin(vJs + 938.796) * 43758.5453) * 2 - 1)); vG12 = (abs(vk - 0) < 0.5) * 6.500000 + (abs(vk - 1) < 0.5) * 6.500000 + (abs(vk - 2) < 0.5) * 6.500000 + (abs(vk - 3) < 0.5) * 9.000000 + (abs(vk - 4) < 0.5) * 13.000000 + (abs(vk - 5) < 0.5) * 9.000000 + (abs(vk - 6) < 0.5) * 2.000000 + (abs(vk - 7) < 0.5) * 13.000000 + (abs(vk - 8) < 0.5) * 13.000000 + (abs(vk - 9) < 0.5) * 9.000000 + (abs(vk - 10) < 0.5) * 13.000000 + (abs(vk - 11) < 0.5) * 13.000000;\nvW13 = ((abs(vk - 0) < 0.5) * 0.025704 + (abs(vk - 1) < 0.5) * 0.032734 + (abs(vk - 2) < 0.5) * 0.010000 + (abs(vk - 3) < 0.5) * 0.017783 + (abs(vk - 4) < 0.5) * 0.005689 + (abs(vk - 5) < 0.5) * 0.072444 + (abs(vk - 6) < 0.5) * 0.018621 + (abs(vk - 7) < 0.5) * 0.004315 + (abs(vk - 8) < 0.5) * 0.036308 + (abs(vk - 9) < 0.5) * 0.015311 + (abs(vk - 10) < 0.5) * 0.006839 + (abs(vk - 11) < 0.5) * 0.017378) * exp(skinT * 1.757358); vG13 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 1.000000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 1.000000 + (abs(vk - 10) < 0.5) * 1.000000 + (abs(vk - 11) < 0.5) * 1.000000;\nvW14 = ((abs(vk - 0) < 0.5) * 0.003162 + (abs(vk - 1) < 0.5) * 0.000582 + (abs(vk - 2) < 0.5) * 0.010715 + (abs(vk - 3) < 0.5) * 0.030903 + (abs(vk - 4) < 0.5) * 0.010000 + (abs(vk - 5) < 0.5) * 0.000324 + (abs(vk - 6) < 0.5) * 0.000316 + (abs(vk - 7) < 0.5) * 0.000320 + (abs(vk - 8) < 0.5) * 0.001216 + (abs(vk - 9) < 0.5) * 0.000331 + (abs(vk - 10) < 0.5) * 0.001884 + (abs(vk - 11) < 0.5) * 0.000977) * exp(skinT * 2.093830); vG14 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 1.000000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 1.000000 + (abs(vk - 10) < 0.5) * 1.000000 + (abs(vk - 11) < 0.5) * 1.000000;\nvW15 = ((abs(vk - 0) < 0.5) * 0.000316 + (abs(vk - 1) < 0.5) * 0.000320 + (abs(vk - 2) < 0.5) * 0.002455 + (abs(vk - 3) < 0.5) * 0.000331 + (abs(vk - 4) < 0.5) * 0.003846 + (abs(vk - 5) < 0.5) * 0.000871 + (abs(vk - 6) < 0.5) * 0.000316 + (abs(vk - 7) < 0.5) * 0.000320 + (abs(vk - 8) < 0.5) * 0.009441 + (abs(vk - 9) < 0.5) * 0.000331 + (abs(vk - 10) < 0.5) * 0.001202 + (abs(vk - 11) < 0.5) * 0.001012) * exp(skinT * 2.450505); vG15 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 1.000000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 1.000000 + (abs(vk - 10) < 0.5) * 1.000000 + (abs(vk - 11) < 0.5) * 1.000000;\nvW16 = ((abs(vk - 0) < 0.5) * 0.000316 + (abs(vk - 1) < 0.5) * 0.000447 + (abs(vk - 2) < 0.5) * 0.019275 + (abs(vk - 3) < 0.5) * 0.000537 + (abs(vk - 4) < 0.5) * 0.019724 + (abs(vk - 5) < 0.5) * 0.015311 + (abs(vk - 6) < 0.5) * 0.000316 + (abs(vk - 7) < 0.5) * 0.000398 + (abs(vk - 8) < 0.5) * 0.022131 + (abs(vk - 9) < 0.5) * 0.000331 + (abs(vk - 10) < 0.5) * 0.010839 + (abs(vk - 11) < 0.5) * 0.007943) * exp(skinT * 2.822069); vG16 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 1.000000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 1.000000 + (abs(vk - 10) < 0.5) * 1.000000 + (abs(vk - 11) < 0.5) * 1.000000;\nvW17 = ((abs(vk - 0) < 0.5) * 0.000316 + (abs(vk - 1) < 0.5) * 0.002344 + (abs(vk - 2) < 0.5) * 0.004266 + (abs(vk - 3) < 0.5) * 0.002163 + (abs(vk - 4) < 0.5) * 0.017579 + (abs(vk - 5) < 0.5) * 0.017989 + (abs(vk - 6) < 0.5) * 0.002018 + (abs(vk - 7) < 0.5) * 0.000320 + (abs(vk - 8) < 0.5) * 0.004365 + (abs(vk - 9) < 0.5) * 0.000871 + (abs(vk - 10) < 0.5) * 0.007079 + (abs(vk - 11) < 0.5) * 0.012589) * exp(skinT * 3.204277); vG17 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 1.000000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 1.000000 + (abs(vk - 10) < 0.5) * 1.000000 + (abs(vk - 11) < 0.5) * 1.000000;\nvkp = (abs(vds - 0) < 0.5) * 0.850000 + (abs(vds - 1) < 0.5) * 0.800000 + (abs(vds - 2) < 0.5) * 0.500000 + (abs(vds - 3) < 0.5) * 0.400000 + (abs(vds - 4) < 0.5) * 0.600000 + (abs(vds - 5) < 0.5) * 0.700000;\nvX0 = vX0 * vkp; vY0 = vY0 * vkp;\nvX1 = vX1 * vkp; vY1 = vY1 * vkp;\nvX2 = vX2 * vkp; vY2 = vY2 * vkp;\nvX3 = vX3 * vkp; vY3 = vY3 * vkp;\nvX4 = vX4 * vkp; vY4 = vY4 * vkp;\nvX5 = vX5 * vkp; vY5 = vY5 * vkp;\nvX6 = vX6 * vkp; vY6 = vY6 * vkp;\nvX7 = vX7 * vkp; vY7 = vY7 * vkp;\nvX8 = vX8 * vkp; vY8 = vY8 * vkp;\nvX9 = vX9 * vkp; vY9 = vY9 * vkp;\nvX10 = vX10 * vkp; vY10 = vY10 * vkp;\nvX11 = vX11 * vkp; vY11 = vY11 * vkp;\nvX12 = vX12 * vkp; vY12 = vY12 * vkp;\nvBe13 = vBe13 * vkp; vBg13 = vW13 * 5.0 / (1 + 4000000 / (vfc * vfc));\nvBe14 = vBe14 * vkp; vBg14 = vW14 * 5.0 / (1 + 7840000 / (vfc * vfc));\nvBe15 = vBe15 * vkp; vBg15 = vW15 * 5.0 / (1 + 16000000 / (vfc * vfc));\nvBe16 = vBe16 * vkp; vBg16 = vW16 * 5.0 / (1 + 33640000 / (vfc * vfc));\nvBe17 = vBe17 * vkp; vBg17 = vW17 * 5.0 / (1 + 72250000 / (vfc * vfc));\n}\nvE1 = vE1 + vK * (vIm - vE1); vE2 = vE2 + vK * (vE1 - vE2);\nif (ctl) {\nvC = vC * vCk;\nvF1 = ((abs(drum - 0) < 0.5) * 365.000000 + (abs(drum - 1) < 0.5) * 325.000000) * exp2(tune / 12);\nvw = twopi * vF1 * pf * ((abs(drum - 0) < 0.5) * 0.780000 + (abs(drum - 1) < 0.5) * 0.750000) / samplerate; vCc0 = cos(vw); vSn0 = sin(vw); vR0 = exp(-6.907755279 * (1 + (vG0 - 1) * vC) / (((abs(drum - 0) < 0.5) * 0.300000 + (abs(drum - 1) < 0.5) * 0.280000) * decayS * samplerate));\nvw = twopi * vF1 * pf * ((abs(drum - 0) < 0.5) * 0.910000 + (abs(drum - 1) < 0.5) * 0.880000) / samplerate; vCc1 = cos(vw); vSn1 = sin(vw); vR1 = exp(-6.907755279 * (1 + (vG1 - 1) * vC) / (((abs(drum - 0) < 0.5) * 0.350000 + (abs(drum - 1) < 0.5) * 0.250000) * decayS * samplerate));\nvw = twopi * vF1 * pf * ((abs(drum - 0) < 0.5) * 1.000000 + (abs(drum - 1) < 0.5) * 1.000000) / samplerate; vCc2 = cos(vw); vSn2 = sin(vw); vR2 = exp(-6.907755279 * (1 + (vG2 - 1) * vC) / (((abs(drum - 0) < 0.5) * 0.380000 + (abs(drum - 1) < 0.5) * 0.320000) * decayS * samplerate));\nvw = twopi * vF1 * pf * ((abs(drum - 0) < 0.5) * 1.210000 + (abs(drum - 1) < 0.5) * 1.120000) / samplerate; vCc3 = cos(vw); vSn3 = sin(vw); vR3 = exp(-6.907755279 * (1 + (vG3 - 1) * vC) / (((abs(drum - 0) < 0.5) * 0.350000 + (abs(drum - 1) < 0.5) * 0.330000) * decayS * samplerate));\nvw = twopi * vF1 * pf * ((abs(drum - 0) < 0.5) * 1.350000 + (abs(drum - 1) < 0.5) * 1.210000) / samplerate; vCc4 = cos(vw); vSn4 = sin(vw); vR4 = exp(-6.907755279 * (1 + (vG4 - 1) * vC) / (((abs(drum - 0) < 0.5) * 0.350000 + (abs(drum - 1) < 0.5) * 0.350000) * decayS * samplerate));\nvw = twopi * vF1 * pf * ((abs(drum - 0) < 0.5) * 1.550000 + (abs(drum - 1) < 0.5) * 1.320000) / samplerate; vCc5 = cos(vw); vSn5 = sin(vw); vR5 = exp(-6.907755279 * (1 + (vG5 - 1) * vC) / (((abs(drum - 0) < 0.5) * 0.350000 + (abs(drum - 1) < 0.5) * 0.350000) * decayS * samplerate));\nvw = twopi * vF1 * pf * ((abs(drum - 0) < 0.5) * 1.740000 + (abs(drum - 1) < 0.5) * 1.540000) / samplerate; vCc6 = cos(vw); vSn6 = sin(vw); vR6 = exp(-6.907755279 * (1 + (vG6 - 1) * vC) / (((abs(drum - 0) < 0.5) * 0.350000 + (abs(drum - 1) < 0.5) * 0.300000) * decayS * samplerate));\nvw = twopi * vF1 * pf * ((abs(drum - 0) < 0.5) * 2.050000 + (abs(drum - 1) < 0.5) * 1.630000) / samplerate; vCc7 = cos(vw); vSn7 = sin(vw); vR7 = exp(-6.907755279 * (1 + (vG7 - 1) * vC) / (((abs(drum - 0) < 0.5) * 0.400000 + (abs(drum - 1) < 0.5) * 0.350000) * decayS * samplerate));\nvw = twopi * vF1 * pf * ((abs(drum - 0) < 0.5) * 2.290000 + (abs(drum - 1) < 0.5) * 2.150000) / samplerate; vCc8 = cos(vw); vSn8 = sin(vw); vR8 = exp(-6.907755279 * (1 + (vG8 - 1) * vC) / (((abs(drum - 0) < 0.5) * 0.340000 + (abs(drum - 1) < 0.5) * 0.390000) * decayS * samplerate));\nvw = twopi * vF1 * pf * ((abs(drum - 0) < 0.5) * 3.430000 + (abs(drum - 1) < 0.5) * 2.960000) / samplerate; vCc9 = cos(vw); vSn9 = sin(vw); vR9 = exp(-6.907755279 * (1 + (vG9 - 1) * vC) / (((abs(drum - 0) < 0.5) * 0.250000 + (abs(drum - 1) < 0.5) * 0.280000) * decayS * samplerate));\nvw = twopi * vF1 * pf * ((abs(drum - 0) < 0.5) * 3.650000 + (abs(drum - 1) < 0.5) * 3.250000) / samplerate; vCc10 = cos(vw); vSn10 = sin(vw); vR10 = exp(-6.907755279 * (1 + (vG10 - 1) * vC) / (((abs(drum - 0) < 0.5) * 0.280000 + (abs(drum - 1) < 0.5) * 0.330000) * decayS * samplerate));\nvw = twopi * vF1 * pf * ((abs(drum - 0) < 0.5) * 4.970000 + (abs(drum - 1) < 0.5) * 3.900000) / samplerate; vCc11 = cos(vw); vSn11 = sin(vw); vR11 = exp(-6.907755279 * (1 + (vG11 - 1) * vC) / (((abs(drum - 0) < 0.5) * 0.260000 + (abs(drum - 1) < 0.5) * 0.340000) * decayS * samplerate));\nvw = twopi * 125.0 / samplerate; vCc12 = cos(vw); vSn12 = sin(vw); vR12 = exp(-115.129255 * (1 + (vG12 - 1) * vC) / (decayS * samplerate));\nvBg = tan(pi * 2000 / samplerate); vBa113 = 1 / (1 + vBg * (vBg + 0.500000)); vBa213 = vBg * vBa113; vBa313 = vBg * vBa213; vR13 = exp(-31.398888 * (1 + (vG13 - 1) * vC) / (decayS * samplerate));\nvBg = tan(pi * 2800 / samplerate); vBa114 = 1 / (1 + vBg * (vBg + 0.500000)); vBa214 = vBg * vBa114; vBa314 = vBg * vBa214; vR14 = exp(-34.538776 * (1 + (vG14 - 1) * vC) / (decayS * samplerate));\nvBg = tan(pi * 4000 / samplerate); vBa115 = 1 / (1 + vBg * (vBg + 0.500000)); vBa215 = vBg * vBa115; vBa315 = vBg * vBa215; vR15 = exp(-43.173470 * (1 + (vG15 - 1) * vC) / (decayS * samplerate));\nvBg = tan(pi * 5800 / samplerate); vBa116 = 1 / (1 + vBg * (vBg + 0.500000)); vBa216 = vBg * vBa116; vBa316 = vBg * vBa216; vR16 = exp(-57.564627 * (1 + (vG16 - 1) * vC) / (decayS * samplerate));\nvBg = tan(pi * 8500 / samplerate); vBa117 = 1 / (1 + vBg * (vBg + 0.500000)); vBa217 = vBg * vBa117; vBa317 = vBg * vBa217; vR17 = exp(-76.752836 * (1 + (vG17 - 1) * vC) / (decayS * samplerate));\n}\nvXn = vR0 * (vCc0 * vX0 - vSn0 * vY0) + 0.737369 * vW0 * vE2; vY0 = vR0 * (vSn0 * vX0 + vCc0 * vY0) + 0.675490 * vW0 * vE2; vX0 = vXn;\nvXn = vR1 * (vCc1 * vX1 - vSn1 * vY1) + -0.087426 * vW1 * vE2; vY1 = vR1 * (vSn1 * vX1 + vCc1 * vY1) + -0.996171 * vW1 * vE2; vX1 = vXn;\nvXn = vR2 * (vCc2 * vX2 - vSn2 * vY2) + -0.608439 * vW2 * vE2; vY2 = vR2 * (vSn2 * vX2 + vCc2 * vY2) + 0.793601 * vW2 * vE2; vX2 = vXn;\nvXn = vR3 * (vCc3 * vX3 - vSn3 * vY3) + 0.984713 * vW3 * vE2; vY3 = vR3 * (vSn3 * vX3 + vCc3 * vY3) + -0.174182 * vW3 * vE2; vX3 = vXn;\nvXn = vR4 * (vCc4 * vX4 - vSn4 * vY4) + -0.843755 * vW4 * vE2; vY4 = vR4 * (vSn4 * vX4 + vCc4 * vY4) + -0.536728 * vW4 * vE2; vX4 = vXn;\nvXn = vR5 * (vCc5 * vX5 - vSn5 * vY5) + 0.259604 * vW5 * vE2; vY5 = vR5 * (vSn5 * vX5 + vCc5 * vY5) + 0.965715 * vW5 * vE2; vX5 = vXn;\nvXn = vR6 * (vCc6 * vX6 - vSn6 * vY6) + 0.460907 * vW6 * vE2; vY6 = vR6 * (vSn6 * vX6 + vCc6 * vY6) + -0.887448 * vW6 * vE2; vX6 = vXn;\nvXn = vR7 * (vCc7 * vX7 - vSn7 * vY7) + -0.939321 * vW7 * vE2; vY7 = vR7 * (vSn7 * vX7 + vCc7 * vY7) + 0.343039 * vW7 * vE2; vX7 = vXn;\nvXn = vR8 * (vCc8 * vX8 - vSn8 * vY8) + 0.924346 * vW8 * vE2; vY8 = vR8 * (vSn8 * vX8 + vCc8 * vY8) + 0.381556 * vW8 * vE2; vX8 = vXn;\nvXn = vR9 * (vCc9 * vX9 - vSn9 * vY9) + -0.423846 * vW9 * vE2; vY9 = vR9 * (vSn9 * vX9 + vCc9 * vY9) + -0.905734 * vW9 * vE2; vX9 = vXn;\nvXn = vR10 * (vCc10 * vX10 - vSn10 * vY10) + -0.299284 * vW10 * vE2; vY10 = vR10 * (vSn10 * vX10 + vCc10 * vY10) + 0.954164 * vW10 * vE2; vX10 = vXn;\nvXn = vR11 * (vCc11 * vX11 - vSn11 * vY11) + 0.865211 * vW11 * vE2; vY11 = vR11 * (vSn11 * vX11 + vCc11 * vY11) + -0.501408 * vW11 * vE2; vX11 = vXn;\nvXn = vR12 * (vCc12 * vX12 - vSn12 * vY12) + -0.976676 * vW12 * vE2; vY12 = vR12 * (vSn12 * vX12 + vCc12 * vY12) + -0.214719 * vW12 * vE2; vX12 = vXn;\nvKn = 1 - exp(-1 / (0.0003 * samplerate)); vP1 = vP1 + vKn * (vIt - vP1); vP2 = vP2 + vKn * (vP1 - vP2);\nvBe13 = vBe13 * vR13 + vBg13 * vP2; vQ3 = nz * vBe13 - vBi213; vQb = vBa113 * vBi113 + vBa213 * vQ3; vQl = vBi213 + vBa213 * vBi113 + vBa313 * vQ3; vBi113 = 2 * vQb - vBi113; vBi213 = 2 * vQl - vBi213; vY13 = vQb / 2.0;\nvBe14 = vBe14 * vR14 + vBg14 * vP2; vQ3 = nz * vBe14 - vBi214; vQb = vBa114 * vBi114 + vBa214 * vQ3; vQl = vBi214 + vBa214 * vBi114 + vBa314 * vQ3; vBi114 = 2 * vQb - vBi114; vBi214 = 2 * vQl - vBi214; vY14 = vQb / 2.0;\nvBe15 = vBe15 * vR15 + vBg15 * vP2; vQ3 = nz * vBe15 - vBi215; vQb = vBa115 * vBi115 + vBa215 * vQ3; vQl = vBi215 + vBa215 * vBi115 + vBa315 * vQ3; vBi115 = 2 * vQb - vBi115; vBi215 = 2 * vQl - vBi215; vY15 = vQb / 2.0;\nvBe16 = vBe16 * vR16 + vBg16 * vP2; vQ3 = nz * vBe16 - vBi216; vQb = vBa116 * vBi116 + vBa216 * vQ3; vQl = vBi216 + vBa216 * vBi116 + vBa316 * vQ3; vBi116 = 2 * vQb - vBi116; vBi216 = 2 * vQl - vBi216; vY16 = vQb / 2.0;\nvBe17 = vBe17 * vR17 + vBg17 * vP2; vQ3 = nz * vBe17 - vBi217; vQb = vBa117 * vBi117 + vBa217 * vQ3; vQl = vBi217 + vBa217 * vBi117 + vBa317 * vQ3; vBi117 = 2 * vQb - vBi117; vBi217 = 2 * vQl - vBi217; vY17 = vQb / 2.0;\nvAe = vAe * vTa;                                      // the head's tone swells in (a soft contact) while the tick and the noise bands start at once\nvSm = (1 - vAe) * (vY0 + vY1 + vY2 + vY3 + vY4 + vY5 + vY6 + vY7 + vY8 + vY9 + vY10 + vY11 + vY12) + vY13 + vY14 + vY15 + vY16 + vY17;\nvNx = nz * vNe; vNe = vNe * vNr;\nvNv3 = vNx - vI2; vNb = vNa1 * vI1 + vNa2 * vNv3; vNl = vI2 + vNa2 * vI1 + vNa3 * vNv3; vI1 = 2 * vNb - vI1; vI2 = 2 * vNl - vI2;\nvmix = (vSm + vNk * vNb) * masterG;\nvax = abs(vmix); vlim = sign(vmix) * (min(vax, 0.8) + 0.2 * tanh(max(vax - 0.8, 0) * 5));\nout1 = vlim + 0 * in1; out2 = vlim + 0 * in2;\n",
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
						"drum",
						0
					],
					"destination": [
						"pre_drum",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_drum",
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
						"drum",
						0
					],
					"destination": [
						"pre_drum_view",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_drum_view",
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
						"drum",
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
						"stroke",
						0
					],
					"destination": [
						"pre_stroke_view",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_stroke_view",
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
						"stroke",
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
						"vary",
						0
					],
					"destination": [
						"pre_vary",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_vary",
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
						"vary",
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
			}
		],
		"dependency_cache": [],
		"autosave": 0,
		"parameters": {
			"drum": [
				"Drum",
				"Drum",
				0
			],
			"stroke": [
				"Stroke",
				"Stroke",
				0
			],
			"tune": [
				"Tune",
				"Tune",
				0
			],
			"decay": [
				"Decay",
				"Decay",
				0
			],
			"skin": [
				"Skin",
				"Skin",
				0
			],
			"shell": [
				"Shell",
				"Shell",
				0
			],
			"touch": [
				"Touch",
				"Touch",
				0
			],
			"press": [
				"Press",
				"Press",
				0
			],
			"vary": [
				"Vary",
				"Vary",
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
					"name": "Drum",
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
						"Drum",
						"Stroke",
						"Tune",
						"Decay",
						"Skin",
						"Shell",
						"Touch",
						"Volume"
					]
				},
				"1": {
					"index": 1,
					"name": "Hand",
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
						"Press",
						"Vary",
						"-",
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