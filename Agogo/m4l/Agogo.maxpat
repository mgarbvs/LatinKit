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
		"description": "Agogo: one agogo bell (High or Low; open or muted) as a modal bell model with doublet partners fitted to recordings, for Drum Rack pads.",
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
					"text": "js agogo_push.js",
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
						980,
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
						2230,
						260,
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
						920,
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
						120.0,
						88.0,
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
					"id": "vary",
					"varname": "vary",
					"parameter_enable": 1,
					"annotation_name": "Vary",
					"annotation": "How much every hit differs from the last: the loudness of each of the bell's tones is nudged at random at every hit (about 1.5 dB at 100 %), as no two real strokes are the same. 0 plays the same hit every time.",
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
						120.0,
						88.0,
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
						830,
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
						64.0,
						88.0,
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
					"id": "touch",
					"varname": "touch",
					"parameter_enable": 1,
					"annotation_name": "Touch",
					"annotation": "Hardness of the stick: harder is brighter, louder and clickier; velocity does the same.",
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
						64.0,
						88.0,
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
					"id": "pre_tone",
					"maxclass": "newobj",
					"text": "prepend tone",
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
					"id": "ol_tone",
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
						88.0,
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
					"id": "tone",
					"varname": "tone",
					"parameter_enable": 1,
					"annotation_name": "Tone",
					"annotation": "Brightness of the bell: tilts the strength of the overtones against the fundamental (+-6 dB per octave at the ends). 50 % is the recording.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Tone",
							"parameter_shortname": "Tone",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								50
							],
							"parameter_unitstyle": 9,
							"parameter_units": "Tone %.0f"
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
						88.0,
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
					"annotation": "How long the bell rings, in percent of the natural time (High about 1.3 s, Low about 0.5 s to fall 60 dB).",
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
					"annotation": "Tuning of the bell in semitones. 0 is the recorded bell (High about 1470 Hz, Low about 1000 Hz); +-12 reaches the other agogos.",
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
					"annotation": "Which stroke a note plays: Open (the stick hits the bell and it rings) or Mute (the other hand holds the bell: a short, dull tick). Changing it between hits works: a Mute hit also stops the ring already on the bell.",
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
								"Mute"
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
					"id": "pre_bell_view",
					"maxclass": "newobj",
					"text": "prepend bell",
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
					"id": "pre_bell",
					"maxclass": "newobj",
					"text": "prepend bell",
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
					"id": "bell",
					"varname": "bell",
					"parameter_enable": 1,
					"annotation_name": "Bell",
					"annotation": "Which bell of the pair: High (the small one, open tone about 1470 Hz) or Low (the large one, about 1000 Hz). Any MIDI note plays it.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Bell",
							"parameter_shortname": "Bell",
							"parameter_type": 2,
							"parameter_enum": [
								"High",
								"Low"
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
					"id": "hdr_Bell",
					"maxclass": "comment",
					"text": "Bell",
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
					"filename": "agogo_view.js",
					"border": 0,
					"parameter_enable": 0,
					"annotation_name": "Agogo",
					"annotation": "The double bell (the selected bell in orange), the stick or the muting hand and the stroke's name: it flashes when a note hits.",
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
					"text": "js agogo_midi.js",
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
									"code": "Param bell(0);\nParam stroke(0);\nParam tune(0);\nParam decay(100);\nParam tone(50);\nParam touch(50);\nParam vary(100);\nParam volume(-9);\nParam trg(0);\nParam vel(1);\nHistory cnt(0);\nHistory pt(0);\nHistory vC(0);\nHistory vCk(0.99);\nHistory vE1(0);\nHistory vE2(0);\nHistory vK(0.5);\nHistory vNe(0);\nHistory vNr(0.99);\nHistory vI1(0);\nHistory vI2(0);\nHistory vNa1(0);\nHistory vNa2(0);\nHistory vNa3(0);\nHistory vNk(1);\nHistory vAm(0);\nHistory vF1(1470);\nHistory vAe(0);\nHistory vTa(0.9);\nHistory vX0(0);\nHistory vY0(0);\nHistory vW0(0);\nHistory vG0(1);\nHistory vCc0(1);\nHistory vSn0(0);\nHistory vR0(0.999);\nHistory vX1(0);\nHistory vY1(0);\nHistory vW1(0);\nHistory vG1(1);\nHistory vCc1(1);\nHistory vSn1(0);\nHistory vR1(0.999);\nHistory vX2(0);\nHistory vY2(0);\nHistory vW2(0);\nHistory vG2(1);\nHistory vCc2(1);\nHistory vSn2(0);\nHistory vR2(0.999);\nHistory vX3(0);\nHistory vY3(0);\nHistory vW3(0);\nHistory vG3(1);\nHistory vCc3(1);\nHistory vSn3(0);\nHistory vR3(0.999);\nHistory vX4(0);\nHistory vY4(0);\nHistory vW4(0);\nHistory vG4(1);\nHistory vCc4(1);\nHistory vSn4(0);\nHistory vR4(0.999);\nHistory vX5(0);\nHistory vY5(0);\nHistory vW5(0);\nHistory vG5(1);\nHistory vCc5(1);\nHistory vSn5(0);\nHistory vR5(0.999);\nHistory vX6(0);\nHistory vY6(0);\nHistory vW6(0);\nHistory vG6(1);\nHistory vCc6(1);\nHistory vSn6(0);\nHistory vR6(0.999);\nHistory vX7(0);\nHistory vY7(0);\nHistory vW7(0);\nHistory vG7(1);\nHistory vCc7(1);\nHistory vSn7(0);\nHistory vR7(0.999);\nHistory vX8(0);\nHistory vY8(0);\nHistory vW8(0);\nHistory vG8(1);\nHistory vCc8(1);\nHistory vSn8(0);\nHistory vR8(0.999);\nHistory vX9(0);\nHistory vY9(0);\nHistory vW9(0);\nHistory vG9(1);\nHistory vCc9(1);\nHistory vSn9(0);\nHistory vR9(0.999);\nHistory vX10(0);\nHistory vY10(0);\nHistory vW10(0);\nHistory vG10(1);\nHistory vCc10(1);\nHistory vSn10(0);\nHistory vR10(0.999);\nHistory vX11(0);\nHistory vY11(0);\nHistory vW11(0);\nHistory vG11(1);\nHistory vCc11(1);\nHistory vSn11(0);\nHistory vR11(0.999);\nHistory vX12(0);\nHistory vY12(0);\nHistory vW12(0);\nHistory vG12(1);\nHistory vCc12(1);\nHistory vSn12(0);\nHistory vR12(0.999);\nHistory vX13(0);\nHistory vY13(0);\nHistory vW13(0);\nHistory vG13(1);\nHistory vCc13(1);\nHistory vSn13(0);\nHistory vR13(0.999);\nHistory vX14(0);\nHistory vY14(0);\nHistory vW14(0);\nHistory vG14(1);\nHistory vCc14(1);\nHistory vSn14(0);\nHistory vR14(0.999);\nHistory vX15(0);\nHistory vY15(0);\nHistory vW15(0);\nHistory vG15(1);\nHistory vCc15(1);\nHistory vSn15(0);\nHistory vR15(0.999);\nHistory vX16(0);\nHistory vY16(0);\nHistory vW16(0);\nHistory vG16(1);\nHistory vCc16(1);\nHistory vSn16(0);\nHistory vR16(0.999);\nHistory vX17(0);\nHistory vY17(0);\nHistory vW17(0);\nHistory vG17(1);\nHistory vCc17(1);\nHistory vSn17(0);\nHistory vR17(0.999);\nHistory vX18(0);\nHistory vY18(0);\nHistory vW18(0);\nHistory vG18(1);\nHistory vCc18(1);\nHistory vSn18(0);\nHistory vR18(0.999);\nHistory vX19(0);\nHistory vY19(0);\nHistory vW19(0);\nHistory vG19(1);\nHistory vCc19(1);\nHistory vSn19(0);\nHistory vR19(0.999);\nHistory vX20(0);\nHistory vY20(0);\nHistory vW20(0);\nHistory vG20(1);\nHistory vCc20(1);\nHistory vSn20(0);\nHistory vR20(0.999);\nHistory vX21(0);\nHistory vY21(0);\nHistory vW21(0);\nHistory vG21(1);\nHistory vCc21(1);\nHistory vSn21(0);\nHistory vR21(0.999);\nHistory vX22(0);\nHistory vY22(0);\nHistory vW22(0);\nHistory vG22(1);\nHistory vCc22(1);\nHistory vSn22(0);\nHistory vR22(0.999);\nHistory vX23(0);\nHistory vY23(0);\nHistory vW23(0);\nHistory vG23(1);\nHistory vCc23(1);\nHistory vSn23(0);\nHistory vR23(0.999);\n\ndecayS = decay * 0.01;\ntoneT = (tone - 50) * 0.02 * 6 / 6.0206;                      // +-6 dB per octave of mode ratio at the ends\ntouchT = (touch - 50) * 0.02;\nmasterG = dbtoa(volume);\ncnt = cnt + 1; ctl = cnt >= 16; cnt = cnt - ctl * 16;\nnz = noise();\nvh = trg != pt; pt = trg;\nvAm = 0;\nif (vh > 0.5) {\nvds = stroke;                                         // History-derived: the stroke and velocity at the hit\nvdv = vel;\nvk = bell * 2 + vds;\nvg = pow(vdv, 1.4);\nvJs = nz * 1000 + trg; vJv = vary * 0.01;\nvAm = vg * ((abs(vk - 0) < 0.5) * 0.540700 + (abs(vk - 1) < 0.5) * 2.036000 + (abs(vk - 2) < 0.5) * 0.370600 + (abs(vk - 3) < 0.5) * 0.609200);\nvAe = 1; vTa = exp(-1 / (((abs(vk - 0) < 0.5) * 0.000770 + (abs(vk - 1) < 0.5) * 0.000770 + (abs(vk - 2) < 0.5) * 0.000570 + (abs(vk - 3) < 0.5) * 0.000570) * samplerate));\nvfc = ((abs(vds - 0) < 0.5) * 9000.000000 + (abs(vds - 1) < 0.5) * 6300.000000) * exp2(touchT * 1.5 + (vdv - 0.6) * 0.8);\nvK = 1 - exp(-twopi * min(vfc, 18000) / samplerate);\nvC = 1;\nvCk = exp(-16 / (((abs(vk - 0) < 0.5) * 0.050000 + (abs(vk - 1) < 0.5) * 1.500000 + (abs(vk - 2) < 0.5) * 0.050000 + (abs(vk - 3) < 0.5) * 1.500000) * samplerate));\nvNe = vAm * ((abs(vk - 0) < 0.5) * 0.000700 + (abs(vk - 1) < 0.5) * 0.000700 + (abs(vk - 2) < 0.5) * 0.000700 + (abs(vk - 3) < 0.5) * 0.000700) * (1 + touchT);\nvNr = exp(-1 / (((abs(vds - 0) < 0.5) * 0.000800 + (abs(vds - 1) < 0.5) * 0.000800) * samplerate));\nvNg = tan(pi * ((abs(vds - 0) < 0.5) * 6580.000000 + (abs(vds - 1) < 0.5) * 6580.000000) / samplerate); vNk = 1 / ((abs(vds - 0) < 0.5) * 0.700000 + (abs(vds - 1) < 0.5) * 0.700000);\nvNa1 = 1 / (1 + vNg * (vNg + vNk)); vNa2 = vNg * vNa1; vNa3 = vNg * vNa2;\nvW0 = ((abs(vk - 0) < 0.5) * 0.018197 + (abs(vk - 1) < 0.5) * 0.018197 + (abs(vk - 2) < 0.5) * 0.653131 + (abs(vk - 3) < 0.5) * 0.653131) * exp(toneT * ((abs(bell - 0) < 0.5) * -0.374010 + (abs(bell - 1) < 0.5) * -0.011091)) * exp(0.299115 * vJv * (fract(sin(vJs + 0.0) * 43758.5453) * 2 - 1)); vG0 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 14.020000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 13.980000;\nvW1 = ((abs(vk - 0) < 0.5) * 0.008035 + (abs(vk - 1) < 0.5) * 0.007079 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.000000) * exp(toneT * ((abs(bell - 0) < 0.5) * -0.019591 + (abs(bell - 1) < 0.5) * 0.000000)) * exp(0.299115 * vJv * (fract(sin(vJs + 78.233) * 43758.5453) * 2 - 1)); vG1 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 14.880000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 14.000000;\nvW2 = ((abs(vk - 0) < 0.5) * 0.190546 + (abs(vk - 1) < 0.5) * 0.167880 + (abs(vk - 2) < 0.5) * 0.008913 + (abs(vk - 3) < 0.5) * 0.008913) * exp(toneT * ((abs(bell - 0) < 0.5) * 0.000000 + (abs(bell - 1) < 0.5) * 0.014593)) * exp(0.299115 * vJv * (fract(sin(vJs + 156.466) * 43758.5453) * 2 - 1)); vG2 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 14.940000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 14.030000;\nvW3 = ((abs(vk - 0) < 0.5) * 0.052481 + (abs(vk - 1) < 0.5) * 0.046238 + (abs(vk - 2) < 0.5) * 0.248313 + (abs(vk - 3) < 0.5) * 0.197242) * exp(toneT * ((abs(bell - 0) < 0.5) * 0.006896 + (abs(bell - 1) < 0.5) * 0.690945)) * exp(0.299115 * vJv * (fract(sin(vJs + 234.699) * 43758.5453) * 2 - 1)); vG3 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 14.960000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 16.000000;\nvW4 = ((abs(vk - 0) < 0.5) * 0.031989 + (abs(vk - 1) < 0.5) * 0.027861 + (abs(vk - 2) < 0.5) * 0.076736 + (abs(vk - 3) < 0.5) * 0.060954) * exp(toneT * ((abs(bell - 0) < 0.5) * 0.017624 + (abs(bell - 1) < 0.5) * 0.702008)) * exp(0.299115 * vJv * (fract(sin(vJs + 312.932) * 43758.5453) * 2 - 1)); vG4 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 14.990000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 16.040000;\nvW5 = ((abs(vk - 0) < 0.5) * 0.013032 + (abs(vk - 1) < 0.5) * 0.009333 + (abs(vk - 2) < 0.5) * 0.070795 + (abs(vk - 3) < 0.5) * 0.053088) * exp(toneT * ((abs(bell - 0) < 0.5) * 0.636794 + (abs(bell - 1) < 0.5) * 0.847669)) * exp(0.299115 * vJv * (fract(sin(vJs + 391.165) * 43758.5453) * 2 - 1)); vG5 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 17.550000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 16.680000;\nvW6 = ((abs(vk - 0) < 0.5) * 0.110917 + (abs(vk - 1) < 0.5) * 0.078524 + (abs(vk - 2) < 0.5) * 0.016982 + (abs(vk - 3) < 0.5) * 0.012735) * exp(toneT * ((abs(bell - 0) < 0.5) * 0.643158 + (abs(bell - 1) < 0.5) * 0.865414)) * exp(0.299115 * vJv * (fract(sin(vJs + 469.398) * 43758.5453) * 2 - 1)); vG6 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 17.590000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 16.760000;\nvW7 = ((abs(vk - 0) < 0.5) * 0.008318 + (abs(vk - 1) < 0.5) * 0.005821 + (abs(vk - 2) < 0.5) * 0.070795 + (abs(vk - 3) < 0.5) * 0.050119) * exp(toneT * ((abs(bell - 0) < 0.5) * 0.693107 + (abs(bell - 1) < 0.5) * 1.024747)) * exp(0.299115 * vJv * (fract(sin(vJs + 547.6310000000001) * 43758.5453) * 2 - 1)); vG7 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 17.880000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 17.590000;\nvW8 = ((abs(vk - 0) < 0.5) * 0.018408 + (abs(vk - 1) < 0.5) * 0.012303 + (abs(vk - 2) < 0.5) * 0.054325 + (abs(vk - 3) < 0.5) * 0.038459) * exp(toneT * ((abs(bell - 0) < 0.5) * 0.833392 + (abs(bell - 1) < 0.5) * 1.035697)) * exp(0.299115 * vJv * (fract(sin(vJs + 625.864) * 43758.5453) * 2 - 1)); vG8 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 18.760000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 17.650000;\nvW9 = ((abs(vk - 0) < 0.5) * 0.024547 + (abs(vk - 1) < 0.5) * 0.016406 + (abs(vk - 2) < 0.5) * 0.025410 + (abs(vk - 3) < 0.5) * 0.016032) * exp(toneT * ((abs(bell - 0) < 0.5) * 0.841740 + (abs(bell - 1) < 0.5) * 1.384808)) * exp(0.299115 * vJv * (fract(sin(vJs + 704.097) * 43758.5453) * 2 - 1)); vG9 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 18.820000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 20.010000;\nvW10 = ((abs(vk - 0) < 0.5) * 0.007943 + (abs(vk - 1) < 0.5) * 0.005248 + (abs(vk - 2) < 0.5) * 0.071614 + (abs(vk - 3) < 0.5) * 0.045186) * exp(toneT * ((abs(bell - 0) < 0.5) * 0.853389 + (abs(bell - 1) < 0.5) * 1.398010)) * exp(0.299115 * vJv * (fract(sin(vJs + 782.33) * 43758.5453) * 2 - 1)); vG10 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 18.900000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 20.110000;\nvW11 = ((abs(vk - 0) < 0.5) * 0.098855 + (abs(vk - 1) < 0.5) * 0.062373 + (abs(vk - 2) < 0.5) * 0.022387 + (abs(vk - 3) < 0.5) * 0.013964) * exp(toneT * ((abs(bell - 0) < 0.5) * 1.002630 + (abs(bell - 1) < 0.5) * 1.423096)) * exp(0.299115 * vJv * (fract(sin(vJs + 860.5630000000001) * 43758.5453) * 2 - 1)); vG11 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 20.010000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 20.320000;\nvW12 = ((abs(vk - 0) < 0.5) * 0.072444 + (abs(vk - 1) < 0.5) * 0.041687 + (abs(vk - 2) < 0.5) * 0.017179 + (abs(vk - 3) < 0.5) * 0.009550) * exp(toneT * ((abs(bell - 0) < 0.5) * 1.295677 + (abs(bell - 1) < 0.5) * 1.750112)) * exp(0.299115 * vJv * (fract(sin(vJs + 938.796) * 43758.5453) * 2 - 1)); vG12 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 22.740000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 23.540000;\nvW13 = ((abs(vk - 0) < 0.5) * 0.039355 + (abs(vk - 1) < 0.5) * 0.022131 + (abs(vk - 2) < 0.5) * 0.285102 + (abs(vk - 3) < 0.5) * 0.151356) * exp(toneT * ((abs(bell - 0) < 0.5) * 1.352960 + (abs(bell - 1) < 0.5) * 1.898491)) * exp(0.299115 * vJv * (fract(sin(vJs + 1017.029) * 43758.5453) * 2 - 1)); vG13 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 23.370000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 24.000000;\nvW14 = ((abs(vk - 0) < 0.5) * 0.109648 + (abs(vk - 1) < 0.5) * 0.060256 + (abs(vk - 2) < 0.5) * 0.139637 + (abs(vk - 3) < 0.5) * 0.070795) * exp(toneT * ((abs(bell - 0) < 0.5) * 1.413783 + (abs(bell - 1) < 0.5) * 2.037356)) * exp(0.299115 * vJv * (fract(sin(vJs + 1095.2620000000002) * 43758.5453) * 2 - 1)); vG14 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 24.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 24.000000;\nvW15 = ((abs(vk - 0) < 0.5) * 0.128825 + (abs(vk - 1) < 0.5) * 0.067608 + (abs(vk - 2) < 0.5) * 0.285102 + (abs(vk - 3) < 0.5) * 0.142889) * exp(toneT * ((abs(bell - 0) < 0.5) * 1.561256 + (abs(bell - 1) < 0.5) * 2.080713)) * exp(0.299115 * vJv * (fract(sin(vJs + 1173.4950000000001) * 43758.5453) * 2 - 1)); vG15 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 24.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 24.000000;\nvW16 = ((abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 0.518800 + (abs(vk - 2) < 0.5) * 0.156675 + (abs(vk - 3) < 0.5) * 0.077625) * exp(toneT * ((abs(bell - 0) < 0.5) * 1.588147 + (abs(bell - 1) < 0.5) * 2.116329)) * exp(0.299115 * vJv * (fract(sin(vJs + 1251.728) * 43758.5453) * 2 - 1)); vG16 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 24.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 24.000000;\nvW17 = ((abs(vk - 0) < 0.5) * 0.069984 + (abs(vk - 1) < 0.5) * 0.034674 + (abs(vk - 2) < 0.5) * 0.165959 + (abs(vk - 3) < 0.5) * 0.081283) * exp(toneT * ((abs(bell - 0) < 0.5) * 1.721734 + (abs(bell - 1) < 0.5) * 2.140212)) * exp(0.299115 * vJv * (fract(sin(vJs + 1329.961) * 43758.5453) * 2 - 1)); vG17 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 24.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 24.000000;\nvW18 = ((abs(vk - 0) < 0.5) * 0.402717 + (abs(vk - 1) < 0.5) * 0.197242 + (abs(vk - 2) < 0.5) * 0.089125 + (abs(vk - 3) < 0.5) * 0.043652) * exp(toneT * ((abs(bell - 0) < 0.5) * 1.751194 + (abs(bell - 1) < 0.5) * 2.150821)) * exp(0.299115 * vJv * (fract(sin(vJs + 1408.194) * 43758.5453) * 2 - 1)); vG18 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 24.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 24.000000;\nvW19 = ((abs(vk - 0) < 0.5) * 0.090157 + (abs(vk - 1) < 0.5) * 0.044157 + (abs(vk - 2) < 0.5) * 0.278612 + (abs(vk - 3) < 0.5) * 0.134896) * exp(toneT * ((abs(bell - 0) < 0.5) * 1.771994 + (abs(bell - 1) < 0.5) * 2.179789)) * exp(0.299115 * vJv * (fract(sin(vJs + 1486.4270000000001) * 43758.5453) * 2 - 1)); vG19 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 24.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 24.000000;\nvW20 = ((abs(vk - 0) < 0.5) * 0.091201 + (abs(vk - 1) < 0.5) * 0.043652 + (abs(vk - 2) < 0.5) * 0.136458 + (abs(vk - 3) < 0.5) * 0.065313) * exp(toneT * ((abs(bell - 0) < 0.5) * 1.850215 + (abs(bell - 1) < 0.5) * 2.206898)) * exp(0.299115 * vJv * (fract(sin(vJs + 1564.66) * 43758.5453) * 2 - 1)); vG20 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 24.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 24.000000;\nvW21 = ((abs(vk - 0) < 0.5) * 0.192752 + (abs(vk - 1) < 0.5) * 0.089125 + (abs(vk - 2) < 0.5) * 0.229087 + (abs(vk - 3) < 0.5) * 0.108393) * exp(toneT * ((abs(bell - 0) < 0.5) * 1.935793 + (abs(bell - 1) < 0.5) * 2.259854)) * exp(0.299115 * vJv * (fract(sin(vJs + 1642.893) * 43758.5453) * 2 - 1)); vG21 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 24.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 24.000000;\nvW22 = ((abs(vk - 0) < 0.5) * 0.138038 + (abs(vk - 1) < 0.5) * 0.062373 + (abs(vk - 2) < 0.5) * 0.094406 + (abs(vk - 3) < 0.5) * 0.044157) * exp(toneT * ((abs(bell - 0) < 0.5) * 2.003130 + (abs(bell - 1) < 0.5) * 2.297688)) * exp(0.299115 * vJv * (fract(sin(vJs + 1721.1260000000002) * 43758.5453) * 2 - 1)); vG22 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 24.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 24.000000;\nvW23 = ((abs(vk - 0) < 0.5) * 0.426580 + (abs(vk - 1) < 0.5) * 0.192752 + (abs(vk - 2) < 0.5) * 0.134896 + (abs(vk - 3) < 0.5) * 0.061660) * exp(toneT * ((abs(bell - 0) < 0.5) * 2.014143 + (abs(bell - 1) < 0.5) * 2.369547)) * exp(0.299115 * vJv * (fract(sin(vJs + 1799.3590000000002) * 43758.5453) * 2 - 1)); vG23 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 24.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 24.000000;\nvkp = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 0.300000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 0.300000;\nvX0 = vX0 * vkp; vY0 = vY0 * vkp;\nvX1 = vX1 * vkp; vY1 = vY1 * vkp;\nvX2 = vX2 * vkp; vY2 = vY2 * vkp;\nvX3 = vX3 * vkp; vY3 = vY3 * vkp;\nvX4 = vX4 * vkp; vY4 = vY4 * vkp;\nvX5 = vX5 * vkp; vY5 = vY5 * vkp;\nvX6 = vX6 * vkp; vY6 = vY6 * vkp;\nvX7 = vX7 * vkp; vY7 = vY7 * vkp;\nvX8 = vX8 * vkp; vY8 = vY8 * vkp;\nvX9 = vX9 * vkp; vY9 = vY9 * vkp;\nvX10 = vX10 * vkp; vY10 = vY10 * vkp;\nvX11 = vX11 * vkp; vY11 = vY11 * vkp;\nvX12 = vX12 * vkp; vY12 = vY12 * vkp;\nvX13 = vX13 * vkp; vY13 = vY13 * vkp;\nvX14 = vX14 * vkp; vY14 = vY14 * vkp;\nvX15 = vX15 * vkp; vY15 = vY15 * vkp;\nvX16 = vX16 * vkp; vY16 = vY16 * vkp;\nvX17 = vX17 * vkp; vY17 = vY17 * vkp;\nvX18 = vX18 * vkp; vY18 = vY18 * vkp;\nvX19 = vX19 * vkp; vY19 = vY19 * vkp;\nvX20 = vX20 * vkp; vY20 = vY20 * vkp;\nvX21 = vX21 * vkp; vY21 = vY21 * vkp;\nvX22 = vX22 * vkp; vY22 = vY22 * vkp;\nvX23 = vX23 * vkp; vY23 = vY23 * vkp;\n}\nvE1 = vE1 + vK * (vAm - vE1); vE2 = vE2 + vK * (vE1 - vE2);\nif (ctl) {\nvC = vC * vCk;\nvF1 = ((abs(bell - 0) < 0.5) * 1469.220000 + (abs(bell - 1) < 0.5) * 1002.320000) * exp2(tune / 12);\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 0.687970 + (abs(bell - 1) < 0.5) * 0.988970) / samplerate; vCc0 = cos(vw); vSn0 = sin(vw); vR0 = exp(-6.907755279 * (1 + (vG0 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.150000 + (abs(bell - 1) < 0.5) * 0.163000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 0.980600 + (abs(bell - 1) < 0.5) * 1.000000) / samplerate; vCc1 = cos(vw); vSn1 = sin(vw); vR1 = exp(-6.907755279 * (1 + (vG1 - 1) * vC) / (((abs(bell - 0) < 0.5) * 1.367000 + (abs(bell - 1) < 0.5) * 0.475000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 1.000000 + (abs(bell - 1) < 0.5) * 1.014700) / samplerate; vCc2 = cos(vw); vSn2 = sin(vw); vR2 = exp(-6.907755279 * (1 + (vG2 - 1) * vC) / (((abs(bell - 0) < 0.5) * 1.372000 + (abs(bell - 1) < 0.5) * 2.000000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 1.006920 + (abs(bell - 1) < 0.5) * 1.995600) / samplerate; vCc3 = cos(vw); vSn3 = sin(vw); vR3 = exp(-6.907755279 * (1 + (vG3 - 1) * vC) / (((abs(bell - 0) < 0.5) * 1.603000 + (abs(bell - 1) < 0.5) * 0.139000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 1.017780 + (abs(bell - 1) < 0.5) * 2.017800) / samplerate; vCc4 = cos(vw); vSn4 = sin(vw); vR4 = exp(-6.907755279 * (1 + (vG4 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.426000 + (abs(bell - 1) < 0.5) * 0.106000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 1.890410 + (abs(bell - 1) < 0.5) * 2.334200) / samplerate; vCc5 = cos(vw); vSn5 = sin(vw); vR5 = exp(-6.907755279 * (1 + (vG5 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.256000 + (abs(bell - 1) < 0.5) * 1.072000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 1.902480 + (abs(bell - 1) < 0.5) * 2.375990) / samplerate; vCc6 = cos(vw); vSn6 = sin(vw); vR6 = exp(-6.907755279 * (1 + (vG6 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.089000 + (abs(bell - 1) < 0.5) * 1.174000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 1.999920 + (abs(bell - 1) < 0.5) * 2.786390) / samplerate; vCc7 = cos(vw); vSn7 = sin(vw); vR7 = exp(-6.907755279 * (1 + (vG7 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.585000 + (abs(bell - 1) < 0.5) * 0.136000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 2.301110 + (abs(bell - 1) < 0.5) * 2.817070) / samplerate; vCc8 = cos(vw); vSn8 = sin(vw); vR8 = exp(-6.907755279 * (1 + (vG8 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.159000 + (abs(bell - 1) < 0.5) * 0.125000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 2.320400 + (abs(bell - 1) < 0.5) * 3.994060) / samplerate; vCc9 = cos(vw); vSn9 = sin(vw); vR9 = exp(-6.907755279 * (1 + (vG9 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.497000 + (abs(bell - 1) < 0.5) * 0.219000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 2.347590 + (abs(bell - 1) < 0.5) * 4.047140) / samplerate; vCc10 = cos(vw); vSn10 = sin(vw); vR10 = exp(-6.907755279 * (1 + (vG10 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.741000 + (abs(bell - 1) < 0.5) * 0.125000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 2.725440 + (abs(bell - 1) < 0.5) * 4.149950) / samplerate; vCc11 = cos(vw); vSn11 = sin(vw); vR11 = exp(-6.907755279 * (1 + (vG11 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.093000 + (abs(bell - 1) < 0.5) * 0.318000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 3.653470 + (abs(bell - 1) < 0.5) * 5.755250) / samplerate; vCc12 = cos(vw); vSn12 = sin(vw); vR12 = exp(-6.907755279 * (1 + (vG12 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.093000 + (abs(bell - 1) < 0.5) * 0.308000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 3.868860 + (abs(bell - 1) < 0.5) * 6.675810) / samplerate; vCc13 = cos(vw); vSn13 = sin(vw); vR13 = exp(-6.907755279 * (1 + (vG13 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.216000 + (abs(bell - 1) < 0.5) * 0.255000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 4.111480 + (abs(bell - 1) < 0.5) * 7.670300) / samplerate; vCc14 = cos(vw); vSn14 = sin(vw); vR14 = exp(-6.907755279 * (1 + (vG14 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.336000 + (abs(bell - 1) < 0.5) * 0.105000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 4.764800 + (abs(bell - 1) < 0.5) * 8.010180) / samplerate; vCc15 = cos(vw); vSn15 = sin(vw); vR15 = exp(-6.907755279 * (1 + (vG15 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.149000 + (abs(bell - 1) < 0.5) * 0.158000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 4.894670 + (abs(bell - 1) < 0.5) * 8.300610) / samplerate; vCc16 = cos(vw); vSn16 = sin(vw); vR16 = exp(-6.907755279 * (1 + (vG16 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.091000 + (abs(bell - 1) < 0.5) * 0.128000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 5.594220 + (abs(bell - 1) < 0.5) * 8.501240) / samplerate; vCc17 = cos(vw); vSn17 = sin(vw); vR17 = exp(-6.907755279 * (1 + (vG17 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.181000 + (abs(bell - 1) < 0.5) * 0.116000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 5.761480 + (abs(bell - 1) < 0.5) * 8.591910) / samplerate; vCc18 = cos(vw); vSn18 = sin(vw); vR18 = exp(-6.907755279 * (1 + (vG18 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.041000 + (abs(bell - 1) < 0.5) * 0.246000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 5.882570 + (abs(bell - 1) < 0.5) * 8.844440) / samplerate; vCc19 = cos(vw); vSn19 = sin(vw); vR19 = exp(-6.907755279 * (1 + (vG19 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.162000 + (abs(bell - 1) < 0.5) * 0.258000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 6.361190 + (abs(bell - 1) < 0.5) * 9.087480) / samplerate; vCc20 = cos(vw); vSn20 = sin(vw); vR20 = exp(-6.907755279 * (1 + (vG20 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.152000 + (abs(bell - 1) < 0.5) * 0.416000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 6.929540 + (abs(bell - 1) < 0.5) * 9.581690) / samplerate; vCc21 = cos(vw); vSn21 = sin(vw); vR21 = exp(-6.907755279 * (1 + (vG21 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.153000 + (abs(bell - 1) < 0.5) * 0.296000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 7.412220 + (abs(bell - 1) < 0.5) * 9.951150) / samplerate; vCc22 = cos(vw); vSn22 = sin(vw); vR22 = exp(-6.907755279 * (1 + (vG22 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.104000 + (abs(bell - 1) < 0.5) * 0.170000) * decayS * samplerate));\nvw = twopi * vF1 * ((abs(bell - 0) < 0.5) * 7.494300 + (abs(bell - 1) < 0.5) * 10.692550) / samplerate; vCc23 = cos(vw); vSn23 = sin(vw); vR23 = exp(-6.907755279 * (1 + (vG23 - 1) * vC) / (((abs(bell - 0) < 0.5) * 0.043000 + (abs(bell - 1) < 0.5) * 0.190000) * decayS * samplerate));\n}\nvXn = vR0 * (vCc0 * vX0 - vSn0 * vY0) + 0.737369 * vW0 * vE2; vY0 = vR0 * (vSn0 * vX0 + vCc0 * vY0) + 0.675490 * vW0 * vE2; vX0 = vXn;\nvXn = vR1 * (vCc1 * vX1 - vSn1 * vY1) + -0.087426 * vW1 * vE2; vY1 = vR1 * (vSn1 * vX1 + vCc1 * vY1) + -0.996171 * vW1 * vE2; vX1 = vXn;\nvXn = vR2 * (vCc2 * vX2 - vSn2 * vY2) + -0.608439 * vW2 * vE2; vY2 = vR2 * (vSn2 * vX2 + vCc2 * vY2) + 0.793601 * vW2 * vE2; vX2 = vXn;\nvXn = vR3 * (vCc3 * vX3 - vSn3 * vY3) + 0.984713 * vW3 * vE2; vY3 = vR3 * (vSn3 * vX3 + vCc3 * vY3) + -0.174182 * vW3 * vE2; vX3 = vXn;\nvXn = vR4 * (vCc4 * vX4 - vSn4 * vY4) + -0.843755 * vW4 * vE2; vY4 = vR4 * (vSn4 * vX4 + vCc4 * vY4) + -0.536728 * vW4 * vE2; vX4 = vXn;\nvXn = vR5 * (vCc5 * vX5 - vSn5 * vY5) + 0.259604 * vW5 * vE2; vY5 = vR5 * (vSn5 * vX5 + vCc5 * vY5) + 0.965715 * vW5 * vE2; vX5 = vXn;\nvXn = vR6 * (vCc6 * vX6 - vSn6 * vY6) + 0.460907 * vW6 * vE2; vY6 = vR6 * (vSn6 * vX6 + vCc6 * vY6) + -0.887448 * vW6 * vE2; vX6 = vXn;\nvXn = vR7 * (vCc7 * vX7 - vSn7 * vY7) + -0.939321 * vW7 * vE2; vY7 = vR7 * (vSn7 * vX7 + vCc7 * vY7) + 0.343039 * vW7 * vE2; vX7 = vXn;\nvXn = vR8 * (vCc8 * vX8 - vSn8 * vY8) + 0.924346 * vW8 * vE2; vY8 = vR8 * (vSn8 * vX8 + vCc8 * vY8) + 0.381556 * vW8 * vE2; vX8 = vXn;\nvXn = vR9 * (vCc9 * vX9 - vSn9 * vY9) + -0.423846 * vW9 * vE2; vY9 = vR9 * (vSn9 * vX9 + vCc9 * vY9) + -0.905734 * vW9 * vE2; vX9 = vXn;\nvXn = vR10 * (vCc10 * vX10 - vSn10 * vY10) + -0.299284 * vW10 * vE2; vY10 = vR10 * (vSn10 * vX10 + vCc10 * vY10) + 0.954164 * vW10 * vE2; vX10 = vXn;\nvXn = vR11 * (vCc11 * vX11 - vSn11 * vY11) + 0.865211 * vW11 * vE2; vY11 = vR11 * (vSn11 * vX11 + vCc11 * vY11) + -0.501408 * vW11 * vE2; vX11 = vXn;\nvXn = vR12 * (vCc12 * vX12 - vSn12 * vY12) + -0.976676 * vW12 * vE2; vY12 = vR12 * (vSn12 * vX12 + vCc12 * vY12) + -0.214719 * vW12 * vE2; vX12 = vXn;\nvXn = vR13 * (vCc13 * vX13 - vSn13 * vY13) + 0.575129 * vW13 * vE2; vY13 = vR13 * (vSn13 * vX13 + vCc13 * vY13) + 0.818062 * vW13 * vE2; vX13 = vXn;\nvXn = vR14 * (vCc14 * vX14 - vSn14 * vY14) + 0.128511 * vW14 * vE2; vY14 = vR14 * (vSn14 * vX14 + vCc14 * vY14) + -0.991708 * vW14 * vE2; vX14 = vXn;\nvXn = vR15 * (vCc15 * vX15 - vSn15 * vY15) + -0.764649 * vW15 * vE2; vY15 = vR15 * (vSn15 * vX15 + vCc15 * vY15) + 0.644447 * vW15 * vE2; vX15 = vXn;\nvXn = vR16 * (vCc16 * vX16 - vSn16 * vY16) + 0.999146 * vW16 * vE2; vY16 = vR16 * (vSn16 * vX16 + vCc16 * vY16) + 0.041318 * vW16 * vE2; vX16 = vXn;\nvXn = vR17 * (vCc17 * vX17 - vSn17 * vY17) + -0.708829 * vW17 * vE2; vY17 = vR17 * (vSn17 * vX17 + vCc17 * vY17) + -0.705380 * vW17 * vE2; vX17 = vXn;\nvXn = vR18 * (vCc18 * vX18 - vSn18 * vY18) + 0.046191 * vW18 * vE2; vY18 = vR18 * (vSn18 * vX18 + vCc18 * vY18) + 0.998933 * vW18 * vE2; vX18 = vXn;\nvXn = vR19 * (vCc19 * vX19 - vSn19 * vY19) + 0.640709 * vW19 * vE2; vY19 = vR19 * (vSn19 * vX19 + vCc19 * vY19) + -0.767784 * vW19 * vE2; vX19 = vXn;\nvXn = vR20 * (vCc20 * vX20 - vSn20 * vY20) + -0.991069 * vW20 * vE2; vY20 = vR20 * (vSn20 * vX20 + vCc20 * vY20) + 0.133347 * vW20 * vE2; vX20 = vXn;\nvXn = vR21 * (vCc21 * vX21 - vSn21 * vY21) + 0.820858 * vW21 * vE2; vY21 = vR21 * (vSn21 * vX21 + vCc21 * vY21) + 0.571132 * vW21 * vE2; vX21 = vXn;\nvXn = vR22 * (vCc22 * vX22 - vSn22 * vY22) + -0.219481 * vW22 * vE2; vY22 = vR22 * (vSn22 * vX22 + vCc22 * vY22) + -0.975617 * vW22 * vE2; vX22 = vXn;\nvXn = vR23 * (vCc23 * vX23 - vSn23 * vY23) + -0.497181 * vW23 * vE2; vY23 = vR23 * (vSn23 * vX23 + vCc23 * vY23) + 0.867647 * vW23 * vE2; vX23 = vXn;\nvAe = vAe * vTa;                                      // the modes' tone swells in over `ta` (a soft contact) while the tick starts at once\nvSm = (1 - vAe) * (vY0 + vY1 + vY2 + vY3 + vY4 + vY5 + vY6 + vY7 + vY8 + vY9 + vY10 + vY11 + vY12 + vY13 + vY14 + vY15 + vY16 + vY17 + vY18 + vY19 + vY20 + vY21 + vY22 + vY23);\nvNx = nz * vNe; vNe = vNe * vNr;\nvNv3 = vNx - vI2; vNb = vNa1 * vI1 + vNa2 * vNv3; vNl = vI2 + vNa2 * vI1 + vNa3 * vNv3; vI1 = 2 * vNb - vI1; vI2 = 2 * vNl - vI2;\nvmix = (vSm + vNk * vNb) * masterG;\nvax = abs(vmix); vlim = sign(vmix) * (min(vax, 0.8) + 0.2 * tanh(max(vax - 0.8, 0) * 5));\nout1 = vlim + 0 * in1; out2 = vlim + 0 * in2;\n",
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
						"bell",
						0
					],
					"destination": [
						"pre_bell",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_bell",
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
						"bell",
						0
					],
					"destination": [
						"pre_bell_view",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_bell_view",
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
						"bell",
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
			"bell": [
				"Bell",
				"Bell",
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
			"tone": [
				"Tone",
				"Tone",
				0
			],
			"touch": [
				"Touch",
				"Touch",
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
					"name": "Bell",
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
						"Bell",
						"Stroke",
						"Tune",
						"Decay",
						"Tone",
						"Touch",
						"Vary",
						"Volume"
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