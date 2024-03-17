extends TextureProgressBar

@export_node_path var label_path : NodePath
@onready var label : Label = get_node(label_path)

func set_data(usable: ItemUsable):
	usable.cooldown_tick.connect(_on_cooldown_tick)
	max_value = usable.cooldown

func _on_cooldown_tick(remaining):
	value = remaining
	label.text = "%0.1f" % remaining
	
	if remaining <= 0:
		queue_free()
