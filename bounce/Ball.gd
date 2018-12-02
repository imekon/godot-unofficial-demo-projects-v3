extends KinematicBody2D

const MOVEMENT = 300

func _ready():
	randomize()
	rotation = get_range(deg2rad(90))
	
func _physics_process(delta):
	var thrust = MOVEMENT * delta
	var direction = Vector2(thrust, 0).rotated(rotation)
	var collide = move_and_collide(direction)
	
	if collide != null:
		direction = direction.bounce(collide.normal)
		rotation = atan2(direction.y, direction.x) + get_range(1.0) - 0.5
	
func get_range(value):
	return randf() * value