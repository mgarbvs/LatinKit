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
		"description": "CR78 Guiro: the Roland CR-78 guiro as its own instrument, for Drum Rack pads. Any note plays it; velocity is the accent.",
		"boxes": [
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
						890,
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
						122.0,
						66.0,
						52.0,
						14.0
					],
					"patching_rect": [
						1810,
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
						124.0,
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
					"id": "pre_tone_guTone",
					"maxclass": "newobj",
					"text": "prepend guTone",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						770,
						98,
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
					"id": "hdr_tone",
					"maxclass": "comment",
					"text": "Tone",
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
						2090,
						140,
						52,
						14
					]
				}
			},
			{
				"box": {
					"id": "tone",
					"varname": "tone",
					"parameter_enable": 1,
					"annotation_name": "Tone",
					"annotation": "Centre of the scrape's resonance (5.9 kHz at 0, fitted to CR-78 guiro recordings).",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Tone",
							"parameter_shortname": "Tone",
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
						2020,
						140,
						48,
						22
					]
				}
			},
			{
				"box": {
					"id": "pre_stroke_variant",
					"maxclass": "newobj",
					"text": "prepend variant",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						650,
						105,
						22
					]
				}
			},
			{
				"box": {
					"id": "pre_stroke_pick",
					"maxclass": "newobj",
					"text": "prepend pick",
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
					"id": "hdr_stroke",
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
						6.0,
						66.0,
						56.0,
						14.0
					],
					"patching_rect": [
						1810,
						140,
						56,
						14
					]
				}
			},
			{
				"box": {
					"id": "stroke",
					"varname": "stroke",
					"parameter_enable": 1,
					"annotation_name": "Stroke",
					"annotation": "Which note of the board a hit plays: the short guiro (125 Hz pulses) or the long one (77 Hz). It runs for as long as the note is held (at most 1 s).",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Stroke",
							"parameter_shortname": "Stroke",
							"parameter_type": 2,
							"parameter_enum": [
								"Short",
								"Long"
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
						1740,
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
						530,
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
						1600,
						140,
						60,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_decay_guDec",
					"maxclass": "newobj",
					"text": "prepend guDec",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						470,
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
					"annotation": "Length of each scrape grain: 0 is 9 ms at the long note's rate; each +1 doubles it, each -1 halves it.",
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
						2020,
						80,
						60,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_rate_guRate",
					"maxclass": "newobj",
					"text": "prepend guRate",
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
					"id": "rate",
					"varname": "rate",
					"parameter_enable": 1,
					"annotation_name": "Rate",
					"annotation": "Speed of the multivibrator for both notes: 0 is the factory 125 Hz (short note) and 77 Hz (long note).",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Rate",
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
						"guiro"
					],
					"annotation_name": "Guiro",
					"annotation": "The guiro: the last note, and a flash with every hit.",
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
					"text": "js cr_voice_push.js guiro",
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
					"text": "js cr_voice_midi.js 12 13",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						""
					],
					"patching_rect": [
						20,
						290,
						175,
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
									"code": "Param guRate(0);\nParam guDec(0);\nParam guTone(0);\nParam accent(60);\nParam vol(0);\nParam tr12(0);\nParam tr13(0);\nParam vl12(1);\nParam vl13(1);\nParam gt12(0);\nParam gt13(0);\nHistory gui1(0);\nHistory gui2(0);\nHistory guLo(0);\nHistory guA(0);\nHistory guPh(0);\nHistory guRt(0);\nHistory guT(0);\nHistory guH(0);\nHistory guGe(0);\nHistory guG(0);\nHistory guW(1);\nHistory pt12(0);\nHistory pt13(0);\naccA = accent * 0.01;\nvolG = dbtoa(vol);\n\ngug = tan(pi * 5900.0 * exp2(guTone / 12) / samplerate); guk = 0.1;\ngua1 = 1 / (1 + gug * (gug + guk)); gua2 = gug * gua1; gua3 = gug * gua2;\nguLp = 1 - exp(-twopi * 6000.0 / samplerate);\nguWs = 1 / (0.009 * exp2(guDec) * samplerate);\nguRu = exp2(guRate / 12);\nguKa = 1 - exp(-1 / (0.001 * samplerate)); guKr = 1 - exp(-1 / (0.004 * samplerate));\n\nnz = noise();                                   // the one noise source\n\nhit12 = tr12 != pt12; pt12 = tr12; hg12 = (1 - accA) + 1.27 * accA * vl12;\nif (hit12) { guRt = 125 * guRu; guPh = 1; guT = 0; guH = 20.0 * 0.001 * samplerate; guGe = 1; guG = hg12; }\nhit13 = tr13 != pt13; pt13 = tr13; hg13 = (1 - accA) + 1.27 * accA * vl13;\nif (hit13) { guRt = 77 * guRu; guPh = 1; guT = 0; guH = 20.0 * 0.001 * samplerate; guGe = 1; guG = hg13; }\nguOn = ((gt12 + gt13) > 0.5) + (guH > 0.5);\nguOn = (guOn > 0.5) * (guT < 1.0 * samplerate);                  // the note length is the stroke, up to 1 s\nguT = guT + 1; guH = guH - (guH > 0.5);\nguGe = guGe + (guOn * guKa + (1 - guOn) * guKr) * (guOn - guGe);\nguPh = guPh + guOn * guRt / samplerate;\nguPu = guPh >= 1; guPh = guPh - guPu;\nif (guPu) { guW = 0; guA = 1 + 0.38 * nz; }                    // each pulse opens one scrape grain, its level random\nguW = guW + (guW < 1) * guWs * guRt / 77;\nguSw = sin(pi * min(guW, 1)); guX = nz * guSw * guSw * guSw * guA * guG * guGe;\nguv3 = guX - gui2; gub = gua1 * gui1 + gua2 * guv3; gul = gui2 + gua2 * gui1 + gua3 * guv3;\ngui1 = 2 * gub - gui1; gui2 = 2 * gul - gui2;\nguLo = guLo + guLp * (guX - guk * gub - gul - guLo);                      // resonant high-pass, then a gentle low-pass\ngu_out = guLo;\n\nvmix = (gu_out * volG * 0.3 * 0.340700);\naxm = abs(vmix); out1 = sign(vmix) * (min(axm, 0.8) + 0.2 * tanh(max(axm - 0.8, 0) * 5)) + 0 * in1;\nout2 = out1 + 0 * in2;\n",
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
						"rate",
						0
					],
					"destination": [
						"pre_rate_guRate",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_rate_guRate",
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
						"rate",
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
						"pre_decay_guDec",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_decay_guDec",
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
						"stroke",
						0
					],
					"destination": [
						"pre_stroke_pick",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_stroke_pick",
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
						"stroke",
						0
					],
					"destination": [
						"pre_stroke_variant",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_stroke_variant",
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
						"tone",
						0
					],
					"destination": [
						"pre_tone_guTone",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_tone_guTone",
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
			}
		],
		"dependency_cache": [],
		"autosave": 0,
		"parameters": {
			"rate": [
				"Rate",
				"Rate",
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
			"stroke": [
				"Stroke",
				"Stroke",
				0
			],
			"tone": [
				"Tone",
				"Tone",
				0
			],
			"accent": [
				"Accent",
				"Accent",
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
						"Rate",
						"Decay",
						"Stroke",
						"Tone",
						"-",
						"-",
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