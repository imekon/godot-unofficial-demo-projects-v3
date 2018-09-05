extends Spatial

const sphere_section = 24

var cos_points = []
var sin_points = []

var disc1
var disc2

onready var fpsLabel = $FPSLabel

func _ready():
	for i in range(sphere_section):
		sin_points.append(sin(deg2rad(i * 360.0 / sphere_section)))
		cos_points.append(cos(deg2rad(i * 360.0 / sphere_section)))
		
	disc1 = create_disc(4, 5, 2, create_material(1,0,0))
	disc1.translate(Vector3(0, 6, 0))
	add_child(disc1)
	
	disc2 = create_disc(0.5, 5, 0.5, create_material(1,1,0))
	disc2.translate(Vector3(-12, 6, 0))
	add_child(disc2)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta):
	var fps = Engine.get_frames_per_second()
	fpsLabel.text = "FPS: " + str(fps)
	disc1.rotate_y(delta)
	disc2.rotate_y(delta)
	
	if Input.is_action_just_pressed("ui_reset"):
		get_tree().reload_current_scene()
		
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
		
func create_material(red, green, blue):
	var material = SpatialMaterial.new()
	material.albedo_color = Color(red, green, blue)
	return material
	
func create_from_vertices(verts, material):
	var surfaceTool = SurfaceTool.new()
	var meshInstance = MeshInstance.new()
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	for vert in verts:
		surfaceTool.add_vertex(vert)
	surfaceTool.index()
	surfaceTool.set_material(material)
	surfaceTool.generate_normals()
	meshInstance.mesh = surfaceTool.commit()
	return meshInstance
	
func create_disc(hole, radius, thickness, material):
	var verts = []
	
	for i in range(sphere_section):
		var vert1 = Vector3(hole * cos_points[i], hole * sin_points[i], thickness)
		var vert2 = Vector3(radius * cos_points[i], radius * sin_points[i], thickness)
		var vert3
		var vert4
		
		if i < sphere_section - 1:
			vert3 = Vector3(radius * cos_points[i + 1], radius * sin_points[i + 1], thickness)
			vert4 = Vector3(hole * cos_points[i + 1], hole * sin_points[i + 1], thickness)
		else:
			vert3 = Vector3(radius * cos_points[0], radius * sin_points[0], thickness)
			vert4 = Vector3(hole * cos_points[0], hole * sin_points[0], thickness)
			
		# add them in ANTI-CLOCKWISE order, only one side is visible
		verts.append(vert1)
		verts.append(vert3)
		verts.append(vert2)
		verts.append(vert1)
		verts.append(vert4)
		verts.append(vert3)
		
		vert1 = Vector3(hole * cos_points[i], hole * sin_points[i], -thickness)
		vert2 = Vector3(radius * cos_points[i], radius * sin_points[i], -thickness)
		
		if i < sphere_section - 1:
			vert3 = Vector3(radius * cos_points[i + 1], radius * sin_points[i + 1], -thickness)
			vert4 = Vector3(hole * cos_points[i + 1], hole * sin_points[i + 1], -thickness)
		else:
			vert3 = Vector3(radius * cos_points[0], radius * sin_points[0], -thickness)
			vert4 = Vector3(hole * cos_points[0], hole * sin_points[0], -thickness)
		
		# this face is CLOCKWISE as it's facing away from us
		verts.append(vert1)
		verts.append(vert2)
		verts.append(vert3)
		verts.append(vert1)
		verts.append(vert3)
		verts.append(vert4)
		
		# the next face is the outer rim
		vert1 = Vector3(radius * cos_points[i], radius * sin_points[i], thickness)
		if i < sphere_section - 1:
			vert2 = Vector3(radius * cos_points[i + 1], radius * sin_points[i + 1], thickness)
			vert3 = Vector3(radius * cos_points[i + 1], radius * sin_points[i + 1], -thickness)
		else:
			vert2 = Vector3(radius * cos_points[0], radius * sin_points[0], thickness)
			vert3 = Vector3(radius * cos_points[0], radius * sin_points[0], -thickness)
		vert4 = Vector3(radius * cos_points[i], radius * sin_points[i], -thickness)
		
		verts.append(vert1)
		verts.append(vert2)
		verts.append(vert3)
		verts.append(vert1)
		verts.append(vert3)
		verts.append(vert4)
		
		# the last face is the inner rim
		vert1 = Vector3(hole * cos_points[i], hole * sin_points[i], thickness)
		if i < sphere_section - 1:
			vert2 = Vector3(hole * cos_points[i + 1], hole * sin_points[i + 1], thickness)
			vert3 = Vector3(hole * cos_points[i + 1], hole * sin_points[i + 1], -thickness)
		else:
			vert2 = Vector3(hole * cos_points[0], hole * sin_points[0], thickness)
			vert3 = Vector3(hole * cos_points[0], hole * sin_points[0], -thickness)
		vert4 = Vector3(hole * cos_points[i], hole * sin_points[i], -thickness)
		
		verts.append(vert1)
		verts.append(vert3)
		verts.append(vert2)
		verts.append(vert1)
		verts.append(vert4)
		verts.append(vert3)
		
	return create_from_vertices(verts, material)
		