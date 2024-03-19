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

##Build
func _ready():
	super._ready()
	SignalManager.equip_item.connect(_on_equip_item)
	SignalManager.unequip_item.connect(_on_unequip_item)
	player_data.changed.connect(_on_data_changed)
	
	_set_body_layer(3,2,1,0)
	animation_tree.set("parameters/conditions/is_not_attack_state_and_alive", !is_attack_state and is_alive)
	_on_data_changed()
	set_player_asset("stand_move_push")

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
	

func _process(_delta):
	if not current_interactable:
		var overlapping_area = interactable_area.get_overlapping_areas()
		
		if overlapping_area.size() > 0 and overlapping_area[0].has_method("interact"):
			current_interactable = overlapping_area[0]
			interactable_labels.display(current_interactable)
		
	if player_data:
		player_data.global_position = global_position
		player_data.health = health
		player_data.max_health = max_health

##State Function
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
	velocity = lerp(velocity, move_input * move_speed_unit * (100 + player_data.get_stat(GameEnums.STAT.MOVE_SPEED)) / 100 * 24, move_weight)
	move_and_slide()


##Function
#Tấn công
func attack():
	damage_area.damage_amount = player_data.get_stat(GameEnums.STAT.ATK)
	is_attacking = true
	attack_timer.start()
	mouse = (get_global_mouse_position() - global_position - BIAS).normalized()
	set_attack_animation()

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

##Setget
func set_health(damage_amount, _is_hitted: bool = false):
	if _is_hitted:
		damage_amount = clamp(damage_amount - player_data.get_stat(GameEnums.STAT.DEF), 0, damage_amount)
	super.set_health(damage_amount)
	SignalManager.new_health.emit(health)
	return damage_amount

func set_max_health(value):
	super.set_max_health(value)
	SignalManager.new_max_health.emit(value)

#Thiết lập hoạt ảnh đòn đánh
func set_attack_animation():
	animation_tree.set("parameters/Attack_state/conditions/is_attacking", is_attacking)
	
	#Nếu vũ khí là vũ khí 1 tay
	if current_weapon.weapon_type == GameEnums.WEAPON_TYPE.ONE_HAND_WEAPON:
		animation_tree.set("parameters/Attack_state/Attack/conditions/is_sword_shield_attack", true)
		
		#Thiết lập hướng đòn đánh
		animation_tree.set("parameters/Attack_state/Attack/Sword_shield_attack/Slash_1/blend_position", mouse)
		animation_tree.set("parameters/Attack_state/Attack/Sword_shield_attack/Slash_2/blend_position", mouse)
		animation_tree.set("parameters/Attack_state/Attack/Sword_shield_attack/Thrust/blend_position", mouse)
		animation_tree.set("parameters/Attack_state/Attack/Sword_shield_attack/Shield_bash/blend_position", mouse)
		
		#Thiết lập kiểu tấn công
		animation_tree.set("parameters/Attack_state/Attack/Sword_shield_attack/conditions/is_slash_1", attack_combo == 0)
		animation_tree.set("parameters/Attack_state/Attack/Sword_shield_attack/conditions/is_slash_2", attack_combo == 1)
		animation_tree.set("parameters/Attack_state/Attack/Sword_shield_attack/conditions/is_thrust", attack_combo == 2)
		animation_tree.set("parameters/Attack_state/Attack/Sword_shield_attack/conditions/is_shield_bash", attack_combo == 3)
		
		if attack_combo < 3:
			attack_combo += 1
		else:
			attack_combo = 0
	
	elif current_weapon.weapon_type == GameEnums.WEAPON_TYPE.SPEAR:
		animation_tree.set("parameters/Attack_state/Attack/conditions/is_spear_attack", true)
		
		#Thiết lập hướng đòn đánh
		animation_tree.set("parameters/Attack_state/Attack/Spear_attack/Slash/blend_position", mouse)
		animation_tree.set("parameters/Attack_state/Attack/Spear_attack/Thrust_1/blend_position", mouse)
		animation_tree.set("parameters/Attack_state/Attack/Spear_attack/Thrust_2/blend_position", mouse)
		
		#Thiết lập kiểu tấn công
		animation_tree.set("parameters/Attack_state/Attack/Spear_attack/conditions/is_slash", attack_combo == 0)
		animation_tree.set("parameters/Attack_state/Attack/Spear_attack/conditions/is_thrust_1", attack_combo % 2 == 1)
		animation_tree.set("parameters/Attack_state/Attack/Spear_attack/conditions/is_thrust_2", attack_combo % 2 == 0 and attack_combo != 0)
		
		if attack_combo < 6:
			attack_combo += 1
		else:
			attack_combo = 0
	
	#Thiết lập hướng nhân vật sau khi thực hiện đòn đánh
	animation_tree.set("parameters/Attack_state/Idle/blend_position", mouse)
	animation_tree.set("parameters/Attack_state/Move/blend_position", mouse)
	animation_tree.set("parameters/Attack_state/Sheath/blend_position", mouse)
	animation_tree.set("parameters/Attack_state/Dodge/blend_position", mouse)
	animation_tree.set("parameters/Attack_state/Parry/blend_position", mouse)

