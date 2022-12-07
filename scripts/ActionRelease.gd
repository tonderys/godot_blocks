extends Action
class_name Release

func move(new_position):
	var delta = new_position.y - position.y
	if (delta < -Global.square_side):
		board_node.highlight.indicate_add()
	elif (delta > Global.square_side) and game_node.removes > 0:
			board_node.highlight.indicate_remove()
	else:
		board_node.highlight.indicate_no_action()

func interact(new_position):
	if (new_position.y - position.y < -Global.square_side):
		board_node.add_loose_row(position.x)
	if (new_position.y - position.y > Global.square_side) and game_node.removes > 0:
		board_node.remove_block_from_column(position.x)
	board_node.unhighlight()
	position = null
	
	state_transition("press")
