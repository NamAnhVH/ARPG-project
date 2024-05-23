extends BattleCharacter
class_name Enemy

@onready var attack_cooldown_time: Timer = $Timers/AttackCooldownTime
@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D

@onready var first_position = global_position

var money_dropped: int
var exp_dropped: int

var is_moving : bool = false
var is_chasing : bool = false
var is_ready_attack : bool = false
var is_attacking : bool = false

func _ready():
	animation_tree.set("parameters/conditions/is_alive", is_alive)
	animation_tree.active = true
	set_stat()

func _physics_process(delta):
	if !Global.paused:
		if is_alive:
			move_state()

func _process(delta):
	if !Global.paused:
		if is_ready_attack and attack_cooldown_time.is_stopped():
			attack_cooldown_time.start()
			is_attacking = true
			animation_tree.set("parameters/conditions/is_attacking", is_attacking)
			attack_state()

func move_state():
	pass

func attack_state():
	animation_tree.set("parameters/Attack/blend_position", navigation_agent.target_position - global_position)

func drop_item():
	pass

func set_stat():
	health = max_health

func _on_detect_area_body_entered(body):
	if body is PlayableCharacter:
		is_chasing = true
		var indicator = ResourceManager.get_instance("indicator")
		indicator.text = "!"
		indicator.indicator_type = GameEnums.INDICATOR_TYPE.EMOTE_INDICATOR
		indicator.texture = preload("res://assets/ui/emote_box.png")
		add_child(indicator)

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
