class_name HotbarSlotButton
extends Button

@export var current_item: Item : set = set_new_item

@onready var count_label: Label = %CountLabel

var hand_equip : HandEquip

func _ready() -> void:
	if current_item:
		set_new_item(current_item)
	else:
		icon = null

func set_new_item(item_to_slot: Item) -> void:
	if not is_node_ready():
		await ready
	
	current_item = item_to_slot
	
	if current_item:
		icon = current_item.texture
	else:
		icon = null
	update_count(1)


func update_count(count : int) -> void:
	if count == 1:
		count_label.text = ""
		return
	
	count_label.text = str(count)

func _on_pressed() -> void:
	if current_item is EquipableItem and hand_equip:
		hand_equip.equipped_item = current_item
	else:
		hand_equip.equipped_item = null
