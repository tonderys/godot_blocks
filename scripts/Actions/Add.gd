extends Action
class_name Add

func init(board, game, pos):
	.init(board, game, pos)
	board_node.highlight.indicate_add()

func move(new_position):
	var delta = new_position.y - position.y
	if (delta > Global.square_side) and game_node.removes > 0:
		state_transition("remove")
	elif (delta > 0):
		state_transition("release")

func interact(new_position):
	board_node.add_loose_row(position.x)
	board_node.unhighlight()
	state_transition("press")
