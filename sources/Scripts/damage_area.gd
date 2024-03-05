extends Area2D
class_name DamageArea

signal hitteded()

@export var damage_amount : int = 1
@export var knockback_strength : int = 3
@export var use_exceptions : bool = false
var attacker

var exceptions : Array = []

func on_hit(hitbox : Area2D):
	if use_exceptions:
		exceptions.append(hitbox)
	emit_signal("hitteded")
	
