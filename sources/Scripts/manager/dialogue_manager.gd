extends Node

func _ready():
	SignalManager.show_dialogue.connect(_on_show_dialogue)

func _on_show_dialogue(dialogue: String, branch: String):
	if !Global.is_inventory_opened:
		Global.paused = true
		var balloon = ResourceManager.get_instance("balloon")
		add_child(balloon)
		if ResourceManager.dialogue.has(dialogue):
			balloon.start(ResourceManager.dialogue[dialogue], branch.to_lower())
		else:
			balloon.start(ResourceManager.dialogue["default"], "start")

func get_button(value) -> String:
	return InputMap.action_get_events(value)[0].as_text().trim_suffix(" (Physical)")
