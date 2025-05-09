extends Node2D
class_name DestroySquare

@onready var emitter = get_node("destroy")

var color: Color

func split_square():
	var slices = Global.rng.randi_range(2, 5)
	var destroyed_square_side = Global.square_side / slices
	emitter.scale_amount_min = destroyed_square_side
	emitter.scale_amount_max = destroyed_square_side
	emitter.set_emission_rect_extents(Vector2(Global.square_side - destroyed_square_side, 
									  		  Global.square_side - destroyed_square_side))
	emitter.set_amount(slices * slices)
	
func init(c: Color, p: Vector2) -> void:
	position = p
	color = c
	
func _ready():
	emitter.set_emission_shape(3)
	split_square()
	emitter.color = color
	emitter.emitting = true
