extends TextureRect
class_name Item

@export var id : String
@export var item_name : String
@export var equipment_type : GameEnums.EQUIPMENT_TYPE

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE

