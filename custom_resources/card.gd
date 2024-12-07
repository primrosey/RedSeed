class_name Card
extends Resource

enum Type {ATTACK, SKILL, POWER}
enum Rarity {COMMON, UNCOMMON, RARE}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

const RARITY_COLORS := {
	Card.Rarity.COMMON: Color.GRAY,
	Card.Rarity.UNCOMMON: Color.CORNFLOWER_BLUE,
	Card.Rarity.RARE: Color.GOLD,
}

@export_group("Card_Attributes")
@export var id: String
@export var type: Type
@export var rarity: Rarity
@export var target: Target
@export var cost: int
@export var exhausts: bool = false

@export_group("Card Visuals")
@export var name: String
@export var icon: Texture
@export_multiline var tooltip_text: String
@export var text_formats: Array[TextFormat]
@export var sound: AudioStream

func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY


func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []
	
	var tree := targets[0].get_tree()
	
	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("enemies")
		Target.EVERYONE:
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("enemies")
		_:
			return []

func play(targets: Array[Node], char_stats: CharacterStats, modifiers: ModifierHandler) -> void:
	Events.card_played.emit(self)
	char_stats.mana -= cost
	
	if is_single_targeted():
		apply_effects(targets, modifiers)
	else: 
		apply_effects(_get_targets(targets), modifiers)

#virtual methods, each Card must implement this on it's own
func apply_effects(_targets: Array[Node], modifiers: ModifierHandler) -> void:
	pass

func get_default_tooltip() -> String:
	return tooltip_text

func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text

func _apply_text_formats(formats: Array[TextFormat], magic_text_values: Array[String]) -> Array[String]:
	
	var formatted_magic_text: Array[String]
	
	for i in max(formats.size(),magic_text_values.size()):
		if formats[i] and magic_text_values[i]:
			formatted_magic_text.append(formats[i].format_text(magic_text_values[i]))
		elif magic_text_values[i]:
			formatted_magic_text.append(magic_text_values[i])
		else:
			formatted_magic_text.append("")
	
	return formatted_magic_text
