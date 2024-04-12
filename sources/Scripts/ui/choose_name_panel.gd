extends Panel
class_name ChooseGamePanel

@onready var player_name : LineEdit = $Name

func _on_accept_pressed():
	if !player_name.text.is_empty():
		SignalManager.player_name.emit(player_name.text)
		queue_free()
