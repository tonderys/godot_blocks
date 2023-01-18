class_name ActionFactory

var actions

func _init():
	actions = {
		"press": Press,
		"release": Release,
		"add":Add,
		"remove":Remove,
		"tap":Tap,
		"untap":Untap
	}
	
func get_action(name):
	if actions.has(name):
		return actions.get(name).new()
	printerr("No action ", name, " in ActionFactory")
