extends Node2D
class_name Row

const Square = preload("res://scenes/Square.tscn")
const Piece = preload("res://scenes/Piece.tscn")
const square_dimensions = Vector2(Global.square_side, Global.square_side) 

var squares: Dictionary
var height: int

func _init(h: int, indices: Array):
	squares = Dictionary()
	height = h

	for i in indices:
		squares[i] = Square.instance()
		squares[i].get_node("body").rect_size = square_dimensions
		squares[i].get_node("body").rect_position = Vector2(i * Global.square_side, 0)
		add_child(squares[i])
	print("squares", len(squares))

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

func destroy_all_squares() -> Array:
	var result = Array()
	var to_be_removed = []
	for column in squares:
		var piece = Piece.instance()
		var square_body = squares[column].get_node("body")
		piece.init(square_body.color, 
				   Vector2(square_body.rect_position.x + square_body.rect_size.x / 2, 
						   self.position.y + square_body.rect_size.y / 2))
		result.append(piece)
		remove_child(squares[column])
		to_be_removed.append(column)
	
	for column in to_be_removed:
		squares.erase(column)
	return result

func destroy_square(column: int) -> Node2D:
	var square_body = squares[column].get_node("body")
	remove_child(squares[column])
	if not squares.erase(column):
		pass

	var piece = Piece.instance()
	piece.init(square_body.color, 
			   Vector2(square_body.rect_position.x + square_body.rect_size.x / 2, 
					   self.position.y + square_body.rect_size.y / 2))
	return piece

func merge_with(other: Row) -> void:
	for id in other.squares.keys():
		assert(not squares.has(id) , "trying to add existing square to a row")
		squares[id] = other.squares[id]
		other.destroy_square(id)
		add_child(squares[id])

func get_squares_within_range(x,y,r):
	var result = []
	for width in squares.keys():
		if (abs(width - x) + abs(height - y)) <= r:
			result.append(width)
	return result

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
