extends Node2D

@onready var control : Control = $CanvasLayer/Control
@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready():
	SignalManager.close_file_saving_container.connect(_on_close_file_saving_container)

func _on_close_file_saving_container():
	control.mouse_filter = Control.MOUSE_FILTER_STOP
	for i in control.get_children():
		i.mouse_filter = Control.MOUSE_FILTER_STOP

func _on_new_game_pressed():
	SignalManager.scene_transition_fade_in.emit()
	SaveManager.new_game()
	get_tree().change_scene_to_file("res://sources/scenes/main.tscn")

func _on_load_game_pressed():
	control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for i in control.get_children():
		i.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var file_saving_container : FileSavingContainer = ResourceManager.get_instance("file_saving_container")
	file_saving_container.is_save_game = false
	canvas_layer.add_child(file_saving_container)

func _on_exit_pressed():
	get_tree().quit()

