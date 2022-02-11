extends Node

const Row = preload("res://scripts/Row.gd")
const tick : float = 1.0/60
const bottomRow : int = 14
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
		var row = Row.new(height, randomIndices())
		rows.append(row)
		add_child(row)

func input(column: int):
	var row = Row.new(bottomRow, [column])
	looseRows.append(row)
	add_child(row)

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

func removeFullRows() -> void:
	for row in rows:
		if row.isFull():
			elevateRowsBelow(row)
			get_parent().addPoints(10)
			row.queue_free()
			rows.erase(row)

func elevateRowsBelow(removedRow: Row):
	for row in rows:
		if row.height > removedRow.height:
			row.elevate()
	
func isBlocked(looseRow: Row):
	var isOnTopRow : bool = looseRow.height == 0
	return isOnTopRow or isBlockedByRowAbove(looseRow)

func isBlockedByRowAbove(looseRow: Row):
	var rowAbove = getIndexOfRowWithHeight(looseRow.height - 1)
	return rowAbove != -1 and looseRow.isBlockedBy(rows[rowAbove])

func anchor(looseRow: Row):
	var sameLevelRow = getIndexOfRowWithHeight(looseRow.height)
	if sameLevelRow == -1:
		rows.append(looseRow)
	else:
		rows[sameLevelRow].mergeWith(looseRow)
	looseRows.erase(looseRow)

func getIndexOfRowWithHeight(height) -> int:
	for id in range(rows.size()):
		if rows[id].height == height:
			return id
	return -1
	
func onTimeout():
	for row in rows:
		row.lower()
	var row = Row.new(0, randomIndices())
	rows.insert(0, row)
	add_child(row)
