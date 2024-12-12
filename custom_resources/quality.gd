class_name Quality
extends Resource

const DESCRIPTOR_SPACER = " - "

@export var id: String
@export var display_name: String
@export var icon: Texture

@export var category: String
@export var display_description: String

@export var level: int
## Setting the Max Level to 0 (default value) means there is no maximum value
@export var max_level: int = 0 #default of 0 means no maximum

@export_group("Optional: Level Descriptors")
## Not every level needs a descriptor; get_level_descriptor will check the requested level, and then proceed downwards until it finds a non-blank description
@export var level_descriptors: Array[String]

func change_level(change_amount: int) -> void:
	var new_level = level + change_amount
	
	#if no maximum level, make sure it doesn't go negative
	if max_level == 0:
		new_level = max(new_level, 0)
	else:
		new_level = clampi(new_level,0,max_level)
	
	level = new_level

func has_level_descriptors() -> bool:
	return level_descriptors.size() > 0

## Gets the first non-blank level description that is less than or equal to the provided level to begine checking at
func get_level_descriptor(level_check: int) -> String:
	if self.has_level_descriptors():
		for i in range(level_check,0,-1):
			if level_descriptors[i] != "":
				return str(level) + DESCRIPTOR_SPACER + level_descriptors[i]
	
	return str(level)

#check functions for filtering
func equals(check_level: int) -> bool:
	return check_level == level

func less_than(check_level: int) -> bool:
	return level < check_level

func less_than_or_equal_to(check_level: int) -> bool:
	return level <= check_level

func greater_than(check_level: int) -> bool:
	return level > check_level

func greater_than_or_equal_to(check_level: int) -> bool:
	return level >= check_level

func range_check(min: int, max: int) -> bool:
	return min <= level and level <= max
