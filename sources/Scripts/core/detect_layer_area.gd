extends Area2D
class_name DetectLayerArea

@onready var parent : PlayableCharacter = get_parent()

var current_layer_index : int 
var current_collision_value : int

func _on_area_entered(area):
	if area is ChangeLayerArea:
		current_layer_index = parent.get_z_index()
		current_collision_value = (current_layer_index + 1) / 2
		parent.set_collision_layer_value(current_collision_value, false)
		parent.set_collision_mask_value(current_collision_value, false)
		parent.hitbox.set_collision_mask_value(current_collision_value + 16, false)
		parent.damage_area.set_collision_layer_value(current_collision_value + 20, false)
		
		parent.set_z_index(area.layer_index)
		current_collision_value = (area.layer_index + 1) / 2
		parent.set_collision_layer_value(current_collision_value, true)
		parent.set_collision_mask_value(current_collision_value, true)
		parent.hitbox.set_collision_mask_value(current_collision_value + 16, true)
		parent.damage_area.set_collision_layer_value(current_collision_value + 20, true)
