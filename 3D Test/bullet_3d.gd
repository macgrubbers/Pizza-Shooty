extends RigidBody3D

var speed = 50
var damage: float = 50.0
var knockback = 10
var velocity: Vector3

func fire(new_pos, new_rot):
	set_position(new_pos)
	set_rotation(new_rot)
	set_linear_velocity(Vector3(cos(get_rotation().y), 0, -sin(get_rotation().y)) * speed)


func _on_body_entered(body):
	if body.is_in_group("walls"):
		pass
	if body.is_in_group("enemies"):
		body.take_damage(damage)
		
	queue_free()

	# Spawn particles here
