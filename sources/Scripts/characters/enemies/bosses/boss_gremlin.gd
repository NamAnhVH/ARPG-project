extends Boss

signal stone_drop

@onready var ready_screaming : Timer = $Timers/ReadyScreming
@onready var hurt_animation : AnimationPlayer = $HurtAnimation

var is_range_attack

func _process(delta):
	if !Global.paused:
		if target:
			if !is_range_attack:
				navigation_agent.target_position = target.global_position
				if is_ready_attack and attack_cooldown_time.is_stopped():
					attack_cooldown_time.start()
					is_attacking = true
					animation_tree.set("parameters/conditions/is_moving", false)
					animation_tree.set("parameters/conditions/is_idling", true)
					animation_tree.set("parameters/conditions/is_attacking", is_attacking)
					attack_state()
			else:
				if ready_screaming.is_stopped():
					is_range_attack = true
					ready_screaming.start()
		else:
			navigation_agent.target_position = first_position

func check_moving():
	return global_position.distance_to(navigation_agent.target_position) > 5 or is_range_attack

func move_state():
	var move_direction : Vector2
	if is_range_attack:
		move_direction = global_position - navigation_agent.get_next_path_position()
	else:
		move_direction = navigation_agent.get_next_path_position() - global_position
	move_direction = move_direction.normalized()
	animation_tree.set("parameters/Move/blend_position", move_direction)
	animation_tree.set("parameters/Idle/blend_position", move_direction)
	if (!is_chasing and !is_ready_attack and !check_moving()) or is_attacking or !is_alive or (is_ready_attack and !is_range_attack):
		move_direction = Vector2.ZERO
	animation_tree.set("parameters/conditions/is_moving", move_direction != Vector2.ZERO)
	animation_tree.set("parameters/conditions/is_idling", move_direction == Vector2.ZERO)
	
	velocity = lerp(velocity, move_direction * move_speed_unit * 24, move_weight)
	move_and_slide()

func attack_state():
	var rand_attack = randi_range(0, 1)
	animation_tree.set("parameters/Attack/Bite/blend_position", navigation_agent.target_position - global_position)
	animation_tree.set("parameters/Attack/Claw/blend_position", navigation_agent.target_position - global_position)
	animation_tree.set("parameters/Attack/conditions/is_biting", rand_attack == 0)
	animation_tree.set("parameters/Attack/conditions/is_clawing", rand_attack == 1)

func range_attack_state():
	is_range_attack = false
	is_attacking = true
	animation_tree.set("parameters/conditions/is_attacking", is_attacking)
	animation_tree.set("parameters/Attack/Scream/blend_position", navigation_agent.target_position - global_position)
	animation_tree.set("parameters/Attack/conditions/is_screaming", true)

func _attack_finished():
	super._attack_finished()
	animation_tree.set("parameters/Attack/conditions/is_biting", false)
	animation_tree.set("parameters/Attack/conditions/is_clawing", false)

func _screaming_finished():
	super._attack_finished()
	animation_tree.set("parameters/Attack/conditions/is_screaming", false)
	stone_drop.emit()

func _on_attack_cooldown_time_timeout():
	if randf() > 0.8:
		is_range_attack = true

func _on_ready_screming_timeout():
	range_attack_state()

func _on_is_attacked(damage_source):
	hurt_animation.queue("hurt")
