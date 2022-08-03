extends Node2D
class_name Highlight

const blue : float = 0.0
const transparency : float = 0.5

func _ready():
	get_node("body").color = Color(0,1,0,0.5)
	
func turn_red(rate: float):
	if rate < 0.0: rate = 0.0
	if rate > 1.0: rate = 1.0
	var red : float = rate
	var green: float = 1 - rate

	get_node("body").color = Color(red ,green, blue, transparency)
	
func set_position(position: Vector2):
	get_node("body").rect_position = position

func set_size(size: Vector2):
	get_node("body").rect_size = size
