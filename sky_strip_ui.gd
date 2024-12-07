class_name SkyStripUI
extends Control

@export var is_day: bool
@export_range(0,2) var current_period: int : set = set_current_period
@export_range(1,6) var moon_phase: int = 3

@onready var sky_strip: TextureRect = %SkyStrip
@onready var sun: Sprite2D = %Sun
@onready var moon: Sprite2D = %Moon

var moon_region_size = 16 #px
var transition_region_size = 15 #px

var positioning_step = 30

func set_time(daytime: bool, period: int) -> void:
	is_day = daytime
	set_current_period(period)

func set_current_period(new_period: int) -> void:
	if not is_node_ready():
		await ready
	
	current_period = new_period
	sun.visible = is_day
	moon.visible = not is_day
	moon.region_rect = Rect2i(moon_phase * moon_region_size,0,moon_region_size, moon_region_size)
	
	sun.position.x = (0.5 + current_period) * positioning_step
	sun.position.y = self.size.y / 2
	
	moon.position = sun.position
	
	var night_offset = sky_strip.texture.get_width() / 2
	
	if is_day:
		night_offset = 0
	
	sky_strip.position.x = -(current_period * transition_region_size) - night_offset

func advance_time() -> void:
	var new_period = current_period + 1
	var daytime = is_day
	
	if new_period > 2:
		new_period = 0
		daytime = not daytime
		
		if daytime:
			Events.dawn.emit()
	
	set_time(daytime, new_period)

func next_mid_period() -> void:
	advance_time()
	while current_period != 1:
		advance_time()
