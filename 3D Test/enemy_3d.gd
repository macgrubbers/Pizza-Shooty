extends CharacterBody3D

var health = 100
var range = 3
var player: CharacterBody3D
@onready var raycast: RayCast3D = $RayCast3D

const SPEED = 3.5

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D


func actor_setup(_player):
	player = _player
	

func _physics_process(delta):
	if health <= 0:
		queue_free()
	
	if player:
		var player_position = player.get_global_position()
		nav_agent.set_target_position(player_position)
		var current_agent_position: Vector3 = global_position
		var next_path_position = nav_agent.get_next_path_position()

		velocity = current_agent_position.direction_to(next_path_position) * SPEED
		move_and_slide()
				
		look_at(player_position)
		rotation.x = 0
		rotation.z = 0
		
		
		if (get_position().distance_to(player_position) <= range):
			attack(player_position)
		else:
			raycast.set_target_position(raycast.get_position())
		

func attack(player_pos: Vector3):
	var ray_destination = get_position().direction_to(player_pos)
	var target = cast_ray(ray_destination * range)
	if target:
		$AnimationPlayer.play("attack")
	
func take_damage(amount: float):
	health -= amount
	if health <= 0:
		print("kill")
		queue_free()

func cast_ray(destination: Vector3):
	raycast.rotation = -rotation
	raycast.set_target_position(destination)
	var collider = raycast.get_collider()
	if collider:
		return collider.get_parent()
	else:
		return null
