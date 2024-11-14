extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var health = 100

@onready var equipedItem = $Gun3D
@onready var camera = get_parent().get_node("Camera3D")

func _physics_process(delta):
	if health <= 0:
		return
	look_at_cursor()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump and jump input
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle movement and movement input
	var input_dir = Input.get_vector("move_down","move_up","move_left","move_right")
	var direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * -sin(camera.get_rotation().y) + direction.z * SPEED * cos(camera.get_rotation().y)
		velocity.z = direction.z * SPEED * -sin(camera.get_rotation().y) + direction.x * SPEED * -cos(camera.get_rotation().y)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) 
		velocity.z = move_toward(velocity.z, 0, SPEED) 
	
	if velocity.length() > 0:
		var rotation_angle = get_rotation().y * 180/PI
		var velocity_angle = Vector2(get_velocity().x, get_velocity().z).angle_to(Vector2(1,0)) * 180/PI
		#print(rotation_angle, "   ", velocity_angle)
		#print(abs(rotation_angle) - abs(velocity_angle))


	if Input.is_action_just_pressed("e"):
		$lil_goober_enhanced/AnimationPlayer.play("die")
	
	if Input.is_action_just_pressed("q"):
		$lil_goober_enhanced/AnimationPlayer.play("Hello")

	
	move_and_slide()
	
	# Handle shoot and shoot input
	if Input.is_action_pressed("LMB"):
		equipedItem.shoot()
		


func look_at_cursor():
	var target_plane_mouse = Plane(Vector3(0,1,0), position.y)
	var ray_length = 1000
	var mouse_position = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * ray_length
	var cursor_position_on_plane = target_plane_mouse.intersects_ray(from,to)
	
	var new_rotation = 0
	if cursor_position_on_plane:
		new_rotation = -Vector2(position.x,position.z).angle_to_point(Vector2(cursor_position_on_plane.x,cursor_position_on_plane.z))
		
	set_rotation(Vector3(0,new_rotation,0))

func apply_damage(amount: float):
	health -= amount
	$AudioStreamPlayer.play(0)
	if health <= 0:
		$lil_goober_enhanced/AnimationPlayer.play("die")
