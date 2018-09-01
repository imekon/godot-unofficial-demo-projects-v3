extends Spatial

const sphere_section = 24

var cos_points = []
var sin_points = []

func _ready():
	for i in range(sphere_section):
		sin_points.append(sin(deg2rad(i * 360.0 / sphere_section)))
		cos_points.append(cos(deg2rad(i * 360.0 / sphere_section)))
		
	var meshInstance = create_disc(1, 2)
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
	
func create_triangles():
	var verts = [Vector3(0,0,0), Vector3(0,1,0), Vector3(1,0,0),
				 Vector3(1,0,0), Vector3(0,1,0), Vector3(1,1,0)]
	return create_from_vertices(verts)
	
func create_disc(hole, radius):
	var verts = []
	
	for i in range(sphere_section):
		var vert1 = Vector3(hole * cos_points[i], hole * sin_points[i], 0)
		var vert2 = Vector3(radius * cos_points[i], radius * sin_points[i], 0)
		var vert3 = Vector3()
		
		if i < sphere_section - 1:
			vert3 = Vector3(radius * cos_points[i + 1], radius * sin_points[i + 1], 0)
		else:
			vert3 = Vector3(radius * cos_points[0], radius * sin_points[0], 0)
			
		verts.append(vert1)
		verts.append(vert3)
		verts.append(vert2)
		
	return create_from_vertices(verts)
		