extends BattleCharacter
class_name EnemyCharacter

@export var max_active_area = 50
@export var texture : Texture2D
@export var damage_amount : int = 2
@export var knockback_strength: int = 3
@export var list_item_dropped : Array[String]
@export var money_dropped: int
@export var exp_dropped: int

@onready var move_idle_change_time : Timer = $Timers/MoveIdleChangeTime
@onready var generate_random_position_time : Timer = $Timers/GenerateRandomPositionTime
@onready var attack_cooldown_time: Timer = $Timers/AttackCooldownTime
@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D
@onready var health_bar : ProgressBar = $HealthBar/HealthBar
@onready var first_position = global_position
@onready var random_position = first_position

var is_moving : bool = false
var is_chasing : bool = false
var is_ready_attack : bool = false
var is_attacking : bool = false
var is_clockwise : bool = false

func _ready():
	animation_tree.set("parameters/conditions/is_alive", is_alive)
	animation_tree.active = true
	health_bar.init_health(health)
	damage_area.damage_amount = damage_amount
	damage_area.knockback_strength = knockback_strength

func _physics_process(delta):
	if !Global.paused:
		if is_alive:
			move_state()

func _process(delta):
	if !Global.paused:
		if global_position.distance_to(random_position) < 5:
			generate_random_position()
		if is_ready_attack and attack_cooldown_time.is_stopped():
			attack_cooldown_time.start()
			is_attacking = true
			animation_tree.set("parameters/conditions/is_attacking", is_attacking)
			attack_state()

func move_state():
	pass

func attack_state():
	animation_tree.set("parameters/Attack/blend_position", navigation_agent.target_position - global_position)

func generate_random_position():
	is_moving = false
	var angle = randf_range(0, 2 * PI)
	var offset = Vector2(cos(angle), sin(angle)) * max_active_area
	if random_position.distance_to(first_position + offset) > 50:
		random_position = first_position + offset
		generate_random_position_time.start()
	else:
		generate_random_position()
	if !is_chasing:
		navigation_agent.target_position = random_position

func set_health(value, _is_hitted: bool = false):
	super.set_health(value)
	if health_bar:
		health_bar.set_health(health)
	return value

func drop_item():
	if randf() > 0.75:
		if list_item_dropped.size() > 0:
			var item = ItemManager.get_item(list_item_dropped[randi() % list_item_dropped.size()])
			if item.equipment_type != GameEnums.EQUIPMENT_TYPE.NONE:
				ItemManager.generate_random_rarity(item, Global.player_level)
			
			var floor_item : FloorItem = ResourceManager.get_instance("floor_item")
			floor_item.item = item
			Global.current_map.floor_item.add_child(floor_item)
			floor_item.global_position = global_position
			floor_item.set_z_index(self.z_index)

func _on_detect_area_body_entered(body):
	if body is PlayableCharacter:
		is_chasing = true
		var indicator = ResourceManager.get_instance("indicator")
		indicator.text = "!"
		indicator.indicator_type = GameEnums.INDICATOR_TYPE.EMOTE_INDICATOR
		indicator.texture = preload("res://assets/ui/emote_box.png")
		add_child(indicator)

func _on_detect_area_body_exited(body):
	if body is PlayableCharacter:
		is_chasing = false
		navigation_agent.target_position = random_position

func _on_move_idle_change_time_timeout():
	is_moving = !is_moving
	move_idle_change_time.start()

func _on_generate_random_position_time_timeout():
	generate_random_position()

func _die_finished():
	SignalManager.gain_money.emit(money_dropped)
	SignalManager.gain_exp.emit(exp_dropped)
	drop_item()
	SignalManager.enemy_died.emit(self)
	queue_free()

func _hurt_finished():
	velocity = Vector2.ZERO
	animation_tree.set("parameters/conditions/is_attacked", false)

func _attack_finished():
	is_attacking = false
	animation_tree.set("parameters/conditions/is_attacking", is_attacking)

func _on_is_attacked(damage_source):
	animation_tree.set("parameters/conditions/is_attacked", true)
	animation_tree.set("parameters/Hurt/blend_position", damage_source.global_position - global_position)
	is_attacking = false
	animation_tree.set("parameters/conditions/is_attacking", is_attacking)

func _on_is_dead():
	hitbox.queue_free()
	damage_area.queue_free()
	is_alive = false
	animation_tree.set("parameters/conditions/is_alive", is_alive)
	animation_tree.set("parameters/conditions/is_dead", !is_alive)

