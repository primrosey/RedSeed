# meta-name: Card Logic
# meta-description: What happens when a card is played
extends Card

@export var optional_sound: AudioStream

func get_default_tooltip() -> String:
	#apply formats to tooltip_text
	return tooltip_text

func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	#apply modifiers to magic numbers
	#apply formats to tooltip_text
	return tooltip_text

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	print("My awesome card has been played!")
	print("Targets: %s" % targets)
