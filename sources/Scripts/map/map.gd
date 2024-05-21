extends Node2D
class_name Map

@export var map_id : String
@export var progress_data : ProgressData

@onready var playable_character = get_node("/root/main/PlayableCharacter")
@onready var enemies : Node2D = $Enemies
@onready var floor_item : Node2D = $FloorItem
@onready var npcs : Node2D = $Npcs
@onready var enemy_respawn_timer : Timer = $Timer/EnemyRespawnTimer

func _on_area_2d_body_entered(body):
	if body is PlayableCharacter:
		SignalManager.change_map.emit(self)
