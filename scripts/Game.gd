extends Node2D

var board = preload("res://scenes/Board.tscn")

var score = 0
var level = 1
onready var boardNode = get_node("BoardNode")

func _process(_delta: float) -> void:
	get_node("Label").text = "Score:%s" % score
	if boardNode.isEmpty():
		level += 1
		boardNode.reset()
		
func _input(event):
	if event is InputEventMouseButton:
		var column = int(event.position.x / 58)
		if event.is_pressed():
			print("pressed at ", column)
		else:
			boardNode.input(column)

func addPoints(multiplier: int):
	score += 10 * level * multiplier
