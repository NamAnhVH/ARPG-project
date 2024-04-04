extends NinePatchRect

func _ready():
	SignalManager.close_file_saving_container.connect(_on_close_file_saving_container)

func _on_close_file_saving_container():
	for i in get_children():
		i.mouse_filter = MOUSE_FILTER_STOP

func _on_button_save_load_pressed(is_save_game: bool):
	for i in get_children():
		i.mouse_filter = MOUSE_FILTER_IGNORE
	var file_saving_container : FileSavingContainer = ResourceManager.get_instance("file_saving_container")
	file_saving_container.is_save_game = is_save_game
	add_child(file_saving_container)

func _on_save_game_pressed():
	_on_button_save_load_pressed(true)

func _on_load_game_pressed():
	_on_button_save_load_pressed(false)

func _on_close_pressed():
	queue_free()

func _on_quit_game_pressed():
	get_tree().change_scene_to_file("res://sources/scenes/gameSetup/start_game.tscn")
