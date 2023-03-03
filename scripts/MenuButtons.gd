extends Node

func start_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/Game.tscn")
	
func quit_pressed():
	get_tree().paused = false
	get_tree().quit()

func back_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/Menu.tscn")

func toggle_pause():
	get_owner().toggle_pause()

func settings_pressed():
	get_tree().change_scene("res://scenes/Settings.tscn")

func highscores_pressed():
	get_tree().change_scene("res://scenes/Scoreboard.tscn")
