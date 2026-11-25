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
		"description": "Timbales: one timbal (High or Low; open, rimshot, cascara, paila, rim click or muted) as a head + metal-shell modal model, for Drum Rack pads.",
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
					"text": "js timbales_push.js",
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
					"annotation": "The mod wheel presses the head (a hand or the stick leaning on it): this many semitones up at full wheel. The shell does not move.",
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
					"id": "pre_stick",
					"maxclass": "newobj",
					"text": "prepend stick",
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
					"id": "ol_stick",
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
					"id": "stick",
					"varname": "stick",
					"parameter_enable": 1,
					"annotation_name": "Stick",
					"annotation": "Hardness of the stick contact: harder is shorter and brighter and ticks more.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Stick",
							"parameter_shortname": "Stick",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								50
							],
							"parameter_unitstyle": 9,
							"parameter_units": "Stick %.0f"
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
					"id": "pre_ring",
					"maxclass": "newobj",
					"text": "prepend ring",
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
					"id": "ol_ring",
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
					"id": "ring",
					"varname": "ring",
					"parameter_enable": 1,
					"annotation_name": "Ring",
					"annotation": "How long the metal shell rings, in percent of the natural time. Short is a dry cascara; long is a loose or ringing shell.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Ring",
							"parameter_shortname": "Ring",
							"parameter_type": 0,
							"parameter_mmin": 30.0,
							"parameter_mmax": 300.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								100
							],
							"parameter_unitstyle": 9,
							"parameter_units": "Ring %.0f"
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
						740,
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
					"id": "shell",
					"varname": "shell",
					"parameter_enable": 1,
					"annotation_name": "Shell",
					"annotation": "How loud the metal shell is: its ring is the cascara, and the metallic edge of every other stroke.",
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
					"annotation": "How long the head rings, in percent of the natural time.",
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
					"annotation": "Tuning of the head in semitones. 0 is the drum's open tone (High 200 Hz, Low 120 Hz). The shell does not move.",
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
					"annotation": "Which stick stroke a note plays: Open (head, ringing), Rimshot (rim and head together, the crack), Cascara (stick on the shell near the top edge), Paila (stick on the middle of the shell), Rim click (stick across the head, against the rim) or Muted (stick pressed into the head). Changing it between hits works: the new stroke damps the ring already there.",
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
								"Rimshot",
								"Cascara",
								"Paila",
								"Rim click",
								"Muted"
							],
							"parameter_mmax": 5,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								2
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
					"annotation": "Which timbal: High (the macho, small drum, open tone about 200 Hz) or Low (the hembra, about 120 Hz). Any MIDI note plays it.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Drum",
							"parameter_shortname": "Drum",
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
					"filename": "timbales_view.js",
					"border": 0,
					"parameter_enable": 0,
					"annotation_name": "Timbal",
					"annotation": "The drum and the stick, and the stroke a note plays: it flashes when it is hit.",
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
					"text": "js timbales_midi.js",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						20,
						200,
						133,
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
									"code": "Param drum(0);\nParam stroke(2);\nParam tune(0);\nParam decay(100);\nParam shell(50);\nParam ring(100);\nParam stick(50);\nParam press(5);\nParam vary(100);\nParam volume(-9);\nParam trg(0);\nParam vel(1);\nParam mw(0);\nHistory cnt(0);\nHistory pf(1);\nHistory pt(0);\nHistory vC(0);\nHistory vCk(0.99);\nHistory vE1(0);\nHistory vE2(0);\nHistory vK(0.5);\nHistory vNe(0);\nHistory vNr(0.99);\nHistory vI1(0);\nHistory vI2(0);\nHistory vNa1(0);\nHistory vNa2(0);\nHistory vNa3(0);\nHistory vNk(1);\nHistory vAm(0);\nHistory vF1(200);\nHistory vTd(1);\nHistory vTs(1);\nHistory vP1(0);\nHistory vP2(0);\nHistory vX0(0);\nHistory vY0(0);\nHistory vW0(0);\nHistory vG0(1);\nHistory vCc0(1);\nHistory vSn0(0);\nHistory vR0(0.999);\nHistory vX1(0);\nHistory vY1(0);\nHistory vW1(0);\nHistory vG1(1);\nHistory vCc1(1);\nHistory vSn1(0);\nHistory vR1(0.999);\nHistory vX2(0);\nHistory vY2(0);\nHistory vW2(0);\nHistory vG2(1);\nHistory vCc2(1);\nHistory vSn2(0);\nHistory vR2(0.999);\nHistory vX3(0);\nHistory vY3(0);\nHistory vW3(0);\nHistory vG3(1);\nHistory vCc3(1);\nHistory vSn3(0);\nHistory vR3(0.999);\nHistory vX4(0);\nHistory vY4(0);\nHistory vW4(0);\nHistory vG4(1);\nHistory vCc4(1);\nHistory vSn4(0);\nHistory vR4(0.999);\nHistory vX5(0);\nHistory vY5(0);\nHistory vW5(0);\nHistory vG5(1);\nHistory vCc5(1);\nHistory vSn5(0);\nHistory vR5(0.999);\nHistory vX6(0);\nHistory vY6(0);\nHistory vW6(0);\nHistory vG6(1);\nHistory vCc6(1);\nHistory vSn6(0);\nHistory vR6(0.999);\nHistory vX7(0);\nHistory vY7(0);\nHistory vW7(0);\nHistory vG7(1);\nHistory vCc7(1);\nHistory vSn7(0);\nHistory vR7(0.999);\nHistory vX8(0);\nHistory vY8(0);\nHistory vW8(0);\nHistory vG8(1);\nHistory vCc8(1);\nHistory vSn8(0);\nHistory vR8(0.999);\nHistory vX9(0);\nHistory vY9(0);\nHistory vW9(0);\nHistory vG9(1);\nHistory vCc9(1);\nHistory vSn9(0);\nHistory vR9(0.999);\nHistory vX10(0);\nHistory vY10(0);\nHistory vW10(0);\nHistory vG10(1);\nHistory vCc10(1);\nHistory vSn10(0);\nHistory vR10(0.999);\nHistory vX11(0);\nHistory vY11(0);\nHistory vW11(0);\nHistory vG11(1);\nHistory vCc11(1);\nHistory vSn11(0);\nHistory vR11(0.999);\nHistory vX12(0);\nHistory vY12(0);\nHistory vW12(0);\nHistory vG12(1);\nHistory vCc12(1);\nHistory vSn12(0);\nHistory vR12(0.999);\nHistory vX13(0);\nHistory vY13(0);\nHistory vW13(0);\nHistory vG13(1);\nHistory vCc13(1);\nHistory vSn13(0);\nHistory vR13(0.999);\nHistory vX14(0);\nHistory vY14(0);\nHistory vW14(0);\nHistory vG14(1);\nHistory vCc14(1);\nHistory vSn14(0);\nHistory vR14(0.999);\nHistory vX15(0);\nHistory vY15(0);\nHistory vW15(0);\nHistory vG15(1);\nHistory vCc15(1);\nHistory vSn15(0);\nHistory vR15(0.999);\nHistory vX16(0);\nHistory vY16(0);\nHistory vW16(0);\nHistory vG16(1);\nHistory vCc16(1);\nHistory vSn16(0);\nHistory vR16(0.999);\nHistory vX17(0);\nHistory vY17(0);\nHistory vW17(0);\nHistory vG17(1);\nHistory vCc17(1);\nHistory vSn17(0);\nHistory vR17(0.999);\nHistory vX18(0);\nHistory vY18(0);\nHistory vW18(0);\nHistory vG18(1);\nHistory vCc18(1);\nHistory vSn18(0);\nHistory vR18(0.999);\nHistory vX19(0);\nHistory vY19(0);\nHistory vW19(0);\nHistory vG19(1);\nHistory vCc19(1);\nHistory vSn19(0);\nHistory vR19(0.999);\nHistory vBe19(0);\nHistory vBi119(0);\nHistory vBi219(0);\nHistory vBa119(0);\nHistory vBa219(0);\nHistory vBa319(0);\nHistory vBg19(0);\nHistory vX20(0);\nHistory vY20(0);\nHistory vW20(0);\nHistory vG20(1);\nHistory vCc20(1);\nHistory vSn20(0);\nHistory vR20(0.999);\nHistory vBe20(0);\nHistory vBi120(0);\nHistory vBi220(0);\nHistory vBa120(0);\nHistory vBa220(0);\nHistory vBa320(0);\nHistory vBg20(0);\nHistory vX21(0);\nHistory vY21(0);\nHistory vW21(0);\nHistory vG21(1);\nHistory vCc21(1);\nHistory vSn21(0);\nHistory vR21(0.999);\nHistory vBe21(0);\nHistory vBi121(0);\nHistory vBi221(0);\nHistory vBa121(0);\nHistory vBa221(0);\nHistory vBa321(0);\nHistory vBg21(0);\nHistory vX22(0);\nHistory vY22(0);\nHistory vW22(0);\nHistory vG22(1);\nHistory vCc22(1);\nHistory vSn22(0);\nHistory vR22(0.999);\nHistory vBe22(0);\nHistory vBi122(0);\nHistory vBi222(0);\nHistory vBa122(0);\nHistory vBa222(0);\nHistory vBa322(0);\nHistory vBg22(0);\nHistory vX23(0);\nHistory vY23(0);\nHistory vW23(0);\nHistory vG23(1);\nHistory vCc23(1);\nHistory vSn23(0);\nHistory vR23(0.999);\nHistory vBe23(0);\nHistory vBi123(0);\nHistory vBi223(0);\nHistory vBa123(0);\nHistory vBa223(0);\nHistory vBa323(0);\nHistory vBg23(0);\n\ndecayS = decay * 0.01;\nringS = ring * 0.01;\nshellG = shell * 0.02;\nstickT = (stick - 50) * 0.02;\npfT = exp2(mw * press / 12);\nmasterG = dbtoa(volume);\ncnt = cnt + 1; ctl = cnt >= 16; cnt = cnt - ctl * 16;\nif (ctl) { pf = pf + 0.2 * (pfT - pf); }\nnz = noise();\nvh = trg != pt; pt = trg;\nvIm = 0;\nif (vh > 0.5) {\nvds = vh * stroke;                                   // History-derived: the stroke and velocity at the hit\nvdv = vh * vel;\nvk = drum * 6 + vds;\nvg = pow(vdv, 1.4);\nvJs = nz * 1000 + trg; vJv = vary * 0.01;\nvAm = vg * ((abs(vk - 0) < 0.5) * 1.485600 + (abs(vk - 1) < 0.5) * 0.950700 + (abs(vk - 2) < 0.5) * 0.121500 + (abs(vk - 3) < 0.5) * 0.194500 + (abs(vk - 4) < 0.5) * 0.136800 + (abs(vk - 5) < 0.5) * 0.716700 + (abs(vk - 6) < 0.5) * 0.547500 + (abs(vk - 7) < 0.5) * 0.184100 + (abs(vk - 8) < 0.5) * 0.123600 + (abs(vk - 9) < 0.5) * 0.129700 + (abs(vk - 10) < 0.5) * 0.135400 + (abs(vk - 11) < 0.5) * 0.114300);\nvIm = vAm;\nvfc = ((abs(vds - 0) < 0.5) * 2500.000000 + (abs(vds - 1) < 0.5) * 6000.000000 + (abs(vds - 2) < 0.5) * 8000.000000 + (abs(vds - 3) < 0.5) * 6000.000000 + (abs(vds - 4) < 0.5) * 5000.000000 + (abs(vds - 5) < 0.5) * 2000.000000) * exp2(stickT * 1.5 + (vdv - 0.6) * 0.8);\nvK = 1 - exp(-twopi * min(vfc, 18000) / samplerate);\nvC = 1;\nvCk = exp(-16 / (((abs(vds - 0) < 0.5) * 0.050000 + (abs(vds - 1) < 0.5) * 0.060000 + (abs(vds - 2) < 0.5) * 0.030000 + (abs(vds - 3) < 0.5) * 0.150000 + (abs(vds - 4) < 0.5) * 0.500000 + (abs(vds - 5) < 0.5) * 0.500000) * samplerate));\nvNe = vAm * ((abs(vk - 0) < 0.5) * 0.153500 + (abs(vk - 1) < 0.5) * 0.069400 + (abs(vk - 2) < 0.5) * 0.899300 + (abs(vk - 3) < 0.5) * 0.090300 + (abs(vk - 4) < 0.5) * 1.352000 + (abs(vk - 5) < 0.5) * 0.161400 + (abs(vk - 6) < 0.5) * 0.153500 + (abs(vk - 7) < 0.5) * 0.069400 + (abs(vk - 8) < 0.5) * 0.899300 + (abs(vk - 9) < 0.5) * 0.090300 + (abs(vk - 10) < 0.5) * 1.352000 + (abs(vk - 11) < 0.5) * 0.161400) * (1 + stickT);\nvNr = exp(-1 / (((abs(vds - 0) < 0.5) * 0.004000 + (abs(vds - 1) < 0.5) * 0.004000 + (abs(vds - 2) < 0.5) * 0.004000 + (abs(vds - 3) < 0.5) * 0.004000 + (abs(vds - 4) < 0.5) * 0.004000 + (abs(vds - 5) < 0.5) * 0.004000) * samplerate));\nvNg = tan(pi * ((abs(vds - 0) < 0.5) * 2990.000000 + (abs(vds - 1) < 0.5) * 3180.000000 + (abs(vds - 2) < 0.5) * 5620.000000 + (abs(vds - 3) < 0.5) * 2360.000000 + (abs(vds - 4) < 0.5) * 2990.000000 + (abs(vds - 5) < 0.5) * 3140.000000) / samplerate); vNk = 1 / ((abs(vds - 0) < 0.5) * 0.500000 + (abs(vds - 1) < 0.5) * 0.500000 + (abs(vds - 2) < 0.5) * 0.400000 + (abs(vds - 3) < 0.5) * 0.500000 + (abs(vds - 4) < 0.5) * 0.500000 + (abs(vds - 5) < 0.5) * 0.500000);\nvNa1 = 1 / (1 + vNg * (vNg + vNk)); vNa2 = vNg * vNa1; vNa3 = vNg * vNa2;\nvW0 = ((abs(vk - 0) < 0.5) * 0.175792 + (abs(vk - 1) < 0.5) * 0.090157 + (abs(vk - 2) < 0.5) * 0.035075 + (abs(vk - 3) < 0.5) * 0.113501 + (abs(vk - 4) < 0.5) * 0.146218 + (abs(vk - 5) < 0.5) * 0.073282 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 0.732825 + (abs(vk - 8) < 0.5) * 0.027861 + (abs(vk - 9) < 0.5) * 1.000000 + (abs(vk - 10) < 0.5) * 0.144544 + (abs(vk - 11) < 0.5) * 0.575440) * exp(0.299115 * vJv * (fract(sin(vJs + 0.0) * 43758.5453) * 2 - 1)); vG0 = (abs(vk - 0) < 0.5) * 2.090000 + (abs(vk - 1) < 0.5) * 1.870000 + (abs(vk - 2) < 0.5) * 0.450000 + (abs(vk - 3) < 0.5) * 2.080000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 2.470000 + (abs(vk - 6) < 0.5) * 8.540000 + (abs(vk - 7) < 0.5) * 6.760000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 10.000000 + (abs(vk - 10) < 0.5) * 9.000000 + (abs(vk - 11) < 0.5) * 8.390000;\nvW1 = ((abs(vk - 0) < 0.5) * 0.027542 + (abs(vk - 1) < 0.5) * 0.158489 + (abs(vk - 2) < 0.5) * 0.028510 + (abs(vk - 3) < 0.5) * 0.153109 + (abs(vk - 4) < 0.5) * 0.134896 + (abs(vk - 5) < 0.5) * 0.064565 + (abs(vk - 6) < 0.5) * 0.109648 + (abs(vk - 7) < 0.5) * 0.595662 + (abs(vk - 8) < 0.5) * 0.038905 + (abs(vk - 9) < 0.5) * 0.716143 + (abs(vk - 10) < 0.5) * 0.197242 + (abs(vk - 11) < 0.5) * 1.000000) * exp(0.299115 * vJv * (fract(sin(vJs + 78.233) * 43758.5453) * 2 - 1)); vG1 = (abs(vk - 0) < 0.5) * 0.400000 + (abs(vk - 1) < 0.5) * 1.320000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 4.650000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 3.900000 + (abs(vk - 6) < 0.5) * 10.000000 + (abs(vk - 7) < 0.5) * 1.000000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 10.000000 + (abs(vk - 10) < 0.5) * 9.000000 + (abs(vk - 11) < 0.5) * 10.000000;\nvW2 = ((abs(vk - 0) < 0.5) * 0.000299 + (abs(vk - 1) < 0.5) * 0.266073 + (abs(vk - 2) < 0.5) * 0.000327 + (abs(vk - 3) < 0.5) * 0.005070 + (abs(vk - 4) < 0.5) * 0.113501 + (abs(vk - 5) < 0.5) * 0.000320 + (abs(vk - 6) < 0.5) * 0.000299 + (abs(vk - 7) < 0.5) * 1.000000 + (abs(vk - 8) < 0.5) * 0.028510 + (abs(vk - 9) < 0.5) * 0.582103 + (abs(vk - 10) < 0.5) * 0.175792 + (abs(vk - 11) < 0.5) * 0.707946) * exp(0.299115 * vJv * (fract(sin(vJs + 156.466) * 43758.5453) * 2 - 1)); vG2 = (abs(vk - 0) < 0.5) * 8.500000 + (abs(vk - 1) < 0.5) * 8.950000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.170000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 2.830000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 10.000000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 10.000000 + (abs(vk - 10) < 0.5) * 9.000000 + (abs(vk - 11) < 0.5) * 10.000000;\nvW3 = ((abs(vk - 0) < 0.5) * 0.049545 + (abs(vk - 1) < 0.5) * 0.108393 + (abs(vk - 2) < 0.5) * 0.053088 + (abs(vk - 3) < 0.5) * 0.002317 + (abs(vk - 4) < 0.5) * 0.068391 + (abs(vk - 5) < 0.5) * 0.030549 + (abs(vk - 6) < 0.5) * 0.088105 + (abs(vk - 7) < 0.5) * 0.431519 + (abs(vk - 8) < 0.5) * 0.001479 + (abs(vk - 9) < 0.5) * 0.231739 + (abs(vk - 10) < 0.5) * 0.048978 + (abs(vk - 11) < 0.5) * 0.188365) * exp(0.299115 * vJv * (fract(sin(vJs + 234.699) * 43758.5453) * 2 - 1)); vG3 = (abs(vk - 0) < 0.5) * 6.710000 + (abs(vk - 1) < 0.5) * 5.540000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.670000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 2.400000 + (abs(vk - 6) < 0.5) * 10.000000 + (abs(vk - 7) < 0.5) * 5.330000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 10.000000 + (abs(vk - 10) < 0.5) * 9.000000 + (abs(vk - 11) < 0.5) * 7.370000;\nvW4 = ((abs(vk - 0) < 0.5) * 0.049545 + (abs(vk - 1) < 0.5) * 0.033113 + (abs(vk - 2) < 0.5) * 0.008511 + (abs(vk - 3) < 0.5) * 0.057544 + (abs(vk - 4) < 0.5) * 0.085114 + (abs(vk - 5) < 0.5) * 0.013964 + (abs(vk - 6) < 0.5) * 0.081283 + (abs(vk - 7) < 0.5) * 0.691831 + (abs(vk - 8) < 0.5) * 0.024831 + (abs(vk - 9) < 0.5) * 0.158489 + (abs(vk - 10) < 0.5) * 0.100000 + (abs(vk - 11) < 0.5) * 0.380189) * exp(0.299115 * vJv * (fract(sin(vJs + 312.932) * 43758.5453) * 2 - 1)); vG4 = (abs(vk - 0) < 0.5) * 5.120000 + (abs(vk - 1) < 0.5) * 1.240000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.510000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 1.880000 + (abs(vk - 6) < 0.5) * 10.000000 + (abs(vk - 7) < 0.5) * 10.000000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 8.900000 + (abs(vk - 10) < 0.5) * 9.000000 + (abs(vk - 11) < 0.5) * 7.930000;\nvW5 = ((abs(vk - 0) < 0.5) * 0.019498 + (abs(vk - 1) < 0.5) * 0.022387 + (abs(vk - 2) < 0.5) * 0.065313 + (abs(vk - 3) < 0.5) * 0.138038 + (abs(vk - 4) < 0.5) * 0.160325 + (abs(vk - 5) < 0.5) * 0.019498 + (abs(vk - 6) < 0.5) * 0.071614 + (abs(vk - 7) < 0.5) * 0.285102 + (abs(vk - 8) < 0.5) * 0.027542 + (abs(vk - 9) < 0.5) * 0.098855 + (abs(vk - 10) < 0.5) * 0.164059 + (abs(vk - 11) < 0.5) * 0.072444) * exp(0.299115 * vJv * (fract(sin(vJs + 391.165) * 43758.5453) * 2 - 1)); vG5 = (abs(vk - 0) < 0.5) * 1.830000 + (abs(vk - 1) < 0.5) * 0.400000 + (abs(vk - 2) < 0.5) * 2.790000 + (abs(vk - 3) < 0.5) * 2.160000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 1.570000 + (abs(vk - 6) < 0.5) * 8.260000 + (abs(vk - 7) < 0.5) * 7.770000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 6.420000 + (abs(vk - 10) < 0.5) * 9.000000 + (abs(vk - 11) < 0.5) * 4.510000;\nvW6 = ((abs(vk - 0) < 0.5) * 0.015136 + (abs(vk - 1) < 0.5) * 0.012735 + (abs(vk - 2) < 0.5) * 0.036308 + (abs(vk - 3) < 0.5) * 0.060954 + (abs(vk - 4) < 0.5) * 0.127350 + (abs(vk - 5) < 0.5) * 0.017989 + (abs(vk - 6) < 0.5) * 0.065313 + (abs(vk - 7) < 0.5) * 0.000324 + (abs(vk - 8) < 0.5) * 0.029854 + (abs(vk - 9) < 0.5) * 0.281838 + (abs(vk - 10) < 0.5) * 0.070795 + (abs(vk - 11) < 0.5) * 0.014622) * exp(0.299115 * vJv * (fract(sin(vJs + 469.398) * 43758.5453) * 2 - 1)); vG6 = (abs(vk - 0) < 0.5) * 1.920000 + (abs(vk - 1) < 0.5) * 0.730000 + (abs(vk - 2) < 0.5) * 0.400000 + (abs(vk - 3) < 0.5) * 1.390000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 1.420000 + (abs(vk - 6) < 0.5) * 8.970000 + (abs(vk - 7) < 0.5) * 0.400000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 9.230000 + (abs(vk - 10) < 0.5) * 9.000000 + (abs(vk - 11) < 0.5) * 10.000000;\nvW7 = ((abs(vk - 0) < 0.5) * 0.016982 + (abs(vk - 1) < 0.5) * 0.023174 + (abs(vk - 2) < 0.5) * 0.105925 + (abs(vk - 3) < 0.5) * 0.218776 + (abs(vk - 4) < 0.5) * 0.116145 + (abs(vk - 5) < 0.5) * 0.019275 + (abs(vk - 6) < 0.5) * 0.015311 + (abs(vk - 7) < 0.5) * 0.211349 + (abs(vk - 8) < 0.5) * 0.009661 + (abs(vk - 9) < 0.5) * 0.375837 + (abs(vk - 10) < 0.5) * 0.131826 + (abs(vk - 11) < 0.5) * 0.169824) * exp(0.299115 * vJv * (fract(sin(vJs + 547.6310000000001) * 43758.5453) * 2 - 1)); vG7 = (abs(vk - 0) < 0.5) * 1.460000 + (abs(vk - 1) < 0.5) * 0.400000 + (abs(vk - 2) < 0.5) * 2.360000 + (abs(vk - 3) < 0.5) * 1.960000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 1.250000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 4.850000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 6.970000 + (abs(vk - 10) < 0.5) * 9.000000 + (abs(vk - 11) < 0.5) * 4.500000;\nvW8 = ((abs(vk - 0) < 0.5) * 0.072444 + (abs(vk - 1) < 0.5) * 0.000324 + (abs(vk - 2) < 0.5) * 0.025704 + (abs(vk - 3) < 0.5) * 0.134896 + (abs(vk - 4) < 0.5) * 0.000309 + (abs(vk - 5) < 0.5) * 0.066834 + (abs(vk - 6) < 0.5) * 0.114815 + (abs(vk - 7) < 0.5) * 0.588844 + (abs(vk - 8) < 0.5) * 0.013183 + (abs(vk - 9) < 0.5) * 0.251189 + (abs(vk - 10) < 0.5) * 0.077625 + (abs(vk - 11) < 0.5) * 0.346737) * shellG * exp(0.299115 * vJv * (fract(sin(vJs + 625.864) * 43758.5453) * 2 - 1)); vG8 = (abs(vk - 0) < 0.5) * 7.590000 + (abs(vk - 1) < 0.5) * 0.400000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 4.460000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 3.580000 + (abs(vk - 6) < 0.5) * 10.000000 + (abs(vk - 7) < 0.5) * 10.000000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 10.000000 + (abs(vk - 10) < 0.5) * 5.400000 + (abs(vk - 11) < 0.5) * 7.630000;\nvW9 = ((abs(vk - 0) < 0.5) * 0.031261 + (abs(vk - 1) < 0.5) * 0.037154 + (abs(vk - 2) < 0.5) * 0.020654 + (abs(vk - 3) < 0.5) * 0.071614 + (abs(vk - 4) < 0.5) * 0.025704 + (abs(vk - 5) < 0.5) * 0.069183 + (abs(vk - 6) < 0.5) * 0.019953 + (abs(vk - 7) < 0.5) * 0.260016 + (abs(vk - 8) < 0.5) * 0.021380 + (abs(vk - 9) < 0.5) * 0.102329 + (abs(vk - 10) < 0.5) * 0.000309 + (abs(vk - 11) < 0.5) * 0.177828) * shellG * exp(0.299115 * vJv * (fract(sin(vJs + 704.097) * 43758.5453) * 2 - 1)); vG9 = (abs(vk - 0) < 0.5) * 6.640000 + (abs(vk - 1) < 0.5) * 1.760000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 4.120000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 3.640000 + (abs(vk - 6) < 0.5) * 1.090000 + (abs(vk - 7) < 0.5) * 7.670000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 8.160000 + (abs(vk - 10) < 0.5) * 5.400000 + (abs(vk - 11) < 0.5) * 7.160000;\nvW10 = ((abs(vk - 0) < 0.5) * 0.028510 + (abs(vk - 1) < 0.5) * 0.156675 + (abs(vk - 2) < 0.5) * 0.038019 + (abs(vk - 3) < 0.5) * 0.254097 + (abs(vk - 4) < 0.5) * 0.051880 + (abs(vk - 5) < 0.5) * 0.083176 + (abs(vk - 6) < 0.5) * 0.094406 + (abs(vk - 7) < 0.5) * 0.462381 + (abs(vk - 8) < 0.5) * 0.043152 + (abs(vk - 9) < 0.5) * 0.242661 + (abs(vk - 10) < 0.5) * 0.047315 + (abs(vk - 11) < 0.5) * 0.120226) * shellG * exp(0.299115 * vJv * (fract(sin(vJs + 782.33) * 43758.5453) * 2 - 1)); vG10 = (abs(vk - 0) < 0.5) * 9.590000 + (abs(vk - 1) < 0.5) * 8.040000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 6.000000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 4.960000 + (abs(vk - 6) < 0.5) * 10.000000 + (abs(vk - 7) < 0.5) * 9.620000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 10.000000 + (abs(vk - 10) < 0.5) * 5.400000 + (abs(vk - 11) < 0.5) * 6.190000;\nvW11 = ((abs(vk - 0) < 0.5) * 0.016596 + (abs(vk - 1) < 0.5) * 0.040272 + (abs(vk - 2) < 0.5) * 0.001479 + (abs(vk - 3) < 0.5) * 0.226464 + (abs(vk - 4) < 0.5) * 0.053703 + (abs(vk - 5) < 0.5) * 0.032734 + (abs(vk - 6) < 0.5) * 0.000299 + (abs(vk - 7) < 0.5) * 0.295121 + (abs(vk - 8) < 0.5) * 0.000339 + (abs(vk - 9) < 0.5) * 0.027227 + (abs(vk - 10) < 0.5) * 0.035075 + (abs(vk - 11) < 0.5) * 0.074989) * shellG * exp(0.299115 * vJv * (fract(sin(vJs + 860.5630000000001) * 43758.5453) * 2 - 1)); vG11 = (abs(vk - 0) < 0.5) * 7.980000 + (abs(vk - 1) < 0.5) * 1.950000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 5.070000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 3.750000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 7.920000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 4.430000 + (abs(vk - 10) < 0.5) * 5.400000 + (abs(vk - 11) < 0.5) * 4.060000;\nvW12 = ((abs(vk - 0) < 0.5) * 0.000299 + (abs(vk - 1) < 0.5) * 0.017579 + (abs(vk - 2) < 0.5) * 0.000327 + (abs(vk - 3) < 0.5) * 0.537032 + (abs(vk - 4) < 0.5) * 0.056234 + (abs(vk - 5) < 0.5) * 0.014454 + (abs(vk - 6) < 0.5) * 0.022131 + (abs(vk - 7) < 0.5) * 0.242661 + (abs(vk - 8) < 0.5) * 0.016596 + (abs(vk - 9) < 0.5) * 0.393550 + (abs(vk - 10) < 0.5) * 0.094406 + (abs(vk - 11) < 0.5) * 0.153109) * shellG * exp(0.299115 * vJv * (fract(sin(vJs + 938.796) * 43758.5453) * 2 - 1)); vG12 = (abs(vk - 0) < 0.5) * 2.520000 + (abs(vk - 1) < 0.5) * 2.990000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 6.070000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 3.240000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 6.740000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 10.000000 + (abs(vk - 10) < 0.5) * 5.400000 + (abs(vk - 11) < 0.5) * 7.240000;\nvW13 = ((abs(vk - 0) < 0.5) * 0.017179 + (abs(vk - 1) < 0.5) * 0.050699 + (abs(vk - 2) < 0.5) * 0.027542 + (abs(vk - 3) < 0.5) * 0.350752 + (abs(vk - 4) < 0.5) * 0.048978 + (abs(vk - 5) < 0.5) * 0.017179 + (abs(vk - 6) < 0.5) * 0.029512 + (abs(vk - 7) < 0.5) * 0.201837 + (abs(vk - 8) < 0.5) * 0.013964 + (abs(vk - 9) < 0.5) * 0.266073 + (abs(vk - 10) < 0.5) * 0.069183 + (abs(vk - 11) < 0.5) * 0.164059) * shellG * exp(0.299115 * vJv * (fract(sin(vJs + 1017.029) * 43758.5453) * 2 - 1)); vG13 = (abs(vk - 0) < 0.5) * 7.780000 + (abs(vk - 1) < 0.5) * 6.310000 + (abs(vk - 2) < 0.5) * 6.210000 + (abs(vk - 3) < 0.5) * 5.640000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 3.300000 + (abs(vk - 6) < 0.5) * 3.930000 + (abs(vk - 7) < 0.5) * 6.570000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 9.700000 + (abs(vk - 10) < 0.5) * 5.400000 + (abs(vk - 11) < 0.5) * 6.620000;\nvW14 = ((abs(vk - 0) < 0.5) * 0.000977 + (abs(vk - 1) < 0.5) * 0.017179 + (abs(vk - 2) < 0.5) * 0.029854 + (abs(vk - 3) < 0.5) * 0.076736 + (abs(vk - 4) < 0.5) * 0.000309 + (abs(vk - 5) < 0.5) * 0.020417 + (abs(vk - 6) < 0.5) * 0.056234 + (abs(vk - 7) < 0.5) * 0.242661 + (abs(vk - 8) < 0.5) * 0.136458 + (abs(vk - 9) < 0.5) * 0.285102 + (abs(vk - 10) < 0.5) * 0.060954 + (abs(vk - 11) < 0.5) * 0.338844) * shellG * exp(0.299115 * vJv * (fract(sin(vJs + 1095.2620000000002) * 43758.5453) * 2 - 1)); vG14 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 3.360000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 4.090000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 3.300000 + (abs(vk - 6) < 0.5) * 8.870000 + (abs(vk - 7) < 0.5) * 5.830000 + (abs(vk - 8) < 0.5) * 10.000000 + (abs(vk - 9) < 0.5) * 10.000000 + (abs(vk - 10) < 0.5) * 5.400000 + (abs(vk - 11) < 0.5) * 7.560000;\nvW15 = ((abs(vk - 0) < 0.5) * 0.028510 + (abs(vk - 1) < 0.5) * 0.024831 + (abs(vk - 2) < 0.5) * 0.006310 + (abs(vk - 3) < 0.5) * 0.060256 + (abs(vk - 4) < 0.5) * 0.070795 + (abs(vk - 5) < 0.5) * 0.030903 + (abs(vk - 6) < 0.5) * 0.022131 + (abs(vk - 7) < 0.5) * 0.242661 + (abs(vk - 8) < 0.5) * 0.060954 + (abs(vk - 9) < 0.5) * 0.201837 + (abs(vk - 10) < 0.5) * 0.071614 + (abs(vk - 11) < 0.5) * 0.473151) * shellG * exp(0.299115 * vJv * (fract(sin(vJs + 1173.4950000000001) * 43758.5453) * 2 - 1)); vG15 = (abs(vk - 0) < 0.5) * 8.770000 + (abs(vk - 1) < 0.5) * 1.160000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 3.850000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 4.020000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 7.720000 + (abs(vk - 8) < 0.5) * 10.000000 + (abs(vk - 9) < 0.5) * 10.000000 + (abs(vk - 10) < 0.5) * 5.400000 + (abs(vk - 11) < 0.5) * 9.380000;\nvW16 = ((abs(vk - 0) < 0.5) * 0.012162 + (abs(vk - 1) < 0.5) * 0.020893 + (abs(vk - 2) < 0.5) * 0.009661 + (abs(vk - 3) < 0.5) * 0.045709 + (abs(vk - 4) < 0.5) * 0.085114 + (abs(vk - 5) < 0.5) * 0.019275 + (abs(vk - 6) < 0.5) * 0.050699 + (abs(vk - 7) < 0.5) * 0.263027 + (abs(vk - 8) < 0.5) * 0.186209 + (abs(vk - 9) < 0.5) * 0.275423 + (abs(vk - 10) < 0.5) * 0.091201 + (abs(vk - 11) < 0.5) * 0.319890) * shellG * exp(0.299115 * vJv * (fract(sin(vJs + 1251.728) * 43758.5453) * 2 - 1)); vG16 = (abs(vk - 0) < 0.5) * 6.670000 + (abs(vk - 1) < 0.5) * 3.430000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 3.490000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 3.420000 + (abs(vk - 6) < 0.5) * 10.000000 + (abs(vk - 7) < 0.5) * 8.530000 + (abs(vk - 8) < 0.5) * 10.000000 + (abs(vk - 9) < 0.5) * 10.000000 + (abs(vk - 10) < 0.5) * 5.400000 + (abs(vk - 11) < 0.5) * 10.000000;\nvW17 = ((abs(vk - 0) < 0.5) * 0.026915 + (abs(vk - 1) < 0.5) * 0.029854 + (abs(vk - 2) < 0.5) * 0.054325 + (abs(vk - 3) < 0.5) * 0.645654 + (abs(vk - 4) < 0.5) * 0.263027 + (abs(vk - 5) < 0.5) * 0.022131 + (abs(vk - 6) < 0.5) * 0.064565 + (abs(vk - 7) < 0.5) * 0.327341 + (abs(vk - 8) < 0.5) * 0.089125 + (abs(vk - 9) < 0.5) * 0.758578 + (abs(vk - 10) < 0.5) * 0.237137 + (abs(vk - 11) < 0.5) * 0.237137) * shellG * exp(0.299115 * vJv * (fract(sin(vJs + 1329.961) * 43758.5453) * 2 - 1)); vG17 = (abs(vk - 0) < 0.5) * 6.340000 + (abs(vk - 1) < 0.5) * 2.690000 + (abs(vk - 2) < 0.5) * 6.540000 + (abs(vk - 3) < 0.5) * 5.370000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 3.090000 + (abs(vk - 6) < 0.5) * 10.000000 + (abs(vk - 7) < 0.5) * 9.130000 + (abs(vk - 8) < 0.5) * 10.000000 + (abs(vk - 9) < 0.5) * 10.000000 + (abs(vk - 10) < 0.5) * 5.400000 + (abs(vk - 11) < 0.5) * 10.000000;\nvW18 = ((abs(vk - 0) < 0.5) * 0.030903 + (abs(vk - 1) < 0.5) * 0.022646 + (abs(vk - 2) < 0.5) * 0.063826 + (abs(vk - 3) < 0.5) * 0.144544 + (abs(vk - 4) < 0.5) * 0.190546 + (abs(vk - 5) < 0.5) * 0.019055 + (abs(vk - 6) < 0.5) * 0.064565 + (abs(vk - 7) < 0.5) * 0.160325 + (abs(vk - 8) < 0.5) * 0.375837 + (abs(vk - 9) < 0.5) * 0.384592 + (abs(vk - 10) < 0.5) * 0.167880 + (abs(vk - 11) < 0.5) * 0.298538) * shellG * exp(0.299115 * vJv * (fract(sin(vJs + 1408.194) * 43758.5453) * 2 - 1)); vG18 = (abs(vk - 0) < 0.5) * 2.840000 + (abs(vk - 1) < 0.5) * 0.400000 + (abs(vk - 2) < 0.5) * 1.130000 + (abs(vk - 3) < 0.5) * 2.350000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 1.480000 + (abs(vk - 6) < 0.5) * 6.720000 + (abs(vk - 7) < 0.5) * 4.280000 + (abs(vk - 8) < 0.5) * 10.000000 + (abs(vk - 9) < 0.5) * 10.000000 + (abs(vk - 10) < 0.5) * 5.400000 + (abs(vk - 11) < 0.5) * 10.000000;\nvW19 = ((abs(vk - 0) < 0.5) * 0.009661 + (abs(vk - 1) < 0.5) * 0.001084 + (abs(vk - 2) < 0.5) * 0.001531 + (abs(vk - 3) < 0.5) * 0.064565 + (abs(vk - 4) < 0.5) * 0.342768 + (abs(vk - 5) < 0.5) * 0.027542 + (abs(vk - 6) < 0.5) * 0.023174 + (abs(vk - 7) < 0.5) * 0.081283 + (abs(vk - 8) < 0.5) * 0.005821 + (abs(vk - 9) < 0.5) * 0.208930 + (abs(vk - 10) < 0.5) * 0.301995 + (abs(vk - 11) < 0.5) * 0.291743) * shellG; vG19 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.000000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 1.000000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 1.000000 + (abs(vk - 10) < 0.5) * 5.400000 + (abs(vk - 11) < 0.5) * 1.000000;\nvW20 = ((abs(vk - 0) < 0.5) * 0.042170 + (abs(vk - 1) < 0.5) * 0.097724 + (abs(vk - 2) < 0.5) * 0.398107 + (abs(vk - 3) < 0.5) * 0.278612 + (abs(vk - 4) < 0.5) * 1.000000 + (abs(vk - 5) < 0.5) * 0.038905 + (abs(vk - 6) < 0.5) * 0.138038 + (abs(vk - 7) < 0.5) * 0.441570 + (abs(vk - 8) < 0.5) * 0.380189 + (abs(vk - 9) < 0.5) * 0.164059 + (abs(vk - 10) < 0.5) * 0.881049 + (abs(vk - 11) < 0.5) * 0.254097) * shellG; vG20 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.000000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 1.000000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 1.000000 + (abs(vk - 10) < 0.5) * 5.400000 + (abs(vk - 11) < 0.5) * 1.000000;\nvW21 = ((abs(vk - 0) < 0.5) * 0.024547 + (abs(vk - 1) < 0.5) * 0.015311 + (abs(vk - 2) < 0.5) * 0.305492 + (abs(vk - 3) < 0.5) * 0.048417 + (abs(vk - 4) < 0.5) * 0.138038 + (abs(vk - 5) < 0.5) * 0.039355 + (abs(vk - 6) < 0.5) * 0.002917 + (abs(vk - 7) < 0.5) * 0.000484 + (abs(vk - 8) < 0.5) * 0.305492 + (abs(vk - 9) < 0.5) * 0.002317 + (abs(vk - 10) < 0.5) * 0.123027 + (abs(vk - 11) < 0.5) * 0.020893) * shellG; vG21 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.000000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 1.000000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 1.000000 + (abs(vk - 10) < 0.5) * 5.400000 + (abs(vk - 11) < 0.5) * 1.000000;\nvW22 = ((abs(vk - 0) < 0.5) * 0.001189 + (abs(vk - 1) < 0.5) * 0.017989 + (abs(vk - 2) < 0.5) * 0.676083 + (abs(vk - 3) < 0.5) * 0.208930 + (abs(vk - 4) < 0.5) * 0.051286 + (abs(vk - 5) < 0.5) * 0.051880 + (abs(vk - 6) < 0.5) * 0.003715 + (abs(vk - 7) < 0.5) * 0.001303 + (abs(vk - 8) < 0.5) * 0.412098 + (abs(vk - 9) < 0.5) * 0.125893 + (abs(vk - 10) < 0.5) * 0.042170 + (abs(vk - 11) < 0.5) * 0.160325) * shellG; vG22 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.000000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 1.000000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 1.000000 + (abs(vk - 10) < 0.5) * 5.400000 + (abs(vk - 11) < 0.5) * 1.000000;\nvW23 = ((abs(vk - 0) < 0.5) * 0.000299 + (abs(vk - 1) < 0.5) * 0.000324 + (abs(vk - 2) < 0.5) * 0.785236 + (abs(vk - 3) < 0.5) * 0.013964 + (abs(vk - 4) < 0.5) * 0.000309 + (abs(vk - 5) < 0.5) * 0.007943 + (abs(vk - 6) < 0.5) * 0.000299 + (abs(vk - 7) < 0.5) * 0.000422 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 0.037584 + (abs(vk - 10) < 0.5) * 0.000309 + (abs(vk - 11) < 0.5) * 0.005689) * shellG; vG23 = (abs(vk - 0) < 0.5) * 1.000000 + (abs(vk - 1) < 0.5) * 1.000000 + (abs(vk - 2) < 0.5) * 1.000000 + (abs(vk - 3) < 0.5) * 1.000000 + (abs(vk - 4) < 0.5) * 3.000000 + (abs(vk - 5) < 0.5) * 1.000000 + (abs(vk - 6) < 0.5) * 1.000000 + (abs(vk - 7) < 0.5) * 1.000000 + (abs(vk - 8) < 0.5) * 1.000000 + (abs(vk - 9) < 0.5) * 1.000000 + (abs(vk - 10) < 0.5) * 5.400000 + (abs(vk - 11) < 0.5) * 1.000000;\nvkh = (abs(vds - 0) < 0.5) * 0.850000 + (abs(vds - 1) < 0.5) * 0.800000 + (abs(vds - 2) < 0.5) * 0.970000 + (abs(vds - 3) < 0.5) * 0.950000 + (abs(vds - 4) < 0.5) * 0.300000 + (abs(vds - 5) < 0.5) * 0.100000; vks = (abs(vds - 0) < 0.5) * 0.900000 + (abs(vds - 1) < 0.5) * 0.700000 + (abs(vds - 2) < 0.5) * 0.500000 + (abs(vds - 3) < 0.5) * 0.400000 + (abs(vds - 4) < 0.5) * 0.700000 + (abs(vds - 5) < 0.5) * 0.800000;\nvX0 = vX0 * vkh; vY0 = vY0 * vkh;\nvX1 = vX1 * vkh; vY1 = vY1 * vkh;\nvX2 = vX2 * vkh; vY2 = vY2 * vkh;\nvX3 = vX3 * vkh; vY3 = vY3 * vkh;\nvX4 = vX4 * vkh; vY4 = vY4 * vkh;\nvX5 = vX5 * vkh; vY5 = vY5 * vkh;\nvX6 = vX6 * vkh; vY6 = vY6 * vkh;\nvX7 = vX7 * vkh; vY7 = vY7 * vkh;\nvX8 = vX8 * vks; vY8 = vY8 * vks;\nvX9 = vX9 * vks; vY9 = vY9 * vks;\nvX10 = vX10 * vks; vY10 = vY10 * vks;\nvX11 = vX11 * vks; vY11 = vY11 * vks;\nvX12 = vX12 * vks; vY12 = vY12 * vks;\nvX13 = vX13 * vks; vY13 = vY13 * vks;\nvX14 = vX14 * vks; vY14 = vY14 * vks;\nvX15 = vX15 * vks; vY15 = vY15 * vks;\nvX16 = vX16 * vks; vY16 = vY16 * vks;\nvX17 = vX17 * vks; vY17 = vY17 * vks;\nvX18 = vX18 * vks; vY18 = vY18 * vks;\nvBe19 = vBe19 * vks; vBg19 = vW19 * 5.0 / (1 + 6723649 / (vfc * vfc));\nvBe20 = vBe20 * vks; vBg20 = vW20 * 5.0 / (1 + 11560000 / (vfc * vfc));\nvBe21 = vBe21 * vks; vBg21 = vW21 * 5.0 / (1 + 20250000 / (vfc * vfc));\nvBe22 = vBe22 * vks; vBg22 = vW22 * 5.0 / (1 + 42706225 / (vfc * vfc));\nvBe23 = vBe23 * vks; vBg23 = vW23 * 5.0 / (1 + 75690000 / (vfc * vfc));\n}\nvE1 = vE1 + vK * (vIm - vE1); vE2 = vE2 + vK * (vE1 - vE2);\nif (ctl) {\nvC = vC * vCk;\nvF1 = ((abs(drum - 0) < 0.5) * 200.000000 + (abs(drum - 1) < 0.5) * 120.000000) * exp2(tune / 12);\nvTd = (abs(drum - 0) < 0.5) * 1.000000 + (abs(drum - 1) < 0.5) * 3.000000;\nvTs = (abs(drum - 0) < 0.5) * 1.000000 + (abs(drum - 1) < 0.5) * 1.800000;\nvw = twopi * vF1 * pf * 1.0 / samplerate; vCc0 = cos(vw); vSn0 = sin(vw); vR0 = exp(-13.815511 * (1 + (vG0 - 1) * vC) / (decayS * vTd * samplerate));\nvw = twopi * vF1 * pf * 1.94 / samplerate; vCc1 = cos(vw); vSn1 = sin(vw); vR1 = exp(-7.675284 * (1 + (vG1 - 1) * vC) / (decayS * vTd * samplerate));\nvw = twopi * vF1 * pf * 2.15 / samplerate; vCc2 = cos(vw); vSn2 = sin(vw); vR2 = exp(-7.675284 * (1 + (vG2 - 1) * vC) / (decayS * vTd * samplerate));\nvw = twopi * vF1 * pf * 3.15 / samplerate; vCc3 = cos(vw); vSn3 = sin(vw); vR3 = exp(-9.868222 * (1 + (vG3 - 1) * vC) / (decayS * vTd * samplerate));\nvw = twopi * vF1 * pf * 4.15 / samplerate; vCc4 = cos(vw); vSn4 = sin(vw); vR4 = exp(-11.512925 * (1 + (vG4 - 1) * vC) / (decayS * vTd * samplerate));\nvw = twopi * vF1 * pf * 5.15 / samplerate; vCc5 = cos(vw); vSn5 = sin(vw); vR5 = exp(-13.815511 * (1 + (vG5 - 1) * vC) / (decayS * vTd * samplerate));\nvw = twopi * vF1 * pf * 6.0 / samplerate; vCc6 = cos(vw); vSn6 = sin(vw); vR6 = exp(-15.350567 * (1 + (vG6 - 1) * vC) / (decayS * vTd * samplerate));\nvw = twopi * vF1 * pf * 7.0 / samplerate; vCc7 = cos(vw); vSn7 = sin(vw); vR7 = exp(-17.269388 * (1 + (vG7 - 1) * vC) / (decayS * vTd * samplerate));\nvw = twopi * 432 / samplerate; vCc8 = cos(vw); vSn8 = sin(vw); vR8 = exp(-6.907755 * (1 + (vG8 - 1) * vC) / (ringS * vTs * samplerate));\nvw = twopi * 577 / samplerate; vCc9 = cos(vw); vSn9 = sin(vw); vR9 = exp(-6.907755 * (1 + (vG9 - 1) * vC) / (ringS * vTs * samplerate));\nvw = twopi * 650 / samplerate; vCc10 = cos(vw); vSn10 = sin(vw); vR10 = exp(-6.907755 * (1 + (vG10 - 1) * vC) / (ringS * vTs * samplerate));\nvw = twopi * 720 / samplerate; vCc11 = cos(vw); vSn11 = sin(vw); vR11 = exp(-6.907755 * (1 + (vG11 - 1) * vC) / (ringS * vTs * samplerate));\nvw = twopi * 816 / samplerate; vCc12 = cos(vw); vSn12 = sin(vw); vR12 = exp(-6.907755 * (1 + (vG12 - 1) * vC) / (ringS * vTs * samplerate));\nvw = twopi * 920 / samplerate; vCc13 = cos(vw); vSn13 = sin(vw); vR13 = exp(-6.907755 * (1 + (vG13 - 1) * vC) / (ringS * vTs * samplerate));\nvw = twopi * 1090 / samplerate; vCc14 = cos(vw); vSn14 = sin(vw); vR14 = exp(-6.907755 * (1 + (vG14 - 1) * vC) / (ringS * vTs * samplerate));\nvw = twopi * 1155 / samplerate; vCc15 = cos(vw); vSn15 = sin(vw); vR15 = exp(-6.907755 * (1 + (vG15 - 1) * vC) / (ringS * vTs * samplerate));\nvw = twopi * 1330 / samplerate; vCc16 = cos(vw); vSn16 = sin(vw); vR16 = exp(-6.907755 * (1 + (vG16 - 1) * vC) / (ringS * vTs * samplerate));\nvw = twopi * 1633 / samplerate; vCc17 = cos(vw); vSn17 = sin(vw); vR17 = exp(-7.675284 * (1 + (vG17 - 1) * vC) / (ringS * vTs * samplerate));\nvw = twopi * 2100 / samplerate; vCc18 = cos(vw); vSn18 = sin(vw); vR18 = exp(-13.815511 * (1 + (vG18 - 1) * vC) / (ringS * vTs * samplerate));\nvBg = tan(pi * 2593 / samplerate); vBa119 = 1 / (1 + vBg * (vBg + 0.500000)); vBa219 = vBg * vBa119; vBa319 = vBg * vBa219; vR19 = exp(-19.736444 * (1 + (vG19 - 1) * vC) / (ringS * vTs * samplerate));\nvBg = tan(pi * 3400 / samplerate); vBa120 = 1 / (1 + vBg * (vBg + 0.500000)); vBa220 = vBg * vBa120; vBa320 = vBg * vBa220; vR20 = exp(-27.631021 * (1 + (vG20 - 1) * vC) / (ringS * vTs * samplerate));\nvBg = tan(pi * 4500 / samplerate); vBa121 = 1 / (1 + vBg * (vBg + 0.500000)); vBa221 = vBg * vBa121; vBa321 = vBg * vBa221; vR21 = exp(-38.376418 * (1 + (vG21 - 1) * vC) / (ringS * vTs * samplerate));\nvBg = tan(pi * 6535 / samplerate); vBa122 = 1 / (1 + vBg * (vBg + 0.500000)); vBa222 = vBg * vBa122; vBa322 = vBg * vBa222; vR22 = exp(-49.341109 * (1 + (vG22 - 1) * vC) / (ringS * vTs * samplerate));\nvBg = tan(pi * 8700 / samplerate); vBa123 = 1 / (1 + vBg * (vBg + 0.500000)); vBa223 = vBg * vBa123; vBa323 = vBg * vBa223; vR23 = exp(-69.077553 * (1 + (vG23 - 1) * vC) / (ringS * vTs * samplerate));\n}\nvXn = vR0 * (vCc0 * vX0 - vSn0 * vY0) + vW0 * vE2; vY0 = vR0 * (vSn0 * vX0 + vCc0 * vY0); vX0 = vXn;\nvXn = vR1 * (vCc1 * vX1 - vSn1 * vY1) + vW1 * vE2; vY1 = vR1 * (vSn1 * vX1 + vCc1 * vY1); vX1 = vXn;\nvXn = vR2 * (vCc2 * vX2 - vSn2 * vY2) + vW2 * vE2; vY2 = vR2 * (vSn2 * vX2 + vCc2 * vY2); vX2 = vXn;\nvXn = vR3 * (vCc3 * vX3 - vSn3 * vY3) + vW3 * vE2; vY3 = vR3 * (vSn3 * vX3 + vCc3 * vY3); vX3 = vXn;\nvXn = vR4 * (vCc4 * vX4 - vSn4 * vY4) + vW4 * vE2; vY4 = vR4 * (vSn4 * vX4 + vCc4 * vY4); vX4 = vXn;\nvXn = vR5 * (vCc5 * vX5 - vSn5 * vY5) + vW5 * vE2; vY5 = vR5 * (vSn5 * vX5 + vCc5 * vY5); vX5 = vXn;\nvXn = vR6 * (vCc6 * vX6 - vSn6 * vY6) + vW6 * vE2; vY6 = vR6 * (vSn6 * vX6 + vCc6 * vY6); vX6 = vXn;\nvXn = vR7 * (vCc7 * vX7 - vSn7 * vY7) + vW7 * vE2; vY7 = vR7 * (vSn7 * vX7 + vCc7 * vY7); vX7 = vXn;\nvXn = vR8 * (vCc8 * vX8 - vSn8 * vY8) + vW8 * vE2; vY8 = vR8 * (vSn8 * vX8 + vCc8 * vY8); vX8 = vXn;\nvXn = vR9 * (vCc9 * vX9 - vSn9 * vY9) + vW9 * vE2; vY9 = vR9 * (vSn9 * vX9 + vCc9 * vY9); vX9 = vXn;\nvXn = vR10 * (vCc10 * vX10 - vSn10 * vY10) + vW10 * vE2; vY10 = vR10 * (vSn10 * vX10 + vCc10 * vY10); vX10 = vXn;\nvXn = vR11 * (vCc11 * vX11 - vSn11 * vY11) + vW11 * vE2; vY11 = vR11 * (vSn11 * vX11 + vCc11 * vY11); vX11 = vXn;\nvXn = vR12 * (vCc12 * vX12 - vSn12 * vY12) + vW12 * vE2; vY12 = vR12 * (vSn12 * vX12 + vCc12 * vY12); vX12 = vXn;\nvXn = vR13 * (vCc13 * vX13 - vSn13 * vY13) + vW13 * vE2; vY13 = vR13 * (vSn13 * vX13 + vCc13 * vY13); vX13 = vXn;\nvXn = vR14 * (vCc14 * vX14 - vSn14 * vY14) + vW14 * vE2; vY14 = vR14 * (vSn14 * vX14 + vCc14 * vY14); vX14 = vXn;\nvXn = vR15 * (vCc15 * vX15 - vSn15 * vY15) + vW15 * vE2; vY15 = vR15 * (vSn15 * vX15 + vCc15 * vY15); vX15 = vXn;\nvXn = vR16 * (vCc16 * vX16 - vSn16 * vY16) + vW16 * vE2; vY16 = vR16 * (vSn16 * vX16 + vCc16 * vY16); vX16 = vXn;\nvXn = vR17 * (vCc17 * vX17 - vSn17 * vY17) + vW17 * vE2; vY17 = vR17 * (vSn17 * vX17 + vCc17 * vY17); vX17 = vXn;\nvXn = vR18 * (vCc18 * vX18 - vSn18 * vY18) + vW18 * vE2; vY18 = vR18 * (vSn18 * vX18 + vCc18 * vY18); vX18 = vXn;\nvKn = 1 - exp(-1 / (0.0003 * samplerate)); vP1 = vP1 + vKn * (vIm - vP1); vP2 = vP2 + vKn * (vP1 - vP2);\nvBe19 = vBe19 * vR19 + vBg19 * vP2; vQ3 = nz * vBe19 - vBi219; vQb = vBa119 * vBi119 + vBa219 * vQ3; vQl = vBi219 + vBa219 * vBi119 + vBa319 * vQ3; vBi119 = 2 * vQb - vBi119; vBi219 = 2 * vQl - vBi219; vY19 = vQb / 2.0;\nvBe20 = vBe20 * vR20 + vBg20 * vP2; vQ3 = nz * vBe20 - vBi220; vQb = vBa120 * vBi120 + vBa220 * vQ3; vQl = vBi220 + vBa220 * vBi120 + vBa320 * vQ3; vBi120 = 2 * vQb - vBi120; vBi220 = 2 * vQl - vBi220; vY20 = vQb / 2.0;\nvBe21 = vBe21 * vR21 + vBg21 * vP2; vQ3 = nz * vBe21 - vBi221; vQb = vBa121 * vBi121 + vBa221 * vQ3; vQl = vBi221 + vBa221 * vBi121 + vBa321 * vQ3; vBi121 = 2 * vQb - vBi121; vBi221 = 2 * vQl - vBi221; vY21 = vQb / 2.0;\nvBe22 = vBe22 * vR22 + vBg22 * vP2; vQ3 = nz * vBe22 - vBi222; vQb = vBa122 * vBi122 + vBa222 * vQ3; vQl = vBi222 + vBa222 * vBi122 + vBa322 * vQ3; vBi122 = 2 * vQb - vBi122; vBi222 = 2 * vQl - vBi222; vY22 = vQb / 2.0;\nvBe23 = vBe23 * vR23 + vBg23 * vP2; vQ3 = nz * vBe23 - vBi223; vQb = vBa123 * vBi123 + vBa223 * vQ3; vQl = vBi223 + vBa223 * vBi123 + vBa323 * vQ3; vBi123 = 2 * vQb - vBi123; vBi223 = 2 * vQl - vBi223; vY23 = vQb / 2.0;\nvSm = vY0 + vY1 + vY2 + vY3 + vY4 + vY5 + vY6 + vY7 + vY8 + vY9 + vY10 + vY11 + vY12 + vY13 + vY14 + vY15 + vY16 + vY17 + vY18 + vY19 + vY20 + vY21 + vY22 + vY23;\nvNx = nz * vNe; vNe = vNe * vNr;\nvNv3 = vNx - vI2; vNb = vNa1 * vI1 + vNa2 * vNv3; vNl = vI2 + vNa2 * vI1 + vNa3 * vNv3; vI1 = 2 * vNb - vI1; vI2 = 2 * vNl - vI2;\nvmix = (vSm + vNk * vNb) * masterG;\nvax = abs(vmix); vlim = sign(vmix) * (min(vax, 0.8) + 0.2 * tanh(max(vax - 0.8, 0) * 5));\nout1 = vlim + 0 * in1; out2 = vlim + 0 * in2;\n",
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
						"ring",
						0
					],
					"destination": [
						"pre_ring",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_ring",
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
						"ring",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"stick",
						0
					],
					"destination": [
						"pre_stick",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_stick",
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
						"stick",
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
			"shell": [
				"Shell",
				"Shell",
				0
			],
			"ring": [
				"Ring",
				"Ring",
				0
			],
			"stick": [
				"Stick",
				"Stick",
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
						"Shell",
						"Ring",
						"Stick",
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