extends Enemy
class_name Boss

@export var damage_amount = 10

var target

func _ready():
	super._ready()
	damage_area.damage_amount = damage_amount
	SignalManager.set_boss.emit(self)

func is_player_outside_area():
	target = null
	is_chasing = false
	navigation_agent.target_position = first_position

func set_health(value, _is_hitted: bool = false):
	super.set_health(value)
	SignalManager.new_boss_health.emit(health)
	return value

func _on_detect_area_body_entered(body):
	if body is PlayableCharacter:
		is_chasing = true
		var indicator = ResourceManager.get_instance("indicator")
		indicator.text = "!"
		indicator.indicator_type = GameEnums.INDICATOR_TYPE.EMOTE_INDICATOR
		indicator.texture = preload("res://assets/ui/emote_box.png")
		add_child(indicator)
		target = body
