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
		"description": "Guiro: a scraper (guiro, samba reco-reco): a train of ridge impacts at a stroke-speed rate ringing the instrument, the guiro fitted to Latin Percussion recordings, the reco-reco (metal box with springs) to a Freesound one.",
		"boxes": [
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
						280,
						110,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "sc_vary",
					"maxclass": "newobj",
					"text": "* 0.01",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						280,
						80,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "vary",
					"varname": "vary",
					"parameter_enable": 1,
					"annotation_name": "Vary",
					"annotation": "Vary: how uneven the hand is: ridge-to-ridge timing (up to +-17 %) and level (up to -3 dB). 0 is a machine.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Vary",
							"parameter_shortname": "Vary",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								50
							],
							"parameter_unitstyle": 5
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
						135.0,
						116.0,
						45.0,
						50.0
					],
					"patching_rect": [
						1690,
						420,
						45,
						50
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
						280,
						20,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "tone",
					"varname": "tone",
					"parameter_enable": 1,
					"annotation_name": "Tone",
					"annotation": "Tone: moves the click's filters and the body modes up or down, in semitones: a smaller or bigger instrument.",
					"saved_attribute_attributes": {
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
					"maxclass": "live.dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [
						"",
						"float"
					],
					"presentation": 1,
					"presentation_rect": [
						90.0,
						116.0,
						45.0,
						50.0
					],
					"patching_rect": [
						2230,
						340,
						45,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_ridge",
					"maxclass": "newobj",
					"text": "prepend ridge",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						1160,
						91,
						22
					]
				}
			},
			{
				"box": {
					"id": "sc_ridge",
					"maxclass": "newobj",
					"text": "* 0.01",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						1130,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "ridge",
					"varname": "ridge",
					"parameter_enable": 1,
					"annotation_name": "Ridge",
					"annotation": "Ridge: how many ridges there are along the instrument (the density): few and wide apart are separate ticks, many a rasp; the stroke keeps its length. 100 % is the middle of the recordings (about 100-170 ridges a second); the four takes in the pack range from 40 to 250.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Ridge",
							"parameter_shortname": "Ridge",
							"parameter_type": 0,
							"parameter_mmin": 25.0,
							"parameter_mmax": 400.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								100
							],
							"parameter_unitstyle": 5,
							"parameter_exponent": 2.32
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
						45.0,
						116.0,
						45.0,
						50.0
					],
					"patching_rect": [
						1960,
						340,
						45,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_speed",
					"maxclass": "newobj",
					"text": "prepend speed",
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
					"id": "sc_speed",
					"maxclass": "newobj",
					"text": "* 0.01",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						1040,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "speed",
					"varname": "speed",
					"parameter_enable": 1,
					"annotation_name": "Speed",
					"annotation": "Speed: how fast the hand moves the stick: 200 % crosses the same ridges in half the time (twice the ticks per second, a stroke half as long); 50 % is slow and twice as long. The loudness stays the same.",
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Speed",
							"parameter_shortname": "Speed",
							"parameter_type": 0,
							"parameter_mmin": 25.0,
							"parameter_mmax": 400.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								100
							],
							"parameter_unitstyle": 5,
							"parameter_exponent": 2.32
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
						45.0,
						50.0
					],
					"patching_rect": [
						1690,
						340,
						45,
						50
					]
				}
			},
			{
				"box": {
					"id": "pre_volume",
					"maxclass": "newobj",
					"text": "prepend vol",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						980,
						77,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_volume",
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
						116.0,
						82.0,
						44.0,
						12.0
					],
					"patching_rect": [
						2230,
						260,
						44,
						12
					]
				}
			},
			{
				"box": {
					"id": "volume",
					"varname": "volume",
					"parameter_enable": 1,
					"annotation_name": "Level",
					"annotation": "Output level. Velocity is the stroke's energy.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Level",
							"parameter_shortname": "Level",
							"parameter_type": 0,
							"parameter_mmin": -36.0,
							"parameter_mmax": 6.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								-6
							],
							"parameter_unitstyle": 4
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
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						116.0,
						82.0,
						44.0,
						12.0
					],
					"patching_rect": [
						2140,
						260,
						44,
						12
					]
				}
			},
			{
				"box": {
					"id": "pre_pan",
					"maxclass": "newobj",
					"text": "prepend pan",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						890,
						77,
						22
					]
				}
			},
			{
				"box": {
					"id": "sc_pan",
					"maxclass": "newobj",
					"text": "* 0.01",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						860,
						42,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_pan",
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
						116.0,
						69.0,
						44.0,
						12.0
					],
					"patching_rect": [
						1870,
						260,
						44,
						12
					]
				}
			},
			{
				"box": {
					"id": "pan",
					"varname": "pan",
					"parameter_enable": 1,
					"annotation_name": "Pan",
					"annotation": "Position in the stereo field.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Pan",
							"parameter_shortname": "Pan",
							"parameter_type": 0,
							"parameter_mmin": -100.0,
							"parameter_mmax": 100.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%+d"
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
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						116.0,
						69.0,
						44.0,
						12.0
					],
					"patching_rect": [
						1780,
						260,
						44,
						12
					]
				}
			},
			{
				"box": {
					"id": "pre_stroke",
					"maxclass": "newobj",
					"text": "prepend strokemode",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						770,
						126,
						22
					]
				}
			},
			{
				"box": {
					"id": "ol_stroke",
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
						66.0,
						96.0,
						56.0,
						12.0
					],
					"patching_rect": [
						1600,
						260,
						56,
						12
					]
				}
			},
			{
				"box": {
					"id": "stroke",
					"varname": "stroke",
					"parameter_enable": 1,
					"annotation_name": "Stroke",
					"annotation": "Stroke: which stroke a note plays. Key: by the note, C Up, C# Down, D Long, D# Top, then the same again (E Up ...). Up / Down / Long / Top: always that stroke, for a Drum Rack pad that sends one fixed note. Alternate: Up, Down, Up ... on every new note.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Stroke",
							"parameter_shortname": "Stroke",
							"parameter_type": 2,
							"parameter_enum": [
								"Key",
								"Up",
								"Down",
								"Long",
								"Top",
								"Alternate"
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
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						66.0,
						94.0,
						56.0,
						12.0
					],
					"patching_rect": [
						2230,
						180,
						56,
						12
					]
				}
			},
			{
				"box": {
					"id": "pre_roll",
					"maxclass": "newobj",
					"text": "prepend roll",
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
					"id": "ol_roll",
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
						44.0,
						12.0
					],
					"patching_rect": [
						2050,
						180,
						44,
						12
					]
				}
			},
			{
				"box": {
					"id": "roll",
					"varname": "roll",
					"parameter_enable": 1,
					"annotation_name": "Roll",
					"annotation": "Roll: 0 is off (one stroke per note). Above 0, a held note keeps scraping, this many strokes per second, until you let go: Up and Down alternate.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Roll",
							"parameter_shortname": "Roll",
							"parameter_type": 0,
							"parameter_mmin": 0.0,
							"parameter_mmax": 12.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								0
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%.1f Hz"
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
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						68.0,
						82.0,
						44.0,
						12.0
					],
					"patching_rect": [
						1960,
						180,
						44,
						12
					]
				}
			},
			{
				"box": {
					"id": "pre_length",
					"maxclass": "newobj",
					"text": "prepend len",
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
					"id": "ol_length",
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
						69.0,
						44.0,
						12.0
					],
					"patching_rect": [
						1780,
						180,
						44,
						12
					]
				}
			},
			{
				"box": {
					"id": "length",
					"varname": "length",
					"parameter_enable": 1,
					"annotation_name": "Length",
					"annotation": "Length: how long the Long stroke is, in milliseconds (the recordings run 450-600 ms). Up, Down and Top have their own fixed lengths.",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"bordercolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Length",
							"parameter_shortname": "Length",
							"parameter_type": 0,
							"parameter_mmin": 100.0,
							"parameter_mmax": 1500.0,
							"parameter_initial_enable": 1,
							"parameter_initial": [
								450
							],
							"parameter_unitstyle": 9,
							"parameter_units": "%d ms"
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
					"fontsize": 9.0,
					"presentation": 1,
					"presentation_rect": [
						68.0,
						69.0,
						44.0,
						12.0
					],
					"patching_rect": [
						1690,
						180,
						44,
						12
					]
				}
			},
			{
				"box": {
					"id": "pre_type_view",
					"maxclass": "newobj",
					"text": "prepend type",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [
						""
					],
					"patching_rect": [
						20,
						500,
						84,
						22
					]
				}
			},
			{
				"box": {
					"id": "pre_type",
					"maxclass": "newobj",
					"text": "prepend type",
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
					"id": "type",
					"varname": "type",
					"parameter_enable": 1,
					"annotation_name": "Type",
					"annotation": "Type: G\u00fciro (a gourd with cut ridges: a dry, bright tick per ridge and a low body knock, fitted to recordings) or Reco (the samba reco-reco: a metal box with tensioned steel springs scraped by a rod: a bright, raspy scrape over ringing spring lines; fitted to one amateur recording, so rougher than the G\u00fciro).",
					"saved_attribute_attributes": {
						"lcdcolor": {
							"expression": "themecolor.live_lcd_control_fg"
						},
						"valueof": {
							"parameter_longname": "Type",
							"parameter_shortname": "Type",
							"parameter_type": 2,
							"parameter_enum": [
								"G\u00fciro",
								"Reco"
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
						75.0,
						58.0,
						24.0
					],
					"patching_rect": [
						2140,
						100,
						58,
						24
					]
				}
			},
			{
				"box": {
					"id": "hdr_Out",
					"maxclass": "comment",
					"text": "Out",
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
						114.0,
						55.0,
						48.0,
						14.0
					],
					"patching_rect": [
						2050,
						100,
						48,
						14
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
						55.0,
						48.0,
						14.0
					],
					"patching_rect": [
						1960,
						100,
						48,
						14
					]
				}
			},
			{
				"box": {
					"id": "hdr_Type",
					"maxclass": "comment",
					"text": "Type",
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
						55.0,
						62.0,
						14.0
					],
					"patching_rect": [
						1870,
						100,
						62,
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
						320,
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
					"text": "js guiro_push.js",
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
					"filename": "guiro_view.js",
					"border": 0,
					"parameter_enable": 0,
					"annotation_name": "Guiro",
					"annotation": "The instrument: the last note, and the stick scraping across the ridges with every stroke.",
					"presentation": 1,
					"presentation_rect": [
						8.0,
						8.0,
						164.0,
						48.0
					],
					"patching_rect": [
						1690,
						100,
						164,
						48
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
					"id": "midi",
					"maxclass": "newobj",
					"text": "js guiro_midi.js",
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
									"code": "// Guiro engine. GENERATED by scripts/guiro_engine.py: do not edit.\nParam type(0.0);\nParam stk(0.0);\nParam len(450.0);\nParam speed(1.0);\nParam ridge(1.0);\nParam tone(0.0);\nParam vary(0.5);\nParam vol(-6.0);\nParam pan(0.0);\nParam tr(0.0);\nParam vl(0.0);\nHistory ltr(0);\nHistory ts(1000000000.0);\nHistory ph(0);\nHistory jt(0);\nHistory sdur(0);\nHistory srm(0);\nHistory scv(0);\nHistory satt(0);\nHistory stap(0);\nHistory samp(0);\nHistory snd(0);\nHistory slw(0);\nHistory slw2(0);\nHistory hx1(0);\nHistory hx2(0);\nHistory hz1(0);\nHistory hz2(0);\nHistory jx1(0);\nHistory jx2(0);\nHistory jz1(0);\nHistory jz2(0);\nHistory r0x1(0);\nHistory r0x2(0);\nHistory r0z1(0);\nHistory r0z2(0);\nHistory r0y1(0);\nHistory r0y2(0);\nHistory r1x1(0);\nHistory r1x2(0);\nHistory r1z1(0);\nHistory r1z2(0);\nHistory r1y1(0);\nHistory r1y2(0);\nHistory r2x1(0);\nHistory r2x2(0);\nHistory r2z1(0);\nHistory r2z2(0);\nHistory r2y1(0);\nHistory r2y2(0);\nt0 = abs(type - 0) < 0.5;\nt1 = abs(type - 1) < 0.5;\ns0 = abs(stk - 0) < 0.5;\ns1 = abs(stk - 1) < 0.5;\ns2 = abs(stk - 2) < 0.5;\ns3 = abs(stk - 3) < 0.5;\n\nnewn = tr != ltr;\nltr = tr;\nmsr = samplerate * 0.001;\n// stroke constants are latched at the note (a new note restarts the gesture; the ring of the old one carries on); a faster stick crosses the\n// same ridges in less time (length / speed), so Speed changes the rate and the length, Ridge the rate only\nsdur = newn * (s0 * 80.0 + s1 * 115.0 + s2 * len + s3 * 0.0) * msr / speed + (1 - newn) * sdur;\nsrm = newn * (s0 * 1.35 + s1 * 0.9 + s2 * 0.8 + s3 * 0.0) + (1 - newn) * srm;\nscv = newn * (s0 * 0.0 + s1 * 0.35 + s2 * 0.1 + s3 * 0.0) + (1 - newn) * scv;\nsatt = newn * (s0 * 0.8 + s1 * 0.3 + s2 * 0.7 + s3 * 1.0) + (1 - newn) * satt;\nstap = newn * (s0 * 2.4 + s1 * 1.8 + s2 * 0.8 + s3 * 0.0) + (1 - newn) * stap;\nsamp = newn * vl + (1 - newn) * samp;\nts = (1 - newn) * (ts + 1);\nu = ts / (sdur + 1);\non = ts < sdur;\n\n// the gesture: impacts at a rate = ridge x speed x stroke factor x a slight curve; one fires with the note, then one per phase wrap\nrt = 130.0 * (t0 * 1.0 + t1 * 3.0) * ridge * speed * srm * (1 + scv * (0.5 - u) * 2);\nrt = rt * (rt > 0) * on;\nph = (1 - newn) * (ph + rt / samplerate * (1 + jt));\nfire = newn + (1 - newn) * (ph >= 1);\nph = ph - (1 - newn) * (ph >= 1);\njt = fire * vary * 0.35 * noise() + (1 - fire) * jt;\ng = (satt + (1 - satt) * clamp(u / 0.4, 0, 1)) * exp(-stap * clamp((u - 0.4) / 0.6, 0, 1));\na = samp * g * (1 - vary * 0.7 * abs(noise()));\n\n// level: a fast click and a slow body ring, both kicked by every impact; grain gain normalised for the overlap\ngl = (t0 * 1.406 + t1 * 2.016);\nsd = exp(-1 / (gl * msr));\nrd = exp(-1 / ((t0 * 12.42 + t1 * 50.82) * msr));\nrd2 = exp(-1 / ((t0 * 43.24 + t1 * 58.52) * msr));\nnr = 130.0 * (t0 * 1.0 + t1 * 3.0) * (s3 + (1 - s3) * ridge * speed * ((s0 * 1.35 + s1 * 0.9 + s2 * 0.8 + s3 * 0.0) + s3));\ngx = nr * gl * 0.001;\ngr = (t0 * (s0 * 0.4921 + s1 * 0.4977 + s2 * 0.3462 + s3 * 0.3379) + t1 * (s0 * 0.3655 + s1 * 0.3739 + s2 * 0.2592 + s3 * 0.8201)) / sqrt(0.36 * gx * gx + 0.2067 * gx);\nsnd = fixdenorm(snd * sd + fire * a * gr * (0.3 + 0.7 * abs(noise())));\nsnd = snd * (snd > 0.000000001);\nslw = fixdenorm(slw * rd + fire * a * gr * ((t0 * 0.02257 + t1 * 0.001511) * (1 - s3) + (t0 * 0.1487 + t1 * 0.08537) * s3));\nslw = slw * (slw > 0.000000001);\nslw2 = fixdenorm(slw2 * rd2 + fire * a * gr * (t0 * 0.005958 + t1 * 0.02649));\nslw2 = slw2 * (slw2 > 0.000000001);\nraw = (snd + slw + slw2) * noise();\n\n// the 4th-order high-pass, then three band-pass resonances (RBJ, constant 0 dB peak), shifted together by Tone\nks = pow(2, tone / 12);\nfmx = 0.42 * samplerate;\nfh = (t0 * 229.8 + t1 * 1653.0) * ks;\nfh = fh / pow(1 + pow(fh / fmx, 4), 0.25);\nwh = twopi * fh / samplerate;\nalh = sin(wh) / (2 * (t0 * 2.145 + t1 * 0.5643));\niah = 1 / (1 + alh);\nchh = cos(wh);\nhb = (1 + chh) * 0.5 * iah;\nh1 = hb * (raw - 2 * hx1 + hx2) + 2 * chh * iah * hz1 - (1 - alh) * iah * hz2;\nhx2 = hx1;\nhx1 = raw;\nhz2 = fixdenorm(hz1);\nhz1 = fixdenorm(h1);\ninp = hb * (h1 - 2 * jx1 + jx2) + 2 * chh * iah * jz1 - (1 - alh) * iah * jz2;\njx2 = jx1;\njx1 = h1;\njz2 = fixdenorm(jz1);\njz1 = fixdenorm(inp);\nacc = 0;\nfr0 = (t0 * 4004.0 + t1 * 7880.0) * ks * (1 + s3 * ((t0 * 1.8 + t1 * 0.8882) - 1));\nfr0 = fr0 / pow(1 + pow(fr0 / fmx, 4), 0.25);\nw0 = twopi * fr0 / samplerate;\nal0 = sin(w0) / (2 * (t0 * 5.653 + t1 * 1.633));\nia0 = 1 / (1 + al0);\nb0 = al0 * ia0;\nc10 = -2 * cos(w0) * ia0;\nc20 = (1 - al0) * ia0;\nyy0 = b0 * (inp - r0x2) - c10 * r0z1 - c20 * r0z2;\nr0x2 = r0x1;\nr0x1 = inp;\nr0z2 = fixdenorm(r0z1);\nr0z1 = fixdenorm(yy0);\nacc = acc + yy0 * (t0 * 1.164 + t1 * 1.367);\nfr1 = (t0 * 6279.0 + t1 * 12590.0) * ks * (1 + s3 * ((t0 * 1.8 + t1 * 0.8882) - 1));\nfr1 = fr1 / pow(1 + pow(fr1 / fmx, 4), 0.25);\nw1 = twopi * fr1 / samplerate;\nal1 = sin(w1) / (2 * (t0 * 5.681 + t1 * 1.599));\nia1 = 1 / (1 + al1);\nb1 = al1 * ia1;\nc11 = -2 * cos(w1) * ia1;\nc21 = (1 - al1) * ia1;\nyy1 = b1 * (inp - r1x2) - c11 * r1z1 - c21 * r1z2;\nr1x2 = r1x1;\nr1x1 = inp;\nr1z2 = fixdenorm(r1z1);\nr1z1 = fixdenorm(yy1);\nacc = acc + yy1 * (t0 * 1.532 + t1 * 0.9958);\nfr2 = (t0 * 3634.0 + t1 * 3195.0) * ks * (1 + s3 * ((t0 * 1.8 + t1 * 0.8882) - 1));\nfr2 = fr2 / pow(1 + pow(fr2 / fmx, 4), 0.25);\nw2 = twopi * fr2 / samplerate;\nal2 = sin(w2) / (2 * (t0 * 2.569 + t1 * 1.498));\nia2 = 1 / (1 + al2);\nb2 = al2 * ia2;\nc12 = -2 * cos(w2) * ia2;\nc22 = (1 - al2) * ia2;\nyy2 = b2 * (inp - r2x2) - c12 * r2z1 - c22 * r2z2;\nr2x2 = r2x1;\nr2x1 = inp;\nr2z2 = fixdenorm(r2z1);\nr2z1 = fixdenorm(yy2);\nacc = acc + yy2 * (t0 * 1.717 + t1 * 1.097);\n\n// the gourd's body: three tonal modes rung by an impulse per impact (amplitude a); a held gourd (scrape) rings less (bs)\nbi = fire * a * (t0 * (s0 * 0.4921 + s1 * 0.4977 + s2 * 0.3462 + s3 * 0.3379) + t1 * (s0 * 0.3655 + s1 * 0.3739 + s2 * 0.2592 + s3 * 0.8201)) * ((t0 * 0.3672 + t1 * 0.6968) * (1 - s3) * (s0 * 1.2 + s1 * 0.35 + s2 * 0.7 + s3 * 1.0) + (t0 * 0.35 + t1 * 1.021) * s3);\nbw0 = twopi * (t0 * 305.8 + t1 * 1606.0) * ks / samplerate;\nbr0 = exp(-1 / ((t0 * 100.0 + t1 * 128.3) * msr));\nby0 = bi * sin(bw0) * (t0 * 0.03922 + t1 * 0.09882) + 2 * br0 * cos(bw0) * r0y1 - br0 * br0 * r0y2;\nr0y2 = fixdenorm(r0y1);\nr0y1 = fixdenorm(by0);\nacc = acc + by0;\nbw1 = twopi * (t0 * 1200.0 + t1 * 2659.0) * ks / samplerate;\nbr1 = exp(-1 / ((t0 * 60.0 + t1 * 327.7) * msr));\nby1 = bi * sin(bw1) * (t0 * 0.1022 + t1 * 0.05797) + 2 * br1 * cos(bw1) * r1y1 - br1 * br1 * r1y2;\nr1y2 = fixdenorm(r1y1);\nr1y1 = fixdenorm(by1);\nacc = acc + by1;\nbw2 = twopi * (t0 * 1523.0 + t1 * 3323.0) * ks / samplerate;\nbr2 = exp(-1 / ((t0 * 30.42 + t1 * 75.57) * msr));\nby2 = bi * sin(bw2) * (t0 * 0.1583 + t1 * 0.1982) + 2 * br2 * cos(bw2) * r2y1 - br2 * br2 * r2y2;\nr2y2 = fixdenorm(r2y1);\nr2y1 = fixdenorm(by2);\nacc = acc + by2;\n\nacc = acc * dbtoa(vol);\npa = (pan + 1) * 0.25 * pi;\nout1 = clamp(acc * cos(pa), -1, 1);\nout2 = clamp(acc * sin(pa), -1, 1);\n",
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
						"type",
						0
					],
					"destination": [
						"pre_type",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_type",
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
						"type",
						0
					],
					"destination": [
						"pre_type_view",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_type_view",
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
						"type",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"length",
						0
					],
					"destination": [
						"pre_length",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_length",
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
						"length",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"roll",
						0
					],
					"destination": [
						"pre_roll",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_roll",
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
						"load",
						0
					],
					"destination": [
						"roll",
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
						"midi",
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
						"pan",
						0
					],
					"destination": [
						"sc_pan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sc_pan",
						0
					],
					"destination": [
						"pre_pan",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_pan",
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
						"pan",
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
						"speed",
						0
					],
					"destination": [
						"sc_speed",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sc_speed",
						0
					],
					"destination": [
						"pre_speed",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_speed",
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
						"speed",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"ridge",
						0
					],
					"destination": [
						"sc_ridge",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sc_ridge",
						0
					],
					"destination": [
						"pre_ridge",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"pre_ridge",
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
						"ridge",
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
						"vary",
						0
					],
					"destination": [
						"sc_vary",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"sc_vary",
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
			}
		],
		"dependency_cache": [],
		"autosave": 0,
		"parameters": {
			"type": [
				"Type",
				"Type",
				0
			],
			"length": [
				"Length",
				"Length",
				0
			],
			"roll": [
				"Roll",
				"Roll",
				0
			],
			"stroke": [
				"Stroke",
				"Stroke",
				0
			],
			"pan": [
				"Pan",
				"Pan",
				0
			],
			"volume": [
				"Level",
				"Level",
				0
			],
			"speed": [
				"Speed",
				"Speed",
				0
			],
			"ridge": [
				"Ridge",
				"Ridge",
				0
			],
			"tone": [
				"Tone",
				"Tone",
				0
			],
			"vary": [
				"Vary",
				"Vary",
				0
			],
			"parameterbanks": {
				"0": {
					"index": 0,
					"name": "Scrape",
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
						"Type",
						"Stroke",
						"Length",
						"Speed",
						"Ridge",
						"Vary",
						"Tone",
						"Level"
					]
				},
				"1": {
					"index": 1,
					"name": "Out",
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
						"Roll",
						"Pan",
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