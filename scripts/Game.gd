extends Node2D

onready var boardNode = get_node("BoardNode")

const tick : float = 1.0/60
const rowsToNextLevel = 30
var action_factory
var level = 1
var elapsedTime = 0.0
var tillNextLevel = rowsToNextLevel
var input_handler = null
var removes = 0

func _init():
	Global.score = 0
	action_factory = ActionFactory.new()
	
func _ready():
	boardNode.connect("squares_removed", self, "squares_removed")
	boardNode.connect("row_removed", self, "row_removed")
	change_action_to("press", boardNode, self, Vector2(0,0))

func change_action_to(name, board, game, pos):
	input_handler = self.action_factory.get_action(name)
	input_handler.init(board, game, pos)

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
		boardNode.elevate_loose_rows()

func _input(event):
	if event is InputEventMouseMotion:
		input_handler.move(event.position)
	if event is InputEventMouseButton:
		input_handler.interact(event.position)

func on_timeout():
	tillNextLevel -= 1
	boardNode.add_top_row()

func squares_removed(radius, squares):
	add_points(squares)
	modify_available_removes(- radius - 1)

func row_removed(combo):
	add_points(Global.columns, combo)
	modify_available_removes(combo - 1)

func add_points(squares: int, multiplier : int = 1):
	print("%s [squares_removed] with multiplier:%s on lvl:%s" % [squares, multiplier, level])
	Global.score += squares * level * multiplier
	get_node("Score").text = "Score:%s" % Global.score

func modify_available_removes(amount):
	removes = clamp(removes + amount, 0, 5)
	get_node("removes").get_node("amount").text = "%s" % removes
	
func level_up():
	add_points(Global.columns, tillNextLevel)
	tillNextLevel = rowsToNextLevel
	level += 1
	get_node("Multipier").text = "x%s" % level
	Global.shorten_timer(get_node("Timer/remaining"), 0.9)
