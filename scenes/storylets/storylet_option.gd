class_name StoryletOption
extends Control

const TITLE_TEXT_FORMAT = preload("res://text_formats/storylet_title_text_format.tres")

const QUALITY_REQUIREMENTS_SCENE = preload("res://scenes/storylets/quality_requirement.tscn")
const STORYLET_RESULT_SCENE = preload("res://scenes/storylets/storylet_result.tscn")

signal option_chosen(next: StoryletResult)

@export var option_id: String
@export var title: String : set = set_option_title
@export_multiline var content: String : set = set_option_content
@export var requirements: Array[QualityRequirement]
@export var show_if_inaccessible: bool = false
@export var result: StoryletResult

@export var char_stats: CharacterStats

@onready var option_title: RichTextLabel = %OptionTitle
@onready var option_content: RichTextLabel = %OptionContent

@onready var qualities_h_box: HBoxContainer = %QualitiesHBox
@onready var choose_option_button: Button = %ChooseOptionButton

func _ready() -> void:
	for child in qualities_h_box.get_children():
		if child != choose_option_button:
			child.free()

func set_option_title(new_title: String) -> void:
	if not is_node_ready():
		await ready
	
	title = TITLE_TEXT_FORMAT.format_text(new_title)
	option_title.text = title

func set_option_content(new_text: String) -> void:
	if not is_node_ready():
		await ready
	
	content = new_text
	option_content.text = content

func set_option_requirements(new_requirements: Dictionary) -> void:
	if not is_node_ready():
		await ready
	
	for qual_id in new_requirements:
		var qual_req := QUALITY_REQUIREMENTS_SCENE.instantiate() as QualityRequirement
		
		qual_req.char_stats = char_stats
		
		qual_req.set_quality(qual_id)
		qual_req.set_criteria(new_requirements[qual_id])
		qual_req.char_stats = char_stats
		
		requirements.append(qual_req)
		qualities_h_box.add_child(qual_req)

func set_storylet_result(result_data: Dictionary) -> void:
	if not is_node_ready():
		await ready
	
	var new_result := STORYLET_RESULT_SCENE.instantiate() as StoryletResult
	
	new_result.set_result_title(result_data["result_title"])
	new_result.set_result_content(result_data["result_content"])
	new_result.set_quality_changes(result_data["quality_changes"][0])
	new_result.set_next_storyley_id(result_data["next_storylet_id"])
	new_result.char_stats = char_stats
	
	result = new_result

func meets_requirements() -> bool:
	for child in qualities_h_box.get_children():
		if  child != choose_option_button and not child.check_requirement_met():
			return false
	
	return true

func _on_choose_option_button_pressed() -> void:
	option_chosen.emit(result)
