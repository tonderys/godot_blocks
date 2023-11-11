extends Node
class_name Board

const Highlight = preload("res://scenes/Highlight.tscn")
const Row = preload("res://scripts/Row.gd")

var rows = Array()
var looseRows = Array()
var pieces = Array()
var highlight
var row_generator = RandomRow.new()

signal squares_removed(amount, combo)
signal add_square

func _ready():
	reset()
	get_node("HSeparator").margin_top = Global.square_side * Global.rows
	get_node("HSeparator").margin_bottom = Global.square_side * Global.rows + 4

func reset() -> void:
	rows = Array()
	for row in looseRows:
		remove_child(row)
	looseRows = Array()
	_remove_unnecessary_pieces()
	
	for height in range(0, Global.rows/2):
		_add_row(height)

func _remove_unnecessary_pieces() -> void:
	var pieces_to_be_removed = Array()
	for piece in pieces:
		if not piece.emitter.emitting:
			pieces_to_be_removed.append(piece)
	for piece in pieces_to_be_removed:
		piece.queue_free()
		pieces.erase(piece)

func highlight_column(pos_x):
	highlight = Highlight.instance()
	highlight.init(_get_column_id(pos_x), self)
	highlight.z_index += 1
	add_child(highlight)

func _update_highlight():
	if is_instance_valid(highlight):
		highlight.update()

func unhighlight():
	highlight.queue_free()

func _get_column_id(pos_x: int) -> int:
	return int(pos_x / Global.square_side)

func _rows_from_bottom() -> Array:
	var result = Array()
	for i in range(rows.size()-1,-1,-1):
		result.push_back(rows[i])
	return result

func get_lowest_square_in(column: int) -> int:
	for row in _rows_from_bottom():
		if row.has_square_in(column):
			return row.height
	return -1

func is_empty() -> bool:
	return rows.empty()

func is_full() -> bool:
	return rows.size() > Global.rows

func _remove_full_rows() -> void:
	var removed_squares = Array()
	for row in rows:
		if row.is_full():
			removed_squares += _handle_rows_below(row)
			removed_squares += _remove_row(row, Row.RemoveBy.DESTROY)
			emit_signal("squares_removed", removed_squares)

func _handle_rows_below(removedRow: Row) -> Array:
	var removed_squares = Array()
	for row in _rows_from_bottom(): 
		if row.height > removedRow.height:
			removed_squares += _remove_row(row, Row.RemoveBy.FALL)
	return removed_squares
	
func _is_blocked(looseRow: Row):
	var isOnTopRow : bool = looseRow.height == 0
	return isOnTopRow or _is_blocked_by_row_above(looseRow)

func _is_blocked_by_row_above(looseRow: Row):
	var rowAbove = _get_row_with_height(looseRow.height - 1)
	return rowAbove != null and looseRow.is_blocked_by(rowAbove)

func _anchor(looseRow: Row):
	var sameLevelRow = _get_row_with_height(looseRow.height)
	if sameLevelRow == null:
		rows.append(looseRow)
	else:
		sameLevelRow.merge_with(looseRow)
		if sameLevelRow.is_full():
			_remove_full_rows()
		remove_child(looseRow)
	looseRows.erase(looseRow)

func _get_row_with_height(height) -> Object:
	for row in rows:
		if row.height == height:
			return row
	return null

func _add_row(height: int) -> void:
	var row = row_generator.generate_row(height)
	rows.insert(height, row)
	add_child(row)

func _remove_row(row: Row, behavior) -> Array:
	var removed_squares = row.remove_squares(behavior)
	for node in removed_squares:
		pieces.append(node)
		self.add_child(pieces.back())
	remove_child(row)
	rows.erase(row)
	_update_highlight()
	return removed_squares

func add_loose_row(pos_x: int) -> void:
	var column = _get_column_id(pos_x)
	if column < Global.columns:
		var row = Row.new(Global.rows, [column])
		looseRows.append(row)
		add_child(row)
		emit_signal("add_square")
	
func add_top_row():
	_anchor_blocked_loose_rows()
	for row in rows:
		row.lower()
	_add_row(0)
	_update_highlight()
	
func _anchor_blocked_loose_rows():
	for looseRow in looseRows:
		if _is_blocked(looseRow):
			_anchor(looseRow)

func elevate_loose_rows():
	for looseRow in looseRows:
		if _is_blocked(looseRow):
			_anchor(looseRow)
		else:
			looseRow.elevate()
