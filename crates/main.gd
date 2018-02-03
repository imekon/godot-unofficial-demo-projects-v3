extends Node2D

export (PackedScene) var ball_scene
export (NodePath) var ball_spawn_path
export (float) var strength = 2.0
onready var ball_spawn = get_node(ball_spawn_path)

var ball_count = 3

func _ready():
	set_process_input(true)
	
func _input(ev):
	if ev.type == InputEvent.MOUSE_BUTTON:
		if ev.button_index == BUTTON_LEFT and ev.pressed:
			if ball_count > 0:
				createBall(ev.pos)
		
func createBall(pos):
	var ball = ball_scene.instance()
	var startPos = ball_spawn.get_global_pos()
	ball.set_global_pos(startPos)
	var dir = (pos - startPos) / strength
	ball.set_linear_velocity(dir)
	add_child(ball)
	ball_count -= 1
