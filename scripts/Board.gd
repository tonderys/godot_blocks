extends Node

const Row = preload("res://scripts/Row.gd")
const tick : float = 1.0/60
onready var tileMap := get_node("TileMap")

var rows = Array()
var looseRows = Array()
var elapsedTime = 0.0

func _ready():
	for height in range(0, 7):
		var row = Row.new(height)
		rows.append(row)
		add_child(row)

func _input(event):
	if event is InputEventMouseButton:
		var column = int(event.position.x / 58)
		if event.is_pressed():
			print("pressed at ", column)
		else:
			var row = Row.new(14, [column])
			looseRows.append(row)
			add_child(row)

func _process(delta: float):
	elapsedTime += delta
	while elapsedTime > tick:
		elapsedTime -= tick
		for row in looseRows:
			row.elevate(rows)
			


func onTimeout():
	for row in rows:
		row.lower()
	var row = Row.new(0)
	rows.insert(0, row)
	add_child(row)
