extends Control

const CHAR_SELECTOR_SCENE := preload("res://scenes/ui/character_selector.tscn")
const RUN_SCENE := preload("res://scenes/run/run.tscn")

@export var run_statup: RunStartup

@onready var contune_button: Button = %Contune

func _ready() -> void:
	get_tree().paused = false
	contune_button.disabled = SaveGame.load_data() == null

func _on_contune_pressed() -> void:
	run_statup.type = RunStartup.Type.CONTINUED_RUN
	get_tree().change_scene_to_packed(RUN_SCENE)

func _on_new_run_pressed() -> void:
	get_tree().change_scene_to_packed(CHAR_SELECTOR_SCENE)


func _on_exit_pressed() -> void:
	get_tree().quit()
