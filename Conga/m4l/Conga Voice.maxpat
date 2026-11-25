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
		"description": "Conga Voice: one conga (quinto, conga or tumba; open, slap, mute, bass, heel or toe) as a modal membrane model, for Drum Rack pads.",
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
					"text": "js conga_voice_push.js",
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
						1100,
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
					"id": "press",
					"varname": "press",
					"parameter_enable": 1,
					"annotation_name": "Press",
					"annotation": "The mod wheel presses the head (elbow or palm on it): this many semitones up at full wheel.",
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
						1010,
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
					"id": "touch",
					"varname": "touch",
					"parameter_enable": 1,
					"annotation_name": "Touch",
					"annotation": "How much velocity changes the tone: harder hits are shorter in contact (brighter) as well as louder.",
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
						920,
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
					"id": "shell",
					"varname": "shell",
					"parameter_enable": 1,
					"annotation_name": "Shell",
					"annotation": "The body of the drum: how much the low modes (air in the shell, the heel and bass thump) speak.",
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
					"id": "ol_slap",
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
					"id": "slap",
					"varname": "slap",
					"parameter_enable": 1,
					"annotation_name": "Slap",
					"annotation": "Character of the Slap stroke: the crack of the fingers on the rim (noise) and how far up the overtones are driven. No effect on other strokes.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
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
							"parameter_units": "Slap %.0f"
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
					"annotation": "How long the head rings, in percent of the natural time (the open tone's T60 is about half a second).",
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
					"annotation": "Tuning in semitones. 0 is the drum's open tone (quinto 366 Hz, conga 266 Hz, tumba 219 Hz).",
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
					"annotation": "Which hand stroke a note plays: Open (abierto, the ringing tone), Slap (seco, the crack), Mute (tapado, the dead thud), Bass (palm in the middle), Heel (the heel of the hand) or Toe (fingertips). Changing it between hits works: the new stroke damps the ring already on the head.",
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
								"Slap",
								"Mute",
								"Bass",
								"Heel",
								"Toe"
							],
							"parameter_mmax": 5,
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
					"annotation": "Which drum: Quinto (the high one, open tone 366 Hz), Conga (266 Hz) or Tumba (the low one, 219 Hz). Any MIDI note plays it.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Drum",
							"parameter_shortname": "Drum",
							"parameter_type": 2,
							"parameter_enum": [
								"Quinto",
								"Conga",
								"Tumba"
							],
							"parameter_mmax": 2,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								1
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
					"filename": "conga_voice_view.js",
					"border": 0,
					"parameter_enable": 0,
					"annotation_name": "Conga",
					"annotation": "The drum, and the stroke it plays: it flashes when it is hit.",
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
					"text": "js conga_voice_midi.js",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						20,
						200,
						154,
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
									"code": "Param drum(1);\nParam stroke(0);\nParam tune(0);\nParam decay(100);\nParam skin(50);\nParam slap(50);\nParam shell(50);\nParam touch(50);\nParam press(5);\nParam volume(-9);\nParam trg(0);\nParam vel(1);\nParam mw(0);\nHistory cnt(0);\nHistory pf(1);\nHistory pt(0);\nHistory vC(0);\nHistory vCk(0.99);\nHistory vE1(0);\nHistory vE2(0);\nHistory vK(0.5);\nHistory vNe(0);\nHistory vNr(0.99);\nHistory vI1(0);\nHistory vI2(0);\nHistory vNa1(0);\nHistory vNa2(0);\nHistory vNa3(0);\nHistory vNk(1);\nHistory vAm(0);\nHistory vF1(300);\nHistory vX0(0);\nHistory vY0(0);\nHistory vW0(0);\nHistory vG0(1);\nHistory vCc0(1);\nHistory vSn0(0);\nHistory vR0(0.999);\nHistory vX1(0);\nHistory vY1(0);\nHistory vW1(0);\nHistory vG1(1);\nHistory vCc1(1);\nHistory vSn1(0);\nHistory vR1(0.999);\nHistory vX2(0);\nHistory vY2(0);\nHistory vW2(0);\nHistory vG2(1);\nHistory vCc2(1);\nHistory vSn2(0);\nHistory vR2(0.999);\nHistory vX3(0);\nHistory vY3(0);\nHistory vW3(0);\nHistory vG3(1);\nHistory vCc3(1);\nHistory vSn3(0);\nHistory vR3(0.999);\nHistory vX4(0);\nHistory vY4(0);\nHistory vW4(0);\nHistory vG4(1);\nHistory vCc4(1);\nHistory vSn4(0);\nHistory vR4(0.999);\nHistory vX5(0);\nHistory vY5(0);\nHistory vW5(0);\nHistory vG5(1);\nHistory vCc5(1);\nHistory vSn5(0);\nHistory vR5(0.999);\nHistory vX6(0);\nHistory vY6(0);\nHistory vW6(0);\nHistory vG6(1);\nHistory vCc6(1);\nHistory vSn6(0);\nHistory vR6(0.999);\nHistory vX7(0);\nHistory vY7(0);\nHistory vW7(0);\nHistory vG7(1);\nHistory vCc7(1);\nHistory vSn7(0);\nHistory vR7(0.999);\nHistory vX8(0);\nHistory vY8(0);\nHistory vW8(0);\nHistory vG8(1);\nHistory vCc8(1);\nHistory vSn8(0);\nHistory vR8(0.999);\nHistory vX9(0);\nHistory vY9(0);\nHistory vW9(0);\nHistory vG9(1);\nHistory vCc9(1);\nHistory vSn9(0);\nHistory vR9(0.999);\nHistory vX10(0);\nHistory vY10(0);\nHistory vW10(0);\nHistory vG10(1);\nHistory vCc10(1);\nHistory vSn10(0);\nHistory vR10(0.999);\nHistory vX11(0);\nHistory vY11(0);\nHistory vW11(0);\nHistory vG11(1);\nHistory vCc11(1);\nHistory vSn11(0);\nHistory vR11(0.999);\nHistory vX12(0);\nHistory vY12(0);\nHistory vW12(0);\nHistory vG12(1);\nHistory vCc12(1);\nHistory vSn12(0);\nHistory vR12(0.999);\nHistory vX13(0);\nHistory vY13(0);\nHistory vW13(0);\nHistory vG13(1);\nHistory vCc13(1);\nHistory vSn13(0);\nHistory vR13(0.999);\n\ndecayS = decay * 0.01;\nskinT = (skin - 50) * 0.02 * 6 / 6.0206;                      // +-6 dB per octave of mode ratio at the ends\nshellG = shell * 0.02;\nslapG = slap * 0.02;\ntouchG = touch * 0.01 * 1.0;\npfT = exp2(mw * press / 12);\nmasterG = dbtoa(volume);\nvSk0 = exp(skinT * -1.203973) * shellG;\nvSk1 = exp(skinT * -0.653926) * shellG;\nvSk2 = exp(skinT * -0.223144);\nvSk3 = exp(skinT * 0.000000);\nvSk4 = exp(skinT * 0.157004);\nvSk5 = exp(skinT * 0.451076);\nvSk6 = exp(skinT * 0.570980);\nvSk7 = exp(skinT * 0.722706);\nvSk8 = exp(skinT * 0.832909);\nvSk9 = exp(skinT * 0.974560);\nvSk10 = exp(skinT * 1.163151);\nvSk11 = exp(skinT * 1.360977);\nvSk12 = exp(skinT * 1.568616);\nvSk13 = exp(skinT * 1.824549);\ncnt = cnt + 1; ctl = cnt >= 16; cnt = cnt - ctl * 16;\nif (ctl) { pf = pf + 0.2 * (pfT - pf); }\nnz = noise();\nvh = trg != pt; pt = trg;\nvIm = 0;\nif (vh > 0.5) {\nvds = vh * stroke;                                   // History-derived: the stroke and velocity at the hit\nvdv = vh * vel;\nvk = drum * 6 + vds;\nvs1 = abs(vds - 1) < 0.5;\nvg = pow(vdv, 1.4);\nvAm = vg * ((abs(vk - 0) < 0.5) * 0.412600 + (abs(vk - 1) < 0.5) * 0.111000 + (abs(vk - 2) < 0.5) * 0.469900 + (abs(vk - 3) < 0.5) * 0.168400 + (abs(vk - 4) < 0.5) * 0.515800 + (abs(vk - 5) < 0.5) * 0.249200 + (abs(vk - 6) < 0.5) * 0.451300 + (abs(vk - 7) < 0.5) * 0.110100 + (abs(vk - 8) < 0.5) * 0.398900 + (abs(vk - 9) < 0.5) * 0.183000 + (abs(vk - 10) < 0.5) * 0.429900 + (abs(vk - 11) < 0.5) * 0.199300 + (abs(vk - 12) < 0.5) * 0.555200 + (abs(vk - 13) < 0.5) * 0.146200 + (abs(vk - 14) < 0.5) * 0.415300 + (abs(vk - 15) < 0.5) * 0.283700 + (abs(vk - 16) < 0.5) * 0.492000 + (abs(vk - 17) < 0.5) * 0.203200);\nvIm = vAm;\nvfc = ((abs(vds - 0) < 0.5) * 3000.000000 + (abs(vds - 1) < 0.5) * 6000.000000 + (abs(vds - 2) < 0.5) * 1500.000000 + (abs(vds - 3) < 0.5) * 250.000000 + (abs(vds - 4) < 0.5) * 500.000000 + (abs(vds - 5) < 0.5) * 2000.000000) * exp2((touchG * (vdv - 0.6) * 2) + vs1 * (slapG - 1));\nvK = 1 - exp(-twopi * min(vfc, 18000) / samplerate);\nvC = 1;\nvCk = exp(-16 / (((abs(vds - 0) < 0.5) * 1.000000 + (abs(vds - 1) < 0.5) * 0.050000 + (abs(vds - 2) < 0.5) * 0.300000 + (abs(vds - 3) < 0.5) * 0.200000 + (abs(vds - 4) < 0.5) * 0.150000 + (abs(vds - 5) < 0.5) * 0.100000) * samplerate));\nvNe = vAm * ((abs(drum - 0) < 0.5) * 1.330000 + (abs(drum - 1) < 0.5) * 1.220000 + (abs(drum - 2) < 0.5) * 0.620000) * ((abs(vds - 0) < 0.5) * 1.396100 + (abs(vds - 1) < 0.5) * 6.791300 + (abs(vds - 2) < 0.5) * 0.758200 + (abs(vds - 3) < 0.5) * 5.809700 + (abs(vds - 4) < 0.5) * 0.668000 + (abs(vds - 5) < 0.5) * 0.650200) * (1 + vs1 * (slapG * 2 - 2));\nvNr = exp(-1 / (((abs(vds - 0) < 0.5) * 0.003000 + (abs(vds - 1) < 0.5) * 0.006000 + (abs(vds - 2) < 0.5) * 0.003000 + (abs(vds - 3) < 0.5) * 0.003000 + (abs(vds - 4) < 0.5) * 0.003000 + (abs(vds - 5) < 0.5) * 0.003000) * samplerate));\nvNg = tan(pi * ((abs(vds - 0) < 0.5) * 2930.000000 + (abs(vds - 1) < 0.5) * 3700.000000 + (abs(vds - 2) < 0.5) * 3750.000000 + (abs(vds - 3) < 0.5) * 3980.000000 + (abs(vds - 4) < 0.5) * 3980.000000 + (abs(vds - 5) < 0.5) * 3330.000000) / samplerate); vNk = 1 / ((abs(vds - 0) < 0.5) * 0.350000 + (abs(vds - 1) < 0.5) * 0.350000 + (abs(vds - 2) < 0.5) * 0.350000 + (abs(vds - 3) < 0.5) * 0.350000 + (abs(vds - 4) < 0.5) * 0.350000 + (abs(vds - 5) < 0.5) * 0.350000);\nvNa1 = 1 / (1 + vNg * (vNg + vNk)); vNa2 = vNg * vNa1; vNa3 = vNg * vNa2;\nvW0 = ((abs(vds - 0) < 0.5) * 0.052481 + (abs(vds - 1) < 0.5) * 0.272270 + (abs(vds - 2) < 0.5) * 0.031261 + (abs(vds - 3) < 0.5) * 0.609537 + (abs(vds - 4) < 0.5) * 0.030200 + (abs(vds - 5) < 0.5) * 0.032734) * vSk0; vG0 = (abs(vds - 0) < 0.5) * 1.000000 + (abs(vds - 1) < 0.5) * 0.250000 + (abs(vds - 2) < 0.5) * 0.320000 + (abs(vds - 3) < 0.5) * 0.370000 + (abs(vds - 4) < 0.5) * 0.300000 + (abs(vds - 5) < 0.5) * 0.250000;\nvW1 = ((abs(vds - 0) < 0.5) * 0.056234 + (abs(vds - 1) < 0.5) * 0.638263 + (abs(vds - 2) < 0.5) * 0.072444 + (abs(vds - 3) < 0.5) * 1.000000 + (abs(vds - 4) < 0.5) * 0.043652 + (abs(vds - 5) < 0.5) * 0.063826) * vSk1; vG1 = (abs(vds - 0) < 0.5) * 0.310000 + (abs(vds - 1) < 0.5) * 0.250000 + (abs(vds - 2) < 0.5) * 0.310000 + (abs(vds - 3) < 0.5) * 0.330000 + (abs(vds - 4) < 0.5) * 0.260000 + (abs(vds - 5) < 0.5) * 0.250000;\nvW2 = ((abs(vds - 0) < 0.5) * 0.113501 + (abs(vds - 1) < 0.5) * 0.568853 + (abs(vds - 2) < 0.5) * 0.091201 + (abs(vds - 3) < 0.5) * 0.451856 + (abs(vds - 4) < 0.5) * 0.037154 + (abs(vds - 5) < 0.5) * 0.117490) * vSk2; vG2 = (abs(vds - 0) < 0.5) * 0.460000 + (abs(vds - 1) < 0.5) * 0.680000 + (abs(vds - 2) < 0.5) * 1.050000 + (abs(vds - 3) < 0.5) * 0.930000 + (abs(vds - 4) < 0.5) * 0.940000 + (abs(vds - 5) < 0.5) * 0.950000;\nvW3 = ((abs(vds - 0) < 0.5) * 1.000000 + (abs(vds - 1) < 0.5) * 0.562341 + (abs(vds - 2) < 0.5) * 0.092257 + (abs(vds - 3) < 0.5) * 0.213796 + (abs(vds - 4) < 0.5) * 0.048978 + (abs(vds - 5) < 0.5) * 0.251189) * vSk3; vG3 = (abs(vds - 0) < 0.5) * 0.990000 + (abs(vds - 1) < 0.5) * 3.760000 + (abs(vds - 2) < 0.5) * 2.750000 + (abs(vds - 3) < 0.5) * 2.740000 + (abs(vds - 4) < 0.5) * 3.160000 + (abs(vds - 5) < 0.5) * 4.710000;\nvW4 = ((abs(vds - 0) < 0.5) * 0.208930 + (abs(vds - 1) < 0.5) * 0.630957 + (abs(vds - 2) < 0.5) * 0.050119 + (abs(vds - 3) < 0.5) * 0.367282 + (abs(vds - 4) < 0.5) * 0.060256 + (abs(vds - 5) < 0.5) * 0.113501) * vSk4; vG4 = (abs(vds - 0) < 0.5) * 0.950000 + (abs(vds - 1) < 0.5) * 1.310000 + (abs(vds - 2) < 0.5) * 1.220000 + (abs(vds - 3) < 0.5) * 1.400000 + (abs(vds - 4) < 0.5) * 1.450000 + (abs(vds - 5) < 0.5) * 1.760000;\nvW5 = ((abs(vds - 0) < 0.5) * 0.116145 + (abs(vds - 1) < 0.5) * 0.668344 + (abs(vds - 2) < 0.5) * 0.030200 + (abs(vds - 3) < 0.5) * 0.266073 + (abs(vds - 4) < 0.5) * 0.035075 + (abs(vds - 5) < 0.5) * 0.077625) * vSk5; vG5 = (abs(vds - 0) < 0.5) * 0.600000 + (abs(vds - 1) < 0.5) * 1.260000 + (abs(vds - 2) < 0.5) * 1.290000 + (abs(vds - 3) < 0.5) * 1.510000 + (abs(vds - 4) < 0.5) * 1.560000 + (abs(vds - 5) < 0.5) * 1.860000;\nvW6 = ((abs(vds - 0) < 0.5) * 0.073282 + (abs(vds - 1) < 0.5) * 0.518800 + (abs(vds - 2) < 0.5) * 0.013964 + (abs(vds - 3) < 0.5) * 0.130317 + (abs(vds - 4) < 0.5) * 0.008610 + (abs(vds - 5) < 0.5) * 0.027861) * vSk6; vG6 = (abs(vds - 0) < 0.5) * 0.360000 + (abs(vds - 1) < 0.5) * 0.250000 + (abs(vds - 2) < 0.5) * 0.700000 + (abs(vds - 3) < 0.5) * 2.000000 + (abs(vds - 4) < 0.5) * 0.550000 + (abs(vds - 5) < 0.5) * 0.760000;\nvW7 = ((abs(vds - 0) < 0.5) * 0.042658 + (abs(vds - 1) < 0.5) * 0.518800 + (abs(vds - 2) < 0.5) * 0.010000 + (abs(vds - 3) < 0.5) * 0.319890 + (abs(vds - 4) < 0.5) * 0.016788 + (abs(vds - 5) < 0.5) * 0.019275) * vSk7; vG7 = (abs(vds - 0) < 0.5) * 1.000000 + (abs(vds - 1) < 0.5) * 0.250000 + (abs(vds - 2) < 0.5) * 0.500000 + (abs(vds - 3) < 0.5) * 2.000000 + (abs(vds - 4) < 0.5) * 0.620000 + (abs(vds - 5) < 0.5) * 0.450000;\nvW8 = ((abs(vds - 0) < 0.5) * 0.056885 + (abs(vds - 1) < 0.5) * 0.922571 + (abs(vds - 2) < 0.5) * 0.010715 + (abs(vds - 3) < 0.5) * 0.384592 + (abs(vds - 4) < 0.5) * 0.015668 + (abs(vds - 5) < 0.5) * 0.030903) * vSk8; vG8 = (abs(vds - 0) < 0.5) * 0.370000 + (abs(vds - 1) < 0.5) * 0.250000 + (abs(vds - 2) < 0.5) * 0.370000 + (abs(vds - 3) < 0.5) * 2.000000 + (abs(vds - 4) < 0.5) * 0.380000 + (abs(vds - 5) < 0.5) * 0.510000;\nvW9 = ((abs(vds - 0) < 0.5) * 0.079433 + (abs(vds - 1) < 0.5) * 1.000000 + (abs(vds - 2) < 0.5) * 0.012445 + (abs(vds - 3) < 0.5) * 0.785236 + (abs(vds - 4) < 0.5) * 0.020893 + (abs(vds - 5) < 0.5) * 0.024547) * vSk9; vG9 = (abs(vds - 0) < 0.5) * 1.000000 + (abs(vds - 1) < 0.5) * 0.250000 + (abs(vds - 2) < 0.5) * 0.280000 + (abs(vds - 3) < 0.5) * 2.000000 + (abs(vds - 4) < 0.5) * 0.260000 + (abs(vds - 5) < 0.5) * 0.250000;\nvW10 = ((abs(vds - 0) < 0.5) * 0.073282 + (abs(vds - 1) < 0.5) * 0.831764 + (abs(vds - 2) < 0.5) * 0.008222 + (abs(vds - 3) < 0.5) * 0.794328 + (abs(vds - 4) < 0.5) * 0.018408 + (abs(vds - 5) < 0.5) * 0.017989) * vSk10; vG10 = (abs(vds - 0) < 0.5) * 1.000000 + (abs(vds - 1) < 0.5) * 0.250000 + (abs(vds - 2) < 0.5) * 0.250000 + (abs(vds - 3) < 0.5) * 2.000000 + (abs(vds - 4) < 0.5) * 0.250000 + (abs(vds - 5) < 0.5) * 0.250000;\nvW11 = ((abs(vds - 0) < 0.5) * 0.063096 + (abs(vds - 1) < 0.5) * 0.562341 + (abs(vds - 2) < 0.5) * 0.724436 + (abs(vds - 3) < 0.5) * 0.732825 + (abs(vds - 4) < 0.5) * 0.380189 + (abs(vds - 5) < 0.5) * 0.421697) * vSk11; vG11 = (abs(vds - 0) < 0.5) * 1.000000 + (abs(vds - 1) < 0.5) * 0.250000 + (abs(vds - 2) < 0.5) * 6.000000 + (abs(vds - 3) < 0.5) * 2.000000 + (abs(vds - 4) < 0.5) * 3.000000 + (abs(vds - 5) < 0.5) * 4.000000;\nvW12 = ((abs(vds - 0) < 0.5) * 0.096605 + (abs(vds - 1) < 0.5) * 0.506991 + (abs(vds - 2) < 0.5) * 1.000000 + (abs(vds - 3) < 0.5) * 0.421697 + (abs(vds - 4) < 0.5) * 0.822243 + (abs(vds - 5) < 0.5) * 0.660693) * vSk12; vG12 = (abs(vds - 0) < 0.5) * 1.000000 + (abs(vds - 1) < 0.5) * 0.250000 + (abs(vds - 2) < 0.5) * 6.000000 + (abs(vds - 3) < 0.5) * 2.000000 + (abs(vds - 4) < 0.5) * 3.000000 + (abs(vds - 5) < 0.5) * 4.000000;\nvW13 = ((abs(vds - 0) < 0.5) * 0.101158 + (abs(vds - 1) < 0.5) * 0.512861 + (abs(vds - 2) < 0.5) * 0.512861 + (abs(vds - 3) < 0.5) * 0.060256 + (abs(vds - 4) < 0.5) * 1.000000 + (abs(vds - 5) < 0.5) * 1.000000) * vSk13; vG13 = (abs(vds - 0) < 0.5) * 1.000000 + (abs(vds - 1) < 0.5) * 0.250000 + (abs(vds - 2) < 0.5) * 6.000000 + (abs(vds - 3) < 0.5) * 2.000000 + (abs(vds - 4) < 0.5) * 3.000000 + (abs(vds - 5) < 0.5) * 4.000000;\nvkp = (abs(vds - 0) < 0.5) * 0.850000 + (abs(vds - 1) < 0.5) * 0.500000 + (abs(vds - 2) < 0.5) * 0.150000 + (abs(vds - 3) < 0.5) * 0.400000 + (abs(vds - 4) < 0.5) * 0.400000 + (abs(vds - 5) < 0.5) * 0.600000;\nvX0 = vX0 * vkp; vY0 = vY0 * vkp;\nvX1 = vX1 * vkp; vY1 = vY1 * vkp;\nvX2 = vX2 * vkp; vY2 = vY2 * vkp;\nvX3 = vX3 * vkp; vY3 = vY3 * vkp;\nvX4 = vX4 * vkp; vY4 = vY4 * vkp;\nvX5 = vX5 * vkp; vY5 = vY5 * vkp;\nvX6 = vX6 * vkp; vY6 = vY6 * vkp;\nvX7 = vX7 * vkp; vY7 = vY7 * vkp;\nvX8 = vX8 * vkp; vY8 = vY8 * vkp;\nvX9 = vX9 * vkp; vY9 = vY9 * vkp;\nvX10 = vX10 * vkp; vY10 = vY10 * vkp;\nvX11 = vX11 * vkp; vY11 = vY11 * vkp;\nvX12 = vX12 * vkp; vY12 = vY12 * vkp;\nvX13 = vX13 * vkp; vY13 = vY13 * vkp;\n}\nvE1 = vE1 + vK * (vIm - vE1); vE2 = vE2 + vK * (vE1 - vE2);\nif (ctl) {\nvC = vC * vCk;\nvF1 = ((abs(drum - 0) < 0.5) * 366.000000 + (abs(drum - 1) < 0.5) * 266.000000 + (abs(drum - 2) < 0.5) * 219.000000) * exp2(tune / 12);\nvw = twopi * vF1 * pf * 0.3 / samplerate; vCc0 = cos(vw); vSn0 = sin(vw); vR0 = exp(-46.051702 * (1 + (vG0 - 1) * vC) / (decayS * 1.0 * samplerate));\nvw = twopi * vF1 * pf * 0.52 / samplerate; vCc1 = cos(vw); vSn1 = sin(vw); vR1 = exp(-57.564627 * (1 + (vG1 - 1) * vC) / (decayS * 1.0 * samplerate));\nvw = twopi * vF1 * pf * 0.8 / samplerate; vCc2 = cos(vw); vSn2 = sin(vw); vR2 = exp(-27.631021 * (1 + (vG2 - 1) * vC) / (decayS * 1.0 * samplerate));\nvw = twopi * vF1 * pf * 1.0 / samplerate; vCc3 = cos(vw); vSn3 = sin(vw); vR3 = exp(-12.559555 * (1 + (vG3 - 1) * vC) / (decayS * 1.0 * samplerate));\nvw = twopi * vF1 * pf * 1.17 / samplerate; vCc4 = cos(vw); vSn4 = sin(vw); vR4 = exp(-23.025851 * (1 + (vG4 - 1) * vC) / (decayS * 1.0 * samplerate));\nvw = twopi * vF1 * pf * 1.57 / samplerate; vCc5 = cos(vw); vSn5 = sin(vw); vR5 = exp(-19.736444 * (1 + (vG5 - 1) * vC) / (decayS * 1.0 * samplerate));\nvw = twopi * vF1 * pf * 1.77 / samplerate; vCc6 = cos(vw); vSn6 = sin(vw); vR6 = exp(-27.631021 * (1 + (vG6 - 1) * vC) / (decayS * 1.0 * samplerate));\nvw = twopi * vF1 * pf * 2.06 / samplerate; vCc7 = cos(vw); vSn7 = sin(vw); vR7 = exp(-31.398888 * (1 + (vG7 - 1) * vC) / (decayS * 1.0 * samplerate));\nvw = twopi * vF1 * pf * 2.3 / samplerate; vCc8 = cos(vw); vSn8 = sin(vw); vR8 = exp(-38.376418 * (1 + (vG8 - 1) * vC) / (decayS * 1.0 * samplerate));\nvw = twopi * vF1 * pf * 2.65 / samplerate; vCc9 = cos(vw); vSn9 = sin(vw); vR9 = exp(-49.341109 * (1 + (vG9 - 1) * vC) / (decayS * 1.0 * samplerate));\nvw = twopi * vF1 * pf * 3.2 / samplerate; vCc10 = cos(vw); vSn10 = sin(vw); vR10 = exp(-69.077553 * (1 + (vG10 - 1) * vC) / (decayS * 1.0 * samplerate));\nvw = twopi * vF1 * pf * 3.9 / samplerate; vCc11 = cos(vw); vSn11 = sin(vw); vR11 = exp(-86.346941 * (1 + (vG11 - 1) * vC) / (decayS * 1.0 * samplerate));\nvw = twopi * vF1 * pf * 4.8 / samplerate; vCc12 = cos(vw); vSn12 = sin(vw); vR12 = exp(-115.129255 * (1 + (vG12 - 1) * vC) / (decayS * 1.0 * samplerate));\nvw = twopi * vF1 * pf * 6.2 / samplerate; vCc13 = cos(vw); vSn13 = sin(vw); vR13 = exp(-172.693882 * (1 + (vG13 - 1) * vC) / (decayS * 1.0 * samplerate));\n}\nvXn = vR0 * (vCc0 * vX0 - vSn0 * vY0) + vW0 * vE2; vY0 = vR0 * (vSn0 * vX0 + vCc0 * vY0); vX0 = vXn;\nvXn = vR1 * (vCc1 * vX1 - vSn1 * vY1) + vW1 * vE2; vY1 = vR1 * (vSn1 * vX1 + vCc1 * vY1); vX1 = vXn;\nvXn = vR2 * (vCc2 * vX2 - vSn2 * vY2) + vW2 * vE2; vY2 = vR2 * (vSn2 * vX2 + vCc2 * vY2); vX2 = vXn;\nvXn = vR3 * (vCc3 * vX3 - vSn3 * vY3) + vW3 * vE2; vY3 = vR3 * (vSn3 * vX3 + vCc3 * vY3); vX3 = vXn;\nvXn = vR4 * (vCc4 * vX4 - vSn4 * vY4) + vW4 * vE2; vY4 = vR4 * (vSn4 * vX4 + vCc4 * vY4); vX4 = vXn;\nvXn = vR5 * (vCc5 * vX5 - vSn5 * vY5) + vW5 * vE2; vY5 = vR5 * (vSn5 * vX5 + vCc5 * vY5); vX5 = vXn;\nvXn = vR6 * (vCc6 * vX6 - vSn6 * vY6) + vW6 * vE2; vY6 = vR6 * (vSn6 * vX6 + vCc6 * vY6); vX6 = vXn;\nvXn = vR7 * (vCc7 * vX7 - vSn7 * vY7) + vW7 * vE2; vY7 = vR7 * (vSn7 * vX7 + vCc7 * vY7); vX7 = vXn;\nvXn = vR8 * (vCc8 * vX8 - vSn8 * vY8) + vW8 * vE2; vY8 = vR8 * (vSn8 * vX8 + vCc8 * vY8); vX8 = vXn;\nvXn = vR9 * (vCc9 * vX9 - vSn9 * vY9) + vW9 * vE2; vY9 = vR9 * (vSn9 * vX9 + vCc9 * vY9); vX9 = vXn;\nvXn = vR10 * (vCc10 * vX10 - vSn10 * vY10) + vW10 * vE2; vY10 = vR10 * (vSn10 * vX10 + vCc10 * vY10); vX10 = vXn;\nvXn = vR11 * (vCc11 * vX11 - vSn11 * vY11) + vW11 * vE2; vY11 = vR11 * (vSn11 * vX11 + vCc11 * vY11); vX11 = vXn;\nvXn = vR12 * (vCc12 * vX12 - vSn12 * vY12) + vW12 * vE2; vY12 = vR12 * (vSn12 * vX12 + vCc12 * vY12); vX12 = vXn;\nvXn = vR13 * (vCc13 * vX13 - vSn13 * vY13) + vW13 * vE2; vY13 = vR13 * (vSn13 * vX13 + vCc13 * vY13); vX13 = vXn;\nvSm = vY0 + vY1 + vY2 + vY3 + vY4 + vY5 + vY6 + vY7 + vY8 + vY9 + vY10 + vY11 + vY12 + vY13;\nvNx = nz * vNe; vNe = vNe * vNr;\nvNv3 = vNx - vI2; vNb = vNa1 * vI1 + vNa2 * vNv3; vNl = vI2 + vNa2 * vI1 + vNa3 * vNv3; vI1 = 2 * vNb - vI1; vI2 = 2 * vNl - vI2;\nvmix = (vSm + vNk * vNb) * 0.707106781186548 * masterG;\nvax = abs(vmix); vlim = sign(vmix) * (min(vax, 0.8) + 0.2 * tanh(max(vax - 0.8, 0) * 5));\nout1 = vlim + 0 * in1; out2 = vlim + 0 * in2;\n",
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
			"slap": [
				"Slap",
				"Slap",
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
						"Slap",
						"Shell",
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
						"Touch",
						"Press",
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