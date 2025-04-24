extends GutTest

const test_file = "res://test/highscore.res"

var dir = DirAccess.new()
var score_data

func before_each():
	score_data = load("res://scripts/ScoreData.gd").new(test_file)

func after_each():
	dir.remove(test_file)

func fill_all_records(score_data, max_score):
	for i in range(score_data.entries_amount):
		score_data.save("name_%s" % i, max_score - i)

func test_empty_file():
	assert_eq(score_data.get_record_at(0), [])
	
func test_first_record():
	score_data.save("player", 50063)
	assert_eq(score_data.get_record_at(0), ["player", 50063])
	
func test_podium():
	score_data.save("second", 20000)
	score_data.save("first", 30000)
	score_data.save("third", 10000)
	
	assert_eq(score_data.get_high_score(), 30000)
	assert_eq(score_data.get_recent_name(), "third")
	
	assert_eq(score_data.get_record_at(0), ["first", 30000])
	assert_eq(score_data.get_record_at(1), ["second", 20000])
	assert_eq(score_data.get_record_at(2), ["third", 10000])
	
func test_fill_all_records():
	fill_all_records(score_data, 10000)
	assert_eq(score_data.get_record_at(0), ["name_0", 10000])
	assert_eq(score_data.get_record_at(4), ["name_4", 9996])
	assert_eq(score_data.get_record_at(8), ["name_8", 9992])
	assert_eq(score_data.get_record_at(9), [])
	assert_eq(score_data.get_high_score(), 10000)
	assert_eq(score_data.get_recent_name(), "name_8")

func test_adding_score_that_doesnt_end_up_in_leaderboard_still_changes_recent_name():
	fill_all_records(score_data, 10000)
	assert_eq(score_data.get_score_at(8), 9992)
	
	assert_false(score_data.is_good_enough(9992))
	score_data.save("player", 9992)
	assert_eq(score_data.get_record_at(8), ["name_8", 9992])
	
	assert_eq(score_data.get_recent_name(), "player")
	
func test_all_records_filled_trying_to_add_low_score():
	fill_all_records(score_data, 10000)
	
	assert_eq(score_data.get_score_at(0), 10000)
	assert_eq(score_data.get_score_at(8), 9992)
	
	assert_eq(score_data.get_record_at(8), ["name_8", 9992])
	assert_false(score_data.is_good_enough(9992))
	score_data.save("player", 9992)
	assert_eq(score_data.get_record_at(8), ["name_8", 9992])

func test_all_records_filled_adding_medium_score():
	fill_all_records(score_data, 10000)
	assert_eq(score_data.get_score_at(0), 10000)
	assert_eq(score_data.get_score_at(8), 9992)
	assert_eq(score_data.get_recent_name(), "name_8")
	
	assert_true(score_data.is_good_enough(9995))
	score_data.save("player", 9995)
	assert_eq(score_data.get_score_at(8), 9993)
	assert_eq(score_data.get_record_at(6), ["player", 9995])
	assert_eq(score_data.get_recent_name(), "player")

func test_all_records_filled_adding_high_score():
	fill_all_records(score_data, 10000)
	
	assert_eq(score_data.get_score_at(0), 10000)
	assert_eq(score_data.get_score_at(8), 9992)
	
	assert_eq(score_data.get_high_score(), 10000)
	
	score_data.save("player", 10005)
	assert_eq(score_data.get_score_at(8), 9993)
	assert_eq(score_data.get_record_at(0), ["player", 10005])
	assert_eq(score_data.get_high_score(), 10005)
