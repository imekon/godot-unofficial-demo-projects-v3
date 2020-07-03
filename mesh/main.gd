extends Spatial

onready var meshInstance = $MeshInstance

var angle = 0

func _ready():
	var mat = SpatialMaterial.new()
	mat.flags_unshaded = true
	mat.albedo_texture = load("res://crate.png")
	
	createMesh(mat, 2)
	
func createMesh(mat, size):
	var surfaceTool = SurfaceTool.new()
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surfaceTool.set_material(mat)
	surfaceTool.add_uv(Vector2(0, 0))
	surfaceTool.add_vertex(Vector3(-size, -size,  0))
	surfaceTool.add_uv(Vector2(1, 1))
	surfaceTool.add_vertex(Vector3( size,  size,  0))
	surfaceTool.add_uv(Vector2(1, 0))
	surfaceTool.add_vertex(Vector3( size, -size,  0))
	surfaceTool.add_uv(Vector2(0, 0))
	surfaceTool.add_vertex(Vector3(-size, -size,  0))
	surfaceTool.add_uv(Vector2(0, 1))
	surfaceTool.add_vertex(Vector3(-size,  size,  0))
	surfaceTool.add_uv(Vector2(1, 1))
	surfaceTool.add_vertex(Vector3( size,  size,  0))
	surfaceTool.generate_normals()
	var mesh = surfaceTool.commit()
	meshInstance.mesh = mesh

func _process(delta):
	angle += delta * 30
	meshInstance.rotation_degrees = Vector3(0, 0, -angle)
