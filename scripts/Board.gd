extends Node
class_name Board

const Highlight = preload("res://scenes/Highlight.tscn")
const Row = preload("res://scripts/Row.gd")
const bottomRowHeight : int = 14
const square_size = 58

var rows = Array()
var looseRows = Array()
var highlight = Highlight.instance()
var highlighted_column = null

func _ready():
	reset()

func reset() -> void:
	rows = Array()
	looseRows = Array()

	for height in range(0, bottomRowHeight/2):
		addRow(height)

func highlight(posX):
	add_child(highlight)
	
func unhighlight():
	remove_child(highlight)

func get_column_id(posX: int) -> int:
	return int(posX / 58)

func get_lowest_empty_square_in(column: int) -> int:
	var height = 0
	var square_found_in = -1
	for row in rows:
		if row.has_square_in(column):
			square_found_in = height
		height += 1
	return square_found_in + 1

func _input(event):
	if event is InputEventMouseMotion:
		highlighted_column = get_column_id(event.position.x)
		
func _process(_delta):
	if highlighted_column != null:
		var column_pos_x = highlighted_column * square_size
		var column_pos_y = get_lowest_empty_square_in(highlighted_column) * square_size
		var max_height = (bottomRowHeight + 1) * square_size
		
		highlight.set_position(Vector2(column_pos_x, column_pos_y))
		highlight.set_size(Vector2(square_size, max_height - column_pos_y))

func input(posX: int):
	unhighlight()
	addLooseRow(get_column_id(posX))

func isEmpty() -> bool:
	return rows.empty()

func isFull() -> bool:
	return rows.size() > bottomRowHeight

func removeFullRows(combo: int = 1) -> void:
	if combo > 1:
		yield(pauseTheGameFor(0.5), "completed")
		
	for row in rows:
		if row.isFull():
			var above = getRowWithHeight(row.height - 1)
			var below = getRowWithHeight(row.height + 1)
			elevateRowsBelow(row)
			get_parent().addPoints(combo)
			removeRow(row)
			if above != null and below != null:
				if above.canMergeWith(below):
					above.mergeWith(below)
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
	return rowAbove != null and looseRow.isBlockedBy(rowAbove)

func anchor(looseRow: Row):
	var sameLevelRow = getRowWithHeight(looseRow.height)
	if sameLevelRow == null:
		rows.append(looseRow)
	else:
		sameLevelRow.mergeWith(looseRow)
		if sameLevelRow.isFull():
			removeFullRows(1)
		remove_child(looseRow)
	looseRows.erase(looseRow)

func getRowWithHeight(height) -> Object:
	for row in rows:
		if row.height == height:
			return row
	return null

func addRow(height: int) -> void:
	var row = Row.new(height, Global.randomIndices())
	rows.insert(height, row)
	add_child(row)
	
func removeRow(row: Row) -> void:
	remove_child(row)
	rows.erase(row)
	
func addLooseRow(column: int) -> void:
	var row = Row.new(bottomRowHeight, [column])
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
