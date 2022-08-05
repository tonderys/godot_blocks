extends Node2D
class_name Row

const Square = preload("res://scenes/Square.tscn")
const square_dimensions = Vector2(Global.square_side, Global.square_side) 

var squares: Dictionary
var height: int

func _init(height: int, indices: Array):
	squares = Dictionary()
	self.height = height

	for i in indices:
		squares[i] = Square.instance()
		squares[i].get_node("body").rect_size = square_dimensions
		squares[i].get_node("body").rect_position = Vector2(i * Global.square_side, 0)
		add_child(squares[i])

func _process(_delta: float):
	self.position = Vector2(0, height * Global.square_side)

func can_merge_with(other: Row) -> bool:
	for otherSquare in other.squares.keys():
		for ownSquare in squares.keys():
			if ownSquare == otherSquare:
				return false
	return true

func has_square_in(column: int) -> bool:
	return squares.has(column)
	
func remove_square(column: int):
	remove_child(squares[column])
	squares.erase(column)

func merge_with(other: Row) -> void:
	for id in other.squares.keys():
		assert(not squares.has(id) , "trying to add existing square to a row")
		squares[id] = other.squares[id]
		other.remove_child(squares[id])
		add_child(squares[id])
		

func is_empty() -> bool:
	return squares.keys().size() == 0

func is_full() -> bool:
	return squares.keys().size() >= Global.columns

func lower() -> void:
	self.height += 1

func elevate() -> void:
	self.height -= 1
	
func is_blocked_by(other: Row) -> bool:
	return other.height == self.height-1 and not can_merge_with(other)
