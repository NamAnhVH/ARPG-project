extends Label

var quantity : set = set_quantity

func set_quantity(value):
	text = str(value)
	visible = value > 1
