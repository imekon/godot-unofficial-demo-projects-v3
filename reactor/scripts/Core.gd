extends KinematicBody

var score = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func on_hit_core(body):
	if body.is_in_group("ball"):
		score += 1
	if body.is_in_group("brick"):
		score -= 10
		if score < 0:
			score = 0

func on_body_shaft(body):
	if body.is_in_group("brick"):
		score -= 10
		if score < 0:
			score = 0
