class_name QualityChange
extends Control

@export var quality: Quality : set = set_quality
@export var change_amount: int : set = set_change

@onready var icon: TextureRect = %Icon
@onready var description: Label = %Description

var no_change_text = "%s hasn't changed from %s"

func set_quality(new_quality: Quality) -> void:
	if not is_node_ready():
		await ready
	
	quality = new_quality
	icon.texture = quality.icon

func set_change(change: int) -> void:
	if not is_node_ready():
		await ready
	
	var direction_text: String
	var old_level = quality.level
	var limit_level = 0
	
	quality.change_level(change)
	
	if quality.level > old_level:
		direction_text = "increased"
	elif quality.level < old_level:
		direction_text = "decreased"
	elif quality.level == old_level:
		description.text = no_change_text % [quality.display_name, quality.level]
		return
	
	description.text = description.text % [quality.display_name, direction_text, old_level, quality.level]
