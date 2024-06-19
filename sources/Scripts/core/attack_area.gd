extends Area2D
class_name AttackArea

@onready var parent = get_parent()

func _on_body_entered(body):
	if body is PlayableCharacter and parent.is_chasing:
		parent.is_ready_attack = true
		parent.is_chasing = false

func _on_body_exited(body):
	if body is PlayableCharacter and !parent.is_chasing:
		parent.is_ready_attack = false
		parent.is_chasing = true
