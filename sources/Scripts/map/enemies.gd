extends Node2D

@onready var playable_character = get_node("/root/main/PlayableCharacter")

var enemies_respawn = []

func _process(delta):
	if has_node("./Slimes"):
		for slime: SlimeCharacter in get_node("./Slimes").get_children():
			if is_instance_valid(slime) and slime.is_chasing:
				slime.navigation_agent.target_position = playable_character.global_position
	
	if has_node("./Gremlins"):
		for gremlin: GremlinCharacter in get_node("./Gremlins").get_children():
			if is_instance_valid(gremlin) and gremlin.is_chasing:
				gremlin.navigation_agent.target_position = playable_character.global_position
	
	if has_node("./Mushrooms"):
		for mushroom: MushroomCharacter in get_node("./Mushrooms").get_children():
			if is_instance_valid(mushroom) and mushroom.is_chasing and !mushroom.is_running:
				mushroom.navigation_agent.target_position = playable_character.global_position

func _on_enemy_respawn_timer_timeout():
	for enemy in enemies_respawn:
		if enemy is SlimeCharacter:
			get_node("./Slimes").add_child(enemy)
		elif enemy is GremlinCharacter:
			get_node("./Gremlins").add_child(enemy)
		elif enemy is MushroomCharacter:
			get_node("./Mushrooms").add_child(enemy)
		enemies_respawn.erase(enemy)
