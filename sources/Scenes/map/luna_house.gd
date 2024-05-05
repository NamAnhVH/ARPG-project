extends Map

func _ready():
	SignalManager.scene_transition_fade_in_finished.connect(_on_scene_transition_fade_in_finished)

func _on_scene_transition_fade_in_finished():
	if progress_data.current_story.name == "start_game":
		SaveManager.create_new_game_file()
		var luna = ResourceManager.get_character("luna")
		luna.global_position = Vector2(86,90)
		npcs.add_child(luna)
		luna.animation_tree.set("parameters/Stand/blend_position", Vector2(-1,0))
		SignalManager.show_dialogue.emit("start_game", "start")
	
