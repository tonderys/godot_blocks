extends Node2D
class_name Background

func _ready():
	reload()

func reload():
	get_node("ColorRect").color = Global.background_color()
