extends Control

@export var player_data : PlayerData = preload("res://data/resources/player_data.tres")
@export var world_data : WorldData = preload("res://data/resources/world_data.tres")

func _ready():
	SignalManager.player_dead.connect(_on_player_dead)

func _on_player_dead():
	await get_tree().create_timer(1.5).timeout
	show()

func _on_revive_pressed():
	player_data.health = player_data.get_stat(GameEnums.STAT.LIFE_POINT)
	world_data.current_map = "luna_house"
	player_data.global_position = Vector2(47,85)
	get_tree().change_scene_to_file("res://sources/scenes/main.tscn")

func _on_load_game_pressed():
	for i in get_children():
		i.mouse_filter = MOUSE_FILTER_IGNORE
	var file_saving_container : FileSavingContainer = ResourceManager.get_instance("file_saving_container")
	file_saving_container.is_save_game = false
	add_child(file_saving_container)

func _on_quit_game_pressed():
	get_tree().change_scene_to_file("res://sources/scenes/gameSetup/start_game.tscn")