func set_player_asset(asset_type):
	if current_weapon:
		base.texture = ResourceManager.player_character_texture[current_weapon.weapon_type][asset_type][player_base_id]
	else:
		base.texture = ResourceManager.player_character_texture.base.stand_move_push[player_base_id]
	set_equipment_asset(asset_type)

func remove_equipment_asset(equipment_type):
	if equipment_type == GameEnums.EQUIPMENT_TYPE.WEAPON:
		if current_weapon.weapon_type == GameEnums.WEAPON_TYPE.ONE_HAND_WEAPON:
			one_hand_weapon.texture = null
		elif current_weapon.weapon_type == GameEnums.WEAPON_TYPE.SPEAR:
			spear.texture = null
	
	elif equipment_type == GameEnums.EQUIPMENT_TYPE.EXTRA_WEAPON:
		if current_extra_weapon.extra_weapon_type == GameEnums.EXTRA_WEAPON_TYPE.SHIELD:
			shield.texture = null
	

func set_equipment_asset(asset_type: String):
	if !is_unequip_weapon:
		if current_weapon.weapon_type == GameEnums.WEAPON_TYPE.ONE_HAND_WEAPON:
			one_hand_weapon.texture = ResourceManager.weapon_texture[current_weapon.weapon_type][asset_type][current_weapon.id]
			spear.texture = null
		elif current_weapon.weapon_type == GameEnums.WEAPON_TYPE.SPEAR:
			spear.texture = ResourceManager.weapon_texture[current_weapon.weapon_type][asset_type][current_weapon.id]
			one_hand_weapon.texture = null
	if current_extra_weapon:
		if current_weapon and current_weapon.weapon_type == GameEnums.WEAPON_TYPE.SPEAR:
			remove_equipment_asset(GameEnums.EQUIPMENT_TYPE.EXTRA_WEAPON)
		else: 
			if current_extra_weapon.extra_weapon_type == GameEnums.EXTRA_WEAPON_TYPE.SHIELD:
				shield.texture = ResourceManager.extra_weapon_texture[current_extra_weapon.extra_weapon_type][asset_type][current_extra_weapon.id]

#Thiết lập các tầng sprite body
func _set_body_layer(base_index: int, one_hand_weapon_index: int, shield_index: int, spear_index: int):
	body.move_child(base, base_index)
	body.move_child(one_hand_weapon, one_hand_weapon_index)
	body.move_child(shield, shield_index)
	body.move_child(spear, spear_index)

##Signal Function
#Kết thúc thời gian để thực hiện combo
func _on_attack_timer_timeout():
	attack_combo = 0 

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
	health = player_data.health
	max_health = player_data.max_health

func _on_equip_item(item: Item):
	if item.equipment_type == GameEnums.EQUIPMENT_TYPE.WEAPON:
		is_unequip_weapon = false
		current_weapon = item
		if is_attack_state:
			sheath()
		set_player_asset("stand_move_push")
		
	elif item.equipment_type == GameEnums.EQUIPMENT_TYPE.EXTRA_WEAPON:
		if current_weapon and current_weapon.weapon_type == GameEnums.WEAPON_TYPE.SPEAR:
			if item.extra_weapon_type == GameEnums.EXTRA_WEAPON_TYPE.SHIELD:
				shield.texture = null
		else:
			if item.extra_weapon_type == GameEnums.EXTRA_WEAPON_TYPE.SHIELD:
				shield.texture = ResourceManager.extra_weapon_texture[item.extra_weapon_type]["stand_move_push" if !is_attack_state else "move_idle"][item.id]
		current_extra_weapon = item

func _on_unequip_item(equipment_type):
	remove_equipment_asset(equipment_type)
	if equipment_type == GameEnums.EQUIPMENT_TYPE.WEAPON:
		is_unequip_weapon = true
		current_weapon = null
		if is_attack_state:
			sheath()
		set_player_asset("stand_move_push")
	elif equipment_type == GameEnums.EQUIPMENT_TYPE.EXTRA_WEAPON:
		current_extra_weapon = null

##Animation Function
#Bắt đầu hoạt ảnh tấn công
func _attack_started():
	set_player_asset("attack")

#Kết thúc hoạt ảnh tấn công
func _attack_finished(attack_type):
	is_attacking = false
	animation_tree.set("parameters/Attack_state/conditions/is_attacking", is_attacking)
	set_player_asset("move_idle")
	
	animation_tree.set("parameters/Attack_state/Attack/conditions/is_" + attack_type + "_attack", false)

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


