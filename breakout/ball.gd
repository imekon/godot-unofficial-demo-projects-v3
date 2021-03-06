extends KinematicBody2D

const MOVEMENT = 300.0

func _ready():
	rotation = randf()

func _physics_process(delta):
	var thrust = MOVEMENT * delta
	var direction = Vector2(thrust, 0).rotated(rotation)
	var collide = move_and_collide(direction)
	
	if collide != null:
		direction = direction.bounce(collide.normal)
		rotation = atan2(direction.y, direction.x)
		
		if collide.collider.is_in_group("brick"):
			collide.collider.destroy()