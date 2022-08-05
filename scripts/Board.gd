extends Node
class_name Board

const Highlight = preload("res://scenes/Highlight.tscn")
const Row = preload("res://scripts/Row.gd")

var rows = Array()
var looseRows = Array()
var highlight = Highlight.instance()
var highlighted_column = null

signal squares_removed(amount, combo)

func _ready():
	reset()

func reset() -> void:
	rows = Array()
	looseRows = Array()

	for height in range(0, Global.rows/2):
		addRow(height)

func highlight(posX):
	add_child(highlight)
	
func unhighlight():
	remove_child(highlight)
	highlight.turn_red(0.0)

func get_column_id(posX: int) -> int:
	return int(posX / 58)

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

func remove_block_from_column(column: int):
	for row in _rows_from_bottom():
		if row.has_square_in(column):
			row.remove_square(column)
			if row.is_empty(): removeRow(row)
			emit_signal("squares_removed", 1, 1)
			return

func _input(event):
	if event is InputEventMouseMotion:
		highlighted_column = get_column_id(event.position.x)
			
func _process(_delta):
	if highlighted_column != null:
		var column_pos_x = highlighted_column * Global.square_side
		var column_pos_y = get_lowest_empty_square_in(highlighted_column) * Global.square_side
		var max_height = (Global.rows + 1) * Global.square_side
		
		highlight.set_position(Vector2(column_pos_x, column_pos_y))
		highlight.set_size(Vector2(Global.square_side, max_height - column_pos_y))

func handle_click(posX: int, remove: bool):
	unhighlight()
	if remove:
		remove_block_from_column(get_column_id(posX))
	else:
		addLooseRow(get_column_id(posX))

func is_empty() -> bool:
	return rows.empty()

func is_full() -> bool:
	return rows.size() > Global.rows

func removeFullRows(combo: int = 1) -> void:
	if combo > 1:
		yield(pauseTheGameFor(0.5), "completed")
	for row in rows:
		if row.is_full():
			var above = getRowWithHeight(row.height - 1)
			var below = getRowWithHeight(row.height + 1)
			elevateRowsBelow(row)
			emit_signal("squares_removed", Global.columns, combo)
			removeRow(row)
			if above != null and below != null:
				if above.can_merge_with(below):
					above.merge_with(below)
					elevateRowsBelow(below)
					removeRow(below)
					removeFullRows(combo + 1)

func elevateRowsBelow(removedRow: Row):
	for row in rows:
		if row.height > removedRow.height:
			row.elevate()
	
func isBlocked(looseRow: Row):
	var isOnTopRow : bool = looseRow.height == 0
	return isOnTopRow or isBlockedByRowAbove(looseRow)

func isBlockedByRowAbove(looseRow: Row):
	var rowAbove = getRowWithHeight(looseRow.height - 1)
	return rowAbove != null and looseRow.is_blocked_by(rowAbove)

func anchor(looseRow: Row):
	var sameLevelRow = getRowWithHeight(looseRow.height)
	if sameLevelRow == null:
		rows.append(looseRow)
	else:
		sameLevelRow.merge_with(looseRow)
		if sameLevelRow.is_full():
			removeFullRows(1)
		remove_child(looseRow)
	looseRows.erase(looseRow)

func getRowWithHeight(height) -> Object:
	for row in rows:
		if row.height == height:
			return row
	return null

func addRow(height: int) -> void:
	var row = Row.new(height, Global.random_indices())
	rows.insert(height, row)
	add_child(row)
	
func removeRow(row: Row) -> void:
	remove_child(row)
	rows.erase(row)
	
func addLooseRow(column: int) -> void:
	var row = Row.new(Global.rows, [column])
	looseRows.append(row)
	add_child(row)
	
func onTimeout():
	addTopRow()

func addTopRow():
	anchorBlockedLooseRows()
	for row in rows:
		row.lower()
	addRow(0)
	
func anchorBlockedLooseRows():
	for looseRow in looseRows:
		if isBlocked(looseRow):
			anchor(looseRow)

func pauseTheGameFor(period: float):
	var dropdownTimer : Timer = get_parent().get_node("Timer/remaining")
	dropdownTimer.set_paused(true)
	yield(get_tree().create_timer(period), "timeout")
	dropdownTimer.set_paused(false)
	
func elevateLooseRows():
	for looseRow in looseRows:
		if isBlocked(looseRow):
			anchor(looseRow)
		else:
			looseRow.elevate()
