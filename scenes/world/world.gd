class_name World
extends Node2D

@export var current_day: int

@onready var modification_tile_map_layer: TileMapLayer = %ModificationTileMapLayer
@onready var player: FarmPlayer = $Player
@onready var hover_selector: HoverSelector = %HoverSelector

const TILL_TYPE = preload("res://scenes/world/objects/harvestable/types/tillable_resource.tres")

var last_day_seen: int = 1

func _ready() -> void:
	var axe = preload("res://scenes/equipment/axe_copper.tres")
	player.inventory.add_resource(axe,1)
	var pickaxe = preload("res://scenes/equipment/pickaxe_copper.tres")
	player.inventory.add_resource(pickaxe,1)
	var hoe = preload("res://scenes/equipment/hoe_copper.tres")
	player.inventory.add_resource(hoe,1)

func _process(delta) -> void:
	var selector_pos: Vector2i = modification_tile_map_layer.local_to_map(get_global_mouse_position())
	var player_tile_pos : Vector2i = modification_tile_map_layer.local_to_map(player.global_position)
	hover_selector.position = selector_pos * 32
	hover_selector.set_valid_state = (selector_pos - player_tile_pos).length() <= 2
	
	#process use action
	if Input.is_action_just_pressed("use") and hover_selector.is_valid:
		
		var current_equip = player.hand_equip.equipped_item as Item
		if hover_selector.targets.size() == 0:
			if current_equip is not HarvestingTool:
				return
			
			var current_tool = current_equip as HarvestingTool
			if current_tool.effective_node_types.find(TILL_TYPE) == -1:
				return
			
			#set to tilled
			#source_id, atlas coords found by hovering tiles in tilemap
			modification_tile_map_layer.set_cell(selector_pos,1,Vector2i(1,0),0)
		elif hover_selector.targets[0] is ResourceNode:
			hover_selector.targets[0].harvest(1, current_equip)
			return
		
		return

func set_current_day(new_current: int) -> void:
	current_day = new_current
	for i in current_day - last_day_seen:
		for aging_comp: AgingComponent in get_tree().get_nodes_in_group("AgingComponent"):
			aging_comp.set_current_age(aging_comp.current_age + 1)
