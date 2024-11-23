class_name Enemy
extends PizzaCharacter3D

var range = 3

@onready var raycast: RayCast3D = $RayCast3D
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

@onready var stm = $StateMachine
@onready var tracker = $Tracker

func _ready():
	super()
	invulnerability_time = 0.2
	var health = 75


func _physics_process(delta):
	super(delta)


func attack(player_pos: Vector3):
	var ray_destination = get_position().direction_to(player_pos)
	var target = cast_ray(ray_destination * range)
	if target:
		$AnimationPlayer.play("attack")


func die():
	queue_free()


func cast_ray(destination: Vector3):
	raycast.rotation = -rotation
	raycast.set_target_position(destination)
	var collider = raycast.get_collider()
	if collider:
		return collider.get_parent()
	else:
		return null
