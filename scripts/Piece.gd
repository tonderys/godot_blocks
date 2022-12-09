extends Node2D

onready var pieceNode = get_node("emitter")

var color: Color
var emitting: bool

func init(c: Color, p: Vector2) -> void:
	position = p
	color = c
	emitting = true
	
func _ready():
	pieceNode.color = color
	pieceNode.emitting = emitting
