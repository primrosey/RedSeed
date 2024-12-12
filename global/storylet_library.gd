class_name StroyletLibrary
extends Node

var all_storylets = {}

func _ready() -> void:
	initialize()

func initialize() -> void:
	for file_name in DirAccess.get_files_at("res://storylet_data/"):
		if (file_name.get_extension() == "import"):
			file_name = file_name.replace('.import', '')
		
		var json = JSON.new()
		var json_string = FileAccess.get_file_as_string("res://storylet_data/"+file_name)
		var error = json.parse(json_string)
		if error == OK:
			var storylet_data = json.data
			all_storylets.get_or_add(storylet_data["storylet_id"], "res://storylet_data/"+file_name)

func lookup(storylet_id: String) -> String:
	return all_storylets[storylet_id]
