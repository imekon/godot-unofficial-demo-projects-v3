extends Node

const SPEED_DELTA = 0.05
const SPEED_LIMIT = 10.0

onready var core = $Core
onready var spawnPoint = $SpawnPoint
onready var fpsLabel = $FPSLabel
onready var ballsLabel = $BallsLabel
onready var scoreLabel = $ScoreLabel
onready var totalLabel = $TotalLabel
onready var highestScoreLabel = $HighestScoreLabel
onready var speedLabel = $SpeedLabel
onready var timer = $Timer

var ballScene
var brickScene
var total = 0
var counter = 0
var highScore = 0
var speed = 1

func _ready():
	ballScene = load("res://scenes/Ball.tscn")
	brickScene = load("res://scenes/Brick.tscn")

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_reset"):
		get_tree().reload_current_scene()
		
	var x = 0
	if Input.is_action_pressed("ui_left"):
		x = -1
	if Input.is_action_pressed("ui_right"):
		x = 1
	x = x * delta * 5
	var xPos = core.global_transform.origin.x + x
	if xPos > -9.0 and xPos < 9.0:
		core.global_translate(Vector3(x, 0, 0))
	core.rotate_y(delta * speed)
	
	if speed < SPEED_LIMIT:
		speed += delta * SPEED_DELTA
	
	speedLabel.text = "Speed: %1.2f" % speed

	var fps = Engine.get_frames_per_second()
	var balls = get_tree().get_nodes_in_group("dropped")
	fpsLabel.text = "FPS: " + str(fps)
	ballsLabel.text = "Balls: " + str(balls.size())
	scoreLabel.text = "Score: " + str(core.score)
	if core.score > highScore:
		highScore = core.score
	highestScoreLabel.text = "Highest Score: " + str(highScore)
	totalLabel.text = "Total balls: " + str(total)

func on_time_tick():
	counter += 1
	total += 1
	
	if counter == 10:
		var brick = brickScene.instance()
		brick.global_transform = spawnPoint.global_transform
		var x = (2 * randf() - 1) * 6
		var z = (2 * randf() - 1) * 1.5
		brick.translate(Vector3(x, 0, z))
		add_child(brick)
		counter = 0
	else:
		var ball = ballScene.instance()
		ball.global_transform = spawnPoint.global_transform
		var x = (2 * randf() - 1) * 6
		var z = (2 * randf() - 1) * 1.5
		ball.translate(Vector3(x, 0, z))
		add_child(ball)
		
	match total:
		50:
			timer.wait_time = 0.6
			
		100:
			timer.wait_time = 0.4
			
		200:
			timer.wait_time = 0.2

