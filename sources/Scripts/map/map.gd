extends Node2D
class_name Map

@export var map_id : String
@export var process_data : ProgressData

@onready var playable_character = get_node("/root/main/PlayableCharacter")
@onready var enemies : Node2D = $Enemies
@onready var floor_item : Node2D = $FloorItem
@onready var camera : Camera2D = $Camera
@onready var npcs : Node2D = $Npcs

var is_pause : bool = false
var balloon

func _ready():
	#SignalManager.scene_transition_fade_in.emit()
	pass


func _process(delta):
	if enemies.get_child_count() > 0:
		if enemies.get_child(0):
			for slime: SlimeCharacter in enemies.get_child(0).get_children():
				if is_instance_valid(slime) and slime.is_chasing:
					slime.navigation_agent.target_position = playable_character.global_position
	
	camera.global_position = playable_character.global_position

func _on_area_2d_body_entered(body):
	if body is PlayableCharacter:
		SignalManager.change_map.emit(map_id)
