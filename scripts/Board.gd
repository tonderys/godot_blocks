extends Node
class_name Board

const Highlight = preload("res://scenes/Highlight.tscn")
const Row = preload("res://scripts/Row.gd")

var rows = Array()
var looseRows = Array()
var pieces = Array()
var highlight
var highlighted_column = null

signal squares_removed(amount, combo)

func _ready():
	reset()

func reset() -> void:
	rows = Array()
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
	add_child(highlight)
	
func unhighlight():
	highlight.queue_free()

func get_column_id(pos_x: int) -> int:
	return int(pos_x / Global.square_side)

func _rows_from_bottom() -> Array:
	var result = Array()
	for i in range(rows.size()-1,-1,-1):
		result.push_back(rows[i])
	return result

func get_lowest_empty_square_in(column: int) -> int:
	for row in _rows_from_bottom():
		if row.has_square_in(column):
			return row.height + 1
	return 0

func remove_block_from_column(pos_x: int):
	var column = get_column_id(pos_x)
	for row in _rows_from_bottom():
		if row.has_square_in(column):
			pieces.append(row.destroy_square(column))
			self.add_child(pieces.back())
			if row.is_empty(): remove_row(row)
			emit_signal("squares_removed", 1, 1)
			return

func is_empty() -> bool:
	return rows.empty()

func is_full() -> bool:
	return rows.size() > Global.rows

func remove_full_rows(combo: int = 1) -> void:
	if combo > 1:
		yield(pause_the_game_for(0.5), "completed")
	for row in rows:
		if row.is_full():
			var above = get_row_with_height(row.height - 1)
			var below = get_row_with_height(row.height + 1)
			elevate_rows_below(row)
			emit_signal("squares_removed", Global.columns, combo)
			remove_row(row)
			if above != null and below != null:
				if above.can_merge_with(below):
					above.merge_with(below)
					elevate_rows_below(below)
					remove_row(below)
					remove_full_rows(combo + 1)

func elevate_rows_below(removedRow: Row):
	for row in rows:
		if row.height > removedRow.height:
			row.elevate()
	
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
			remove_full_rows(1)
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
	for node in row.destroy_squares():
		pieces.append(node)
		self.add_child(pieces.back())
	elevate_rows_below(row)
	remove_child(row)
	rows.erase(row)
	
func add_loose_row(pos_x: int) -> void:
	var column = get_column_id(pos_x)
	var row = Row.new(Global.rows, [column])
	looseRows.append(row)
	add_child(row)
	
func on_timeout():
	add_top_row()

func add_top_row():
	anchor_blocked_loose_rows()
	for row in rows:
		row.lower()
	add_row(0)
	
func anchor_blocked_loose_rows():
	for looseRow in looseRows:
		if is_blocked(looseRow):
			anchor(looseRow)

func pause_the_game_for(period: float):
	var dropdownTimer : Timer = get_parent().get_node("Timer/remaining")
	dropdownTimer.set_paused(true)
	yield(get_tree().create_timer(period), "timeout")
	dropdownTimer.set_paused(false)
	
func elevate_loose_rows():
	for looseRow in looseRows:
		if is_blocked(looseRow):
			anchor(looseRow)
		else:
			looseRow.elevate()
