extends Node2D

const Square = preload("res://scenes/Square.tscn")
var rng = RandomNumberGenerator.new()

var squares = Array()

func randomIndices() -> Array:
	var indices = [0,1,2,3,4,5,6,7,8,9]
	indices.shuffle()
	indices.resize(rng.randi_range(2, 9))
	return indices

func _init(height: int):
	rng.randomize()
	var indices = randomIndices()
	for i in indices:
		var square = Square.instance()
		square.get_node("body").rect_size = Vector2(58,58)
		square.get_node("body").rect_position = Vector2(i * 58, height * 58)
		add_child(square)
