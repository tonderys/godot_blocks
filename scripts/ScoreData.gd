extends Node
class_name ScoreData

const entries_amount = 9

var file_path
var score_file = File.new()

var score_data = {"recent_name": "input name",
				  "scoreboard": [],
				  "high_score": 0}

func _init(path):
	file_path = path
	if not score_file.file_exists(file_path):
		_save_file()
	else:
		_read_file()

func _save_file():
	score_file.open(file_path, File.WRITE)
	score_file.store_var(score_data)
	score_file.close()

func _read_file():
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
	_save_file()

func get_record_at(place):
	if len(score_data.scoreboard) > place:
		return score_data.scoreboard[place]
	else:
		return []

func get_score_at(place):
	return get_record_at(place)[1]

func is_good_enough(score):
	return score > get_score_at(entries_amount - 1)
	
func get_high_score():
	return score_data.high_score
	
func get_recent_name():
	return score_data.recent_name
