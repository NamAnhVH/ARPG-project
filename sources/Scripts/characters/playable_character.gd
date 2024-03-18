extends BattleCharacter
class_name PlayableCharacter

const BIAS = Vector2(0, 5)

@export var player_data : Resource
@export var player_base_id: String

@onready var body : Node2D = $Body
@onready var base : Sprite2D = $Body/Base
@onready var one_hand_weapon : Sprite2D = $Body/OneHandWeapon
@onready var shield : Sprite2D = $Body/Shield
@onready var spear : Sprite2D = $Body/Spear
@onready var attack_timer : Timer = $AttackTimer
@onready var interactable_area : Area2D = $InteractableArea
@onready var interactable_labels : VBoxContainer = $Interactable/InteractableLabels
@onready var current_map = get_parent()

 #Check trang bị hiện tại
var current_weapon : Item
var current_extra_weapon : Item

#State
var is_unequip_weapon : bool = true
var is_attacking : bool = false
var is_attack_state: bool = false
var is_drawing : bool = false
var is_sheathing : bool = false
var is_hurting : bool = false
var is_in_stair_direction : GameEnums.STAIR_DIRECTION


var attack_combo : int = 0
var move_input := Vector2()
var mouse := Vector2()

var current_interactable

func _ready():
	super._ready()
	SignalManager.equip_item.connect(_on_equip_item)
	SignalManager.unequip_item.connect(_on_unequip_item)
	player_data.changed.connect(_on_data_changed)
	
	_set_body_layer(3,2,1,0)
	animation_tree.set("parameters/conditions/is_not_attack_state_and_alive", !is_attack_state and is_alive)
	_on_data_changed()
	set_player_asset("stand_move_push")

#Xử lý thao tác
func _unhandled_input(event):
	#Nhấn phím chuyển trạng thái sẵn sàng tấn công
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
	
	#Nhấn phím tương tác
	if event.is_action_pressed("interact") and current_interactable:
		current_interactable.interact()

func _physics_process(_delta):
	if !is_attacking and !is_drawing and !is_sheathing and !is_hurting:
		move_state()
	
	if player_data:
		player_data.global_position = global_position

func _process(_delta):
	if not current_interactable:
		var overlapping_area = interactable_area.get_overlapping_areas()
		
		if overlapping_area.size() > 0 and overlapping_area[0].has_method("interact"):
			current_interactable = overlapping_area[0]
			interactable_labels.display(current_interactable)

#Trạng thái di chuyển của nhân vật
func move_state():
	move_input.x = -Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
	
	#Trục Oy khi di chuyển lên xuống cầu thang
	match is_in_stair_direction:
		GameEnums.STAIR_DIRECTION.NONE:
			move_input.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down")
		GameEnums.STAIR_DIRECTION.RIGHT:
			move_input.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down") + Input.get_action_strength("move_left") / sqrt(2) - Input.get_action_strength("move_right") / sqrt(2)
		GameEnums.STAIR_DIRECTION.LEFT:
			move_input.y = -Input.get_action_strength("move_up") + Input.get_action_strength("move_down") - Input.get_action_strength("move_left") / sqrt(2) + Input.get_action_strength("move_right") / sqrt(2)
		GameEnums.STAIR_DIRECTION.DOWN:
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
	velocity = lerp(velocity, move_input * player_data.get_stat(GameEnums.STAT.MOVE_SPEED) * 24, get_move_weight())
	move_and_slide()

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
	set_player_asset("attack")

#Kết thúc hoạt ảnh tấn công
func _attack_finished():
	is_attacking = false
	animation_tree.set("parameters/Attack_state/conditions/is_attacking", is_attacking)
	set_player_asset("move_idle")
	
	#Chỉnh sửa sau
	#animation_tree.set("parameters/Attack_state/Attack/conditions/is_sword_shield_attack", false)

#Bắt đầu hoạt ảnh rút vũ khí
func _draw_started():
	set_player_asset("change_state")

#Kết thúc hoạt ảnh rút vũ khí
func _draw_finished():
	is_drawing = false
	animation_tree.set("parameters/Attack_state/conditions/is_drawing", is_drawing)
	animation_tree.set("parameters/Attack_state/conditions/is_not_drawing", !is_drawing)
	set_player_asset("move_idle")

#Bắt đầu hoạt ảnh cất vũ khí
func _sheath_started():
	set_player_asset("change_state")

#Kết thúc hoạt ảnh cất vũ khí
func _sheath_finished():
	is_sheathing = false
	animation_tree.set("parameters/Attack_state/conditions/is_sheathing", is_sheathing)
	set_player_asset("stand_move_push")

