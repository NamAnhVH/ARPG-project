extends EnemyCharacter
class_name GremlinCharacter

@onready var body : Sprite2D = $Body

func move_state():
	var move_direction : Vector2
	move_direction = navigation_agent.get_next_path_position() - global_position
	move_direction = move_direction.normalized()
	animation_tree.set("parameters/Move_idle/Move/blend_position", move_direction)
	animation_tree.set("parameters/Move_idle/Idle/blend_position", move_direction)
	animation_tree.set("parameters/Move_idle/conditions/is_moving", is_moving or is_chasing)
	animation_tree.set("parameters/Move_idle/conditions/is_idling", !is_moving and !is_chasing)
	
	if (!is_chasing and !is_moving and !is_ready_attack) or is_attacking or !is_alive or is_ready_attack:
		move_direction = Vector2.ZERO
	
	velocity = lerp(velocity, move_direction * move_speed_unit * 24, move_weight)
	move_and_slide()

func attack_state():
	var rand_attack = randi_range(0, 1)
	animation_tree.set("parameters/Attack/Bite/blend_position", navigation_agent.target_position - global_position)
	animation_tree.set("parameters/Attack/Claw/blend_position", navigation_agent.target_position - global_position)
	animation_tree.set("parameters/Attack/conditions/is_biting", rand_attack == 0)
	animation_tree.set("parameters/Attack/conditions/is_clawing", rand_attack == 1)

func set_stat():
	damage_area.damage_amount = level * 6
	damage_area.knockback_strength = 4
	max_health = level * 100
	money_dropped = level * 5
	exp_dropped = level * 8
	super.set_stat()

func set_base_texture():
	body.texture = ResourceManager.get_gremlin_texture(level)

func _attack_finished():
	super._attack_finished()
	animation_tree.set("parameters/Attack/conditions/is_biting", false)
	animation_tree.set("parameters/Attack/conditions/is_clawing", false)

func _die_finished():
	var new_gremlin : GremlinCharacter = ResourceManager.get_character("gremlin")
	get_enemy_data(new_gremlin)
	get_parent().get_parent().enemies_respawn.append(new_gremlin)
	super._die_finished()

func _on_move_idle_change_time_timeout():
	is_moving = !is_moving
	move_idle_change_time.start(randf_range(3,6))
