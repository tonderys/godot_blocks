extends Node2D

const floating_offset = 40;
var starting_pos: Vector2
var y: int
var x: int
var font_color: Color
var outline_color: Color

func get_size_of_label() -> Vector2:
	var font = get_node("score").get_font("font")
	return font.get_string_size(get_node("score").text)

func get_starting_pos(position) -> Vector2:
	var label_size = get_size_of_label()
	x = position.x - label_size.x / 2
	y = position.y - label_size.y / 2 + floating_offset ;
	var result = starting_pos + Vector2(x,y)
	
	result.x = clamp(result.x, 0, Global.width - label_size.x)
	result.y = clamp(result.y, 0, Global.height - label_size.y)
	return result

func _get_remaining() -> float:
	return float(get_node("timer").time_left / get_node("timer").wait_time);

func _process(_delta):
	get_node("score").set_position(starting_pos + Vector2(0,floating_offset * _get_remaining()))
	var alpha = _get_remaining() * 3
	font_color.a = alpha
	outline_color.a = alpha
	get_node("score").add_color_override("font_color", font_color)
	get_node("score").add_color_override("font_outline_modulate", outline_color)

func init(text: String, position: Vector2):
	font_color = Global.get_random_color();
	outline_color = Color(1,1,1,0);
	get_node("score").add_color_override("font_color", font_color)
	
	get_node("score").text = text
	
	starting_pos = get_starting_pos(position)
	get_node("score").set_position(starting_pos)

func _on_timeout():
	get_parent().remove_child(self)
