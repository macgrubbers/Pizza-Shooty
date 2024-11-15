extends StaticBody3D

var speed = 50
var damage: float = 50
var knockback_amount = 5
var velocity: Vector3


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collision_object = collision.get_collider()
		if collision_object != self and  not collision_object.is_in_group("walls"):
			var knockback_direction = collision.get_normal() + velocity.normalized()
			knockback_direction.y = 0
			collision_object.apply_damage(damage,knockback_direction * knockback_amount)
			print("damage time")
		else:
			print("nada")
			# do nothing!
			pass
		queue_free()

func fire(new_pos, new_rot):
	set_position(new_pos)
	set_rotation(new_rot)
	velocity = Vector3(cos(get_rotation().y), 0, -sin(get_rotation().y)) * speed
