class_name AgeIncrementButton
extends Button

@export var age_on_press = 1.0

const MESSAGE := "+%s Day"

func _ready() -> void:
	self.pressed.connect(_on_pressed)
	self.text = MESSAGE % age_on_press

func _on_pressed() -> void:
	_age()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cheat_grow"):
		_age()

func _age() -> void:
	for aging_component in get_tree().get_nodes_in_group(AgingComponent.GROUP_NAME):
		if aging_component is AgingComponent:
			aging_component.current_age += 1
		else:
			push_error(aging_component.name + " is not an aging component")
