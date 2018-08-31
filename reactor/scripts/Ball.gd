extends Spatial

var time = 0

func _ready():
	pass

func _physics_process(delta):
	time += delta
	if time > 10:
		queue_free()