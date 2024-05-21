extends Enemy
class_name Minion

@export var min_level = 1
@export var max_level = 10
@export var max_active_area = 50

@onready var move_idle_change_time : Timer = $Timers/MoveIdleChangeTime
@onready var generate_random_position_time : Timer = $Timers/GenerateRandomPositionTime
@onready var health_bar : ProgressBar = $HealthBar/HealthBar


@onready var random_position = global_position

var level

func _ready():
	level = randi_range(min_level, max_level)
	super._ready()
	set_base_texture()
	set_stat()
	health_bar.init_health(health)

func _process(delta):
	super._process(delta)
	if !Global.paused:
		if global_position.distance_to(random_position) < 5:
			generate_random_position()

func generate_random_position():
	var angle = randf_range(0, 2 * PI)
	var offset = Vector2(cos(angle), sin(angle)) * max_active_area
	if random_position.distance_to(first_position + offset) > 50:
		random_position = first_position + offset
		generate_random_position_time.start()
	else:
		generate_random_position()
	if !is_chasing:
		navigation_agent.target_position = random_position

func get_enemy_data(new_enemy):
	new_enemy.min_level = min_level
	new_enemy.max_level = max_level
	new_enemy.global_position = first_position - get_parent().global_position

func set_base_texture():
	pass

func set_stat():
	health = max_health

func set_health(value, _is_hitted: bool = false):
	super.set_health(value)
	if health_bar:
		health_bar.set_health(health)
	return value

func drop_item():
	if randf() > 0.75:
		var item = ItemManager.get_item(ItemManager.items.keys()[randi() % ItemManager.items.size()])
		if level >= item.level and level - 10 <= item.level and !item.unique_drop:
			if item.equipment_type != GameEnums.EQUIPMENT_TYPE.NONE:
				ItemManager.generate_random_rarity(item, Global.player_level)
			
			var floor_item : FloorItem = ResourceManager.get_instance("floor_item")
			floor_item.item = item
			Global.current_map.floor_item.add_child(floor_item)
			floor_item.global_position = global_position
			floor_item.set_z_index(self.z_index)
		else:
			item.queue_free()

func _on_generate_random_position_time_timeout():
	generate_random_position()

func _on_detect_area_body_exited(body):
	if body is PlayableCharacter:
		is_chasing = false
		navigation_agent.target_position = random_position

func _on_move_idle_change_time_timeout():
	is_moving = !is_moving
	move_idle_change_time.start()
