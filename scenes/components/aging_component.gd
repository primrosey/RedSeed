class_name AgingComponent
extends Node
# Track object age and can replace target scene (usually parent)
# with a new scene after reaching an age_threashold

signal age_changed(new_age : float, last_age: float)
signal age_threshold_reached(new_scene : Node2D)

@export var target : Node2D #scene that will be replaced with next_scene
@export var current_age = 0.0 : set = set_current_age
@export var age_threashold = 1.0
#aging idea: event bus age event, connect to it for each time change?
@export var next_scene : PackedScene

static var GROUP_NAME = "AgingComponent"

var _threshold_reached = false

func _ready() -> void:
	if not target:
		target = get_parent()
	
	add_to_group(GROUP_NAME)

func set_current_age(value: float) -> void:
	if current_age != value:
		var last_age = current_age
		current_age = value
		self.age_changed.emit(current_age, last_age)
		
		if current_age >= age_threashold and not _threshold_reached:
			var new_scene : Node2D
			
			if next_scene:
				new_scene = _create_next_scene()
			
			self.age_threshold_reached.emit(new_scene)
			_threshold_reached = true
			target.queue_free()

func _create_next_scene() -> Node2D:
	var instance = next_scene.instantiate() as Node2D
	target.get_parent().add_child(instance)
	instance.global_transform = target.global_transform
	return instance
