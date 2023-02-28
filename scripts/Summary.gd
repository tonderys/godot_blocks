extends Node2D

func _ready():
	get_node("UI/Score").text = "Score:%s" % Global.score
	get_node("UI/HiScore").text = "Best:%s" % Global.score
