class_name HoverSelector
extends Area2D

@onready var texture_rect: TextureRect = $TextureRect
@onready var overlap_detector: CollisionShape2D = $OverlapDetector

@export var set_valid_state: bool : set = _set_valid_state
@export var is_valid: bool = false
@export var targets: Array[Node2D] = []

func _set_valid_state(valid_check: bool = false) -> void:
	if not is_node_ready():
		await ready
	
	if valid_check:
		texture_rect.modulate = Color.GREEN
		is_valid = true
		return
	
	texture_rect.modulate = Color.RED
	is_valid = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("farm_player"):
		return
	
	targets.append(body)


func _on_body_exited(body: Node2D) -> void:
	targets.erase(body)
