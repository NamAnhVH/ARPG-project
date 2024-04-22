extends Area2D

signal damaged(amount, knockback_strength, damage_source, attacker)
signal feature_damaged()

@onready var immunity_timmer = $ImmunityTimer
@onready var parent = get_parent()

@export var immunity_duration := 0.0

#Function
func damage(amount, knockback_strength, damage_source: Area2D, attacker):
	damaged.emit(amount, knockback_strength, damage_source, attacker)
	if immunity_duration > 0:
		immunity_timmer.start(immunity_duration) #Bat dau thoi gian bat tu

#Signal Function
func _on_area_entered(area):
	if !immunity_timmer.is_stopped():
		return
	
	if area is DamageArea:
		if parent is BattleCharacter:
			damage(area.damage_amount, area.knockback_strength, area, area.attacker)
		else:
			feature_damaged.emit()



