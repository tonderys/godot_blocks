extends Node2D

var rng = RandomNumberGenerator.new()

func rand() -> float:
	return rng.randf_range(0.0, 0.7)

func getRandomColor() -> Color:
	return Color(rand(), rand(), rand())

func _init():
	rng.randomize()

func _ready():
	get_node("body").color = getRandomColor()
