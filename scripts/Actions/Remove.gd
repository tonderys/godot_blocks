extends Action
class_name Remove

var radius

func init(board, game, pos):
	.init(board, game, pos)
	board_node.highlight.indicate_remove()

func move(new_position):
	var delta = (new_position.y - position.y) / Global.square_side
	if (delta < -1):
		state_transition("add")
	elif (delta < 0) :
		state_transition("release")
	elif radius != delta / 2:
		radius = delta / 2
		board_node.highlight.indicate_remove(min(radius, game_node.removes) - 1)

func interact(new_position):
	board_node.remove_block_from_column(position.x)
	board_node.unhighlight()
	state_transition("press")
