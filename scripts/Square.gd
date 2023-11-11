extends Node2D
class_name Square

func _ready():
	get_node("body").color = Global.get_random_color()
