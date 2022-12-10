extends Action
class_name Remove

var delta

func init(board, game, pos):
	.init(board, game, pos)
	board_node.highlight.indicate_remove()

func radius():
	return min(self.delta, game_node.removes) - 1

func move(new_position):
	var delta = (new_position.y - position.y) / Global.square_side
	if (delta < -1):
		state_transition("add")
	elif (delta < 0) :
		state_transition("release")
	elif self.delta != delta / 2:
		self.delta = delta / 2
		board_node.highlight.indicate_remove(radius())

func interact(new_position):
	board_node.remove_blocks_from_column(position.x, radius())
	board_node.unhighlight()
	state_transition("press")
