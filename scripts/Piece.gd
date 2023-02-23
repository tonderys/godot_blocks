extends Node2D
class_name Piece

onready var piece_node = get_node("emitter")

var color: Color

func split_square():
	var slices = Global.rng.randi_range(2, 5)
	piece_node.scale_amount = Global.square_side / slices
	piece_node.amount = slices * slices
	
func init(c: Color, p: Vector2) -> void:
	position = p
	color = c
	
func _ready():
	split_square()
	piece_node.color = color
	piece_node.emitting = true
