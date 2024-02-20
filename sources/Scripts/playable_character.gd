extends BattleCharacter
class_name PlayableCharacter

@export var move_speed_unit = 5 #toc do di chuyen cua nhan vat

@onready var animation_tree = $AnimationTree
@onready var base : Sprite2D = $Body/Base
@onready var one_hand_weapon : Sprite2D = $Body/OneHandWeapon
@onready var shield : Sprite2D = $Body/Shield

var is_unequip_weapon : bool = true #Check trang bị vũ khí chưa (Chỉnh sửa sau)

var move_input := Vector2()

func _ready():
	#Gán texture khi được khởi tạo
	base.texture = load("res://assets/characters/base/standMovePush/humn_v00.png")
	
	#Chỉnh sửa sau (Đang dùng để chỉnh trạng thái trang bị vũ khí)
	animation_tree.set("parameters/conditions/is_unequip_weapon", true)

func _unhandled_input(event):
	#Chỉnh sửa sau (Đang dùng để chỉnh trạng thái trang bị vũ khí)
	if event.is_action_pressed("change_weapon"):
		if is_unequip_weapon:
			equip_weapon()
		else:
			unequip_weapon()

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
		animation_tree.set("parameters/conditions/is_running", true)
		animation_tree.set("parameters/conditions/is_stand", false)

	else:
		animation_tree.set("parameters/conditions/is_running", false)
		animation_tree.set("parameters/conditions/is_stand", true)

	
	#Vecto di chuyen
	velocity = lerp(velocity, move_input * move_speed_unit * 24, 1)
	move_and_slide()

#Chỉnh sửa sau
func equip_weapon():
	one_hand_weapon.texture = load("res://assets/weapon/swordAndShield/standMovePush/axe_v00.png")
	shield.texture = load("res://assets/weapon/swordAndShield/standMovePush/shield_v00.png")
	is_unequip_weapon = false

#Chỉnh sửa sau
func unequip_weapon():
	one_hand_weapon.texture = null
	shield.texture = null
	is_unequip_weapon = true

