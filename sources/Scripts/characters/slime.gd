extends EnemyCharacter
class_name SlimeCharacter

@onready var clockwise_change_time : Timer = $Timers/ClockwiseChangeTime
@onready var base : Sprite2D = $Body/Base
@onready var attack_effect : Sprite2D = $Body/AttackEffect

func _ready():
	super._ready()
	base.texture = texture
	attack_effect.texture = texture

func move_state():
	var move_direction : Vector2
	move_direction = navigation_agent.get_next_path_position() - global_position
	if is_ready_attack:
		if is_clockwise:
			move_direction = Vector2(move_direction.y, -move_direction.x)
		else: 
			move_direction = Vector2(-move_direction.y, move_direction.x)
	move_direction = move_direction.normalized()
	animation_tree.set("parameters/Move_idle/blend_position", move_direction)
	
	if (!is_chasing and !is_moving and !is_ready_attack) or is_attacking or !is_alive:
		move_direction = Vector2.ZERO
	
	velocity = lerp(velocity, move_direction * move_speed_unit * 24, move_weight)
	move_and_slide()

func generate_random_position():
	is_moving = false
	super.generate_random_position()

func _on_clockwise_change_time_timeout():
	is_clockwise = !is_clockwise
	clockwise_change_time.start()

func _die_finished():
	var new_slime : SlimeCharacter = ResourceManager.get_character("slime")
	get_enemy_data(new_slime)
	get_parent().get_parent().enemies_respawn.append(new_slime)
	super._die_finished()
