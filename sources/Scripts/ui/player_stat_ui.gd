extends NinePatchRect

@export var player_data : Resource

@onready var lbl_atk : Label = $StatContainer/VBoxContainer/AttackDamage/Stat
@onready var lbl_move_speed : Label = $StatContainer/VBoxContainer/MoveSpeed/Stat
@onready var lbl_def : Label = $StatContainer/VBoxContainer/Defence/Stat
@onready var lbl_crit_rate : Label = $StatContainer/VBoxContainer/CritRate/Stat
@onready var lbl_crit_damage : Label = $StatContainer/VBoxContainer/CritDamage/Stat
@onready var lbl_life_point : Label = $StatContainer/VBoxContainer/LifePoint/Stat

func _ready():
	SignalManager.inventory_opened.connect(_on_inventory_opened)
	SignalManager.inventory_closed.connect(_on_inventory_closed)
	for s in InventoryManager.equipment.slots:
		s.item_changed.connect(_on_item_changed)
	player_data.changed.connect(_on_item_changed)
	_on_item_changed()

func _on_item_changed():
	lbl_atk.text = str(player_data.get_stat(GameEnums.STAT.ATK))
	lbl_move_speed.text = str(player_data.get_stat(GameEnums.STAT.MOVE_SPEED))
	lbl_def.text = str(player_data.get_stat(GameEnums.STAT.DEF))
	lbl_crit_rate.text = str(player_data.get_stat(GameEnums.STAT.CRIT_RATE))
	lbl_crit_damage.text = str(player_data.get_stat(GameEnums.STAT.CRIT_DAMAGE))
	lbl_life_point.text = str(player_data.get_stat(GameEnums.STAT.LIFE_POINT))

func _on_inventory_opened():
	show()

func _on_inventory_closed():
	hide()
