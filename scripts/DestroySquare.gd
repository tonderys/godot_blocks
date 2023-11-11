extends Node2D
class_name DestroySquare

onready var emitter = get_node("destroy")

var color: Color

func split_square():
	var slices = Global.rng.randi_range(2, 5)
	emitter.scale_amount = Global.square_side / slices
	emitter.amount = slices * slices
	
func init(c: Color, p: Vector2) -> void:
	position = p
	color = c
	
func _ready():
	split_square()
	emitter.color = color
	emitter.emitting = true
