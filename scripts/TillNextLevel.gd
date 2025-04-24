extends ColorRect

func _get_remaining() -> float:
	return float(get_parent().tillNextLevel) / get_parent().rowsToNextLevel

func _process(_delta):
	self.scale = Vector2(_get_remaining(), 1)
