extends Node2D
class_name Row

const Square = preload("res://scenes/Square.tscn")
const DestroySquare = preload("res://scenes/DestroySquare.tscn")
const FallSquare = preload("res://scenes/FallSquare.tscn")
const square_dimensions = Vector2(Global.square_side, Global.square_side) 

enum RemoveBy {FALL, DESTROY}

var squares: Dictionary
var height: int
var columns

func _init(h: int, indices: Array, amount_of_columns = Global.columns):
	squares = Dictionary()
	height = h
	columns = amount_of_columns

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

func remove_squares(behavior) -> Array:
	var result = Array()
	var to_be_removed = []
	for column in squares:
		var square_body = squares[column].get_node("body")
		var square_position = Vector2(square_body.rect_position.x + square_body.rect_size.x / 2,
									  self.position.y + square_body.rect_size.y / 2)
		var piece
		if (behavior == RemoveBy.DESTROY):
			piece = DestroySquare.instance()
		else:
			piece = FallSquare.instance()
		piece.init(square_body.color, square_position)
		result.append(piece)
		remove_child(squares[column])
		to_be_removed.append(column)
	
	for column in to_be_removed:
		if squares.erase(column) != true:
			print ("Can't erase column that doesn't exist")
	return result

func merge_with(other: Row) -> void:
	for id in other.squares.keys():
		if not squares.has(id):
			squares[id] = other.squares[id].duplicate(1)
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
	return squares.keys().size() >= columns

func lower() -> void:
	self.height += 1

func elevate() -> void:
	self.height -= 1
	
func is_blocked_by(other: Row) -> bool:
	return other.height == self.height-1 and not can_merge_with(other)
