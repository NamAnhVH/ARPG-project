extends Inventory
class_name Equipment

@export_node_path var head_path : NodePath
@export_node_path var chest_path : NodePath
@export_node_path var pants_path : NodePath
@export_node_path var shoes_path : NodePath
@export_node_path var one_hand_weapon_path : NodePath
@export_node_path var shield_path : NodePath
@export_node_path var spear_path : NodePath
@export_node_path var bow_path : NodePath
@export_node_path var main_accessory_path : NodePath
@export_node_path var extra_accessory_path : NodePath

@onready var head : InventorySlot = get_node(head_path)
@onready var chest : InventorySlot = get_node(chest_path)
@onready var pants : InventorySlot = get_node(pants_path)
@onready var shoes : InventorySlot = get_node(shoes_path)
@onready var one_hand_weapon : InventorySlot = get_node(one_hand_weapon_path)
@onready var shield : InventorySlot = get_node(shield_path)
@onready var spear : InventorySlot = get_node(spear_path)
@onready var bow : InventorySlot = get_node(bow_path)
@onready var main_accessory : InventorySlot = get_node(main_accessory_path)
@onready var extra_accessory : InventorySlot = get_node(extra_accessory_path)

func _init():
	set_inventory_size(10)

func _ready():
	slots.append(head)
	slots.append(chest)
	slots.append(pants)
	slots.append(shoes)
	slots.append(one_hand_weapon)
	slots.append(shield)
	slots.append(spear)
	slots.append(bow)
	slots.append(main_accessory)
	slots.append(extra_accessory)
	
	SignalManager.equipment_ready.emit(self)

func set_inventory_size(value):
	inventory_size = value
