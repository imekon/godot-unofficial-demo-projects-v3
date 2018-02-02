extends Node2D

export (int) var level = 1

func getLevel():
	return level
	
func _process(delta):
	var score = get_node("/root/globals").getScore()
	get_node("scoring/ScoreLabel").set_text("Score: " + str(score))
	
	var lives = get_node("/root/globals").getLives()
	get_node("scoring/LivesLabel").set_text("Lives: " + str(lives))

	var bricks = get_node("bricks").get_children().size()
	if bricks == 0:
		get_node("/root/globals").changeLevel(level + 1)