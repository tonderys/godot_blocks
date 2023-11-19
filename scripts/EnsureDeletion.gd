extends Node2D
class_name EnsureDeletion

func _delete_score_file():
	var dir = Directory.new()
	dir.remove(Global.highscore_file_path)
	_change_back_to_scoreboard()

func _change_back_to_scoreboard():
	get_tree().change_scene("res://scenes/Scoreboard.tscn")
