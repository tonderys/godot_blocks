extends Node
class_name Board

const Row = preload("res://scripts/Row.gd")
const tick : float = 1.0/60
const bottomRowHeight : int = 14
onready var tileMap := get_node("TileMap")

var rows = Array()
var looseRows = Array()
var topRowsDemand: int = 0
var elapsedTime = 0.0

func _ready():
	reset()

func reset() -> void:
	rows = Array()
	looseRows = Array()
	elapsedTime = 0.0
	for height in range(0, bottomRowHeight/2):
		addRow(height)

func input(column: int):
	addLooseRow(column)

func _process(delta: float):
	elapsedTime += delta
	while elapsedTime > tick:
		elapsedTime -= tick
		for looseRow in looseRows:
			if isBlocked(looseRow):
				anchor(looseRow)
				break
			looseRow.elevate()
	for i in range(topRowsDemand):
		addTopRow()
	topRowsDemand = 0
	removeFullRows()

func isEmpty() -> bool:
	return rows.empty()

func isFull() -> bool:
	return rows.size() > bottomRowHeight

func removeFullRows(combo: int = 1) -> void:
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
	
func addTopRow():
	for row in rows:
		row.lower()
	addRow(0)

func removeRow(row: Row) -> void:
	remove_child(row)
	rows.erase(row)
	
func addLooseRow(column: int) -> void:
	var row = Row.new(bottomRowHeight, [column])
	looseRows.append(row)
	add_child(row)
	
func onTimeout():
	topRowsDemand += 1
