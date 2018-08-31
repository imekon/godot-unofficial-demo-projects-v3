extends Node2D

onready var fileMenu = $TopPanel/FileMenu
onready var createMenu = $TopPanel/CreateMenu
onready var viewMenu = $TopPanel/ViewMenu
onready var fileDialog = $FileDialog
onready var projectPanel = $ProjectPanel
onready var fpsLabel = $TopPanel/FPSLabel

onready var projectTree = $ProjectPanel/VSplitContainer/ProjectTree
onready var paletteList = $ProjectPanel/VSplitContainer/PaletteList

onready var spatial = $Spatial

var current = null
var offset = 0.1
var root
var counter = 1

func _ready():
	var popup = fileMenu.get_popup()
	popup.connect("id_pressed", self, "on_menu_pressed")
	popup.add_item("New", 1)
	popup.add_item("Open...", 2)
	popup.add_item("Save...", 3)
	popup.add_separator()
	popup.add_item("Export...", 4)
	popup.add_separator()
	popup.add_item("Exit", 8)
	
	popup = createMenu.get_popup()
	popup.connect("id_pressed", self, "on_menu_pressed")
	popup.add_item("Cube", 10)
	popup.add_item("Sphere", 11)
	popup.add_item("Cylinder", 12)
	
	popup = viewMenu.get_popup()
	popup.connect("id_pressed", self, "on_menu_pressed")
	popup.add_item("Project", 20)
	popup.add_item("Textures", 21)
	
	root = projectTree.create_item()
	root.set_text(0, "Project")
	
func _process(delta):
	var fps = Engine.get_frames_per_second()
	fpsLabel.text = "FPS: " + str(fps)
	
	if Input.is_action_just_pressed("ui_left"):
		command_left()
	if Input.is_action_just_pressed("ui_right"):
		command_right()
	if Input.is_action_just_pressed("ui_up"):
		command_up()
	if Input.is_action_just_pressed("ui_down"):
		command_down()

func on_menu_pressed(id):
	match id:
		1:
			new_document()
		2:
			open_document()
		3:
			save_document()
		4:
			export_document()
		8:
			command_quit()
		10:
			command_cube()
		11:
			command_sphere()
		12:
			command_cylinder()
		20:
			pass
			
func new_document():
	pass
	
func open_document():
	fileDialog.clear_filters()
	fileDialog.add_filter("*.gml;Models")
	fileDialog.mode = FileDialog.MODE_OPEN_FILE
	fileDialog.window_title = "Open a file"
	fileDialog.popup_centered()
	
func save_document():
	fileDialog.clear_filters()
	fileDialog.add_filter("*.gml;Models")
	fileDialog.mode = FileDialog.MODE_SAVE_FILE
	fileDialog.window_title = "Save a file"
	fileDialog.popup_centered()
	
func export_document():
	fileDialog.clear_filters()
	fileDialog.add_filter("*.out;Export")
	fileDialog.mode = FileDialog.MODE_SAVE_FILE
	fileDialog.window_title = "Export a file"
	fileDialog.popup_centered()
	
func command_cube():
	var meshInstance = MeshInstance.new()
	var mesh = CubeMesh.new()
	meshInstance.mesh = mesh
	spatial.add_child(meshInstance)
	current = meshInstance
	var item = projectTree.create_item(root)
	item.set_text(0, "cube" + str(counter))
	counter += 1
	
func command_sphere():
	var meshInstance = MeshInstance.new()
	var mesh = SphereMesh.new()
	meshInstance.mesh = mesh
	spatial.add_child(meshInstance)
	current = meshInstance
	var item = projectTree.create_item(root)
	item.set_text(0, "sphere" + str(counter))
	counter += 1
	
func command_cylinder():
	var meshInstance = MeshInstance.new()
	var mesh = CylinderMesh.new()
	meshInstance.mesh = mesh
	spatial.add_child(meshInstance)
	current = meshInstance
	var item = projectTree.create_item(root)
	item.set_text(0, "cylinder" + str(counter))
	counter += 1
	
func command_left():
	if current == null:
		return
		
	current.translate(Vector3(-offset, 0, 0))
	
func command_right():
	if current == null:
		return
		
	current.translate(Vector3(offset, 0, 0))
	
func command_up():
	if current == null:
		return
		
	current.translate(Vector3(0, offset, 0))
	
func command_down():
	if current == null:
		return
		
	current.translate(Vector3(0, -offset, 0))
	
func command_quit():
	get_tree().quit()