extends Relic

func activate_relic(owner: RelicUI) -> void:
	# slightly hack-y solution used for tutorial to keep EventBus simple
	# may want to actually fragment/break out player events for more fine control
	Events.player_hand_drawn.connect(_add_mana.bind(owner), CONNECT_ONE_SHOT)

func _add_mana(owner: RelicUI) -> void:
	owner.flash()
	var player := owner.get_tree().get_first_node_in_group("player") as Player
	if player:
		player.stats.mana += 1

# we can provide unique tooltips per relic, i.e. if magic numbers (%s) are needed
func get_tooltip() -> String:
	return tooltip
