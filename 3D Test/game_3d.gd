extends Node3D

@onready var player: CharacterBody3D = $Player3d
@onready var camera: Camera3D = $Camera3D
@onready var enemy = preload("res://3D Test/Enemy3D.tscn")

# Camera specific
var player_camera_angle: Vector3 = Vector3(-75 * PI/180, -90 * PI/180, 0 * PI/180)
var player_camera_distance: float = 10
var player_camera_position: Vector3 = Vector3(-cos(player_camera_angle.x),-sin(player_camera_angle.x), 0) * player_camera_distance
#var new_camera_angle: float
var camera_rotation_rate: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	#new_camera_angle = camera.get_rotation().y
	camera.set_rotation(player_camera_angle)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	pass
	
	'''
	# Used for camera rotaitons, disabling for now
	var rotate_camera_direction = 0
	if Input.is_action_just_pressed("q"):
		set_camera_rotation(-1)
	if Input.is_action_just_pressed("e"):
		set_camera_rotation(1)
	'''
		
	update_camera()
	
	# Temporary, spawn enemies on this button press
	if Input.is_action_just_pressed("p"):
		spawn_enemies()
'''
func set_camera_rotation(direction: int)->void:
	new_camera_angle += PI/2 * direction
'''
	
func update_camera()->void:
	'''
	# camera.rotation.y = move_toward(camera.get_rotation().y, new_camera_angle, camera_rotation_rate)
	# var camera_rotation = camera.get_rotation()
	# var new_camera_pos = Vector3(sin(camera_rotation.y) , 1, cos(camera_rotation.y)) * camera_distance + player.get_global_position()
	'''
	var new_camera_pos = player_camera_position + player.get_global_position()
	camera.set_position(new_camera_pos)

func spawn_enemies():
	var new_enemy = enemy.instantiate()
	new_enemy.set_position(Vector3(0,1,20))
	add_child(new_enemy)
	new_enemy.actor_setup($Player3d)
	
