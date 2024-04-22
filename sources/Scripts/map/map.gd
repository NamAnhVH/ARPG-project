extends Node2D
class_name Map

@export var map_id : String
@export var process_data : ProgressData

@onready var playable_character = get_node("/root/main/PlayableCharacter")
@onready var enemies : Node2D = $Enemies
@onready var floor_item : Node2D = $FloorItem
@onready var camera : Camera2D = $Camera
@onready var npcs : Node2D = $Npcs
@onready var enemy_respawn_timer : Timer = $Timer/EnemyRespawnTimer

func _process(delta):
	camera.global_position = playable_character.global_position

func _on_area_2d_body_entered(body):
	if body is PlayableCharacter:
		SignalManager.change_map.emit(map_id)




