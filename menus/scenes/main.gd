extends PanelContainer

onready var menuButton = $Panel/MenuButton

func _ready():
	var popup = menuButton.get_popup()
	popup.connect("id_pressed", self, "file_menu")
	
func file_menu( id ):
	match id:
		0:
			print("new")
		1:
			print("open")
		2:
			print("save")
		3:
			get_tree().quit()
