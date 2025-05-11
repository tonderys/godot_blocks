extends Node2D
class_name EnsureDeletion

func _delete_score_file():
	DirAccess.remove_absolute(Global.highscore_file_path)
	_change_back_to_scoreboard()

func _change_back_to_scoreboard():
	if get_tree().change_scene_to_file("res://scenes/Scoreboard.tscn") != OK:
		print("Can't open scoreboard scene")
