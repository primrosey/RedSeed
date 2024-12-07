class_name BattleOverPanel
extends Panel

const MAIN_MENU_PATH = "res://scenes/ui/main_menu.tscn"

enum Type {WIN, LOSE}

@onready var label: Label = %Label
@onready var continue_button: Button = %Continuebutton
@onready var new_game_button: Button = %NewGameButton


func _ready() -> void:
	continue_button.pressed.connect(func(): Events.battle_won.emit())
	new_game_button.pressed.connect(get_tree().change_scene_to_file.bind(MAIN_MENU_PATH))
	Events.battle_over_screen_requested.connect(show_screen)


func show_screen(text: String, type: Type) -> void:
	label.text = text
	continue_button.visible = type == Type.WIN
	new_game_button.visible = type == Type.LOSE
	show()
	get_tree().paused = true
