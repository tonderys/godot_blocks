extends Node2D

var board = preload("res://scenes/Board.tscn")


var level = 1
onready var boardNode = get_node("BoardNode")

func _init():
	Global.score = 0

func _process(_delta: float) -> void:
	get_node("Score").text = "Score:%s" % Global.score
	if boardNode.isEmpty():
		level += 1
		boardNode.reset()
		Global.shortenTimer(get_node("Timer/remaining"), 0.9)
	elif boardNode.isFull():
		get_tree().change_scene("res://scenes/Summary.tscn")
		
func _input(event):
	if event is InputEventMouseButton:
		var column = int(event.position.x / 58)
		if event.is_pressed():
			print("pressed at ", column)
		else:
			boardNode.input(column)

func addPoints(multiplier: int):
	Global.score += 10 * level * multiplier
