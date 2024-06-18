extends Node
class_name BuffSlot

@onready var effective_timer : Timer = $EffectiveTime

var type
var amount
var effective_time

func _ready():
	effective_timer.start(effective_time)
	#SignalManager.update_stat.emit()

func _on_effective_time_timeout():
	queue_free()

