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
			904.0,
			169.0
		],
		"openinpresentation": 1,
		"devicewidth": 904.0,
		"default_fontname": "Ableton Sans Medium",
		"default_fontsize": 9.0,
		"gridsize": [
			8.0,
			8.0
		],
		"description": "CR78: the Roland CR-78 voice board: bass drum, snare, rimshot, clave, bongos, conga, cowbell, hi-hat, cymbal, maracas, tambourine, guiro and metallic beat.",
		"boxes": [
			{
				"box": {
					"id": "pre_drive",
					"maxclass": "newobj",
					"text": "prepend drive",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1060,
						1100,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "drive",
					"varname": "drive",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Drive",
					"annotation": "Transistor-style saturation on the ringing oscillators (bass drum, snare tone, bongos, conga). 0 = clean.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Drive",
							"parameter_shortname": "Drive",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.0f %"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						782.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1810,
						1460,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "pre_master",
					"maxclass": "newobj",
					"text": "prepend master",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1060,
						1040,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "master",
					"varname": "master",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Master Volume",
					"annotation": "Output level of the whole kit.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Master Volume",
							"parameter_shortname": "Master",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 150.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								100
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.0f %"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						830.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1670,
						1460,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "pre_accent",
					"maxclass": "newobj",
					"text": "prepend accent",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1060,
						980,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "accent",
					"varname": "accent",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Accent",
					"annotation": "How much velocity lifts or lowers a hit, like the accent stage of the board. 0 = every hit equal; 100 = level follows velocity (velocity 100 is the factory level).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Accent",
							"parameter_shortname": "Accent",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								60
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.0f %"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						782.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						2090,
						1400,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "pre_guPan",
					"maxclass": "newobj",
					"text": "prepend guPan",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1060,
						920,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "guPan",
					"varname": "guPan",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Guiro Pan",
					"annotation": "Guiro position in the stereo field. The CR-78 itself is mono.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Guiro Pan",
							"parameter_shortname": "Pan",
							"parameter_type": 0,
							"parameter_mmin": -100.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.0f"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						320.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1950,
						1400,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_guLvl",
					"maxclass": "newobj",
					"text": "prepend guLvl",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1060,
						860,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "guLvl",
					"varname": "guLvl",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Guiro Level",
					"annotation": "Output level, in the service notes' volts peak-to-peak: the default is the factory amplitude (0.3 Vpp).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Guiro Level",
							"parameter_shortname": "Level",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.3
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.2f Vpp"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						272.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1810,
						1400,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_guDec",
					"maxclass": "newobj",
					"text": "prepend guDec",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1060,
						800,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "guDec",
					"varname": "guDec",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Guiro Decay",
					"annotation": "Length of each scrape grain: 0 is 9 ms at the long note's rate; each +1 doubles it, each -1 halves it.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Guiro Decay",
							"parameter_shortname": "Decay",
							"parameter_type": 0,
							"parameter_mmin": -2.0,
							"parameter_mmax": 2.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f oct"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						224.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1670,
						1400,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_guTone",
					"maxclass": "newobj",
					"text": "prepend guTone",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1060,
						740,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "guTone",
					"varname": "guTone",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Guiro Tone",
					"annotation": "Centre of the scrape's resonance (5.9 kHz at 0, fitted to CR-78 guiro recordings).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Guiro Tone",
							"parameter_shortname": "Tone",
							"parameter_type": 0,
							"parameter_mmin": -12.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f st"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						176.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						2090,
						1340,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_guRate",
					"maxclass": "newobj",
					"text": "prepend guRate",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1060,
						680,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "guRate",
					"varname": "guRate",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Guiro Rate",
					"annotation": "Speed of the multivibrator for both notes: 0 is the factory 125 Hz (short note) and 77 Hz (long note).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Guiro Rate",
							"parameter_shortname": "Rate",
							"parameter_type": 0,
							"parameter_mmin": -12.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f st"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						128.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1950,
						1340,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "msg_guLTrig",
					"maxclass": "message",
					"text": "trig 13 100",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1200,
						20,
						80,
						22
					]
				}
			},
			{
				"box": {
					"id": "rb_guLTrig",
					"maxclass": "newobj",
					"text": "route bang",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						1060,
						620,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "sel_guLTrig",
					"maxclass": "newobj",
					"text": "sel 1",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						1060,
						590,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "guLTrig",
					"varname": "guLTrig",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"mode": 0,
					"text": "L",
					"fontname": "Ableton Sans Bold",
					"fontsize": 8.5,
					"parameter_enable": 1,
					"annotation_name": "Guiro Long Trigger",
					"annotation": "Plays the guiro long guiro stroke for about 0.3 s (a MIDI note runs it for as long as it is held).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Guiro Long Trigger",
							"parameter_shortname": "L",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"off",
								"on"
							]
						}
					},
					"presentation": 1,
					"presentation_rect": [
						96.0,
						106.0,
						26.0,
						16.0
					],
					"patching_rect": [
						1740,
						1340,
						26,
						16
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "msg_guHTrig",
					"maxclass": "message",
					"text": "trig 12 100",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1200,
						20,
						80,
						22
					]
				}
			},
			{
				"box": {
					"id": "rb_guHTrig",
					"maxclass": "newobj",
					"text": "route bang",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						1060,
						530,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "sel_guHTrig",
					"maxclass": "newobj",
					"text": "sel 1",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						1060,
						500,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "guHTrig",
					"varname": "guHTrig",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"mode": 0,
					"text": "H",
					"fontname": "Ableton Sans Bold",
					"fontsize": 8.5,
					"parameter_enable": 1,
					"annotation_name": "Guiro Short Trigger",
					"annotation": "Plays the guiro short guiro stroke for about 0.3 s (a MIDI note runs it for as long as it is held).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Guiro Short Trigger",
							"parameter_shortname": "H",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"off",
								"on"
							]
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						106.0,
						26.0,
						16.0
					],
					"patching_rect": [
						2090,
						1280,
						26,
						16
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "lbl_gu",
					"maxclass": "comment",
					"text": "GUIRO",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Bold",
					"fontsize": 9,
					"varname": "lbl_gu",
					"textcolor": [
						0.85,
						0.85,
						0.85,
						1.0
					],
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						88.0,
						60.0,
						14.0
					],
					"patching_rect": [
						2020,
						1280,
						60,
						14
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_tbPan",
					"maxclass": "newobj",
					"text": "prepend tbPan",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1060,
						410,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "tbPan",
					"varname": "tbPan",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Tambourine Pan",
					"annotation": "Tambourine position in the stereo field. The CR-78 itself is mono.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Tambourine Pan",
							"parameter_shortname": "Pan",
							"parameter_type": 0,
							"parameter_mmin": -100.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.0f"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						672.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1880,
						1280,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_tbLvl",
					"maxclass": "newobj",
					"text": "prepend tbLvl",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1060,
						350,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "tbLvl",
					"varname": "tbLvl",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Tambourine Level",
					"annotation": "Output level, in the service notes' volts peak-to-peak: the default is the factory amplitude (0.25 Vpp).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Tambourine Level",
							"parameter_shortname": "Level",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.25
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.2f Vpp"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						624.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1740,
						1280,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_tbShake",
					"maxclass": "newobj",
					"text": "prepend tbShake",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1060,
						290,
						105,
						22
					]
				}
			},
			{
				"box": {
					"id": "tbShake",
					"varname": "tbShake",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"mode": 1,
					"text": "Shake",
					"texton": "Shake",
					"fontname": "Ableton Sans Bold",
					"fontsize": 8.5,
					"parameter_enable": 1,
					"annotation_name": "Tambourine Shake",
					"annotation": "When on, each hit kicks the envelope a second time 70 ms later (the board has two trigger lines into it): a double shake.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Tambourine Shake",
							"parameter_shortname": "Shake",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"off",
								"on"
							]
						}
					},
					"presentation": 1,
					"presentation_rect": [
						578.0,
						20.0,
						44.0,
						26.0
					],
					"patching_rect": [
						1600,
						1280,
						44,
						26
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_tbTone",
					"maxclass": "newobj",
					"text": "prepend tbTone",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1060,
						230,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "tbTone",
					"varname": "tbTone",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Tambourine Tone",
					"annotation": "Frequency of the tank the noise rings (about 4.5 kHz, from forum reports).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Tambourine Tone",
							"parameter_shortname": "Tone",
							"parameter_type": 0,
							"parameter_mmin": -12.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f st"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						528.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						2020,
						1220,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_tbDec",
					"maxclass": "newobj",
					"text": "prepend tbDec",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1060,
						170,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "tbDec",
					"varname": "tbDec",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Tambourine Decay",
					"annotation": "Decay trim pot. 0 is the factory time (to 1/10 amplitude); each +1 doubles it, each -1 halves it (x0.25 to x4).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Tambourine Decay",
							"parameter_shortname": "Decay",
							"parameter_type": 0,
							"parameter_mmin": -2.0,
							"parameter_mmax": 2.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f oct"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						480.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1880,
						1220,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "msg_tbTrig",
					"maxclass": "message",
					"text": "trig 6 100",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1200,
						20,
						80,
						22
					]
				}
			},
			{
				"box": {
					"id": "rb_tbTrig",
					"maxclass": "newobj",
					"text": "route bang",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						1060,
						110,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "sel_tbTrig",
					"maxclass": "newobj",
					"text": "sel 1",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						1060,
						80,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "tbTrig",
					"varname": "tbTrig",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"mode": 0,
					"text": "TRIG",
					"fontname": "Ableton Sans Bold",
					"fontsize": 8.5,
					"parameter_enable": 1,
					"annotation_name": "Tambourine Trigger",
					"annotation": "Plays tambourine (velocity 100), like its MIDI note.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Tambourine Trigger",
							"parameter_shortname": "TRIG",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"off",
								"on"
							]
						}
					},
					"presentation": 1,
					"presentation_rect": [
						420.0,
						24.0,
						54.0,
						16.0
					],
					"patching_rect": [
						1670,
						1220,
						54,
						16
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "lbl_tb",
					"maxclass": "comment",
					"text": "TAMBOURINE",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Bold",
					"fontsize": 9,
					"varname": "lbl_tb",
					"textcolor": [
						0.85,
						0.85,
						0.85,
						1.0
					],
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						420.0,
						6.0,
						60.0,
						14.0
					],
					"patching_rect": [
						1600,
						1220,
						60,
						14
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_cbPan",
					"maxclass": "newobj",
					"text": "prepend cbPan",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						800,
						1190,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "cbPan",
					"varname": "cbPan",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Cowbell Pan",
					"annotation": "Cowbell position in the stereo field. The CR-78 itself is mono.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Cowbell Pan",
							"parameter_shortname": "Pan",
							"parameter_type": 0,
							"parameter_mmin": -100.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.0f"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						320.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						2020,
						1160,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_cbLvl",
					"maxclass": "newobj",
					"text": "prepend cbLvl",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						800,
						1130,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "cbLvl",
					"varname": "cbLvl",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Cowbell Level",
					"annotation": "Output level, in the service notes' volts peak-to-peak: the default is the factory amplitude (0.2 Vpp).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Cowbell Level",
							"parameter_shortname": "Level",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.2
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.2f Vpp"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						272.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1880,
						1160,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_cbTone",
					"maxclass": "newobj",
					"text": "prepend cbTone",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						800,
						1070,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "cbTone",
					"varname": "cbTone",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Cowbell Tone",
					"annotation": "The LC tank after the cowbell VCA. Its value is not legible in the scan: about 2.9 kHz is my estimate.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Cowbell Tone",
							"parameter_shortname": "Tone",
							"parameter_type": 0,
							"parameter_mmin": -12.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f st"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						224.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1740,
						1160,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_cbDec",
					"maxclass": "newobj",
					"text": "prepend cbDec",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						800,
						1010,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "cbDec",
					"varname": "cbDec",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Cowbell Decay",
					"annotation": "Decay trim pot. 0 is the factory time (to 1/10 amplitude); each +1 doubles it, each -1 halves it (x0.25 to x4).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Cowbell Decay",
							"parameter_shortname": "Decay",
							"parameter_type": 0,
							"parameter_mmin": -2.0,
							"parameter_mmax": 2.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f oct"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						176.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1600,
						1160,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_cbTune",
					"maxclass": "newobj",
					"text": "prepend cbTune",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						800,
						950,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "cbTune",
					"varname": "cbTune",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Cowbell Tune",
					"annotation": "Moves both oscillators (800 and 555 Hz) together, up to an octave either way.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Cowbell Tune",
							"parameter_shortname": "Tune",
							"parameter_type": 0,
							"parameter_mmin": -12.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f st"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						128.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						2020,
						1100,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "msg_cbTrig",
					"maxclass": "message",
					"text": "trig 7 100",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1200,
						20,
						80,
						22
					]
				}
			},
			{
				"box": {
					"id": "rb_cbTrig",
					"maxclass": "newobj",
					"text": "route bang",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						800,
						890,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "sel_cbTrig",
					"maxclass": "newobj",
					"text": "sel 1",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						800,
						860,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "cbTrig",
					"varname": "cbTrig",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"mode": 0,
					"text": "TRIG",
					"fontname": "Ableton Sans Bold",
					"fontsize": 8.5,
					"parameter_enable": 1,
					"annotation_name": "Cowbell Trigger",
					"annotation": "Plays cowbell (velocity 100), like its MIDI note.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Cowbell Trigger",
							"parameter_shortname": "TRIG",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"off",
								"on"
							]
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						24.0,
						54.0,
						16.0
					],
					"patching_rect": [
						1810,
						1100,
						54,
						16
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "lbl_cb",
					"maxclass": "comment",
					"text": "COWBELL",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Bold",
					"fontsize": 9,
					"varname": "lbl_cb",
					"textcolor": [
						0.85,
						0.85,
						0.85,
						1.0
					],
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						6.0,
						60.0,
						14.0
					],
					"patching_rect": [
						1740,
						1100,
						60,
						14
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_mbPan",
					"maxclass": "newobj",
					"text": "prepend mbPan",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						800,
						770,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "mbPan",
					"varname": "mbPan",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Metallic Beat Pan",
					"annotation": "Metallic Beat position in the stereo field. The CR-78 itself is mono.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Metallic Beat Pan",
							"parameter_shortname": "Pan",
							"parameter_type": 0,
							"parameter_mmin": -100.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.0f"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						720.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1600,
						1100,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_mbLvl",
					"maxclass": "newobj",
					"text": "prepend mbLvl",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						800,
						710,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "mbLvl",
					"varname": "mbLvl",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Metallic Beat Level",
					"annotation": "Output level, in the service notes' volts peak-to-peak: the default is the factory amplitude (0.35 Vpp).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Metallic Beat Level",
							"parameter_shortname": "Level",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.35
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.2f Vpp"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						672.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						2020,
						1040,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_mbHats",
					"maxclass": "newobj",
					"text": "prepend mbHats",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						800,
						650,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "mbHats",
					"varname": "mbHats",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"mode": 1,
					"text": "On Hats",
					"texton": "On Hats",
					"fontname": "Ableton Sans Bold",
					"fontsize": 8.5,
					"parameter_enable": 1,
					"annotation_name": "Metallic Beat On Hats",
					"annotation": "When on, hi-hat and cymbal notes also fire the Metallic Beat, like the hat/cymbal layer on the real machine.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Metallic Beat On Hats",
							"parameter_shortname": "On Hats",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"off",
								"on"
							]
						}
					},
					"presentation": 1,
					"presentation_rect": [
						626.0,
						102.0,
						44.0,
						26.0
					],
					"patching_rect": [
						1880,
						1040,
						44,
						26
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_mbAmt",
					"maxclass": "newobj",
					"text": "prepend mbAmt",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						800,
						590,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "mbAmt",
					"varname": "mbAmt",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Metallic Beat Amount",
					"annotation": "How loud the Metallic Beat is when it is layered on hi-hat and cymbal (see On Hats), as a share of its own Level.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Metallic Beat Amount",
							"parameter_shortname": "Amount",
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
					"presentation": 1,
					"presentation_rect": [
						576.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1740,
						1040,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_mbDec",
					"maxclass": "newobj",
					"text": "prepend mbDec",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						800,
						530,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "mbDec",
					"varname": "mbDec",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Metallic Beat Decay",
					"annotation": "Decay trim pot. 0 is the factory time (to 1/10 amplitude); each +1 doubles it, each -1 halves it (x0.25 to x4).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Metallic Beat Decay",
							"parameter_shortname": "Decay",
							"parameter_type": 0,
							"parameter_mmin": -2.0,
							"parameter_mmax": 2.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f oct"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						528.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1600,
						1040,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_mbTune",
					"maxclass": "newobj",
					"text": "prepend mbTune",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						800,
						470,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "mbTune",
					"varname": "mbTune",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Metallic Beat Tune",
					"annotation": "Moves all three square oscillators (6170, 5620 and 4080 Hz) together, up to an octave either way.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Metallic Beat Tune",
							"parameter_shortname": "Tune",
							"parameter_type": 0,
							"parameter_mmin": -12.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f st"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						480.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						2020,
						980,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "msg_mbTrig",
					"maxclass": "message",
					"text": "trig 4 100",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1200,
						20,
						80,
						22
					]
				}
			},
			{
				"box": {
					"id": "rb_mbTrig",
					"maxclass": "newobj",
					"text": "route bang",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						800,
						410,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "sel_mbTrig",
					"maxclass": "newobj",
					"text": "sel 1",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						800,
						380,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "mbTrig",
					"varname": "mbTrig",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"mode": 0,
					"text": "TRIG",
					"fontname": "Ableton Sans Bold",
					"fontsize": 8.5,
					"parameter_enable": 1,
					"annotation_name": "Metallic Beat Trigger",
					"annotation": "Plays metallic beat (velocity 100), like its MIDI note.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Metallic Beat Trigger",
							"parameter_shortname": "TRIG",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"off",
								"on"
							]
						}
					},
					"presentation": 1,
					"presentation_rect": [
						420.0,
						106.0,
						54.0,
						16.0
					],
					"patching_rect": [
						1810,
						980,
						54,
						16
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "lbl_mb",
					"maxclass": "comment",
					"text": "MET. BEAT",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Bold",
					"fontsize": 9,
					"varname": "lbl_mb",
					"textcolor": [
						0.85,
						0.85,
						0.85,
						1.0
					],
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						420.0,
						88.0,
						60.0,
						14.0
					],
					"patching_rect": [
						1740,
						980,
						60,
						14
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_maPan",
					"maxclass": "newobj",
					"text": "prepend maPan",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						800,
						290,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "maPan",
					"varname": "maPan",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Maracas Pan",
					"annotation": "Maracas position in the stereo field. The CR-78 itself is mono.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Maracas Pan",
							"parameter_shortname": "Pan",
							"parameter_type": 0,
							"parameter_mmin": -100.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.0f"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						224.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1600,
						980,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_maLvl",
					"maxclass": "newobj",
					"text": "prepend maLvl",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						800,
						230,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "maLvl",
					"varname": "maLvl",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Maracas Level",
					"annotation": "Output level, in the service notes' volts peak-to-peak: the default is the factory amplitude (0.4 Vpp).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Maracas Level",
							"parameter_shortname": "Level",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.4
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.2f Vpp"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						176.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						2020,
						920,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_maDec",
					"maxclass": "newobj",
					"text": "prepend maDec",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						800,
						170,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "maDec",
					"varname": "maDec",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Maracas Decay",
					"annotation": "How long the noise burst rings. 0 is the factory time (to 1/10 amplitude); each +1 doubles it.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Maracas Decay",
							"parameter_shortname": "Decay",
							"parameter_type": 0,
							"parameter_mmin": -2.0,
							"parameter_mmax": 2.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f oct"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						128.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1880,
						920,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "msg_maTrig",
					"maxclass": "message",
					"text": "trig 11 100",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1200,
						20,
						80,
						22
					]
				}
			},
			{
				"box": {
					"id": "rb_maTrig",
					"maxclass": "newobj",
					"text": "route bang",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						800,
						110,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "sel_maTrig",
					"maxclass": "newobj",
					"text": "sel 1",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						800,
						80,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "maTrig",
					"varname": "maTrig",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"mode": 0,
					"text": "TRIG",
					"fontname": "Ableton Sans Bold",
					"fontsize": 8.5,
					"parameter_enable": 1,
					"annotation_name": "Maracas Trigger",
					"annotation": "Plays maracas (velocity 100), like its MIDI note.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Maracas Trigger",
							"parameter_shortname": "TRIG",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"off",
								"on"
							]
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						106.0,
						54.0,
						16.0
					],
					"patching_rect": [
						1670,
						920,
						54,
						16
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "lbl_ma",
					"maxclass": "comment",
					"text": "MARACAS",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Bold",
					"fontsize": 9,
					"varname": "lbl_ma",
					"textcolor": [
						0.85,
						0.85,
						0.85,
						1.0
					],
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						88.0,
						60.0,
						14.0
					],
					"patching_rect": [
						1600,
						920,
						60,
						14
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_cyPan",
					"maxclass": "newobj",
					"text": "prepend cyPan",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						540,
						1190,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "cyPan",
					"varname": "cyPan",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Cymbal Pan",
					"annotation": "Cymbal position in the stereo field. The CR-78 itself is mono.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Cymbal Pan",
							"parameter_shortname": "Pan",
							"parameter_type": 0,
							"parameter_mmin": -100.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.0f"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						576.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						2020,
						860,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_cyLvl",
					"maxclass": "newobj",
					"text": "prepend cyLvl",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						540,
						1130,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "cyLvl",
					"varname": "cyLvl",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Cymbal Level",
					"annotation": "Output level, in the service notes' volts peak-to-peak: the default is the factory amplitude (0.4 Vpp).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Cymbal Level",
							"parameter_shortname": "Level",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.4
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.2f Vpp"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						528.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1880,
						860,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_cyDec",
					"maxclass": "newobj",
					"text": "prepend cyDec",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						540,
						1070,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "cyDec",
					"varname": "cyDec",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Cymbal Decay",
					"annotation": "How long the noise burst rings. 0 is the factory time (to 1/10 amplitude); each +1 doubles it.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Cymbal Decay",
							"parameter_shortname": "Decay",
							"parameter_type": 0,
							"parameter_mmin": -2.0,
							"parameter_mmax": 2.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f oct"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						480.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1740,
						860,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "msg_cyTrig",
					"maxclass": "message",
					"text": "trig 5 100",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1200,
						20,
						80,
						22
					]
				}
			},
			{
				"box": {
					"id": "rb_cyTrig",
					"maxclass": "newobj",
					"text": "route bang",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						540,
						1010,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "sel_cyTrig",
					"maxclass": "newobj",
					"text": "sel 1",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						540,
						980,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "cyTrig",
					"varname": "cyTrig",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"mode": 0,
					"text": "TRIG",
					"fontname": "Ableton Sans Bold",
					"fontsize": 8.5,
					"parameter_enable": 1,
					"annotation_name": "Cymbal Trigger",
					"annotation": "Plays cymbal (velocity 100), like its MIDI note.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Cymbal Trigger",
							"parameter_shortname": "TRIG",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"off",
								"on"
							]
						}
					},
					"presentation": 1,
					"presentation_rect": [
						420.0,
						24.0,
						54.0,
						16.0
					],
					"patching_rect": [
						2090,
						800,
						54,
						16
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "lbl_cy",
					"maxclass": "comment",
					"text": "CYMBAL",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Bold",
					"fontsize": 9,
					"varname": "lbl_cy",
					"textcolor": [
						0.85,
						0.85,
						0.85,
						1.0
					],
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						420.0,
						6.0,
						60.0,
						14.0
					],
					"patching_rect": [
						2020,
						800,
						60,
						14
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_hhPan",
					"maxclass": "newobj",
					"text": "prepend hhPan",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						540,
						890,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "hhPan",
					"varname": "hhPan",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Hi-Hat Pan",
					"annotation": "Hi-Hat position in the stereo field. The CR-78 itself is mono.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Hi-Hat Pan",
							"parameter_shortname": "Pan",
							"parameter_type": 0,
							"parameter_mmin": -100.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.0f"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						272.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1880,
						800,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_hhLvl",
					"maxclass": "newobj",
					"text": "prepend hhLvl",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						540,
						830,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "hhLvl",
					"varname": "hhLvl",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Hi-Hat Level",
					"annotation": "Output level, in the service notes' volts peak-to-peak: the default is the factory amplitude (0.4 Vpp).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Hi-Hat Level",
							"parameter_shortname": "Level",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.4
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.2f Vpp"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						224.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1740,
						800,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_hatTone",
					"maxclass": "newobj",
					"text": "prepend hatTone",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						540,
						770,
						105,
						22
					]
				}
			},
			{
				"box": {
					"id": "hatTone",
					"varname": "hatTone",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Hat Cym Maracas Tone",
					"annotation": "The LC band-pass that hi-hat, cymbal and maracas all pass through (one shared VCA and tank on the real board). Its factory frequency is not legible in the scan: 6.5 kHz is my estimate.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Hat Cym Maracas Tone",
							"parameter_shortname": "Tone",
							"parameter_type": 0,
							"parameter_mmin": -12.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f st"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						176.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1600,
						800,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_hhDec",
					"maxclass": "newobj",
					"text": "prepend hhDec",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						540,
						710,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "hhDec",
					"varname": "hhDec",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Hi-Hat Decay",
					"annotation": "How long the noise burst rings. 0 is the factory time (to 1/10 amplitude); each +1 doubles it.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Hi-Hat Decay",
							"parameter_shortname": "Decay",
							"parameter_type": 0,
							"parameter_mmin": -2.0,
							"parameter_mmax": 2.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f oct"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						128.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						2020,
						740,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "msg_hhTrig",
					"maxclass": "message",
					"text": "trig 3 100",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1200,
						20,
						80,
						22
					]
				}
			},
			{
				"box": {
					"id": "rb_hhTrig",
					"maxclass": "newobj",
					"text": "route bang",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						540,
						650,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "sel_hhTrig",
					"maxclass": "newobj",
					"text": "sel 1",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						540,
						620,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "hhTrig",
					"varname": "hhTrig",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"mode": 0,
					"text": "TRIG",
					"fontname": "Ableton Sans Bold",
					"fontsize": 8.5,
					"parameter_enable": 1,
					"annotation_name": "Hi-Hat Trigger",
					"annotation": "Plays hi-hat (velocity 100), like its MIDI note.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Hi-Hat Trigger",
							"parameter_shortname": "TRIG",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"off",
								"on"
							]
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						24.0,
						54.0,
						16.0
					],
					"patching_rect": [
						1810,
						740,
						54,
						16
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "lbl_hh",
					"maxclass": "comment",
					"text": "HI-HAT",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Bold",
					"fontsize": 9,
					"varname": "lbl_hh",
					"textcolor": [
						0.85,
						0.85,
						0.85,
						1.0
					],
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						6.0,
						60.0,
						14.0
					],
					"patching_rect": [
						1740,
						740,
						60,
						14
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_lcPan",
					"maxclass": "newobj",
					"text": "prepend lcPan",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						540,
						530,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "lcPan",
					"varname": "lcPan",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Low Conga Pan",
					"annotation": "Low Conga position in the stereo field. The CR-78 itself is mono.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Low Conga Pan",
							"parameter_shortname": "Pan",
							"parameter_type": 0,
							"parameter_mmin": -100.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.0f"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						272.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1600,
						740,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_lcLvl",
					"maxclass": "newobj",
					"text": "prepend lcLvl",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						540,
						470,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "lcLvl",
					"varname": "lcLvl",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Low Conga Level",
					"annotation": "Output level, in the service notes' volts peak-to-peak: the default is the factory amplitude (0.3 Vpp).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Low Conga Level",
							"parameter_shortname": "Level",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.3
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.2f Vpp"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						224.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						2020,
						680,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_lcDec",
					"maxclass": "newobj",
					"text": "prepend lcDec",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						540,
						410,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "lcDec",
					"varname": "lcDec",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Low Conga Decay",
					"annotation": "Decay trim pot. 0 is the factory time (to 1/10 amplitude); each +1 doubles it, each -1 halves it (x0.25 to x4).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Low Conga Decay",
							"parameter_shortname": "Decay",
							"parameter_type": 0,
							"parameter_mmin": -2.0,
							"parameter_mmax": 2.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f oct"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						176.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1880,
						680,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_lcTune",
					"maxclass": "newobj",
					"text": "prepend lcTune",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						540,
						350,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "lcTune",
					"varname": "lcTune",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Low Conga Tune",
					"annotation": "The tuning pot of the ringing oscillator: up to an octave either way. 0 is the factory frequency.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Low Conga Tune",
							"parameter_shortname": "Tune",
							"parameter_type": 0,
							"parameter_mmin": -12.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f st"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						128.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1740,
						680,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "msg_lcTrig",
					"maxclass": "message",
					"text": "trig 10 100",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1200,
						20,
						80,
						22
					]
				}
			},
			{
				"box": {
					"id": "rb_lcTrig",
					"maxclass": "newobj",
					"text": "route bang",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						540,
						290,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "sel_lcTrig",
					"maxclass": "newobj",
					"text": "sel 1",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						540,
						260,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "lcTrig",
					"varname": "lcTrig",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"mode": 0,
					"text": "TRIG",
					"fontname": "Ableton Sans Bold",
					"fontsize": 8.5,
					"parameter_enable": 1,
					"annotation_name": "Low Conga Trigger",
					"annotation": "Plays low conga (velocity 100), like its MIDI note.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Low Conga Trigger",
							"parameter_shortname": "TRIG",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"off",
								"on"
							]
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						106.0,
						54.0,
						16.0
					],
					"patching_rect": [
						2090,
						620,
						54,
						16
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "lbl_lc",
					"maxclass": "comment",
					"text": "LOW CONGA",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Bold",
					"fontsize": 9,
					"varname": "lbl_lc",
					"textcolor": [
						0.85,
						0.85,
						0.85,
						1.0
					],
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						88.0,
						60.0,
						14.0
					],
					"patching_rect": [
						2020,
						620,
						60,
						14
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_lbPan",
					"maxclass": "newobj",
					"text": "prepend lbPan",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						540,
						170,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "lbPan",
					"varname": "lbPan",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Low Bongo Pan",
					"annotation": "Low Bongo position in the stereo field. The CR-78 itself is mono.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Low Bongo Pan",
							"parameter_shortname": "Pan",
							"parameter_type": 0,
							"parameter_mmin": -100.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.0f"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						624.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1880,
						620,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_lbLvl",
					"maxclass": "newobj",
					"text": "prepend lbLvl",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						540,
						110,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "lbLvl",
					"varname": "lbLvl",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Low Bongo Level",
					"annotation": "Output level, in the service notes' volts peak-to-peak: the default is the factory amplitude (0.15 Vpp).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Low Bongo Level",
							"parameter_shortname": "Level",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.15
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.2f Vpp"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						576.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1740,
						620,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_lbDec",
					"maxclass": "newobj",
					"text": "prepend lbDec",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						540,
						50,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "lbDec",
					"varname": "lbDec",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Low Bongo Decay",
					"annotation": "Decay trim pot. 0 is the factory time (to 1/10 amplitude); each +1 doubles it, each -1 halves it (x0.25 to x4).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Low Bongo Decay",
							"parameter_shortname": "Decay",
							"parameter_type": 0,
							"parameter_mmin": -2.0,
							"parameter_mmax": 2.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f oct"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						528.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1600,
						620,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_lbTune",
					"maxclass": "newobj",
					"text": "prepend lbTune",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						1190,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "lbTune",
					"varname": "lbTune",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Low Bongo Tune",
					"annotation": "The tuning pot of the ringing oscillator: up to an octave either way. 0 is the factory frequency.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Low Bongo Tune",
							"parameter_shortname": "Tune",
							"parameter_type": 0,
							"parameter_mmin": -12.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f st"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						480.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						2020,
						560,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "msg_lbTrig",
					"maxclass": "message",
					"text": "trig 9 100",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1200,
						20,
						80,
						22
					]
				}
			},
			{
				"box": {
					"id": "rb_lbTrig",
					"maxclass": "newobj",
					"text": "route bang",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						280,
						1130,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "sel_lbTrig",
					"maxclass": "newobj",
					"text": "sel 1",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						280,
						1100,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "lbTrig",
					"varname": "lbTrig",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"mode": 0,
					"text": "TRIG",
					"fontname": "Ableton Sans Bold",
					"fontsize": 8.5,
					"parameter_enable": 1,
					"annotation_name": "Low Bongo Trigger",
					"annotation": "Plays low bongo (velocity 100), like its MIDI note.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Low Bongo Trigger",
							"parameter_shortname": "TRIG",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"off",
								"on"
							]
						}
					},
					"presentation": 1,
					"presentation_rect": [
						420.0,
						24.0,
						54.0,
						16.0
					],
					"patching_rect": [
						1810,
						560,
						54,
						16
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "lbl_lb",
					"maxclass": "comment",
					"text": "LOW BONGO",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Bold",
					"fontsize": 9,
					"varname": "lbl_lb",
					"textcolor": [
						0.85,
						0.85,
						0.85,
						1.0
					],
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						420.0,
						6.0,
						60.0,
						14.0
					],
					"patching_rect": [
						1740,
						560,
						60,
						14
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_hbPan",
					"maxclass": "newobj",
					"text": "prepend hbPan",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						1010,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "hbPan",
					"varname": "hbPan",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "High Bongo Pan",
					"annotation": "High Bongo position in the stereo field. The CR-78 itself is mono.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "High Bongo Pan",
							"parameter_shortname": "Pan",
							"parameter_type": 0,
							"parameter_mmin": -100.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.0f"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						272.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1600,
						560,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_hbLvl",
					"maxclass": "newobj",
					"text": "prepend hbLvl",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						950,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "hbLvl",
					"varname": "hbLvl",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "High Bongo Level",
					"annotation": "Output level, in the service notes' volts peak-to-peak: the default is the factory amplitude (0.15 Vpp).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "High Bongo Level",
							"parameter_shortname": "Level",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.15
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.2f Vpp"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						224.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						2020,
						500,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_hbDec",
					"maxclass": "newobj",
					"text": "prepend hbDec",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						890,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "hbDec",
					"varname": "hbDec",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "High Bongo Decay",
					"annotation": "Decay trim pot. 0 is the factory time (to 1/10 amplitude); each +1 doubles it, each -1 halves it (x0.25 to x4).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "High Bongo Decay",
							"parameter_shortname": "Decay",
							"parameter_type": 0,
							"parameter_mmin": -2.0,
							"parameter_mmax": 2.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f oct"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						176.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1880,
						500,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_hbTune",
					"maxclass": "newobj",
					"text": "prepend hbTune",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						830,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "hbTune",
					"varname": "hbTune",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "High Bongo Tune",
					"annotation": "The tuning pot of the ringing oscillator: up to an octave either way. 0 is the factory frequency.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "High Bongo Tune",
							"parameter_shortname": "Tune",
							"parameter_type": 0,
							"parameter_mmin": -12.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f st"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						128.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1740,
						500,
						48,
						56
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "msg_hbTrig",
					"maxclass": "message",
					"text": "trig 8 100",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1200,
						20,
						80,
						22
					]
				}
			},
			{
				"box": {
					"id": "rb_hbTrig",
					"maxclass": "newobj",
					"text": "route bang",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						280,
						770,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "sel_hbTrig",
					"maxclass": "newobj",
					"text": "sel 1",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						280,
						740,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "hbTrig",
					"varname": "hbTrig",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"mode": 0,
					"text": "TRIG",
					"fontname": "Ableton Sans Bold",
					"fontsize": 8.5,
					"parameter_enable": 1,
					"annotation_name": "High Bongo Trigger",
					"annotation": "Plays high bongo (velocity 100), like its MIDI note.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "High Bongo Trigger",
							"parameter_shortname": "TRIG",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"off",
								"on"
							]
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						24.0,
						54.0,
						16.0
					],
					"patching_rect": [
						2090,
						440,
						54,
						16
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "lbl_hb",
					"maxclass": "comment",
					"text": "HIGH BONGO",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Bold",
					"fontsize": 9,
					"varname": "lbl_hb",
					"textcolor": [
						0.85,
						0.85,
						0.85,
						1.0
					],
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						6.0,
						60.0,
						14.0
					],
					"patching_rect": [
						2020,
						440,
						60,
						14
					],
					"hidden": 1
				}
			},
			{
				"box": {
					"id": "pre_clPan",
					"maxclass": "newobj",
					"text": "prepend clPan",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						650,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "clPan",
					"varname": "clPan",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Clave Pan",
					"annotation": "Clave position in the stereo field. The CR-78 itself is mono.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Clave Pan",
							"parameter_shortname": "Pan",
							"parameter_type": 0,
							"parameter_mmin": -100.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.0f"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						624.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1880,
						440,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "pre_clLvl",
					"maxclass": "newobj",
					"text": "prepend clLvl",
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
					"id": "clLvl",
					"varname": "clLvl",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Clave Level",
					"annotation": "Output level, in the service notes' volts peak-to-peak: the default is the factory amplitude (0.15 Vpp).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Clave Level",
							"parameter_shortname": "Level",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.15
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.2f Vpp"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						576.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1740,
						440,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "pre_clDec",
					"maxclass": "newobj",
					"text": "prepend clDec",
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
					"id": "clDec",
					"varname": "clDec",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Clave Decay",
					"annotation": "Decay trim pot. 0 is the factory time (to 1/10 amplitude); each +1 doubles it, each -1 halves it (x0.25 to x4).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Clave Decay",
							"parameter_shortname": "Decay",
							"parameter_type": 0,
							"parameter_mmin": -2.0,
							"parameter_mmax": 2.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f oct"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						528.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1600,
						440,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "pre_clTune",
					"maxclass": "newobj",
					"text": "prepend clTune",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						470,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "clTune",
					"varname": "clTune",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Clave Tune",
					"annotation": "The inductor of the LC tank: up to an octave either way. 0 is the factory frequency.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Clave Tune",
							"parameter_shortname": "Tune",
							"parameter_type": 0,
							"parameter_mmin": -12.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f st"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						480.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						2020,
						380,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "msg_clTrig",
					"maxclass": "message",
					"text": "trig 14 100",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1200,
						20,
						80,
						22
					]
				}
			},
			{
				"box": {
					"id": "rb_clTrig",
					"maxclass": "newobj",
					"text": "route bang",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						280,
						410,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "sel_clTrig",
					"maxclass": "newobj",
					"text": "sel 1",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						280,
						380,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "clTrig",
					"varname": "clTrig",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"mode": 0,
					"text": "TRIG",
					"fontname": "Ableton Sans Bold",
					"fontsize": 8.5,
					"parameter_enable": 1,
					"annotation_name": "Clave Trigger",
					"annotation": "Plays clave (velocity 100), like its MIDI note.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Clave Trigger",
							"parameter_shortname": "TRIG",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"off",
								"on"
							]
						}
					},
					"presentation": 1,
					"presentation_rect": [
						420.0,
						106.0,
						54.0,
						16.0
					],
					"patching_rect": [
						1810,
						380,
						54,
						16
					]
				}
			},
			{
				"box": {
					"id": "lbl_cl",
					"maxclass": "comment",
					"text": "CLAVE",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Bold",
					"fontsize": 9,
					"varname": "lbl_cl",
					"textcolor": [
						0.85,
						0.85,
						0.85,
						1.0
					],
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						420.0,
						88.0,
						60.0,
						14.0
					],
					"patching_rect": [
						1740,
						380,
						60,
						14
					]
				}
			},
			{
				"box": {
					"id": "pre_rsPan",
					"maxclass": "newobj",
					"text": "prepend rsPan",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						290,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "rsPan",
					"varname": "rsPan",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Rimshot Pan",
					"annotation": "Rimshot position in the stereo field. The CR-78 itself is mono.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Rimshot Pan",
							"parameter_shortname": "Pan",
							"parameter_type": 0,
							"parameter_mmin": -100.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.0f"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						272.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1600,
						380,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "pre_rsLvl",
					"maxclass": "newobj",
					"text": "prepend rsLvl",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						230,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "rsLvl",
					"varname": "rsLvl",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Rimshot Level",
					"annotation": "Output level, in the service notes' volts peak-to-peak: the default is the factory amplitude (0.8 Vpp).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Rimshot Level",
							"parameter_shortname": "Level",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.8
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.2f Vpp"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						224.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						2020,
						320,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "pre_rsDec",
					"maxclass": "newobj",
					"text": "prepend rsDec",
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
					"id": "rsDec",
					"varname": "rsDec",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Rimshot Decay",
					"annotation": "Decay trim pot. 0 is the factory time (to 1/10 amplitude); each +1 doubles it, each -1 halves it (x0.25 to x4).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Rimshot Decay",
							"parameter_shortname": "Decay",
							"parameter_type": 0,
							"parameter_mmin": -2.0,
							"parameter_mmax": 2.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f oct"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						176.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1880,
						320,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "pre_rsTune",
					"maxclass": "newobj",
					"text": "prepend rsTune",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						110,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "rsTune",
					"varname": "rsTune",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Rimshot Tune",
					"annotation": "The inductor of the LC tank: up to an octave either way. 0 is the factory frequency.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Rimshot Tune",
							"parameter_shortname": "Tune",
							"parameter_type": 0,
							"parameter_mmin": -12.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f st"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						128.0,
						88.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1740,
						320,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "msg_rsTrig",
					"maxclass": "message",
					"text": "trig 1 100",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1200,
						20,
						80,
						22
					]
				}
			},
			{
				"box": {
					"id": "rb_rsTrig",
					"maxclass": "newobj",
					"text": "route bang",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						280,
						50,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "sel_rsTrig",
					"maxclass": "newobj",
					"text": "sel 1",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						280,
						20,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "rsTrig",
					"varname": "rsTrig",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"mode": 0,
					"text": "TRIG",
					"fontname": "Ableton Sans Bold",
					"fontsize": 8.5,
					"parameter_enable": 1,
					"annotation_name": "Rimshot Trigger",
					"annotation": "Plays rimshot (velocity 100), like its MIDI note.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Rimshot Trigger",
							"parameter_shortname": "TRIG",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"off",
								"on"
							]
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						106.0,
						54.0,
						16.0
					],
					"patching_rect": [
						2090,
						260,
						54,
						16
					]
				}
			},
			{
				"box": {
					"id": "lbl_rs",
					"maxclass": "comment",
					"text": "RIMSHOT",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Bold",
					"fontsize": 9,
					"varname": "lbl_rs",
					"textcolor": [
						0.85,
						0.85,
						0.85,
						1.0
					],
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						88.0,
						60.0,
						14.0
					],
					"patching_rect": [
						2020,
						260,
						60,
						14
					]
				}
			},
			{
				"box": {
					"id": "pre_sdPan",
					"maxclass": "newobj",
					"text": "prepend sdPan",
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
					"id": "sdPan",
					"varname": "sdPan",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Snare Pan",
					"annotation": "Snare position in the stereo field. The CR-78 itself is mono.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Snare Pan",
							"parameter_shortname": "Pan",
							"parameter_type": 0,
							"parameter_mmin": -100.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.0f"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						672.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1880,
						260,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "pre_sdLvl",
					"maxclass": "newobj",
					"text": "prepend sdLvl",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						1070,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "sdLvl",
					"varname": "sdLvl",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Snare Level",
					"annotation": "Output level, in the service notes' volts peak-to-peak: the default is the factory amplitude (0.4 Vpp).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Snare Level",
							"parameter_shortname": "Level",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.4
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.2f Vpp"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						624.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1740,
						260,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "pre_sdNoise",
					"maxclass": "newobj",
					"text": "prepend sdNoise",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						1010,
						105,
						22
					]
				}
			},
			{
				"box": {
					"id": "sdNoise",
					"varname": "sdNoise",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Snare Noise",
					"annotation": "Noise part of the snare, from the shared noise source. 100 % matches the CR-78 snare recording's noise level.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Snare Noise",
							"parameter_shortname": "Noise",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 200.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								100
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.0f %"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						576.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1600,
						260,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "pre_sdDec",
					"maxclass": "newobj",
					"text": "prepend sdDec",
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
					"id": "sdDec",
					"varname": "sdDec",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Snare Decay",
					"annotation": "Decay trim pot. 0 is the factory time (to 1/10 amplitude); each +1 doubles it, each -1 halves it (x0.25 to x4).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Snare Decay",
							"parameter_shortname": "Decay",
							"parameter_type": 0,
							"parameter_mmin": -2.0,
							"parameter_mmax": 2.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f oct"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						528.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						2020,
						200,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "pre_sdTune",
					"maxclass": "newobj",
					"text": "prepend sdTune",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						890,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "sdTune",
					"varname": "sdTune",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Snare Tune",
					"annotation": "The tuning pot of the ringing oscillator: up to an octave either way. 0 is the factory frequency.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Snare Tune",
							"parameter_shortname": "Tune",
							"parameter_type": 0,
							"parameter_mmin": -12.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f st"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						480.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1880,
						200,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "msg_sdTrig",
					"maxclass": "message",
					"text": "trig 2 100",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1200,
						20,
						80,
						22
					]
				}
			},
			{
				"box": {
					"id": "rb_sdTrig",
					"maxclass": "newobj",
					"text": "route bang",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						20,
						830,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "sel_sdTrig",
					"maxclass": "newobj",
					"text": "sel 1",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						20,
						800,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "sdTrig",
					"varname": "sdTrig",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"mode": 0,
					"text": "TRIG",
					"fontname": "Ableton Sans Bold",
					"fontsize": 8.5,
					"parameter_enable": 1,
					"annotation_name": "Snare Trigger",
					"annotation": "Plays snare (velocity 100), like its MIDI note.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Snare Trigger",
							"parameter_shortname": "TRIG",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"off",
								"on"
							]
						}
					},
					"presentation": 1,
					"presentation_rect": [
						420.0,
						24.0,
						54.0,
						16.0
					],
					"patching_rect": [
						1670,
						200,
						54,
						16
					]
				}
			},
			{
				"box": {
					"id": "lbl_sd",
					"maxclass": "comment",
					"text": "SNARE",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Bold",
					"fontsize": 9,
					"varname": "lbl_sd",
					"textcolor": [
						0.85,
						0.85,
						0.85,
						1.0
					],
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						420.0,
						6.0,
						60.0,
						14.0
					],
					"patching_rect": [
						1600,
						200,
						60,
						14
					]
				}
			},
			{
				"box": {
					"id": "pre_bdPan",
					"maxclass": "newobj",
					"text": "prepend bdPan",
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
					"id": "bdPan",
					"varname": "bdPan",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Bass Drum Pan",
					"annotation": "Bass Drum position in the stereo field. The CR-78 itself is mono.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Bass Drum Pan",
							"parameter_shortname": "Pan",
							"parameter_type": 0,
							"parameter_mmin": -100.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.0f"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						272.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						2020,
						140,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "pre_bdLvl",
					"maxclass": "newobj",
					"text": "prepend bdLvl",
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
					"id": "bdLvl",
					"varname": "bdLvl",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Bass Drum Level",
					"annotation": "Output level, in the service notes' volts peak-to-peak: the default is the factory amplitude (0.4 Vpp).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Bass Drum Level",
							"parameter_shortname": "Level",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0.4
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.2f Vpp"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						224.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1880,
						140,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "pre_bdDec",
					"maxclass": "newobj",
					"text": "prepend bdDec",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						590,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "bdDec",
					"varname": "bdDec",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Bass Drum Decay",
					"annotation": "Decay trim pot. 0 is the factory time (to 1/10 amplitude); each +1 doubles it, each -1 halves it (x0.25 to x4).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Bass Drum Decay",
							"parameter_shortname": "Decay",
							"parameter_type": 0,
							"parameter_mmin": -2.0,
							"parameter_mmax": 2.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f oct"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						176.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1740,
						140,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "pre_bdTune",
					"maxclass": "newobj",
					"text": "prepend bdTune",
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
					"id": "bdTune",
					"varname": "bdTune",
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"parameter_enable": 1,
					"annotation_name": "Bass Drum Tune",
					"annotation": "The tuning pot of the ringing oscillator: up to an octave either way. 0 is the factory frequency.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Bass Drum Tune",
							"parameter_shortname": "Tune",
							"parameter_type": 0,
							"parameter_mmin": -12.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+.2f st"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						128.0,
						6.0,
						48.0,
						56.0
					],
					"patching_rect": [
						1600,
						140,
						48,
						56
					]
				}
			},
			{
				"box": {
					"id": "msg_bdTrig",
					"maxclass": "message",
					"text": "trig 0 100",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						1200,
						20,
						80,
						22
					]
				}
			},
			{
				"box": {
					"id": "rb_bdTrig",
					"maxclass": "newobj",
					"text": "route bang",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						20,
						470,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "sel_bdTrig",
					"maxclass": "newobj",
					"text": "sel 1",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						20,
						440,
						40,
						22
					]
				}
			},
			{
				"box": {
					"id": "bdTrig",
					"varname": "bdTrig",
					"maxclass": "live.text",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"mode": 0,
					"text": "TRIG",
					"fontname": "Ableton Sans Bold",
					"fontsize": 8.5,
					"parameter_enable": 1,
					"annotation_name": "Bass Drum Trigger",
					"annotation": "Plays bass drum (velocity 100), like its MIDI note.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Bass Drum Trigger",
							"parameter_shortname": "TRIG",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 1.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"off",
								"on"
							]
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						24.0,
						54.0,
						16.0
					],
					"patching_rect": [
						1950,
						80,
						54,
						16
					]
				}
			},
			{
				"box": {
					"id": "lbl_bd",
					"maxclass": "comment",
					"text": "BASS DRUM",
					"numinlets": 1,
					"numoutlets": 0,
					"fontname": "Ableton Sans Bold",
					"fontsize": 9,
					"varname": "lbl_bd",
					"textcolor": [
						0.85,
						0.85,
						0.85,
						1.0
					],
					"saved_attribute_attributes": {
						"textcolor": {
							"expression": "themecolor.live_control_fg"
						}
					},
					"presentation": 1,
					"presentation_rect": [
						68.0,
						6.0,
						60.0,
						14.0
					],
					"patching_rect": [
						1880,
						80,
						60,
						14
					]
				}
			},
			{
				"box": {
					"id": "pre_pgtab",
					"maxclass": "newobj",
					"text": "prepend pg",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						350,
						70,
						22
					]
				}
			},
			{
				"box": {
					"id": "pgtab",
					"maxclass": "live.tab",
					"varname": "pgtab",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"",
						"",
						"float"
					],
					"num_lines_patching": 4,
					"num_lines_presentation": 4,
					"parameter_enable": 1,
					"annotation_name": "Page",
					"annotation": "Chooses which voices' controls are shown. Every voice keeps playing; Accent, Drive and Master on the right are always visible.",
					"fontname": "Ableton Sans Medium",
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						4.0,
						6.0,
						58.0,
						156.0
					],
					"patching_rect": [
						1740,
						80,
						58,
						156
					],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Page",
							"parameter_shortname": "Page",
							"parameter_type": 2,
							"parameter_mmin": 0.0,
							"parameter_mmax": 3.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 0,
							"parameter_enum": [
								"DRUMS",
								"LATIN",
								"NOISE",
								"PERC"
							],
							"parameter_invisible": 1
						}
					}
				}
			},
			{
				"box": {
					"id": "midi",
					"maxclass": "newobj",
					"text": "js cr_midi.js",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						290,
						91,
						22
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
					"id": "plugout",
					"maxclass": "newobj",
					"text": "plugout~",
					"numinlets": 2,
					"numoutlets": 0,
					"outlettype": [],
					"patching_rect": [
						20,
						200,
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
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"signal",
						"signal"
					],
					"patching_rect": [
						20,
						170,
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
									"code": "\nblep(t, dt) {\n\tbl = 0;\n\tif (t < dt) {\n\t\tx = t / dt;\n\t\tbl = x + x - x * x - 1;\n\t} else if (t > 1 - dt) {\n\t\tx = (t - 1) / dt;\n\t\tbl = x * x + x + x + 1;\n\t}\n\treturn bl;\n}\n\nParam bdTune(0);\nParam bdDec(0);\nParam bdLvl(0.4);\nParam bdPan(0);\nParam sdTune(0);\nParam sdDec(0);\nParam sdNoise(100);\nParam sdLvl(0.4);\nParam sdPan(0);\nParam rsTune(0);\nParam rsDec(0);\nParam rsLvl(0.8);\nParam rsPan(0);\nParam clTune(0);\nParam clDec(0);\nParam clLvl(0.15);\nParam clPan(0);\nParam hbTune(0);\nParam hbDec(0);\nParam hbLvl(0.15);\nParam hbPan(0);\nParam lbTune(0);\nParam lbDec(0);\nParam lbLvl(0.15);\nParam lbPan(0);\nParam lcTune(0);\nParam lcDec(0);\nParam lcLvl(0.3);\nParam lcPan(0);\nParam hhDec(0);\nParam hatTone(0);\nParam hhLvl(0.4);\nParam hhPan(0);\nParam cyDec(0);\nParam cyLvl(0.4);\nParam cyPan(0);\nParam maDec(0);\nParam maLvl(0.4);\nParam maPan(0);\nParam mbTune(0);\nParam mbDec(0);\nParam mbAmt(50);\nParam mbHats(0);\nParam mbLvl(0.35);\nParam mbPan(0);\nParam cbTune(0);\nParam cbDec(0);\nParam cbTone(0);\nParam cbLvl(0.2);\nParam cbPan(0);\nParam tbDec(0);\nParam tbTone(0);\nParam tbShake(0);\nParam tbLvl(0.25);\nParam tbPan(0);\nParam guRate(0);\nParam guTone(0);\nParam guDec(0);\nParam guLvl(0.3);\nParam guPan(0);\nParam accent(60);\nParam drive(0);\nParam master(100);\nParam tr0(0);\nParam tr1(0);\nParam tr2(0);\nParam tr3(0);\nParam tr4(0);\nParam tr5(0);\nParam tr6(0);\nParam tr7(0);\nParam tr8(0);\nParam tr9(0);\nParam tr10(0);\nParam tr11(0);\nParam tr12(0);\nParam tr13(0);\nParam tr14(0);\nParam vl0(1);\nParam vl1(1);\nParam vl2(1);\nParam vl3(1);\nParam vl4(1);\nParam vl5(1);\nParam vl6(1);\nParam vl7(1);\nParam vl8(1);\nParam vl9(1);\nParam vl10(1);\nParam vl11(1);\nParam vl12(1);\nParam vl13(1);\nParam vl14(1);\nParam gt12(0);\nParam gt13(0);\nHistory bdS(0);\nHistory bdQ(0);\nHistory pt0(0);\nHistory rsS(0);\nHistory rsQ(0);\nHistory pt1(0);\nHistory sdS(0);\nHistory sdQ(0);\nHistory pt2(0);\nHistory sdNe(0);\nHistory sdNz(0);\nHistory sdNh(0);\nHistory sdNy(0);\nHistory sdNp(0);\nHistory sdNl(0);\nHistory hhE(0);\nHistory hhi1(0);\nHistory hhi2(0);\nHistory pt3(0);\nHistory cyE(0);\nHistory cyi1(0);\nHistory cyi2(0);\nHistory pt5(0);\nHistory maE(0);\nHistory mai1(0);\nHistory mai2(0);\nHistory pt11(0);\nHistory mbE(0);\nHistory mbSl(0);\nHistory mbi1(0);\nHistory mbi2(0);\nHistory mbP0(0);\nHistory mbP1(0);\nHistory mbP2(0);\nHistory pt4(0);\nHistory mbHit(0);\nHistory tbE(0);\nHistory tbi1(0);\nHistory tbi2(0);\nHistory tbD(0);\nHistory tbG(0);\nHistory pt6(0);\nHistory cbE(0);\nHistory cbSl(0);\nHistory cbi1(0);\nHistory cbi2(0);\nHistory cbP1(0);\nHistory cbP2(0);\nHistory pt7(0);\nHistory hbS(0);\nHistory hbQ(0);\nHistory pt8(0);\nHistory lbS(0);\nHistory lbQ(0);\nHistory pt9(0);\nHistory lcS(0);\nHistory lcQ(0);\nHistory pt10(0);\nHistory gui1(0);\nHistory gui2(0);\nHistory guLo(0);\nHistory guA(0);\nHistory guPh(0);\nHistory guRt(0);\nHistory guT(0);\nHistory guH(0);\nHistory guGe(0);\nHistory guG(0);\nHistory guW(1);\nHistory pt12(0);\nHistory pt13(0);\nHistory clS(0);\nHistory clQ(0);\nHistory pt14(0);\n\naccA = accent * 0.01;\ndrK = 0.01 + 0.04 * drive; drN = 1 / tanh(drK);\nmasterG = master * 0.01;\n\nhaf = 8700.0 * exp2(hatTone / 12);\nhag = tan(pi * haf / samplerate); hak = 0.09090909090909091;\nhaa1 = 1 / (1 + hag * (hag + hak)); haa2 = hag * haa1; haa3 = hag * haa2;\n\n\nbdWt = twopi * 62.5 * exp2(bdTune / 12) / samplerate;\nbdTa = 100 * 0.001 * exp2(bdDec) / 2.302585093;                          // decay constant (s)\nbdRr = exp(-1 / (bdTa * samplerate));\nbdCc = cos(bdWt); bdSn = sin(bdWt);\nbdWn = bdWt * bdTa * samplerate;\nbdPs = atan(bdWn);\nbdAg = 1 / (exp(-bdPs / bdWn) * sin(bdPs));                        // 1 / the first peak of e^-t sin(wt)\n\n\nrsWt = twopi * 1480 * exp2(rsTune / 12) / samplerate;\nrsTa = 5 * 0.001 * exp2(rsDec) / 2.302585093;                          // decay constant (s)\nrsRr = exp(-1 / (rsTa * samplerate));\nrsCc = cos(rsWt); rsSn = sin(rsWt);\nrsWn = rsWt * rsTa * samplerate;\nrsPs = atan(rsWn);\nrsAg = 1 / (exp(-rsPs / rsWn) * sin(rsPs));                        // 1 / the first peak of e^-t sin(wt)\n\n\nsdWt = twopi * 340 * exp2(sdTune / 12) / samplerate;\nsdTa = 60 * 0.001 * exp2(sdDec) / 2.302585093;                          // decay constant (s)\nsdRr = exp(-1 / (sdTa * samplerate));\nsdCc = cos(sdWt); sdSn = sin(sdWt);\nsdWn = sdWt * sdTa * samplerate;\nsdPs = atan(sdWn);\nsdAg = 1 / (exp(-sdPs / sdWn) * sin(sdPs));                        // 1 / the first peak of e^-t sin(wt)\n\nsdTn = 60 * 0.001 * exp2(sdDec) / 2.302585093;\nsdRn = exp(-1 / (sdTn * samplerate));\nsdLk = exp(-twopi * 2000 / samplerate); sdLl = 1 - exp(-twopi * 9000 / samplerate);\nsdNg = sdNoise * 0.01 * 14;\n\nhhRe = exp(-1 / (60 * 0.001 * exp2(hhDec) / 2.302585093 * samplerate));\n\ncyRe = exp(-1 / (350 * 0.001 * exp2(cyDec) / 2.302585093 * samplerate));\n\nmaRe = exp(-1 / (20 * 0.001 * exp2(maDec) / 2.302585093 * samplerate));\n\n\nmbRs = 0.9 / (50 * 0.001 * exp2(mbDec) * samplerate);                  // linear ramp: 1/10 at the table's 50 ms\nmbf = 6200.0;\nmbg = tan(pi * mbf / samplerate); mbk = 0.2;\nmba1 = 1 / (1 + mbg * (mbg + mbk)); mba2 = mbg * mba1; mba3 = mbg * mba2;\nmbTu = exp2(mbTune / 12);\n\n\ntbRe = exp(-1 / (220 * 0.001 * exp2(tbDec) / 2.302585093 * samplerate));\ntbf = 4400.0 * exp2(tbTone / 12);\ntbg = tan(pi * tbf / samplerate); tbk = 0.05714285714285714;\ntba1 = 1 / (1 + tbg * (tbg + tbk)); tba2 = tbg * tba1; tba3 = tbg * tba2;\ntbDl = 70.0 * 0.001 * samplerate * (tbShake > 0.5);\n\n\ncbRs = 0.9 / (60 * 0.001 * exp2(cbDec) * samplerate);                  // linear ramp: 1/10 at the table's 60 ms\ncbf = 1660.0 * exp2(cbTone / 12);\ncbg = tan(pi * cbf / samplerate); cbk = 0.5780346820809249;\ncba1 = 1 / (1 + cbg * (cbg + cbk)); cba2 = cbg * cba1; cba3 = cbg * cba2;\ncbTu = exp2(cbTune / 12);\n\n\nhbWt = twopi * 600 * exp2(hbTune / 12) / samplerate;\nhbTa = 40 * 0.001 * exp2(hbDec) / 2.302585093;                          // decay constant (s)\nhbRr = exp(-1 / (hbTa * samplerate));\nhbCc = cos(hbWt); hbSn = sin(hbWt);\nhbWn = hbWt * hbTa * samplerate;\nhbPs = atan(hbWn);\nhbAg = 1 / (exp(-hbPs / hbWn) * sin(hbPs));                        // 1 / the first peak of e^-t sin(wt)\n\n\nlbWt = twopi * 400 * exp2(lbTune / 12) / samplerate;\nlbTa = 40 * 0.001 * exp2(lbDec) / 2.302585093;                          // decay constant (s)\nlbRr = exp(-1 / (lbTa * samplerate));\nlbCc = cos(lbWt); lbSn = sin(lbWt);\nlbWn = lbWt * lbTa * samplerate;\nlbPs = atan(lbWn);\nlbAg = 1 / (exp(-lbPs / lbWn) * sin(lbPs));                        // 1 / the first peak of e^-t sin(wt)\n\n\nlcWt = twopi * 208 * exp2(lcTune / 12) / samplerate;\nlcTa = 150 * 0.001 * exp2(lcDec) / 2.302585093;                          // decay constant (s)\nlcRr = exp(-1 / (lcTa * samplerate));\nlcCc = cos(lcWt); lcSn = sin(lcWt);\nlcWn = lcWt * lcTa * samplerate;\nlcPs = atan(lcWn);\nlcAg = 1 / (exp(-lcPs / lcWn) * sin(lcPs));                        // 1 / the first peak of e^-t sin(wt)\n\n\ngug = tan(pi * 5900.0 * exp2(guTone / 12) / samplerate); guk = 0.1;\ngua1 = 1 / (1 + gug * (gug + guk)); gua2 = gug * gua1; gua3 = gug * gua2;\nguLp = 1 - exp(-twopi * 6000.0 / samplerate);\nguWs = 1 / (0.009 * exp2(guDec) * samplerate);\nguRu = exp2(guRate / 12);\nguKa = 1 - exp(-1 / (0.001 * samplerate)); guKr = 1 - exp(-1 / (0.004 * samplerate));\n\n\nclWt = twopi * 2630 * exp2(clTune / 12) / samplerate;\nclTa = 18 * 0.001 * exp2(clDec) / 2.302585093;                          // decay constant (s)\nclRr = exp(-1 / (clTa * samplerate));\nclCc = cos(clWt); clSn = sin(clWt);\nclWn = clWt * clTa * samplerate;\nclPs = atan(clWn);\nclAg = 1 / (exp(-clPs / clWn) * sin(clPs));                        // 1 / the first peak of e^-t sin(wt)\n\nnz = noise();                                   // the one noise source every noise voice shares\n\nhit0 = tr0 != pt0; pt0 = tr0; hg0 = (1 - accA) + 1.27 * accA * vl0;\nif (hit0) { bdQ = bdQ + bdAg * hg0; }\nbdXt = bdRr * (bdCc * bdS - bdSn * bdQ); bdQ = bdRr * (bdSn * bdS + bdCc * bdQ); bdS = bdXt;\nbd_ring = tanh(drK * (0 - bdS)) * drN;\nbd_out = bd_ring;\n\n\nhit1 = tr1 != pt1; pt1 = tr1; hg1 = (1 - accA) + 1.27 * accA * vl1;\nif (hit1) { rsQ = rsQ + rsAg * hg1; }\nrsXt = rsRr * (rsCc * rsS - rsSn * rsQ); rsQ = rsRr * (rsSn * rsS + rsCc * rsQ); rsS = rsXt;\nrs_ring = 0 - rsS;\nrs_out = rs_ring;\n\n\nhit2 = tr2 != pt2; pt2 = tr2; hg2 = (1 - accA) + 1.27 * accA * vl2;\nif (hit2) { sdQ = sdQ + sdAg * hg2; sdNe = hg2; }\nsdXt = sdRr * (sdCc * sdS - sdSn * sdQ); sdQ = sdRr * (sdSn * sdS + sdCc * sdQ); sdS = sdXt;\nsd_ring = tanh(drK * (0 - sdS)) * drN;\nsdNz = sdLk * (sdNz + nz - sdNh); sdNh = nz;                 // two one-pole high-passes at 2 kHz\nsdNy = sdLk * (sdNy + sdNz - sdNp); sdNp = sdNz;\nsdNl = sdNl + sdLl * (sdNy - sdNl);                          // and a gentle 9 kHz low-pass\nsd_out = sd_ring + sdNl * sdNe * sdNg;\nsdNe = sdNe * sdRn;\n\n\nhit3 = tr3 != pt3; pt3 = tr3; hg3 = (1 - accA) + 1.27 * accA * vl3;\nif (hit3) { hhE = hg3; mbHit = mbHit + (mbHats > 0.5) * hg3 * mbAmt * 0.01; }\nhhv3 = (nz * hhE) - hhi2; hhb = haa1 * hhi1 + haa2 * hhv3; hhl = hhi2 + haa2 * hhi1 + haa3 * hhv3; hhi1 = 2 * hhb - hhi1; hhi2 = 2 * hhl - hhi2; hhbp = hak * hhb;\nhhE = hhE * hhRe;\nhh_out = hhbp;\n\n\nhit5 = tr5 != pt5; pt5 = tr5; hg5 = (1 - accA) + 1.27 * accA * vl5;\nif (hit5) { cyE = hg5; mbHit = mbHit + (mbHats > 0.5) * hg5 * mbAmt * 0.01; }\ncyv3 = (nz * cyE) - cyi2; cyb = haa1 * cyi1 + haa2 * cyv3; cyl = cyi2 + haa2 * cyi1 + haa3 * cyv3; cyi1 = 2 * cyb - cyi1; cyi2 = 2 * cyl - cyi2; cybp = hak * cyb;\ncyE = cyE * cyRe;\ncy_out = cybp;\n\n\nhit11 = tr11 != pt11; pt11 = tr11; hg11 = (1 - accA) + 1.27 * accA * vl11;\nif (hit11) { maE = hg11; }\nmav3 = (nz * maE) - mai2; mab = haa1 * mai1 + haa2 * mav3; mal = mai2 + haa2 * mai1 + haa3 * mav3; mai1 = 2 * mab - mai1; mai2 = 2 * mal - mai2; mabp = hak * mab;\nmaE = maE * maRe;\nma_out = mabp;\n\n\nhit4 = tr4 != pt4; pt4 = tr4; hg4 = (1 - accA) + 1.27 * accA * vl4;\nif (hit4) { mbE = hg4; mbSl = mbE * mbRs; }\nif (mbHit > 0) { mbE = mbHit; mbSl = mbE * mbRs; mbHit = 0; }\nmbd0 = 6170 * mbTu / samplerate; mbP0 = fract(mbP0 + mbd0);\nmbd1 = 5620 * mbTu / samplerate; mbP1 = fract(mbP1 + mbd1);\nmbd2 = 4080 * mbTu / samplerate; mbP2 = fract(mbP2 + mbd2);\nmbsq = ((2 * (mbP0 < 0.5) - 1 + blep(mbP0, mbd0) - blep(fract(mbP0 + 0.5), mbd0)) + (2 * (mbP1 < 0.5) - 1 + blep(mbP1, mbd1) - blep(fract(mbP1 + 0.5), mbd1)) + (2 * (mbP2 < 0.5) - 1 + blep(mbP2, mbd2) - blep(fract(mbP2 + 0.5), mbd2))) * 0.3333;\nmbv = mbsq * mbE; mbv = mbv + 0.3 * mbv * mbv;\nmbv3 = mbv - mbi2; mbb = mba1 * mbi1 + mba2 * mbv3; mbl = mbi2 + mba2 * mbi1 + mba3 * mbv3; mbi1 = 2 * mbb - mbi1; mbi2 = 2 * mbl - mbi2; mbbp = mbk * mbb;\nmbE = max(mbE - mbSl, 0);\nmb_out = mbbp;\n\n\nhit6 = tr6 != pt6; pt6 = tr6; hg6 = (1 - accA) + 1.27 * accA * vl6;\nif (hit6) { tbE = hg6; tbG = hg6; tbD = tbDl; }\nif (tbD > 0.5) { tbD = tbD - 1; if (tbD < 0.5) { tbE = 0.8 * tbG; } }\ntbv3 = (nz * tbE) - tbi2; tbb = tba1 * tbi1 + tba2 * tbv3; tbl = tbi2 + tba2 * tbi1 + tba3 * tbv3; tbi1 = 2 * tbb - tbi1; tbi2 = 2 * tbl - tbi2; tbbp = tbk * tbb;\ntbE = tbE * tbRe;\ntb_out = tbbp;\n\n\nhit7 = tr7 != pt7; pt7 = tr7; hg7 = (1 - accA) + 1.27 * accA * vl7;\nif (hit7) { cbE = hg7; cbSl = cbE * cbRs; }\ncbP1 = fract(cbP1 + 800 * cbTu / samplerate); cbP2 = fract(cbP2 + 555 * cbTu / samplerate);\ncbs1 = sin(twopi * cbP1); cbs2 = sin(twopi * cbP2);                    // phase-shift oscillators: sine-ish, each lopsided\ncbo = 0.5 * (cbs2 + 0.324 * (cbs2 * cbs2 - 0.5) + 0.077 * cbs2 * cbs2 * cbs2 + cbs1 + 0.061 * (cbs1 * cbs1 - 0.5) + 0.044 * cbs1 * cbs1 * cbs1);\ncbv = cbo * cbE; cbv = cbv + 0.036 * cbv * cbv;\ncbv3 = cbv - cbi2; cbb = cba1 * cbi1 + cba2 * cbv3; cbl = cbi2 + cba2 * cbi1 + cba3 * cbv3; cbi1 = 2 * cbb - cbi1; cbi2 = 2 * cbl - cbi2; cbbp = cbk * cbb;\ncbE = max(cbE - cbSl, 0);\ncb_out = cbbp;\n\n\nhit8 = tr8 != pt8; pt8 = tr8; hg8 = (1 - accA) + 1.27 * accA * vl8;\nif (hit8) { hbQ = hbQ + hbAg * hg8; }\nhbXt = hbRr * (hbCc * hbS - hbSn * hbQ); hbQ = hbRr * (hbSn * hbS + hbCc * hbQ); hbS = hbXt;\nhb_ring = tanh(drK * (0 - hbS)) * drN;\nhb_out = hb_ring;\n\n\nhit9 = tr9 != pt9; pt9 = tr9; hg9 = (1 - accA) + 1.27 * accA * vl9;\nif (hit9) { lbQ = lbQ + lbAg * hg9; }\nlbXt = lbRr * (lbCc * lbS - lbSn * lbQ); lbQ = lbRr * (lbSn * lbS + lbCc * lbQ); lbS = lbXt;\nlb_ring = tanh(drK * (0 - lbS)) * drN;\nlb_out = lb_ring;\n\n\nhit10 = tr10 != pt10; pt10 = tr10; hg10 = (1 - accA) + 1.27 * accA * vl10;\nif (hit10) { lcQ = lcQ + lcAg * hg10; }\nlcXt = lcRr * (lcCc * lcS - lcSn * lcQ); lcQ = lcRr * (lcSn * lcS + lcCc * lcQ); lcS = lcXt;\nlc_ring = tanh(drK * (0 - lcS)) * drN;\nlc_out = lc_ring;\n\n\nhit12 = tr12 != pt12; pt12 = tr12; hg12 = (1 - accA) + 1.27 * accA * vl12;\nif (hit12) { guRt = 125 * guRu; guPh = 1; guT = 0; guH = 20.0 * 0.001 * samplerate; guGe = 1; guG = hg12; }\nhit13 = tr13 != pt13; pt13 = tr13; hg13 = (1 - accA) + 1.27 * accA * vl13;\nif (hit13) { guRt = 77 * guRu; guPh = 1; guT = 0; guH = 20.0 * 0.001 * samplerate; guGe = 1; guG = hg13; }\nguOn = ((gt12 + gt13) > 0.5) + (guH > 0.5);\nguOn = (guOn > 0.5) * (guT < 1.0 * samplerate);                  // the note length is the stroke, up to 1 s\nguT = guT + 1; guH = guH - (guH > 0.5);\nguGe = guGe + (guOn * guKa + (1 - guOn) * guKr) * (guOn - guGe);\nguPh = guPh + guOn * guRt / samplerate;\nguPu = guPh >= 1; guPh = guPh - guPu;\nif (guPu) { guW = 0; guA = 1 + 0.38 * nz; }                    // each pulse opens one scrape grain, its level random\nguW = guW + (guW < 1) * guWs * guRt / 77;\nguSw = sin(pi * min(guW, 1)); guX = nz * guSw * guSw * guSw * guA * guG * guGe;\nguv3 = guX - gui2; gub = gua1 * gui1 + gua2 * guv3; gul = gui2 + gua2 * gui1 + gua3 * guv3;\ngui1 = 2 * gub - gui1; gui2 = 2 * gul - gui2;\nguLo = guLo + guLp * (guX - guk * gub - gul - guLo);                      // resonant high-pass, then a gentle low-pass\ngu_out = guLo;\n\n\nhit14 = tr14 != pt14; pt14 = tr14; hg14 = (1 - accA) + 1.27 * accA * vl14;\nif (hit14) { clQ = clQ + clAg * hg14; }\nclXt = clRr * (clCc * clS - clSn * clQ); clQ = clRr * (clSn * clS + clCc * clQ); clS = clXt;\ncl_ring = 0 - clS;\ncl_out = cl_ring;\n\nbdpn = bdPan * 0.01; bdgl = cos((bdpn + 1) * pi * 0.25); bdgr = sin((bdpn + 1) * pi * 0.25); bdvg = bdLvl * 1.000000;\nrspn = rsPan * 0.01; rsgl = cos((rspn + 1) * pi * 0.25); rsgr = sin((rspn + 1) * pi * 0.25); rsvg = rsLvl * 1.000400;\nsdpn = sdPan * 0.01; sdgl = cos((sdpn + 1) * pi * 0.25); sdgr = sin((sdpn + 1) * pi * 0.25); sdvg = sdLvl * 0.114700;\nhhpn = hhPan * 0.01; hhgl = cos((hhpn + 1) * pi * 0.25); hhgr = sin((hhpn + 1) * pi * 0.25); hhvg = hhLvl * 3.482100;\ncypn = cyPan * 0.01; cygl = cos((cypn + 1) * pi * 0.25); cygr = sin((cypn + 1) * pi * 0.25); cyvg = cyLvl * 2.882500;\nmapn = maPan * 0.01; magl = cos((mapn + 1) * pi * 0.25); magr = sin((mapn + 1) * pi * 0.25); mavg = maLvl * 4.048700;\nmbpn = mbPan * 0.01; mbgl = cos((mbpn + 1) * pi * 0.25); mbgr = sin((mbpn + 1) * pi * 0.25); mbvg = mbLvl * 1.409300;\ntbpn = tbPan * 0.01; tbgl = cos((tbpn + 1) * pi * 0.25); tbgr = sin((tbpn + 1) * pi * 0.25); tbvg = tbLvl * 5.114900;\ncbpn = cbPan * 0.01; cbgl = cos((cbpn + 1) * pi * 0.25); cbgr = sin((cbpn + 1) * pi * 0.25); cbvg = cbLvl * 2.976300;\nhbpn = hbPan * 0.01; hbgl = cos((hbpn + 1) * pi * 0.25); hbgr = sin((hbpn + 1) * pi * 0.25); hbvg = hbLvl * 1.000100;\nlbpn = lbPan * 0.01; lbgl = cos((lbpn + 1) * pi * 0.25); lbgr = sin((lbpn + 1) * pi * 0.25); lbvg = lbLvl * 1.000300;\nlcpn = lcPan * 0.01; lcgl = cos((lcpn + 1) * pi * 0.25); lcgr = sin((lcpn + 1) * pi * 0.25); lcvg = lcLvl * 0.999600;\ngupn = guPan * 0.01; gugl = cos((gupn + 1) * pi * 0.25); gugr = sin((gupn + 1) * pi * 0.25); guvg = guLvl * 0.340700;\nclpn = clPan * 0.01; clgl = cos((clpn + 1) * pi * 0.25); clgr = sin((clpn + 1) * pi * 0.25); clvg = clLvl * 1.012600;\nmixl = (bd_out * bdvg * bdgl + rs_out * rsvg * rsgl + sd_out * sdvg * sdgl + hh_out * hhvg * hhgl + cy_out * cyvg * cygl + ma_out * mavg * magl + mb_out * mbvg * mbgl + tb_out * tbvg * tbgl + cb_out * cbvg * cbgl + hb_out * hbvg * hbgl + lb_out * lbvg * lbgl + lc_out * lcvg * lcgl + gu_out * guvg * gugl + cl_out * clvg * clgl) * masterG; mixr = (bd_out * bdvg * bdgr + rs_out * rsvg * rsgr + sd_out * sdvg * sdgr + hh_out * hhvg * hhgr + cy_out * cyvg * cygr + ma_out * mavg * magr + mb_out * mbvg * mbgr + tb_out * tbvg * tbgr + cb_out * cbvg * cbgr + hb_out * hbvg * hbgr + lb_out * lbvg * lbgr + lc_out * lcvg * lcgr + gu_out * guvg * gugr + cl_out * clvg * clgr) * masterG;\naxl = abs(mixl); out1 = sign(mixl) * (min(axl, 0.8) + 0.2 * tanh(max(axl - 0.8, 0) * 5)) + 0 * in1;\naxr = abs(mixr); out2 = sign(mixr) * (min(axr, 0.8) + 0.2 * tanh(max(axr - 0.8, 0) * 5)) + 0 * in2;\n",
									"fontface": 0,
									"fontname": "<Monospaced>",
									"fontsize": 11.0,
									"numinlets": 2,
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
										90.0,
										20.0,
										40.0,
										22.0
									]
								}
							},
							{
								"box": {
									"id": "in2",
									"maxclass": "newobj",
									"text": "in 2",
									"numinlets": 0,
									"numoutlets": 1,
									"outlettype": [
										""
									],
									"patching_rect": [
										160.0,
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
										"in2",
										0
									],
									"destination": [
										"code",
										1
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
					"id": "plugin",
					"maxclass": "newobj",
					"text": "plugin~",
					"numinlets": 2,
					"numoutlets": 2,
					"outlettype": [
						"signal",
						"signal"
					],
					"patching_rect": [
						20,
						140,
						49,
						22
					]
				}
			},
			{
				"box": {
					"id": "loadbang_t",
					"maxclass": "newobj",
					"text": "t b b b",
					"numinlets": 1,
					"numoutlets": 3,
					"outlettype": [
						"",
						"",
						""
					],
					"patching_rect": [
						20,
						110,
						49,
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
					"id": "view",
					"maxclass": "newobj",
					"text": "js cr_view.js",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						50,
						91,
						22
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
						"loadbang_t",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"plugin",
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
						"plugin",
						1
					],
					"destination": [
						"engine",
						1
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
						"pgtab",
						0
					],
					"destination": [
						"pre_pgtab",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_pgtab",
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
						"bdTrig",
						0
					],
					"destination": [
						"sel_bdTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"bdTrig",
						0
					],
					"destination": [
						"rb_bdTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel_bdTrig",
						0
					],
					"destination": [
						"msg_bdTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rb_bdTrig",
						0
					],
					"destination": [
						"msg_bdTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_bdTrig",
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
						"loadbang_t",
						2
					],
					"destination": [
						"bdTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"bdTune",
						0
					],
					"destination": [
						"pre_bdTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_bdTune",
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
						"loadbang_t",
						2
					],
					"destination": [
						"bdDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"bdDec",
						0
					],
					"destination": [
						"pre_bdDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_bdDec",
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
						"loadbang_t",
						2
					],
					"destination": [
						"bdLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"bdLvl",
						0
					],
					"destination": [
						"pre_bdLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_bdLvl",
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
						"loadbang_t",
						2
					],
					"destination": [
						"bdPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"bdPan",
						0
					],
					"destination": [
						"pre_bdPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_bdPan",
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
						"sdTrig",
						0
					],
					"destination": [
						"sel_sdTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sdTrig",
						0
					],
					"destination": [
						"rb_sdTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel_sdTrig",
						0
					],
					"destination": [
						"msg_sdTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rb_sdTrig",
						0
					],
					"destination": [
						"msg_sdTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_sdTrig",
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
						"loadbang_t",
						2
					],
					"destination": [
						"sdTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sdTune",
						0
					],
					"destination": [
						"pre_sdTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_sdTune",
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
						"loadbang_t",
						2
					],
					"destination": [
						"sdDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sdDec",
						0
					],
					"destination": [
						"pre_sdDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_sdDec",
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
						"loadbang_t",
						2
					],
					"destination": [
						"sdNoise",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sdNoise",
						0
					],
					"destination": [
						"pre_sdNoise",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_sdNoise",
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
						"loadbang_t",
						2
					],
					"destination": [
						"sdLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sdLvl",
						0
					],
					"destination": [
						"pre_sdLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_sdLvl",
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
						"loadbang_t",
						2
					],
					"destination": [
						"sdPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sdPan",
						0
					],
					"destination": [
						"pre_sdPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_sdPan",
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
						"rsTrig",
						0
					],
					"destination": [
						"sel_rsTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rsTrig",
						0
					],
					"destination": [
						"rb_rsTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel_rsTrig",
						0
					],
					"destination": [
						"msg_rsTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rb_rsTrig",
						0
					],
					"destination": [
						"msg_rsTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_rsTrig",
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
						"loadbang_t",
						2
					],
					"destination": [
						"rsTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rsTune",
						0
					],
					"destination": [
						"pre_rsTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_rsTune",
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
						"loadbang_t",
						2
					],
					"destination": [
						"rsDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rsDec",
						0
					],
					"destination": [
						"pre_rsDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_rsDec",
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
						"loadbang_t",
						2
					],
					"destination": [
						"rsLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rsLvl",
						0
					],
					"destination": [
						"pre_rsLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_rsLvl",
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
						"loadbang_t",
						2
					],
					"destination": [
						"rsPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rsPan",
						0
					],
					"destination": [
						"pre_rsPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_rsPan",
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
						"clTrig",
						0
					],
					"destination": [
						"sel_clTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"clTrig",
						0
					],
					"destination": [
						"rb_clTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel_clTrig",
						0
					],
					"destination": [
						"msg_clTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rb_clTrig",
						0
					],
					"destination": [
						"msg_clTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_clTrig",
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
						"loadbang_t",
						2
					],
					"destination": [
						"clTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"clTune",
						0
					],
					"destination": [
						"pre_clTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_clTune",
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
						"loadbang_t",
						2
					],
					"destination": [
						"clDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"clDec",
						0
					],
					"destination": [
						"pre_clDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_clDec",
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
						"loadbang_t",
						2
					],
					"destination": [
						"clLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"clLvl",
						0
					],
					"destination": [
						"pre_clLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_clLvl",
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
						"loadbang_t",
						2
					],
					"destination": [
						"clPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"clPan",
						0
					],
					"destination": [
						"pre_clPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_clPan",
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
						"hbTrig",
						0
					],
					"destination": [
						"sel_hbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"hbTrig",
						0
					],
					"destination": [
						"rb_hbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel_hbTrig",
						0
					],
					"destination": [
						"msg_hbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rb_hbTrig",
						0
					],
					"destination": [
						"msg_hbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_hbTrig",
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
						"loadbang_t",
						2
					],
					"destination": [
						"hbTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"hbTune",
						0
					],
					"destination": [
						"pre_hbTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_hbTune",
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
						"loadbang_t",
						2
					],
					"destination": [
						"hbDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"hbDec",
						0
					],
					"destination": [
						"pre_hbDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_hbDec",
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
						"loadbang_t",
						2
					],
					"destination": [
						"hbLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"hbLvl",
						0
					],
					"destination": [
						"pre_hbLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_hbLvl",
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
						"loadbang_t",
						2
					],
					"destination": [
						"hbPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"hbPan",
						0
					],
					"destination": [
						"pre_hbPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_hbPan",
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
						"lbTrig",
						0
					],
					"destination": [
						"sel_lbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lbTrig",
						0
					],
					"destination": [
						"rb_lbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel_lbTrig",
						0
					],
					"destination": [
						"msg_lbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rb_lbTrig",
						0
					],
					"destination": [
						"msg_lbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_lbTrig",
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
						"loadbang_t",
						2
					],
					"destination": [
						"lbTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lbTune",
						0
					],
					"destination": [
						"pre_lbTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_lbTune",
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
						"loadbang_t",
						2
					],
					"destination": [
						"lbDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lbDec",
						0
					],
					"destination": [
						"pre_lbDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_lbDec",
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
						"loadbang_t",
						2
					],
					"destination": [
						"lbLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lbLvl",
						0
					],
					"destination": [
						"pre_lbLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_lbLvl",
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
						"loadbang_t",
						2
					],
					"destination": [
						"lbPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lbPan",
						0
					],
					"destination": [
						"pre_lbPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_lbPan",
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
						"lcTrig",
						0
					],
					"destination": [
						"sel_lcTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lcTrig",
						0
					],
					"destination": [
						"rb_lcTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel_lcTrig",
						0
					],
					"destination": [
						"msg_lcTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rb_lcTrig",
						0
					],
					"destination": [
						"msg_lcTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_lcTrig",
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
						"loadbang_t",
						2
					],
					"destination": [
						"lcTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lcTune",
						0
					],
					"destination": [
						"pre_lcTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_lcTune",
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
						"loadbang_t",
						2
					],
					"destination": [
						"lcDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lcDec",
						0
					],
					"destination": [
						"pre_lcDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_lcDec",
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
						"loadbang_t",
						2
					],
					"destination": [
						"lcLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lcLvl",
						0
					],
					"destination": [
						"pre_lcLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_lcLvl",
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
						"loadbang_t",
						2
					],
					"destination": [
						"lcPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"lcPan",
						0
					],
					"destination": [
						"pre_lcPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_lcPan",
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
						"hhTrig",
						0
					],
					"destination": [
						"sel_hhTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"hhTrig",
						0
					],
					"destination": [
						"rb_hhTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel_hhTrig",
						0
					],
					"destination": [
						"msg_hhTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rb_hhTrig",
						0
					],
					"destination": [
						"msg_hhTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_hhTrig",
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
						"loadbang_t",
						2
					],
					"destination": [
						"hhDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"hhDec",
						0
					],
					"destination": [
						"pre_hhDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_hhDec",
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
						"loadbang_t",
						2
					],
					"destination": [
						"hatTone",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"hatTone",
						0
					],
					"destination": [
						"pre_hatTone",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_hatTone",
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
						"loadbang_t",
						2
					],
					"destination": [
						"hhLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"hhLvl",
						0
					],
					"destination": [
						"pre_hhLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_hhLvl",
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
						"loadbang_t",
						2
					],
					"destination": [
						"hhPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"hhPan",
						0
					],
					"destination": [
						"pre_hhPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_hhPan",
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
						"cyTrig",
						0
					],
					"destination": [
						"sel_cyTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"cyTrig",
						0
					],
					"destination": [
						"rb_cyTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel_cyTrig",
						0
					],
					"destination": [
						"msg_cyTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rb_cyTrig",
						0
					],
					"destination": [
						"msg_cyTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_cyTrig",
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
						"loadbang_t",
						2
					],
					"destination": [
						"cyDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"cyDec",
						0
					],
					"destination": [
						"pre_cyDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_cyDec",
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
						"loadbang_t",
						2
					],
					"destination": [
						"cyLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"cyLvl",
						0
					],
					"destination": [
						"pre_cyLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_cyLvl",
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
						"loadbang_t",
						2
					],
					"destination": [
						"cyPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"cyPan",
						0
					],
					"destination": [
						"pre_cyPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_cyPan",
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
						"maTrig",
						0
					],
					"destination": [
						"sel_maTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"maTrig",
						0
					],
					"destination": [
						"rb_maTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel_maTrig",
						0
					],
					"destination": [
						"msg_maTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rb_maTrig",
						0
					],
					"destination": [
						"msg_maTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_maTrig",
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
						"loadbang_t",
						2
					],
					"destination": [
						"maDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"maDec",
						0
					],
					"destination": [
						"pre_maDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_maDec",
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
						"loadbang_t",
						2
					],
					"destination": [
						"maLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"maLvl",
						0
					],
					"destination": [
						"pre_maLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_maLvl",
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
						"loadbang_t",
						2
					],
					"destination": [
						"maPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"maPan",
						0
					],
					"destination": [
						"pre_maPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_maPan",
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
						"mbTrig",
						0
					],
					"destination": [
						"sel_mbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"mbTrig",
						0
					],
					"destination": [
						"rb_mbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel_mbTrig",
						0
					],
					"destination": [
						"msg_mbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rb_mbTrig",
						0
					],
					"destination": [
						"msg_mbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_mbTrig",
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
						"loadbang_t",
						2
					],
					"destination": [
						"mbTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"mbTune",
						0
					],
					"destination": [
						"pre_mbTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_mbTune",
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
						"loadbang_t",
						2
					],
					"destination": [
						"mbDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"mbDec",
						0
					],
					"destination": [
						"pre_mbDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_mbDec",
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
						"loadbang_t",
						2
					],
					"destination": [
						"mbAmt",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"mbAmt",
						0
					],
					"destination": [
						"pre_mbAmt",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_mbAmt",
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
						"mbHats",
						0
					],
					"destination": [
						"pre_mbHats",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_mbHats",
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
						"loadbang_t",
						2
					],
					"destination": [
						"mbLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"mbLvl",
						0
					],
					"destination": [
						"pre_mbLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_mbLvl",
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
						"loadbang_t",
						2
					],
					"destination": [
						"mbPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"mbPan",
						0
					],
					"destination": [
						"pre_mbPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_mbPan",
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
						"cbTrig",
						0
					],
					"destination": [
						"sel_cbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"cbTrig",
						0
					],
					"destination": [
						"rb_cbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel_cbTrig",
						0
					],
					"destination": [
						"msg_cbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rb_cbTrig",
						0
					],
					"destination": [
						"msg_cbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_cbTrig",
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
						"loadbang_t",
						2
					],
					"destination": [
						"cbTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"cbTune",
						0
					],
					"destination": [
						"pre_cbTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_cbTune",
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
						"loadbang_t",
						2
					],
					"destination": [
						"cbDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"cbDec",
						0
					],
					"destination": [
						"pre_cbDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_cbDec",
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
						"loadbang_t",
						2
					],
					"destination": [
						"cbTone",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"cbTone",
						0
					],
					"destination": [
						"pre_cbTone",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_cbTone",
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
						"loadbang_t",
						2
					],
					"destination": [
						"cbLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"cbLvl",
						0
					],
					"destination": [
						"pre_cbLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_cbLvl",
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
						"loadbang_t",
						2
					],
					"destination": [
						"cbPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"cbPan",
						0
					],
					"destination": [
						"pre_cbPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_cbPan",
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
						"tbTrig",
						0
					],
					"destination": [
						"sel_tbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"tbTrig",
						0
					],
					"destination": [
						"rb_tbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel_tbTrig",
						0
					],
					"destination": [
						"msg_tbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rb_tbTrig",
						0
					],
					"destination": [
						"msg_tbTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_tbTrig",
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
						"loadbang_t",
						2
					],
					"destination": [
						"tbDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"tbDec",
						0
					],
					"destination": [
						"pre_tbDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_tbDec",
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
						"loadbang_t",
						2
					],
					"destination": [
						"tbTone",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"tbTone",
						0
					],
					"destination": [
						"pre_tbTone",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_tbTone",
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
						"tbShake",
						0
					],
					"destination": [
						"pre_tbShake",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_tbShake",
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
						"loadbang_t",
						2
					],
					"destination": [
						"tbLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"tbLvl",
						0
					],
					"destination": [
						"pre_tbLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_tbLvl",
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
						"loadbang_t",
						2
					],
					"destination": [
						"tbPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"tbPan",
						0
					],
					"destination": [
						"pre_tbPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_tbPan",
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
						"guHTrig",
						0
					],
					"destination": [
						"sel_guHTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"guHTrig",
						0
					],
					"destination": [
						"rb_guHTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel_guHTrig",
						0
					],
					"destination": [
						"msg_guHTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rb_guHTrig",
						0
					],
					"destination": [
						"msg_guHTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_guHTrig",
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
						"guLTrig",
						0
					],
					"destination": [
						"sel_guLTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"guLTrig",
						0
					],
					"destination": [
						"rb_guLTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sel_guLTrig",
						0
					],
					"destination": [
						"msg_guLTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"rb_guLTrig",
						0
					],
					"destination": [
						"msg_guLTrig",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"msg_guLTrig",
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
						"loadbang_t",
						2
					],
					"destination": [
						"guRate",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"guRate",
						0
					],
					"destination": [
						"pre_guRate",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_guRate",
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
						"loadbang_t",
						2
					],
					"destination": [
						"guTone",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"guTone",
						0
					],
					"destination": [
						"pre_guTone",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_guTone",
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
						"loadbang_t",
						2
					],
					"destination": [
						"guDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"guDec",
						0
					],
					"destination": [
						"pre_guDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_guDec",
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
						"loadbang_t",
						2
					],
					"destination": [
						"guLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"guLvl",
						0
					],
					"destination": [
						"pre_guLvl",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_guLvl",
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
						"loadbang_t",
						2
					],
					"destination": [
						"guPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"guPan",
						0
					],
					"destination": [
						"pre_guPan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_guPan",
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
						"loadbang_t",
						2
					],
					"destination": [
						"accent",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"accent",
						0
					],
					"destination": [
						"pre_accent",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_accent",
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
						"loadbang_t",
						2
					],
					"destination": [
						"master",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"master",
						0
					],
					"destination": [
						"pre_master",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_master",
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
						"loadbang_t",
						2
					],
					"destination": [
						"drive",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"drive",
						0
					],
					"destination": [
						"pre_drive",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_drive",
						0
					],
					"destination": [
						"engine",
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