extends Node2D

var board = preload("res://scenes/Board.tscn")
onready var boardNode = get_node("BoardNode")

var elapsedTime = 0.0
const tick : float = 1.0/60
var level = 1
var rowsToNextLevel = 100

func _init():
	Global.score = 0

func _process(_delta: float) -> void:
	if boardNode.isEmpty():
		rowsToNextLevel = 100
		level += 1
		get_node("Multipier").text = "x%s" % level
		Global.shortenTimer(get_node("Timer/remaining"), 0.9)
		boardNode.reset()
	elif rowsToNextLevel <= 0:
		rowsToNextLevel = 100
		level += 1
		get_node("Multipier").text = "x%s" % level
		Global.shortenTimer(get_node("Timer/remaining"), 0.9)
	elif boardNode.isFull():
		get_tree().change_scene("res://scenes/Summary.tscn")

	elapsedTime += _delta
	while elapsedTime > tick:
		elapsedTime -= tick
		boardNode.elevateLooseRows()

func _input(event):
	if event is InputEventMouseButton:
		var column = int(event.position.x / 58)
		if event.is_pressed():
			pass
		else:
			boardNode.input(column)

func onTimeout():
	rowsToNextLevel -= 1
	boardNode.addTopRow()

func addPoints(multiplier: int):
	Global.score += 10 * level * multiplier
	get_node("Score").text = "Score:%s" % Global.score
