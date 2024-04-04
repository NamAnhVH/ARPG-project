extends Button


func _on_pressed():
	var slot = get_parent().get_child(0).get_child_count() + 1
	SaveManager.save_game(slot)
	SignalManager.update_file_saving_container.emit()
