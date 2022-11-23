extends Node
class_name Mouse_press_release

var clickStartPosY = null
var board_node

func _init(board):
	board_node = board

func move(event):
	if clickStartPosY != null:
		board_node.highlight.turn_red((event.position.y - clickStartPosY)/58)

func interaction_on(event):
	self.clickStartPosY = event.position.y
	board_node.highlight(event.position.x)
	
func interaction_off(event):
	board_node.handle_click(event.position.x, event.position.y > clickStartPosY + 58) #ToDo:click_off(pos)
	clickStartPosY = null

