extends Node2D

const Scoreboard = preload("res://scripts/Scoreboard.gd")

var scoreboard = Scoreboard.new()

func _ready():
	var score_data = scoreboard.read()
	var hiScore = max(Global.score, score_data["high_score"])
	
	get_node("UI/Score").text = "Score:%s" % Global.score
	get_node("UI/HiScore").text = "Best:%s" % score_data["high_score"]
