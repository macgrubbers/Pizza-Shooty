extends Area3D


var current_radius: float = 5
var new_radius: float = current_radius
var num_points: int = 20
var current_fov_angle: float = PI/2
var new_fov_angle: float = current_fov_angle

var transparancy: int = 0

var vertices: PackedVector3Array = PackedVector3Array()

@onready var raycast: RayCast3D = $RayCast3D
@onready var parent: PizzaCharacter3D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_vertices()
	update_fov()
	

# Update fov if radius or angle are changed.
# TODO: Trigger the update via signals so physics_process doesn't keep running
#			OR handle it in the parent node instead
func _physics_process(delta):
	scan_fov()
	pass

func scan_fov():
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body != get_parent():
			if body.is_in_group("player"):
				raycast.set_rotation(Vector3(0,-current_fov_angle/2,0))
				var target = global_position - body.global_position
				print("Position: ", position)
				print("Target: ", target)
				raycast.set_target_position(body.position - global_position)
				raycast.force_raycast_update()
				if raycast.is_colliding():
					print(raycast.get_collider())
				
					
			elif body.is_in_group("walls"):
				print("Wall!")
			else:
				print("Something else")
		
		
	# Temporary fov testing
	#if Input.is_action_just_pressed('c'):
		#scan()
		#new_radius += 3
		#new_fov_angle -= PI/6
	
	# if these are changed, update them!
	if (new_radius != current_radius or new_fov_angle != current_fov_angle):
		current_radius = move_toward(current_radius,new_radius, 0.1)
		current_fov_angle = rotate_toward(current_fov_angle, new_fov_angle, 0.05)
		update_fov()


func update_fov():
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	$MeshInstance3D.set_mesh(arr_mesh)
	$CollisionPolygon3D.shape.set_points(vertices)
	
	


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
	
	# keep FOV centered on the enemy
	set_rotation(Vector3(0,current_fov_angle/2,0))

# Cast rays at the current MeshInstance3D points, identifying any corrections
func scan():
	'''
	print("Scanning: ")
	for vert in vertices.size():
		var target = vertices[vert]
		raycast.set_target_position(target)
		raycast.force_raycast_update()
		if raycast.is_colliding():
			if raycast.get_collider().is_in_group("walls"):
				print("Wall!")
				var collision_point = raycast.get_collision_point() - raycast.global_position
				vertices[vert] = collision_point #collision_point
		else:
			# Use its default position
			pass
			
	update_fov()
	'''
