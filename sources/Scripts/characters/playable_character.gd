extends BattleCharacter
class_name PlayableCharacter

const BIAS = Vector2(0, 5)

@export var player_data : PlayerData
@export var player_base_id: String

@onready var body : Node2D = $Body
@onready var base : Sprite2D = $Body/Base
@onready var one_hand_weapon : Sprite2D = $Body/OneHandWeapon
@onready var shield : Sprite2D = $Body/Shield
@onready var spear : Sprite2D = $Body/Spear
@onready var bow : Sprite2D = $Body/Bow
@onready var quiver : Sprite2D = $Body/Quiver
@onready var attack_timer : Timer = $Timer/AttackTimer
@onready var parry_timer : Timer = $Timer/ParryTimer
@onready var counter_attack_timer : Timer = $Timer/CounterAttackTimer
@onready var interactable_area : Area2D = $InteractableArea
@onready var interactable_labels : VBoxContainer = $Interactable/InteractableLabels
@onready var detect_layer_area : DetectLayerArea = $DetectLayerArea

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
var is_parrying : bool = false

var is_in_stair_direction : GameEnums.STAIR_DIRECTION
var attack_combo : int = 0
var move_input := Vector2()
var mouse := Vector2()
var parry_direction : Vector2
var current_interactable

##Build
func _ready():
	super._ready()
	SignalManager.equip_item.connect(_on_equip_item)
	SignalManager.unequip_item.connect(_on_unequip_item)
	
	##Xoá sau
	SignalManager.set_player.connect(_on_data_changed)
	
	#SignalManager.gain_money.connect(_on_gain_money)
	#SignalManager.gain_exp.connect(_on_gain_exp)
	
	SignalManager.heal_player.connect(set_health)
	SignalManager.level_up.connect(_on_level_up)
	SignalManager.item_changed.connect(_on_item_changed)

	player_data.changed.connect(_on_data_changed)
	
	_set_body_layer(5,4,3,2,1,0)
	animation_tree.set("parameters/conditions/is_not_attack_state_and_alive", !is_attack_state and is_alive)
	_on_data_changed()

func _unhandled_input(event):
	if !Global.paused:
		#Nhấn phím chuyển trạng thái sẵn sàng tấn công
		if event.is_action_pressed("draw_sheath"):
			if !is_unequip_weapon:
				if is_attack_state:
					sheath()
				else:
					draw()
		
		#Nhấn phím Attack
		if event.is_action_pressed("attack"):
			if !is_attacking and !is_drawing and !is_sheathing and !is_hurting and is_attack_state:
				attack()
		
		#Nhấn phím tương tác
		if event.is_action_pressed("interact") and current_interactable:
			current_interactable.interact()
			
		#Nhấn phím đỡ đòn
		if is_attack_state and !is_attacking and parry_timer.is_stopped():
			if event.get_action_strength("dodge"):
				is_parrying = true
			elif event.is_action_released("dodge"):
				if is_parrying:
					is_parrying = false
					parry_timer.start()
		
		#Nhấn phím mở danh sách nhiệm vụ
		if event.is_action_pressed("quest"):
			SignalManager.show_quest.emit()

func _physics_process(_delta):
	if !Global.paused:
		if !is_attacking and !is_drawing and !is_sheathing and !is_hurting and !is_parrying and is_alive:
			move_state()
	else: 
		if !is_attack_state:
			animation_tree.set("parameters/Base/conditions/is_running", false)
			animation_tree.set("parameters/Base/conditions/is_standing", true)
		else:
			animation_tree.set("parameters/Attack_state/conditions/is_moving", false)
			animation_tree.set("parameters/Attack_state/conditions/is_idling", true)
		
