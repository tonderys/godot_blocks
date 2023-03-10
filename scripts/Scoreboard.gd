extends Node
class_name Scoreboard

const entries_amount = 9

var score_file = File.new()
var file_path = "user://highscore.res"

var score_data = {"recent_name": "input name",
				  "scoreboard": [],
				  "high_score": 0}

func save_file():
	score_file.open(file_path, File.WRITE)
	score_file.store_var(score_data)
	score_file.close()

func _init():
	if not score_file.file_exists(file_path):
		save_file()
	else:
		read_file()
	
func _ready():
	var scores = score_data["scoreboard"]
	var i = 0
	for place in get_node("Scores").get_children():
		if i >= len(scores):
			return
		var player_name = scores[i][0]
		var player_score = scores[i][1]
		place.text = "%s. %s %s"%[(i+1), player_name, player_score]
		i += 1


func save(name, score):
	score_data.recent_name = name
	score_data.high_score = max(score, score_data.high_score)
	
	var entry = [name, score]
	for i in range(entries_amount):
		if len(score_data.scoreboard) == i:
			score_data.scoreboard.append(entry)
			break
		elif score_data.scoreboard[i][1] < score:
			score_data.scoreboard.insert(i, entry)
			break
	save_file()
	
func read_file():
	score_file.open(file_path, File.READ)
	score_data = score_file.get_var()
	score_file.close()
	
func read():
	return score_data
