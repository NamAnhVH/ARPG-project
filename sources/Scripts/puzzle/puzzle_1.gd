extends Puzzle
class_name Sokoban

@onready var targets : Node2D = $TargetPosition
@onready var num_target : int = $TargetPosition.get_child_count()

var num_current_target_success : int = 0

func _ready():
	for target : Area2D in targets.get_children():
		target.body_entered.connect(_on_target_entered)
		target.body_exited.connect(_on_target_exited)

func _on_target_entered(body):
	if body is PushableObject:
		num_current_target_success += 1
	
	if num_current_target_success == num_target:
		solved()

func _on_target_exited(body):
	if body is PushableObject:
		num_current_target_success -= 1

func solved():
	print("Puzzle Solved")
