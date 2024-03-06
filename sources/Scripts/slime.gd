extends BattleCharacter

@onready var animation_tree = $AnimationTree

func _ready():
	animation_tree.set("parameters/conditions/is_alive", is_alive)

func _on_is_attacked():
	animation_tree.set("parameters/conditions/is_attacked", true)

func _hurt_finished():
	animation_tree.set("parameters/conditions/is_attacked", false)

func _on_is_dead():
	is_alive = false
	animation_tree.set("parameters/conditions/is_alive", is_alive)
	animation_tree.set("parameters/conditions/is_dead", !is_alive)
