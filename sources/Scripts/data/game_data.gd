extends Resource
class_name GameData

@export var setting_data : SettingData
@export var player_data : PlayerData
@export var world_data : WorldData
@export var progress_data : ProgressData


func set_data(data):
	#setting_data.set_data(data.setting_data)
	player_data.set_data(data.player_data)
	world_data.set_data(data.world_data)
	progress_data.set_data(data.progress_data)
	emit_changed()

func get_data():
	return {
		#"setting_data": setting_data.get_data(),
		"world_data": world_data.get_data(),
		"player_data": player_data.get_data(),
		"progress_data": progress_data.get_data()
	}
