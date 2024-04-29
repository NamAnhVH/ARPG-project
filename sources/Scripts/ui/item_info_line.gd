extends Label
class_name ItemInfoLine

func _init(value, rarity):
	text = value
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label_settings = ResourceManager.set_font(12, ResourceManager.colors[rarity])
