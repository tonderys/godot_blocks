extends Node2D

const columns: int = 7
const width = 580 - (580 % columns)
const square_side: int = width / columns
const height = 870
const rows: int = (height - square_side) / square_side

var score : int = 0

func shorten_timer(timer: Node, modifier: float) -> void:
		timer.wait_time *= modifier
		timer.stop()
		timer.start()

var rng = RandomNumberGenerator.new()
	
func _init():
	rng.randomize()

func random_indices() -> Array:
	var indices = []
	for i in range(columns):
		indices.push_back(i)
	indices.shuffle()
	indices.resize(rng.randi_range(2, columns - 1))
	return indices
