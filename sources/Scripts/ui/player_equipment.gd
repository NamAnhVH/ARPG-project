extends NinePatchRect

var current_equipment : Equipment

func _ready():
	SignalManager.equipment_opened.connect(_on_equipment_opened)
	SignalManager.equipment_closed.connect(_on_equipment_closed)

func _on_equipment_opened(equipment: Equipment):
	current_equipment = equipment
	add_child(current_equipment)
	show()

func _on_equipment_closed(equipment: Equipment):
	remove_child(current_equipment)
	hide()

