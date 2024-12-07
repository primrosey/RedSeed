extends Card

var base_block := 5

func get_default_tooltip() -> String:
	var formatted_magic_nums = _apply_text_formats(text_formats,[str(base_block)])
	return tooltip_text % formatted_magic_nums

func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_block := player_modifiers.get_modified_value(base_block,Modifier.Type.NO_MODIFIER)
	
	var formatted_magic_nums = _apply_text_formats(text_formats,[str(modified_block)])
	return tooltip_text % formatted_magic_nums

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var block_effect := BlockEffect.new()
	block_effect.amount = base_block
	block_effect.sound = sound
	block_effect.execute(targets)
