extends Area2D

@onready var parent : SlimeCharacter = get_parent()

func _on_body_entered(body):
	if body is PlayableCharacter:
		parent.is_chasing = true

func _on_body_exited(body):
	if body is PlayableCharacter:
		parent.is_chasing = false
		parent.navigation_agent.target_position = parent.random_position
