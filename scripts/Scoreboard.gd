extends Node
class_name Scoreboard

const entries_amount = 9
var score_data

func _init():
	score_data = load("res://scripts/ScoreData.gd").new(Global.highscore_file_path)
	
func _ready():
	var i = 0
	for place in get_node("records").get_children():
		var record = score_data.get_record_at(i)
		if len(record) == 0:
			return
		else:
			var player_name = record[0]
			var player_score = record[1]

			i += 1
			place.get_node("place").text = "%s.%s"%[i, player_name]
			place.get_node("score").text = "%s"%player_score

func save(name, score):
	score_data.save(name, score)

func _ensure_deletion():
	if get_tree().change_scene("res://scenes/EnsureDeletion.tscn") != OK:
		print("Can't open ensure deletion scene")


func show_global_scores():
	get_tree().change_scene("res://scenes/GlobalScoreboard.tscn")
