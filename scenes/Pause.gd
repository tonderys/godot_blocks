extends Control

func toggle():
	var new_state = not get_tree().paused
	get_tree().paused = new_state
	get_node("overlay").visible = new_state
