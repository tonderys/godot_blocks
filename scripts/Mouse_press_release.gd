extends Node
class_name Mouse_press_release

var starting_pos
var board_node
var game_node

func _init(board, game):
	board_node = board
	game_node = game

func move(position):
	if self.starting_pos != null:
		var delta = position.y - self.starting_pos.y
		if (delta < -Global.square_side):
			board_node.highlight.indicate_add()
		elif (delta > Global.square_side) and game_node.removes > 0:
				board_node.highlight.indicate_remove()
		else:
			board_node.highlight.indicate_no_action()

func interaction_on(position):
	if self.starting_pos == null:
		self.starting_pos = position
		board_node.highlight(self.starting_pos.x)
	
func interaction_off(position):
	if self.starting_pos != null:
		if (position.y - self.starting_pos.y < -Global.square_side):
			board_node.add_loose_row(starting_pos.x)
		if (position.y - self.starting_pos.y > Global.square_side) and game_node.removes > 0:
			board_node.remove_block_from_column(starting_pos.x)
		board_node.unhighlight()
		self.starting_pos = null

