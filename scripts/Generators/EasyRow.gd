extends Generator
class_name EasyRow

func generate_row(height):
	var indices = range(0, Global.columns)
	indices.erase(Global.rng.randi()%Global.columns)
	return Row.new(height, indices)
