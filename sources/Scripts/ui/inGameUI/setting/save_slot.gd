extends Button
class_name SaveSlot

var file_name : String
var is_save_game : bool

func _ready():
	text = file_name.get_basename()


func _on_pressed():
	if is_save_game:
		SaveManager.save_game(file_name)
	else:
		SignalManager.scene_transition_fade_in.emit()
		get_tree().change_scene_to_file("res://sources/scenes/main.tscn")
		SaveManager.load_game(file_name)
