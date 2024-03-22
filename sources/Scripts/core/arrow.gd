extends Node2D

@export var speed : int = 500

@onready var sprite : Sprite2D = $Sprite2D
@onready var damage_area : DamageArea = $DamageArea
@onready var impact_detector : Area2D = $ImpactDetector
@onready var life_time : Timer = $Timer/LifeTime
@onready var start_time : Timer = $Timer/StartTime

var damage_amount : int
var attacker
var texture
var direction : Vector2
var mark_value : int

func _ready():
	set_as_top_level(true)
	look_at(position + direction)
	sprite.texture = texture
	damage_area.damage_amount = damage_amount
	impact_detector.set_collision_mask_value(mark_value, true)

func _physics_process(delta):
	if start_time.is_stopped():
		position += direction * speed * delta

func _on_life_time_timeout():
	queue_free()

func _on_impact_detector_body_entered(body):
	if body != attacker:
		queue_free()
