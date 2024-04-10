extends Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	SignalManager.show_dialogue.connect(_on_show_dialogue)

func _on_show_dialogue(dialogue: String, branch: String):
	Global.paused = true
	var balloon = ResourceManager.get_instance("balloon")
	add_child(balloon)
	balloon.start(ResourceManager.dialogue[dialogue], branch)