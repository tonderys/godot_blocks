extends Action
class_name Tap

func interact(position):
	board_node.highlight(position.x)
	self.position = position
	state_transition("untap")
