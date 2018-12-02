extends KinematicBody2D

const MOVEMENT = 700.0

var thrust : float = 0.0

func _physics_process(delta):
	var angle = 0.0

	if Input.is_action_pressed("ui_up"):
		thrust = MOVEMENT * delta
	if Input.is_action_pressed("ui_down"):
		thrust = -MOVEMENT * delta * 0.25
	if Input.is_action_pressed("ui_left"):
		angle = -2
	if Input.is_action_pressed("ui_right"):
		angle = 2
		
	var rot = rotation_degrees

	var direction = Vector2(thrust, 0).rotated(deg2rad(rot))
	var collide = move_and_collide(direction)
		
	rotate(deg2rad(angle))

	thrust *= 0.99
	
func _draw():
	draw_line(Vector2(0, 0), Vector2(500, 0), Color(1.0, 0.0, 0.0))