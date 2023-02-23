extends Action
class_name Tap

func interact(event):
	if ((event is InputEventMouseButton or event is InputEventScreenTouch)
		and event.pressed):
		board_node.highlight(event.position.x)
		self.position = event.position
		state_transition("untap")
