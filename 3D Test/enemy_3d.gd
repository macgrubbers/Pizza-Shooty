extends CharacterBody3D

var health = 100
var range = 2
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
		
		if (get_position().distance_to(player_position) <= range):
			attack(player_position)
		

func attack(player_pos: Vector3):
	print("attack!")
	raycast.set_target_position(player_pos.normalized())
	
func take_damage(amount: float):
	health -= amount
	
	if health <= 0:
		print("kill")
		queue_free()
	
