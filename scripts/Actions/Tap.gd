extends Action
class_name Tap

func interact(event):
	if is_valid(event) and event.pressed and is_on_board(event):
		board_node.highlight(event.position.x)
		self.position = event.position
		state_transition("untap")
