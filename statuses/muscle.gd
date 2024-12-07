class_name MuscleStatus
extends Status

@export var modifier_id:= "muscle"

func get_tooltip() -> String:
	return tooltip % stacks

func initialize_status(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)

func _on_status_changed(target: Node) -> void:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var dmg_dealt_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DMG_DEALT)
	assert(dmg_dealt_modifier, "No dmg dealt modifier on %s" % target)
	
	var muscle_modifer_value := dmg_dealt_modifier.get_value(modifier_id)
	
	if not muscle_modifer_value:
		muscle_modifer_value = ModifierValue.create_new_modifier(modifier_id,ModifierValue.Type.FLAT)
	
	muscle_modifer_value.flat_value = stacks
	dmg_dealt_modifier.add_new_value(muscle_modifer_value)
