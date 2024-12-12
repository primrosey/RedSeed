class_name QualityRequirement
extends TextureRect

enum comparator {NOT_POSSESED, EQUAL_TO, LESS_THAN, LESS_THAN_OR_EQUAL_TO, GREATER_THAN, GREATER_THAN_OR_EQUAL_TO, RANGE}

@export var quality: Quality
@export var char_stats: CharacterStats

@export_group("Requirement")
@export var requirement_comparator: comparator
## Used as the minimum for Range comparator option
@export var threshold_level: int = 0
## Maximum if using the Range comparator option; not used otherwise. Note: if this is left at 0 and the comparator option is set to Range, the Range will use it as the minimum and will function similar to "Less Than Or Equal To"
@export var range_max_level: int = 0

func set_quality(new_quality_id: String) -> void:
	if not is_node_ready():
		await ready
	
	var new_quality = QualityLibrary.lookup(new_quality_id)
	quality = new_quality
	texture = quality.icon

## Recieves the comparator, theshold, and range max arguments as an array of ints. the comparator treats the dropdown options as a 0 indexed array
func set_criteria(new_criteria: Array) -> void:
	requirement_comparator = int(new_criteria[0])
	threshold_level = int(new_criteria[1])
	if new_criteria.size() > 2:
		range_max_level = int(new_criteria[2])

func check_requirement_met() -> bool:
	var existing_qual = char_stats.get_quality(quality.id)
	
	var meets_requirements: bool
	
	var level_text = str(threshold_level)
	if requirement_comparator == comparator.RANGE and range_max_level != 0:
		level_text = str(threshold_level) + "-" + str(range_max_level)
	elif requirement_comparator == comparator.RANGE and range_max_level == 0:
		level_text = str(range_max_level) + "-" + str(threshold_level)
	
	if existing_qual:
		
		
		meets_requirements = _compare_quality_level(existing_qual)
		
		if meets_requirements:
			tooltip_text = "You unlocked this with %s %s (%s needed)." % [existing_qual.display_name, existing_qual.get_level_descriptor(existing_qual.level), level_text]
			return meets_requirements
		else:
			tooltip_text = "You need %s %s (you have %s)." % [existing_qual.display_name, level_text, existing_qual.get_level_descriptor(existing_qual.level)]
			modulate = Color.DIM_GRAY
			return meets_requirements
	else:
		meets_requirements = requirement_comparator == comparator.NOT_POSSESED
		
		if meets_requirements:
			tooltip_text = "You unlocked this by not having any %s." % quality.display_name
			return meets_requirements
		else:
			tooltip_text = "You need %s %s (you have none)." % [quality.display_name, level_text]
			modulate = Color.DIM_GRAY
			return meets_requirements
	

func _compare_quality_level(compare_quality: Quality) -> bool:
	match requirement_comparator:
		comparator.NOT_POSSESED:
			return false #if it got here, then the player *does* have the quality, and does not meet the "does not posses" requirement
		comparator.EQUAL_TO:
			return compare_quality.equals(threshold_level)
		comparator.LESS_THAN:
			return compare_quality.less_than(threshold_level)
		comparator.LESS_THAN_OR_EQUAL_TO:
			return compare_quality.less_than_or_equal_to(threshold_level)
		comparator.GREATER_THAN:
			return compare_quality.greater_than(threshold_level)
		comparator.GREATER_THAN_OR_EQUAL_TO:
			return compare_quality.greater_than_or_equal_to(threshold_level)
		comparator.RANGE:
			if range_max_level == 0:
				return compare_quality.range_check(range_max_level, threshold_level)
			return compare_quality.range_check(threshold_level, range_max_level)
	
	#if code gets here something is wrong
	return false
