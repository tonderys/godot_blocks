extends Node2D

func _ready():
	get_node("UI/Score").text = "%s" % Global.score

func quitPressed():
	get_tree().quit()