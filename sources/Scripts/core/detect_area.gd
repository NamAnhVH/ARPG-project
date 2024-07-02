extends Area2D
class_name DetectArea

@onready var parent = get_parent()

func _on_body_entered(body):
	if body is PlayableCharacter:
		parent.is_chasing = true
		var indicator = ResourceManager.get_instance("indicator")
		indicator.text = "!"
		indicator.indicator_type = GameEnums.INDICATOR_TYPE.EMOTE_INDICATOR
		indicator.texture = preload("res://assets/ui/emote_box.png")
		parent.add_child(indicator)

func _on_body_exited(body):
	if body is PlayableCharacter:
		parent.is_chasing = false
		parent.navigation_agent.target_position = parent.random_position
