extends Node2D

export (int) var level = 1

onready var scoreLabel = $scoring/ScoreLabel
onready var livesLabel = $scoring/LivesLabel
onready var bricks = $bricks

func getLevel():
	return level
	
func _process(delta):
	scoreLabel.text = "Score: " + str(Globals.score)
	
	livesLabel.text = "Lives: " + str(Globals.lives)

	var brickCount = bricks.get_children().size()
	if brickCount == 0:
		Globals.changeLevel(level + 1)