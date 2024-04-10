extends Map

func _ready():
	if process_data.current_story == "start_game":
		var luna = ResourceManager.get_character("luna")
		luna.global_position = Vector2(86,90)
		npcs.add_child(luna)
		luna.animation_tree.set("parameters/Stand/blend_position", Vector2(-1,0))
		SignalManager.show_dialogue.emit("start_game", "start")
	