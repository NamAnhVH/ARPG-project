extends Node

const SAVE_FOLDER = "user://save/"
const SAVE_FILE = "save.dat"

var game_data : GameData

func _ready():
	game_data = ResourceManager.resources["game_data"]
	load_game()

func has_save_file(file_path):
	return FileAccess.file_exists(file_path)

func load_game():
	var save_path = SAVE_FOLDER + SAVE_FILE
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = file.get_var(true)
		file.close()
		
		if data != null:
			game_data.set_data(data)

func save_game():
	SignalManager.saving_game.emit()
	var dir = DirAccess.open(SAVE_FOLDER)
	
	if !dir:
		var dn = DirAccess.make_dir_absolute(SAVE_FOLDER)
	
	dir = DirAccess.open(SAVE_FOLDER)
	var save_path = SAVE_FOLDER + SAVE_FILE
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(game_data.get_data(), true)
	file.close()
