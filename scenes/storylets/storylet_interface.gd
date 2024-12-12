class_name StoryletInterface
extends Control

const TITLE_TEXT_FORMAT = preload("res://text_formats/storylet_title_text_format.tres")
const STORYLET_OPTION_SCENE = preload("res://scenes/storylets/storylet_option.tscn")

@export var char_stats: CharacterStats

@export var storylet_id: String

@onready var storylet_image: TextureRect = %StoryletImage
@onready var storylet_title: RichTextLabel = %StoryletTitle
@onready var storylet_content: RichTextLabel = %StoryletContent
@onready var options_container: VBoxContainer = %OptionsContainer

@onready var outside_button_container: VBoxContainer = %OutsideButtonContainer
@onready var exit_button: TextureButton = %ExitButton

func _ready() -> void:
	
	await get_tree().create_timer(3).timeout
	set_storylet_id("test_story")

func set_storylet_id(new_storylet_id: String) -> void:
	storylet_id = new_storylet_id
	_retrieve_storylet_file(storylet_id)

func _retrieve_storylet_file(new_storylet_id: String) -> void:
	## Load json
	var filepath = StoryletLibrary.lookup(new_storylet_id)
	var json = JSON.new()
	var json_string = FileAccess.get_file_as_string(filepath)
	var error = json.parse(json_string)
	if error == OK:
		_load_storylet(json.data)
		_filter_options()
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())

func _load_storylet(storylet_data: Dictionary) -> void:
	## Load options
	exit_button.disabled = false
	#clear
	_clear_options()
	#set id, image, title and content
	print("TODO: set the storylet image")
	storylet_id = storylet_data["storylet_id"]
	storylet_title.text = TITLE_TEXT_FORMAT.format_text(storylet_data["storylet_title"])
	storylet_content.text = storylet_data["storylet_content"]
	
	#load options
	for option: Dictionary in storylet_data["options"]:
		#new option
		var new_option = STORYLET_OPTION_SCENE.instantiate() as StoryletOption
		options_container.add_child(new_option)
		
		#pass stats
		new_option.char_stats = char_stats
		
		#id, title, content
		new_option.option_id = option["option_id"]
		new_option.set_option_title(option["option_title"])
		new_option.set_option_content(option["option_content"])
		
		#requirements
		new_option.set_option_requirements(option["option_requirements"][0])
		
		#hide if inaccessible
		new_option.show_if_inaccessible = option["show_if_inaccessible"]
		
		#result and result signal
		new_option.set_storylet_result(option["result"][0])
		new_option.option_chosen.connect(_process_result)

func _filter_options() -> void:
	#filter to accessible options
	for child_option in options_container.get_children():
		if child_option is StoryletOption:
			var reqs_met = child_option.meets_requirements()
			child_option.visible = reqs_met or child_option.show_if_inaccessible
			if not reqs_met:
				child_option.choose_option_button.disabled = true
				options_container.move_child(child_option, options_container.get_child_count())

func _process_result(result_scene: StoryletResult) -> void:
	exit_button.disabled = true
	#clear out options
	_clear_options()
	#instantiate result
	#add result to option container
	options_container.add_child(result_scene)
	#set result image, title, & content
	print("TODO: set result image")
	storylet_title.text = TITLE_TEXT_FORMAT.format_text(result_scene.title)
	storylet_content.text = result_scene.content
	#connect signal
	result_scene.result_continue.connect(_retrieve_storylet_file)

func _clear_options() -> void:
	for child in options_container.get_children():
		child.queue_free()


func _on_exit_button_pressed() -> void:
	queue_free()
