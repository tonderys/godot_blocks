extends Node
class_name Board

const Highlight = preload("res://scenes/Highlight.tscn")
const Row = preload("res://scripts/Row.gd")

var rows = Array()
var looseRows = Array()
var pieces = Array()
var highlight

signal squares_removed(amount, combo)

func _ready():
	reset()

func reset() -> void:
	rows = Array()
	for row in looseRows:
		remove_child(row)
	looseRows = Array()
	remove_unnecessary_pieces()
	
	for height in range(0, Global.rows/2):
		add_row(height)
		
func remove_unnecessary_pieces() -> void:
	var pieces_to_be_removed = Array()
	for piece in pieces:
		if not piece.get_node("emitter").emitting:
			pieces_to_be_removed.append(piece)
	for piece in pieces_to_be_removed:
		piece.queue_free()
		pieces.erase(piece)

func highlight(pos_x):
	highlight = Highlight.instance()
	highlight.init(get_column_id(pos_x), self)
	highlight.z_index += 1
	add_child(highlight)

func update_highlight():
	if is_instance_valid(highlight):
		highlight.update()

func unhighlight():
	highlight.queue_free()

func get_column_id(pos_x: int) -> int:
	return int(pos_x / Global.square_side)

func rows_from_bottom() -> Array:
	var result = Array()
	for i in range(rows.size()-1,-1,-1):
		result.push_back(rows[i])
	return result

func get_lowest_square_in(column: int) -> int:
	for row in rows_from_bottom():
		if row.has_square_in(column):
			return row.height
	return -1

func is_empty() -> bool:
	return rows.empty()

func is_full() -> bool:
	return rows.size() > Global.rows

func remove_full_rows() -> void:
	for row in rows:
		if row.is_full():
			emit_signal("row_removed")
			remove_row(row)

func handle_rows_below(removedRow: Row):
	for row in rows:
		if row.height > removedRow.height:
			remove_row(row)
	
func is_blocked(looseRow: Row):
	var isOnTopRow : bool = looseRow.height == 0
	return isOnTopRow or is_blocked_by_row_above(looseRow)

func is_blocked_by_row_above(looseRow: Row):
	var rowAbove = get_row_with_height(looseRow.height - 1)
	return rowAbove != null and looseRow.is_blocked_by(rowAbove)

func anchor(looseRow: Row):
	var sameLevelRow = get_row_with_height(looseRow.height)
	if sameLevelRow == null:
		rows.append(looseRow)
	else:
		sameLevelRow.merge_with(looseRow)
		if sameLevelRow.is_full():
			remove_full_rows()
		remove_child(looseRow)
	looseRows.erase(looseRow)

func get_row_with_height(height) -> Object:
	for row in rows:
		if row.height == height:
			return row
	return null

func add_row(height: int) -> void:
	var row = Row.new(height, Global.random_indices())
	rows.insert(height, row)
	add_child(row)

func remove_row(row: Row) -> void:
	var removed_squares = row.destroy_all_squares()
	emit_signal("squares_removed", len(removed_squares))
	for node in removed_squares:
		pieces.append(node)
		self.add_child(pieces.back())
	remove_child(row)
	rows.erase(row)
	handle_rows_below(row)
	update_highlight()

func add_loose_row(pos_x: int) -> void:
	var column = get_column_id(pos_x)
	var row = Row.new(Global.rows, [column])
	looseRows.append(row)
	add_child(row)
	
func add_top_row():
	anchor_blocked_loose_rows()
	for row in rows:
		row.lower()
	add_row(0)
	update_highlight()
	
func anchor_blocked_loose_rows():
	for looseRow in looseRows:
		if is_blocked(looseRow):
			anchor(looseRow)

func elevate_loose_rows():
	for looseRow in looseRows:
		if is_blocked(looseRow):
			anchor(looseRow)
		else:
			looseRow.elevate()
