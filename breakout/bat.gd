extends KinematicBody2D

func _physics_process(delta):
	# Get the x position of the mouse
	var x = get_viewport().get_mouse_position().x
	
	# Get the current y position to keep bat at same vertical level
	var y = position.y
	
	# Set the bat position
	# If you use move, I found the ball can actually 'push' the bat
	# out the way!
	position = Vector2(x, y)
