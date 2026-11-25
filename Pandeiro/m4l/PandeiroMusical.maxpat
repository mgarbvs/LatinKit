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
		"description": "Pandeiro Musical: a pandeiro (frame-drum head and jingles) or a tamborim as a modal head plus a PhISEM jingle model fitted to recordings, played melodically: the MIDI key sets the pitch of the head.",
		"boxes": [
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
						280,
						50,
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
						1600,
						420,
						60,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_jingles",
					"maxclass": "newobj",
					"text": "prepend jingles",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						1190,
						105,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_jingles",
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
						96.0,
						52.0,
						13.0
					],
					"patching_rect": [
						2140,
						340,
						52,
						13
					]
				}
			},
			{
				"box": {
					"id": "jingles",
					"varname": "jingles",
					"parameter_enable": 1,
					"annotation_name": "Jingles",
					"annotation": "How much the jingles (platinelas) answer every hit and the Shake. 0 is a bare head. The Tamborim has no jingles: here the control does nothing.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Jingles",
							"parameter_shortname": "Jingles",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								100
							],
							"parameter_unitstyle": 9,
							"parameter_units": "Jingles %.0f"
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
						96.0,
						52.0,
						13.0
					],
					"patching_rect": [
						2050,
						340,
						52,
						13
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
					"annotation": "How much every hit differs from the last: the loudness of each of the head's tones is nudged at random at every hit (about 1.5 dB at 100 %); the jingles and the noise differ every hit anyway. 0 repeats the same sinusoids.",
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
					"annotation": "The mod wheel presses the head (a thumb leaning on it): this many semitones up at full wheel. The body and the jingles do not move.",
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
					"annotation": "The body of the drum: how much the low 125 Hz thump speaks.",
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
					"annotation": "How long the head and the jingles ring, in percent of the natural time (a pandeiro head rings about a quarter of a second, the jingles a little longer).",
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
					"annotation": "Tuning of the head in semitones, added to the MIDI key: the head's fundamental is the key's pitch x 2^(Tune/12). The 125 Hz body and the jingles do not move.",
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
					"annotation": "Which stroke a note plays. Pandeiro: Thumb (the open bass tone), Finger, Slap, Rim, Shake (the jingles alone, no head hit), Roll (about 18 rapid finger taps a second for 1.1 s). Tamborim: Open (the stick on the head), Mute (the hand damps it), Finger. A stroke an instrument does not have plays the nearest one it does (the panel shows which). Changing it between hits works: the new stroke damps the ring already on the head.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Stroke",
							"parameter_shortname": "Stroke",
							"parameter_type": 2,
							"parameter_enum": [
								"Thumb",
								"Finger",
								"Slap",
								"Rim",
								"Shake",
								"Roll",
								"Open",
								"Mute"
							],
							"parameter_mmax": 7,
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
					"id": "pre_inst_view",
					"maxclass": "newobj",
					"text": "prepend inst",
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
					"id": "pre_inst",
					"maxclass": "newobj",
					"text": "prepend inst",
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
					"id": "inst",
					"varname": "inst",
					"parameter_enable": 1,
					"annotation_name": "Instrument",
					"annotation": "Which instrument: Pandeiro (a frame-drum head with jingles, the platinelas) or Tamborim (a small tight head played with a stick, no jingles). The MIDI key sets the pitch of the head.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Instrument",
							"parameter_shortname": "Instrument",
							"parameter_type": 2,
							"parameter_enum": [
								"Pandeiro",
								"Tamborim"
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
					"id": "hdr_Instrument",
					"maxclass": "comment",
					"text": "Instrument",
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
					"text": "js pandeiro_push.js",
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
					"filename": "pandeiro_view.js",
					"border": 0,
					"parameter_enable": 0,
					"annotation_name": "Instrument",
					"annotation": "The instrument (pandeiro or tamborim), the hand or stick where the stroke is played and the stroke's name (the one actually played: a stroke the instrument lacks is mapped to the nearest). It flashes when a note hits.",
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
					"text": "js pandeiro_midi_musical.js",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						20,
						200,
						189,
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
									"code": "Param inst(0);\nParam stroke(0);\nParam tune(0);\nParam decay(100);\nParam skin(50);\nParam shell(50);\nParam touch(50);\nParam press(5);\nParam vary(100);\nParam jingles(100);\nParam volume(-9);\nParam trg(0);\nParam vel(1);\nParam mw(0);\nParam note(60);\nHistory cnt(0);\nHistory pf(1);\nHistory pt(0);\nHistory vC(0);\nHistory vCk(0.99);\nHistory vE1(0);\nHistory vE2(0);\nHistory vK(0.5);\nHistory vNe(0);\nHistory vNr(0.99);\nHistory vI1(0);\nHistory vI2(0);\nHistory vNa1(0);\nHistory vNa2(0);\nHistory vNa3(0);\nHistory vNk(1);\nHistory vAm(0);\nHistory vF1(250);\nHistory vTd(1);\nHistory vNs(1);\nHistory vIt(0);\nHistory vP1(0);\nHistory vP2(0);\nHistory vFd(0);\nHistory vFv(0);\nHistory vRn(0);\nHistory vAe(0);\nHistory vTa(0.9);\nHistory vJts(1);\nHistory vJash(1);\nHistory vJmsr(48);\nHistory vJo(0);\nHistory vJhh(0);\nHistory vJin(0);\nHistory vJpe(0);\nHistory vJp(0);\nHistory vJcl(0);\nHistory vJraw(0);\nHistory vJyy(0);\nHistory vJfh(0);\nHistory vJwh(0);\nHistory vJalh(0);\nHistory vJiah(1);\nHistory vJchh(0);\nHistory vJfmx(0);\nHistory vJfr(0);\nHistory vJw(0);\nHistory vJal(0);\nHistory vJia(0);\nHistory vJgx(0);\nHistory vJa(0);\nHistory vJpa(0);\nHistory vJdn(0);\nHistory vJy1(0);\nHistory vJy2(0);\nHistory vJen(0);\nHistory vJsnd(0);\nHistory vJhx1(0);\nHistory vJhx2(0);\nHistory vJhz1(0);\nHistory vJhz2(0);\nHistory vJjx1(0);\nHistory vJjx2(0);\nHistory vJjz1(0);\nHistory vJjz2(0);\nHistory vJamp(0);\nHistory vJdE(0);\nHistory vJca(0);\nHistory vJrt(0);\nHistory vJsd(0);\nHistory vJgr(0);\nHistory vJsp(0);\nHistory vJhb(0);\nHistory vJh2(0);\nHistory vJh3(0);\nHistory vJ0x1(0);\nHistory vJ0x2(0);\nHistory vJ0z1(0);\nHistory vJ0z2(0);\nHistory vJ0b(0);\nHistory vJ0c1(0);\nHistory vJ0c2(0);\nHistory vJ0g(0);\nHistory vJ1x1(0);\nHistory vJ1x2(0);\nHistory vJ1z1(0);\nHistory vJ1z2(0);\nHistory vJ1b(0);\nHistory vJ1c1(0);\nHistory vJ1c2(0);\nHistory vJ1g(0);\nHistory vJ2x1(0);\nHistory vJ2x2(0);\nHistory vJ2z1(0);\nHistory vJ2z2(0);\nHistory vJ2b(0);\nHistory vJ2c1(0);\nHistory vJ2c2(0);\nHistory vJ2g(0);\nHistory vX0(0);\nHistory vY0(0);\nHistory vW0(0);\nHistory vG0(1);\nHistory vCc0(1);\nHistory vSn0(0);\nHistory vR0(0.999);\nHistory vX1(0);\nHistory vY1(0);\nHistory vW1(0);\nHistory vG1(1);\nHistory vCc1(1);\nHistory vSn1(0);\nHistory vR1(0.999);\nHistory vX2(0);\nHistory vY2(0);\nHistory vW2(0);\nHistory vG2(1);\nHistory vCc2(1);\nHistory vSn2(0);\nHistory vR2(0.999);\nHistory vX3(0);\nHistory vY3(0);\nHistory vW3(0);\nHistory vG3(1);\nHistory vCc3(1);\nHistory vSn3(0);\nHistory vR3(0.999);\nHistory vX4(0);\nHistory vY4(0);\nHistory vW4(0);\nHistory vG4(1);\nHistory vCc4(1);\nHistory vSn4(0);\nHistory vR4(0.999);\nHistory vX5(0);\nHistory vY5(0);\nHistory vW5(0);\nHistory vG5(1);\nHistory vCc5(1);\nHistory vSn5(0);\nHistory vR5(0.999);\nHistory vX6(0);\nHistory vY6(0);\nHistory vW6(0);\nHistory vG6(1);\nHistory vCc6(1);\nHistory vSn6(0);\nHistory vR6(0.999);\nHistory vX7(0);\nHistory vY7(0);\nHistory vW7(0);\nHistory vG7(1);\nHistory vCc7(1);\nHistory vSn7(0);\nHistory vR7(0.999);\nHistory vX8(0);\nHistory vY8(0);\nHistory vW8(0);\nHistory vG8(1);\nHistory vCc8(1);\nHistory vSn8(0);\nHistory vR8(0.999);\nHistory vX9(0);\nHistory vY9(0);\nHistory vW9(0);\nHistory vG9(1);\nHistory vCc9(1);\nHistory vSn9(0);\nHistory vR9(0.999);\nHistory vX10(0);\nHistory vY10(0);\nHistory vW10(0);\nHistory vG10(1);\nHistory vCc10(1);\nHistory vSn10(0);\nHistory vR10(0.999);\nHistory vX11(0);\nHistory vY11(0);\nHistory vW11(0);\nHistory vG11(1);\nHistory vCc11(1);\nHistory vSn11(0);\nHistory vR11(0.999);\nHistory vX12(0);\nHistory vY12(0);\nHistory vW12(0);\nHistory vG12(1);\nHistory vCc12(1);\nHistory vSn12(0);\nHistory vR12(0.999);\nHistory vX13(0);\nHistory vY13(0);\nHistory vW13(0);\nHistory vG13(1);\nHistory vCc13(1);\nHistory vSn13(0);\nHistory vR13(0.999);\nHistory vBe13(0);\nHistory vBi113(0);\nHistory vBi213(0);\nHistory vBa113(0);\nHistory vBa213(0);\nHistory vBa313(0);\nHistory vBg13(0);\nHistory vX14(0);\nHistory vY14(0);\nHistory vW14(0);\nHistory vG14(1);\nHistory vCc14(1);\nHistory vSn14(0);\nHistory vR14(0.999);\nHistory vBe14(0);\nHistory vBi114(0);\nHistory vBi214(0);\nHistory vBa114(0);\nHistory vBa214(0);\nHistory vBa314(0);\nHistory vBg14(0);\nHistory vX15(0);\nHistory vY15(0);\nHistory vW15(0);\nHistory vG15(1);\nHistory vCc15(1);\nHistory vSn15(0);\nHistory vR15(0.999);\nHistory vBe15(0);\nHistory vBi115(0);\nHistory vBi215(0);\nHistory vBa115(0);\nHistory vBa215(0);\nHistory vBa315(0);\nHistory vBg15(0);\nHistory vX16(0);\nHistory vY16(0);\nHistory vW16(0);\nHistory vG16(1);\nHistory vCc16(1);\nHistory vSn16(0);\nHistory vR16(0.999);\nHistory vBe16(0);\nHistory vBi116(0);\nHistory vBi216(0);\nHistory vBa116(0);\nHistory vBa216(0);\nHistory vBa316(0);\nHistory vBg16(0);\nHistory vX17(0);\nHistory vY17(0);\nHistory vW17(0);\nHistory vG17(1);\nHistory vCc17(1);\nHistory vSn17(0);\nHistory vR17(0.999);\nHistory vBe17(0);\nHistory vBi117(0);\nHistory vBi217(0);\nHistory vBa117(0);\nHistory vBa217(0);\nHistory vBa317(0);\nHistory vBg17(0);\n\ndecayS = decay * 0.01;\nshellG = shell * 0.02;\nskinT = (skin - 50) * 0.02 * 6 / 6.0206;                      // +-6 dB per octave of mode ratio at the ends\ntouchT = (touch - 50) * 0.02;\npfT = exp2(mw * press / 12);\nmasterG = dbtoa(volume);\ncnt = cnt + 1; ctl = cnt >= 16; cnt = cnt - ctl * 16;\nif (ctl) { pf = pf + 0.2 * (pfT - pf); }\nnz = noise();\nvh1 = trg != pt; pt = trg;\nvh2 = 0;\nif (vFd > 0.5) { vFd = vFd - 1; vh2 = vFd < 0.5; }\nvh = max(vh1, vh2 * (1 - vh1));\nvIm = 0; vIt = 0;\nif (vh > 0.5) {\nvr1 = vh1 * (abs(stroke - 5) < 0.5);                  // a Roll starts: this tap is the first of ROLL_N\nvk = vh1 * ((abs(inst - 0) < 0.5) * (abs(stroke - 0) < 0.5) * 0 + (abs(inst - 0) < 0.5) * (abs(stroke - 1) < 0.5) * 1 + (abs(inst - 0) < 0.5) * (abs(stroke - 2) < 0.5) * 2 + (abs(inst - 0) < 0.5) * (abs(stroke - 3) < 0.5) * 3 + (abs(inst - 0) < 0.5) * (abs(stroke - 4) < 0.5) * 4 + (abs(inst - 0) < 0.5) * (abs(stroke - 5) < 0.5) * 1 + (abs(inst - 0) < 0.5) * (abs(stroke - 6) < 0.5) * 0 + (abs(inst - 0) < 0.5) * (abs(stroke - 7) < 0.5) * 1 + (abs(inst - 1) < 0.5) * (abs(stroke - 0) < 0.5) * 5 + (abs(inst - 1) < 0.5) * (abs(stroke - 1) < 0.5) * 7 + (abs(inst - 1) < 0.5) * (abs(stroke - 2) < 0.5) * 5 + (abs(inst - 1) < 0.5) * (abs(stroke - 3) < 0.5) * 5 + (abs(inst - 1) < 0.5) * (abs(stroke - 4) < 0.5) * 7 + (abs(inst - 1) < 0.5) * (abs(stroke - 5) < 0.5) * 7 + (abs(inst - 1) < 0.5) * (abs(stroke - 6) < 0.5) * 5 + (abs(inst - 1) < 0.5) * (abs(stroke - 7) < 0.5) * 6) + (1 - vh1) * ((abs(inst - 0) < 0.5) * 1.000000 + (abs(inst - 1) < 0.5) * 7.000000);   // the table row: the menu's (per instrument), or the Finger row for the taps of a Roll\nvdv = vh1 * vel * (1 - vr1 * (1 - ((abs(inst - 0) < 0.5) * 0.149000 + (abs(inst - 1) < 0.5) * 0.600000))) + (1 - vh1) * vFv;     // every tap of a Roll, the first too, is ROLL_REL x the velocity (the recording's roll has no louder first tap)\nvRn = vr1 * 19 + (1 - vh1) * (vRn - 1);               // taps still to come\nvFd = (vr1 + (1 - vh1) * (vRn > 0.5)) * 0.054945054945054944 * samplerate;   // a new stroke (vh1, no Roll) cancels the pending taps\nvFv = vr1 * vdv + (1 - vr1) * vFv;\nvg = pow(vdv, 1.4);\nvJs = nz * 1000 + trg; vJv = vary * 0.01;\nvAm = vg * ((abs(vk - 0) < 0.5) * 0.186900 + (abs(vk - 1) < 0.5) * 0.104900 + (abs(vk - 2) < 0.5) * 0.187600 + (abs(vk - 3) < 0.5) * 0.720500 + (abs(vk - 4) < 0.5) * 0.170500 + (abs(vk - 5) < 0.5) * 0.234400 + (abs(vk - 6) < 0.5) * 0.655200 + (abs(vk - 7) < 0.5) * 0.410600);\nvIm = vAm; vIt = vAm;\nvAe = 1; vTa = exp(-1 / (((abs(vk - 0) < 0.5) * 0.001340 + (abs(vk - 1) < 0.5) * 0.000500 + (abs(vk - 2) < 0.5) * 0.003670 + (abs(vk - 3) < 0.5) * 0.001060 + (abs(vk - 4) < 0.5) * 0.000100 + (abs(vk - 5) < 0.5) * 0.002470 + (abs(vk - 6) < 0.5) * 0.004000 + (abs(vk - 7) < 0.5) * 0.001680) * samplerate));\nvfc = ((abs(vk - 0) < 0.5) * 2500.000000 + (abs(vk - 1) < 0.5) * 3000.000000 + (abs(vk - 2) < 0.5) * 6000.000000 + (abs(vk - 3) < 0.5) * 6000.000000 + (abs(vk - 4) < 0.5) * 2000.000000 + (abs(vk - 5) < 0.5) * 6000.000000 + (abs(vk - 6) < 0.5) * 5000.000000 + (abs(vk - 7) < 0.5) * 4000.000000) * exp2(touchT * 1.5 + (vdv - 0.6) * 0.8);\nvK = 1 - exp(-twopi * min(vfc, 18000) / samplerate);\nvC = 1;\nvCk = exp(-16 / (((abs(vk - 0) < 0.5) * 0.004000 + (abs(vk - 1) < 0.5) * 0.004000 + (abs(vk - 2) < 0.5) * 0.004000 + (abs(vk - 3) < 0.5) * 0.004000 + (abs(vk - 4) < 0.5) * 0.004000 + (abs(vk - 5) < 0.5) * 0.004000 + (abs(vk - 6) < 0.5) * 0.012000 + (abs(vk - 7) < 0.5) * 0.012000) * samplerate));\nvNe = vAm * ((abs(vk - 0) < 0.5) * 0.067900 + (abs(vk - 1) < 0.5) * 0.029700 + (abs(vk - 2) < 0.5) * 0.093400 + (abs(vk - 3) < 0.5) * 0.026800 + (abs(vk - 4) < 0.5) * 0.390300 + (abs(vk - 5) < 0.5) * 0.022800 + (abs(vk - 6) < 0.5) * 0.363200 + (abs(vk - 7) < 0.5) * 0.916600) * (1 + touchT);\nvNr = exp(-1 / (((abs(vk - 0) < 0.5) * 0.000800 + (abs(vk - 1) < 0.5) * 0.000800 + (abs(vk - 2) < 0.5) * 0.000800 + (abs(vk - 3) < 0.5) * 0.000800 + (abs(vk - 4) < 0.5) * 0.000800 + (abs(vk - 5) < 0.5) * 0.000800 + (abs(vk - 6) < 0.5) * 0.000800 + (abs(vk - 7) < 0.5) * 0.000800) * samplerate));\nvNg = tan(pi * ((abs(vk - 0) < 0.5) * 1380.000000 + (abs(vk - 1) < 0.5) * 1360.000000 + (abs(vk - 2) < 0.5) * 1130.000000 + (abs(vk - 3) < 0.5) * 1510.000000 + (abs(vk - 4) < 0.5) * 2740.000000 + (abs(vk - 5) < 0.5) * 1780.000000 + (abs(vk - 6) < 0.5) * 2160.000000 + (abs(vk - 7) < 0.5) * 1480.000000) / samplerate); vNk = 1 / ((abs(vk - 0) < 0.5) * 0.700000 + (abs(vk - 1) < 0.5) * 0.700000 + (abs(vk - 2) < 0.5) * 0.700000 + (abs(vk - 3) < 0.5) * 0.700000 + (abs(vk - 4) < 0.5) * 0.700000 + (abs(vk - 5) < 0.5) * 0.700000 + (abs(vk - 6) < 0.5) * 0.700000 + (abs(vk - 7) < 0.5) * 0.700000);\nvNa1 = 1 / (1 + vNg * (vNg + vNk)); vNa2 = vNg * vNa1; vNa3 = vNg * vNa2;\nvJts = 29.71 * (((abs(vk - 0) < 0.5) * 2.164000 + (abs(vk - 1) < 0.5) * 1.474000 + (abs(vk - 2) < 0.5) * 2.685000 + (abs(vk - 3) < 0.5) * 1.869000 + (abs(vk - 4) < 0.5) * 1.183000 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 1.000000) * decayS) * vJmsr; vJash = ((abs(vk - 0) < 0.5) * 0.500000 + (abs(vk - 1) < 0.5) * 0.500000 + (abs(vk - 2) < 0.5) * 0.500000 + (abs(vk - 3) < 0.5) * 0.500000 + (abs(vk - 4) < 0.5) * 2.950000 + (abs(vk - 5) < 0.5) * 2.000000 + (abs(vk - 6) < 0.5) * 2.000000 + (abs(vk - 7) < 0.5) * 2.000000) * vJmsr;\nvJdE = exp(-1 / vJts); vJca = 1 - exp(-1 / vJash); vJamp = 1 + 2.7 * vJash / vJts; vJpa = vg * ((abs(vk - 0) < 0.5) * 0.370700 + (abs(vk - 1) < 0.5) * 0.352500 + (abs(vk - 2) < 0.5) * 0.450100 + (abs(vk - 3) < 0.5) * 0.261000 + (abs(vk - 4) < 0.5) * 0.480400 + (abs(vk - 5) < 0.5) * 0.000000 + (abs(vk - 6) < 0.5) * 0.000000 + (abs(vk - 7) < 0.5) * 0.000000) * jingles * 0.01 * ((abs(inst - 0) < 0.5) * 1.000000 + (abs(inst - 1) < 0.5) * 0.000000) * (1 + (vr1 + 1 - vh1) * 13.350000); vJdn = 0.002 * samplerate;\nvFh = mtof(note) * exp2(tune / 12) * pf;\nvW0 = ((abs(vk - 0) < 0.5) * 0.204174 + (abs(vk - 1) < 0.5) * 0.197242 + (abs(vk - 2) < 0.5) * 0.177828 + (abs(vk - 3) < 0.5) * 0.079433 + (abs(vk - 4) < 0.5) * 0.021135 + (abs(vk - 5) < 0.5) * 0.048417 + (abs(vk - 6) < 0.5) * 0.087096 + (abs(vk - 7) < 0.5) * 0.568853) * exp(skinT * ((abs(inst - 0) < 0.5) * -0.579818 + (abs(inst - 1) < 0.5) * -0.430783)) * (vFh * ((abs(inst - 0) < 0.5) * 0.560000 + (abs(inst - 1) < 0.5) * 0.650000) < 0.45 * samplerate) * exp(0.299115 * vJv * (fract(sin(vJs + 0.0) * 43758.5453) * 2 - 1)); vG0 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 13.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.400000 + (abs(vk - 6) < 0.5) * 13.000000 + (abs(vk - 7) < 0.5) * 13.000000;\nvW1 = ((abs(vk - 0) < 0.5) * 0.660693 + (abs(vk - 1) < 0.5) * 0.668344 + (abs(vk - 2) < 0.5) * 0.446684 + (abs(vk - 3) < 0.5) * 1.000000 + (abs(vk - 4) < 0.5) * 0.169824 + (abs(vk - 5) < 0.5) * 0.037584 + (abs(vk - 6) < 0.5) * 0.093325 + (abs(vk - 7) < 0.5) * 0.421697) * exp(skinT * ((abs(inst - 0) < 0.5) * 0.000000 + (abs(inst - 1) < 0.5) * -0.150823)) * (vFh * ((abs(inst - 0) < 0.5) * 1.000000 + (abs(inst - 1) < 0.5) * 0.860000) < 0.45 * samplerate) * exp(0.299115 * vJv * (fract(sin(vJs + 78.233) * 43758.5453) * 2 - 1)); vG1 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 13.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.400000 + (abs(vk - 6) < 0.5) * 13.000000 + (abs(vk - 7) < 0.5) * 13.000000;\nvW2 = ((abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 0.870964 + (abs(vk - 2) < 0.5) * 0.582103 + (abs(vk - 3) < 0.5) * 0.331131 + (abs(vk - 4) < 0.5) * 0.121619 + (abs(vk - 5) < 0.5) * 0.211349 + (abs(vk - 6) < 0.5) * 0.036728 + (abs(vk - 7) < 0.5) * 0.146218) * exp(skinT * ((abs(inst - 0) < 0.5) * 0.148420 + (abs(inst - 1) < 0.5) * 0.000000)) * (vFh * ((abs(inst - 0) < 0.5) * 1.160000 + (abs(inst - 1) < 0.5) * 1.000000) < 0.45 * samplerate) * exp(0.299115 * vJv * (fract(sin(vJs + 156.466) * 43758.5453) * 2 - 1)); vG2 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 13.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.400000 + (abs(vk - 6) < 0.5) * 13.000000 + (abs(vk - 7) < 0.5) * 13.000000;\nvW3 = ((abs(vk - 0) < 0.5) * 0.000316 + (abs(vk - 1) < 0.5) * 0.000484 + (abs(vk - 2) < 0.5) * 0.000316 + (abs(vk - 3) < 0.5) * 0.000316 + (abs(vk - 4) < 0.5) * 0.001884 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 0.426580 + (abs(vk - 7) < 0.5) * 0.077625) * exp(skinT * ((abs(inst - 0) < 0.5) * 0.239017 + (abs(inst - 1) < 0.5) * 0.076961)) * (vFh * ((abs(inst - 0) < 0.5) * 1.270000 + (abs(inst - 1) < 0.5) * 1.080000) < 0.45 * samplerate) * exp(0.299115 * vJv * (fract(sin(vJs + 234.699) * 43758.5453) * 2 - 1)); vG3 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 13.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.400000 + (abs(vk - 6) < 0.5) * 13.000000 + (abs(vk - 7) < 0.5) * 13.000000;\nvW4 = ((abs(vk - 0) < 0.5) * 0.462381 + (abs(vk - 1) < 0.5) * 0.767361 + (abs(vk - 2) < 0.5) * 0.860994 + (abs(vk - 3) < 0.5) * 0.032359 + (abs(vk - 4) < 0.5) * 0.027227 + (abs(vk - 5) < 0.5) * 0.446684 + (abs(vk - 6) < 0.5) * 0.257040 + (abs(vk - 7) < 0.5) * 0.190546) * exp(skinT * ((abs(inst - 0) < 0.5) * 0.322083 + (abs(inst - 1) < 0.5) * 0.173953)) * (vFh * ((abs(inst - 0) < 0.5) * 1.380000 + (abs(inst - 1) < 0.5) * 1.190000) < 0.45 * samplerate) * exp(0.299115 * vJv * (fract(sin(vJs + 312.932) * 43758.5453) * 2 - 1)); vG4 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 13.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.400000 + (abs(vk - 6) < 0.5) * 13.000000 + (abs(vk - 7) < 0.5) * 13.000000;\nvW5 = ((abs(vk - 0) < 0.5) * 0.346737 + (abs(vk - 1) < 0.5) * 0.549541 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 0.038019 + (abs(vk - 4) < 0.5) * 0.030903 + (abs(vk - 5) < 0.5) * 0.011092 + (abs(vk - 6) < 0.5) * 0.085114 + (abs(vk - 7) < 0.5) * 0.147911) * exp(skinT * ((abs(inst - 0) < 0.5) * 0.463734 + (abs(inst - 1) < 0.5) * 0.223144)) * (vFh * ((abs(inst - 0) < 0.5) * 1.590000 + (abs(inst - 1) < 0.5) * 1.250000) < 0.45 * samplerate) * exp(0.299115 * vJv * (fract(sin(vJs + 391.165) * 43758.5453) * 2 - 1)); vG5 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 13.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.400000 + (abs(vk - 6) < 0.5) * 13.000000 + (abs(vk - 7) < 0.5) * 13.000000;\nvW6 = ((abs(vk - 0) < 0.5) * 0.211349 + (abs(vk - 1) < 0.5) * 0.457088 + (abs(vk - 2) < 0.5) * 0.530884 + (abs(vk - 3) < 0.5) * 0.046774 + (abs(vk - 4) < 0.5) * 0.108393 + (abs(vk - 5) < 0.5) * 0.141254 + (abs(vk - 6) < 0.5) * 0.358922 + (abs(vk - 7) < 0.5) * 0.630957) * exp(skinT * ((abs(inst - 0) < 0.5) * 0.587787 + (abs(inst - 1) < 0.5) * 0.285179)) * (vFh * ((abs(inst - 0) < 0.5) * 1.800000 + (abs(inst - 1) < 0.5) * 1.330000) < 0.45 * samplerate) * exp(0.299115 * vJv * (fract(sin(vJs + 469.398) * 43758.5453) * 2 - 1)); vG6 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 13.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.400000 + (abs(vk - 6) < 0.5) * 13.000000 + (abs(vk - 7) < 0.5) * 13.000000;\nvW7 = ((abs(vk - 0) < 0.5) * 0.199526 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 0.901571 + (abs(vk - 3) < 0.5) * 0.058884 + (abs(vk - 4) < 0.5) * 0.091201 + (abs(vk - 5) < 0.5) * 0.162181 + (abs(vk - 6) < 0.5) * 0.506991 + (abs(vk - 7) < 0.5) * 1.000000) * exp(skinT * ((abs(inst - 0) < 0.5) * 0.693147 + (abs(inst - 1) < 0.5) * 0.398776)) * (vFh * ((abs(inst - 0) < 0.5) * 2.000000 + (abs(inst - 1) < 0.5) * 1.490000) < 0.45 * samplerate) * exp(0.299115 * vJv * (fract(sin(vJs + 547.6310000000001) * 43758.5453) * 2 - 1)); vG7 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 13.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.400000 + (abs(vk - 6) < 0.5) * 13.000000 + (abs(vk - 7) < 0.5) * 13.000000;\nvW8 = ((abs(vk - 0) < 0.5) * 0.512861 + (abs(vk - 1) < 0.5) * 0.495450 + (abs(vk - 2) < 0.5) * 0.375837 + (abs(vk - 3) < 0.5) * 0.188365 + (abs(vk - 4) < 0.5) * 0.165959 + (abs(vk - 5) < 0.5) * 0.223872 + (abs(vk - 6) < 0.5) * 0.316228 + (abs(vk - 7) < 0.5) * 0.358922) * exp(skinT * ((abs(inst - 0) < 0.5) * 0.916291 + (abs(inst - 1) < 0.5) * 0.476234)) * (vFh * ((abs(inst - 0) < 0.5) * 2.500000 + (abs(inst - 1) < 0.5) * 1.610000) < 0.45 * samplerate) * exp(0.299115 * vJv * (fract(sin(vJs + 625.864) * 43758.5453) * 2 - 1)); vG8 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 13.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.400000 + (abs(vk - 6) < 0.5) * 13.000000 + (abs(vk - 7) < 0.5) * 13.000000;\nvW9 = ((abs(vk - 0) < 0.5) * 0.263027 + (abs(vk - 1) < 0.5) * 0.562341 + (abs(vk - 2) < 0.5) * 0.484172 + (abs(vk - 3) < 0.5) * 0.094406 + (abs(vk - 4) < 0.5) * 0.138038 + (abs(vk - 5) < 0.5) * 0.367282 + (abs(vk - 6) < 0.5) * 0.309030 + (abs(vk - 7) < 0.5) * 0.291743) * exp(skinT * ((abs(inst - 0) < 0.5) * 1.098612 + (abs(inst - 1) < 0.5) * 0.746688)) * (vFh * ((abs(inst - 0) < 0.5) * 3.000000 + (abs(inst - 1) < 0.5) * 2.110000) < 0.45 * samplerate) * exp(0.299115 * vJv * (fract(sin(vJs + 704.097) * 43758.5453) * 2 - 1)); vG9 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 13.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.400000 + (abs(vk - 6) < 0.5) * 13.000000 + (abs(vk - 7) < 0.5) * 13.000000;\nvW10 = ((abs(vk - 0) < 0.5) * 0.568853 + (abs(vk - 1) < 0.5) * 0.323594 + (abs(vk - 2) < 0.5) * 0.699842 + (abs(vk - 3) < 0.5) * 0.350752 + (abs(vk - 4) < 0.5) * 0.175792 + (abs(vk - 5) < 0.5) * 0.346737 + (abs(vk - 6) < 0.5) * 0.239883 + (abs(vk - 7) < 0.5) * 0.272270) * exp(skinT * ((abs(inst - 0) < 0.5) * 1.335001 + (abs(inst - 1) < 0.5) * 1.018847)) * (vFh * ((abs(inst - 0) < 0.5) * 3.800000 + (abs(inst - 1) < 0.5) * 2.770000) < 0.45 * samplerate) * exp(0.299115 * vJv * (fract(sin(vJs + 782.33) * 43758.5453) * 2 - 1)); vG10 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 13.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.400000 + (abs(vk - 6) < 0.5) * 13.000000 + (abs(vk - 7) < 0.5) * 13.000000;\nvW11 = ((abs(vk - 0) < 0.5) * 0.451856 + (abs(vk - 1) < 0.5) * 0.660693 + (abs(vk - 2) < 0.5) * 0.446684 + (abs(vk - 3) < 0.5) * 0.066069 + (abs(vk - 4) < 0.5) * 0.047315 + (abs(vk - 5) < 0.5) * 0.543250 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 0.741310) * exp(skinT * ((abs(inst - 0) < 0.5) * 1.757858 + (abs(inst - 1) < 0.5) * 1.175573)) * (vFh * ((abs(inst - 0) < 0.5) * 5.800000 + (abs(inst - 1) < 0.5) * 3.240000) < 0.45 * samplerate) * exp(0.299115 * vJv * (fract(sin(vJs + 860.5630000000001) * 43758.5453) * 2 - 1)); vG11 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 13.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.400000 + (abs(vk - 6) < 0.5) * 13.000000 + (abs(vk - 7) < 0.5) * 13.000000;\nvW12 = ((abs(vk - 0) < 0.5) * 0.068391 + (abs(vk - 1) < 0.5) * 0.295121 + (abs(vk - 2) < 0.5) * 0.260016 + (abs(vk - 3) < 0.5) * 0.000316 + (abs(vk - 4) < 0.5) * 0.000316 + (abs(vk - 5) < 0.5) * 0.072444 + (abs(vk - 6) < 0.5) * 0.003589 + (abs(vk - 7) < 0.5) * 0.501187) * shellG * exp(0.299115 * vJv * (fract(sin(vJs + 938.796) * 43758.5453) * 2 - 1)); vG12 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 13.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.400000 + (abs(vk - 6) < 0.5) * 13.000000 + (abs(vk - 7) < 0.5) * 13.000000;\nvW13 = ((abs(vk - 0) < 0.5) * 0.860994 + (abs(vk - 1) < 0.5) * 0.537032 + (abs(vk - 2) < 0.5) * 0.676083 + (abs(vk - 3) < 0.5) * 0.085114 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 0.944061 + (abs(vk - 6) < 0.5) * 0.154882 + (abs(vk - 7) < 0.5) * 0.242661) * exp(skinT * 1.757358); vG13 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 1.000000;\nvW14 = ((abs(vk - 0) < 0.5) * 0.027542 + (abs(vk - 1) < 0.5) * 0.076736 + (abs(vk - 2) < 0.5) * 0.197242 + (abs(vk - 3) < 0.5) * 0.000841 + (abs(vk - 4) < 0.5) * 0.467735 + (abs(vk - 5) < 0.5) * 0.015488 + (abs(vk - 6) < 0.5) * 0.066834 + (abs(vk - 7) < 0.5) * 0.000316) * exp(skinT * 2.093830); vG14 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 1.000000;\nvW15 = ((abs(vk - 0) < 0.5) * 0.000316 + (abs(vk - 1) < 0.5) * 0.001202 + (abs(vk - 2) < 0.5) * 0.000316 + (abs(vk - 3) < 0.5) * 0.000316 + (abs(vk - 4) < 0.5) * 0.000316 + (abs(vk - 5) < 0.5) * 0.001679 + (abs(vk - 6) < 0.5) * 0.000519 + (abs(vk - 7) < 0.5) * 0.000316) * exp(skinT * 2.450505); vG15 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 1.000000;\nvW16 = ((abs(vk - 0) < 0.5) * 0.000316 + (abs(vk - 1) < 0.5) * 0.000316 + (abs(vk - 2) < 0.5) * 0.000316 + (abs(vk - 3) < 0.5) * 0.000316 + (abs(vk - 4) < 0.5) * 0.000316 + (abs(vk - 5) < 0.5) * 0.000316 + (abs(vk - 6) < 0.5) * 0.000316 + (abs(vk - 7) < 0.5) * 0.000316) * exp(skinT * 2.822069); vG16 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 1.000000;\nvW17 = ((abs(vk - 0) < 0.5) * 0.000316 + (abs(vk - 1) < 0.5) * 0.000316 + (abs(vk - 2) < 0.5) * 0.000316 + (abs(vk - 3) < 0.5) * 0.000316 + (abs(vk - 4) < 0.5) * 0.000316 + (abs(vk - 5) < 0.5) * 0.582103 + (abs(vk - 6) < 0.5) * 0.537032 + (abs(vk - 7) < 0.5) * 0.009016) * exp(skinT * 3.204277); vG17 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.000000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 1.000000;\nvkp = (abs(vk - 0) < 0.5) * 0.700000 + (abs(vk - 1) < 0.5) * 0.600000 + (abs(vk - 2) < 0.5) * 0.500000 + (abs(vk - 3) < 0.5) * 0.700000 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 0.800000 + (abs(vk - 6) < 0.5) * 0.400000 + (abs(vk - 7) < 0.5) * 0.500000; vNs = (abs(vk - 0) < 0.5) * 1.183000 + (abs(vk - 1) < 0.5) * 1.558000 + (abs(vk - 2) < 0.5) * 0.874000 + (abs(vk - 3) < 0.5) * 2.740000 + (abs(vk - 4) < 0.5) * 0.967000 + (abs(vk - 5) < 0.5) * 1.149000 + (abs(vk - 6) < 0.5) * 0.475000 + (abs(vk - 7) < 0.5) * 0.558000;\nvX0 = vX0 * vkp; vY0 = vY0 * vkp;\nvX1 = vX1 * vkp; vY1 = vY1 * vkp;\nvX2 = vX2 * vkp; vY2 = vY2 * vkp;\nvX3 = vX3 * vkp; vY3 = vY3 * vkp;\nvX4 = vX4 * vkp; vY4 = vY4 * vkp;\nvX5 = vX5 * vkp; vY5 = vY5 * vkp;\nvX6 = vX6 * vkp; vY6 = vY6 * vkp;\nvX7 = vX7 * vkp; vY7 = vY7 * vkp;\nvX8 = vX8 * vkp; vY8 = vY8 * vkp;\nvX9 = vX9 * vkp; vY9 = vY9 * vkp;\nvX10 = vX10 * vkp; vY10 = vY10 * vkp;\nvX11 = vX11 * vkp; vY11 = vY11 * vkp;\nvX12 = vX12 * vkp; vY12 = vY12 * vkp;\nvBe13 = vBe13 * vkp; vBg13 = vW13 * 5.0 / (1 + 4000000 / (vfc * vfc));\nvBe14 = vBe14 * vkp; vBg14 = vW14 * 5.0 / (1 + 7840000 / (vfc * vfc));\nvBe15 = vBe15 * vkp; vBg15 = vW15 * 5.0 / (1 + 16000000 / (vfc * vfc));\nvBe16 = vBe16 * vkp; vBg16 = vW16 * 5.0 / (1 + 33640000 / (vfc * vfc));\nvBe17 = vBe17 * vkp; vBg17 = vW17 * 5.0 / (1 + 72250000 / (vfc * vfc));\n}\nvE1 = vE1 + vK * (vIm - vE1); vE2 = vE2 + vK * (vE1 - vE2);\nif (ctl) {\nvC = vC * vCk;\nvF1 = mtof(note) * exp2(tune / 12);\nvJmsr = samplerate * 0.001; vJrt = 7395.0 / samplerate; vJsp = 0.4143; vJsd = exp(-1 / (5.754 * vJmsr));\nvJgx = 7395.0 * 5.754 * 0.001; vJgr = 1 / sqrt(0.36 * vJgx * vJgx + 0.2067 * vJgx);\nvJfmx = 0.42 * samplerate;\nvJfh = 4561.0; vJfh = vJfh / pow(1 + pow(vJfh / vJfmx, 4), 0.25); vJwh = twopi * vJfh / samplerate; vJalh = sin(vJwh) / (2 * 0.5771); vJiah = 1 / (1 + vJalh); vJchh = cos(vJwh); vJhb = (1 + vJchh) * 0.5 * vJiah; vJh2 = 2 * vJchh * vJiah; vJh3 = (1 - vJalh) * vJiah;\nvJfr = 10730.0; vJfr = vJfr / pow(1 + pow(vJfr / vJfmx, 4), 0.25); vJw = twopi * vJfr / samplerate; vJal = sin(vJw) / (2 * 6.498); vJia = 1 / (1 + vJal); vJ0b = vJal * vJia; vJ0c1 = -2 * cos(vJw) * vJia; vJ0c2 = (1 - vJal) * vJia; vJ0g = 0.8481;\nvJfr = 10620.0; vJfr = vJfr / pow(1 + pow(vJfr / vJfmx, 4), 0.25); vJw = twopi * vJfr / samplerate; vJal = sin(vJw) / (2 * 9.394); vJia = 1 / (1 + vJal); vJ1b = vJal * vJia; vJ1c1 = -2 * cos(vJw) * vJia; vJ1c2 = (1 - vJal) * vJia; vJ1g = 0.8304;\nvJfr = 11970.0; vJfr = vJfr / pow(1 + pow(vJfr / vJfmx, 4), 0.25); vJw = twopi * vJfr / samplerate; vJal = sin(vJw) / (2 * 1.89); vJia = 1 / (1 + vJal); vJ2b = vJal * vJia; vJ2c1 = -2 * cos(vJw) * vJia; vJ2c2 = (1 - vJal) * vJia; vJ2g = 1.16;\nvw = twopi * vF1 * pf * ((abs(inst - 0) < 0.5) * 0.560000 + (abs(inst - 1) < 0.5) * 0.650000) / samplerate; vCc0 = cos(vw); vSn0 = sin(vw); vR0 = exp(-6.907755279 * (1 + (vG0 - 1) * vC) / (((abs(inst - 0) < 0.5) * 0.200000 + (abs(inst - 1) < 0.5) * 0.250000) * decayS * samplerate)) * (vw < 2.827433);\nvw = twopi * vF1 * pf * ((abs(inst - 0) < 0.5) * 1.000000 + (abs(inst - 1) < 0.5) * 0.860000) / samplerate; vCc1 = cos(vw); vSn1 = sin(vw); vR1 = exp(-6.907755279 * (1 + (vG1 - 1) * vC) / (((abs(inst - 0) < 0.5) * 0.280000 + (abs(inst - 1) < 0.5) * 0.250000) * decayS * samplerate)) * (vw < 2.827433);\nvw = twopi * vF1 * pf * ((abs(inst - 0) < 0.5) * 1.160000 + (abs(inst - 1) < 0.5) * 1.000000) / samplerate; vCc2 = cos(vw); vSn2 = sin(vw); vR2 = exp(-6.907755279 * (1 + (vG2 - 1) * vC) / (((abs(inst - 0) < 0.5) * 0.260000 + (abs(inst - 1) < 0.5) * 0.500000) * decayS * samplerate)) * (vw < 2.827433);\nvw = twopi * vF1 * pf * ((abs(inst - 0) < 0.5) * 1.270000 + (abs(inst - 1) < 0.5) * 1.080000) / samplerate; vCc3 = cos(vw); vSn3 = sin(vw); vR3 = exp(-6.907755279 * (1 + (vG3 - 1) * vC) / (((abs(inst - 0) < 0.5) * 0.260000 + (abs(inst - 1) < 0.5) * 0.350000) * decayS * samplerate)) * (vw < 2.827433);\nvw = twopi * vF1 * pf * ((abs(inst - 0) < 0.5) * 1.380000 + (abs(inst - 1) < 0.5) * 1.190000) / samplerate; vCc4 = cos(vw); vSn4 = sin(vw); vR4 = exp(-6.907755279 * (1 + (vG4 - 1) * vC) / (((abs(inst - 0) < 0.5) * 0.250000 + (abs(inst - 1) < 0.5) * 0.300000) * decayS * samplerate)) * (vw < 2.827433);\nvw = twopi * vF1 * pf * ((abs(inst - 0) < 0.5) * 1.590000 + (abs(inst - 1) < 0.5) * 1.250000) / samplerate; vCc5 = cos(vw); vSn5 = sin(vw); vR5 = exp(-6.907755279 * (1 + (vG5 - 1) * vC) / (((abs(inst - 0) < 0.5) * 0.240000 + (abs(inst - 1) < 0.5) * 0.300000) * decayS * samplerate)) * (vw < 2.827433);\nvw = twopi * vF1 * pf * ((abs(inst - 0) < 0.5) * 1.800000 + (abs(inst - 1) < 0.5) * 1.330000) / samplerate; vCc6 = cos(vw); vSn6 = sin(vw); vR6 = exp(-6.907755279 * (1 + (vG6 - 1) * vC) / (((abs(inst - 0) < 0.5) * 0.600000 + (abs(inst - 1) < 0.5) * 0.250000) * decayS * samplerate)) * (vw < 2.827433);\nvw = twopi * vF1 * pf * ((abs(inst - 0) < 0.5) * 2.000000 + (abs(inst - 1) < 0.5) * 1.490000) / samplerate; vCc7 = cos(vw); vSn7 = sin(vw); vR7 = exp(-6.907755279 * (1 + (vG7 - 1) * vC) / (((abs(inst - 0) < 0.5) * 0.240000 + (abs(inst - 1) < 0.5) * 0.250000) * decayS * samplerate)) * (vw < 2.827433);\nvw = twopi * vF1 * pf * ((abs(inst - 0) < 0.5) * 2.500000 + (abs(inst - 1) < 0.5) * 1.610000) / samplerate; vCc8 = cos(vw); vSn8 = sin(vw); vR8 = exp(-6.907755279 * (1 + (vG8 - 1) * vC) / (((abs(inst - 0) < 0.5) * 0.200000 + (abs(inst - 1) < 0.5) * 0.350000) * decayS * samplerate)) * (vw < 2.827433);\nvw = twopi * vF1 * pf * ((abs(inst - 0) < 0.5) * 3.000000 + (abs(inst - 1) < 0.5) * 2.110000) / samplerate; vCc9 = cos(vw); vSn9 = sin(vw); vR9 = exp(-6.907755279 * (1 + (vG9 - 1) * vC) / (((abs(inst - 0) < 0.5) * 0.170000 + (abs(inst - 1) < 0.5) * 0.550000) * decayS * samplerate)) * (vw < 2.827433);\nvw = twopi * vF1 * pf * ((abs(inst - 0) < 0.5) * 3.800000 + (abs(inst - 1) < 0.5) * 2.770000) / samplerate; vCc10 = cos(vw); vSn10 = sin(vw); vR10 = exp(-6.907755279 * (1 + (vG10 - 1) * vC) / (((abs(inst - 0) < 0.5) * 0.170000 + (abs(inst - 1) < 0.5) * 0.300000) * decayS * samplerate)) * (vw < 2.827433);\nvw = twopi * vF1 * pf * ((abs(inst - 0) < 0.5) * 5.800000 + (abs(inst - 1) < 0.5) * 3.240000) / samplerate; vCc11 = cos(vw); vSn11 = sin(vw); vR11 = exp(-6.907755279 * (1 + (vG11 - 1) * vC) / (((abs(inst - 0) < 0.5) * 0.150000 + (abs(inst - 1) < 0.5) * 0.250000) * decayS * samplerate)) * (vw < 2.827433);\nvw = twopi * 125.0 / samplerate; vCc12 = cos(vw); vSn12 = sin(vw); vR12 = exp(-115.129255 * (1 + (vG12 - 1) * vC) / (decayS * samplerate));\nvBg = tan(pi * 2000 / samplerate); vBa113 = 1 / (1 + vBg * (vBg + 0.500000)); vBa213 = vBg * vBa113; vBa313 = vBg * vBa213; vR13 = exp(-6.907755279 * (1 + (vG13 - 1) * vC) / (((abs(inst - 0) < 0.5) * 0.100000 + (abs(inst - 1) < 0.5) * 0.150000) * vNs * decayS * samplerate));\nvBg = tan(pi * 2800 / samplerate); vBa114 = 1 / (1 + vBg * (vBg + 0.500000)); vBa214 = vBg * vBa114; vBa314 = vBg * vBa214; vR14 = exp(-6.907755279 * (1 + (vG14 - 1) * vC) / (((abs(inst - 0) < 0.5) * 0.170000 + (abs(inst - 1) < 0.5) * 0.130000) * vNs * decayS * samplerate));\nvBg = tan(pi * 4000 / samplerate); vBa115 = 1 / (1 + vBg * (vBg + 0.500000)); vBa215 = vBg * vBa115; vBa315 = vBg * vBa215; vR15 = exp(-6.907755279 * (1 + (vG15 - 1) * vC) / (((abs(inst - 0) < 0.5) * 0.100000 + (abs(inst - 1) < 0.5) * 0.120000) * vNs * decayS * samplerate));\nvBg = tan(pi * 5800 / samplerate); vBa116 = 1 / (1 + vBg * (vBg + 0.500000)); vBa216 = vBg * vBa116; vBa316 = vBg * vBa216; vR16 = exp(-6.907755279 * (1 + (vG16 - 1) * vC) / (((abs(inst - 0) < 0.5) * 0.200000 + (abs(inst - 1) < 0.5) * 0.070000) * vNs * decayS * samplerate));\nvBg = tan(pi * 8500 / samplerate); vBa117 = 1 / (1 + vBg * (vBg + 0.500000)); vBa217 = vBg * vBa117; vBa317 = vBg * vBa217; vR17 = exp(-6.907755279 * (1 + (vG17 - 1) * vC) / (((abs(inst - 0) < 0.5) * 0.250000 + (abs(inst - 1) < 0.5) * 0.060000) * vNs * decayS * samplerate));\n}\nvXn = vR0 * (vCc0 * vX0 - vSn0 * vY0) + 0.737369 * vW0 * vE2; vY0 = vR0 * (vSn0 * vX0 + vCc0 * vY0) + 0.675490 * vW0 * vE2; vX0 = vXn;\nvXn = vR1 * (vCc1 * vX1 - vSn1 * vY1) + -0.087426 * vW1 * vE2; vY1 = vR1 * (vSn1 * vX1 + vCc1 * vY1) + -0.996171 * vW1 * vE2; vX1 = vXn;\nvXn = vR2 * (vCc2 * vX2 - vSn2 * vY2) + -0.608439 * vW2 * vE2; vY2 = vR2 * (vSn2 * vX2 + vCc2 * vY2) + 0.793601 * vW2 * vE2; vX2 = vXn;\nvXn = vR3 * (vCc3 * vX3 - vSn3 * vY3) + 0.984713 * vW3 * vE2; vY3 = vR3 * (vSn3 * vX3 + vCc3 * vY3) + -0.174182 * vW3 * vE2; vX3 = vXn;\nvXn = vR4 * (vCc4 * vX4 - vSn4 * vY4) + -0.843755 * vW4 * vE2; vY4 = vR4 * (vSn4 * vX4 + vCc4 * vY4) + -0.536728 * vW4 * vE2; vX4 = vXn;\nvXn = vR5 * (vCc5 * vX5 - vSn5 * vY5) + 0.259604 * vW5 * vE2; vY5 = vR5 * (vSn5 * vX5 + vCc5 * vY5) + 0.965715 * vW5 * vE2; vX5 = vXn;\nvXn = vR6 * (vCc6 * vX6 - vSn6 * vY6) + 0.460907 * vW6 * vE2; vY6 = vR6 * (vSn6 * vX6 + vCc6 * vY6) + -0.887448 * vW6 * vE2; vX6 = vXn;\nvXn = vR7 * (vCc7 * vX7 - vSn7 * vY7) + -0.939321 * vW7 * vE2; vY7 = vR7 * (vSn7 * vX7 + vCc7 * vY7) + 0.343039 * vW7 * vE2; vX7 = vXn;\nvXn = vR8 * (vCc8 * vX8 - vSn8 * vY8) + 0.924346 * vW8 * vE2; vY8 = vR8 * (vSn8 * vX8 + vCc8 * vY8) + 0.381556 * vW8 * vE2; vX8 = vXn;\nvXn = vR9 * (vCc9 * vX9 - vSn9 * vY9) + -0.423846 * vW9 * vE2; vY9 = vR9 * (vSn9 * vX9 + vCc9 * vY9) + -0.905734 * vW9 * vE2; vX9 = vXn;\nvXn = vR10 * (vCc10 * vX10 - vSn10 * vY10) + -0.299284 * vW10 * vE2; vY10 = vR10 * (vSn10 * vX10 + vCc10 * vY10) + 0.954164 * vW10 * vE2; vX10 = vXn;\nvXn = vR11 * (vCc11 * vX11 - vSn11 * vY11) + 0.865211 * vW11 * vE2; vY11 = vR11 * (vSn11 * vX11 + vCc11 * vY11) + -0.501408 * vW11 * vE2; vX11 = vXn;\nvXn = vR12 * (vCc12 * vX12 - vSn12 * vY12) + -0.976676 * vW12 * vE2; vY12 = vR12 * (vSn12 * vX12 + vCc12 * vY12) + -0.214719 * vW12 * vE2; vX12 = vXn;\nvKn = 1 - exp(-1 / (0.0003 * samplerate)); vP1 = vP1 + vKn * (vIt - vP1); vP2 = vP2 + vKn * (vP1 - vP2);\nvBe13 = vBe13 * vR13 + vBg13 * vP2; vQ3 = nz * vBe13 - vBi213; vQb = vBa113 * vBi113 + vBa213 * vQ3; vQl = vBi213 + vBa213 * vBi113 + vBa313 * vQ3; vBi113 = 2 * vQb - vBi113; vBi213 = 2 * vQl - vBi213; vY13 = vQb / 2.0;\nvBe14 = vBe14 * vR14 + vBg14 * vP2; vQ3 = nz * vBe14 - vBi214; vQb = vBa114 * vBi114 + vBa214 * vQ3; vQl = vBi214 + vBa214 * vBi114 + vBa314 * vQ3; vBi114 = 2 * vQb - vBi114; vBi214 = 2 * vQl - vBi214; vY14 = vQb / 2.0;\nvBe15 = vBe15 * vR15 + vBg15 * vP2; vQ3 = nz * vBe15 - vBi215; vQb = vBa115 * vBi115 + vBa215 * vQ3; vQl = vBi215 + vBa215 * vBi115 + vBa315 * vQ3; vBi115 = 2 * vQb - vBi115; vBi215 = 2 * vQl - vBi215; vY15 = vQb / 2.0;\nvBe16 = vBe16 * vR16 + vBg16 * vP2; vQ3 = nz * vBe16 - vBi216; vQb = vBa116 * vBi116 + vBa216 * vQ3; vQl = vBi216 + vBa216 * vBi116 + vBa316 * vQ3; vBi116 = 2 * vQb - vBi116; vBi216 = 2 * vQl - vBi216; vY16 = vQb / 2.0;\nvBe17 = vBe17 * vR17 + vBg17 * vP2; vQ3 = nz * vBe17 - vBi217; vQb = vBa117 * vBi117 + vBa217 * vQ3; vQl = vBi217 + vBa217 * vBi117 + vBa317 * vQ3; vBi117 = 2 * vQb - vBi117; vBi217 = 2 * vQl - vBi217; vY17 = vQb / 2.0;\nvAe = vAe * vTa;                                      // the head's tone swells in (a soft contact) while the tick and the noise bands start at once\nvSm = (1 - vAe) * (vY0 + vY1 + vY2 + vY3 + vY4 + vY5 + vY6 + vY7 + vY8 + vY9 + vY10 + vY11 + vY12) + vY13 + vY14 + vY15 + vY16 + vY17;\nvNx = nz * vNe; vNe = vNe * vNr;\nvNv3 = vNx - vI2; vNb = vNa1 * vI1 + vNa2 * vNv3; vNl = vI2 + vNa2 * vI1 + vNa3 * vNv3; vI1 = 2 * vNb - vI1; vI2 = 2 * vNl - vI2;\nvJa = 0; if (vJdn > 0.5) { vJdn = vJdn - 1; if (vJdn < 0.5) { vJa = vJpa; } }\nvJy1 = vJy1 + vJca * (vJa * vJamp - vJy1); vJy2 = vJy2 + vJca * (vJy1 - vJy2);\nvJen = fixdenorm(vJen * vJdE + vJy2); vJen = vJen * (vJen > 0.000000001);\nvJpe = vJen * (vJen < 1) + (vJen >= 1); vJp = vJrt * (1 - vJsp + vJsp * vJpe); vJcl = abs(noise()) < vJp;\nvJsnd = fixdenorm(vJsnd * vJsd + vJcl * vJen * vJgr * (0.2 + 0.8 * abs(noise()))); vJsnd = vJsnd * (vJsnd > 0.000000001); vJraw = vJsnd * noise();\nvJhh = vJhb * (vJraw - 2 * vJhx1 + vJhx2) + vJh2 * vJhz1 - vJh3 * vJhz2; vJhx2 = vJhx1; vJhx1 = vJraw; vJhz2 = fixdenorm(vJhz1); vJhz1 = fixdenorm(vJhh);\nvJin = vJhb * (vJhh - 2 * vJjx1 + vJjx2) + vJh2 * vJjz1 - vJh3 * vJjz2; vJjx2 = vJjx1; vJjx1 = vJhh; vJjz2 = fixdenorm(vJjz1); vJjz1 = fixdenorm(vJin);\nvJo = 0;\nvJyy = vJ0b * (vJin - vJ0x2) - vJ0c1 * vJ0z1 - vJ0c2 * vJ0z2; vJ0x2 = vJ0x1; vJ0x1 = vJin; vJ0z2 = fixdenorm(vJ0z1); vJ0z1 = fixdenorm(vJyy); vJo = vJo + vJyy * vJ0g;\nvJyy = vJ1b * (vJin - vJ1x2) - vJ1c1 * vJ1z1 - vJ1c2 * vJ1z2; vJ1x2 = vJ1x1; vJ1x1 = vJin; vJ1z2 = fixdenorm(vJ1z1); vJ1z1 = fixdenorm(vJyy); vJo = vJo + vJyy * vJ1g;\nvJyy = vJ2b * (vJin - vJ2x2) - vJ2c1 * vJ2z1 - vJ2c2 * vJ2z2; vJ2x2 = vJ2x1; vJ2x1 = vJin; vJ2z2 = fixdenorm(vJ2z1); vJ2z1 = fixdenorm(vJyy); vJo = vJo + vJyy * vJ2g;\nvmix = (vSm + vNk * vNb + vJo) * masterG;\nvax = abs(vmix); vlim = sign(vmix) * (min(vax, 0.8) + 0.2 * tanh(max(vax - 0.8, 0) * 5));\nout1 = vlim + 0 * in1; out2 = vlim + 0 * in2;\n",
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
						"inst",
						0
					],
					"destination": [
						"pre_inst",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_inst",
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
						"inst",
						0
					],
					"destination": [
						"pre_inst_view",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_inst_view",
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
						"inst",
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
						"jingles",
						0
					],
					"destination": [
						"pre_jingles",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_jingles",
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
						"jingles",
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
			}
		],
		"dependency_cache": [],
		"autosave": 0,
		"parameters": {
			"inst": [
				"Instrument",
				"Instrument",
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
			"jingles": [
				"Jingles",
				"Jingles",
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
						"Instrument",
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
					"name": "Jingles",
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
						"Jingles",
						"Press",
						"Vary",
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