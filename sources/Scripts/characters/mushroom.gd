extends EnemyCharacter
class_name MushroomCharacter

@onready var body : Sprite2D = $Body
@onready var running_timer : Timer = $Timers/RunningTimer

var drop_mushroom_id
var is_running : bool = false

func move_state():
	var move_direction : Vector2
	if is_running:
		move_direction = global_position - navigation_agent.get_next_path_position()
	else:
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

func drop_item():
	super.drop_item()
	var drop_rate = randf()
	if drop_rate >= 0.75:
		var item = ItemManager.get_item(drop_mushroom_id)
		var floor_item : FloorItem = ResourceManager.get_instance("floor_item")
		floor_item.item = item
		Global.current_map.floor_item.add_child(floor_item)
		floor_item.global_position = global_position + Vector2(5,5)
		floor_item.set_z_index(self.z_index)

func set_stat():
	damage_area.damage_amount = level * 5
	max_health = level * 75
	damage_area.knockback_strength = 3
	money_dropped = level * 4
	exp_dropped = level * 6
	super.set_stat()

func _attack_finished():
	super._attack_finished()
	is_running = true
	running_timer.start()

func set_base_texture():
	body.texture = ResourceManager.get_mushroom_texture(level)
	drop_mushroom_id = body.texture.resource_path.split("/")[-1].replace(".png", "")

func _die_finished():
	var new_mushroom : MushroomCharacter = ResourceManager.get_character("mushroom")
	get_enemy_data(new_mushroom)
	get_parent().get_parent().enemies_respawn.append(new_mushroom)
	super._die_finished()

func _on_move_idle_change_time_timeout():
	is_moving = !is_moving
	move_idle_change_time.start(randf_range(1,2))

func _on_running_timer_timeout():
	is_running = false
