extends Area2D
class_name DetectLayerArea

@onready var parent = get_parent()

func _on_area_entered(area):
	if area is ChangeLayerArea:
		var current_layer_index : int = parent.get_z_index()
		var current_collision_value : int = (current_layer_index + 1) / 2
		var new_collision_value : int = (area.layer_index + 1) / 2
		parent.set_collision_layer_value(current_collision_value, false)
		parent.set_collision_mask_value(current_collision_value, false)
		parent.set_z_index(area.layer_index)
		parent.set_collision_layer_value(new_collision_value, true)
		parent.set_collision_mask_value(new_collision_value, true)
