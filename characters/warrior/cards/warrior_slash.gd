extends Card

var base_damage = 4

func get_default_tooltip() -> String:
	var formatted_magic_nums = _apply_text_formats(text_formats,[str(base_damage)])
	return tooltip_text % formatted_magic_nums

func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_dmg := player_modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	
	if enemy_modifiers:
		modified_dmg = enemy_modifiers.get_modified_value(modified_dmg, Modifier.Type.DMG_TAKEN)
	var formatted_magic_nums = _apply_text_formats(text_formats,[str(modified_dmg)])
	return tooltip_text % formatted_magic_nums

func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage,Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets)
