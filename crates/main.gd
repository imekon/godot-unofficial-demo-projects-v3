extends Node2D

export (PackedScene) var ball_scene
export (NodePath) var ball_spawn_path
export (float) var strength = 2.0
onready var ball_spawn = get_node(ball_spawn_path)

var ball_count = 3

func _ready():
	set_process_input(true)
	
func _input(ev):
	if (ev.button_mask & BUTTON_MASK_LEFT) and ev.is_pressed():
		if ball_count > 0:
			createBall(ev.position)
		
func createBall(pos):
	var ball = ball_scene.instance()
	var startPos = ball_spawn.global_position
	ball.global_position = startPos
	var dir = (pos - startPos) / strength
	ball.linear_velocity = dir
	add_child(ball)
	ball_count -= 1
