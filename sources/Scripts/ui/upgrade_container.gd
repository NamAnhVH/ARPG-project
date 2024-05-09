extends NinePatchRect
class_name Upgrade

@onready var upgrade_slot : UpgradeSlot = $MainContainer/HBoxContainer/UpgradeSlot
@onready var material_slot : UpgradeSlot = $MainContainer/HBoxContainer/MaterialSlot
@onready var label : Label = $MainContainer/Label
@onready var upgrade_button : Button = $MainContainer/UpgradeButton

var upgrade_item : Item
var material_required
var material_available : Item

func _ready():
	SignalManager.upgrade_opened.connect(show)
	SignalManager.upgrade_closed.connect(_on_upgrade_closed)
	SignalManager.upgrade_ready.emit(self)
	
	upgrade_slot.put_item_to_slot.connect(_on_put_item_to_upgrade_slot)
	material_slot.put_item_to_slot.connect(_on_put_item_to_material_slot)

func update():
	material_required = ResourceManager.upgrade_info[str(upgrade_item.upgrade_level + 1)] if upgrade_item else null
	update_label(upgrade_item)
	can_upgrade()

func can_upgrade():
	if material_required and material_available \
	and material_available.id == material_required.item_id \
	and material_available.quantity >= material_required.quantity:
		upgrade_button.disabled = false
	else:
		upgrade_button.disabled = true

func update_label(item):
	if item:
		label.text = "Need " + str(material_required.quantity) + \
		" " + ItemManager.get_item_name(material_required.item_id) + " to upgrade"
	else:
		label.text = ""

func _on_upgrade_closed():
	if upgrade_slot.item:
		var item = upgrade_slot.item
		upgrade_slot.set_item(null)
		SignalManager.inventory_add_item.emit(item)
	if material_slot.item:
		var item = material_slot.item
		material_slot.set_item(null)
		SignalManager.inventory_add_item.emit(item)
	hide()

func _on_put_item_to_upgrade_slot(item: Item):
	if item:
		upgrade_item = item
	else:
		upgrade_item = null
		material_required = null
	update()

func _on_put_item_to_material_slot(item: Item):
	if item:
		material_available = item
	else:
		material_available = null
	update()

func _on_upgrade_button_pressed():
	upgrade_item.upgrade()
	material_available.quantity -= material_required.quantity
	update()

