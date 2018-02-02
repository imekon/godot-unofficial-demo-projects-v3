extends Node

var lives = 5
var score = 0

func _ready():
	pass
	
func getLives():
	return lives
	
func decLives():
	lives -= 1
	
func getScore():
	return score
	
func addScore(value):
	score += value
	
func changeLevel(level):
	var scene = "res://level%02d.tscn" % level
	get_tree().change_scene(scene)