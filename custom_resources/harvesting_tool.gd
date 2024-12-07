class_name HarvestingTool
extends EquipableItem

@export var effective_node_types : Array[ResourceNodeType]
@export var min_amount : int = 1
@export var max_amount : int = 1

# if the body interacted with is a resource node that matches one of the effected types
# set for the tool, the resource node will be harvested for an amount between the max and min amounts
func interact_with_body(body: Node2D) -> void:
	if not body:
		return
	
	if body is ResourceNode:
		for type: ResourceNodeType in effective_node_types:
			if body.node_type == type:
				body.harvest(randi_range(min_amount,max_amount))
