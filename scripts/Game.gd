extends Node
class_name Game 

@onready var board_node = get_node("BoardNode")
const FloatingText = preload("res://scenes/FloatingText.tscn")

const tick : float = 0.2/Global.rows
const rowsToNextLevel = 30
const noStallMultiplier = 2
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
	board_node.connect("squares_removed", Callable(self, "squares_removed"))
	board_node.connect("add_square", Callable(Sounds, "play_add_square"))
	change_action_to("tap", board_node, self, Vector2(0,0))
	get_node("Timer").color = Global.timer_color()
	get_node("TillNextLevel").color = Global.till_next_level_color()
	
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
		if get_tree().change_scene_to_file("res://scenes/NamePrompt.tscn") != OK:
			print("Can't open name prompt scene")
	else:
		if get_tree().change_scene_to_file("res://scenes/Summary.tscn") != OK:
			print("Can't open summary scene")

func display_at(text, position, remove_others = false):
	var score = FloatingText.instantiate()
	score.init(text, position)
	if remove_others:
		for child in get_node("GUI/popups").get_children():
			child.free()
	get_node("GUI/popups").add_child(score)
	
func _input(event):
	input_handler.interact(event)

func on_timeout():
	Sounds.get_node("addRow").play()
	tillNextLevel -= 1
	board_node.add_top_row()

func squares_removed(squares):
	Sounds.get_node("removeRow").play()
	var score = add_points(squares.size());

	display_at("+%s" % score, Global.screen_center)
	
func add_points(squares: int, multiplier : int = 1):
	print("%s [squares_removed] with multiplier:%s on lvl:%s" % [squares, multiplier, level])
	var score_delta = squares * level * multiplier
	Global.score += squares * level * multiplier
	get_node("GUI/Score").text = "Score:%s" % Global.score
	return score_delta
	
func level_up():
	Sounds.get_node("lvlUp").play()
	var score = add_points(Global.columns, tillNextLevel * noStallMultiplier)
	display_at("lvl UP! +%s" % score,
				Global.screen_center,
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
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_node("GUI/Pause/overlay/PauseMenu").back_pressed()
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_node("GUI/Pause/overlay/PauseMenu").back_pressed()
