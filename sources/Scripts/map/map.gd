extends Node2D
class_name Map
@export var map_id : String

@onready var playable_character = get_node("/root/main/PlayableCharacter")
@onready var enemies : Node2D = $Enemies
@onready var floor_item : Node2D = $FloorItem
@onready var camera : Camera2D = $Camera

var is_pause : bool = false


func _ready():
	#SignalManager.scene_transition_fade_in.emit()
	pass


func _process(delta):
	for slime: SlimeCharacter in enemies.get_children():
		if is_instance_valid(slime) and slime.is_chasing:
			slime.navigation_agent.target_position = playable_character.global_position
	
	camera.global_position = playable_character.global_position

func _on_area_2d_body_entered(body):
	if body is PlayableCharacter:
		SignalManager.change_map.emit(map_id)