func _process(_delta):
	if !Global.paused:
		if !current_interactable:
			var overlapping_area = interactable_area.get_overlapping_areas()
			
			if overlapping_area.size() > 0 and overlapping_area[0].has_method("interact"):
				current_interactable = overlapping_area[0]
				interactable_labels.display(current_interactable)
			
			var overlapping_body = interactable_area.get_overlapping_bodies()
			if overlapping_body.size() > 0 and overlapping_body[0].has_method("interact"):
				current_interactable = overlapping_body[0]
				interactable_labels.display(current_interactable)
		
		if player_data:
			set_player_data()
		
		parry()


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
		
		animation_tree.set("parameters/Attack_state/Idle/blend_position", move_input)
		animation_tree.set("parameters/Attack_state/Move/blend_position", move_input)

		animation_tree.set("parameters/Attack_state/Dodge/blend_position", move_input)
		animation_tree.set("parameters/Attack_state/Parry/blend_position", move_input)
		
		if !is_attack_state:
			animation_tree.set("parameters/Attack_state/Draw/blend_position", move_input)
			animation_tree.set("parameters/Base/conditions/is_running", true)
			animation_tree.set("parameters/Base/conditions/is_standing", false)
		else:
			animation_tree.set("parameters/Attack_state/Sheath/blend_position", move_input)
			animation_tree.set("parameters/Attack_state/conditions/is_moving", true)
			animation_tree.set("parameters/Attack_state/conditions/is_idling", false)
	else:
		if !is_attack_state:
			animation_tree.set("parameters/Base/conditions/is_running", false)
			animation_tree.set("parameters/Base/conditions/is_standing", true)
		else:
			animation_tree.set("parameters/Attack_state/conditions/is_moving", false)
			animation_tree.set("parameters/Attack_state/conditions/is_idling", true)

	#Vecto di chuyen
	velocity = lerp(velocity, move_input * move_speed_unit * (100 + player_data.get_stat(GameEnums.STAT.MOVE_SPEED)) / 100 * 24, move_weight)
	move_and_slide()

##Function
#Tấn công
func attack():
	damage_area.damage_amount = get_player_damage() + attack_combo * 2
	is_attacking = true
	attack_timer.start()
	mouse = (get_global_mouse_position() - global_position - BIAS).normalized()
	set_attack_animation()

#Rút vũ khí
func draw():
	set_move_speed_unit(2)
	is_drawing = true
	is_attack_state = true
	animation_tree.set("parameters/conditions/is_attack_state_and_alive", is_attack_state and is_alive)
	animation_tree.set("parameters/conditions/is_not_attack_state_and_alive", !is_attack_state and is_alive)
	animation_tree.set("parameters/Attack_state/conditions/is_drawing", is_drawing)
	animation_tree.set("parameters/Attack_state/conditions/is_not_drawing", !is_drawing)

#Cất vũ khí
func sheath():
	set_move_speed_unit(5)
	is_attack_state = false
	is_sheathing = true
	animation_tree.set("parameters/conditions/is_attack_state_and_alive", is_attack_state and is_alive)
	animation_tree.set("parameters/conditions/is_not_attack_state_and_alive", !is_attack_state and is_alive)
	animation_tree.set("parameters/Attack_state/conditions/is_sheathing", is_sheathing)

#Đỡ đòn
func parry():
	if is_parrying:
		parry_direction = (get_global_mouse_position() - global_position - BIAS).normalized()
		animation_tree.set("parameters/Attack_state/Parry/blend_position", parry_direction)
	animation_tree.set("parameters/Attack_state/conditions/is_parrying", is_parrying)
	animation_tree.set("parameters/Attack_state/conditions/is_not_parrying", !is_parrying)

func check_parry_direction(attacker):
	var attacker_direction = (attacker.global_position - global_position).normalized()
	return abs(parry_direction.x - attacker_direction.x) < 0.5 and abs(parry_direction.y - attacker_direction.y) < 0.5

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
		
		#Thiết lập hướng đòn đánh và kiểu tấn công
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
	
	elif current_weapon.weapon_type == GameEnums.WEAPON_TYPE.BOW:
		animation_tree.set("parameters/Attack_state/Attack/conditions/is_bow_attack", true)
		
		#Thiết lập hướng đòn đánh
		animation_tree.set("parameters/Attack_state/Attack/Bow_attack/blend_position", mouse)
	
	#Thiết lập hướng nhân vật sau khi thực hiện đòn đánh
	animation_tree.set("parameters/Attack_state/Idle/blend_position", mouse)
	animation_tree.set("parameters/Attack_state/Move/blend_position", mouse)
	animation_tree.set("parameters/Attack_state/Sheath/blend_position", mouse)
	animation_tree.set("parameters/Attack_state/Dodge/blend_position", mouse)
	animation_tree.set("parameters/Attack_state/Parry/blend_position", mouse)

