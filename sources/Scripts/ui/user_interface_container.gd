extends Control

func _on_save_pressed():
	SaveManager.save_game()

func _on_load_pressed():
	SaveManager.load_game()

func _on_quit_pressed():
	get_tree().quit()
