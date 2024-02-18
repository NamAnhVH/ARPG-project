extends BattleCharacter
class_name PlayableCharacter

@export var move_speed_unit = 5 #toc do di chuyen cua nhan vat

@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var body : Node2D = $Body
@onready var base : Sprite2D = $Body/Base
@onready var one_hand_weapon : Sprite2D = $Body/OneHandWeapon

var move_input := Vector2()

func _ready():
	base.texture = load("res://assets/characters/base/standMovePush/humn_v00.png")
	#one_hand_weapon.texture = load("res://assets/Weapon/Axe/char_a_pONE3_6tla_ax01_v01.png")
	
	#Chỉnh sửa sau (Đang dùng để chỉnh trạng thái trang bị vũ khí)
	animation_tree.set("parameters/conditions/is_unequip_weapon", true)

func _unhandled_input(event):
	#Chỉnh sửa sau (Đang dùng để chỉnh trạng thái trang bị vũ khí)
	if event.is_action_pressed("change_weapon"):
		if animation_tree.get("parameters/conditions/is_unequip_weapon"):
			equip_sword_shield()
			animation_tree.set("parameters/conditions/is_unequip_weapon", false)
		else:
			unequip_weapon()
			animation_tree.set("parameters/conditions/is_unequip_weapon", true)


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
		animation_tree.set("parameters/Run_sword_shield/blend_position", move_input)
		animation_tree.set("parameters/Stand_sword_shield/blend_position", move_input)
		animation_tree.set("parameters/conditions/is_running", true)
		animation_tree.set("parameters/conditions/is_stand", false)
		#animation_state.travel("Run")
	else:
		animation_tree.set("parameters/conditions/is_running", false)
		animation_tree.set("parameters/conditions/is_stand", true)
		#animation_state.travel("Stand")
	
	#Vecto di chuyen
	velocity = lerp(velocity, move_input * move_speed_unit * 24, 1)
	move_and_slide()

#Chỉnh sửa sau
func equip_sword_shield():
	one_hand_weapon.texture = load("res://assets/weapon/swordAndShield/standMovePush/axe_v00.png")
	animation_tree.set("parameters/conditions/is_equip_sword_shield", true)

#Chỉnh sửa sau
func unequip_weapon():
	one_hand_weapon.texture = null
	animation_tree.set("parameters/conditions/is_equip_sword_shield", false)
