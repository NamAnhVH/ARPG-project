extends Character
class_name NonePlayableCharacter

@export var object_name : String
@export var texture : Texture2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var quest : Node2D = $Quest

var action = "talk"

func _ready():
	if !sprite.texture:
		sprite.texture = texture

func interact():
	Global.npc_name = object_name
	SignalManager.show_dialogue.emit(StoryManager.progress_data.current_main_quest.id, object_name)
