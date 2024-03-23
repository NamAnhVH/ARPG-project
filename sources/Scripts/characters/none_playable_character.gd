extends Character
class_name NonePlayableCharacter

@export var object_name : String

var balloon
var action = "talk"

func interact():
	Global.npc_name = object_name
	balloon = ResourceManager.get_instance("balloon")
	get_tree().current_scene.add_child(balloon)

