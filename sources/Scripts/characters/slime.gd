extends EnemyCharacter
class_name SlimeCharacter

@export var max_active_area = 50

@onready var move_idle_change_time : Timer = $Timers/MoveIdleChangeTime
@onready var clockwise_change_time : Timer = $Timers/ClockwiseChangeTime
@onready var base : Sprite2D = $Body/Base
@onready var attack_effect : Sprite2D = $Body/AttackEffect

func _ready():
	super._ready()
	base.texture = texture
	attack_effect.texture = texture
	animation_tree.set("parameters/conditions/is_alive", is_alive)

func _physics_process(delta):
	if is_alive:
		move_state()

func _process(delta):
	if global_position.distance_to(random_position) < 5:
		generate_random_position()
	if is_ready_attack and attack_cooldown_time.is_stopped():
		attack_cooldown_time.start()
		is_attacking = true
		animation_tree.set("parameters/Attack/blend_position", navigation_agent.target_position - global_position)
		animation_tree.set("parameters/conditions/is_attacking", is_attacking)


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
	
	if !is_chasing and !is_moving and !is_ready_attack or is_attacking:
		move_direction = Vector2.ZERO
	
	velocity = lerp(velocity, move_direction * move_speed_unit * 24, move_weight)
	move_and_slide()

func generate_random_position():
	is_moving = false
	var angle = randf_range(0, 2 * PI)
	var offset = Vector2(cos(angle), sin(angle)) * max_active_area
	random_position = first_position + offset
	if !is_chasing:
		navigation_agent.target_position = random_position

func _hurt_finished():
	velocity = Vector2.ZERO
	animation_tree.set("parameters/conditions/is_attacked", false)

func _attack_finished():
	is_attacking = false
	animation_tree.set("parameters/conditions/is_attacking", is_attacking)

func _die_finished():
	queue_free()

func _on_is_attacked():
	animation_tree.set("parameters/conditions/is_attacked", true)
	animation_tree.set("parameters/Hurt/blend_position", -velocity)
	is_attacking = false
	animation_tree.set("parameters/conditions/is_attacking", is_attacking)

func _on_is_dead():
	is_alive = false
	animation_tree.set("parameters/conditions/is_alive", is_alive)
	animation_tree.set("parameters/conditions/is_dead", !is_alive)

func _on_move_idle_change_time_timeout():
	is_moving = !is_moving
	move_idle_change_time.start()

func _on_clockwise_change_time_timeout():
	is_clockwise = !is_clockwise
	clockwise_change_time.start()
