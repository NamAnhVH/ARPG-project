extends Resource
class_name WorldData

@export var current_map: String = "luna_house"

var chest_opened = {}

func set_data(data):
	if data.current_map == "dungeon":
		current_map = "map_14"
	else:
		current_map = data.current_map
	chest_opened = data.chest_opened if data.has("chest_opened") else []
	emit_changed()

func get_data():
	return {
		"current_map": current_map,
		"chest_opened": chest_opened
	}
