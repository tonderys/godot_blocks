extends Generator
class_name FakeRow

var indices_to_add = range(0, Global.columns)

func generate_row(height):
	return Row.new(height, indices_to_add)
