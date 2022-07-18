extends ColorRect

func getRemainingTime() -> float:
	return get_parent().tillNextLevel / get_parent().rowsToNextLevel

func _process(_delta):
	self.rect_scale = Vector2(getRemainingTime(), 1)
