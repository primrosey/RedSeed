class_name Pickup
extends Area2D

@export var resource_type : ItemResource
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var launch_velocity : Vector2 = Vector2.ZERO
var move_duration : float = 0
var time_since_launch: float = 0
var launching : bool = false : set = _set_is_launching

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _process(delta: float) -> void:
	if launching:
		position += launch_velocity * delta
		time_since_launch += delta
		
		if time_since_launch >= move_duration:
			launching = false
			

func launch(velocity : Vector2, duration : float) -> void:
	launch_velocity = velocity
	move_duration = duration
	launching = true

func _set_is_launching(is_launching: bool = false):
	if not is_node_ready():
		await ready
	
	launching =  is_launching
	
	collision_shape_2d.disabled = launching

func _on_body_entered(body) -> void:
	if not body.is_in_group("farm_player"):
		return
	
	var inventory = body.inventory as Inventory
	
	if not inventory.resources.size() == inventory.size_limit:
		inventory.add_resource(resource_type, 1)
		queue_free()
