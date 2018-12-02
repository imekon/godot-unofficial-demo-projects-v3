extends StaticBody2D

export (int) var score = 20

onready var tween = $"Tween"
onready var sprite = $"Sprite"

func _ready():
	# Ensure this is in group 'brick' so we can detect it when the ball
	# collides with it
	add_to_group("brick")
	tween.interpolate_property(sprite, "modulate:a", 1.0, 0.0, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(sprite, "scale", sprite.get_scale(), Vector2(1.7, 1.7), 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	
func destroy():
	# clear_shapes()
	tween.start()

func _onTweenCompleted( object, key ):
	Globals.score += score
	queue_free()
