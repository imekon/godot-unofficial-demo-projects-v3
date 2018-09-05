extends Panel

var left = 0.0
var right = 0.0

func _draw():
	var rect
	rect = Rect2(10, 10 - left, 30, 100 + left)
	draw_rect(rect, Color(0, 1, 0), true)
	rect = Rect2(50, 10 - right, 30, 100 + right)
	draw_rect(rect, Color(0, 1, 0), true)