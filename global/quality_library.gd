extends Node

## Library of all the extant Qualities
var all_qualities = {}

func _ready() -> void:
	initialize()

func initialize() -> void:
	for file_name in DirAccess.get_files_at("res://qualities/"):
		if (file_name.get_extension() == "import"):
			file_name = file_name.replace('.import', '')
		var quality = load("res://qualities/"+file_name) as Quality
		all_qualities.get_or_add(quality.id, quality)

func lookup(quality_id: String) -> Quality:
	return all_qualities[quality_id]
