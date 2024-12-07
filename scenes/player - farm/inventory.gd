class_name Inventory
extends Node

@export var resources : Dictionary = { }
@export var size_limit : int

signal inventory_change(item_type : Item, new_count: int)

func add_resource(item_type: Item, amount : int) -> void:
	if resources.has(item_type):
		resources[item_type] = resources[item_type] + amount
	else:
		resources[item_type] = amount
	
	inventory_change.emit(item_type, resources[item_type])
