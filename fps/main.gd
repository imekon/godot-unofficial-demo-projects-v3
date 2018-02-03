extends Spatial

onready var fpsLabel = get_node("CanvasLayer/FPS")

func _physics_process(delta):
	fpsLabel.set_text("FPS: " + str(Performance.get_monitor(0)))

