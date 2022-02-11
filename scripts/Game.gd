extends Node2D

var score = 0

func _input(event):
	if event is InputEventMouseButton:
		var column = int(event.position.x / 58)
		if event.is_pressed():
			print("pressed at ", column)
		else:
			get_node("BoardNode").input(column)

func _process(_delta: float) -> void:
	get_node("Label").text = "Score:%s" % score

func addPoints(points: int):
	score += points
