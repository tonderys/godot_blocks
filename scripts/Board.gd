extends Node

const Row = preload("res://scripts/Row.gd")
onready var tileMap := get_node("TileMap")

func _ready():
	for row in range(0, 7):
		add_child(Row.new(row))

func _input(event):
	if event is InputEventMouseButton:
		var column = int(event.position.x / 58)
		if event.is_pressed():
			print("pressed at ", column)
		else:
			print("released at ", column)
		
