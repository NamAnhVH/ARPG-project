extends Dungeon

@onready var gremlin : Boss = $Enemies/BossGremlin

func _on_area_2d_body_entered(body):
	super._on_area_2d_body_entered(body)
	gremlin._on_detect_area_body_entered(body)
	
func _on_area_2d_body_exited(body):
	gremlin.is_player_outside_area()
	
