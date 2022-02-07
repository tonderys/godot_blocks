extends Node

const Row = preload("res://scripts/Row.gd")
onready var tileMap := get_node("TileMap")

var rows = Array()

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
			print("released at ", column)
		

func onTimeout():
	for row in rows:
		row.lower()
	var row = Row.new(0)
	rows.insert(0, row)
	add_child(row)
