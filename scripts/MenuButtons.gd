extends Node2D

func start_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")
	
func quit_pressed():
	get_tree().quit()
