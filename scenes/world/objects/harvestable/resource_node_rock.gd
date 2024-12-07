class_name ResourceNode
extends StaticBody2D

@export var node_type : ResourceNodeType
@export var starting_resources : int = 1


@export_category("Pickup Values")
@export var pickup_dropped : PackedScene
@export var launch_speed : float = 100
@export var launch_time : float = 0.25

var current_resources : int

func _ready() -> void:
	current_resources = starting_resources

func harvest(amount: int, used_equipment: Item) -> void:
	if used_equipment is not HarvestingTool:
		return
	
	var used_tool: HarvestingTool = used_equipment
	if used_tool.effective_node_types.find(node_type) == -1:
		return
	
	for n in amount:
		spawn_resource()
	
	current_resources = clampi(current_resources - amount, 0, starting_resources)
	if current_resources <= 0:
		queue_free()

func spawn_resource() -> void:
	var pickup_instance : Pickup = pickup_dropped.instantiate() as Pickup
	get_tree().get_first_node_in_group("pickups").add_child(pickup_instance)
	pickup_instance.position = position
	var direction : Vector2 = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()
	pickup_instance.launch(launch_speed * direction, launch_time)
