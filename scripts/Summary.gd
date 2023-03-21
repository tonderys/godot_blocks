extends Node2D

const Scoreboard = preload("res://scripts/Scoreboard.gd")

var scoreboard = Scoreboard.new()

func _ready():
	var hiScore = max(Global.score, scoreboard.score_data.get_high_score())
	
	get_node("UI/Score").text = "Score:%s" % Global.score
	get_node("UI/HiScore").text = "Best:%s" % hiScore
