extends NonePlayableCharacter

@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D

var is_moving : bool = false

func _ready():
	SignalManager.luna_go_out.connect(_on_luna_go_out)

func _physics_process(delta):
	move_state()

func move_state():
	var move_direction : Vector2
	if is_moving:
		move_direction = navigation_agent.get_next_path_position() - global_position
		move_direction = move_direction.normalized()
		animation_tree.set("parameters/Move/blend_position", move_direction)
		animation_tree.set("parameters/Stand/blend_position", move_direction)
		
	velocity = lerp(velocity, move_direction * move_speed_unit * 24, 1)
	move_and_slide()

func _on_luna_go_out():
	navigation_agent.target_position = Vector2(129,-9)
	is_moving = true
	animation_tree.set("parameters/conditions/is_moving", is_moving)
	Global.paused = true

func _on_navigation_agent_2d_navigation_finished():
	queue_free()
	SignalManager.show_dialogue.emit("start_game", "luna_go_out")
