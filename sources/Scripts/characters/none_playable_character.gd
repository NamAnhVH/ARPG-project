extends Character
class_name NonePlayableCharacter

@export var object_name : String

var action = "talk"

func interact():
	Global.npc_name = object_name


