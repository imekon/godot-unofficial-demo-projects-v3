extends RigidBody

const view_sensitivity = 0.25
const SPEED = 20
const BALL_SPEED = 35

var yaw = 0   # yaw is left/right (y axis)
var pitch = 0 # pitch is up/down (x axis)

onready var camera = $Camera
onready var main = get_tree().get_root().get_node("main")
onready var ballScene = preload("res://ball.tscn")
onready var ballSpawnPoint = $ballSpawnPoint

func _ready():
	set_process_input(true)
	
func _input(event):
	if event is InputEventMouseMotion:
		# compute the yaw with full 360 degree rotation
		yaw = fmod(yaw - event.relative.x * view_sensitivity, 360)
	
		# compute pitch with limited +85/-85 rotation, so we don't wrap around
		pitch = max(min(pitch - event.relative.y * view_sensitivity, 85), -85)
	
		# pitch angle goes on camera
		camera.rotation_degrees = Vector3(pitch, 0, 0)
	
		# yaw goes on player (RigidBody)
		rotation_degrees = Vector3(0, yaw, 0)
	
	if Input.is_action_pressed("move_forwards"):
		var x = sin(deg2rad(-yaw))
		var z = -cos(deg2rad(yaw))
		set_linear_velocity(Vector3(x, 0, z) * SPEED)
	elif Input.is_action_pressed("move_backwards"):
		var x = sin(deg2rad(-yaw) - PI)
		var z = -cos(deg2rad(yaw) - PI)
		set_linear_velocity(Vector3(x, 0, z) * SPEED)
	elif Input.is_action_pressed("move_left"):
		var x = sin(deg2rad(-yaw) - PI/2)
		var z = -cos(deg2rad(yaw) + PI/2)
		set_linear_velocity(Vector3(x, 0, z) * SPEED)
	elif Input.is_action_pressed("move_right"):
		var x = sin(deg2rad(-yaw) + PI/2)
		var z = -cos(deg2rad(yaw) - PI/2)
		set_linear_velocity(Vector3(x, 0, z) * SPEED)
	elif event.is_action_pressed("ui_fire"):
		fire_ball()
	else:
		set_linear_velocity(Vector3())
		
func fire_ball():
	var ball = ballScene.instance()
	var x = sin(deg2rad(-yaw))
	var z = -cos(deg2rad(yaw))
	var pos = ballSpawnPoint.get_global_transform().origin
	ball.set_translation(pos)
	ball.set_linear_velocity(Vector3(x, 0, z) * BALL_SPEED)
	main.add_child(ball)