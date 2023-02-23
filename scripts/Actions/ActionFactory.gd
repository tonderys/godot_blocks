class_name ActionFactory

var actions

func _init():
	actions = {
		"tap":Tap,
		"untap":Untap
	}
	
func get_action(name):
	if actions.has(name):
		return actions.get(name).new()
	printerr("No action ", name, " in ActionFactory")
