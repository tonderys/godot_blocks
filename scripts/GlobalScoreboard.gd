extends Node2D
class_name GlobalScoreboard

const highscore_file_path = "user://global_score.res"

var highlight_name
var highlight_score

func set_updated():
	get_node("State/waiting").visible = false
	get_node("State/refresh").visible = true

func set_waiting():
	get_node("State/waiting").visible = true
	get_node("State/refresh").visible = false

func _ready():
	refresh_data()

func score_received():
	set_updated()
	get_data_from_database()

func get_data_from_database():
	var local_best_found = false
	var score_data = load("res://scripts/ScoreData.gd").new(Global.highscore_file_path)
	var local_best = score_data.get_record_at(0)
	if(local_best):
		highlight_name = local_best[0]
		highlight_score = local_best[1]
	
	var i = 0;
	for place in get_node("records").get_children():
		if i >= len(SilentWolf.Scores.scores):
			return
		var record = SilentWolf.Scores.scores[i];
		if len(record) == 0:
			return
		else:
			i += 1
			if(record.player_name == highlight_name && record.score == highlight_score):
				local_best_found = true
				set_record_color(place, Color(0,0,1,1))
			
			place.get_node("place").text = "%s.%s"%[i,record.player_name]
			place.get_node("score").text = "%s"%record.score
	if not local_best_found:
		get_node("local").visible = true
		set_record_color(get_node("local/score"), Color(0,0,1,1))
		
		await SilentWolf.Scores.get_score_position(highlight_score).sw_position_received
		var position = SilentWolf.Scores.position
		get_node("local/score/place").text = "%s.%s"%[(position - 1), highlight_name]
		get_node("local/score/score").text = "%s"%highlight_score
		

func set_record_color(record, color):
	record.get_node("place").add_theme_color_override("font_color", color)
	record.get_node("score").add_theme_color_override("font_color", color)
	
func remove_theme_color_override():
	for place in get_node("records").get_children():
		set_record_color(place, Color(0,0,0,1))
		
func refresh_data():
	set_waiting()
	remove_theme_color_override()
	await SilentWolf.Scores.get_scores(get_node("records").get_child_count())
	score_received()
