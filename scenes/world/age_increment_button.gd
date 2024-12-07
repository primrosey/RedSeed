extends Button


func _on_pressed() -> void:
	for aging_comp: AgingComponent in get_tree().get_nodes_in_group("AgingComponent"):
		aging_comp.set_current_age(aging_comp.current_age + 1)
