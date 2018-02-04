extends Spatial

onready var fpsLabel = $CanvasLayer/FPS

func _physics_process(delta):
	var fps = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
	# var fps = "FPS: " + str(Engine.get_frames_per_second())
	if fps != "":
		fpsLabel.text = fps
	else:
		fpsLabel.text = "FPS is blank!"

