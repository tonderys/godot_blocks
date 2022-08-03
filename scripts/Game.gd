extends Node2D

const Highlight = preload("res://scenes/Highlight.tscn")
onready var boardNode = get_node("BoardNode")

var elapsedTime = 0.0
const tick : float = 1.0/60
var level = 1
const rowsToNextLevel = 30
var tillNextLevel = rowsToNextLevel
var clickStartPosY = null

func _init():
	Global.score = 0
	
func _process(_delta: float) -> void:
	if boardNode.isEmpty():
		levelUp()
		boardNode.reset()
	elif tillNextLevel <= 0:
		levelUp()
	elif boardNode.isFull():
		get_tree().change_scene("res://scenes/Summary.tscn")

	elapsedTime += _delta
	while elapsedTime > tick:
		elapsedTime -= tick
		boardNode.elevateLooseRows()

func _input(event):
	if event is InputEventMouseMotion:
		if clickStartPosY != null:
			boardNode.highlight.turn_red((event.position.y - clickStartPosY)/58)
	if event is InputEventMouseButton:
		if event.pressed: 
			clickStartPosY = event.position.y
			boardNode.highlight(event.position.x)
		else:
			boardNode.handle_click(event.position.x, event.position.y > clickStartPosY + 58)
			clickStartPosY = null

func onTimeout():
	tillNextLevel -= 1
	boardNode.addTopRow()

func addPoints(multiplier: int):
	Global.score += 10 * level * multiplier
	get_node("Score").text = "Score:%s" % Global.score

func levelUp():
	addPoints(tillNextLevel)
	tillNextLevel = rowsToNextLevel
	level += 1
	get_node("Multipier").text = "x%s" % level
	Global.shortenTimer(get_node("Timer/remaining"), 0.9)
