extends Node

const SAVE_FOLDER = "user://save/"
const NEW_GAME_FILE = "user://new_game.dat"

var game_data : GameData

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	game_data = ResourceManager.resources["game_data"]

func has_save_file(file_path):
	return FileAccess.file_exists(file_path)

func new_game():
	if FileAccess.file_exists(NEW_GAME_FILE):
		var file = FileAccess.open(NEW_GAME_FILE, FileAccess.READ)
		var data = file.get_var(true)
		file.close()
	
		if data != null:
			game_data.set_data(data)

func create_new_game_file():
	if !FileAccess.file_exists(NEW_GAME_FILE):
		var file = FileAccess.open(NEW_GAME_FILE, FileAccess.WRITE)
		file.store_var(game_data.get_data(), true)
		file.close()

func load_game(file_name):
	SignalManager.inventory_closed.emit()
	var save_path = SAVE_FOLDER + file_name
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = file.get_var(true)
		file.close()
		
		if data != null:
			game_data.set_data(data)

func save_game(slot):
	SignalManager.saving_game.emit()
	var dir = DirAccess.open(SAVE_FOLDER)
	
	if !dir:
		var dn = DirAccess.make_dir_absolute(SAVE_FOLDER)
	
	dir = DirAccess.open(SAVE_FOLDER)
	var save_path : String
	if slot is String:
		save_path = SAVE_FOLDER + slot
	else:
		save_path = SAVE_FOLDER + "save_" + str(slot) + ".dat"
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(game_data.get_data(), true)
	file.close()

func get_list_file_save():
	var list_file_save : Array[String] = []
	var dir = DirAccess.open(SAVE_FOLDER)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				list_file_save.append(file_name)
			file_name = dir.get_next()
	return list_file_save
