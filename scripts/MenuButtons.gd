extends Node2D

func StartPressed():
	get_tree().change_scene("res://scenes/Game.tscn")
	
func quitPressed():
	get_tree().quit()
