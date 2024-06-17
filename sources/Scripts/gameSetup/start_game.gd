extends Node2D

@onready var control : Control = $CanvasLayer/Control
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var continue_button : Button = $CanvasLayer/Control/Continue

func _ready():
	SignalManager.close_file_saving_container.connect(_on_close_file_saving_container)
	SoundManager.play_start_game_background_music()
	can_continue()

func can_continue():
	if SaveManager.can_continue():
		continue_button.disabled = false
	else:
		continue_button.disabled = true

func _on_close_file_saving_container():
	control.mouse_filter = Control.MOUSE_FILTER_STOP
	for i in control.get_children():
		i.mouse_filter = Control.MOUSE_FILTER_STOP

func _on_new_game_pressed():
	SignalManager.scene_transition_fade_in.emit()
	SaveManager.new_game()
	get_tree().change_scene_to_file("res://sources/main.tscn")

func _on_continue_game_pressed():
	SignalManager.scene_transition_fade_in.emit()
	SaveManager.continue_game()
	get_tree().change_scene_to_file("res://sources/main.tscn")

func _on_load_game_pressed():
	control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for i in control.get_children():
		i.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var file_saving_container : FileSavingContainer = ResourceManager.get_instance("file_saving_container")
	file_saving_container.is_save_game = false
	canvas_layer.add_child(file_saving_container)

func _on_exit_pressed():
	get_tree().quit()

func _on_setting_pressed():
	var setting_container = ResourceManager.get_instance("setting_container")
	setting_container.is_start_game_screen = true
	canvas_layer.add_child(setting_container)
