extends Spatial

onready var meshInstance = $Mesh

var angle = 0

func _ready():
	var material = SpatialMaterial.new()
	material.albedo_color = Color(1.0, 0.0, 0.0)
	createMesh(10, material)
	
func createMesh(size, material):
	var surfaceTool = SurfaceTool.new()
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	surfaceTool.add_normal(Vector3(    0,     0,  1))
	
	surfaceTool.add_vertex(Vector3(-size, -size,  0))
	surfaceTool.add_vertex(Vector3( size,  size,  0))
	surfaceTool.add_vertex(Vector3( size, -size,  0))
	surfaceTool.add_vertex(Vector3(-size, -size,  0))
	surfaceTool.add_vertex(Vector3(-size,  size,  0))
	surfaceTool.add_vertex(Vector3( size,  size,  0))
	
	var mesh = surfaceTool.commit()
	meshInstance.mesh = mesh
	meshInstance.set_surface_material(0, material)
	
func _process(delta):
	angle += delta * 30
	meshInstance.rotation_degrees = Vector3(0, 0, angle)