extends Node2D
class_name FallSquare

@onready var emitter = get_node("fall")

var color: Color

func init(c: Color, p: Vector2) -> void:
	position = p
	color = c
	
func _ready():
	emitter.color = color
	emitter.emitting = true
