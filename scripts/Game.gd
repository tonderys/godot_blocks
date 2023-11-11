extends Node
class_name Game 

onready var board_node = get_node("BoardNode")
var sounds = load("res://scenes/Sounds.tscn").instance()
const FloatingText = preload("res://scenes/FloatingText.tscn")

const tick : float = 0.2/Global.rows
const rowsToNextLevel = 30
var action_factory
var level = 1
var elapsedTime = 0.0
var tillNextLevel = rowsToNextLevel
var input_handler = null
var removes = 0
var paused = false

func _init():
	Global.score = 0
	action_factory = ActionFactory.new()
	
func _ready():
	board_node.connect("squares_removed", self, "squares_removed")
	board_node.connect("add_square", get_node("Sounds"), "play_add_square")
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
		game_over()
	elapsedTime += _delta
	while elapsedTime > tick:
		elapsedTime -= tick
		board_node.elevate_loose_rows()

func game_over():
	var score_data = load("res://scripts/ScoreData.gd").new(Global.highscore_file_path)
	if score_data.is_good_enough(Global.score):
		get_tree().change_scene("res://scenes/NamePrompt.tscn")
	else:
		get_tree().change_scene("res://scenes/Summary.tscn")

func display_at(text, position, remove_others = false):
	var score = FloatingText.instance()
	score.init(text, position)
	if remove_others:
		for child in get_node("GUI/popups").get_children():
			child.free()
	get_node("GUI/popups").add_child(score)
	
func _input(event):
	input_handler.interact(event)

func on_timeout():
	get_node("Sounds/addRow").play()
	tillNextLevel -= 1
	board_node.add_top_row()

func squares_removed(squares):
	get_node("Sounds/removeRow").play()
	var score = add_points(squares.size());
	display_at("+%s" % score, Vector2(Global.width / 2, Global.height / 2))
	
func add_points(squares: int, multiplier : int = 1):
	print("%s [squares_removed] with multiplier:%s on lvl:%s" % [squares, multiplier, level])
	var score_delta = squares * level * multiplier
	Global.score += squares * level * multiplier
	get_node("GUI/Score").text = "Score:%s" % Global.score
	return score_delta

func modify_available_removes(amount):
	removes = clamp(removes + amount, 0, 5)
	get_node("removes").get_node("amount").text = "%s" % removes
	
func level_up():
	get_node("Sounds/lvlUp").play()
	var score = add_points(Global.columns, tillNextLevel)
	display_at("lvl UP! +%s" % score,
				Vector2(Global.width / 2, Global.height/2),
				true)
	level += 1
	tillNextLevel = rowsToNextLevel
	get_node("GUI/Multipier").text = "x%s" % level
	Global.shorten_timer(get_node("Timer/remaining"), 0.9)

func toggle_pause():
	paused = not paused
	get_tree().paused = paused
	get_node("GUI/Pause/overlay").visible = paused

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		get_node("GUI/Pause/overlay/PauseMenu").back_pressed()
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_node("GUI/Pause/overlay/PauseMenu").back_pressed()
