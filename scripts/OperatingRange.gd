extends Node2D

var bottom_left
var radius 
var color = Color.blue

const step = Global.square_side
const thickness = 5.0

func get_line(start, steps):
	var result = [start, ]
	for i in range((radius * 2) + 1):
		result.append(result[-1] + steps[i%2])
	return result

func _init(pos, r, c):
	bottom_left = pos
	radius = r
	color = c

func set_position(y):
	bottom_left = Vector2(bottom_left.x, y)
	update()
	
func set_radius(r):
	radius = r
	update()

func _draw():
	var bl = get_line(bottom_left, [Vector2(0, -step), Vector2(-step,0)])
	var ul = get_line(bl[-1], [Vector2(step, 0), Vector2(0, -step)])
	var ur = get_line(ul[-1], [Vector2(0, step), Vector2(step, 0)])
	var dr = get_line(ur[-1], [Vector2(-step, 0), Vector2(0, step)])
	
	var points = bl + ul + ur + dr
	for i in range (1, len(points)):
		draw_line(points[i-1], points[i], color, thickness)
