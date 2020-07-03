extends Panel

onready var scanner = $Control

func _process(delta):
	if Input.is_action_just_pressed("short_range_scanner"):
		set_short_range_scanner()
		
	if Input.is_action_just_pressed("medium_range_scanner"):
		set_medium_range_scanner()
		
	if Input.is_action_just_pressed("long_range_scanner"):
		set_long_range_scanner()

func set_short_range_scanner():
	scanner.set_short_range_scan()
	
func set_medium_range_scanner():
	scanner.set_medium_range_scan()
	
func set_long_range_scanner():
	scanner.set_long_range_scan()
	
