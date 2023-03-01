extends Node
class_name Scoreboard

var score_file = File.new()
var file_path = "user://highscore.res"

var score_data = {"recent_name": "input name",
				  "scoreboard": {},
				  "high_score": 0}

func create_output_file():
	score_file.open(file_path, File.WRITE)
	score_file.store_var(score_data)
	score_file.close()

func _init():
	if not score_file.file_exists(file_path):
		create_output_file()

func save(name, score):
	score_data.recent_name = name
	score_data.high_score = max(score, score_data.high_score)
	score_data.scoreboard[name] = score
	
	score_file.open(file_path, File.WRITE)
	score_file.store_var(score_data)
	score_file.close()
	
func read():
	score_file.open(file_path, File.READ)
	score_data = score_file.get_var()
	score_file.close()
	
	return score_data
