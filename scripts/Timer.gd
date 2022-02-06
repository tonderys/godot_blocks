extends ColorRect

func getRemainingTime() -> float:
	return get_node("remaining").time_left / get_node("remaining").wait_time

func _process(_delta):
	self.rect_scale = Vector2(getRemainingTime(), 1)
