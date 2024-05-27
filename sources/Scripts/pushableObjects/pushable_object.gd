extends CharacterBody2D
class_name PushableObject

func _ready():
	velocity = Vector2.ZERO

func _physics_process(delta):
	move_and_slide()
	velocity = Vector2.ZERO

func slide(vector):
	velocity = vector
