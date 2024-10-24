class_name baseBullet
extends Area2D

@export var speed: float = 1400.0
@export var damage: int = 30

@onready var bullet_particle = preload("res://scenes/bullet_particle.tscn")
@onready var bullet_hit_sound = preload("res://scenes/bullet_hit_sound.tscn")

func _physics_process(delta):
	position += transform.x * speed * delta

func setup(trans: Transform2D, parentLayer: int):
	set_collision_mask_value(parentLayer,false)
	transform = trans

func _on_body_entered(body):
	print(body)
	if body.is_in_group("enemy"):
		body.get_hit(damage, global_transform)
	
	if body.is_in_group("customer"):
		body.get_hit(damage, global_transform)
		
	var bullet_effect = bullet_particle.instantiate()
	get_tree().root.add_child(bullet_effect)
	bullet_effect.setup(global_transform)
	var bullet_hit_player = bullet_hit_sound.instantiate()
	get_tree().root.add_child(bullet_hit_player)
	bullet_hit_player.play()
	queue_free()
