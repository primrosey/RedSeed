class_name StoryletResult
extends Control

const TITLE_TEXT_FORMAT = preload("res://text_formats/storylet_title_text_format.tres")

const QUALITY_CHANGE_SCENE = preload("res://scenes/storylets/quality_change.tscn")

signal result_continue(storylet_id: String)

@export var image: Texture
@export var title: String : set = set_result_title
@export_multiline var content: String : set = set_result_content
@export var quality_changes: Array[QualityChange]
@export var next_storylet_id: String : set = set_next_storyley_id
@export var char_stats: CharacterStats

@onready var quality_change_container: VBoxContainer = %QualityChangeContainer
@onready var continue_button: Button = %ContinueButton


func _ready() -> void:
	for child in quality_change_container.get_children():
		child.free()

func set_result_title(new_title: String) -> void:
	if not is_node_ready():
		await ready
	
	title = TITLE_TEXT_FORMAT.format_text(new_title)

func set_result_content(new_text: String) -> void:
	if not is_node_ready():
		await ready
	
	content = new_text

func set_quality_changes(id_and_change: Dictionary) -> void:
	if not is_node_ready():
		await ready
	
	for qual_id in id_and_change:
		var qual = char_stats.get_quality(qual_id)
		if not qual:
			qual = QualityLibrary.lookup(qual_id)
		
		var qual_change := QUALITY_CHANGE_SCENE.instantiate() as QualityChange
		
		qual_change.set_quality(qual)
		qual_change.set_change(id_and_change[qual_id])
		quality_changes.append(qual_change)
		
		if not char_stats.get_quality(qual_id):
			char_stats.add_quality(qual)
		
	
	for change: QualityChange in quality_changes:
		quality_change_container.add_child(change)

func set_next_storyley_id(new_id: String) -> void:
	if not is_node_ready():
		await ready
	
	next_storylet_id = new_id

func _on_continue_button_pressed() -> void:
	result_continue.emit(next_storylet_id)
	queue_free()
