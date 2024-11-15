extends PizzaCharacter3D


const JUMP_VELOCITY = 4.5

@onready var equipedItem = $Gun3D
@onready var camera = get_parent().get_node("Camera3D")


func _ready():
	super()
	health = 100
	SPEED = 5
	knockback_restore_rate = 0.2
	invulnerability_time = 0.7

func _physics_process(delta):
	if health <= 0:
		return
	look_at_cursor()
	

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

	

	
	# Handle shoot and shoot input
	if Input.is_action_pressed("LMB"):
		equipedItem.shoot()
		
	super(delta)
		


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

func apply_damage(amount: float, knockback_amount: Vector3):
	if not is_invulernable:
		$lil_goober_enhanced/Armature/Skeleton3D/Vert.get_active_material(0).set_albedo(Color(1,0,0))
	super(amount, knockback_amount)

func die():
	$lil_goober_enhanced/AnimationPlayer.play("die")

func _on_invulernability_timer_timeout():
	invulnerability_timer.stop()
	is_invulernable = false
	$lil_goober_enhanced/Armature/Skeleton3D/Vert.get_active_material(0).set_albedo(Color(1,1,1))

func handle_animation():
	var player_rotation = get_rotation().y
	var player_velocity = velocity.angle_to(Vector3(1,0,0))
	
	if player_velocity != 0:
		if abs(abs(cos(player_rotation)) - abs(cos(player_velocity))) < 0.5:
			$lil_goober_enhanced/AnimationPlayer.play("Run")
		elif abs(cos(player_rotation) - cos(player_velocity)) > 1:
			$lil_goober_enhanced/AnimationPlayer.play("strafe_right")
		elif abs(cos(player_rotation) - cos(player_velocity)) < 1:
			$lil_goober_enhanced/AnimationPlayer.play("strafe_left")

	if Input.is_action_just_pressed("e"):
		$lil_goober_enhanced/AnimationPlayer.play("Hello")
	
