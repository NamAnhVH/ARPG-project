extends Node2D

func _unhandled_input(event):
	if event.is_action_pressed("asd"):
		get_tree().change_scene_to_file("res://sources/scenes/Map/test_map.tscn")
