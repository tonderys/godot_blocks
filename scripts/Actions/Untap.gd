extends Action
class_name Untap

func init(board, game, pos):
	.init(board, game, pos)
	board_node.highlight.indicate_add()

func interact(event):
	if ((event is InputEventMouseButton or event is InputEventScreenTouch)
		and not event.pressed):
		board_node.add_loose_row(position.x)
		board_node.unhighlight()
		state_transition("tap")
