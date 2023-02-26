extends Node

onready var board_node = get_node("BoardNode")

const tick : float = 0.2/Global.rows
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
	board_node.connect("squares_removed", self, "squares_removed")
	change_action_to("tap", board_node, self, Vector2(0,0))
	
func change_action_to(name, board, game, pos):
	input_handler = self.action_factory.get_action(name)
	input_handler.init(board, game, pos)

func _process(_delta: float) -> void:
	if board_node.is_empty():
		level_up()
		board_node.reset()
	elif tillNextLevel <= 0:
		level_up()
	elif board_node.is_full():
		get_tree().change_scene("res://scenes/Summary.tscn")

	elapsedTime += _delta
	while elapsedTime > tick:
		elapsedTime -= tick
		board_node.elevate_loose_rows()

func _input(event):
	input_handler.interact(event)

func on_timeout():
	get_node("Sounds").get_node("addRow").play()
	tillNextLevel -= 1
	board_node.add_top_row()

func squares_removed(squares):
	get_node("Sounds").get_node("removeRow").play()
	add_points(squares)

func add_points(squares: int, multiplier : int = 1):
	print("%s [squares_removed] with multiplier:%s on lvl:%s" % [squares, multiplier, level])
	Global.score += squares * level * multiplier
	get_node("Score").text = "Score:%s" % Global.score

func modify_available_removes(amount):
	removes = clamp(removes + amount, 0, 5)
	get_node("removes").get_node("amount").text = "%s" % removes
	
func level_up():
	get_node("Sounds").get_node("lvlUp").play()
	add_points(Global.columns, tillNextLevel)
	tillNextLevel = rowsToNextLevel
	level += 1
	get_node("Multipier").text = "x%s" % level
	Global.shorten_timer(get_node("Timer/remaining"), 0.9)
