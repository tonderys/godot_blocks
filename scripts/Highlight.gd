extends Node2D
class_name Highlight

const OperatingRange = preload("res://scripts/OperatingRange.gd")

const blue : float = 0.0
const transparency : float = 0.5

const max_height = (Global.rows + 1) * Global.square_side

const no_action_color = Color(0.0 ,0.0 , blue, transparency)
var add_color = Global.highlight_color()
const rmv_color = Color(1.0, 0.0, blue, transparency)

var width = Global.square_side
var delta_x = 0
var delta_y = 0
var highlighted_column
var board_node
var game_node
var operating_range

func init(column, board):
	highlighted_column = column
	board_node = board

	update()

func add_operating_range(color, radius := 0):
	if is_instance_valid(operating_range):
		operating_range.queue_free()
	operating_range = OperatingRange.new(
		Vector2(highlighted_column * Global.square_side + delta_x, pos_y()),
		radius,
		color)
	add_child(operating_range)	

func remove_operating_range():
	if is_instance_valid(operating_range):
		operating_range.queue_free()

func update():
	var tmp_y = pos_y()
	set_position(Vector2(highlighted_column * Global.square_side + delta_x, tmp_y))
	set_size(Vector2(width, max_height - tmp_y))
	if is_instance_valid(operating_range):
		operating_range.set_position(tmp_y)

func lower_by(delta):
	delta_y = delta

func pos_y():
	return (board_node.get_lowest_square_in(highlighted_column) + 1 + delta_y) * Global.square_side

func _ready():
	$column.color = Color(0, 0, blue, transparency)

func indicate_add():
	lower_by(1)
	add_operating_range(Global.highlight_color())
	$column.color = Global.highlight_color() - Color(0,0,0,0.5)
	update()

func indicate_no_action():
	remove_operating_range()
	lower_by(0)
	$column.color = no_action_color
	update()

func set_position(position: Vector2):
	$column.rect_position = position

func set_size(size: Vector2):
	$column.rect_size = size
