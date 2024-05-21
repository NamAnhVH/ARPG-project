extends Enemy
class_name Boss

func _ready(): 
	pass

func is_player_outside_area():
	is_chasing = false
	navigation_agent.target_position = first_position
