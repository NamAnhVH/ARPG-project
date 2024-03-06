extends CharacterBody2D
class_name BattleCharacter

signal is_dead()
signal is_attacked()

const KNOCKBACK_VELOCITY = 200

@export var move_speed_unit: float = 5: set = set_move_speed_unit, get = get_move_speed_unit
@export var knockback_modifier: bool = true
@export var move_weight: float = 0.2: set = set_move_weight, get = get_move_weight
@export var max_health = 10.0


@onready var health = max_health: set = set_health
@onready var hitbox = $Hitbox

var is_alive : bool = true

func _on_hitbox_damaged(amount, knockback_strength, damage_source, attacker):
	set_health(health - amount)
	if damage_source != null:
		knockback(knockback_strength, damage_source.global_position)
	emit_signal("is_attacked")

func knockback(knockback_strength, damage_source_position: Vector2):
	var normal = (global_position - damage_source_position).normalized()
	if knockback_modifier:
		velocity = knockback_strength * normal * KNOCKBACK_VELOCITY

func set_move_speed_unit(value: float):
	move_speed_unit = value

func get_move_speed_unit():
	return move_speed_unit

func set_move_weight(value):
	move_weight = value

func get_move_weight():
	return move_weight

func set_health(value):
	health = clamp(value, 0, max_health)
	if health <= 0:
		emit_signal("is_dead")


