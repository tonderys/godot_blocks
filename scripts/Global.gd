extends Node2D

var score : int = 0
var rng = RandomNumberGenerator.new()
const square_side: int = 58
const columns: int = 10
const rows: int = 14

func _init():
	rng.randomize()

func shorten_timer(timer: Node, modifier: float) -> void:
		timer.wait_time *= modifier
		timer.stop()
		timer.start()

func random_indices() -> Array:
	var indices = []
	for i in range(columns):
		indices.push_back(i)
	indices.shuffle()
	indices.resize(rng.randi_range(2, columns - 1))
	return indices
