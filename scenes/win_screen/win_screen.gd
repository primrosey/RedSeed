class_name WinScreen
extends Control

const MAIN_MENU_PATH = "res://scenes/ui/main_menu.tscn"
const MESSAGE := "The %s\nis victorious!"

@export var character_stats: CharacterStats : set = set_character

@onready var character_portrait: TextureRect = %CharacterPortrait
@onready var message: Label = %Message

func set_character(new_char_stats: CharacterStats) -> void:
	if not is_node_ready():
		await ready
	
	character_stats = new_char_stats
	
	character_portrait.texture = character_stats.portrait
	message.text = MESSAGE % character_stats.character_name

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
