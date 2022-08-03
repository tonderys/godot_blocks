extends Node2D
class_name Row

const Square = preload("res://scenes/Square.tscn")
const square_side : int = 58
const square_dimensions = Vector2(square_side, square_side) #ToDo: this might belong to the board

var squares = Dictionary()
var height : int

func _init(height: int, indices: Array):
	self.height = height

	for i in indices:
		squares[i] = Square.instance()
		squares[i].get_node("body").rect_size = square_dimensions
		squares[i].get_node("body").rect_position = Vector2(i * square_side, 0)
		add_child(squares[i])

func _process(_delta: float):
	self.position = Vector2(0, self.height * square_side)

func canMergeWith(other: Row) -> bool:
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

func mergeWith(other: Row) -> void:
	for id in other.squares.keys():
		assert(not squares.has(id) , "trying to add existing square to a row")
		squares[id] = other.squares[id]
		other.remove_child(squares[id])
		add_child(squares[id])
		

func isEmpty() -> bool:
	return squares.keys().size() == 0

func isFull() -> bool:
	return squares.keys().size() >= 10

func lower() -> void:
	self.height += 1

func elevate() -> void:
	self.height -= 1
	
func isBlockedBy(other: Row) -> bool:
	return other.height == height-1 and not canMergeWith(other)
