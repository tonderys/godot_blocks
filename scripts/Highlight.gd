extends Node2D
class_name Highlight

const blue : float = 0.0
const transparency : float = 0.5

const width = Global.square_side
const max_height = (Global.rows + 1) * Global.square_side

var highlighted_column
var board_node
var game_node

func init(column, board):
	highlighted_column = column
	board_node = board
	update()

func _process(_delta):
	update()
	
func update():
	set_position(Vector2(highlighted_column * Global.square_side, pos_y()))
	set_size(Vector2(width, max_height - pos_y()))
	
func pos_y():
	return (board_node.get_lowest_square_in(highlighted_column) + 1) * Global.square_side

func _ready():
	get_node("column").color = Color(0, 0, blue, transparency)
	
func indicate_remove():
	get_node("column").color = Color(1.0, 0.0, blue, transparency)
	
func indicate_add():
	get_node("column").color = Color(0.0 ,1.0 , blue, transparency)

func indicate_no_action():
	get_node("column").color = Color(0.0 ,0.0 , blue, transparency)

func set_position(position: Vector2):
	get_node("column").rect_position = position

func set_size(size: Vector2):
	get_node("column").rect_size = size
