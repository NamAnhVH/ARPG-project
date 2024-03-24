extends Resource
class_name WorldData

@export var current_map: String

func set_data(data):
	current_map = data.current_map
	emit_changed()

func get_data():
	return {
		"current_map": current_map
	}
