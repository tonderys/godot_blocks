extends Node2D

var scoreboard = load("res://scripts/Scoreboard.gd").new()

func _ready():
	var hiScore = max(Global.score, scoreboard.score_data.get_high_score())
	
	get_node("UI/Score").text = "Score:%s" % Global.score
	get_node("UI/HiScore").text = "Best:%s" % hiScore
	
	get_node("UI/Buttons/Back").disabled = true;
	
func _enable_back_button():
	get_node("UI/Buttons/Back").disabled = false;
