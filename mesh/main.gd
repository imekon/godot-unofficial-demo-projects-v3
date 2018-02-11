extends Spatial

onready var meshInstance = $Mesh

var angle = 0

func _ready():
	var texture = load("res://junk.png")
	var material = SpatialMaterial.new()
	# material.albedo_color = Color(1.0, 0.0, 0.0)
	material.albedo_texture = texture
	createMesh(2, material)
	
func createMesh(size, material):
	var surfaceTool = SurfaceTool.new()
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# surfaceTool.add_normal(Vector3(    0,     0,  1))
	
	surfaceTool.set_material(material)

	surfaceTool.add_vertex(Vector3(-size, -size,  0))
	surfaceTool.add_vertex(Vector3( size,  size,  0))
	surfaceTool.add_vertex(Vector3( size, -size,  0))
	surfaceTool.add_vertex(Vector3(-size, -size,  0))
	surfaceTool.add_vertex(Vector3(-size,  size,  0))
	surfaceTool.add_vertex(Vector3( size,  size,  0))
	
	surfaceTool.generate_normals()
	# surfaceTool.add_color(Color(1.0, 0.0, 0.0))
	
	var mesh = surfaceTool.commit()
	meshInstance.mesh = mesh
	
func _process(delta):
	angle += delta * 30
	meshInstance.rotation_degrees = Vector3(0, 0, angle)