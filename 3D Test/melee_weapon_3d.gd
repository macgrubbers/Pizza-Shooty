extends Node3D

@onready var parent = get_parent()
var damage = 30
var knockback_amount = 13

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body != parent and not body.is_in_group("walls"):
		var knockback_direction = -(get_global_position() - body.get_global_position()).normalized()
		knockback_direction.y = 0
		body.apply_damage(damage, knockback_direction * knockback_amount)
		print("stabby")
