class_name HandEquip
extends Sprite2D

@export var equipped_item : EquipableItem : set = set_equipped_item

@onready var equip_hitbox: Area2D = %EquipHitbox

func set_equipped_item(new_equip: EquipableItem) -> void:
	if new_equip:
		equipped_item = new_equip
		texture = equipped_item.texture
	else: 
		equipped_item = null
		texture = null
	
