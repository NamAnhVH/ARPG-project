extends Node2D

@onready var playable_character = $PlayableCharacter
var enemies : Array

func _process(delta):
	enemies = $Enemies.get_children()
	for slime: SlimeCharacter in enemies:
		if is_instance_valid(slime) and slime.is_chasing:
			slime.navigation_agent.target_position = playable_character.global_position

