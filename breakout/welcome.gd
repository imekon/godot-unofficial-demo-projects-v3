extends PanelContainer

func _ready():
	pass

# User clicked on the START button
func onStart():
	# Randomise everything (set a new seed for the random function,
	# ensuring it's different every time the application starts)
	randomize()
	
	# Change scene to level 01 and off we go!
	get_tree().change_scene("res://level01.tscn")
