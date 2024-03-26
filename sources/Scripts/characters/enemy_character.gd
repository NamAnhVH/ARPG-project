extends BattleCharacter
class_name EnemyCharacter

@export var texture : Texture2D
@export var damage_amount : int = 2
@export var knockback_strength: int = 3
@export var list_item_dropped : Array[String]
@export var money_dropped: int
@export var exp_dropped: int

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

func drop_item():
	var item = ItemManager.get_item(list_item_dropped[randi() % list_item_dropped.size()])
		
	if item.equipment_type != GameEnums.EQUIPMENT_TYPE.NONE:
		ItemManager.generate_random_rarity(item, 100)
	
	var floor_item = ResourceManager.tscn.floor_item.instantiate()
	floor_item.item = item
	Global.current_map.floor_item.add_child(floor_item)
	floor_item.position = position
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

func _die_finished():
	SignalManager.gain_money.emit(money_dropped)
	SignalManager.gain_exp.emit(exp_dropped)
	drop_item()
	queue_free()
