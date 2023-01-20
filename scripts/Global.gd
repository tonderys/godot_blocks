extends Node2D

const width = 580
const height = 870
var score : int = 0
var rng = RandomNumberGenerator.new()
const columns: int = 8
const square_side: int = width / columns
const rows: int = (height - square_side) / square_side

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
