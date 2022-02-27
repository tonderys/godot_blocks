extends Node2D
class_name Row

const Square = preload("res://scenes/Square.tscn")
const square_side : int = 58
const square_dimensions = Vector2(square_side, square_side)

var squares = Array()
var height : int

func _init(height: int, indices: Array):
	self.height = height

	for i in indices:
		squares.append(i)
		var square = Square.instance()
		square.get_node("body").rect_size = square_dimensions
		square.get_node("body").rect_position = Vector2(i * square_side, 0)
		add_child(square)

func _process(_delta: float):
	self.position = Vector2(0, self.height * square_side)

func canMergeWith(other: Row) -> bool:
	for otherSquare in other.squares:
		for ownSquare in squares:
			if ownSquare == otherSquare:
				return false
	return true

func mergeWith(other: Row) -> void:
	for square in other.squares:
		assert(not squares.has(square) , "trying to add existing square to a row")
		squares.append(square)
	for child in other.get_children():
		other.remove_child(child)
		add_child(child)

func isFull() -> bool:
	return squares.size() >= 10

func lower() -> void:
	self.height += 1

func elevate() -> void:
	self.height -= 1
	
func isBlockedBy(other: Row) -> bool:
	return other.height == height-1 and not canMergeWith(other)
