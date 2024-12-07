class_name TheaterManager
extends Node

const LAIR_SCENE := preload("res://scenes/lair/lair.tscn")
const EXPLORE_THEATER_SCENE := preload("res://scenes/run/run.tscn")
const SOCIALIZE_THEATER_SCENE := preload("res://scenes/socialize/socialize.tscn")
const FARM_THEATER_SCENE := preload("res://scenes/world/world.tscn")

const MAIN_MENU_PATH := "res://scenes/ui/main_menu.tscn"

@export var run_startup: RunStartup

@export var current_day = 7

@onready var current_theater: Node = $CurrentTheater
@onready var gold_ui: GoldUI = %GoldUI
@onready var blood_ui: HBoxContainer = %BloodUI
@onready var health_ui: HealthUI = %HealthUI


@onready var relic_handler: RelicHandler = %RelicHandler
@onready var relic_tooltip: RelicTooltip = %RelicTooltip
@onready var deck_button: CardPileOpener = %DeckButton
@onready var deck_view: CardPileView = %DeckView
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var sky_strip_ui: SkyStripUI = %SkyStripUI

#region Debug
@onready var day_label: Label = %DayLabel

@onready var leave_button: Button = %LeaveButton
@onready var lair_button: Button = %LairButton
@onready var explore_button: Button = %ExploreButton
@onready var socialize_button: Button = %SocializeButton
@onready var farm_button: Button = %FarmButton
#endregion

@export var run_stats: RunStats
@export var character: CharacterStats
var save_data: SaveGame

func _ready() -> void:
	
	pause_menu.save_and_quit.connect(
		func():
			get_tree().change_scene_to_file(MAIN_MENU_PATH)
	)
	
	character = run_startup.picked_character.create_instance()
	_start_run()

func _start_run() -> void:
	run_stats = RunStats.new()
	_setup_event_connections()
	_setup_top_bar()

func _setup_top_bar() -> void:
	character.stats_changed.connect(health_ui.update_stats.bind(character))
	health_ui.update_stats(character)
	gold_ui.run_stats = run_stats
	relic_handler.add_relic(character.starting_relic)
	Events.relic_tooltip_requested.connect(relic_tooltip.show_tooltip)
	deck_button.card_pile = character.deck
	deck_view.card_pile = character.deck
	deck_button.pressed.connect(deck_view.show_current_view.bind("Deck"))

func _change_view(scene: PackedScene) -> Node:
	if current_theater.get_child_count() > 0:
		current_theater.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_theater.add_child(new_view)
	
	#debug
	day_label.text = "Day: %s" % current_day
	
	return new_view

func _return_to_lair() -> void:
	sky_strip_ui.advance_time()
	
	_change_view(LAIR_SCENE)

func _enter_farm() -> void:
	var farm_theater := _change_view(FARM_THEATER_SCENE) as World
	
	farm_theater.set_current_day(current_day)
	
	sky_strip_ui.next_mid_period()
	health_ui.hide()

func _enter_explore() -> void:
	var explore_theater := _change_view(EXPLORE_THEATER_SCENE) as Run
	
	explore_theater.character = character
	explore_theater.run_stats = run_stats
	
	sky_strip_ui.next_mid_period()
	health_ui.show()

func _setup_event_connections() -> void:
	leave_button.pressed.connect(_return_to_lair)
	lair_button.pressed.connect(_change_view.bind(LAIR_SCENE))
	explore_button.pressed.connect(_enter_explore)
	socialize_button.pressed.connect(_change_view.bind(SOCIALIZE_THEATER_SCENE))
	farm_button.pressed.connect(_enter_farm)
	
	Events.dawn.connect(_advance_day_count)

func _advance_day_count() -> void:
	current_day = current_day + 1
