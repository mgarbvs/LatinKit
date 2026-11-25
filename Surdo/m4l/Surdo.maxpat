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
		"description": "Surdo: one samba bass drum (open, mute, rim or finger) as a modal head model fitted to recordings, for Drum Rack pads.",
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
						20,
						950,
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
						2140,
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
						890,
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
						8.0,
						96.0,
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
						8.0,
						96.0,
						52.0,
						13.0
					],
					"patching_rect": [
						1870,
						260,
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
						800,
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
						120.0,
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
					"id": "press",
					"varname": "press",
					"parameter_enable": 1,
					"annotation_name": "Press",
					"annotation": "The mod wheel presses the head (a hand leaning on it): this many semitones up at full wheel.",
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
						120.0,
						81.0,
						52.0,
						13.0
					],
					"patching_rect": [
						1600,
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
						710,
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
					"id": "touch",
					"varname": "touch",
					"parameter_enable": 1,
					"annotation_name": "Touch",
					"annotation": "Hardness of the contact: harder is brighter and ticks more; velocity does the same.",
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
						81.0,
						52.0,
						13.0
					],
					"patching_rect": [
						2050,
						180,
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
						620,
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
						1870,
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
						1780,
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
						530,
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
					"annotation": "How long the head rings, in percent of the natural time (the Open stroke's 86 Hz tone falls 40 dB in about 0.7 s).",
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
						1600,
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
						470,
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
					"annotation": "Tuning of the head in semitones. 0 is the recorded drum's open tone, 86 Hz. Down a fourth or up a fourth might stand for the larger and smaller surdo sizes: a guess, the sizes are not in the recordings.",
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
						2140,
						100,
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
						410,
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
						380,
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
					"annotation": "Which stroke a note plays: Open (mallet in the middle of the head, the long 86 Hz boom), Mute (the other hand on the head: a short thud), Rim (stick on the rim and head together: a crack over a lower tone) or Finger (a finger tap: a soft click and a low thump). Changing it between hits works: the new stroke damps the ring already on the head.",
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
								"Mute",
								"Rim",
								"Finger"
							],
							"parameter_mmax": 3,
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
						1870,
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
					"text": "js surdo_push.js",
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
					"filename": "surdo_view.js",
					"border": 0,
					"parameter_enable": 0,
					"annotation_name": "Surdo",
					"annotation": "The surdo in orange line art, the mallet or hand where the current stroke is played and its name: it flashes when a note hits.",
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
					"text": "js surdo_midi.js",
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
									"code": "Param stroke(0);\nParam tune(0);\nParam decay(100);\nParam skin(50);\nParam touch(50);\nParam press(5);\nParam vary(100);\nParam volume(-9);\nParam trg(0);\nParam vel(1);\nParam mw(0);\nHistory cnt(0);\nHistory pf(1);\nHistory pt(0);\nHistory vC(0);\nHistory vCk(0.99);\nHistory vE1(0);\nHistory vE2(0);\nHistory vK(0.5);\nHistory vNe(0);\nHistory vNr(0.99);\nHistory vI1(0);\nHistory vI2(0);\nHistory vNa1(0);\nHistory vNa2(0);\nHistory vNa3(0);\nHistory vNk(1);\nHistory vAm(0);\nHistory vF1(86);\nHistory vIt(0);\nHistory vP1(0);\nHistory vP2(0);\nHistory vAe(0);\nHistory vTa(0.9);\nHistory vGp(0);\nHistory vGk(0.99);\nHistory vX0(0);\nHistory vY0(0);\nHistory vW0(0);\nHistory vG0(1);\nHistory vCc0(1);\nHistory vSn0(0);\nHistory vR0(0.999);\nHistory vX1(0);\nHistory vY1(0);\nHistory vW1(0);\nHistory vG1(1);\nHistory vCc1(1);\nHistory vSn1(0);\nHistory vR1(0.999);\nHistory vX2(0);\nHistory vY2(0);\nHistory vW2(0);\nHistory vG2(1);\nHistory vCc2(1);\nHistory vSn2(0);\nHistory vR2(0.999);\nHistory vX3(0);\nHistory vY3(0);\nHistory vW3(0);\nHistory vG3(1);\nHistory vCc3(1);\nHistory vSn3(0);\nHistory vR3(0.999);\nHistory vX4(0);\nHistory vY4(0);\nHistory vW4(0);\nHistory vG4(1);\nHistory vCc4(1);\nHistory vSn4(0);\nHistory vR4(0.999);\nHistory vX5(0);\nHistory vY5(0);\nHistory vW5(0);\nHistory vG5(1);\nHistory vCc5(1);\nHistory vSn5(0);\nHistory vR5(0.999);\nHistory vX6(0);\nHistory vY6(0);\nHistory vW6(0);\nHistory vG6(1);\nHistory vCc6(1);\nHistory vSn6(0);\nHistory vR6(0.999);\nHistory vX7(0);\nHistory vY7(0);\nHistory vW7(0);\nHistory vG7(1);\nHistory vCc7(1);\nHistory vSn7(0);\nHistory vR7(0.999);\nHistory vX8(0);\nHistory vY8(0);\nHistory vW8(0);\nHistory vG8(1);\nHistory vCc8(1);\nHistory vSn8(0);\nHistory vR8(0.999);\nHistory vX9(0);\nHistory vY9(0);\nHistory vW9(0);\nHistory vG9(1);\nHistory vCc9(1);\nHistory vSn9(0);\nHistory vR9(0.999);\nHistory vX10(0);\nHistory vY10(0);\nHistory vW10(0);\nHistory vG10(1);\nHistory vCc10(1);\nHistory vSn10(0);\nHistory vR10(0.999);\nHistory vX11(0);\nHistory vY11(0);\nHistory vW11(0);\nHistory vG11(1);\nHistory vCc11(1);\nHistory vSn11(0);\nHistory vR11(0.999);\nHistory vX12(0);\nHistory vY12(0);\nHistory vW12(0);\nHistory vG12(1);\nHistory vCc12(1);\nHistory vSn12(0);\nHistory vR12(0.999);\nHistory vX13(0);\nHistory vY13(0);\nHistory vW13(0);\nHistory vG13(1);\nHistory vCc13(1);\nHistory vSn13(0);\nHistory vR13(0.999);\nHistory vX14(0);\nHistory vY14(0);\nHistory vW14(0);\nHistory vG14(1);\nHistory vCc14(1);\nHistory vSn14(0);\nHistory vR14(0.999);\nHistory vX15(0);\nHistory vY15(0);\nHistory vW15(0);\nHistory vG15(1);\nHistory vCc15(1);\nHistory vSn15(0);\nHistory vR15(0.999);\nHistory vX16(0);\nHistory vY16(0);\nHistory vW16(0);\nHistory vG16(1);\nHistory vCc16(1);\nHistory vSn16(0);\nHistory vR16(0.999);\nHistory vX17(0);\nHistory vY17(0);\nHistory vW17(0);\nHistory vG17(1);\nHistory vCc17(1);\nHistory vSn17(0);\nHistory vR17(0.999);\nHistory vBe17(0);\nHistory vBi117(0);\nHistory vBi217(0);\nHistory vBa117(0);\nHistory vBa217(0);\nHistory vBa317(0);\nHistory vBg17(0);\nHistory vX18(0);\nHistory vY18(0);\nHistory vW18(0);\nHistory vG18(1);\nHistory vCc18(1);\nHistory vSn18(0);\nHistory vR18(0.999);\nHistory vBe18(0);\nHistory vBi118(0);\nHistory vBi218(0);\nHistory vBa118(0);\nHistory vBa218(0);\nHistory vBa318(0);\nHistory vBg18(0);\nHistory vX19(0);\nHistory vY19(0);\nHistory vW19(0);\nHistory vG19(1);\nHistory vCc19(1);\nHistory vSn19(0);\nHistory vR19(0.999);\nHistory vBe19(0);\nHistory vBi119(0);\nHistory vBi219(0);\nHistory vBa119(0);\nHistory vBa219(0);\nHistory vBa319(0);\nHistory vBg19(0);\nHistory vX20(0);\nHistory vY20(0);\nHistory vW20(0);\nHistory vG20(1);\nHistory vCc20(1);\nHistory vSn20(0);\nHistory vR20(0.999);\nHistory vBe20(0);\nHistory vBi120(0);\nHistory vBi220(0);\nHistory vBa120(0);\nHistory vBa220(0);\nHistory vBa320(0);\nHistory vBg20(0);\nHistory vX21(0);\nHistory vY21(0);\nHistory vW21(0);\nHistory vG21(1);\nHistory vCc21(1);\nHistory vSn21(0);\nHistory vR21(0.999);\nHistory vBe21(0);\nHistory vBi121(0);\nHistory vBi221(0);\nHistory vBa121(0);\nHistory vBa221(0);\nHistory vBa321(0);\nHistory vBg21(0);\nHistory vX22(0);\nHistory vY22(0);\nHistory vW22(0);\nHistory vG22(1);\nHistory vCc22(1);\nHistory vSn22(0);\nHistory vR22(0.999);\nHistory vBe22(0);\nHistory vBi122(0);\nHistory vBi222(0);\nHistory vBa122(0);\nHistory vBa222(0);\nHistory vBa322(0);\nHistory vBg22(0);\nHistory vX23(0);\nHistory vY23(0);\nHistory vW23(0);\nHistory vG23(1);\nHistory vCc23(1);\nHistory vSn23(0);\nHistory vR23(0.999);\nHistory vBe23(0);\nHistory vBi123(0);\nHistory vBi223(0);\nHistory vBa123(0);\nHistory vBa223(0);\nHistory vBa323(0);\nHistory vBg23(0);\n\ndecayS = decay * 0.01;\nskinT = (skin - 50) * 0.02 * 6 / 6.0206;                      // +-6 dB per octave of mode ratio at the ends\ntouchT = (touch - 50) * 0.02;\npfT = exp2(mw * press / 12);\nmasterG = dbtoa(volume);\ncnt = cnt + 1; ctl = cnt >= 16; cnt = cnt - ctl * 16;\nif (ctl) { pf = pf + 0.2 * (pfT - pf); }\nnz = noise();\nvh = trg != pt; pt = trg;\nvIm = 0; vIt = 0;\nif (vh > 0.5) {\nvds = vh * stroke;                                    // History-derived: the stroke and velocity at the hit\nvdv = vh * vel;\nvg = pow(vdv, 1.4);\nvJs = nz * 1000 + trg; vJv = vary * 0.01;\nvAm = vg * ((abs(vds - 0) < 0.5) * 0.536200 + (abs(vds - 1) < 0.5) * 1.228200 + (abs(vds - 2) < 0.5) * 0.237900 + (abs(vds - 3) < 0.5) * 0.325600);\nvIm = vAm; vIt = vAm;\nvAe = 1; vTa = exp(-1 / (((abs(vds - 0) < 0.5) * 0.002610 + (abs(vds - 1) < 0.5) * 0.005960 + (abs(vds - 2) < 0.5) * 0.001350 + (abs(vds - 3) < 0.5) * 0.007170) * samplerate));\nvfc = ((abs(vds - 0) < 0.5) * 700.000000 + (abs(vds - 1) < 0.5) * 2500.000000 + (abs(vds - 2) < 0.5) * 5000.000000 + (abs(vds - 3) < 0.5) * 1500.000000) * exp2(touchT * 1.5 + (vdv - 0.6) * 0.8);\nvK = 1 - exp(-twopi * min(vfc, 18000) / samplerate);\nvC = vC + (1 - vC) * vdv;                              // a soft hit does not restart the stroke's own damping (an Open over a ringing Open would slow its ring again)\nvCk = exp(-16 / (((abs(vds - 0) < 0.5) * 0.400000 + (abs(vds - 1) < 0.5) * 0.100000 + (abs(vds - 2) < 0.5) * 0.200000 + (abs(vds - 3) < 0.5) * 0.050000) * samplerate));\nvGp = ((abs(vds - 0) < 0.5) * 0.063800 + (abs(vds - 1) < 0.5) * 0.000000 + (abs(vds - 2) < 0.5) * 0.000000 + (abs(vds - 3) < 0.5) * 0.000000) * vdv * vdv; vGk = exp(-16 / (0.1 * samplerate));\nvNe = vAm * ((abs(vds - 0) < 0.5) * 0.001000 + (abs(vds - 1) < 0.5) * 0.001600 + (abs(vds - 2) < 0.5) * 0.568200 + (abs(vds - 3) < 0.5) * 0.016800) * (1 + touchT);\nvNr = exp(-1 / (((abs(vds - 0) < 0.5) * 0.000800 + (abs(vds - 1) < 0.5) * 0.000800 + (abs(vds - 2) < 0.5) * 0.000800 + (abs(vds - 3) < 0.5) * 0.000800) * samplerate));\nvNg = tan(pi * ((abs(vds - 0) < 0.5) * 800.000000 + (abs(vds - 1) < 0.5) * 830.000000 + (abs(vds - 2) < 0.5) * 3460.000000 + (abs(vds - 3) < 0.5) * 860.000000) / samplerate); vNk = 1 / ((abs(vds - 0) < 0.5) * 0.700000 + (abs(vds - 1) < 0.5) * 0.700000 + (abs(vds - 2) < 0.5) * 0.700000 + (abs(vds - 3) < 0.5) * 0.700000);\nvNa1 = 1 / (1 + vNg * (vNg + vNk)); vNa2 = vNg * vNa1; vNa3 = vNg * vNa2;\nvW0 = ((abs(vds - 0) < 0.5) * 0.092257 + (abs(vds - 1) < 0.5) * 1.000000 + (abs(vds - 2) < 0.5) * 0.199526 + (abs(vds - 3) < 0.5) * 1.000000) * exp(skinT * -1.203973) * exp(0.299115 * vJv * (fract(sin(vJs + 0.0) * 43758.5453) * 2 - 1)); vG0 = (abs(vds - 0) < 0.5) * 0.250000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.250000;\nvW1 = ((abs(vds - 0) < 0.5) * 0.031623 + (abs(vds - 1) < 0.5) * 0.040272 + (abs(vds - 2) < 0.5) * 0.334965 + (abs(vds - 3) < 0.5) * 0.037154) * exp(skinT * -0.867501) * exp(0.299115 * vJv * (fract(sin(vJs + 78.233) * 43758.5453) * 2 - 1)); vG1 = (abs(vds - 0) < 0.5) * 0.250000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.250000;\nvW2 = ((abs(vds - 0) < 0.5) * 0.041687 + (abs(vds - 1) < 0.5) * 0.543250 + (abs(vds - 2) < 0.5) * 0.007413 + (abs(vds - 3) < 0.5) * 0.131826) * exp(skinT * -0.616186) * exp(0.299115 * vJv * (fract(sin(vJs + 156.466) * 43758.5453) * 2 - 1)); vG2 = (abs(vds - 0) < 0.5) * 0.250000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.250000;\nvW3 = ((abs(vds - 0) < 0.5) * 0.000351 + (abs(vds - 1) < 0.5) * 0.008610 + (abs(vds - 2) < 0.5) * 0.035892 + (abs(vds - 3) < 0.5) * 0.131826) * exp(skinT * -0.301105) * exp(0.299115 * vJv * (fract(sin(vJs + 234.699) * 43758.5453) * 2 - 1)); vG3 = (abs(vds - 0) < 0.5) * 0.250000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.250000;\nvW4 = ((abs(vds - 0) < 0.5) * 0.015668 + (abs(vds - 1) < 0.5) * 0.050119 + (abs(vds - 2) < 0.5) * 0.338844 + (abs(vds - 3) < 0.5) * 0.066069) * exp(skinT * -0.162519) * exp(0.299115 * vJv * (fract(sin(vJs + 312.932) * 43758.5453) * 2 - 1)); vG4 = (abs(vds - 0) < 0.5) * 0.250000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.250000;\nvW5 = ((abs(vds - 0) < 0.5) * 1.000000 + (abs(vds - 1) < 0.5) * 0.019055 + (abs(vds - 2) < 0.5) * 0.094406 + (abs(vds - 3) < 0.5) * 0.116145) * exp(skinT * 0.000000) * exp(0.299115 * vJv * (fract(sin(vJs + 391.165) * 43758.5453) * 2 - 1)); vG5 = (abs(vds - 0) < 0.5) * 0.250000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.250000;\nvW6 = ((abs(vds - 0) < 0.5) * 0.165959 + (abs(vds - 1) < 0.5) * 0.044157 + (abs(vds - 2) < 0.5) * 0.000302 + (abs(vds - 3) < 0.5) * 0.173780) * exp(skinT * 0.182322) * exp(0.299115 * vJv * (fract(sin(vJs + 469.398) * 43758.5453) * 2 - 1)); vG6 = (abs(vds - 0) < 0.5) * 0.250000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.250000;\nvW7 = ((abs(vds - 0) < 0.5) * 0.000313 + (abs(vds - 1) < 0.5) * 0.162181 + (abs(vds - 2) < 0.5) * 0.028510 + (abs(vds - 3) < 0.5) * 0.069183) * exp(skinT * 0.371564) * exp(0.299115 * vJv * (fract(sin(vJs + 547.6310000000001) * 43758.5453) * 2 - 1)); vG7 = (abs(vds - 0) < 0.5) * 0.250000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.250000;\nvW8 = ((abs(vds - 0) < 0.5) * 0.074131 + (abs(vds - 1) < 0.5) * 0.484172 + (abs(vds - 2) < 0.5) * 0.066834 + (abs(vds - 3) < 0.5) * 0.093325) * exp(skinT * 0.500775) * exp(0.299115 * vJv * (fract(sin(vJs + 625.864) * 43758.5453) * 2 - 1)); vG8 = (abs(vds - 0) < 0.5) * 0.250000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.250000;\nvW9 = ((abs(vds - 0) < 0.5) * 0.116145 + (abs(vds - 1) < 0.5) * 0.041210 + (abs(vds - 2) < 0.5) * 0.030903 + (abs(vds - 3) < 0.5) * 0.044668) * exp(skinT * 0.615186) * exp(0.299115 * vJv * (fract(sin(vJs + 704.097) * 43758.5453) * 2 - 1)); vG9 = (abs(vds - 0) < 0.5) * 0.250000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.250000;\nvW10 = ((abs(vds - 0) < 0.5) * 0.033113 + (abs(vds - 1) < 0.5) * 0.192752 + (abs(vds - 2) < 0.5) * 0.024831 + (abs(vds - 3) < 0.5) * 0.038905) * exp(skinT * 0.875469) * exp(0.299115 * vJv * (fract(sin(vJs + 782.33) * 43758.5453) * 2 - 1)); vG10 = (abs(vds - 0) < 0.5) * 0.250000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.250000;\nvW11 = ((abs(vds - 0) < 0.5) * 0.021878 + (abs(vds - 1) < 0.5) * 0.034674 + (abs(vds - 2) < 0.5) * 0.055590 + (abs(vds - 3) < 0.5) * 0.018197) * exp(skinT * 1.015231) * exp(0.299115 * vJv * (fract(sin(vJs + 860.5630000000001) * 43758.5453) * 2 - 1)); vG11 = (abs(vds - 0) < 0.5) * 0.250000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.250000;\nvW12 = ((abs(vds - 0) < 0.5) * 0.035481 + (abs(vds - 1) < 0.5) * 0.019055 + (abs(vds - 2) < 0.5) * 0.037154 + (abs(vds - 3) < 0.5) * 0.027227) * exp(skinT * 1.098612) * exp(0.299115 * vJv * (fract(sin(vJs + 938.796) * 43758.5453) * 2 - 1)); vG12 = (abs(vds - 0) < 0.5) * 0.250000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.250000;\nvW13 = ((abs(vds - 0) < 0.5) * 0.045709 + (abs(vds - 1) < 0.5) * 0.076736 + (abs(vds - 2) < 0.5) * 0.000302 + (abs(vds - 3) < 0.5) * 0.015136) * exp(skinT * 1.342865) * exp(0.299115 * vJv * (fract(sin(vJs + 1017.029) * 43758.5453) * 2 - 1)); vG13 = (abs(vds - 0) < 0.5) * 0.250000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.250000;\nvW14 = ((abs(vds - 0) < 0.5) * 0.024266 + (abs(vds - 1) < 0.5) * 0.061660 + (abs(vds - 2) < 0.5) * 0.069984 + (abs(vds - 3) < 0.5) * 0.014289) * exp(skinT * 1.481605) * exp(0.299115 * vJv * (fract(sin(vJs + 1095.2620000000002) * 43758.5453) * 2 - 1)); vG14 = (abs(vds - 0) < 0.5) * 0.250000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.250000;\nvW15 = ((abs(vds - 0) < 0.5) * 0.052481 + (abs(vds - 1) < 0.5) * 0.019275 + (abs(vds - 2) < 0.5) * 0.101158 + (abs(vds - 3) < 0.5) * 0.006918) * exp(skinT * 1.648659) * exp(0.299115 * vJv * (fract(sin(vJs + 1173.4950000000001) * 43758.5453) * 2 - 1)); vG15 = (abs(vds - 0) < 0.5) * 0.250000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.250000;\nvW16 = ((abs(vds - 0) < 0.5) * 0.064565 + (abs(vds - 1) < 0.5) * 0.024831 + (abs(vds - 2) < 0.5) * 0.047863 + (abs(vds - 3) < 0.5) * 0.020893) * exp(skinT * 1.768150) * exp(0.299115 * vJv * (fract(sin(vJs + 1251.728) * 43758.5453) * 2 - 1)); vG16 = (abs(vds - 0) < 0.5) * 0.250000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.250000;\nvW17 = ((abs(vds - 0) < 0.5) * 0.237137 + (abs(vds - 1) < 0.5) * 0.086099 + (abs(vds - 2) < 0.5) * 0.030549 + (abs(vds - 3) < 0.5) * 0.046238) * exp(skinT * 2.230264); vG17 = (abs(vds - 0) < 0.5) * 1.000000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 1.000000;\nvW18 = ((abs(vds - 0) < 0.5) * 0.005188 + (abs(vds - 1) < 0.5) * 0.036308 + (abs(vds - 2) < 0.5) * 1.000000 + (abs(vds - 3) < 0.5) * 0.025410) * exp(skinT * 2.593170); vG18 = (abs(vds - 0) < 0.5) * 1.000000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 1.000000;\nvW19 = ((abs(vds - 0) < 0.5) * 0.001995 + (abs(vds - 1) < 0.5) * 0.009886 + (abs(vds - 2) < 0.5) * 0.512861 + (abs(vds - 3) < 0.5) * 0.002754) * exp(skinT * 2.954183); vG19 = (abs(vds - 0) < 0.5) * 1.000000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 1.000000;\nvW20 = ((abs(vds - 0) < 0.5) * 0.000313 + (abs(vds - 1) < 0.5) * 0.000299 + (abs(vds - 2) < 0.5) * 0.103514 + (abs(vds - 3) < 0.5) * 0.000422) * exp(skinT * 3.328877); vG20 = (abs(vds - 0) < 0.5) * 1.000000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 1.000000;\nvW21 = ((abs(vds - 0) < 0.5) * 0.000313 + (abs(vds - 1) < 0.5) * 0.000299 + (abs(vds - 2) < 0.5) * 0.009886 + (abs(vds - 3) < 0.5) * 0.002399) * exp(skinT * 3.706171); vG21 = (abs(vds - 0) < 0.5) * 1.000000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 1.000000;\nvW22 = ((abs(vds - 0) < 0.5) * 0.000313 + (abs(vds - 1) < 0.5) * 0.000299 + (abs(vds - 2) < 0.5) * 0.001035 + (abs(vds - 3) < 0.5) * 0.019724) * exp(skinT * 4.102067); vG22 = (abs(vds - 0) < 0.5) * 1.000000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 1.000000;\nvW23 = ((abs(vds - 0) < 0.5) * 0.000313 + (abs(vds - 1) < 0.5) * 0.000299 + (abs(vds - 2) < 0.5) * 0.001778 + (abs(vds - 3) < 0.5) * 0.074989) * exp(skinT * 4.507532); vG23 = (abs(vds - 0) < 0.5) * 1.000000 + (abs(vds - 1) < 0.5) * 4.000000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 1.000000;\nvkp = (abs(vds - 0) < 0.5) * 0.900000 + (abs(vds - 1) < 0.5) * 0.150000 + (abs(vds - 2) < 0.5) * 0.700000 + (abs(vds - 3) < 0.5) * 0.500000;\nvX0 = vX0 * vkp; vY0 = vY0 * vkp;\nvX1 = vX1 * vkp; vY1 = vY1 * vkp;\nvX2 = vX2 * vkp; vY2 = vY2 * vkp;\nvX3 = vX3 * vkp; vY3 = vY3 * vkp;\nvX4 = vX4 * vkp; vY4 = vY4 * vkp;\nvX5 = vX5 * vkp; vY5 = vY5 * vkp;\nvX6 = vX6 * vkp; vY6 = vY6 * vkp;\nvX7 = vX7 * vkp; vY7 = vY7 * vkp;\nvX8 = vX8 * vkp; vY8 = vY8 * vkp;\nvX9 = vX9 * vkp; vY9 = vY9 * vkp;\nvX10 = vX10 * vkp; vY10 = vY10 * vkp;\nvX11 = vX11 * vkp; vY11 = vY11 * vkp;\nvX12 = vX12 * vkp; vY12 = vY12 * vkp;\nvX13 = vX13 * vkp; vY13 = vY13 * vkp;\nvX14 = vX14 * vkp; vY14 = vY14 * vkp;\nvX15 = vX15 * vkp; vY15 = vY15 * vkp;\nvX16 = vX16 * vkp; vY16 = vY16 * vkp;\nvBe17 = vBe17 * vkp; vBg17 = vW17 * 5.0 / (1 + 640000 / (vfc * vfc));\nvBe18 = vBe18 * vkp; vBg18 = vW18 * 5.0 / (1 + 1322500 / (vfc * vfc));\nvBe19 = vBe19 * vkp; vBg19 = vW19 * 5.0 / (1 + 2722500 / (vfc * vfc));\nvBe20 = vBe20 * vkp; vBg20 = vW20 * 5.0 / (1 + 5760000 / (vfc * vfc));\nvBe21 = vBe21 * vkp; vBg21 = vW21 * 5.0 / (1 + 12250000 / (vfc * vfc));\nvBe22 = vBe22 * vkp; vBg22 = vW22 * 5.0 / (1 + 27040000 / (vfc * vfc));\nvBe23 = vBe23 * vkp; vBg23 = vW23 * 5.0 / (1 + 60840000 / (vfc * vfc));\n}\nvE1 = vE1 + vK * (vIm - vE1); vE2 = vE2 + vK * (vE1 - vE2);\nif (ctl) {\nvC = vC * vCk; vGp = vGp * vGk;\nvF1 = 86.0 * exp2(tune / 12);\nvw = twopi * vF1 * pf * (1 + vGp) * 0.3 / samplerate; vCc0 = cos(vw); vSn0 = sin(vw); vR0 = exp(-6.907755279 * (1 + (vG0 - 1) * vC) / (0.12 * decayS * samplerate));\nvw = twopi * vF1 * pf * (1 + vGp) * 0.42 / samplerate; vCc1 = cos(vw); vSn1 = sin(vw); vR1 = exp(-6.907755279 * (1 + (vG1 - 1) * vC) / (0.25 * decayS * samplerate));\nvw = twopi * vF1 * pf * (1 + vGp) * 0.54 / samplerate; vCc2 = cos(vw); vSn2 = sin(vw); vR2 = exp(-6.907755279 * (1 + (vG2 - 1) * vC) / (0.15 * decayS * samplerate));\nvw = twopi * vF1 * pf * (1 + vGp) * 0.74 / samplerate; vCc3 = cos(vw); vSn3 = sin(vw); vR3 = exp(-6.907755279 * (1 + (vG3 - 1) * vC) / (0.3 * decayS * samplerate));\nvw = twopi * vF1 * pf * (1 + vGp) * 0.85 / samplerate; vCc4 = cos(vw); vSn4 = sin(vw); vR4 = exp(-6.907755279 * (1 + (vG4 - 1) * vC) / (0.75 * decayS * samplerate));\nvw = twopi * vF1 * pf * (1 + vGp) * 1.0 / samplerate; vCc5 = cos(vw); vSn5 = sin(vw); vR5 = exp(-6.907755279 * (1 + (vG5 - 1) * vC) / (0.85 * decayS * samplerate));\nvw = twopi * vF1 * pf * (1 + vGp) * 1.2 / samplerate; vCc6 = cos(vw); vSn6 = sin(vw); vR6 = exp(-6.907755279 * (1 + (vG6 - 1) * vC) / (0.4 * decayS * samplerate));\nvw = twopi * vF1 * pf * (1 + vGp) * 1.45 / samplerate; vCc7 = cos(vw); vSn7 = sin(vw); vR7 = exp(-6.907755279 * (1 + (vG7 - 1) * vC) / (0.35 * decayS * samplerate));\nvw = twopi * vF1 * pf * (1 + vGp) * 1.65 / samplerate; vCc8 = cos(vw); vSn8 = sin(vw); vR8 = exp(-6.907755279 * (1 + (vG8 - 1) * vC) / (0.3 * decayS * samplerate));\nvw = twopi * vF1 * pf * (1 + vGp) * 1.85 / samplerate; vCc9 = cos(vw); vSn9 = sin(vw); vR9 = exp(-6.907755279 * (1 + (vG9 - 1) * vC) / (1.0 * decayS * samplerate));\nvw = twopi * vF1 * pf * (1 + vGp) * 2.4 / samplerate; vCc10 = cos(vw); vSn10 = sin(vw); vR10 = exp(-6.907755279 * (1 + (vG10 - 1) * vC) / (0.3 * decayS * samplerate));\nvw = twopi * vF1 * pf * (1 + vGp) * 2.76 / samplerate; vCc11 = cos(vw); vSn11 = sin(vw); vR11 = exp(-6.907755279 * (1 + (vG11 - 1) * vC) / (0.5 * decayS * samplerate));\nvw = twopi * vF1 * pf * (1 + vGp) * 3.0 / samplerate; vCc12 = cos(vw); vSn12 = sin(vw); vR12 = exp(-6.907755279 * (1 + (vG12 - 1) * vC) / (1.0 * decayS * samplerate));\nvw = twopi * vF1 * pf * (1 + vGp) * 3.83 / samplerate; vCc13 = cos(vw); vSn13 = sin(vw); vR13 = exp(-6.907755279 * (1 + (vG13 - 1) * vC) / (0.4 * decayS * samplerate));\nvw = twopi * vF1 * pf * (1 + vGp) * 4.4 / samplerate; vCc14 = cos(vw); vSn14 = sin(vw); vR14 = exp(-6.907755279 * (1 + (vG14 - 1) * vC) / (0.4 * decayS * samplerate));\nvw = twopi * vF1 * pf * (1 + vGp) * 5.2 / samplerate; vCc15 = cos(vw); vSn15 = sin(vw); vR15 = exp(-6.907755279 * (1 + (vG15 - 1) * vC) / (0.9 * decayS * samplerate));\nvw = twopi * vF1 * pf * (1 + vGp) * 5.86 / samplerate; vCc16 = cos(vw); vSn16 = sin(vw); vR16 = exp(-6.907755279 * (1 + (vG16 - 1) * vC) / (0.6 * decayS * samplerate));\nvBg = tan(pi * 800 / samplerate); vBa117 = 1 / (1 + vBg * (vBg + 0.500000)); vBa217 = vBg * vBa117; vBa317 = vBg * vBa217; vR17 = exp(-21.586735 * (1 + (vG17 - 1) * vC) / (decayS * samplerate));\nvBg = tan(pi * 1150 / samplerate); vBa118 = 1 / (1 + vBg * (vBg + 0.500000)); vBa218 = vBg * vBa118; vBa318 = vBg * vBa218; vR18 = exp(-24.670555 * (1 + (vG18 - 1) * vC) / (decayS * samplerate));\nvBg = tan(pi * 1650 / samplerate); vBa119 = 1 / (1 + vBg * (vBg + 0.500000)); vBa219 = vBg * vBa119; vBa319 = vBg * vBa219; vR19 = exp(-28.782314 * (1 + (vG19 - 1) * vC) / (decayS * samplerate));\nvBg = tan(pi * 2400 / samplerate); vBa120 = 1 / (1 + vBg * (vBg + 0.500000)); vBa220 = vBg * vBa120; vBa320 = vBg * vBa220; vR20 = exp(-34.538776 * (1 + (vG20 - 1) * vC) / (decayS * samplerate));\nvBg = tan(pi * 3500 / samplerate); vBa121 = 1 / (1 + vBg * (vBg + 0.500000)); vBa221 = vBg * vBa121; vBa321 = vBg * vBa221; vR21 = exp(-34.538776 * (1 + (vG21 - 1) * vC) / (decayS * samplerate));\nvBg = tan(pi * 5200 / samplerate); vBa122 = 1 / (1 + vBg * (vBg + 0.500000)); vBa222 = vBg * vBa122; vBa322 = vBg * vBa222; vR22 = exp(-34.538776 * (1 + (vG22 - 1) * vC) / (decayS * samplerate));\nvBg = tan(pi * 7800 / samplerate); vBa123 = 1 / (1 + vBg * (vBg + 0.500000)); vBa223 = vBg * vBa123; vBa323 = vBg * vBa223; vR23 = exp(-34.538776 * (1 + (vG23 - 1) * vC) / (decayS * samplerate));\n}\nvXn = vR0 * (vCc0 * vX0 - vSn0 * vY0) + 0.737369 * vW0 * vE2; vY0 = vR0 * (vSn0 * vX0 + vCc0 * vY0) + 0.675490 * vW0 * vE2; vX0 = vXn;\nvXn = vR1 * (vCc1 * vX1 - vSn1 * vY1) + -0.087426 * vW1 * vE2; vY1 = vR1 * (vSn1 * vX1 + vCc1 * vY1) + -0.996171 * vW1 * vE2; vX1 = vXn;\nvXn = vR2 * (vCc2 * vX2 - vSn2 * vY2) + -0.608439 * vW2 * vE2; vY2 = vR2 * (vSn2 * vX2 + vCc2 * vY2) + 0.793601 * vW2 * vE2; vX2 = vXn;\nvXn = vR3 * (vCc3 * vX3 - vSn3 * vY3) + 0.984713 * vW3 * vE2; vY3 = vR3 * (vSn3 * vX3 + vCc3 * vY3) + -0.174182 * vW3 * vE2; vX3 = vXn;\nvXn = vR4 * (vCc4 * vX4 - vSn4 * vY4) + -0.843755 * vW4 * vE2; vY4 = vR4 * (vSn4 * vX4 + vCc4 * vY4) + -0.536728 * vW4 * vE2; vX4 = vXn;\nvXn = vR5 * (vCc5 * vX5 - vSn5 * vY5) + 0.259604 * vW5 * vE2; vY5 = vR5 * (vSn5 * vX5 + vCc5 * vY5) + 0.965715 * vW5 * vE2; vX5 = vXn;\nvXn = vR6 * (vCc6 * vX6 - vSn6 * vY6) + 0.460907 * vW6 * vE2; vY6 = vR6 * (vSn6 * vX6 + vCc6 * vY6) + -0.887448 * vW6 * vE2; vX6 = vXn;\nvXn = vR7 * (vCc7 * vX7 - vSn7 * vY7) + -0.939321 * vW7 * vE2; vY7 = vR7 * (vSn7 * vX7 + vCc7 * vY7) + 0.343039 * vW7 * vE2; vX7 = vXn;\nvXn = vR8 * (vCc8 * vX8 - vSn8 * vY8) + 0.924346 * vW8 * vE2; vY8 = vR8 * (vSn8 * vX8 + vCc8 * vY8) + 0.381556 * vW8 * vE2; vX8 = vXn;\nvXn = vR9 * (vCc9 * vX9 - vSn9 * vY9) + -0.423846 * vW9 * vE2; vY9 = vR9 * (vSn9 * vX9 + vCc9 * vY9) + -0.905734 * vW9 * vE2; vX9 = vXn;\nvXn = vR10 * (vCc10 * vX10 - vSn10 * vY10) + -0.299284 * vW10 * vE2; vY10 = vR10 * (vSn10 * vX10 + vCc10 * vY10) + 0.954164 * vW10 * vE2; vX10 = vXn;\nvXn = vR11 * (vCc11 * vX11 - vSn11 * vY11) + 0.865211 * vW11 * vE2; vY11 = vR11 * (vSn11 * vX11 + vCc11 * vY11) + -0.501408 * vW11 * vE2; vX11 = vXn;\nvXn = vR12 * (vCc12 * vX12 - vSn12 * vY12) + -0.976676 * vW12 * vE2; vY12 = vR12 * (vSn12 * vX12 + vCc12 * vY12) + -0.214719 * vW12 * vE2; vX12 = vXn;\nvXn = vR13 * (vCc13 * vX13 - vSn13 * vY13) + 0.575129 * vW13 * vE2; vY13 = vR13 * (vSn13 * vX13 + vCc13 * vY13) + 0.818062 * vW13 * vE2; vX13 = vXn;\nvXn = vR14 * (vCc14 * vX14 - vSn14 * vY14) + 0.128511 * vW14 * vE2; vY14 = vR14 * (vSn14 * vX14 + vCc14 * vY14) + -0.991708 * vW14 * vE2; vX14 = vXn;\nvXn = vR15 * (vCc15 * vX15 - vSn15 * vY15) + -0.764649 * vW15 * vE2; vY15 = vR15 * (vSn15 * vX15 + vCc15 * vY15) + 0.644447 * vW15 * vE2; vX15 = vXn;\nvXn = vR16 * (vCc16 * vX16 - vSn16 * vY16) + 0.999146 * vW16 * vE2; vY16 = vR16 * (vSn16 * vX16 + vCc16 * vY16) + 0.041318 * vW16 * vE2; vX16 = vXn;\nvKn = 1 - exp(-1 / (0.0003 * samplerate)); vP1 = vP1 + vKn * (vIt - vP1); vP2 = vP2 + vKn * (vP1 - vP2);\nvBe17 = vBe17 * vR17 + vBg17 * vP2; vQ3 = nz * vBe17 - vBi217; vQb = vBa117 * vBi117 + vBa217 * vQ3; vQl = vBi217 + vBa217 * vBi117 + vBa317 * vQ3; vBi117 = 2 * vQb - vBi117; vBi217 = 2 * vQl - vBi217; vY17 = vQb / 2.0;\nvBe18 = vBe18 * vR18 + vBg18 * vP2; vQ3 = nz * vBe18 - vBi218; vQb = vBa118 * vBi118 + vBa218 * vQ3; vQl = vBi218 + vBa218 * vBi118 + vBa318 * vQ3; vBi118 = 2 * vQb - vBi118; vBi218 = 2 * vQl - vBi218; vY18 = vQb / 2.0;\nvBe19 = vBe19 * vR19 + vBg19 * vP2; vQ3 = nz * vBe19 - vBi219; vQb = vBa119 * vBi119 + vBa219 * vQ3; vQl = vBi219 + vBa219 * vBi119 + vBa319 * vQ3; vBi119 = 2 * vQb - vBi119; vBi219 = 2 * vQl - vBi219; vY19 = vQb / 2.0;\nvBe20 = vBe20 * vR20 + vBg20 * vP2; vQ3 = nz * vBe20 - vBi220; vQb = vBa120 * vBi120 + vBa220 * vQ3; vQl = vBi220 + vBa220 * vBi120 + vBa320 * vQ3; vBi120 = 2 * vQb - vBi120; vBi220 = 2 * vQl - vBi220; vY20 = vQb / 2.0;\nvBe21 = vBe21 * vR21 + vBg21 * vP2; vQ3 = nz * vBe21 - vBi221; vQb = vBa121 * vBi121 + vBa221 * vQ3; vQl = vBi221 + vBa221 * vBi121 + vBa321 * vQ3; vBi121 = 2 * vQb - vBi121; vBi221 = 2 * vQl - vBi221; vY21 = vQb / 2.0;\nvBe22 = vBe22 * vR22 + vBg22 * vP2; vQ3 = nz * vBe22 - vBi222; vQb = vBa122 * vBi122 + vBa222 * vQ3; vQl = vBi222 + vBa222 * vBi122 + vBa322 * vQ3; vBi122 = 2 * vQb - vBi122; vBi222 = 2 * vQl - vBi222; vY22 = vQb / 2.0;\nvBe23 = vBe23 * vR23 + vBg23 * vP2; vQ3 = nz * vBe23 - vBi223; vQb = vBa123 * vBi123 + vBa223 * vQ3; vQl = vBi223 + vBa223 * vBi123 + vBa323 * vQ3; vBi123 = 2 * vQb - vBi123; vBi223 = 2 * vQl - vBi223; vY23 = vQb / 2.0;\nvAe = vAe * vTa;                                      // the head's tone swells in (a soft contact) while the tick and the noise bands start at once\nvSm = (1 - vAe) * (vY0 + vY1 + vY2 + vY3 + vY4 + vY5 + vY6 + vY7 + vY8 + vY9 + vY10 + vY11 + vY12 + vY13 + vY14 + vY15 + vY16) + vY17 + vY18 + vY19 + vY20 + vY21 + vY22 + vY23;\nvNx = nz * vNe; vNe = vNe * vNr;\nvNv3 = vNx - vI2; vNb = vNa1 * vI1 + vNa2 * vNv3; vNl = vI2 + vNa2 * vI1 + vNa3 * vNv3; vI1 = 2 * vNb - vI1; vI2 = 2 * vNl - vI2;\nvmix = (vSm + vNk * vNb) * masterG;\nvax = abs(vmix); vlim = sign(vmix) * (min(vax, 0.8) + 0.2 * tanh(max(vax - 0.8, 0) * 5));\nout1 = vlim + 0 * in1; out2 = vlim + 0 * in2;\n",
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
			}
		],
		"dependency_cache": [],
		"autosave": 0,
		"parameters": {
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
						"Stroke",
						"Tune",
						"Decay",
						"Skin",
						"Touch",
						"Vary",
						"Press",
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