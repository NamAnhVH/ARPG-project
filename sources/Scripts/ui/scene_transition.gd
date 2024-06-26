extends CanvasLayer

@onready var texture : TextureRect = $TextureRect
@onready var animation : AnimationPlayer = $AnimationPlayer

var map_id
var location
var next_z_index

func _ready():
	SignalManager.scene_transition_fade_out.connect(_on_scene_transition_fade_out)
	SignalManager.scene_transition_fade_in.connect(_on_scene_transition_fade_in)
	texture.visible = false

func _on_scene_transition_fade_out(_map_id, _location, _next_z_index):
	animation.queue("fade_out")
	map_id = _map_id
	location = _location
	next_z_index = _next_z_index
	animation.queue("fade_in")

func _on_scene_transition_fade_in():
	animation.queue("fade_in")

func _on_fade_out_started():
	Global.paused = true

func _on_fade_out_finished():
	if map_id == "dungeon_main":
		SignalManager.generate_dungeon.emit()
	SignalManager.change_world.emit(map_id, location, next_z_index)
	SignalManager.set_player.emit()

func _on_fade_in_started():
	Global.paused = true

func _on_fade_in_finished():
	Global.paused = false
	SignalManager.scene_transition_fade_in_finished.emit()