func set_player_asset(asset_type: String):
	if current_weapon:
		base.texture = ResourceManager.player_character_texture[current_weapon.weapon_type][asset_type][player_base_id]
	else:
		base.texture = ResourceManager.player_character_texture.base.stand_move_push[player_base_id]
	set_equipment_asset(asset_type)

func remove_equipment_asset(equipment_type):
	if equipment_type == GameEnums.EQUIPMENT_TYPE.WEAPON:
		if current_weapon:
			if current_weapon.weapon_type == GameEnums.WEAPON_TYPE.ONE_HAND_WEAPON:
				one_hand_weapon.texture = null
			elif current_weapon.weapon_type == GameEnums.WEAPON_TYPE.SPEAR:
				spear.texture = null
			elif current_weapon.weapon_type == GameEnums.WEAPON_TYPE.BOW:
				bow.texture = null
	
	elif equipment_type == GameEnums.EQUIPMENT_TYPE.EXTRA_WEAPON:
		if current_extra_weapon:
			if current_extra_weapon.extra_weapon_type == GameEnums.EXTRA_WEAPON_TYPE.SHIELD:
				shield.texture = null
			elif current_extra_weapon.extra_weapon_type == GameEnums.EXTRA_WEAPON_TYPE.QUIVER:
				quiver.texture = null

func set_equipment_asset(asset_type: String):
	if !is_unequip_weapon:
		if current_weapon.weapon_type == GameEnums.WEAPON_TYPE.ONE_HAND_WEAPON:
			one_hand_weapon.texture = ResourceManager.weapon_texture[current_weapon.weapon_type][asset_type][current_weapon.id]
			spear.texture = null
			bow.texture = null
		elif current_weapon.weapon_type == GameEnums.WEAPON_TYPE.SPEAR:
			spear.texture = ResourceManager.weapon_texture[current_weapon.weapon_type][asset_type][current_weapon.id]
			one_hand_weapon.texture = null
			bow.texture = null
		elif current_weapon.weapon_type == GameEnums.WEAPON_TYPE.BOW:
			bow.texture = ResourceManager.weapon_texture[current_weapon.weapon_type][asset_type][current_weapon.id]
			one_hand_weapon.texture = null
			spear.texture = null
	
	if current_extra_weapon:
		if current_weapon:
			if current_weapon.weapon_type == GameEnums.WEAPON_TYPE.SPEAR:
				remove_equipment_asset(GameEnums.EQUIPMENT_TYPE.EXTRA_WEAPON)
			if current_weapon.weapon_type == GameEnums.WEAPON_TYPE.ONE_HAND_WEAPON:
				shield.texture = ResourceManager.extra_weapon_texture[current_extra_weapon.extra_weapon_type][asset_type][current_extra_weapon.id] if current_extra_weapon.extra_weapon_type == GameEnums.EXTRA_WEAPON_TYPE.SHIELD else null
				quiver.texture = null
			if current_weapon.weapon_type == GameEnums.WEAPON_TYPE.BOW:
				quiver.texture = ResourceManager.extra_weapon_texture[current_extra_weapon.extra_weapon_type][asset_type][current_extra_weapon.id] if current_extra_weapon.extra_weapon_type == GameEnums.EXTRA_WEAPON_TYPE.QUIVER else null
				shield.texture = null
		else:
			if current_extra_weapon.extra_weapon_type == GameEnums.EXTRA_WEAPON_TYPE.SHIELD:
				shield.texture = ResourceManager.extra_weapon_texture[current_extra_weapon.extra_weapon_type][asset_type][current_extra_weapon.id]
			else:
				quiver.texture = ResourceManager.extra_weapon_texture[current_extra_weapon.extra_weapon_type][asset_type][current_extra_weapon.id]

