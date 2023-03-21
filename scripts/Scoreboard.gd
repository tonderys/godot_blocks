extends Node
class_name Scoreboard

const ScoreData = preload("res://scripts/ScoreData.gd")
const entries_amount = 9

var score_data

func _init():
	score_data = ScoreData.new()
	
func _ready():
	var i = 0
	for place in get_node("Scores").get_children():
		var score = score_data.get_score_at(i)
		if len(score) == 0:
			return
		else:
			var player_name = score[0]
			var player_score = score[1]
			place.text = "%s. %s %s"%[(i+1), player_name, player_score]
			i += 1

func save(name, score):
	score_data.save(name, score)
