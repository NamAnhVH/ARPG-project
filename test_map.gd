extends Node2D

@onready var playable_character = $PlayableCharacter
@onready var enemies : Node2D = $Enemies
@onready var floor_item : Node2D = $FloorItem

var is_pause : bool = false

func _process(delta):
	for slime: Slime in enemies.get_children():
		if is_instance_valid(slime) and slime.is_chasing:
			slime.navigation_agent.target_position = playable_character.global_position

