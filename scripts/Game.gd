extends Node2D

onready var boardNode = get_node("BoardNode")

var elapsedTime = 0.0
const tick : float = 1.0/60
var level = 1
const rowsToNextLevel = 30
var tillNextLevel = rowsToNextLevel
var clickStartPosY = null
var input_handler = null

func _init():
	Global.score = 0
	
func _ready():
	boardNode.connect("squares_removed", self, "add_points")
	input_handler = Mouse_press_release.new(boardNode)
	
func _process(_delta: float) -> void:
	if boardNode.is_empty():
		level_up()
		boardNode.reset()
	elif tillNextLevel <= 0:
		level_up()
	elif boardNode.is_full():
		get_tree().change_scene("res://scenes/Summary.tscn")

	elapsedTime += _delta
	while elapsedTime > tick:
		elapsedTime -= tick
		boardNode.elevateLooseRows()

func _input(event):
	if event is InputEventMouseMotion:
		input_handler.move(event)
	if event is InputEventMouseButton:
		if event.pressed:
			input_handler.interaction_on(event)
		else:
			input_handler.interaction_off(event)

func on_timeout():
	tillNextLevel -= 1
	boardNode.addTopRow()

func add_points(squares: int, multiplier : int = 1):
	print("signal received ", squares, multiplier)
	Global.score += squares * level * multiplier
	get_node("Score").text = "Score:%s" % Global.score

func level_up():
	add_points(Global.columns, tillNextLevel)
	tillNextLevel = rowsToNextLevel
	level += 1
	get_node("Multipier").text = "x%s" % level
	Global.shorten_timer(get_node("Timer/remaining"), 0.9)
