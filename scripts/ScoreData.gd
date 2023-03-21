extends Node
class_name ScoreData

const entries_amount = 100

var score_file = File.new()
var file_path = "user://highscore.res"

var score_data = {"recent_name": "input name",
				  "scoreboard": [],
				  "high_score": 0}

func _init():
	if not score_file.file_exists(file_path):
		save_file()
	else:
		read_file()

func save_file():
	score_file.open(file_path, File.WRITE)
	score_file.store_var(score_data)
	score_file.close()

func read_file():
	score_file.open(file_path, File.READ)
	score_data = score_file.get_var()
	score_file.close()

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
	if len(score_data.scoreboard) > entries_amount:
		score_data.scoreboard.resize(entries_amount)

func get_score_at(place):
	if len(score_data.scoreboard) >= place:
		return score_data.scoreboard[place]
	else:
		return []

func get_high_score():
	return score_data.high_score
	
func get_recent_name():
	return score_data.recent_name
