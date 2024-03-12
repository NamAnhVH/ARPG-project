extends TextureRect
class_name Item

@export var id : String
@export var item_name : String

func is_pick_up():
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func is_put_down():
	mouse_filter = Control.MOUSE_FILTER_PASS

