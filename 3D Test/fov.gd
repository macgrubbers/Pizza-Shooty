extends Area3D

var current_radius: float = 12
var new_radius: float = current_radius
var num_points: int = 20
var current_fov_angle: float = PI/2
var new_fov_angle: float = current_fov_angle
var transparancy: int = 0
var player_found: bool = false
var last_player_location: Vector3

var vertices: PackedVector3Array = PackedVector3Array()

@onready var raycast: RayCast3D = $RayCast3D
var parent: PizzaCharacter3D
var player: PizzaCharacter3D

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_vertices()
	update_fov()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not player_found:
		scan_fov()
	else:
		raycast_towards_player(get_parent().get_player().position)


# Draws a semicircle given a radius, angle, and num of points.
func setup_vertices():
	print("updating vertices")
	vertices = PackedVector3Array()
	vertices.push_back(Vector3(0,0,0))
	
	var angle = 0
	var step_size: float = PI / 2 / (num_points-2)
	while angle <= current_fov_angle:
		var target_destination = Vector3(cos(angle) * current_radius,0,sin(angle) * current_radius)
		
		vertices.push_back(target_destination)
		vertices.push_back(Vector3(0,0,0))
		vertices.push_back(target_destination)
		angle += step_size


func update_fov():
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	$MeshInstance3D.set_mesh(arr_mesh)
	$CollisionShape3D.shape.set_points(vertices)


func scan_fov():
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body != get_parent():
			if body.is_in_group("player"):
				var collider = raycast_towards_player(body.position)


func raycast_towards_player(object_position: Vector3):
	raycast.rotation = -get_parent().rotation
	var target = object_position - global_position
	target.y = 0
	raycast.set_target_position(target)
	raycast.force_raycast_update()
	if raycast.is_colliding():
		if raycast.get_collider() == get_parent().get_player():
			player_found = true
			last_player_location= raycast.get_collider().position
		else:
			player_found = false
			raycast.set_target_position(Vector3.ZERO)

func look_for_corners():
	
