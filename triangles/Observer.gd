extends KinematicBody

const VIEW_SENSITIVITY = 0.25
const SPEED = 10

var yaw = 0
var pitch = 0.0

var direction = Vector3()
var velocity = Vector3()

onready var camera = $Camera

func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		yaw = int(yaw - event.relative.x * VIEW_SENSITIVITY) % 360
		pitch = clamp(pitch - event.relative.y * VIEW_SENSITIVITY, -85, 85)
		camera.rotation = Vector3(deg2rad(pitch), 0, 0)
		rotation = Vector3(0, deg2rad(yaw), 0)
		
	velocity.x = 0
	velocity.z = 0
		
	if Input.is_action_pressed("ui_up"):
		var x = sin(deg2rad(-yaw))
		var z = -cos(deg2rad(yaw))
		velocity.x = x * SPEED
		velocity.z = z * SPEED
		
	if Input.is_action_pressed("ui_down"):
		var x = sin(deg2rad(-yaw) - PI)
		var z = -cos(deg2rad(yaw) - PI)
		velocity.x = x * SPEED
		velocity.z = z * SPEED
	
	if Input.is_action_pressed("ui_left"):
		var x = sin(deg2rad(-yaw) - PI/2)
		var z = -cos(deg2rad(yaw) + PI/2)
		velocity.x = x * SPEED
		velocity.z = z * SPEED
		
	if Input.is_action_pressed("ui_right"):
		var x = sin(deg2rad(-yaw) + PI/2)
		var z = -cos(deg2rad(yaw) - PI/2)
		velocity.x = x * SPEED
		velocity.z = z * SPEED
		
func _physics_process(delta):
	move_and_slide(velocity, Vector3(0, 1, 0))