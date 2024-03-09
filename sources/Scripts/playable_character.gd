extends BattleCharacter
class_name PlayableCharacter

const BIAS = Vector2(0, 5)

@onready var body : Node2D = $Body
@onready var base : Sprite2D = $Body/Base
@onready var one_hand_weapon : Sprite2D = $Body/OneHandWeapon
@onready var shield : Sprite2D = $Body/Shield
@onready var attack_timer : Timer = $AttackTimer

var is_unequip_weapon : bool = true #Check trang bị vũ khí chưa (Chỉnh sửa sau)

var is_attacking : bool = false
var is_attack_state: bool = false
var is_drawing : bool = false
var is_sheathing : bool = false
var is_hurting : bool = false
var is_in_stair_direction : Enums.Direction

var attack_combo : int = 0
var move_input := Vector2()
var mouse := Vector2()

func _ready():
	#Gán texture khi được khởi tạo
	base.texture = load("res://assets/characters/base/standMovePush/humn_v00.png")
	
	_set_body_layer(2,1,0)
	animation_tree.set("parameters/conditions/is_not_attack_state_and_alive", !is_attack_state and is_alive)

#Xử lý thao tác
func _unhandled_input(event):
	#Chỉnh sửa sau (Đang dùng để chỉnh trạng thái trang bị vũ khí)
	if event.is_action_pressed("change_weapon"):
		if is_unequip_weapon:
			equip_weapon()
		else:
			unequip_weapon()
	
	if event.is_action_pressed("draw_sheath"):
		if !is_unequip_weapon:
			if is_attack_state:
				sheath()
			else:
				draw()
	
	#Nhấn phím Attack
	if event.is_action_pressed("attack"):
		if !is_attacking and !is_unequip_weapon and !is_drawing and !is_sheathing and !is_hurting and is_attack_state:
			attack()

func _physics_process(_delta):
	if !is_attacking and !is_drawing and !is_sheathing and !is_hurting:
		move_state()

#Trạng thái di chuyển của nhân vật
func move_state():
	move_input.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	
	#Trục Oy khi di chuyển lên xuống cầu thang
	match is_in_stair_direction:
		Enums.Direction.NONE:
			move_input.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down")
		Enums.Direction.RIGHT:
			move_input.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down") + Input.get_action_strength("move_left") / sqrt(2) - Input.get_action_strength("move_right") / sqrt(2)
		Enums.Direction.LEFT:
			move_input.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down") - Input.get_action_strength("move_left") / sqrt(2) + Input.get_action_strength("move_right") / sqrt(2)
		Enums.Direction.DOWN:
			move_input.y = -Input.get_action_strength("move_up") / 2 + Input.get_action_strength("move_down") / 2
	
	#Vecto chuẩn hoá hướng di chuyển
	move_input = move_input.normalized()
	
	#Animation
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/Base/Stand/blend_position", move_input)
		animation_tree.set("parameters/Base/Run/blend_position", move_input)
		animation_tree.set("parameters/Base/conditions/is_running", true)
		animation_tree.set("parameters/Base/conditions/is_standing", false)
		
		animation_tree.set("parameters/Attack_state/Draw/blend_position", move_input)
		animation_tree.set("parameters/Attack_state/Idle/blend_position", move_input)
		animation_tree.set("parameters/Attack_state/Move/blend_position", move_input)
		animation_tree.set("parameters/Attack_state/Sheath/blend_position", move_input)
		animation_tree.set("parameters/Attack_state/Dodge/blend_position", move_input)
		animation_tree.set("parameters/Attack_state/Parry/blend_position", move_input)
		animation_tree.set("parameters/Attack_state/conditions/is_moving", true)
		animation_tree.set("parameters/Attack_state/conditions/is_idling", false)
	else:
		animation_tree.set("parameters/Base/conditions/is_running", false)
		animation_tree.set("parameters/Base/conditions/is_standing", true)
		
		animation_tree.set("parameters/Attack_state/conditions/is_moving", false)
		animation_tree.set("parameters/Attack_state/conditions/is_idling", true)

	#Vecto di chuyen
	velocity = lerp(velocity, move_input * move_speed_unit * 24, get_move_weight())
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

func attack():
	is_attacking = true
	attack_timer.start()
	mouse = (get_global_mouse_position() - global_position - BIAS).normalized()
	set_attack_animation(mouse, attack_combo)
	if attack_combo < 3:
		attack_combo += 1
	else:
		attack_combo = 0

#Rút vũ khí
func draw():
	set_move_speed_unit(2)
	is_drawing = true
	is_attack_state = true
	animation_tree.set("parameters/Attack_state/conditions/is_drawing", is_drawing)
	animation_tree.set("parameters/Attack_state/conditions/is_not_drawing", !is_drawing)
	animation_tree.set("parameters/conditions/is_attack_state_and_alive", is_attack_state and is_alive)
	animation_tree.set("parameters/conditions/is_not_attack_state_and_alive", !is_attack_state and is_alive)

#Cất vũ khí
func sheath():
	set_move_speed_unit(5)
	is_attack_state = false
	is_sheathing = true
	animation_tree.set("parameters/conditions/is_attack_state_and_alive", is_attack_state and is_alive)
	animation_tree.set("parameters/conditions/is_not_attack_state_and_alive", !is_attack_state and is_alive)
	animation_tree.set("parameters/Attack_state/conditions/is_sheathing", is_sheathing)

