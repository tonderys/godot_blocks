extends Node2D

func _ready():
	get_node("UI/Score").text = "%s" % Global.score

func back_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")
