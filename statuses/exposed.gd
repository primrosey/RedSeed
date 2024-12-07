class_name ExposedStatus
extends Status

const MODIFIER := 0.5

@export var modifier_id:= "exposed"

func get_tooltip() -> String:
	return tooltip % duration

func initialize_status(target: Node) -> void:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var dmg_taken_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DMG_TAKEN)
	assert(dmg_taken_modifier, "No dmg taken modifier on %s" % target)
	
	var exposed_modifer_value := dmg_taken_modifier.get_value(modifier_id)
	
	if not exposed_modifer_value:
		exposed_modifer_value = ModifierValue.create_new_modifier(modifier_id,ModifierValue.Type.PERCENT_BASED)
		exposed_modifer_value.percent_value = MODIFIER
		dmg_taken_modifier.add_new_value(exposed_modifer_value)
	
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(dmg_taken_modifier))

func _on_status_changed(dmg_taken_modifier: Modifier) -> void:
	if duration <= 0 and dmg_taken_modifier:
		dmg_taken_modifier.remove_value(modifier_id)
