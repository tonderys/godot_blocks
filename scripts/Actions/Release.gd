extends Action
class_name Release

func init(board, game, pos):
	.init(board, game, pos)
	board_node.highlight.indicate_no_action()

func move(new_position):
	var delta = new_position.y - position.y
	if (delta < -Global.square_side):
		state_transition("add")
	elif (delta > Global.square_side) and game_node.removes > 0:
		state_transition("remove")

func interact(new_position):
	board_node.unhighlight()
	state_transition("press")
