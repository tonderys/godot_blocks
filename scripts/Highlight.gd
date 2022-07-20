extends Node2D
class_name Highlight

#onready var body = get_node("body")

func _ready():
	get_node("body").color = Color(0,1,0,0.5)
	
func set_position(position):
	get_node("body").rect_position = position

