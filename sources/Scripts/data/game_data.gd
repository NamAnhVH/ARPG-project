extends Resource
class_name GameData

@export var setting_data : Resource
@export var player_data : Resource

func set_data(data):
	#setting_data.set_data(data.setting_data)
	player_data.set_data(data.player_data)
	emit_changed()

func get_data():
	return {
		#"setting_data": setting_data.get_data(),
		"player_data": player_data.get_data()
	}
