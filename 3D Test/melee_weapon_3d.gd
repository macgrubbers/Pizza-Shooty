extends Node3D

@onready var parent = get_parent()
var damage = 30
var knockback = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body != parent:
		body.apply_damage(damage)
		print("stabby")