func _hurt_started():
	is_hurting = true
	set_player_asset("change_state")

func _hurt_finished():
	velocity = Vector2.ZERO
	is_hurting = false
	animation_tree.set("parameters/conditions/is_attacked", false)
	if is_attack_state:
		set_player_asset("move_idle")
	else:
		set_player_asset("stand_move_push")

func set_player_asset(asset_type):
	if current_weapon:
		if current_weapon.weapon_type == GameEnums.WEAPON_TYPE.ONE_HAND_WEAPON:
			base.texture = ResourceManager.player_character_texture[current_weapon.weapon_type].stand_move_push[player_base_id]
	else:
		base.texture = ResourceManager.player_character_texture.base.stand_move_push[player_base_id]
	set_equipment_asset(asset_type)

func remove_equipment_asset(equipment_type):
	if equipment_type == GameEnums.EQUIPMENT_TYPE.WEAPON:
		if current_weapon.weapon_type == GameEnums.WEAPON_TYPE.ONE_HAND_WEAPON:
			one_hand_weapon.texture = null
	elif equipment_type == GameEnums.EQUIPMENT_TYPE.EXTRA_WEAPON:
		if current_extra_weapon.extra_weapon_type == GameEnums.EXTRA_WEAPON_TYPE.SHIELD:
			shield.texture = null

func set_equipment_asset(asset_type: String):
	if !is_unequip_weapon:
		if current_weapon.weapon_type == GameEnums.WEAPON_TYPE.ONE_HAND_WEAPON:
			one_hand_weapon.texture = ResourceManager.weapon_texture[current_weapon.weapon_type][asset_type][current_weapon.id]
	if current_extra_weapon:
		if current_extra_weapon.extra_weapon_type == GameEnums.EXTRA_WEAPON_TYPE.SHIELD:
			shield.texture = ResourceManager.extra_weapon_texture[current_extra_weapon.extra_weapon_type][asset_type][current_extra_weapon.id]

#Thiết lập các tầng sprite body
func _set_body_layer(base_index: int, one_hand_weapon_index: int, shield_index: int, spear_index: int):
	body.move_child(base, base_index)
	body.move_child(one_hand_weapon, one_hand_weapon_index)
	body.move_child(shield, shield_index)
	body.move_child(spear, spear_index)

func _on_is_attacked():
	animation_tree.set("parameters/conditions/is_attacked", true)

func _on_is_dead():
	is_alive = false
	animation_tree.set("parameters/conditions/is_attack_state_and_alive", is_alive)
	animation_tree.set("parameters/conditions/is_not_attack_state_and_alive", is_alive)
	animation_tree.set("parameters/conditions/is_dead", !is_alive)

func _on_interactable_area_area_exited(area):
	if current_interactable == area:
		if current_interactable.has_method("out_of_range"):
			current_interactable.out_of_range()
		interactable_labels.hide()
		current_interactable = null

func _on_item_dropped(item):
	var floor_item = ResourceManager.tscn.floor_item.instantiate()
	floor_item.item = item
	current_map.floor_item.add_child(floor_item)
	floor_item.position = position
	floor_item.set_z_index(self.z_index)

func _on_data_changed():
	global_position = player_data.global_position

func _on_equip_item(item: Item):
	if item.equipment_type == GameEnums.EQUIPMENT_TYPE.WEAPON:
			is_unequip_weapon = false
			if item.weapon_type == GameEnums.WEAPON_TYPE.ONE_HAND_WEAPON:
				current_weapon = item
				one_hand_weapon.texture = ResourceManager.weapon_texture[item.weapon_type].stand_move_push[item.id]
		
	elif item.equipment_type == GameEnums.EQUIPMENT_TYPE.EXTRA_WEAPON:
			if item.extra_weapon_type == GameEnums.EXTRA_WEAPON_TYPE.SHIELD:
				current_extra_weapon = item
				shield.texture = ResourceManager.extra_weapon_texture[item.extra_weapon_type].stand_move_push[item.id]

func _on_unequip_item(equipment_type):
	remove_equipment_asset(equipment_type)
	if equipment_type == GameEnums.EQUIPMENT_TYPE.WEAPON:
		is_unequip_weapon = true
		current_weapon = null
		if is_attack_state:
			sheath()
	elif equipment_type == GameEnums.EQUIPMENT_TYPE.EXTRA_WEAPON:
		current_extra_weapon = null
