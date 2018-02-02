extends RigidBody2D

# Various settings on RigidBody2D have been altered:
# Mode:				Character
# Friction:			0
# Bounce:			1
# Gravity Scale:	0
# Contacts Rep.:	1
# Contact Monitor:	ON
# Damp Override
#	Linear:			0
#	Angular:		0

const SPEEDUP = 10
const DEFSPEED = 200
const MAXSPEED = 300

func _ready():
	# Set the initial linear velocity
	compute_velocity()

func compute_velocity():
	# Compute a direction
	var n = randf() * PI / 2
	var velocity = Vector2(sin(n), -cos(n))
	set_linear_velocity(velocity * DEFSPEED)
	
func compute_collision(delta, bodies):
	# For each body we collide with, assuming group "brick"
	for body in bodies:
		if body.is_in_group("brick"):
			# Get the score of the brick
			var score = body.getScore()
			
			# Add score to global score
			get_node("/root/globals").addScore(score)
			
			# Delete the colliding body, i.e. brick
			body.destroy()
			
		if body.get_name() == "bat":
			var speed = get_linear_velocity().length()
			var direction = get_pos() - body.get_node("anchor").get_global_pos()
			var velocity = direction.normalized() * min(speed + SPEEDUP, MAXSPEED)
			set_linear_velocity(velocity)
		
func _fixed_process(delta):
	# Get a list of bodies we're bumping into
	var bodies = get_colliding_bodies()
	compute_collision(delta, bodies)
	
	# Are we off screen, if so, drop a life and reset
	var pos = get_pos()
	if pos.y > 650:
		set_pos(Vector2(512, 400))
		compute_velocity()
		get_node("/root/globals").decLives()

