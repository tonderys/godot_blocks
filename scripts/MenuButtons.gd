extends Node

enum Action{NONE = 0, BACK = 1, RESTART = 2}
var action = Action.NONE

func start_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/Game.tscn")
	
func quit_pressed():
	get_tree().paused = false
	get_tree().quit()

func back_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/Menu.tscn")

func ensure(text, act):
	$menu.visible = false
	var prompt = get_node("ensure prompt")
	prompt.visible = true
	prompt.get_node("option").text = text
	action = act

func yes_pressed():
	if action == Action.RESTART:
		start_pressed()
	if action == Action.BACK:
		back_pressed()

func restore_pause_menu():
	var prompt = get_node("ensure prompt")
	prompt.visible = false
	$menu.visible = true
	action = Action.NONE

func toggle_pause():
	get_owner().toggle_pause()

func settings_pressed():
	get_tree().change_scene_to(Settings)

func highscores_pressed():
	get_tree().change_scene("res://scenes/Scoreboard.tscn")
