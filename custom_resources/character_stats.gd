class_name CharacterStats
extends Stats

@export_group("Visuals")
@export var character_name: String
@export_multiline var description: String
@export var portrait: Texture

@export_group("Qualities")
@export var qualilities: Array[Quality]

@export_group("Explore Gameplay Data")
@export var starting_deck: CardPile
@export var draftable_cards: CardPile
@export var cards_per_turn: int
@export var max_mana: int
@export var starting_relic: Relic

var mana: int : set = set_mana
var deck: CardPile
var discard: CardPile
var draw_pile: CardPile

#region Qualities
## If the quality already exists, then the level of the existing quality is increased by the levels of the quality being addded
func add_quality(new_quality: Quality) -> void:
	var existing_quality = get_quality(new_quality.id)
	
	if existing_quality:
		existing_quality.change_level(new_quality.level)
	else:
		qualilities.append(new_quality)

## Returns null if a quality with that id was not found
func get_quality(quality_id: String) -> Quality:
	for qual: Quality in qualilities:
		if qual.id == quality_id:
			return qual
	
	return null

#endregion

#region Explore functions
func set_mana(value: int) -> void:
	mana = value
	stats_changed.emit()

func reset_mana() -> void:
	mana = max_mana
	
func take_damage(damage: int) -> void:
	var initial_health := health
	super.take_damage(damage)
	if initial_health > health:
		Events.player_hit.emit()

func can_play_card(card: Card) -> bool:
	return mana>= card.cost

func create_instance() -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.health = max_health
	instance.block = 0
	instance.reset_mana()
	instance.deck = instance.starting_deck.custom_duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard = CardPile.new()
	return instance
#endregion
