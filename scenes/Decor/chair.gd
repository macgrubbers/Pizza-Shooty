extends Area2D

var is_sat_in: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("customer"):
		body.sit($SitLocation.global_position)
		is_sat_in = true
