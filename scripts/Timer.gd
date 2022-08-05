extends ColorRect

func get_remaining_time() -> float:
	return get_node("remaining").time_left / get_node("remaining").wait_time

func _process(_delta):
	self.rect_scale = Vector2(get_remaining_time(), 1)
