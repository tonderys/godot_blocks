extends Node2D
class_name Square

func rand() -> float:
	return Global.rng.randf_range(0.0, 0.7)

func _get_random_color() -> Color:
	return Color(rand(), rand(), rand())

func _ready():
	get_node("body").color = _get_random_color()
