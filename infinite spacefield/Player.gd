extends KinematicBody2D

var thrust = 0
var velocity = Vector2()

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		rotation_degrees -= 1
		
	if Input.is_action_pressed("ui_right"):
		rotation_degrees += 1
		
	if Input.is_action_pressed("ui_up"):
		thrust += 10
		
	thrust -= 3
		
	thrust = clamp(thrust, 0, 700)
	
	velocity = Vector2(thrust, 0).rotated(deg2rad(rotation_degrees))
		
	velocity = move_and_slide(velocity)
