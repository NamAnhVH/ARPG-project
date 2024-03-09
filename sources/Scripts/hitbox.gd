extends Area2D

signal damaged(amount, knockback_strength, damage_source, attacker)
signal immunity_ended()
signal feature_damaged()

#const HIT_EFFECT = preload("res://Effects/HitEffect.tscn")

@onready var immunity_timmer = $ImmunityTimer
@onready var parent = get_parent()

@export var immunity_duration := 0.0

func _on_area_entered(area):
	if !immunity_timmer.is_stopped():
		return
	
	if area is DamageArea:
		if parent is BattleCharacter:
			damage(area.damage_amount, area.knockback_strength, area, area.attacker)
			#var effect = HIT_EFFECT.instance()
			#var main = get_tree().current_scene
			#main.add_child(effect)
			#effect.global_position = global_position
		else:
			emit_signal("feature_damaged")

func damage(amount, knockback_strength, damage_source: Area2D, attacker):
	emit_signal("damaged", amount, knockback_strength, damage_source, attacker)
	if immunity_duration > 0:
		immunity_timmer.start(immunity_duration) #Bat dau thoi gian bat tu

func _on_immunity_timer_timeout():
	emit_signal("immunity_ended")