func set_player_data():
	player_data.global_position = global_position
	player_data.health = health
	player_data.z_index = z_index

func set_collision_value():
	var current_collision_value = (z_index + 1) / 2
	set_collision_layer_value(current_collision_value, true)
	set_collision_mask_value(current_collision_value, true)
	hitbox.set_collision_mask_value(current_collision_value + 16, true)
	damage_area.set_collision_layer_value(current_collision_value + 20, true)

#Thiết lập các tầng sprite body
func _set_body_layer(base_index: int, one_hand_weapon_index: int, shield_index: int, spear_index: int, bow_index: int, quiver_index: int):
	body.move_child(base, base_index)
	body.move_child(one_hand_weapon, one_hand_weapon_index)
	body.move_child(shield, shield_index)
	body.move_child(spear, spear_index)
	body.move_child(bow, bow_index)
	body.move_child(quiver, quiver_index)

func get_player_damage():
	var damage_amount = player_data.get_stat(GameEnums.STAT.ATK)
	if randf() < float(player_data.get_stat(GameEnums.STAT.CRIT_RATE)) / 100:
		damage_amount += int(round(damage_amount * player_data.get_stat(GameEnums.STAT.CRIT_DAMAGE) / 100))
	return damage_amount

##Signal Function
#Kết thúc thời gian để thực hiện combo
func _on_attack_timer_timeout():
	attack_combo = 0 

func _on_is_attacked(damage_source):
	animation_tree.set("parameters/Hurt/blend_position", damage_source.global_position - global_position)
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

func _on_interactable_area_body_exited(_body):
	if current_interactable == _body:
		if current_interactable.has_method("out_of_range"):
			current_interactable.out_of_range()
		interactable_labels.hide()
		current_interactable = null

func _on_item_dropped(item):
	var floor_item = ResourceManager.tscn.floor_item.instantiate()
	floor_item.item = item
	Global.current_map.floor_item.add_child(floor_item)
	floor_item.global_position = global_position
	floor_item.set_z_index(self.z_index)

func _on_data_changed():
	player_data.global_position.x = fmod(fmod(player_data.global_position.x, 896) + 896, 896)
	player_data.global_position.y = fmod(fmod(player_data.global_position.y, 896) + 896, 896)
	global_position = player_data.global_position
	health = player_data.health
	#max_health = player_data.get_stat(GameEnums.STAT.LIFE_POINT)
	z_index = player_data.z_index
	set_collision_value()

func _on_item_changed():
	max_health = player_data.get_stat(GameEnums.STAT.LIFE_POINT)

func _on_level_up():
	max_health = player_data.get_stat(GameEnums.STAT.LIFE_POINT) 
	health = max_health
	SignalManager.new_health.emit(health)

func _on_equip_item(item: Item):
	if item.equipment_type == GameEnums.EQUIPMENT_TYPE.WEAPON:
		is_unequip_weapon = false
		current_weapon = item
		if current_weapon.weapon_type == GameEnums.WEAPON_TYPE.ONE_HAND_WEAPON:
			one_hand_weapon.texture = ResourceManager.weapon_texture[current_weapon.weapon_type].stand_move_push[current_weapon.id]
		elif current_weapon.weapon_type == GameEnums.WEAPON_TYPE.SPEAR:
			spear.texture = ResourceManager.weapon_texture[current_weapon.weapon_type].stand_move_push[current_weapon.id]
		elif current_weapon.weapon_type == GameEnums.WEAPON_TYPE.BOW:
			bow.texture = ResourceManager.weapon_texture[current_weapon.weapon_type].stand_move_push[current_weapon.id]
		set_player_asset("stand_move_push")
	
	elif item.equipment_type == GameEnums.EQUIPMENT_TYPE.EXTRA_WEAPON:
		if current_weapon and current_weapon.weapon_type == GameEnums.WEAPON_TYPE.SPEAR:
			if item.extra_weapon_type == GameEnums.EXTRA_WEAPON_TYPE.SHIELD:
				shield.texture = null
			elif item.extra_weapon_type == GameEnums.EXTRA_WEAPON_TYPE.QUIVER:
				quiver.texture = null
		else:
			if item.extra_weapon_type == GameEnums.EXTRA_WEAPON_TYPE.SHIELD:
				shield.texture = ResourceManager.extra_weapon_texture[item.extra_weapon_type]["stand_move_push" if !is_attack_state else "move_idle"][item.id]
			elif item.extra_weapon_type == GameEnums.EXTRA_WEAPON_TYPE.QUIVER:
				quiver.texture = ResourceManager.extra_weapon_texture[item.extra_weapon_type]["stand_move_push" if !is_attack_state else "move_idle"][item.id]
		current_extra_weapon = item

