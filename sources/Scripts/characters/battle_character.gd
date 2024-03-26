extends Character
class_name BattleCharacter

signal is_dead()
signal is_attacked()

const KNOCKBACK_VELOCITY = 200

@export var move_speed_unit: float = 5: set = set_move_speed_unit
@export var knockback_modifier: bool = true
@export var move_weight: float = 0.2: set = set_move_weight
@export var max_health : int = 10 : set = set_max_health

@onready var health : int = max_health
@onready var hitbox : Area2D = $Hitbox
@onready var damage_area : Area2D = $DamageArea
@onready var animation_tree : AnimationTree = $AnimationTree

var is_alive : bool = true

##Build
func _ready():
	super._ready()

##Function
func knockback(knockback_strength, damage_source_position: Vector2):
	var normal = (global_position - damage_source_position).normalized()
	if knockback_modifier:
		velocity = knockback_strength * normal * KNOCKBACK_VELOCITY

func show_damage_indicator(amount):
	var damage_indicator = ResourceManager.get_instance("indicator")
	damage_indicator.text = str(amount)
	damage_indicator.indicator_type = GameEnums.INDICATOR_TYPE.DAMAGE_INDICATOR
	add_child(damage_indicator)

##Setget
func set_move_speed_unit(value: float):
	move_speed_unit = value

func set_move_weight(value):
	move_weight = value

func set_health(value, _is_hitted: bool = false):
	health = clamp(health - value, 0, max_health)
	if health <= 0:
		is_dead.emit()
		hitbox.queue_free()
	return value

#Signal Function
func _on_hitbox_damaged(amount, knockback_strength, damage_source, attacker):
	var damage_amount = set_health(amount, true)
	if damage_source != null:
		knockback(knockback_strength, damage_source.global_position)
	is_attacked.emit()
	show_damage_indicator(damage_amount)

func set_max_health(value):
	max_health = value
