extends Area2D

@export var map_id : String
@export var location : Vector2
@export var next_z_index : int

func _on_body_entered(body):
	if body is PlayableCharacter:
		SignalManager.scene_transition_fade_out.emit(map_id, location, next_z_index)
