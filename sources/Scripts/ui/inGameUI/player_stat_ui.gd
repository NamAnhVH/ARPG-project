extends NinePatchRect

@export var player_data : PlayerData

@onready var lbl_level : Label = $StatContainer/VBoxContainer/Level/Stat
@onready var lbl_atk : Label = $StatContainer/VBoxContainer/AttackDamage/Stat
@onready var lbl_move_speed : Label = $StatContainer/VBoxContainer/MoveSpeed/Stat
@onready var lbl_def : Label = $StatContainer/VBoxContainer/Defence/Stat
@onready var lbl_crit_rate : Label = $StatContainer/VBoxContainer/CritRate/Stat
@onready var lbl_crit_damage : Label = $StatContainer/VBoxContainer/CritDamage/Stat
@onready var lbl_knockback : Label = $StatContainer/VBoxContainer/Knockback/Stat
@onready var lbl_life_point : Label = $StatContainer/VBoxContainer/LifePoint/Stat

func _ready():
	SignalManager.inventory_opened.connect(show)
	SignalManager.inventory_closed.connect(hide)
	SignalManager.update_stat.connect(_on_update_stat)
	SignalManager.level_up.connect(_on_level_up)
	_on_level_up()
	_on_update_stat()

func _on_level_up():
	lbl_level.text = str(player_data.level)
	_on_update_stat()

func _on_update_stat():
	lbl_atk.text = str(player_data.get_stat(GameEnums.STAT.ATK))
	lbl_move_speed.text = str(player_data.get_stat(GameEnums.STAT.MOVE_SPEED)) + "%"
	lbl_def.text = str(player_data.get_stat(GameEnums.STAT.DEF))
	lbl_crit_rate.text = str(player_data.get_stat(GameEnums.STAT.CRIT_RATE)) + "%"
	lbl_crit_damage.text = str(player_data.get_stat(GameEnums.STAT.CRIT_DAMAGE)) + "%"
	lbl_knockback.text = str(player_data.get_stat(GameEnums.STAT.KNOCKBACK))
	lbl_life_point.text = str(player_data.get_stat(GameEnums.STAT.LIFE_POINT))
