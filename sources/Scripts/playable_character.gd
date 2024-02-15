extends CharacterBody2D
class_name PlayableCharacter

@export var move_speed_unit = 5 #toc do di chuyen cua nhan vat

@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

var move_input := Vector2()

func _physics_process(_delta):
	move_state()

#Trạng thái di chuyển của nhân vật
func move_state():
	move_input.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	move_input.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down")
	
	#Vecto chuẩn hoá hướng di chuyển
	move_input = move_input.normalized()
	
	#Animation
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/Stand/blend_position", move_input)
		animation_tree.set("parameters/Run/blend_position", move_input)
		animation_state.travel("Run")
	else:
		animation_state.travel("Stand")
	
	#Vecto di chuyen
	velocity = lerp(velocity, move_input * move_speed_unit * 24, 1)
	move_and_slide()
