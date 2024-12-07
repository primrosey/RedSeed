extends Relic

@export var bonus_block := 3

func activate_relic(owner: RelicUI) -> void:
	var player := owner.get_tree().get_nodes_in_group("player") #block effect expects an array of nodes
	var block_effect := BlockEffect.new()
	block_effect.amount = bonus_block
	block_effect.execute(player)
	
	owner.flash()

# we can provide unique tooltips per relic, i.e. if magic numbers (%s) are needed
func get_tooltip() -> String:
	return tooltip % 3
