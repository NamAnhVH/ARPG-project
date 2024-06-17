extends Node

func _on_timer_timeout():
	SaveManager.save_continue_file()
