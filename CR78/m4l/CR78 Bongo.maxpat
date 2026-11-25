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
		"description": "CR78 Bongo: the Roland CR-78 high and low bongo as its own instrument, for Drum Rack pads. Any note plays it; velocity is the accent.",
		"boxes": [
			{
				"box": {
					"id": "pre_drive_drive",
					"maxclass": "newobj",
					"text": "prepend drive",
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
					"id": "ol_drive",
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
						124.0,
						82.0,
						48.0,
						22.0
					],
					"patching_rect": [
						2020,
						200,
						48,
						22
					]
				}
			},
			{
				"box": {
					"id": "hdr_drive",
					"maxclass": "comment",
					"text": "Drive",
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
						122.0,
						66.0,
						52.0,
						14.0
					],
					"patching_rect": [
						1950,
						200,
						52,
						14
					]
				}
			},
			{
				"box": {
					"id": "drive",
					"varname": "drive",
					"parameter_enable": 1,
					"annotation_name": "Drive",
					"annotation": "Transistor-style saturation on the ringing oscillator. 0 = clean.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
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
					"fontsize": 10.0,
					"presentation": 1,
					"presentation_rect": [
						124.0,
						82.0,
						48.0,
						22.0
					],
					"patching_rect": [
						1880,
						200,
						48,
						22
					]
				}
			},
			{
				"box": {
					"id": "pre_accent_accent",
					"maxclass": "newobj",
					"text": "prepend accent",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						830,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_accent",
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
						48.0,
						22.0
					],
					"patching_rect": [
						1740,
						200,
						48,
						22
					]
				}
			},
			{
				"box": {
					"id": "hdr_accent",
					"maxclass": "comment",
					"text": "Accent",
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
						66.0,
						52.0,
						14.0
					],
					"patching_rect": [
						1670,
						200,
						52,
						14
					]
				}
			},
			{
				"box": {
					"id": "accent",
					"varname": "accent",
					"parameter_enable": 1,
					"annotation_name": "Accent",
					"annotation": "How much velocity lifts or lowers a hit, like the accent stage of the board. 0 = every hit equal; 100 = level follows velocity (velocity 100 is the factory level).",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
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
					"fontsize": 10.0,
					"presentation": 1,
					"presentation_rect": [
						68.0,
						82.0,
						48.0,
						22.0
					],
					"patching_rect": [
						1600,
						200,
						48,
						22
					]
				}
			},
			{
				"box": {
					"id": "pre_bongo_variant",
					"maxclass": "newobj",
					"text": "prepend variant",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						710,
						105,
						22
					]
				}
			},
			{
				"box": {
					"id": "pre_bongo_pick",
					"maxclass": "newobj",
					"text": "prepend pick",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						680,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "hdr_bongo",
					"maxclass": "comment",
					"text": "Bongo",
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
						66.0,
						56.0,
						14.0
					],
					"patching_rect": [
						1950,
						140,
						56,
						14
					]
				}
			},
			{
				"box": {
					"id": "bongo",
					"varname": "bongo",
					"parameter_enable": 1,
					"annotation_name": "Bongo",
					"annotation": "Which bongo a note plays: the high one (600 Hz) or the low one (400 Hz). The ringing tail of the other one is not cut.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Bongo",
							"parameter_shortname": "Bongo",
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
						82.0,
						52.0,
						22.0
					],
					"patching_rect": [
						1880,
						140,
						52,
						22
					]
				}
			},
			{
				"box": {
					"id": "pre_volume_vol",
					"maxclass": "newobj",
					"text": "prepend vol",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						590,
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
					"annotation": "Output level in dB. 0 dB is the factory level of this voice (the service notes' amplitude: what the full CR78 plays at Level's default, before its pan law; Live's meter reads about 3 dB lower than the sample peak). Down to -36 dB, up to +6 dB.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Volume",
							"parameter_shortname": "Volume",
							"parameter_type": 0,
							"parameter_mmin": -36.0,
							"parameter_mmax": 6.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
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
						1740,
						140,
						60,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_decay_lbDec",
					"maxclass": "newobj",
					"text": "prepend lbDec",
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
					"id": "pre_decay_hbDec",
					"maxclass": "newobj",
					"text": "prepend hbDec",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						500,
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
					"annotation": "Decay trim pot. 0 is the factory time (to 1/10 amplitude); each +1 doubles it, each -1 halves it (x0.25 to x4).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Decay",
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
						2090,
						80,
						60,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_tune_lbTune",
					"maxclass": "newobj",
					"text": "prepend lbTune",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						440,
						98,
						22
					]
				}
			},
			{
				"box": {
					"id": "pre_tune_hbTune",
					"maxclass": "newobj",
					"text": "prepend hbTune",
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
					"id": "tune",
					"varname": "tune",
					"parameter_enable": 1,
					"annotation_name": "Tune",
					"annotation": "The tuning pot of the ringing oscillator: up to an octave either way. 0 is the factory frequency.",
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
							"parameter_units": "%+.2f st"
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
						1880,
						80,
						60,
						50
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
						350,
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
					"filename": "cr_voice_view.js",
					"border": 0,
					"parameter_enable": 0,
					"jsarguments": [
						"bongo"
					],
					"annotation_name": "Bongo",
					"annotation": "The high and low bongo: the last note, and a flash with every hit.",
					"presentation": 1,
					"presentation_rect": [
						8.0,
						8.0,
						164.0,
						48.0
					],
					"patching_rect": [
						1740,
						80,
						164,
						48
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
					"text": "js cr_voice_push.js bongo",
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
					"id": "midi",
					"maxclass": "newobj",
					"text": "js cr_voice_midi.js 8 9",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						20,
						290,
						161,
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
									"code": "Param hbTune(0);\nParam lbTune(0);\nParam hbDec(0);\nParam lbDec(0);\nParam accent(60);\nParam drive(0);\nParam vol(0);\nParam tr8(0);\nParam tr9(0);\nParam vl8(1);\nParam vl9(1);\nHistory hbS(0);\nHistory hbQ(0);\nHistory pt8(0);\nHistory lbS(0);\nHistory lbQ(0);\nHistory pt9(0);\naccA = accent * 0.01;\nvolG = dbtoa(vol);\ndrK = 0.01 + 0.04 * drive; drN = 1 / tanh(drK);\n\nhbWt = twopi * 600 * exp2(hbTune / 12) / samplerate;\nhbTa = 40 * 0.001 * exp2(hbDec) / 2.302585093;                          // decay constant (s)\nhbRr = exp(-1 / (hbTa * samplerate));\nhbCc = cos(hbWt); hbSn = sin(hbWt);\nhbWn = hbWt * hbTa * samplerate;\nhbPs = atan(hbWn);\nhbAg = 1 / (exp(-hbPs / hbWn) * sin(hbPs));                        // 1 / the first peak of e^-t sin(wt)\n\n\nlbWt = twopi * 400 * exp2(lbTune / 12) / samplerate;\nlbTa = 40 * 0.001 * exp2(lbDec) / 2.302585093;                          // decay constant (s)\nlbRr = exp(-1 / (lbTa * samplerate));\nlbCc = cos(lbWt); lbSn = sin(lbWt);\nlbWn = lbWt * lbTa * samplerate;\nlbPs = atan(lbWn);\nlbAg = 1 / (exp(-lbPs / lbWn) * sin(lbPs));                        // 1 / the first peak of e^-t sin(wt)\n\n\nhit8 = tr8 != pt8; pt8 = tr8; hg8 = (1 - accA) + 1.27 * accA * vl8;\nif (hit8) { hbQ = hbQ + hbAg * hg8; }\nhbXt = hbRr * (hbCc * hbS - hbSn * hbQ); hbQ = hbRr * (hbSn * hbS + hbCc * hbQ); hbS = hbXt;\nhb_ring = tanh(drK * (0 - hbS)) * drN;\nhb_out = hb_ring;\n\n\nhit9 = tr9 != pt9; pt9 = tr9; hg9 = (1 - accA) + 1.27 * accA * vl9;\nif (hit9) { lbQ = lbQ + lbAg * hg9; }\nlbXt = lbRr * (lbCc * lbS - lbSn * lbQ); lbQ = lbRr * (lbSn * lbS + lbCc * lbQ); lbS = lbXt;\nlb_ring = tanh(drK * (0 - lbS)) * drN;\nlb_out = lb_ring;\n\nvmix = (hb_out * volG * 0.15 * 1.000100 + lb_out * volG * 0.15 * 1.000300);\naxm = abs(vmix); out1 = sign(vmix) * (min(axm, 0.8) + 0.2 * tanh(max(axm - 0.8, 0) * 5)) + 0 * in1;\nout2 = out1 + 0 * in2;\n",
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
						1670,
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
						"tune",
						0
					],
					"destination": [
						"pre_tune_hbTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_tune_hbTune",
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
						"tune",
						0
					],
					"destination": [
						"pre_tune_lbTune",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_tune_lbTune",
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
						"pre_decay_hbDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_decay_hbDec",
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
						"decay",
						0
					],
					"destination": [
						"pre_decay_lbDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_decay_lbDec",
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
						"pre_volume_vol",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_volume_vol",
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
						"bongo",
						0
					],
					"destination": [
						"pre_bongo_pick",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_bongo_pick",
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
						"bongo",
						0
					],
					"destination": [
						"pre_bongo_variant",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_bongo_variant",
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
						"bongo",
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
						"pre_accent_accent",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_accent_accent",
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
						"accent",
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
						"pre_drive_drive",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_drive_drive",
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
						"drive",
						0
					]
				}
			}
		],
		"dependency_cache": [],
		"autosave": 0,
		"parameters": {
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
			"volume": [
				"Volume",
				"Volume",
				0
			],
			"bongo": [
				"Bongo",
				"Bongo",
				0
			],
			"accent": [
				"Accent",
				"Accent",
				0
			],
			"drive": [
				"Drive",
				"Drive",
				0
			],
			"parameterbanks": {
				"0": {
					"index": 0,
					"name": "Voice",
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
						"Decay",
						"Bongo",
						"-",
						"-",
						"Drive",
						"Accent",
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