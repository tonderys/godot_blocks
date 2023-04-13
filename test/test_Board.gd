extends GutTest

var board

var generator = FakeRow.new()

func before_each():
	board = load("res://scripts/Board.gd").new()
	board.row_generator = generator
	
func reset_board_with_rows(indices):
	board.row_generator.indices_to_add = indices
	board.reset()
	
func change_rows_to(indices):
	board.row_generator.indices_to_add = indices

func test_get_lowest_square():
	reset_board_with_rows([0])
	assert_eq(board.get_lowest_square_in(0), 3)
	assert_eq(board.get_lowest_square_in(1), -1)
	assert_eq(board.get_lowest_square_in(2), -1)
	
	change_rows_to([0,1])
	board.add_top_row()
	assert_eq(board.get_lowest_square_in(0), 4)
	assert_eq(board.get_lowest_square_in(1), 0)
	assert_eq(board.get_lowest_square_in(2), -1)

func test_is_empty_and_full():
	assert_true(board.is_empty())
	assert_false(board.is_full())
	for i in range(Global.rows + 1):
		board.add_top_row()
	assert_false(board.is_empty())
	assert_true(board.is_full())

func test_loose_row_elevation_destroys_top_row():
	reset_board_with_rows([0,1,2,  4,5,6])
	assert_eq(board.get_lowest_square_in(2), 3)
	assert_eq(board.get_lowest_square_in(3), -1)
	assert_eq(board.get_lowest_square_in(4), 3)

	assert_false(board.is_empty())
	
	board.add_loose_row(3 * Global.square_side)
	for i in range(Global.rows + 2):
		board.elevate_loose_rows()
		
	assert_true(board.is_empty())
	
func test_loose_row_elevation_adds_new_row():
	reset_board_with_rows([0,1,2,  4,5,6])
	assert_eq(board.get_lowest_square_in(2), 3)
	assert_eq(board.get_lowest_square_in(3), -1)
	assert_eq(board.get_lowest_square_in(4), 3)

	board.add_loose_row(2 * Global.square_side)
	for i in range(Global.rows + 2):
		board.elevate_loose_rows()
		
	assert_eq(board.get_lowest_square_in(2), 4)
	assert_eq(board.get_lowest_square_in(3), -1)
	assert_eq(board.get_lowest_square_in(4), 3)
	
