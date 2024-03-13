extends Area2D
class_name StairArea
@export var stair_direction: GameEnums.STAIR_DIRECTION

func _on_body_entered(body):
	if body is PlayableCharacter:
		body.is_in_stair_direction = stair_direction

func _on_body_exited(body):
	if body is PlayableCharacter:
		body.is_in_stair_direction = GameEnums.STAIR_DIRECTION.NONE
