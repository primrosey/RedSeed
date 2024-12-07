extends Card

const EXPOSED_STATUS = preload("res://statuses/exposed.tres")

var base_damage := 4
var exposed_duration := 2
var exposed_name = "Exposed"

func get_default_tooltip() -> String:
	var formatted_magic_nums = _apply_text_formats(text_formats,[str(base_damage),str(exposed_duration),exposed_name])
	return tooltip_text % formatted_magic_nums

func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_dmg := player_modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	
	if enemy_modifiers:
		modified_dmg = enemy_modifiers.get_modified_value(modified_dmg, Modifier.Type.DMG_TAKEN)
	
	var formatted_magic_nums = _apply_text_formats(text_formats,[str(modified_dmg),str(exposed_duration),exposed_name])
	return tooltip_text % formatted_magic_nums
	
func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets)
	
	var status_effect := StatusEffect.new()
	var exposed := EXPOSED_STATUS.duplicate()
	exposed.duration = exposed_duration
	status_effect.status = exposed
	status_effect.execute(targets)
