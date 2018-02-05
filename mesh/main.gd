extends Spatial

onready var meshInstance = get_node("Mesh")

var angle = 0

func _ready():
	createMesh(10)
	
func createMesh(size):
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.add_normal(Vector3( 0, 0, 1))
	st.add_vertex(Vector3(-size, -size,  0))
	st.add_vertex(Vector3( size,  size,  0))
	st.add_vertex(Vector3( size, -size,  0))
	st.add_vertex(Vector3(-size, -size,  0))
	st.add_vertex(Vector3(-size,  size,  0))
	st.add_vertex(Vector3( size,  size,  0))
	var mesh = st.commit()
	meshInstance.set_mesh(mesh)
	
func _process(delta):
	angle += delta * 30
	meshInstance.rotation_degrees = Vector3(0, 0, angle)