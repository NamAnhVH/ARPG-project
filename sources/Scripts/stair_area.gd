extends Area2D
class_name StairArea
@export var direction: Enums.Direction

func _on_body_entered(body):
	if body is PlayableCharacter:
		body.is_in_stair_direction = direction

func _on_body_exited(body):
	if body is PlayableCharacter:
		body.is_in_stair_direction = Enums.Direction.NONE
