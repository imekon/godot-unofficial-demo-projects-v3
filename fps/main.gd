extends Spatial

onready var fpsLabel = get_node("CanvasLayer/FPS")

func _physics_process(delta):
	pass
	# fpsLabel.set_text("FPS: " + str(OS.get_frames_per_second()))

