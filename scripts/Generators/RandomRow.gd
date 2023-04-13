extends Generator
class_name RandomRow

func generate_row(height):
	return Row.new(height, Global.random_indices())
