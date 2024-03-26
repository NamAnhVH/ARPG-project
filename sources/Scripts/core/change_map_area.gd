extends Area2D

@export var world_id : String
@export var location : Vector2
@export var next_z_index : int

func _on_body_entered(body):
	if body is PlayableCharacter:
		SignalManager.change_map.emit(world_id, location, next_z_index)
		SignalManager.set_player.emit()
