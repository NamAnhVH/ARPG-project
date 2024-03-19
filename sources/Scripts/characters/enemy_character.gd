extends BattleCharacter
class_name EnemyCharacter

@export var texture : Texture2D

@onready var attack_cooldown_time: Timer = $Timers/AttackCooldownTime
@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D
@onready var health_bar : ProgressBar = $HealthBar
@onready var first_position = global_position
@onready var random_position = first_position

var is_moving : bool = false
var is_chasing : bool = false
var is_ready_attack : bool = false
var is_attacking : bool = false
var is_clockwise : bool = false

func _ready():
	animation_tree.active = true
	health_bar.init_health(health)

func set_health(value, _is_hitted: bool = false):
	super.set_health(value)
	if health_bar:
		health_bar.set_health(health)
	return value