func _on_unequip_item(equipment_type):
	remove_equipment_asset(equipment_type)
	if equipment_type == GameEnums.EQUIPMENT_TYPE.WEAPON:
		is_unequip_weapon = true
		current_weapon = null
		if is_attack_state:
			sheath()
	elif equipment_type == GameEnums.EQUIPMENT_TYPE.EXTRA_WEAPON:
		current_extra_weapon = null

func _on_hitbox_damaged(amount, knockback_strength, damage_source, attacker):
	if is_parrying and check_parry_direction(attacker):
		if !counter_attack_timer.is_stopped():
			attacker.hitbox.damaged.emit(get_player_damage(), 1, damage_area, self)
		else:
			super._on_hitbox_damaged(0, 0, damage_source, attacker)
	else:
		super._on_hitbox_damaged(amount, knockback_strength, damage_source, attacker)

#func _on_gain_money(value):
	#var indicator = ResourceManager.get_instance("indicator")
	#indicator.text = str(value)
	#indicator.indicator_type = GameEnums.INDICATOR_TYPE.MONEY_INDICATOR
	#add_child(indicator)
#
#func _on_gain_exp(value):
	#var indicator = ResourceManager.get_instance("indicator")
	#indicator.text = str(value)
	#indicator.indicator_type = GameEnums.INDICATOR_TYPE.EXP_INDICATOR
	#add_child(indicator)

##Animation Function
#Bắt đầu hoạt ảnh tấn công
func _attack_started():
	pass

#Kết thúc hoạt ảnh tấn công
func _attack_finished(attack_type):
	is_attacking = false
	animation_tree.set("parameters/Attack_state/conditions/is_attacking", is_attacking)
	animation_tree.set("parameters/Attack_state/Attack/conditions/is_" + attack_type + "_attack", false)

func _shoot_arrow():
	var arrow = ResourceManager.get_instance("arrow")
	arrow.damage_amount = get_player_damage()
	arrow.global_position = global_position
	arrow.direction = mouse
	arrow.attacker = self
	if current_extra_weapon and current_extra_weapon.extra_weapon_type == GameEnums.EXTRA_WEAPON_TYPE.QUIVER:
		arrow.texture = ResourceManager.arrow_texture[current_extra_weapon.id]
	else:
		arrow.texture = ResourceManager.arrow_texture["quiver_v00"]
	arrow.z_index = z_index
	arrow.mark_value = (z_index + 1) / 2
	add_child(arrow)

#Bắt đầu hoạt ảnh rút vũ khí
func _draw_started():
	pass

#Kết thúc hoạt ảnh rút vũ khí
func _draw_finished():
	is_drawing = false
	animation_tree.set("parameters/Attack_state/conditions/is_drawing", is_drawing)
	animation_tree.set("parameters/Attack_state/conditions/is_not_drawing", !is_drawing)

#Bắt đầu hoạt ảnh cất vũ khí
func _sheath_started():
	pass

#Kết thúc hoạt ảnh cất vũ khí
func _sheath_finished():
	is_sheathing = false
	animation_tree.set("parameters/Attack_state/conditions/is_sheathing", is_sheathing)

func _hurt_started():
	is_hurting = true

func _hurt_finished():
	velocity = Vector2.ZERO
	is_hurting = false
	animation_tree.set("parameters/conditions/is_attacked", false)


