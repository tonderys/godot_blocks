extends Node2D

const highscore_file_path = "user://highscore.res"

const columns: int = 7
const width = 580 - (580 % columns)
const square_side: int = width / columns
const height = 870
const rows: int = (height - square_side) / square_side

func background_color():
	return Color("cdffc7") if Settings.data.color else Color("cdcdcd")

func till_next_level_color():
	return Color("ff0000") if Settings.data.color else Color("363636")
	
func timer_color():
	return Color("0004ff") if Settings.data.color else Color("151515")

func highlight_color():
	return Color("00ff00") if Settings.data.color else Color("b8b8b8")

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

func random_coordinates():
	var x = rng.randi_range(100, width - 100)
	var y = rng.randi_range(100, height - 100)
	return Vector2(x,y)

func rand(from: float, to: float) -> float:
	return Global.rng.randf_range(from, to)

func get_random_color() -> Color:
	if Settings.data.color:
		return Color(rand(0.0, 0.7), rand(0.0, 0.7), rand(0.0, 0.7))
	else:
		var shade = rand(0.0, 0.7)
		return Color(shade, shade, shade)
