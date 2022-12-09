extends Action
class_name Press

func interact(position):
	board_node.highlight(position.x)
	self.position = position
	state_transition("release")
