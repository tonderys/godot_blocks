extends Node
class_name Action

var board_node
var game_node
var position

func init(board, game, pos):
	board_node = board
	game_node = game
	position = pos
	
func state_transition(new_state_name):
	game_node.change_action_to(new_state_name, board_node, game_node, position)
	
func move(_position):
	pass

func interact(_position):
	pass

func is_valid(event):
	return event is InputEventMouseButton or event is InputEventScreenTouch
	
func is_on_board(event):
	return board_node.get_node("Area3D").get_global_rect().has_point(event.position)
