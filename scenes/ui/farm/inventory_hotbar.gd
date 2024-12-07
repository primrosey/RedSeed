class_name InventoryHotbar
extends Control

@onready var player: FarmPlayer = get_tree().get_first_node_in_group("farm_player")
@onready var grid_container: GridContainer = $GridContainer

var inputsDictionary = {
	"hotbar_slot_1":0,
	"hotbar_slot_2":1,
	"hotbar_slot_3":2,
	"hotbar_slot_4":3,
	"hotbar_slot_5":4,
	"hotbar_slot_6":5,
	"hotbar_slot_7":6,
	"hotbar_slot_8":7
}

var hand_equip : HandEquip

func _ready() -> void:
	if player:
		hand_equip = player.hand_equip
		
		for button in grid_container.get_children():
			if button is HotbarSlotButton:
				button.hand_equip = hand_equip
				button.set_new_item(null)
		
		var first_button = grid_container.get_child(0) as HotbarSlotButton
		hand_equip.equipped_item = first_button.current_item
	
	
	
	player.inventory.inventory_change.connect(_on_player_inventory_changed)

func _input(event: InputEvent) -> void:
	for key in inputsDictionary.keys():
		if Input.is_action_pressed(key):
			var slot: HotbarSlotButton = grid_container.get_child(inputsDictionary[key])
			slot.pressed.emit()

func _on_player_inventory_changed(new_item: Item, new_count: int) -> void:
	# find if an existing item of the type exits
	var current_slot : HotbarSlotButton
	
	for slot: HotbarSlotButton in grid_container.get_children():
		if slot.current_item == new_item:
			current_slot = slot
	
	#if none exist, get the first empty slot
	if not current_slot:
		current_slot = _get_first_empty_slot()
	
	#set the item and count
	current_slot.set_new_item(new_item)
	current_slot.update_count(player.inventory.resources[new_item])

func _get_first_empty_slot() -> HotbarSlotButton:
	for slot: HotbarSlotButton in grid_container.get_children():
		if not slot.current_item:
			return slot
	
	return null
