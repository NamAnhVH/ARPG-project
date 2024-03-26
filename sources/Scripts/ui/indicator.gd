extends Node2D
class_name Indicator

@export var speed : int = 50
@export var friction : int = 20

@onready var texture_rect : TextureRect = $TextureRect
@onready var label : Label = $TextureRect/Label

var shift_direction: Vector2 = Vector2.ZERO
var text : String
var indicator_type : GameEnums.INDICATOR_TYPE
var texture 

func _ready():
	label.text = text
	texture_rect.texture = texture
	if indicator_type == GameEnums.INDICATOR_TYPE.DAMAGE_INDICATOR:
		label.label_settings.font_color = Color("ffffff")
		shift_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	elif indicator_type == GameEnums.INDICATOR_TYPE.EMOTE_INDICATOR:
		label.label_settings.font_color = Color("ff0000")

func _process(delta):
	if indicator_type == GameEnums.INDICATOR_TYPE.DAMAGE_INDICATOR:
		global_position += speed * shift_direction * delta
		speed = max(speed - friction * delta, 0)
	elif indicator_type == GameEnums.INDICATOR_TYPE.EMOTE_INDICATOR:
		global_position = get_parent().global_position + Vector2(-8, -20)

