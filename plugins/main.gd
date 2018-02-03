extends PanelContainer

onready var data = preload("res://bin/simple.gdns").new()

func _on_ButtonPressed():
	$Panel/Label.text = "Data = " + data.get_data()
	
