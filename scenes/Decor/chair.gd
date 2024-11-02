class_name chair
extends Area2D

var claimed_customer: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func claim_chair(customer: CharacterBody2D):
	claimed_customer = customer
	add_to_group("claimed_chairs")
	remove_from_group("unclaimed_chairs")


func _on_body_entered(body):
	if body == claimed_customer:
		body.sit($SitLocation.global_position)
