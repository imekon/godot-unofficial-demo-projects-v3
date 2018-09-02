extends Spatial

const sphere_section = 24

var cos_points = []
var sin_points = []

func _ready():
	for i in range(sphere_section):
		sin_points.append(sin(deg2rad(i * 360.0 / sphere_section)))
		cos_points.append(cos(deg2rad(i * 360.0 / sphere_section)))
		
	var meshInstance = create_disc(4, 5, 0.1)
	add_child(meshInstance)
	
func create_from_vertices(verts):
	var surfaceTool = SurfaceTool.new()
	var meshInstance = MeshInstance.new()
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	for vert in verts:
		surfaceTool.add_vertex(vert)
	surfaceTool.index()
	meshInstance.mesh = surfaceTool.commit()
	return meshInstance
	
func create_disc(hole, radius, thickness):
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
		
		# the last face is the outer rim
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
		
	return create_from_vertices(verts)
		