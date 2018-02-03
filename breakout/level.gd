extends Node2D

export (int) var level = 1

onready var scoreLabel = $scoring/ScoreLabel
onready var livesLabel = $scoring/LivesLabel
onready var bricks = $bricks

func getLevel():
	return level
	
func _process(delta):
	var score = get_node("/root/globals").getScore()
	scoreLabel.text = "Score: " + str(score)
	
	var lives = get_node("/root/globals").getLives()
	livesLabel.text = "Lives: " + str(lives)

	var brickCount = bricks.get_children().size()
	if brickCount == 0:
		get_node("/root/globals").changeLevel(level + 1)