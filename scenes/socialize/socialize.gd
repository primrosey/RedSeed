class_name Socialize
extends Node

const LOCATION_CARD_SCENE := preload("res://scenes/components/location_card_select.tscn")

@export var run_startup: RunStartup

@onready var map: Map = $Map
@onready var current_view: Node = $CurrentView
@onready var health_ui: HealthUI = %HealthUI
@onready var gold_ui: GoldUI = %GoldUI
@onready var relic_handler: RelicHandler = %RelicHandler
@onready var relic_tooltip: RelicTooltip = %RelicTooltip
@onready var deck_button: CardPileOpener = %DeckButton
@onready var deck_view: CardPileView = %DeckView
@onready var pause_menu: PauseMenu = $PauseMenu

@onready var location_button: Button = %LocationButton

var run_stats: RunStats
var character: CharacterStats
var save_data: SaveGame

func _ready() -> void:
	_setup_event_connections()

func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)
	
	return new_view


func _setup_event_connections() -> void:
	location_button.pressed.connect(_change_view.bind(LOCATION_CARD_SCENE))