#Thiết lập hoạt ảnh đòn đánh
func set_attack_animation(_mouse: Vector2, _attack_combo: int):
	animation_tree.set("parameters/Attack_state/conditions/is_attacking", is_attacking)
	
	#Thiết lập hướng đòn đánh
	animation_tree.set("parameters/Attack_state/Attack/Sword_shield_attack/Slash_1/blend_position", _mouse)
	animation_tree.set("parameters/Attack_state/Attack/Sword_shield_attack/Slash_2/blend_position", _mouse)
	animation_tree.set("parameters/Attack_state/Attack/Sword_shield_attack/Thrust/blend_position", _mouse)
	animation_tree.set("parameters/Attack_state/Attack/Sword_shield_attack/Shield_bash/blend_position", _mouse)
	
	#Thiết lập kiểu vũ khí tấn công (Chỉnh sửa sau)
	animation_tree.set("parameters/Attack_state/Attack/conditions/is_sword_shield_attack", true)
	
	#Thiết lập kiểu tấn công
	animation_tree.set("parameters/Attack_state/Attack/Sword_shield_attack/conditions/is_slash_1", _attack_combo == 0)
	animation_tree.set("parameters/Attack_state/Attack/Sword_shield_attack/conditions/is_slash_2", _attack_combo == 1)
	animation_tree.set("parameters/Attack_state/Attack/Sword_shield_attack/conditions/is_thrust", _attack_combo == 2)
	animation_tree.set("parameters/Attack_state/Attack/Sword_shield_attack/conditions/is_shield_bash", _attack_combo == 3)
	
	#Thiết lập hướng nhân vật sau khi thực hiện đòn đánh
	animation_tree.set("parameters/Attack_state/Idle/blend_position", _mouse)
	animation_tree.set("parameters/Attack_state/Move/blend_position", _mouse)
	animation_tree.set("parameters/Attack_state/Sheath/blend_position", _mouse)
	animation_tree.set("parameters/Attack_state/Dodge/blend_position", _mouse)
	animation_tree.set("parameters/Attack_state/Parry/blend_position", _mouse)

#Kết thúc thời gian để thực hiện combo
func _on_attack_timer_timeout():
	attack_combo = 0 

#Bắt đầu hoạt ảnh tấn công
func _attack_started():
	attack_asset()

#Kết thúc hoạt ảnh tấn công
func _attack_finished():
	is_attacking = false
	animation_tree.set("parameters/Attack_state/conditions/is_attacking", is_attacking)
	move_idle_asset()
	
	#Chỉnh sửa sau
	#animation_tree.set("parameters/Attack_state/Attack/conditions/is_sword_shield_attack", false)

#Bắt đầu hoạt ảnh rút vũ khí
func _draw_started():
	change_state_asset()

#Kết thúc hoạt ảnh rút vũ khí
func _draw_finished():
	is_drawing = false
	animation_tree.set("parameters/Attack_state/conditions/is_drawing", is_drawing)
	animation_tree.set("parameters/Attack_state/conditions/is_not_drawing", !is_drawing)
	move_idle_asset()

#Bắt đầu hoạt ảnh cất vũ khí
func _sheath_started():
	change_state_asset()

#Kết thúc hoạt ảnh cất vũ khí
func _sheath_finished():
	is_sheathing = false
	animation_tree.set("parameters/Attack_state/conditions/is_sheathing", is_sheathing)
	base_asset()

func _hurt_started():
	is_hurting = true
	change_state_asset()

func _hurt_finished():
	velocity = Vector2.ZERO
	is_hurting = false
	animation_tree.set("parameters/conditions/is_attacked", false)
	if is_attack_state:
		move_idle_asset()
	else:
		base_asset()

func base_asset():
	base.texture = load("res://assets/characters/base/standMovePush/humn_v00.png")
	if !is_unequip_weapon:
		one_hand_weapon.texture = load("res://assets/weapon/swordAndShield/standMovePush/axe_v00.png")
		shield.texture = load("res://assets/weapon/swordAndShield/standMovePush/shield_v00.png")

func change_state_asset():
	base.texture = load("res://assets/characters/swordAndShieldBase/changeState/humn_v00.png")
	if !is_unequip_weapon:
		one_hand_weapon.texture = load("res://assets/weapon/swordAndShield/changeState/axe_v00.png")
		shield.texture = load("res://assets/weapon/swordAndShield/changeState/shield_v00.png")

func attack_asset():
	base.texture = load("res://assets/characters/swordAndShieldBase/attack/humn_v00.png")
	if !is_unequip_weapon:
		one_hand_weapon.texture = load("res://assets/weapon/swordAndShield/attack/axe_v00.png")
		shield.texture = load("res://assets/weapon/swordAndShield/attack/shield_v00.png")

func move_idle_asset():
	base.texture = load("res://assets/characters/swordAndShieldBase/moveIdle/humn_v00.png")
	if !is_unequip_weapon:
		one_hand_weapon.texture = load("res://assets/weapon/swordAndShield/moveIdle/axe_v00.png")
		shield.texture = load("res://assets/weapon/swordAndShield/moveIdle/shield_v00.png")

#Thiết lập các tầng sprite body
func _set_body_layer(base_index: int, one_hand_weapon_index:int, shield_index: int):
	body.move_child(base, base_index)
	body.move_child(one_hand_weapon, one_hand_weapon_index)
	body.move_child(shield, shield_index)

func _on_is_attacked():
	animation_tree.set("parameters/conditions/is_attacked", true)


func _on_is_dead():
	is_alive = false
	animation_tree.set("parameters/conditions/is_attack_state_and_alive", is_alive)
	animation_tree.set("parameters/conditions/is_not_attack_state_and_alive", is_alive)
	animation_tree.set("parameters/conditions/is_dead", !is_alive)
