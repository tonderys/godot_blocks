extends GutTest

var Row = preload("res://scripts/Row.gd")

func amount_of_squares_in(row):
	var amount = 0
	for i in range(Global.columns):
		if row.has_square_in(i):
			amount += 1
	return amount

func test_row_cannot_merge_with_identical_one():
	var row = Row.new(0, [1])
	assert_false(row.can_merge_with(row))

func test_row_can_merge_with_not_overlapping_row():
	var row1 = Row.new(0, [1,3,5,7])
	var row2 = Row.new(0, [2,4,6,8])
	assert_true(row1.can_merge_with(row2))
	
func test_has_square_in():
	var row = Row.new(0, [1,3,5,7])
	assert_true(row.has_square_in(1))
	assert_true(row.has_square_in(3))
	assert_true(row.has_square_in(5))
	assert_true(row.has_square_in(7))
	
	assert_false(row.has_square_in(0))
	assert_false(row.has_square_in(2))
	assert_false(row.has_square_in(4))
	assert_false(row.has_square_in(6))
	assert_false(row.has_square_in(8))
	assert_false(row.has_square_in(9))
	assert_false(row.has_square_in(10))

func test_destroy_all_squares():
	var row = Row.new(0, [1,2,3,5])
	
	assert_true(row.has_square_in(1))
	var pieces = row.destroy_all_squares()
	assert_false(row.has_square_in(1))
	
	assert_true(len(pieces) == 4)
	for piece in pieces:
		piece.free()

func test_destroy_square():
	var row = Row.new(0, [1,2,3,5])
	
	assert_true(row.has_square_in(1))
	row.destroy_square(1)
	assert_false(row.has_square_in(1))

func test_merge_possible():
	var row1 = Row.new(0, [1,2,3,5])
	var row2 = Row.new(0, [0,4,6,7,8])
	
	assert_eq(amount_of_squares_in(row1), 4)
	assert_eq(amount_of_squares_in(row2), 5)
	
	assert_true(row1.can_merge_with(row2))
	row1.merge_with(row2)
	
	assert_eq(amount_of_squares_in(row1), 9)
	assert_eq(amount_of_squares_in(row2), 0)
	
func test_merge_impossible():
	var row1 = Row.new(0, [1,2,3,5])
	var row2 = Row.new(0, [4,5,6,7,8])
	
	assert_eq(amount_of_squares_in(row1), 4)
	assert_eq(amount_of_squares_in(row2), 5)
	
	assert_false(row1.can_merge_with(row2))
	
func test_get_squares_within_range_0():
		var height = 3
		var radius = 0
		var row = Row.new(height, [1,2,3,5])
		assert_eq(row.get_squares_within_range(1, height, radius), [1])
		assert_eq(row.get_squares_within_range(2, height, radius), [2])
		assert_eq(row.get_squares_within_range(3, height, radius), [3])
		assert_eq(row.get_squares_within_range(4, height, radius), [])
		assert_eq(row.get_squares_within_range(5, height, radius), [5])

func test_get_squares_within_range_0_another_row():
		var height = 3
		var radius = 0
		var row = Row.new(height, [1,2,3,5])
		assert_eq(row.get_squares_within_range(1, height - 1, radius), [])
		assert_eq(row.get_squares_within_range(2, height - 1, radius), [])
		assert_eq(row.get_squares_within_range(3, height - 2, radius), [])
		assert_eq(row.get_squares_within_range(4, height + 1, radius), [])
		assert_eq(row.get_squares_within_range(5, height + 1,radius), [])

func test_get_squares_within_range_1():
		var height = 3
		var radius = 1
		var row = Row.new(height, [1,2,3,5])
		assert_eq(row.get_squares_within_range(1, height - 1, radius), [1])
		assert_eq(row.get_squares_within_range(2, height, radius), [1,2,3])
		assert_eq(row.get_squares_within_range(3, height + 1, radius), [3])
		assert_eq(row.get_squares_within_range(4, height, radius), [3,5])

func test_get_squares_within_range_2():
		var height = 3
		var radius = 2
		var row = Row.new(height, [1,2,3,5])
		assert_eq(row.get_squares_within_range(1, height - 1, radius), [1,2])
		assert_eq(row.get_squares_within_range(2, height - 2, radius), [2])
		assert_eq(row.get_squares_within_range(3, height, radius), [1,2,3,5])
		assert_eq(row.get_squares_within_range(4, height + 1, radius), [3,5])
		assert_eq(row.get_squares_within_range(5, height + 1, radius), [5])
		
func test_get_squares_within_range_4():
		var height = 3
		var radius = 4
		var row = Row.new(height, [0,1,2,3,5,7,8,9])
		assert_eq(row.get_squares_within_range(1, height - 4, radius), [1])
		assert_eq(row.get_squares_within_range(2, height - 3, radius), [1,2,3])
		assert_eq(row.get_squares_within_range(3, height - 2, radius), [1,2,3,5])
		assert_eq(row.get_squares_within_range(4, height - 1, radius), [1,2,3,5,7])
		assert_eq(row.get_squares_within_range(5, height, radius), [1,2,3,5,7,8,9])
		assert_eq(row.get_squares_within_range(4, height, radius), [0,1,2,3,5,7,8])

func test_is_not_empty():
	var row = Row.new(3, [0])
	assert_false(row.is_empty())

func test_is_empty():
	var row = Row.new(3, [])
	assert_true(row.is_empty())
	
func test_is_not_full():
	var row = Row.new(3, [0,1,2,3,4,5,  7,8,9])
	assert_false(row.is_full())

func test_is_full():
	var row = Row.new(3, [0,1,2,3,4,5,6,7,8,9])
	assert_true(row.is_full())
	
func test_lower():
	var row = Row.new(3, [0,2])
	assert_eq(row.height, 3)
	row.lower()
	assert_eq(row.height, 4)

func test_elevate():
	var row = Row.new(3, [0,2])
	assert_eq(row.height, 3)
	row.elevate()
	assert_eq(row.height, 2)
	
func test_is_blocked_by():
	var row_lower = Row.new(3, [0,2])
	var row_higher = Row.new(2, [1,2,3])
	
	assert_true(row_lower.is_blocked_by(row_higher))

func test_is_not_blocked_by():
	var row1 = Row.new(3, [0,2])
	var row2 = Row.new(2, [1,3])
	var row3 = Row.new(1, [1,2,3])
	
	assert_false(row2.is_blocked_by(row1))
	assert_false(row3.is_blocked_by(row1))
