extends EnemyCharacter
class_name SlimeCharacter

@export var max_active_area = 50

@onready var animation_tree = $AnimationTree
@onready var move_idle_change_time = $Timers/MoveIdleChangeTime
@onready var direction_change_time = $Timers/DirectionChangeTime

@onready var first_position = global_position
@onready var random_position = first_position: set = set_random_position, get = get_random_position

var is_moving : bool = false

func _ready():
	animation_tree.set("parameters/conditions/is_alive", is_alive)

func _physics_process(delta):
	move_and_slide()

func generate_random_position():
	var angle = randf_range(0, 2 * PI)
	var offset = Vector2(cos(angle), sin(angle)) * max_active_area
	set_random_position(first_position + offset)

func _on_is_attacked():
	animation_tree.set("parameters/conditions/is_attacked", true)

func _hurt_finished():
	animation_tree.set("parameters/conditions/is_attacked", false)

func _on_is_dead():
	is_alive = false
	animation_tree.set("parameters/conditions/is_alive", is_alive)
	animation_tree.set("parameters/conditions/is_dead", !is_alive)

func set_random_position(position):
	random_position = position

func get_random_position():
	return random_position
