extends Node
class_name Scoreboard

const entries_amount = 9
var score_data

func _init():
	score_data = load("res://scripts/ScoreData.gd").new(Global.highscore_file_path)
	
func _ready():
	var i = 0
	for place in get_node("Scores").get_children():
		var record = score_data.get_record_at(i)
		if len(record) == 0:
			return
		else:
			var player_name = record[0]
			var player_score = record[1]
			place.text = "%s. %s %s"%[(i+1), player_name, player_score]
			i += 1

func save(name, score):
	score_data.save(name, score)
