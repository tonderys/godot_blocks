extends Node2D

var bottom_left
var radius 
var color = Color.BLUE

const step = Global.square_side
const thickness = 0.1 * Global.square_side

func is_in_range(point):
	return point.x >= 0 and point.y >= 0

func get_line(start, steps):
	var result = [start, ]
	for i in range(3):
		result.append(result[-1] + steps[i%2])
	return result

func _init(c):
	bottom_left = Vector2(0,0)
	color = c

func _draw():
	var bl = Vector2(0, step)
	var ul = Vector2(0, 0)
	var ur = Vector2(step, 0)
	var dr = Vector2(step, step)
	
	var points = [bl, ul, ur, dr, bl]
	var prev = points[0]
	for i in range (1, len(points)):
		var next = points[i]
		if is_in_range(prev) and is_in_range(next):
			draw_line(prev, next, color, thickness)
			prev = next
			
