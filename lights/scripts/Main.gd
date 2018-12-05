extends Node2D

onready var light = $Light2D

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		light.translate(Vector2(-1, 0))
		
	if Input.is_action_pressed("ui_right"):
		light.translate(Vector2(1, 0))