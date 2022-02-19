extends Node

const Row = preload("res://scripts/Row.gd")
const tick : float = 1.0/60
const bottomRowHeight : int = 14
onready var tileMap := get_node("TileMap")
var rng = RandomNumberGenerator.new()

var rows = Array()
var looseRows = Array()
var elapsedTime = 0.0

func _init():
	rng.randomize()

func randomIndices() -> Array:
	var indices = [0,1,2,3,4,5,6,7,8,9]
	indices.shuffle()
	indices.resize(rng.randi_range(2, 9))
	return indices

func _ready():
	for height in range(0, 7):
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
	removeFullRows()

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
	var row = Row.new(height, randomIndices())
	rows.append(row)
	add_child(row)
	
func removeRow(row: Row) -> void:
	remove_child(row)
	rows.erase(row)
	
func addLooseRow(column: int) -> void:
	var row = Row.new(bottomRowHeight, [column])
	looseRows.append(row)
	add_child(row)
	
func onTimeout():
	for row in rows:
		row.lower()
	var row = Row.new(0, randomIndices())
	rows.insert(0, row)
	add_child(row)
