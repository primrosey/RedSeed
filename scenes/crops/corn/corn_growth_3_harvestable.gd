extends ResourceNode

@export var next_scene : PackedScene = load("res://scenes/crops/corn/corn_growth_3.tscn")

func harvest(amount: int, used_tool: Item) -> void:
	for n in current_resources:
		spawn_resource()
	
	var instance = next_scene.instantiate() as Node2D
	self.get_parent().add_child(instance)
	instance.global_transform = self.global_transform
	self.queue_free()
