extends CharacterBody2D
class_name PlayableCharacter

@export var move_speed_unit = 20 #toc do di chuyen cua nhan vat

var move_input := Vector2()

func _physics_process(_delta):
	move_state()

#Trạng thái di chuyển của nhân vật
func move_state():
	move_input.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	move_input.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down")
	#Vecto chuẩn hoá hướng di chuyển
	move_input = move_input.normalized()
	#Vecto di chuyen
	velocity = lerp(velocity, move_input * move_speed_unit * 24, 1)
	move_and_slide()
