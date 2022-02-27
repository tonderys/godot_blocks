extends Node2D

var score : int = 0
var rng = RandomNumberGenerator.new()

func _init():
	rng.randomize()

func shortenTimer(timer: Node, modifier: float) -> void:
		timer.wait_time *= 0.9
		timer.stop()
		timer.start()

func randomIndices() -> Array:
	var indices = [0,1,2,3,4,5,6,7,8,9]
	indices.shuffle()
	indices.resize(rng.randi_range(2, 9))
	return indices
